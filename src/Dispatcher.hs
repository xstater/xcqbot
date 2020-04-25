{-# LANGUAGE OverloadedStrings #-}

module Dispatcher(
    dispatch
)where

import Data.Aeson
import Data.Text
import Data.Monoid
import Control.Monad
import qualified Data.ByteString.Lazy as BS
import qualified Data.HashMap.Lazy as HM
import Web.Scotty
import qualified Callbacks.PrivateMessage as PMC
import qualified Resolvers.PrivateMessage as PMR
import qualified Callbacks.GroupMessage as GMC
import qualified Resolvers.GroupMessage as GMR

ifDo :: Maybe a -> (a -> ActionM ()) -> ActionM ()
ifDo (Just x) f = f x
ifDo Nothing _ = return () 

dispatch :: Maybe Object -> ActionM ()
dispatch (Just obj) = do
    ifDo (PMR.getMessageInfo obj) PMC.onPrivateMessage
    ifDo (GMR.getMessageInfo obj) GMC.onGroupMessage
dispatch Nothing = raw $ BS.empty

