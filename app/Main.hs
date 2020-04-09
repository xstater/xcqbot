{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Data.Aeson
import Data.ByteString.Lazy
import Control.Monad
import Data.Text
import qualified Data.HashMap.Lazy as HM 
import qualified Resolver as R
import Callbacks.PrivateMessage as PM
{--
main :: IO ()
main = scotty 23358 $ do
    post "/" $ do
        --msgdata <- (jsonData :: ActionM RawInfo) `rescue` (\msg -> (liftAndCatchIO $ print msg) >> finish)
        bodydata <- body
        --liftAndCatchIO $ print msgdata
        liftAndCatchIO $ print $ ((decode bodydata :: Maybe Object) >>= getItem "post_type" :: Maybe Text)
        --liftAndCatchIO $ print $ getEventInfo <$> (decode bodydata :: Maybe Object)
        text "asdsad"
--}

main :: IO ()
main = do
    print $ obj >>= R.isMessageM
    print $ obj >>= R.isPrivateMessageM
    print $ obj >>= R.isPrivateMessageM >> PM.onPrivateMessage PM.FromFriend (PM.Sender { qq = Nothing,nickname = Nothing ,sex = Nothing,age = Nothing})
    where
        obj :: Maybe Object 
        obj = decode "{\"post_type\":\"message\",\"message_type\":\"private\"}"
