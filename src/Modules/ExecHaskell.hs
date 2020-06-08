{-# LANGUAGE OverloadedStrings #-}

module Modules.ExecHaskell(
    execHaskellGroup,
    execHaskellPrivate
)where

import Data.Text
import Data.Aeson
import Web.Scotty
import qualified Resolvers.Resolver as R
import qualified Resolvers.GroupMessage as RGM
import qualified Resolvers.PrivateMessage as RPM
import Language.Haskell.Interpreter

parseCmd :: Text -> Maybe String
parseCmd text = (Data.Text.unpack . (Data.Text.replace "&#93;" "]") . (Data.Text.replace "&#91;" "[")) `fmap` Data.Text.stripPrefix "hs " text

imports :: [String]
imports = [
    "Prelude",
    "Data.Aeson",
    "Control.Monad",
    "Control.Monad.Except",
    "Control.Monad.Identity",
    "Control.Monad.List",
    "Control.Monad.Reader",
    "Control.Monad.State",
    "Control.Monad.Trans",
    "Control.Monad.Writer",
    "Chronos",
    "Modules.ExecHaskell.Utility"]

execHaskellGroup :: R.Message a => a -> ActionM ()
execHaskellGroup msginfo = do
    case parseCmd $ R.getMessage msginfo of
        (Just code) -> do
            result <- liftIO $ runInterpreter $ do
                setImports imports
                eval code
            case result of
                (Left err) -> raw $ encode $ (R.replyMessage $ Data.Text.pack $ show err :: RGM.Reply)
                (Right msg) -> raw $ encode $ (R.replyMessage $ Data.Text.pack msg :: RGM.Reply)
            finish
        Nothing -> return ()

execHaskellPrivate :: R.Message a => a -> ActionM ()
execHaskellPrivate msginfo = do
    case parseCmd $ R.getMessage msginfo of
        (Just code) -> do
            liftIO $ print code
            result <- liftIO $ runInterpreter $ do
                setImports imports 
                eval code
            case result of
                (Left err) -> raw $ encode $ (R.replyMessage $ Data.Text.pack $ show err :: RPM.Reply)
                (Right msg) -> raw $ encode $ (R.replyMessage $ Data.Text.pack msg :: RPM.Reply)
            finish
        Nothing -> return ()