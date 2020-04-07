{-# LANGUAGE OverloadedStrings #-}

module Dispatcher(
    dispatch
)where

import Data.Aeson
import Data.Text
import qualified Data.HashMap.Lazy as HM
import Web.Scotty

dispatch :: Object -> ActionM ()
dispatch obj = undefined
