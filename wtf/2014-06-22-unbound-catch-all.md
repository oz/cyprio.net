---
title: Unbound catch-alls
---

I have been using [Unbound][] as a local DNS cache for a little while
now. It's a fine piece of software and I can only recommend it if you
need (or want) to run a DNS on your laptop/device. I *think* that the
latest versions of Ubuntu are configured to use [dnsmasq][] by default,
so I guess this is of little interest for you guys.

# Why would you use a local DNS cache?

Well, if you are at home, using your router's DNS you probably do not need to:
because the device is already doing the caching for you, and your home network
is probably never under a lot of load. However, on the road, while using random
joe's wifi, it does help speed up name resolution.

For example, this request is not cached, and very slow (Mexico's airport, yay),
and took 2.981s to complete:

```
$ time host cyprio.net
cyprio.net has address 91.121.147.65
(...)
host cyprio.net  0.00s user 0.00s system 4% cpu 2.981 total
$
```

The next call only takes a fraction of the time as it does not need to connect
to a french DNS anymore, or wait for the saturated AP's cache:

```
$ time host cyprio.net
cyprio.net has address 91.121.147.65
(...)
host cyprio.net  0.00s user 0.00s system 88% cpu 0.007 total
```

Having a local DNS also allows a few tricks such as domain blacklisting, custom
TLDs, etc. Anyway, my $work laptop is a Macbook Air, usually running Apple's
latest stable version, whatever that is. However, it does not come with
Unbound, but the easiest way to remedy that error is to install it with [brew]:

```
brew install unbound
```

I will just point you to [this excellent installation
guide][unbound-install], rather than copy most of it here.

# Catch-all

If your work involves building web things (pages, sites, applications,
you name it), you are probably used to configure virtual hosts in Apache
or Nginx, and then add another line to `/etc/resolv.conf`, each time.
You know it is a crappy way of doing things. Why not use that little DNS
you run locally?

After searching 5 minutes with the [Duck], and the Google, I could not find a
clear method to configure Unbound for this job. It is really simple though. All
you have to do is add a stub zone for a custom TLD, for example "dev":

```
stub-zone:
    name: "dev"
    stub-addr: 127.0.0.1
```

Unbound will then try to resolve ".dev" domains using the DNS server
running on localhost. Hence, you also need to add a catch-all local zone
matching the "dev" domain, that will always resolve to the loop-back
address:

```
server:
    # ... your stuff
    local-zone: "dev." redirect
    local-data: "dev. 10800 IN A 127.0.0.1"
```

Restart Unbound, and you are all set.

```
$ host whatever.dev
whatever.dev has address 127.0.0.1
$ host blabla.dev
blabla.dev has address 127.0.0.1
```

And now, back to waiting for my flight...

[Unbound]: https://unbound.net/
[dnsmasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html
[unbound-install]: https://www.spatof.org/blog/unbound-dns-resolver-on-osx.html
[duck]: https://duckduckgo.com/
[brew]: http://brew.sh/
