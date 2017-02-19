module OAI (createOAI, tryIt, tryIt2) where

import Prelude (Unit, bind, ($), (<>))

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception(Error)
import Control.Monad.Aff (Aff, makeAff, attempt)
import Control.Monad.Aff.Console(logShow, log, CONSOLE)

foreign import createOAIImpl :: forall eff.
  (Error -> Eff eff Unit) ->
  (String -> Eff eff Unit) ->
  String ->
  Eff eff Unit

createOAI :: forall eff. String -> Aff eff String
createOAI req = makeAff
  (\error success -> createOAIImpl error success req)

tryIt :: forall eff. Aff (console :: CONSOLE | eff) Unit
tryIt = do
  out <- createOAI "Hi!"
  log ("got: " <> out)

tryIt2 :: forall eff. Aff (console :: CONSOLE | eff) Unit
tryIt2 = do
  log "wot?"
  out <- attempt $ createOAI "Boink"
  logShow out
