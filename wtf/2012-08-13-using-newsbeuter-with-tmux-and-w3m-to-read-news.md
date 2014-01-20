---
title: Using newsbeuter with tmux and w3m to read news
---

I consume most news through RSS feeds. If you don't, this post is probably of
no interest to you.

Twitter's nice and all, but I can't stand the constant interruptions, and it
feels quite stupid to read all those super-real-time conversations hours after
the fact. I can't be bothered at the moment, plus [I'm
busy](http://www.randsinrepose.com/archives/2012/08/12/one_job.html). :)

Furthermore, I'm using a console program to read news, which is called
[newsbeuter](http://newsbeuter.org/). Call me old school if you want, I don't
mind. I've tried a bunch of other RSS readers: graphical, e-mail based, web
based, but I kept coming back to newsbeuter. YMMV, but it politely does its
job, lets you configure about every aspect of it, filter your feeds, etc. I
love it.

When I want to read an article, I often send it to an external browser in a
read-later kind of way, while I skim through other feeds. That's sspecially
true for [hacker-news](http://news.ycombinator.com) type feeds, where you're
only getting a link-feed. Generally, it can result in a few billion opened
tabs, of which I'll read a few million, which in turn can lead to more little
tab offsprings, _ad nauseam_. In the end, quite a lot of noise, or a simple
case of information overload. So, a few days ago, I decided I would try
another approach to _read less noise_, and get more sleep.

While running newsbeuter in [tmux](http://tmux.sourceforge.net) it is actually
very simple to split the virtual window to open interesting articles in a
pane. That means using a text-mode browser, no javascript/css, no "Send to
instapaper", or whatever. Just the text. I've been killing boring prose in
seconds for a week, so I guess it works for me.

Here how's you might do it. First, you'll add this line to your newsbeuter
config file:

    
    
    browser "~/bin/open-in-pane"

This configures newsbeuter so that the external browser is actually a little
(shell) script that you will find here:

    
    
      
    #!/bin/sh
    
    
    
    
    
    W3M='/usr/bin/w3m'
    
    
    
    
    
    # If the window has only one pane, create one by splitting.
      
    pane_count=`tmux list-panes -F '#{line}' | wc -l`
      
    if [ $pane_count -lt 2 ]; then
      
        tmux split-window -h
      
    fi
    
    
    
    
    
    # Start my reader if it ain't running already, and send it the URL to
      
    # open.
      
    w3m_process_count=`ps auxw | grep "$W3M" | grep -cv grep`
      
    if [ $w3m_process_count = '1' ];then
      
        tmux send-keys -t 1 "TU" "C-u" "$1
      
    "
      
        tmux select-pane -t 0
      
    else
      
        tmux send-keys -t 1 "$W3M \"$1\"
      
    "
      
        tmux select-pane -t 0
      
    fi
    
    
    
    
    
    # Done! :)
      
    

Save this to `~/bin/open-in-pane`, chmod+x it, and you should be set. I'm
using w3m's tab feature, but since it is very limited, I can't _abuse_ it.
Also, double-check the URLs you're opening, since this shell script does
absolutely no effort at preventing evil URLs from escaping. You've been
warned. :)

Hope this helps anyway.

