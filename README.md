# Cyprio.net

This is the source for http://cyprio.net

To compile, you will need:
  * [Hakyll][hakyll],
  * and [Stylus][stylus] from [Node.js][node].

To deploy, you also want [Rsync][rsync].

# Setup

Install Haskell dependencies:

```
cabal install hakyll
```

Install node dependencies:

```
npm i
```

Build `site` program with `ghc --make site`, then check `./site --help`.


# Deploying

Use `./site deploy` to deploy to `/tmp/www`, or change the `DEST`
environment variable to deploy elsewhere.

For example:

```
DEST=server.com:/srv/blog/www ./site deploy
```

# License

 * The haskell program `site.hs` is public domain.
 * All other contents are © Arnaud Berthomier.

[hakyll]: http://jaspervdj.be/hakyll/
[stylus]: http://learnboost.github.io/stylus/
[node]: http://nodejs.org
[rsync]: https://rsync.samba.org/
