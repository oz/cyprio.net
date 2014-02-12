---
title: Publishing with git-annex
---

I've been using [git-annex][] and boring people with it for quite a while now.
It is an excellent piece of software, and so I can't really promise this rant
will be the last.

After [moving to Hakyll][moving-to-hakyll], I was left with a few dangling
links (e.g. pictures) for various reasons detailed in the earlier post. I
decided to host those files on a separate sub-domain `static.cyprio.net` and
also used the occasion to cleanup the accumulated cruft. A few `sed`s after,
all the broken links have been squashed.

This website is normally generated with Hakyll, and then deployed by a simple
rsync. However its contents are stored in Git: mainly because it makes it
harder to destroy things unintentionally. Because I want the same security for
the *static* domain, it is setup as a git-annex repository: this means
git-annex manages file contents (a few Gigs), and regular git manages file's
metadata (a few Megs).

I am still "refining" the process, but right now it looks like this:

 * I have clones of the full git-annex *static* repository on two servers (one
   master, and a backup).
 * Those servers synchronize automatically using a cronjob (`git annex sync
   --content`): I'd rather have git hooks on the *master* do the sync, but I'm
   not sure how git-annex plugs itself in Git's hooks. So I still have room for
   experimentation here. :)
 * I also have a partial clone of the git-annex repository on my laptop, which
   allows me to push stuff online with `git annex copy`, or grab the data I may
   need when offline.

That's all for this post. If you have other ideas, shoot me a mail, I'm all
ears.

[git-annex]: https://git-annex.branchable.com/
[moving-to-hakyll]: http://www.cyprio.net/wtf/2014-02-05-lifting.html
