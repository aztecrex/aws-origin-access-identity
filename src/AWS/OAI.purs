module OAI (createOAI, tryIt) where

import Prelude (Unit, bind, ($), (<>))

import Control.Monad.Eff (Eff)
import Control.Monad.Aff (Aff, makeAff)
import Control.Monad.Aff.Console(log, CONSOLE)

foreign import createOAIImpl :: forall eff.
  (String -> Eff eff Unit) ->
  String ->
  Eff eff Unit

createOAI :: forall eff. String -> Aff eff String
createOAI req = makeAff (\error success -> createOAIImpl success req)

tryIt :: forall eff. Aff (console :: CONSOLE | eff) Unit
tryIt = do
  out <- createOAI "Hi!"
  log ("got: " <> out)
