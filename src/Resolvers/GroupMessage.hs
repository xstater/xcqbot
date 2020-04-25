{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Resolvers.GroupMessage(
    MessageType(NormalMessage,AnonymousMessage,NoticeMessage),
    Anonymous(Anonymous,anonymous_id,anonymous_name,anonymous_flag),
    Role(Owner,Admin,Member),
    Sex(Male,Female,Unknown),
    Sender(Sender,qq,nickname,card,sex,age,area,level,role,title),
    MessageInfo(MessageInfo,message_type,message_id,group_id,user_id,anonymous,message,font,sender),
    Reply(Reply,reply,auto_escape,at_sender,delete,kick,ban,ban_duration),
    getMessageInfo,
)where

import Data.Aeson
import Data.Text
import Data.Maybe
import GHC.Generics
import qualified Resolvers.Resolver as R

data MessageType = 
    NormalMessage
  | AnonymousMessage
  | NoticeMessage deriving (Eq,Show)
instance R.Resolvable MessageType where
    resolve (String "normal") = Just NormalMessage
    resolve (String "anonymous") = Just AnonymousMessage
    resolve (String "notice") = Just NoticeMessage
    resolve _ = Nothing

data Anonymous = Anonymous {
    anonymous_id :: Maybe Int,
    anonymous_name :: Maybe Text,
    anonymous_flag :: Maybe Text
}deriving (Eq,Show)

data Role = Owner | Admin | Member deriving (Eq,Show)
instance R.Resolvable Role where
    resolve (String "owner") = Just Owner
    resolve (String "admin") = Just Admin
    resolve (String "member") = Just Member
    resolve _ = Nothing

data Sex = Male | Female | Unknown deriving (Eq,Show)
instance R.Resolvable Sex where
    resolve (String "male") = Just Male
    resolve (String "female") = Just Female
    resolve (String "unknown") = Just Unknown
    resolve _ = Nothing

data Sender = Sender {
    qq :: Maybe Int,
    nickname :: Maybe Text,
    card :: Maybe Text,
    sex :: Maybe Sex,
    age :: Maybe Int,
    area :: Maybe Text,
    level :: Maybe Text,
    role :: Maybe Role,
    title :: Maybe Text
}deriving (Eq,Show)

data MessageInfo = MessageInfo {
    message_type :: MessageType,
    message_id :: Int,
    group_id :: Int,
    user_id :: Int,
    anonymous :: Maybe Anonymous,
    message :: Text,
    font :: Int,
    sender :: Maybe Sender
}deriving (Eq,Show)

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

isGroupMessageM :: Object -> Maybe ()
isGroupMessageM obj = R.getPostType obj >>= R.eqStringM "message" >> R.getMessageType obj >>= R.eqStringM "group"

getAnonymous :: Object -> Maybe Anonymous
getAnonymous obj = do
    anon_obj <- R.getItem "anonymous" obj
    return $ Anonymous {
        anonymous_id = R.getItem "id" anon_obj,
        anonymous_name = R.getItem "name" anon_obj,
        anonymous_flag = R.getItem "flag" anon_obj
    }

getSender :: Object -> Maybe Sender
getSender obj = do
    sender_obj <- R.getItem "sender" obj
    return $ Sender {
        qq = R.getItem "user_id" sender_obj,
        nickname = R.getItem "nickname" sender_obj,
        card = R.getItem "card" sender_obj,
        sex = R.getItem "sex" sender_obj,
        age = R.getItem "age" sender_obj,
        area = R.getItem "area" sender_obj,
        level = R.getItem "level" sender_obj,
        role = R.getItem "role" sender_obj,
        title = R.getItem "title" sender_obj
    }

getMessageInfo :: Object -> Maybe MessageInfo
getMessageInfo obj = isGroupMessageM obj >> Just MessageInfo {
    message_type = fromMaybe NormalMessage $ R.getItem "sub_type" obj,
    message_id = fromMaybe 0 $ R.getItem "message_id" obj,
    group_id = fromMaybe 0 $ R.getItem "group_id" obj,
    user_id = fromMaybe 0 $ R.getItem "user_id" obj,
    anonymous = getAnonymous obj,
    message = fromMaybe "" $ R.getItem "message" obj,
    font = fromMaybe 0 $ R.getItem "font" obj,
    sender = getSender obj
}


