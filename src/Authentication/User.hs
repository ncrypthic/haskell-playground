{-# LANGUAGE OverloadedStrings #-}
module Authentication.User
    ( register
    , findUserById
    , userName
    ) where

import Data.Maybe (Maybe)
import Control.Monad
import System.IO
import Database.MySQL.Base
import qualified System.IO.Streams as Streams

data User = User {
                username::String,
                password::String,
                email::String } deriving (Eq, Show, Ord)

userName :: User -> String
userName (User username _ _) = username

makeUser :: String -> String -> String -> User
makeUser uname passwd email = User{username=uname, password=passwd, email=email}

register :: User -> Maybe User
register user = Nothing

findUserById :: MySQLConn -> String -> IO (Maybe User)
findUserById conn id = do
    (columnDefs, rows) <- query_ conn "SELECT UserName, Password FROM TblUser LIMIT 1"
    let users = rows >>= (\_ -> makeUser "t" "t" "t") rows
    let user = head users
    return Just(user)
