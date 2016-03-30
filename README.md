# Cyprio.net

This is the source for http://cyprio.net

To build it, you will need:
  * [Cabal][cabal] to build Haskell dependencies,
  * and [Node.js][node] for stylesheets & co.

To deploy, you also want [Rsync][rsync].


# Setup

Install Node.js dependencies:

```
npm install
```

Install Haskell dependencies with cabal ; you probably want a sandbox
to do that, e.g.:

```
cabal sandbox init
cabal install
```

This should build all the relevant deps, and also a `site` program
under `.cabal-sandbox/bin/site`. Yes, it will take a long time, you're
building [Pandoc][pandoc] and [Hakyll][hakyll] here. :innocent:

After a couple of coffees away from the :fire: of your CPU, you can
run the `site` program directly, or through `cabal run`.


# Deploying

Use `./site deploy` to deploy to `/tmp/www`, or change the `DEST`
environment variable to deploy elsewhere.

For example:

```
DEST=server.com:/srv/blog/www ./site deploy
```


# License

 * The haskell program `site.hs`, templates, stylesheets and javascript files
   are published in the public domain, without any warranty that they can be of
   any (good) use at all. Use at your own risk!
 * All other contents are © Arnaud Berthomier.

[hakyll]: http://jaspervdj.be/hakyll/
[cabal]: https://www.haskell.org/cabal/
[pandoc]: http://pandoc.org/
[stylus]: http://learnboost.github.io/stylus/
[node]: http://nodejs.org
[rsync]: https://rsync.samba.org/
