{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Data.Aeson
import Data.ByteString.Lazy.Char8 as B
import Control.Monad
import Control.Monad.IO.Class
import Data.Text
import qualified Data.HashMap.Lazy as HM 
import qualified Resolvers.Resolver as R
import qualified Resolvers.PrivateMessage as RPM
import Callbacks.PrivateMessage as PM
import Network.HTTP.Req
import Text.HTML.DOM
import Text.XML.Cursor
import Text.XML
import Dispatcher

{--
main :: IO ()
main = scotty 23358 $ do
    post "/" $ do
        --msgdata <- (jsonData :: ActionM RawInfo) `rescue` (\msg -> (liftAndCatchIO $ print msg) >> finish)
        bodydata <- body
        let json_data = (decode bodydata :: Maybe Object)
        --liftAndCatchIO $ print msgdata
        liftAndCatchIO $ print json_data
        --liftAndCatchIO $ print $ getEventInfo <$> (decode bodydata :: Maybe Object)
        dispatch json_data
--}

main :: IO ()
main = runReq defaultHttpConfig $ do
    bs <- req GET (http "www.baidu.com") NoReqBody lbsResponse mempty 
    --liftIO $ B.putStrLn (responseBody bs)
    let cur = fromDocument $ Text.HTML.DOM.parseLBS $ responseBody bs
    liftIO $ print $ Data.Text.concat $ cur $/ element "head" &/ element "title" &// content

{--
main :: IO ()
main = do
    --print $ parseLT "<html><body><h1>asd</h1><br><br/></body></html>"
    doc <- Text.HTML.DOM.readFile "/home/xstater/haskell/xcqbot/test.html"
    --doc <- return $ parseLT "<html><head><title>nmsl</title></head><body><h1>asd</h1><br><br/></body></html>"
    let cur = fromDocument doc
    print $ Prelude.length $ child cur
    --print doc
    print $ Data.Text.concat $ cur $/ element "head" &/ element "title" &// content
--}

--main :: IO ()
--main = do
    

