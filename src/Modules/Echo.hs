{-# LANGUAGE OverloadedStrings #-}

module Modules.Echo(
    echoPrivateMessage,
    echoGroupMessage
)where

import Web.Scotty
import Data.Text 
import Data.Aeson
import qualified Resolvers.PrivateMessage as RPM
import qualified Resolvers.GroupMessage as RGM

echoPrivateMessage :: RPM.MessageInfo -> ActionM ()
echoPrivateMessage msginfo = raw $ encode RPM.Reply{
    RPM.reply = RPM.message msginfo,
    RPM.auto_escape = False
}

echoGroupMessage :: RGM.MessageInfo -> ActionM ()
echoGroupMessage msginfo = do
    raw $ encode RGM.Reply {
        RGM.reply = RGM.message msginfo,
        RGM.auto_escape = False,
        RGM.at_sender = False,
        RGM.delete = False,
        RGM.kick = False,
        RGM.ban = False,
        RGM.ban_duration = 0
    }
    finish

