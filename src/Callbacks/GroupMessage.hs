{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Callbacks.GroupMessage (
    call
)where

import Data.Aeson
import Data.Text
import Data.Maybe
import Control.Monad
import Data.ByteString.Lazy as BS
import qualified Resolvers.Resolver as R
import GHC.Generics
import Resolvers.GroupMessage as RGM

data Reply = Reply {
    reply :: Text,
    auto_escape :: Bool,
    at_sender :: Bool,
    delete :: Bool,
    kick :: Bool,
    ban :: Bool,
    ban_duration :: Int
}deriving (Eq,Show,Generic)
instance ToJSON Reply

onGroupMessage :: RGM.MessageInfo -> Maybe Reply
onGroupMessage msg_info =
    case (RGM.group_id msg_info) of
        (Just 795831442) -> Just Reply {
            reply = case (RGM.message msg_info) of
                (Just msg) -> mconcat ["[CQ:at,qq=2953415341]",msg]
                Nothing -> "",
            auto_escape = False,
            at_sender = False,
            delete = False,
            kick = False,
            ban = False,
            ban_duration = 0
        }
        Nothing -> Nothing

call :: Object -> Maybe BS.ByteString
call obj = do
    RGM.isGroupMessageM obj
    msgi <- RGM.getMessageInfo obj
    rep <- onGroupMessage msgi
    return $ encode rep

