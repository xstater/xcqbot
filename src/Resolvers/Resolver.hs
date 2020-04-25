{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}

module Resolvers.Resolver(
    Resolvable(resolve),
    getItem,
    getPostType,
    getMessageType,
    getNoticeType,
    getRequestType,
    getSubType,
    eqStringM
)where

import Data.Scientific
import Data.Text
import Data.Aeson
import Data.HashMap.Lazy as HM
import Control.Monad

class Resolvable a where
    resolve :: Value -> Maybe a
    
instance Resolvable Scientific where
    resolve (Number n) = Just n
    resolve _ = Nothing 

instance Resolvable Double where
    resolve (Number n) = Just $ toRealFloat n
    resolve _ = Nothing

instance Resolvable Float where
    resolve (Number n) = Just $ toRealFloat n
    resolve _ = Nothing

instance Resolvable Int where
    resolve (Number n) = toBoundedInteger n
    resolve _ = Nothing

instance Resolvable Bool where
    resolve (Bool b) = Just b
    resolve _ = Nothing

instance Resolvable Text where
    resolve (String s) = Just s
    resolve _ = Nothing

instance Resolvable Object where
    resolve (Object o) = Just o
    resolve _ = Nothing

instance Resolvable Array where
    resolve (Array a) = Just a
    resolve _ = Nothing 

getItem :: Resolvable a => Text -> Object -> Maybe a
getItem k o = (HM.lookup k o) >>= resolve 

getPostType :: Object -> Maybe Text
getPostType = getItem "post_type"

getMessageType :: Object -> Maybe Text
getMessageType = getItem "message_type"

getNoticeType :: Object -> Maybe Text
getNoticeType = getItem "notice_type"

getRequestType :: Object -> Maybe Text
getRequestType = getItem "request_type"

getSubType :: Object -> Maybe Text
getSubType = getItem "sub_type"

eqStringM :: Text -> Text -> Maybe ()
eqStringM str1 str2 = if str1 == str2 then Just () else Nothing

