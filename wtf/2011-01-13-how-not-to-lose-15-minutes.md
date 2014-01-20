---
title: How not to lose 15 minutes
---

Another geeky one? Although it's light, this post deals with Apache, and PHP,
and htaccess files. So anyone with a brain, go away. You have been warned.

When setting up a vhost for Apache 2, under your homedir, the following thing
is explained very clearly in [the official
documentation](http://httpd.apache.org/docs/2.0/howto/htaccess.html):

> Further note that Apache must look for .htaccess files in all higher-level
directories, in order to have a full complement of directives that it must
apply. (See section on how directives are applied.) Thus, if a file is
requested out of a directory /www/htdocs/example, Apache must look for the
following files:

>  
>  
>     /.htaccess

>  
>     /www/.htaccess

>  
>     /www/htdocs/.htaccess

>  
>     /www/htdocs/example/.htaccess

>

>  

That is to say: when you setup an application under `$HOME/src/foo/bar/baz`,
and do not understand why (the fuck) Apache complains it can't read e.g. the
file `$HOME/src/.htaccess`, that's because of the quoted statement above. The
quickest fix is to just `chmod` your way up the parent directories so that
your web server user can at least _read_ them.

... Isn't that ugly? I guess for a laptop/dev env it's okay-ish. Although, I
should probably remove the htaccess file and have directives placed in
Apache's vhost configuration. As to why I'm using Apache and not something
lighter, it is because of a PHP project, and the inability of our client's
tech team to grasp the concept of FastCGI... in spite of our efforts as I've
been told, but they won't let me try my good'ol' chainsaw Rusty. Aah those
sales guys...

