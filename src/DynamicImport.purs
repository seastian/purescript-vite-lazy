module DynamicImport where

import Control.Promise (Promise)
import Effect (Effect)
import Unsafe.Coerce (unsafeCoerce)

dynamicImport :: forall a. a -> Effect (Promise a)
dynamicImport = unsafeCoerce
