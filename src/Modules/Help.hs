{-# LANGUAGE OverloadedStrings #-}

module Modules.Help(
    helpGroup
)where

import Data.Text
import Data.Aeson
import Web.Scotty
import qualified Resolvers.Resolver as R
import qualified Resolvers.GroupMessage as RGM
import qualified Resolvers.PrivateMessage as RPM

helpMessage :: Text
helpMessage = "Help:\n1.showTemp => 显示温度\n2.showCPUInfo => 显示CPU信息"

helpGroup :: R.Message a => a -> ActionM ()
helpGroup msginfo =
    case R.getMessage msginfo of
        "help" -> do
            raw $ encode $ (R.replyMessage helpMessage :: RGM.Reply)
            finish
        _ -> return ()


