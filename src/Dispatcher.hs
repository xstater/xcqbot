{-# LANGUAGE OverloadedStrings #-}

module Dispatcher(
    dispatch
)where

import Data.Aeson
import Data.Text
import Control.Monad
import qualified Data.ByteString.Lazy as BS
import qualified Data.HashMap.Lazy as HM
import Web.Scotty
import qualified Callbacks.PrivateMessage as PM
import qualified Callbacks.GroupMessage as GM

dispatch :: Maybe Object -> ActionM ()
dispatch (Just obj) = 
    raw $ case PM.call obj of
       (Just bs) -> bs
       Nothing -> case GM.call obj of 
           (Just bs) -> bs
           Nothing -> BS.empty
dispatch Nothing = raw $ BS.empty
