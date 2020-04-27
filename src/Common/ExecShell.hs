{-# LANGUAGE OverloadedStrings #-}

module Common.ExecShell(
    execShell
)where

import Data.Text
import Web.Scotty
import System.Process
import GHC.IO.Handle

execShell :: Text -> ActionM Text
execShell sh = do
    liftAndCatchIO $ do
        (_,Just hout,_,_) <- createProcess (proc (Data.Text.unpack sh) []) { std_out = CreatePipe }
        txt <- hGetContents hout
        return $ Data.Text.pack txt
