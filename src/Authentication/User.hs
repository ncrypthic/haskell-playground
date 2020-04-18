{-# LANGUAGE OverloadedStrings #-}
module Authentication.User
    ( register
    , findUserById
    , userName
    ) where

import Data.Maybe
import Control.Monad
import System.IO
import Data.Text
import Database.MySQL.Base
import qualified System.IO.Streams as Streams

data User = User { username::String
            , password::String
            , email::String } deriving (Eq, Show, Ord)

userName :: User -> String
userName (User username _ _) = username

makeUser :: String -> String -> String -> User
makeUser uname passwd email = User{username=uname, password=passwd, email=email}

mapUser :: Text -> Text -> Text -> User
mapUser uname passwd email = User{username=unpack uname, password=unpack passwd, email= unpack email}

register :: User -> Maybe User
register user = Nothing

-- TODO: Itchy
unwrap :: [MySQLValue] -> Maybe User
unwrap xs =  case xs of {
                 ; [MySQLText uname, MySQLText pass, MySQLText x] -> Just(mapUser uname pass x)
                 ; _ ->  Nothing
               }

findUserById :: MySQLConn -> String -> IO (Maybe User)
findUserById conn id = do
    (columnDefs, inputStream) <- query_ conn "SELECT UserName, Password, UserName FROM TblUser LIMIT 1"
    row <- Streams.read inputStream
    return (row >>= unwrap)
