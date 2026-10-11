---
title: "Building a Multi-Threaded Download Manager: TCP Sockets, Range Headers, and Concurrency"
description: "Why do single-connection downloads crawl on high-bandwidth networks? Here is how to build a high-performance multi-threaded download manager in Python using HTTP Range headers, sparse file pre-allocation, and thread-safe chunk writing."
date: 2026-10-09 10:00:00 +0600
categories: [programming, python]
tags: [python, networking, concurrency, tcp, sockets, download manager, performance]
pin: false
math: false
mermaid: false
published: true
image:
  path: /assets/images/2026-10-09-building-a-multi-threaded-download-manager-in-python/banner.webp
  lqip: data:image/webp;base64,UklGRlgAAABXRUJQVlA4IEwAAADwAwCdASoUAAsAP1WSwFYxqiajsAgCMCqJYgCdAB6JMVIkQRf0bJsAANnEALYmLIEvXbE88V916Yzo7Dq4EhRC6urMATrKkoxOsAAA
  alt: Dark IDE showing high-performance asynchronous networking code
---

Have you ever wondered why downloading a multi-gigabyte ISO or game archive through your browser often tops out at a fraction of your internet speed, while classic download accelerators easily saturate your entire Gigabit connection?

When I built [Bengal Download Manager](https://github.com/tazihad/bengal-download-manager), a multi-threaded desktop download utility, I wanted to understand the low-level network mechanics that govern throughput, socket exhaustion, and disk I/O.

Here is a breakdown of why single-stream downloads leave bandwidth on the table, and how to construct a robust, resumable, multi-connection download engine from scratch.

---

## The Network Problem: Bandwidth-Delay Product (BDP)

A single TCP connection does not immediately send data at maximum network line rate. It relies on **TCP Congestion Control** algorithms (like Cubic or BBR) which start with a small congestion window (**TCP Slow Start**) and scale up gradually until packet loss occurs.

Over high-latency links or connections with moderate packet loss, a single TCP stream is fundamentally constrained by the **Bandwidth-Delay Product (BDP)**:

$$\text{BDP} = \text{Bandwidth} \times \text{Round-Trip Time (RTT)}$$

If the TCP receive window size or server-side socket buffer is smaller than the BDP, the sender spends idle time waiting for packet acknowledgments (`ACK`s), causing the pipeline to starve.

By opening **multiple parallel TCP connections**—each requesting a non-overlapping slice of the file—you bypass the per-connection window bottleneck, multiply your aggregate TCP buffer capacity, and achieve line-rate saturation.

---

## 1. Probing the Server: Capabilities and Size

Before launching multiple download workers, the client must verify that the remote HTTP server supports partial content requests. This is done via an HTTP `HEAD` request:

```python
import requests

def probe_url(url: str):
    headers = {"User-Agent": "BengalDownloadManager/1.0"}
    response = requests.head(url, headers=headers, allow_redirects=True)
    
    accept_ranges = response.headers.get("Accept-Ranges", "").lower()
    content_length = response.headers.get("Content-Length")
    
    can_parallelize = accept_ranges == "bytes" and content_length is not None
    total_size = int(content_length) if content_length else None
    
    return can_parallelize, total_size
```

If the server returns `Accept-Ranges: bytes` and a valid `Content-Length`, we can safely partition the file. If not, the manager must fall back to a standard single-stream sequential download.

---

## 2. Partitioning Byte Ranges

Suppose we want to download an 800 MB file across 8 worker threads. We calculate start and end byte offsets for each chunk:

```python
def calculate_chunks(total_bytes: int, num_workers: int = 8):
    chunk_size = total_bytes // num_workers
    ranges = []
    
    for i in range(num_workers):
        start = i * chunk_size
        # The final chunk takes any remainder bytes
        end = total_bytes - 1 if i == num_workers - 1 else (start + chunk_size - 1)
        ranges.append((i, start, end))
        
    return ranges
```

For worker 0, the HTTP request header will look like:

```http
GET /linux-distro.iso HTTP/1.1
Host: mirrors.example.org
Range: bytes=0-104857599
```

The server should respond with status **`206 Partial Content`**.

---

## 3. Fast Sparse File Pre-Allocation

A common pitfall in naive download managers is downloading individual parts into separate temporary files (`part0.tmp`, `part1.tmp`) and stitching them together at the end. For large files, merging 8 temporary files forces the OS to read and write hundreds of gigabytes of duplicate disk sectors, pinning your disk queue to 100%.

The professional approach is to **pre-allocate a single sparse target file** on disk before downloading begins:

```python
import os

def preallocate_file(filepath: str, total_bytes: int):
    with open(filepath, "wb") as f:
        # Fast allocation without writing zeroes across the whole drive
        f.seek(total_bytes - 1)
        f.write(b"\0")
        f.flush()
```

On Linux filesystems (ext4, XFS, Btrfs), you can also use `posix_fallocate()` for atomic allocation without disk fragmentation:

```python
import os

with open(filepath, "wb") as f:
    os.posix_fallocate(f.fileno(), 0, total_bytes)
```

---

## 4. Concurrency and Thread-Safe Chunk Writing

Each worker thread connects, opens the pre-allocated file independently, seeks to its assigned offset (`start`), and writes incoming network stream buffers in 64 KB chunks:

```python
import os
import requests
from concurrent.futures import ThreadPoolExecutor

CHUNK_BUFFER_SIZE = 64 * 1024 # 64 KB socket buffer

def download_part(url: str, filepath: str, part_id: int, start: int, end: int):
    headers = {"Range": f"bytes={start}-{end}"}
    
    # stream=True prevents buffering entire chunk in RAM
    with requests.get(url, headers=headers, stream=True, timeout=15) as r:
        r.raise_for_status()
        
        # Open file in read-write binary mode ('r+b')
        with open(filepath, "r+b") as f:
            f.seek(start)
            current_pos = start
            
            for chunk in r.iter_content(chunk_size=CHUNK_BUFFER_SIZE):
                if chunk:
                    f.write(chunk)
                    current_pos += len(chunk)
                    
    print(f"Part {part_id} finished: {start} to {end}")
```

Because each thread writes to a **mutually exclusive byte range**, there is zero lock contention or file corruption!

---

## 5. Resuming Interrupted Downloads

What happens if your connection drops mid-download?

A production download manager maintains a small JSON or SQLite state file (`.bengal.state`) tracking the highest downloaded byte position for each worker:

```json
{
  "total_bytes": 838860800,
  "parts": [
    {"id": 0, "start": 0, "current": 45120300, "end": 104857599},
    {"id": 1, "start": 104857600, "current": 89230100, "end": 209715199}
  ]
}
```

Upon resuming:
1. Load `part["current"]`.
2. Construct the resume header: `Range: bytes={current}-{end}`.
3. Seek to `current` in the destination file and continue writing.
4. Once all parts report `current == end`, delete the metadata file.

---

## Benchmarking Results

In real-world tests across transcontinental connections (e.g. Asia to US/Europe mirrors with 180ms latency):

* **Standard browser download (1 connection):** ~4.2 MB/s (TCP buffer bottlenecked)
* **Bengal Download Manager (8 parallel streams):** ~38.6 MB/s (Line rate saturated)

That is an over **9x speedup** on the exact same physical network connection, achieved purely by optimizing how the application interacts with the TCP stack and filesystem.
