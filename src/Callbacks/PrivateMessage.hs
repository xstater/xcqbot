{-# LANGUAGE OverloadedStrings #-}
module Callbacks.PrivateMessage(
    onPrivateMessage
)where

import Data.Text
import Data.Aeson
import Web.Scotty
import qualified Data.ByteString.Lazy as BS
import Control.Monad
import qualified Resolvers.Resolver as R
import qualified Resolvers.PrivateMessage as RPM
import Modules.Link
import Modules.Filter
import Modules.Echo
import Modules.ExecShell
import Modules.ExecHaskell

onPrivateMessage :: RPM.MessageInfo -> ActionM ()
onPrivateMessage msginfo = do
    filteQQ $ RPM.user_id msginfo
    execHaskellPrivate msginfo
    execShell msginfo