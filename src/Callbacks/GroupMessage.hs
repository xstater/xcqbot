{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Callbacks.GroupMessage (
)where

import Data.Aeson
import Data.Text
import Data.Maybe
import Control.Monad
import qualified Resolver as R
import GHC.Generic

data MessageType = 
    NormalMessage
  | AnonymousMessage
  | NoticeMessage deriving (Eq,Show)
instance R.Resolvable MessageType where
    resolve (String "normal") = Just NormalMessage
    resolve (String "anonymous") = Just AnonymousMessage
    resolve (String "notice") = Just NoticeMessage
    resolve _ = Nothing

type MessageID = Int
type GroupID = Int
type QQ = Int
type Font = Int

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
    age :: Maybe Int
    area :: Maybe Text,
    level :: Maybe Text,
    role :: Maybe Role,
    title :: Maybe Text
}deriving (Eq,Show)

data Reply = Reply {
    reply :: Text,
    auto_escape :: Bool,
    at_sender :: Bool,
    delete :: Bool,
    kick :: Bool,
    ban :: Bool,
    ban_duration :: Bool
}deriving (Eq,Show,Generic)
instance ToJSON Reply

isGroupMessageM :: Object -> Maybe ()
isGroupMessageM obj = R.getPostType obj >>= R.eqStringM "message" >> R.getPostType obj >>= "group"

getQQ :: Object -> Maybe QQ
getQQ = getItem "user_id"

getFont :: Object -> Maybe Font 
getFont = getItem "font"

getMessage :: Object -> Maybe Text
getMessage = getItem "message"

getSender :: Object -> Maybe Sender
getSender obj = Just Sender{
        qq = sender_obj >>= getItem "user_id",
        nickname = sender_obj >>= getItem "nickname",
        sex = sender_obj >>= getItem "sex",
        age = sender_obj >>= getItem "age"
    }where sender_obj = getItem "sender" obj

getAnonymous :: Object -> Maybe Anonymous
getAnonymous obj = Just Anonymous{
    anonymous_id = anon_obj >>= getItem ""
}where anon_obj = getItem "anonymous" obj

onGroupMessage :: QQ -> GroupID -> MessageID -> Font -> Text -> Maybe Reply
onGroupMessage qq groupid messageid font msg = undefined

call :: Object -> Maybe 

