---
title: "xlockmore on squeeze / testing"
---

(Sorry, writing it down is the best way I know to remember it.)

I've been using Debian for some years now. While the alternatives like Ubuntu
seem easier to a lot of people, I can't help but prefer Debian for its
idealistic views on software, and freedom ; which sometimes beat practicality
to the ground, but let us dream.

So, if you've been using Debian's squeeze (aka as testing for now), you may
have noticed that the xlockmore package is not available (for very good
reasons IIRC, do your googling-homework). However the software is present in
the unstable branch, and you can easily build the package from unstable for
your testing playground. Note that this method is _unsafe_, as you won't get
any automatic update of the "custom" package...

First, grab the [source tarball from
unstable](http://packages.debian.org/sid/xlockmore).

Un-compress the archive:  

    
    
    tar zxvf xlockmore_5.31-1.tar.gz

Build the package:  

    
    
      
        cd xlockmore_5.31-1
      
        dpkg-buildpackage
      
        # This should take a little time
      
    

If the dpkg-buildpackage command complains about missing build dependencies,
just install them and restart the dpkg-buildpackage command after (did I even
need to mention that?).

There, you have your package:  

    
    
      
        cd ..
      
        ls xlock*.deb
      
        # if you on amd64, you should get:
      
        # xlockmore_5.31-1_amd64.deb  xlockmore-gl_5.31-1_amd64.deb
      
    

Install one, or both of them. For example on amd64...:  

    
    
    sudo dpkg -i xlockmore_5.31-1_amd64.deb

You're done.

