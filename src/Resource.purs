module Resource where

import Prelude (class Show)
import Node.URL (parse, URL)

foreign import showData :: forall a. a -> String

foreign import data Request :: *

instance showRequest :: Show Request where
  show = showData
