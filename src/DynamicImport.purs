module DynamicImport where

import Prelude

import Control.Promise (Promise, fromAff)
import Effect (Effect)

dynamicImport :: forall a. a -> Effect (Promise a)
dynamicImport = pure >>> fromAff
