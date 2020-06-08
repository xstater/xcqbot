module Modules.ExecHaskell.Utility(
    unsafe,
    timeNow
)where

import System.IO.Unsafe
import Data.Aeson
import Chronos

unsafe :: IO a -> a
unsafe = unsafePerformIO

timeNow :: IO Value
timeNow = (toJSON . timeToDatetime) `fmap` now