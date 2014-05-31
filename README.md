# Cyprio.net

This is the source for http://cyprio.net

To compile, you will need:
  * [Hakyll][hakyll],
  * and [Stylus][stylus].

To build, simply `ghc --make site`. Then use `./site deploy` to deploy
to `/tmp/www`, or change the `DEST` environment variable to deploy
elsewhere.

# License

 * The haskell program `site.hs` is public domain.
 * All other contents are © Arnaud Berthomier.

[hakyll]: http://jaspervdj.be/hakyll/
[stylus]: http://learnboost.github.io/stylus/
