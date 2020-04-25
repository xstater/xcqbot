{-# LANGUAGE OverloadedStrings #-}

module Modules.Link(
    echoTitle
)where

import Data.Text
import Data.Monoid
import Data.Aeson
import Web.Scotty
import Network.HTTP.Req
import Text.HTML.DOM
import Text.XML
import Text.XML.Cursor
import qualified Resolvers.GroupMessage as RGM



getLinkHTML :: Text -> ActionM Document
getLinkHTML lnk = do
    bs <- runReq defaultHttpConfig $ do
        resBody <- req GET (https lnk) NoReqBody lbsResponse mempty
        return $ responseBody resBody
    return $ Text.HTML.DOM.parseLBS bs

getHTMLTitle :: Document -> ActionM Text
getHTMLTitle doc = do
    let cur = fromDocument doc
    return $ Data.Text.concat $ cur $/ element "head" &/ element "title" &// content
        

echoTitle :: RGM.MessageInfo -> ActionM ()
echoTitle msginfo = do
    html <- getLinkHTML $ RGM.message msginfo
    title <- getHTMLTitle html
    raw $ encode RGM.Reply{
        RGM.reply = title,
        RGM.auto_escape = False,
        RGM.at_sender = False,
        RGM.delete = False,
        RGM.kick = False,
        RGM.ban = False,
        RGM.ban_duration = 0
    }
