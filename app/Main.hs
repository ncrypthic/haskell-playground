{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Authentication.User
import Database.MySQL.Base

main :: IO ()
-- main = putStrLn "Hello world"
-- main = putStrLn $ spec "Hello"
-- main = map putStrLn [spec "Hello"]
-- main = fmap putStrLn spec "Hello"
main = do
    _ <- putStrLn $ spec "Hello"
    conn <- connect
        defaultConnectInfo { ciUser = "root", ciPassword = "asdf", ciDatabase = "erp" }
    id <- getLine
    res <- findUserById conn id
    print res
