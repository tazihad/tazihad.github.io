---
title: Tensorflow and PyTorch Setup Guide with CUDA
description: Learn how to set up TensorFlow and PyTorch with CUDA for GPU-accelerated machine learning and deep learning on your system.
date: 2025-04-14 16:33:00 +0600
categories: [deep-learning]
tags: [drafts, deep-learning, machine-learning, pytorch]
pin: false # pin post
math: false # math latex syntax
mermaid: false # diagram & visualizations
published: false # publish post
image:
  path: # 16:9 image
  lqip: 
  alt: # A description of the image
---

Befor we continue we have to make sure what is the latest python version for [supported Tensorflow](https://www.tensorflow.org/install/pip#software_requirements).

For me it is `Python 3.9–3.12`.

Now we have to install tensorflow and pytorch. We can install all of these using python. It's better we install python environment so that we don't pollute our system.
There are many ways to create python environment. But we are going to use `conda`.

We are going to install miniconda and start from there. Go to miniconda [website and download](https://www.anaconda.com/docs/getting-started/miniconda/install#macos-linux-installation).

Make sure to install miniconda in a location where you have enough storage. Our directory will become big overtime.

```bash
curl -o ~/Downloads/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x ~/Downloads/miniconda.sh
bash ~/Downloads/miniconda3/miniconda.sh
```

We have to check inf conda is available in terminal.

```bash
conda --version
```

If it's available create python environment. Since Latest tersorflow supported python version is 3.12 as of now.
We create:
```bash
conda create -n ml-env python=3.12 -y
```
Then activate it:
```bash
conda activate ml-env
```

Check where conda env is located:
```bash
conda env list
```

Now install Jupyter Notebook inside conda environment.
```sh
conda install notebook -c conda-forge -y
```
> conda-forge is community driven channel. notebook just contain basic jupyterlab. install jupyterlab for full package.

If you have NVIDIA gpu. Make sure to install CUDA drivers from NVIDIA website.
```bash
conda install tensorflow-gpu -c conda-forge -y
conda install pytorch-cuda -c pytorch -y
```














