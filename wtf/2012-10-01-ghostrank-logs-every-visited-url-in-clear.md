---
title: Ghostrank logs every visited URL in clear
---

While debugging a rather strange encoding problem on
[Defora](https://defora.org), I fired up [Tamper-
Data](https://addons.mozilla.org/en-US/firefox/addon/tamper-data/) to have a
clean log of the ongoing requests. Doing this, I also noticed that another
add-on I use, namely [Ghostery](https://www.ghostery.com/), was sending every
page URI to their HTTP API. No big deal here, since this is part of the
Ghostrank feature, and AFAIK you have to opt-in to activate it:

> GhostRank sends anonymous statistical information about the trackers, ads,
and other scripts that Ghostery encounters and the pages on which they're
found. It does not make use of browser cookies or flash cookies and stores no
unique information about the user (not even an IP address).

>

> Ghostery uses this information to create panel data about the proliferation
of these scripts and shares this data with the Ghostery community, companies
interested in measuring their own activity and compliance with privacy
standards across the web, and organizations dedicated to holding these
companies accountable. GhostRank data is not used to target advertising and is
never shared for that purpose. For more details on exactly what GhostRank
collects, please visit our [FAQ](http://www.ghostery.com/faq).

>

> By participating in GhostRank, you're agreeing to become part of this
anonymous panel and you're helping to support Ghostery as you browse the web.

Ghostery's great, I've been using it for a while, and Ghostrank looks innocent
enough to activate it: I mean, it's a small waste of bandwidth compared to
loading a handful of social buttons to Twitbook+. However Ghostery logs in
plain HTTP every visited URL (be it through HTTP or HTTPS). This is rather
unwelcome when you're accessing sites that are proposing HTTPS in an effort to
protect your privacy.

HTTPS is a minimum when you're trying to collect _anonymous_ data. What's more
annoying here is that they do use HTTPS to send filter-updates, or load their
main home page, but not to log your private data. So... meh.

Sample Ghostrank API call logged here for the curious.

    
    
      
    GET http://l.ghostery.com/api/page/?d=www.defora.org%2F(...)
      
       Request Headers:
      
          Host[l.ghostery.com]
      
          User-Agent[Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20100101 Firefox/16.0]
      
          Accept[text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8]
      
          Accept-Language[en-US,en;q=0.5]
      
          Accept-Encoding[gzip, deflate]
      
          DNT[1]
      
          Connection[keep-alive]
      
       Response Headers:
      
    (...)
      
    

Rant over. :)

