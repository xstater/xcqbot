{-# LANGUAGE OverloadedStrings #-}

module Modules.SayWhat(
    sayWhatGroup
)where

import Data.Text
import Data.Aeson
import Web.Scotty
import qualified Resolvers.Resolver as R
import qualified Resolvers.GroupMessage as RGM
import qualified Resolvers.PrivateMessage as RPM

sayWhatGroup :: R.Message a => a -> ActionM ()
sayWhatGroup msginfo = case R.getMessage msginfo of
    "[CQ:at,qq=2022847429]" -> do
        raw $ encode $ (R.replyMessage "干嘛？" :: RGM.Reply)
        finish
    _ -> return ()
