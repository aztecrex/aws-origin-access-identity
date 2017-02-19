module Handler(handler) where

import Control.Monad.Eff(Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Foreign(Foreign)
import Prelude(Unit, unit, pure, bind)
import AWSLambda (FUNCTION,Context)

handler ::
  Context ->
  Foreign ->
  Eff (function :: FUNCTION, console :: CONSOLE) Unit
handler _ _ = do
  log "entered the handler"
  pure unit
