{-# LANGUAGE OverloadedStrings #-}
module Callbacks.PrivateMessage(
    MessageFrom(FromFriend,FromGroup,FromDiscuss,FromOther),
    Sex(Male,Female),
    Sender(Sender,qq,nickname,sex,age),
    onPrivateMessage
)where

import Data.Text

data MessageFrom =
    FromFriend
  | FromGroup
  | FromDiscuss 
  | FromOther deriving (Eq,Show)

data Sex = Male | Female deriving (Eq,Show)

data Sender = Sender {
    qq :: Maybe Int,
    nickname :: Maybe Text,
    sex :: Maybe Sex,
    age :: Maybe Int
} deriving (Eq,Show)

onPrivateMessage :: MessageFrom -> Sender -> Maybe Text
onPrivateMessage msgfrom sender = Just "nmsl"
