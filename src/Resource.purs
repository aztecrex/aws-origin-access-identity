module Resource where

import Prelude(class Show)

foreign import showData :: forall a. a -> String

foreign import data Request :: *

instance showRequest :: Show Request where
  show = showData
