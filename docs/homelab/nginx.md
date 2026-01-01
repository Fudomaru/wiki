---
title: NGINX
description: The gateway to my lab, and my first lesson in structured routing.
---

# NGINX Reverse Proxy

Nginx is the front door to my entire homelab. 
It started as a simple experiment to expose a single service 
without revealing an IP address and port, 
but it quickly became one of the most critical components in my infrastructure. 
It acts as the central gateway, 
directing traffic cleanly and providing a layer of isolation 
between the outside world and my internal services.

It enforces a critical design principle for me: 
backend services should never have to know they are on the internet. 
They just run, and Nginx handles the rest.

---

## Purpose and Design

In any real network, you don't just expose services directly. 
You put a proxy in front. 
I wanted to replicate that discipline here.

The purpose of my Nginx setup is to:
- **Act as a single ingress point:** All web traffic enters through this one container.
- **Route traffic with hostnames:** Instead of messy IPs and ports, I can use clean subdomains like 'gitea.voidex.me'.
- **Terminate connections:** It handles the initial HTTP request, so backend services don't have to.
- **Isolate my services:** No service needs a public-facing IP address. They all live safely on an internal network.

The architecture is straightforward:
1. A dedicated LXC container runs Nginx on Debian.
2. My DNS (Pi-hole) points all my subdomains to the Nginx container's IP.
3. Nginx reads the 'Host' header of the incoming request.
4. It forwards the request to the correct internal service (e.g., Gitea, Paperless) based on that hostname.

This keeps the setup predictable and easy to manage.

---

## Setup and Configuration

I created a standard Debian LXC container to house Nginx. 
The installation itself was simple (`apt install nginx`), 
but the real work is in the configuration.

My philosophy is to keep the global `/etc/nginx/nginx.conf` 
as close to the default as possible. 
This makes it predictable. 
The only change I made was adding `server_tokens off;` 
to prevent Nginx from advertising its version number.

All the routing logic lives in individual configuration files 
inside `/etc/nginx/sites-available/`, 
which are then symlinked into `/etc/nginx/sites-enabled/`.

#### The Default Server: A Critical Defense

One of the first lessons I learned was the danger of accidental exposure. What happens if a request comes in for a hostname Nginx doesn't recognize? To prevent it from forwarding the request to a default backend, I implemented a catch-all server block that simply drops the connection.

```
server {
    listen 80 default_server;
    server_name _;
    return 444; # Drops the connection without a response
}
```

This is a vital security measure. It ensures that only explicitly defined services are accessible.

#### The Proxy Template

To keep things consistent, every backend service uses the same proxy template. This ensures that the backend services get the information they need about the original request.

```nginx
server {
    listen 80;
    server_name service.voidex.me;

    location / {
        proxy_pass http://10.0.0.X:PORT;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
These headers are not just boilerplate. 
They are essential for applications to work correctly behind a proxy, 
especially for logging real client IPs and generating correct redirect URLs.

---

## Lessons Learned

Setting up Nginx was a deep dive into how web traffic actually flows. 
It was less about the tool itself and more about the protocols it manages.

- **A Proxy is a Gatekeeper and a Translator:** 
Nginx isn't just passing traffic. 
It's rewriting parts of it (like the headers) so the backend application isn't confused. 
The `X-Forwarded-For` header was my first real lesson in this; 
without it, all my application logs just showed Nginx's IP address.
- **Defense in Depth Starts Here:** 
The `default_server` config was a major insight. 
It's a simple rule that prevents a whole class of potential security issues. 
It taught me to think defensively, even at the routing layer.
- **Discipline over Complexity:** 
It's tempting to put all sorts of logic into Nginx (authentication, complex rewrites). 
I’ve learned to resist that. 
Keeping Nginx as a pure routing layer makes the entire system easier to debug. 
If there's an application problem, it's likely in the application, 
not hidden in some obscure Nginx rule.

---

## Future Plans

Right now, my Nginx setup handles HTTP only and is not exposed directly to the internet. 
The next steps are about hardening and expanding its capabilities.

- **TLS Termination:** 
While my external access is handled by a Cloudflare Tunnel, 
I plan to learn how to manage TLS certificates directly on Nginx using Let's Encrypt. 
This is a fundamental skill.
- **Centralized Logging:** 
Nginx access logs are a goldmine of data. 
I want to ship them to a central logging server (like Graylog or an ELK stack) 
to monitor traffic patterns and potential security events.
- **Authentication Layer:** 
For some internal services, 
I want to add an authentication layer directly at the proxy level, 
using something like `authelia` or `oauth2-proxy`.

---

## Value in My Lab

Nginx is more than just a proxy. 
It’s a control point. 
It forces me to be intentional about my network architecture. 
By sitting in the middle of everything, 
it provides a perfect vantage point for monitoring, security, and traffic management.

It taught me that a well-configured boundary 
is the first step toward a secure and scalable system. 
It's an intentionally "boring" but stable foundation 
upon which I can build more complex services.

