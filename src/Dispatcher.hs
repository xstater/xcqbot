{-# LANGUAGE OverloadedStrings #-}

module Dispatcher(
    dispatch
)where

import Data.Aeson
import Data.Text
import Control.Monad
import qualified Data.HashMap.Lazy as HM
import Web.Scotty
import Callbacks.PrivateMessage

dispatch :: Object -> ActionM ()
dispatch obj = do
    text $ isPrivateMessageM obj >> onPrivateMessage FromFriend (Sender { qq = Nothing,nickname = Nothing ,sex = Nothing,age = Nothing})
    return ()
