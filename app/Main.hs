{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Data.Aeson
import Data.ByteString.Lazy
import Control.Monad
import Data.Text
import qualified Data.HashMap.Lazy as HM 
import qualified Resolvers.Resolver as R
import qualified Resolvers.PrivateMessage as RPM
import Callbacks.PrivateMessage as PM
import Dispatcher

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

--main :: IO ()
--main = do
    

