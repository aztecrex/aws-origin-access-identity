module AWS.OAI (OAI, createOAI, tryIt) where

import Prelude (Unit, bind, ($), class Show, (<>))

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Aff (Aff, makeAff, attempt)
import Control.Monad.Aff.Console(logShow, log, CONSOLE)
import AWS (AWS)

foreign import data OAI :: *

foreign import reference :: OAI -> String
foreign import principal :: OAI -> String
foreign import canonical :: OAI -> String

instance showOAI :: Show OAI where
  show x = reference x <> " " <> principal x <> " " <> canonical x



foreign import createOAIImpl :: forall eff.
  (Error -> Eff (aws :: AWS | eff) Unit) ->
  (OAI -> Eff (aws :: AWS | eff) Unit) ->
  String ->
  Eff (aws :: AWS | eff) Unit


createOAI :: forall eff. String -> Aff (aws :: AWS | eff) OAI
createOAI req = makeAff
  (\error success -> createOAIImpl error success req)




tryIt :: forall eff. String -> Aff (console :: CONSOLE, aws :: AWS | eff) Unit
tryIt clid = do
  log "here we go"
  out <- attempt $ createOAI clid
  logShow out
