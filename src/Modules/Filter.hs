{-# LANGUAGE OverloadedStrings #-}

module Modules.Filter (
    filteQQ,
    filteGroup
)where

import Data.List
import Web.Scotty

qqs :: [Int]
qqs = [1209635268]

groups :: [Int]
groups = [795831442,516482852]

filteQQ :: Int -> ActionM ()
filteQQ qq = if qq `elem` qqs then return () else finish

filteGroup :: Int -> ActionM ()
filteGroup group = if group `elem` groups then return () else finish
