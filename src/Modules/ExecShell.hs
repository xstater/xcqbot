{-# LANGUAGE OverloadedStrings #-}

module Modules.ExecShell(
    execShell
)where

import Data.Text
import Data.Aeson
import Web.Scotty
import qualified Resolvers.Resolver as R
import qualified Resolvers.GroupMessage as RGM
import qualified Resolvers.PrivateMessage as RPM
import qualified Common.ExecShell as ES

execShell :: R.Message a => a -> ActionM ()
execShell msginfo = do
    tempInfoText <- ES.execShell $ R.getMessage msginfo 
    raw $ encode $ (R.replyMessage tempInfoText :: RPM.Reply)
    finish

