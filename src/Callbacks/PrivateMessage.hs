{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Callbacks.PrivateMessage(
    MessageFrom(FromFriend,FromGroup,FromDiscuss,FromOther),
    Sex(Male,Female),
    Sender(Sender,qq,nickname,sex,age),
    Reply(Reply,reply,auto_escape),
    isPrivateMessageM,
    getSender,
    getMessageFrom,
    getQQ,
    getFont,
    onPrivateMessage,
)where

import Data.Text
import Data.Aeson
import Data.ByteString.Lazy
import Data.Monoid
import Control.Monad
import Resolver as R
import GHC.Generics

data MessageFrom =
    FromFriend
  | FromGroup
  | FromDiscuss 
  | FromOther deriving (Eq,Show)
instance R.Resolvable MessageFrom where
    resolve (String "friend") = Just FromFriend
    resolve (String "group") = Just FromGroup
    resolve (String "discuss") = Just FromDiscuss
    resolve (String "other") = Just FromOther
    resolve _ = Nothing

data Sex = Male | Female deriving (Eq,Show)
instance R.Resolvable Sex where
    resolve (String "male") = Just Male
    resolve (String "female") = Just Female
    resolve _ = Nothing

data Sender = Sender {
    qq :: Maybe Int,
    nickname :: Maybe Text,
    sex :: Maybe Sex,
    age :: Maybe Int
} deriving (Eq,Show)

type QQ = Int
type Font = Int

data Reply = Reply{
    reply :: Text,
    auto_escape :: Bool
}deriving (Eq,Show,Generic)
instance ToJSON Reply

isPrivateMessageM :: Object -> Maybe ()
isPrivateMessageM obj = R.getPostType obj >>= R.eqStringM "message" >> R.getMessageType obj >>= R.eqStringM "private"

getSender :: Object -> Maybe Sender
getSender obj = Just Sender{
        qq = sender_obj >>= getItem "user_id",
        nickname = sender_obj >>= getItem "nickname",
        sex = sender_obj >>= getItem "sex",
        age = sender_obj >>= getItem "age"
    }where sender_obj = getItem "sender" obj

getMessageFrom :: Object -> Maybe MessageFrom
getMessageFrom obj = getItem "sub_type" obj

getQQ :: Object -> Maybe QQ
getQQ obj = getItem "user_id" obj

getFont :: Object -> Maybe Font
getFont obj = getItem "font" obj

onPrivateMessage :: QQ -> Font -> MessageFrom -> Sender -> Maybe Reply
onPrivateMessage qq font msgfrom sender = Just $ Reply {reply = "nmsl",auto_escape = True}


