module Send where

import Prelude ((<>), ($), Unit, unit, bind, pure)
import Node.Stream (end, onData, onDataString)
import Node.Encoding (Encoding(..))
import Node.HTTP (HTTP)
import Node.HTTP.Client (
    RequestOptions,
    protocol,
    hostname,
    path,
    method,
    request,
    Request,
    Response,
    statusCode,
    requestAsStream,
    responseAsStream
  )
import Data.Options (Options, (:=))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log, logShow)
import Control.Monad.Eff.Exception (EXCEPTION)

opts :: Options RequestOptions
opts = protocol := "https:"
  <>   hostname := "gregwiley.com"
  <>   path := "/"
  <>   method := "GET"


go :: forall eff. Eff (http :: HTTP, console :: CONSOLE, err :: EXCEPTION | eff) Request
go = do
  rq <- request opts handle
  end (requestAsStream rq) (pure unit)
  pure rq


handle :: forall eff.
  Response ->
  Eff (http :: HTTP, console :: CONSOLE, err :: EXCEPTION | eff) Unit
handle resp = do
  logShow $ statusCode resp
  let resps = responseAsStream resp
  onDataString resps UTF8 log
  log "hi"
  pure unit

-- request :: forall eff.
--   Options RequestOptions ->
--   (Response -> Eff (http :: HTTP | eff) Unit) ->
--   Eff (http :: HTTP | eff) Request
