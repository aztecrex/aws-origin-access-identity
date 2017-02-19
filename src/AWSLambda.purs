module AWSLambda (
  Context,
  FUNCTION,
  succeed,
  fail
  ) where

import Prelude (Unit)
import Control.Monad.Eff (Eff)

foreign import data Context :: *

foreign import data FUNCTION :: !

foreign import succeed :: forall eff.
  Context ->
  String ->
  Eff (function :: FUNCTION | eff) Unit

foreign import fail :: forall eff.
  Context ->
  String ->
  Eff (function :: FUNCTION | eff) Unit
