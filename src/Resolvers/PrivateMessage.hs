{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Resolvers.PrivateMessage(
    MessageFrom(FromFriend,FromGroup,FromDiscuss,FromOther),
    Sex(Male,Female),
    Sender(Sender,qq,nickname,sex,age),
    MessageInfo(MessageInfo,from,message_id,user_id,message,font,sender),
    Reply(Reply,reply,auto_escape),
    getMessageInfo 
)where

import Data.Aeson
import Data.Text
import Data.Maybe
import GHC.Generics
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
    from :: MessageFrom,
    message_id :: Int,
    user_id :: Int,
    message :: Text,
    font :: Int,
    sender :: Maybe Sender
} deriving (Eq,Show)

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

getMessageInfo :: Object -> Maybe MessageInfo
getMessageInfo obj = isPrivateMessageM obj >> Just MessageInfo{
    Resolvers.PrivateMessage.from = fromMaybe FromOther $ getItem "sub_type" obj,
    message_id = fromMaybe 0 $ getItem "message_id" obj,
    user_id = fromMaybe 0 $ getItem "user_id" obj,
    message = fromMaybe "" $ getItem "message" obj,
    font = fromMaybe 0 $ getItem "font" obj,
    sender = getSender obj
}
