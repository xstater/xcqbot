{-# LANGUAGE OverloadedStrings #-}

module Modules.ShowCPUInfo(
    showCPUInfoGroup
)where

import Data.Text
import Data.Aeson
import Web.Scotty
import qualified Resolvers.Resolver as R
import qualified Resolvers.GroupMessage as RGM
import qualified Resolvers.PrivateMessage as RPM
import Common.ExecShell

showCPUInfoGroup :: R.Message a => a -> ActionM ()
showCPUInfoGroup msginfo = case R.getMessage msginfo of
    "showCPUInfo" -> do
        tempInfoText <- execShell "lscpu"
        raw $ encode $ (R.replyMessage tempInfoText :: RGM.Reply)
        finish
    _ -> return ()
