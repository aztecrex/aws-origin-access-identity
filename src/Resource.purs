module Resource (
  class Resource,
  class New,
  class Existing,
  physicalId,
  stackName,
  logicalName,
  succeed,
  fail,
  onCreate,
  onDelete,
  onUpdate,
  properties,
  Request
  ) where

import Prelude (class Show, Unit)
import Control.Monad.Eff (Eff)
import Data.Foreign (Foreign)

foreign import showData :: forall a. a -> String

foreign import data Request :: *

class Resource r where
  onCreate :: forall req eff. New req =>
              (req -> Eff eff Unit) -> Eff eff req
  onUpdate :: forall req eff. Existing req =>
              (req -> Eff eff Unit) -> Eff eff req
  onDelete :: forall req eff. Existing req =>
              (req -> Eff eff Unit) -> Eff eff req
  succeed :: forall eff. String -> Eff eff Unit
  fail :: forall eff. String -> Eff eff Unit

class New r where
  stackName :: r -> String
  logicalName :: r -> String
  properties :: r -> Foreign

class New r <= Existing r  where
  physicalId :: r -> String

instance showRequest :: Show Request where
  show = showData
