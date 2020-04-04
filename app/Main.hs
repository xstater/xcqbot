{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Data.Aeson
import Data.ByteString.Lazy
import Control.Monad
import qualified Data.HashMap.Lazy as HM 
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
    print $ getMessageInfo `fmap` (decode "{\"user_id\":123,\"age\":123,\"sex\":\"male\",\"sender\":{\"nickname\":\"dgsgh\"}}" :: Maybe Object)
