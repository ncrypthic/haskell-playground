{-# LANGUAGE OverloadedStrings #-}
module Authentication.User
    ( findUserById
    , userName
    ) where

import Data.Maybe
import Control.Monad
import System.IO
import Data.Text (unpack, pack)
import Database.MySQL.Base
import qualified System.IO.Streams as Streams
import System.IO.Streams (InputStream)

class Serializable m where
    serialize :: m -> Maybe [MySQLValue]
    unserialize :: [MySQLValue] -> Maybe m

data User = User {userName::String,
                  password::String,
                  email::String } deriving (Eq, Show, Ord)

instance Serializable User where
    serialize (User uname pass email) = Just(MySQLText . pack <$> [uname, pass, email])
    unserialize [MySQLText uname, MySQLText pass, MySQLText email] =  Just (User (unpack uname) (unpack pass) (unpack email))
    unserialize [] = Nothing

-- TODO: Itchy
-- unwrap :: [MySQLValue] -> Maybe User
-- unwrap xs = case xs of
--               [uname, pass, x] -> Just(UserRecord uname pass x)
--               [] ->  Nothing

findUserById :: MySQLConn -> String -> IO (Maybe User)
findUserById conn id = do
    (columnDefs, inputStream) <- query conn "SELECT UserName, Password, UserName FROM TblUser WHERE UserName = ? LIMIT 1" [MySQLText (pack id)]
    row <- Streams.read inputStream
    return (row >>= unserialize)
