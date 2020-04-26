{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module Modules.Link(
    echoTitle
)where

import Data.Text
import Data.Monoid
import Data.Aeson
import qualified Data.ByteString.Lazy as BS
import Web.Scotty
import Network.HTTP.Req
import Text.HTML.DOM
import Text.XML
import Text.XML.Cursor
import Text.URI
import Control.Monad.Catch
import Control.Monad.Trans.Maybe
import Data.Functor.Identity
import qualified Resolvers.GroupMessage as RGM

handleParseError :: ParseException -> MaybeT ActionM URI
handleParseError e = MaybeT $ return Nothing

getURI :: Text -> MaybeT ActionM URI
getURI lnk = mkURI lnk `catch` handleParseError

getHTMLTitle :: Document -> Text
getHTMLTitle doc = Data.Text.concat $ cur $/ element "head" &/ element "title" &// content
    where cur = fromDocument doc

instance MonadHttp (MaybeT ActionM) where
    handleHttpException httperr = MaybeT $ return Nothing

getHTMLFromURI :: URI -> MaybeT ActionM BS.ByteString
getHTMLFromURI uri = do
    case useURI uri of
        --for http
        (Just (Left  (url,opts))) -> do
            resbody <- req GET url NoReqBody lbsResponse mempty
            return $ responseBody resbody
        --for https
        (Just (Right (url,opts))) -> do
            resbody <- req GET url NoReqBody lbsResponse mempty
            return $ responseBody resbody
        --Cant resolve URI
        _ -> MaybeT $ return Nothing


echoTitle :: RGM.MessageInfo -> ActionM ()
echoTitle msginfo = do
    title <- runMaybeT $ do
        uri <- getURI $ RGM.message msginfo
        htmlbs <- getHTMLFromURI uri
        return $ getHTMLTitle $ Text.HTML.DOM.parseLBS htmlbs
    case title of
        Nothing -> return ()
        (Just t) -> raw (encode RGM.Reply {
           RGM.reply = t,
           RGM.auto_escape = False,
           RGM.at_sender = False,
           RGM.delete = False,
           RGM.kick = False,
           RGM.ban = False,
           RGM.ban_duration = 0
        }) >> finish
