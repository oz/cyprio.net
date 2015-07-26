---
title: A simple VPN tunnel with FreeBSD
---

I live in Mexico, but work for a [french tech company][af83].  As I spend most
of my days online, and can't always encrypt everything, I often use a VPN.  This
is especially important when working from an untrusted network (my favorite
coffee dealer's public wifi comes to mind), although I tend *not* to trust any
network these days...

I had been (ab) using the company's own VPN for personal communications for a
while, and I'd rather not, so I took some time so setup OpenVPN on a modest
[Kimsufi][kimsufi] box, to finally get my private VPN. Whether you trust OVH's
network is a personal matter, but still, I believe it safer that a random wifi
hotspot.

This post highlights the few required steps, to setup your OpenVPN server on
FreeBSD (release 10 at the time of this writing).  The goal is to:

  - setup a VPN on a dedicated host,
  - use RSA certificates to authenticate server and clients,
  - use a shared secret on top of it all to mitigate potential DoS attacks,
  - use Diffie-Hellman for key exchange,
  - route *all* client traffic through the VPN once the tunnel is up.

# Installing and configuring OpenVPN

Start by installing the relevant FreeBSD port: using pkg-ng, it's a simple `pkg
install openvpn`. If you'd rather use ports, chances are you know what to do.

You will have to enable the daemon in your `rc.conf`:

```
echo 'openvpn_enable="YES"' >> /etc/rc.conf'
```

## Certificates

Here, I could write a bunch of openssl incantations to generate a CA, server keys,
signing requests, etc. Well no, I'm too lazy, and using the `easy-rsa` package
will probably save *you* some time too: `pkg install easy-rsa`.

This should have created a `/usr/local/share/easy-rsa/`, which contains a few
shell scripts to handle server and client certificates generation simply. Once
this package is installed, it is recommended that you copy the script directory
elsewhere, as you will need to customize it, and future package upgrades may
overwrite your changes.

In this example, I will copy easy-rsa's scripts to OpenVPN's configuration
directory:

```
mkdir -p /usr/local/etc/openvpn
cp -vr /usr/local/share/easy-rsa /usr/local/etc/openvpn/
export EASY=/usr/local/etc/openvpn/easy-rsa
```

That should settle it, now `cd $EASY` and edit the `vars` file in there, in
order to fit the following variables to your particular environment:

 - `KEY_COUNTRY`,
 - `KEY_PROVINCE`,
 - `KEY_CITY`,
 - `KEY_ORG`,
 - `KEY_EMAIL`,
 - `KEY_CN`: CN stands for "Common Name" and *must* match your server's
   hostname,
 - `KEY_NAME`,
 - `KEY_OU`,
 - and set `KEY_SIZE` to at least 2048.

Then, source this file with `. vars`, and we will start generating your
certificates.

Let's start by cleaning the `keys` directory:

```
./clean-all
```

Then, we will build your local CA. This step will require that you confirm some
of the values you updated earlier in the `vars` file:

```
./build-ca
```

You also need a certificate and key for your server. The `build-key-server`
script is used to handle that part.  It takes one parameter that *should* match
your server's common name ; although, unless you are using a commercial CA to
sign your server keys, it is not *that* important: leaving `server` is fine
here.

```
./build-key-server server
```

Finally, generate Diffie-Hellman parameters:

```
./build-dh
```

This can take a some time depending on your hardware. Coffee break? :)

## Using TLS-Auth

TLS-Auth is a small security improvement that signs (HMAC) SSL/TLS handshake
packets with a shared key. It does not cost much, and improves security a
little (e.g. it allows OpenVPN to drop weird packets before they reach your
super trusty SSL implementation).

However, being a shared secret, you need to distribute the file to all your
clients.

```
openvpn --genkey --secret $EASY/keys/ta.key
```

## Client certificates

To connect to your OpenVPN server, your clients will need to be authenticate
with signed certificates themselves. To generate new client certificates, use
the `build-key` script:

```
./build-key laptop
```

To connect to your VPN server, you will need to *securely* transmit these files
to your client:

 - The client's certificate and private key:
    - `$EASY/keys/laptop.crt`
    - `$EASY/keys/laptop.key`
 - and the server's certificate and private TLS Authentication key:
    - `$EASY/keys/ca.crt`
    - `$EASY/keys/ta.key`

## Server configuration

Here is a sample one. Update it to fit your environment, and store it under
`/usr/local/etc/openvpn/openvpn.conf`. Be smart. :)

```
local $SERVER_IP
port 1194
proto udp
dev tun
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
# Allow clients to "see" each other.
client-to-client
keepalive 10 120
comp-lzo
max-clients 16
user nobody
group nobody
persist-key
persist-tun

cipher AES-256-CBC
ca $EASY/ca.crt
cert $EASY/server.crt
key $EASY/server.key
dh $EASY/dh2048.pem
tls-auth $EASY/ta.key 0

status /usr/local/etc/openvpn/openvpn-status.log
verb 4
mute 20
mute-replay-warnings

# Uncomment the following if you're running a local DNS cache (such as unbound),
# and want to instruct your clients to use it. In that case, don't forget to
# update Unbound configuration too, to accept requests on the 10.8.0.0/24 
# network.
#push "dhcp-option DNS 10.8.0.1"
push "redirect-gateway"
push "redirect-gateway def1 bypass-dhcp"
```

You should be set. Start the OpenVPN service with `service openvpn start`.

# Routing and NAT

Chances are your server is not configured to do any routing at all. Maybe it was
meant to be a simple server, rather than a router. In that case, enable the
"gateway" pseudo-service in `/etc/rc.conf`:

```
echo 'gateway_enable="YES"' >> /etc/rc.conf
```

And activate the following sysctl flag:

```
sysctl net.inet.ip.forwarding=1
```

Update PF's configuration by adding a few lines to `/etc/pf.conf`, in order to
NAT OpenVPN's `tun` interface to the rest of the world:

```
# The ext_if name is probably different on your system...
ext_if = "em0"
vpn_if = "tun0"
vpn_net = "10.8.0.0/24"

nat on ! $vpn_if from $vpn_net to any -> ($ext_if)
```

Then, restart PF: `/etc/rc.d pf restart`.

And that should be it for your server: it is running, accepting authenticated
clients, and clients' connections are NAT-ed to the outer network.


# Sample client setup

Alright, if you have no clue on how to setup a client, this is the OpenVPN
configuration I use on a laptop:

```
dev tun
remote $SERVER_IP 1194
client
tls-client
verify-x509-name server name
ns-cert-type server
tls-auth ta.key 1
ca ca.crt
cert laptop.crt
key laptop.key
cipher AES-256-CBC
comp-lzo
ping-timer-rem
resolv-retry infinite
persist-tun
persist-key
verb 1
ping 15
ping-restart 30
```

And that's about all you need. Simple enough. :)

[af83]: http://af83.com/
[kimsufi]: http://www.kimsufi.com/fr/
