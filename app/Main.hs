{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Data.Aeson
import Data.ByteString.Lazy
import qualified Data.Map.Lazy as Map
import Lib
{--
main :: IO ()
main = scotty 23358 $ do
    post "/" $ do
        msgdata <- (jsonData :: ActionM RawInfo) `rescue` (\msg -> (liftAndCatchIO $ print msg) >> finish)
        --bodydata <- body
        liftAndCatchIO $ print msgdata
        text "asdsad"
--}
main :: IO ()
main = do 
    print $ (decode "{\"user_id\":123,\"age\":123,\"sex\":\"male\",\"info\":{\"aaa\":123}}" :: Maybe Object)
