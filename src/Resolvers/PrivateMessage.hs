{-# LANGUAGE OverloadedStrings #-}

module Resolvers.PrivateMessage(
    MessageFrom(FromFriend,FromGroup,FromDiscuss,FromOther),
    Sex(Male,Female),
    Sender(Sender,qq,nickname,sex,age),
    MessageInfo(MessageInfo,from,message_id,user_id,message,font,sender),
    isPrivateMessageM,
    getMessageInfo 
)where

import Data.Aeson
import Data.Text
import Resolvers.Resolver as R

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

data MessageInfo = MessageInfo{
    from :: Maybe MessageFrom,
    message_id :: Maybe Int,
    user_id :: Maybe Int,
    message :: Maybe Text,
    font :: Maybe Int,
    sender :: Maybe Sender
} deriving (Eq,Show)


isPrivateMessageM :: Object -> Maybe ()
isPrivateMessageM obj = R.getPostType obj >>= R.eqStringM "message" >> R.getMessageType obj >>= R.eqStringM "private"

getSender :: Object -> Maybe Sender
getSender obj = Just Sender{
    qq = sender_obj >>= getItem "user_id",
    nickname = sender_obj >>= getItem "nickname",
    sex = sender_obj >>= getItem "sex",
    age = sender_obj >>= getItem "age"
}where sender_obj = getItem "sender" obj

getMessageInfo :: Object -> Maybe MessageInfo
getMessageInfo obj = Just MessageInfo{
    from = getItem "sub_type" obj,
    message_id = getItem "message_id" obj,
    user_id = getItem "user_id" obj,
    message = getItem "message" obj,
    font = getItem "font" obj,
    sender = getSender obj
}
