module GetAString where

import Prelude

import Control.Monad.Trans.Class (lift)
import Effect.Aff (Aff)
import Halogen (HalogenM)

class Monad m <= GetAString m where
  getAString :: m String

instance GetAString m => GetAString (HalogenM st act slots msg m) where
  getAString = lift getAString

instance GetAString Aff where
  getAString = pure "a string from Aff"
