---
title: How to use Cloudflare Warp in Fedora Silverblue & Kinoite using Podman
categories: 
- linux
- silverblue
---

You can install Cloudflare WARP in Fedora silverblue by directly laying on the system. Or you can use podman cotainer to pass Cloudflare-warp network using proxy.  

```bash
podman run -d --name cloudflare-warp -p 127.0.0.1:1080:1080 -p 127.0.0.1:8080:8080 --restart unless-stopped amirdaaee/cloudflare-warp:latest
```  

Now we can use the network using any proxy client on browser or directly on system.  
We can use ProxyOmega client on browser to route our network in cloudflare-warp.  
ProxyOmega [Chrome](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif?hl=en), [Firefox](https://addons.mozilla.org/en-US/firefox/addon/switchyomega/).  

Now use any one of below proxy to route the network from inside browser.  
`socks5://127.0.0.1:1080`  
`http://127.0.0.1:8080`

We can start and stop the podman container anytime using:  
`podman start cloudflare-warp`  
`podman stop cloudflare-warp`  

If you want to access the cloudflare terminal or change license key. Use this:  
`podman exec cloudflare-warp warp-cli "--accept-tos" help`
