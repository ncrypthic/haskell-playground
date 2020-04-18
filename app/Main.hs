{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Authentication.User
import Database.MySQL.Base
import Lim.Echo

main :: IO ()
main = do
    _ <- putStrLn $ spec "Hello"
    conn <- connect
        defaultConnectInfo { ciUser = "root", ciPassword = "asdf", ciDatabase = "erp" }
    res <- findUserById conn "asd"
    case res of
      Just user -> putStrLn $ userName user
      _ -> putStrLn "Nothing"
