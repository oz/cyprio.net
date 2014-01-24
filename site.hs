--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend, mconcat)
import Data.Functor ((<$>))
import Hakyll

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "img/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- Copy regular files (HTML5 Boilerplate CSS, favicon, some JS...)
    match (fromList ["favicon.ico", "robots.txt"])$ do
        route   idRoute
        compile copyFileCompiler

    match "img/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*.css" $ do
        route   idRoute
        compile compressCssCompiler

    -- Compile Sass styles
    match "css/main.scss" $ do
        route   $ setExtension "css"
        compile $ getResourceString >>= sassify

    match (fromList ["about.md", "contact.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "wtf/*.md"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- loadAll "wtf/*.md"
            sorted_posts <- take 3 <$> recentFirst posts
            let indexCtx =
                    listField "posts" postCtx (return sorted_posts) `mappend`
                    constField "title" "Home"                       `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

-------------------------------------------------------------------------------
-- Bloggy thing
    match "wtf/*.md" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

-- RSS feed
    create ["wtf/index.xml"] $ do
            route idRoute
            compile $ do
                    loadAllSnapshots "wtf/*.md" "content"
                    >>= fmap (take 10) . recentFirst
                    >>= renderRss wtfFeedConfig feedCtx

-- Atom feed
    create ["wtf/atom.xml"] $ do
            route idRoute
            compile $ do
                    loadAllSnapshots "wtf/*.md" "content"
                    >>= fmap (take 10) . recentFirst
                    >>= renderAtom wtfFeedConfig feedCtx
-------------------------------------------------------------------------------
-- Feeds stuff
feedCtx :: Context String
feedCtx = mconcat
        [ bodyField "description"
        , defaultContext
        ]

wtfFeedConfig :: FeedConfiguration
wtfFeedConfig = feedConfig " - Latest wtf posts"

feedConfig :: String -> FeedConfiguration
feedConfig title = FeedConfiguration
        { feedTitle       = "Mostly harmless" ++ title
        , feedDescription = "rants and moods from Mexico"
        , feedAuthorName  = "oz"
        , feedAuthorEmail = "oz@cyprio.net"
        , feedRoot        = "http://cyprio.net"
        }

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

--------------------------------------------------------------------------------
sassify :: Item String -> Compiler (Item String)
sassify item = withItemBody (unixFilter "sass" ["-s", "--scss", "--load-path", "css"]) item
               >>= return . fmap compressCss
