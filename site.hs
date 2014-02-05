--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend, mconcat)
import Data.Functor ((<$>))
import Hakyll
import System.Exit (ExitCode(..))
import System.Process (system)
import System.Environment (lookupEnv)

--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do
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

    match "js/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*.css" $ do
        route   idRoute
        compile compressCssCompiler

    -- Compile Stylus files to CSS
    match "css/main.styl" $ do
        route   $ setExtension "css"
        compile $ getResourceString >>= stylus

    match (fromList ["about.md", "contact.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
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

    match "templates/wtf/*" $ compile templateCompiler

    match "wtf/*.md" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/wtf/post.html" postCtx
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["wtf/index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "wtf/*.md"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "WTF?"                `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/wtf/index.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

-- RSS feed
    create ["wtf/index.xml"] $ do
            route idRoute
            compile $
                    loadAllSnapshots "wtf/*.md" "content"
                    >>= fmap (take 10) . recentFirst
                    >>= renderRss wtfFeedConfig feedCtx

-- Atom feed
    create ["wtf/atom.xml"] $ do
            route idRoute
            compile $
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
stylus :: Item String -> Compiler (Item String)
stylus item = withItemBody (unixFilter "stylus" ["-I", "css"]) item
               >>= return . fmap compressCss


--------------------------------------------------------------------------------
-- Customize the "deploy" command.

config :: Configuration
config = defaultConfiguration { deploySite = doDeploy }

-- Custom deploy function: use rsync over SSH. Set the "DEST" environment
-- variable to deploy to other mirrors.
doDeploy :: Configuration -> IO ExitCode
doDeploy _ = deployCmd >>= system

deployProgram :: String
deployProgram = "rsync -av --delete -e 'ssh' _site/ "

defaultDeployDest :: String
defaultDeployDest = "oz@cyprio.net:/usr/local/www/cyprio.net/www/data"

-- Lookup DEST env var, to build a deploy command.
deployCmd :: IO String
deployCmd = do
        dest <- lookupEnv "DEST"
        return $ case dest of Nothing -> deployProgram ++ defaultDeployDest
                              Just x  -> deployProgram ++ x

