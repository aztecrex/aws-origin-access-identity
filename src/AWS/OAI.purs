module AWS.OAI (
  OAI,
  createOAI,
  getOAI,
  tryIt,
  reference,
  identity,
  canonical
  ) where

import Prelude (Unit, bind, ($), class Show, (<>))

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Aff (Aff, makeAff, attempt)
import Control.Monad.Aff.Console(logShow, log, CONSOLE)
import AWS (AWS)

foreign import data OAI :: *

foreign import reference :: OAI -> String
foreign import identity :: OAI -> String
foreign import canonical :: OAI -> String

instance showOAI :: Show OAI where
  show x = reference x <> " " <> identity x <> " " <> canonical x



foreign import createOAIImpl :: forall eff.
  (Error -> Eff (aws :: AWS | eff) Unit) ->
  (OAI -> Eff (aws :: AWS | eff) Unit) ->
  String ->
  Eff (aws :: AWS | eff) Unit
-- createOAIImpl errorHandler successHandler reference

foreign import getOAIImpl :: forall eff.
  (Error -> Eff (aws :: AWS | eff) Unit) ->
  (OAI -> Eff (aws :: AWS | eff) Unit) ->
  String ->
  Eff (aws :: AWS | eff) Unit
-- getOAIImpl errorHandler successHandler identity

createOAI :: forall eff. String -> Aff (aws :: AWS | eff) OAI
createOAI reference = makeAff
  (\error success -> createOAIImpl error success reference)

getOAI :: forall eff. String -> Aff (aws :: AWS | eff) OAI
getOAI identity = makeAff
  (\error success -> createOAIImpl error success identity)

tryIt :: forall eff. String -> Aff (console :: CONSOLE, aws :: AWS | eff) Unit
tryIt clid = do
  log "here we go"
  got <- createOAI clid
  out <- getOAI (identity got)
  logShow out
