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
        let cmdWithArgs = Prelude.map (Data.Text.unpack) $ Data.Text.words sh
        let cmd = Prelude.head cmdWithArgs
        let args = Prelude.drop 1 cmdWithArgs
        (_,Just hout,_,_) <- createProcess (proc cmd args) { std_out = CreatePipe }
        txt <- hGetContents hout
        return $ Data.Text.pack txt
