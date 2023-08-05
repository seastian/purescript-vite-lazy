module Main where

import Prelude

import AClass (class GetAString)
import Control.Promise (toAffE)
import Data.Maybe (Maybe(..))
import DynamicImport (dynamicImport)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)
import MyComponent as MyComponent
import Network.RemoteData (RemoteData(..))
import Type.Prelude (Proxy(..))

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI component unit body

type Input = Unit

data Action = Initialize

type State m = { page :: RemoteData Unit (H.Component MyComponent.Query {} Void m) }

component :: forall q o m. MonadAff m => GetAString m => H.Component q Input o m
component = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval
      { initialize = Just Initialize
      , handleAction = handleAction
      }
  }
  where
  initialState _ = { page: NotAsked }

  handleAction :: Action -> H.HalogenM (State m) Action _ _ m _
  handleAction = case _ of
    Initialize -> do
      lazyComponent <- liftAff $ toAffE (dynamicImport MyComponent.component)
      void $ H.put { page: Success $ lazyComponent unit }
      pure unit

  render { page } = HH.div []
    [ HH.div [] [ HH.text "Something" ]
    , case page of
        Success c ->
          HH.slot_ (Proxy :: _ "child") unit c {}
        _ -> HH.text "Loading"
    ]
