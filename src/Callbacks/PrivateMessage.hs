{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Callbacks.PrivateMessage(
    Reply(Reply,reply,auto_escape),
    call
)where

import Data.Text
import Data.Aeson
import Data.ByteString.Lazy
import Data.Monoid
import Control.Monad
import qualified Resolvers.Resolver as R
import qualified Resolvers.PrivateMessage as RPM
import GHC.Generics

data Reply = Reply{
    reply :: Text,
    auto_escape :: Bool
}deriving (Eq,Show,Generic)
instance ToJSON Reply

onPrivateMessage :: RPM.MessageInfo -> Maybe Reply
onPrivateMessage msg_info =
    if (RPM.user_id msg_info) == Just 1209635268 
        then Just $ 
            Reply {
                reply = 
                    case (RPM.message msg_info) of
                        (Just msg) -> msg
                        Nothing -> Data.Text.empty,
                auto_escape = True
            }
        else Nothing

call :: Object -> Maybe ByteString
--call obj = obj >>= RPM.isPrivateMessageM >> RPM.getMessageInfo obj >>= onPrivateMessage >>= Just $ encode
call obj = do
    RPM.isPrivateMessageM obj
    msgi <- RPM.getMessageInfo obj
    rep <- onPrivateMessage msgi
    return $ encode rep

