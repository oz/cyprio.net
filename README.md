# Cyprio.net

This is the source for http://cyprio.net

To build it, you will need:

 * [Stack][stack], or [Cabal][cabal] to build Haskell dependencies,
 * [Node.js][node] to build stylesheets,
 * and some free time.

To deploy, you will need [Rsync][rsync]. All those things should have
packages for your favorite OS.


# Setup

Install Node.js dependencies:

```
npm install
```

Install and build Haskell code with `stack`:

```
stack build && stack install
```

This should build all the relevant deps, and compile a `site` program.

After a couple of coffees away from the :fire: of your CPU, you can
run the `site` program directly.


# Deploying

Use `site deploy` to deploy to `/tmp/www`, or change the `DEST`
environment variable to deploy elsewhere.

For example:

```
DEST=server.com:/srv/blog/www site deploy
```


# License

 * The haskell program `site.hs`, templates, stylesheets and javascript files
   are published in the public domain, without any warranty that they can be of
   any (good) use at all. Use at your own risk!
 * All other contents are © Arnaud Berthomier.

[hakyll]: http://jaspervdj.be/hakyll/
[cabal]: https://www.haskell.org/cabal/
[stack]: http://haskellstack.org/
[pandoc]: http://pandoc.org/
[stylus]: http://learnboost.github.io/stylus/
[node]: http://nodejs.org
[rsync]: https://rsync.samba.org/
