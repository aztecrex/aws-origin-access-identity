module Handler(handler) where

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Console (CONSOLE, log, logShow)
import Prelude(Unit, unit, pure, bind)
import AWSLambda (FUNCTION,Context)
import Resource(Request)

handler ::
  Context ->
  Request ->
  Eff (function :: FUNCTION, console :: CONSOLE) Unit
handler _ request = do
  log "entered the handler"
  logShow request
  pure unit
