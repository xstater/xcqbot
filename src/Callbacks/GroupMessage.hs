{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Callbacks.GroupMessage (
    onGroupMessage
)where

import Data.Aeson
import Data.Text
import Data.Maybe
import Web.Scotty
import Control.Monad
import Data.ByteString.Lazy as BS
import qualified Resolvers.Resolver as R
import GHC.Generics
import Resolvers.GroupMessage as RGM
import Modules.Link
import Modules.Filter
import Modules.Echo


onGroupMessage :: RGM.MessageInfo -> ActionM ()
onGroupMessage msginfo = do
    filteGroup $ RGM.group_id msginfo
    echoTitle msginfo  
    echoGroupMessage msginfo


