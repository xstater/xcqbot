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
import Modules.Help
import Modules.ShowTemp
import Modules.ShowCPUInfo
import Modules.SayWhat
import Modules.ExecHaskell

onGroupMessage :: RGM.MessageInfo -> ActionM ()
onGroupMessage msginfo = do
    filteGroup $ RGM.group_id msginfo
    helpGroup msginfo 
    showTempGroup msginfo
    showCPUInfoGroup msginfo
    echoTitle msginfo  
    sayWhatGroup msginfo
    --echoGroupMessage msginfo
    execHaskellGroup msginfo


