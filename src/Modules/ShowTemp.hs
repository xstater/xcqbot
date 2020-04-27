{-# LANGUAGE OverloadedStrings #-}

module Modules.ShowTemp(
    showTempGroup
)where

import Data.Text
import Data.Aeson
import Web.Scotty
import qualified Resolvers.Resolver as R
import qualified Resolvers.GroupMessage as RGM
import qualified Resolvers.PrivateMessage as RPM
import Common.ExecShell

showTempGroup :: R.Message a => a -> ActionM ()
showTempGroup msginfo = case R.getMessage msginfo of
    "showTemp" -> do
        tempInfoText <- execShell "sensors"
        raw $ encode $ (R.replyMessage tempInfoText :: RGM.Reply)
        finish
    _ -> return ()
