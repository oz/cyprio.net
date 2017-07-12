# Cyprio.net

This is the source for https://cyprio.net

To build it, you will need:

 * [Stack][stack], or [Cabal][cabal] to build Haskell dependencies,
 * [Node.js][node] to build JS & stylesheets,
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
stack build
```

This should build all the relevant deps, and compile a `site` program.

After a couple of coffees away from the :fire: of your CPU, you can
run `stack exec site`. Alternatively, use `stack install` to use the
`site` program directly.


# Deploying

Use `site deploy` to deploy to `/tmp/www`, or change the `DEST`
environment variable to deploy elsewhere.

For example:

```
DEST=server.com:/srv/blog/www site deploy
```


# License

* The haskell program `site.hs`, HTML templates, stylesheets, and Javascript
  files are published in the public domain, without any warranty that they
  can be of any use at all. Use at your own risk, etc.
* All other contents are © Arnaud Berthomier.

[hakyll]: https://jaspervdj.be/hakyll/
[cabal]: https://www.haskell.org/cabal/
[stack]: https://haskellstack.org/
[pandoc]: https://pandoc.org/
[stylus]: http://learnboost.github.io/stylus/
[node]: https://nodejs.org
[rsync]: https://rsync.samba.org/
