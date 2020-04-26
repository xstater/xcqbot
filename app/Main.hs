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
import Modules.Link
import Control.Monad.Trans.Maybe

main :: IO ()
main = scotty 23358 $ do
    post "/" $ do
        bodydata <- body
        let json_data = (decode bodydata :: Maybe Object)
        liftAndCatchIO $ print json_data
        dispatch json_data

