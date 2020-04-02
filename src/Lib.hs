{-# LANGUAGE OverloadedStrings #-}

module Lib(
    Sex (Male,Female),
    Role (Owner,Admin,Member),
    UserInfo(UserInfo),
    Anonymous(Anonymous),
    MessageInfo(MessageInfo)
)where 

import Data.Maybe
import Data.Eq
import Data.Aeson
import Data.ByteString
import qualified Data.HashMap.Lazy as HM

data Sex = Male | Female deriving (Eq,Show)
data Role = Owner | Admin | Member deriving (Eq,Show)

data UserInfo = UserInfo {
    qq :: Int,
    nickname :: Maybe Int,
    sex :: Maybe Sex,
    age :: Maybe Int,
    card :: Maybe String,
    area :: Maybe String,
    level :: Maybe String,
    role :: Maybe Role,
    title :: Maybe String
}deriving (Eq,Show)

data Anonymous = Anonymous {
    anonymous_id :: Int,
    anonymous_name :: String,
    anonymous_flag :: String
}deriving (Eq,Show)

data MessageInfo = MessageInfo {
    user :: UserInfo,
    group :: Maybe Int,
    font :: Maybe Int,
    message :: String,
    anonymous :: Maybe Anonymous
}deriving (Eq,Show)


fromAST :: Object -> MessageInfo
fromAST ast = undefined
