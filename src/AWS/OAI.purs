module AWS.OAI (
  OAI,
  createOAI,
  getOAI,
  tryIt,
  tryIt2,
  maybeReference,
  identity,
  canonical,
  comment
  ) where

import Prelude (Unit, bind, ($), class Show, (<>), show, when)
import Data.Maybe (Maybe (..))
import Prim (Array)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (Error)
import Control.Monad.Aff (Aff, makeAff)
import Control.Monad.Aff.Console(logShow, log, CONSOLE)
import AWS (AWS)

-- an OAI value that can be used outside this module
foreign import data OAI :: *

foreign import referenceImpl :: Maybe String -> (String -> Maybe String) -> OAI -> Maybe String
maybeReference :: OAI -> Maybe String
maybeReference = referenceImpl Nothing Just
foreign import identity :: OAI -> String
foreign import canonical :: OAI -> String
foreign import comment :: OAI -> String

instance showOAI :: Show OAI where
  show x =  identity x <> " " <>
            canonical x <> " " <>
            comment x <> " " <>
            show (maybeReference x)

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
  String ->
  Eff (aws :: AWS | eff) Unit
-- createOAIImpl errorHandler successHandler reference comment

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

createOAI :: forall eff.
  String ->
  String ->
  Aff (aws :: AWS | eff) OAI
createOAI referencestr commentstr = makeAff
  (\error success -> createOAIImpl error success referencestr commentstr)

getOAI :: forall eff. String -> Aff (aws :: AWS | eff) OAI
getOAI identitystr = makeAff
  (\error success -> getOAIImpl error success identitystr)

listOAIs :: forall eff. Aff (aws :: AWS | eff) OAIPage
listOAIs = makeAff (\error success -> listOAIsImpl error success)

listMoreOAIs :: forall eff. OAIPage -> Aff (aws :: AWS | eff) OAIPage
listMoreOAIs page = makeAff (\error success -> listMoreOAIsImpl error success page)

tryIt :: forall eff. String -> Aff (console :: CONSOLE, aws :: AWS | eff) Unit
tryIt clid = do
  log "here we go"
  got <- createOAI clid "Created in tryIt"
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
