{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib(
    Sex (Male,Female),
    Role (Owner,Admin,Member),
    UserInfo(UserInfo),
    Anonymous(Anonymous),
    MessageInfo(MessageInfo),
    getMessageInfo
)where 

import Data.Maybe
import Data.Eq
import Data.Aeson
import qualified Data.ByteString as BS
import Data.Text
import Data.Scientific
import Control.Monad
import qualified Data.HashMap.Lazy as HM

data Sex = Male | Female deriving (Eq,Show)
data Role = Owner | Admin | Member deriving (Eq,Show)

data UserInfo = UserInfo {
    qq :: Maybe Int,
    nickname :: Maybe Text,
    sex :: Maybe Sex,
    age :: Maybe Int,
    card :: Maybe Text,
    area :: Maybe Text,
    level :: Maybe Text,
    role :: Maybe Role,
    title :: Maybe Text
}deriving (Eq,Show)

data Anonymous = Anonymous {
    anonymous_id :: Int,
    anonymous_name :: Text,
    anonymous_flag :: Text
}deriving (Eq,Show)

data MessageInfo = MessageInfo {
    user :: UserInfo,
    group_id :: Maybe Int,
    font :: Maybe Int,
    message :: Text,
    anonymous :: Maybe Anonymous
}deriving (Eq,Show)

class FromValue a where
    convert :: Value -> Maybe a

instance FromValue Object where
    convert (Object o) = Just o
    convert _ = Nothing

instance FromValue Text where
    convert (String s) = Just s 
    convert _ = Nothing

instance FromValue Scientific where
    convert (Number n) = Just n
    convert _ = Nothing

instance FromValue Int where
    convert f = do
        v <- convert f
        toBoundedInteger v

instance FromValue Bool where
    convert (Bool b) = Just b
    convert _ = Nothing

instance FromValue Sex where
    convert (String "male") = Just Male
    convert (String "female") = Just Female
    convert _ = Nothing

instance FromValue Role where
    convert (String "owner") = Just Owner
    convert (String "admin") = Just Admin
    convert (String "member") = Just Member
    convert _ = Nothing

getData :: FromValue a => Text -> Object -> Maybe a
getData k o = do
    t <- HM.lookup k o
    convert t

getMessageInfo :: Object -> MessageInfo
getMessageInfo obj = MessageInfo {
    user = UserInfo {
        qq = getData "user_id" obj,
        nickname = sender >>= getData "nickname",
        sex = sender >>= getData "sex",
        age = sender >>= getData "age",
        card = sender >>= getData "card",
        area = sender >>= getData "area",
        level = sender >>= getData "level",
        role = sender >>= getData "role",
        title = sender >>= getData "title" 
    },
    group_id = getData "group_id" obj,
    font = getData "font" obj,
    message = Data.Text.concat $ maybeToList $ getData "message" obj,
    anonymous = Nothing
} where
    sender :: Maybe Object
    sender = getData "sender" obj
    anon :: Maybe Object
    anon = getData "anonymous" obj
