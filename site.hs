-------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend, mconcat)
import Data.Functor ((<$>))
import Hakyll
import System.Exit (ExitCode(..))
import System.Process (system)
import System.Environment (lookupEnv)

main :: IO ()
main = hakyllWith config $ do
    match "templates/*" $ compile templateCompiler
    assetsRules
    sectionRules "wtf"
    sectionRules "reviews"

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

------------------------- [ Javascript, stylesheets, and other "static" files ]

assetsRules :: Rules ()
assetsRules = do
    match "img/*" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["favicon.ico", "robots.txt"]) $ do
        route   idRoute
        compile copyFileCompiler

    match "js/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "fonts/**" $ do
        route   idRoute
        compile copyFileCompiler

    -- Compile Stylus files to CSS
    match "css/main.styl" $ do
        route   $ setExtension "css"
        compile $ getResourceString >>= stylusCompiler

------------------------------------------------------------- [ Bloggy things ]

sectionRules :: String -> Rules ()
sectionRules name = do
    let sectionHome     = fromFilePath (name ++ "/index.html")
    let sectionFiles    = fromGlob (name ++ "/*.md")
    let sectionTemplate = fromFilePath ("templates/" ++ name ++ "/post.html")
    let indexTemplate   = fromFilePath ("templates/" ++ name ++ "/index.html")
    let rssFeed         = fromFilePath (name ++ "/index.xml")
    let atomFeed        = fromFilePath (name ++ "/atom.xml")

    match (fromGlob ("templates/" ++ name ++ "/*")) $ compile templateCompiler

    match sectionFiles $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate sectionTemplate postCtx
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create [sectionHome] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll sectionFiles
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" name                  `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate indexTemplate archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    -- RSS feed
    create [rssFeed] $ do
        route idRoute
        compile $
            loadAllSnapshots sectionFiles "content"
            >>= fmap (take 10) . recentFirst
            >>= renderRss (feedConfig $ " - Latest under " ++ name) feedCtx

    -- Atom feed
    create [atomFeed] $ do
        route idRoute
        compile $
            loadAllSnapshots sectionFiles "content"
            >>= fmap (take 10) . recentFirst
            >>= renderAtom (feedConfig $ " - Latest under " ++ name) feedCtx

feedCtx :: Context String
feedCtx = mconcat
    [ bodyField "description"
    , defaultContext
    ]

feedConfig :: String -> FeedConfiguration
feedConfig title = FeedConfiguration
    { feedTitle       = "Mostly harmless" ++ title
    , feedDescription = "rants and news from Mexico"
    , feedAuthorName  = "oz"
    , feedAuthorEmail = "oz@cyprio.net"
    , feedRoot        = "http://cyprio.net"
    }

----------------------------------------------------- [ date format for posts ]
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

-------------------------------------------------------------- [ CSS compiler ]
stylusCompiler :: Item String -> Compiler (Item String)
stylusCompiler item = withItemBody (unixFilter "./node_modules/stylus/bin/stylus" ["-I", "css"]) item
               >>= return . fmap compressCss

------------------------------------------------------------------- [ deploys ]

config :: Configuration
config = defaultConfiguration { deploySite = doDeploy }

-- Custom deploy function: use rsync over SSH. Set the "DEST" environment
-- variable to deploy to other mirrors.
doDeploy :: Configuration -> IO ExitCode
doDeploy _ = deployCmd >>= system

deployProgram :: String
deployProgram = "rsync -av --delete -e 'ssh' _site/ "

defaultDeployDest :: String
defaultDeployDest = "/tmp/www"

-- Lookup DEST env var, to build a deploy command.
deployCmd :: IO String
deployCmd = do
    dest <- lookupEnv "DEST"
    return $ case dest of Nothing -> deployProgram ++ defaultDeployDest
                          Just x  -> deployProgram ++ x
