{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Rank2Types #-}

module Main where

import           Prelude
import           Control.Monad      (forever, (>=>))
import           Data.Monoid        ((<>))
import           Data.String        (fromString)
import qualified Data.Text          as T
import qualified Network.WebSockets as WS
import           Network.Wai.Handler.Warp as WP
import           Network.Wai.Application.Static 
import           WaiAppStatic.Types (unsafeToPiece)
import           Control.Concurrent

main :: IO ()
main = do
  print $ "Listening on " <> host <> ":" <> show wsPort
  forkIO $ WS.runServer host wsPort (WS.acceptRequest >=> ohce)
  let warpSettings = WP.setPort serverPort $ WP.setHost (fromString host) WP.defaultSettings
  WP.runSettings warpSettings $ staticApp $ (defaultWebAppSettings "/public_html") {ssIndices = [unsafeToPiece "index.html"]}
  where
    host = "0.0.0.0"
    serverPort = 8080
    wsPort = 9160

ohce :: WS.Connection -> IO ()
ohce conn = forever $ do
  msg <- WS.receiveData conn
  print $ "Received: " <> msg
  WS.sendTextData conn (T.reverse msg :: T.Text)
