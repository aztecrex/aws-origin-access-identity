module AWS.OAI (
  OAI,
  createOAI,
  getOAI,
  tryIt,
  tryIt2,
  reference,
  identity,
  canonical
  ) where

import Prelude (Unit, bind, ($), class Show, (<>), show, when)

import Prim (Array)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Aff (Aff, makeAff, attempt)
import Control.Monad.Aff.Console(logShow, log, CONSOLE)
import AWS (AWS)

-- an OAI value that can be used outside this module
foreign import data OAI :: *

foreign import reference :: OAI -> String
foreign import identity :: OAI -> String
foreign import canonical :: OAI -> String

instance showOAI :: Show OAI where
  show x = reference x <> " " <> identity x <> " " <> canonical x

-- page of OAIs from native call, don't export this
foreign import data OAIPage :: *

foreign import more :: OAIPage -> Boolean

foreign import unpage :: OAIPage -> Array OAI

foreign import showData :: forall d. d -> String

instance showOAIPage :: Show OAIPage where
  show = showData

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

foreign import listOAIsImpl :: forall eff.
  (Error -> Eff (aws :: AWS | eff) Unit) ->
  (OAIPage -> Eff (aws :: AWS | eff) Unit) ->
  Eff (aws :: AWS | eff) Unit
-- listOAIsImpl errorHandler successHandler

foreign import listMoreOAIsImpl :: forall eff.
  (Error -> Eff (aws :: AWS | eff) Unit) ->
  (OAIPage -> Eff (aws :: AWS | eff) Unit) ->
  OAIPage ->
  Eff (aws :: AWS | eff) Unit
-- listOAIsImpl errorHandler successHandler

createOAI :: forall eff. String -> Aff (aws :: AWS | eff) OAI
createOAI reference = makeAff
  (\error success -> createOAIImpl error success reference)

getOAI :: forall eff. String -> Aff (aws :: AWS | eff) OAI
getOAI identity = makeAff
  (\error success -> getOAIImpl error success identity)

listOAIs :: forall eff. Aff (aws :: AWS | eff) OAIPage
listOAIs = makeAff (\error success -> listOAIsImpl error success)

listMoreOAIs :: forall eff. OAIPage -> Aff (aws :: AWS | eff) OAIPage
listMoreOAIs page = makeAff (\error success -> listMoreOAIsImpl error success page)

tryIt :: forall eff. String -> Aff (console :: CONSOLE, aws :: AWS | eff) Unit
tryIt clid = do
  log "here we go"
  got <- createOAI clid
  logShow got
  out <- getOAI (identity got)
  logShow out

tryIt2 :: forall eff. Aff (console :: CONSOLE, aws ::AWS | eff) Unit
tryIt2 = do
  log "getting a list"
  got <- listOAIs
  logShow got
  log ("more? " <> (show $ more got))
  logShow $ unpage got
  when (more got) do
    gotmore <- listMoreOAIs got
    logShow gotmore
    log ("more? " <> (show $ more gotmore))
