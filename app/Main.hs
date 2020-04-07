{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Data.Aeson
import Data.ByteString.Lazy
import Control.Monad
import Data.Text
import qualified Data.HashMap.Lazy as HM 
import Resolver

main :: IO ()
main = scotty 23358 $ do
    post "/" $ do
        --msgdata <- (jsonData :: ActionM RawInfo) `rescue` (\msg -> (liftAndCatchIO $ print msg) >> finish)
        bodydata <- body
        --liftAndCatchIO $ print msgdata
        liftAndCatchIO $ print $ ((decode bodydata :: Maybe Object) >>= getItem "post_type" :: Maybe Text)
        --liftAndCatchIO $ print $ getEventInfo <$> (decode bodydata :: Maybe Object)
        text "asdsad"

{--
main :: IO ()
main = do 
    print $ getMessageInfo `fmap` (decode "{\"user_id\":123,\"age\":123,\"sex\":\"male\",\"sender\":{\"nickname\":\"dgsgh\",\"sex\":\"male\"}}" :: Maybe Object)
--}
