module Main where

import Prelude

import Control.Promise (toAffE)
import Data.Maybe (Maybe(..))
import Data.NoQuery (NoQuery)
import DynamicImport (dynamicImport)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import GetAString (class GetAString)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)
import Network.RemoteData (RemoteData(..))
import Page.About as About
import Page.Admin as Admin
import Page.NotIsolated as NotIsolated
import Page.NotIsolated (Query(..))
import Page.WithTypeClass as WithTypeClass
import Type.Prelude (Proxy(..))

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI component unit body

type Input = Unit

data Action
  = Initialize
  | LoadAbout
  | LoadAdmin
  | LoadWithTypeClass
  | LoadNotIsolated
  | SendQuery

data Route m
  = About (RemoteData Unit (H.Component NoQuery {} Void m))
  | Admin (RemoteData Unit (H.Component NoQuery {} Void m))
  | WithTypeClass (RemoteData Unit (H.Component NoQuery {} Void m))
  | NotIsolated (RemoteData Unit (H.Component NotIsolated.Query {} Void m))

type State m = Route m

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
  initialState _ = About NotAsked

  handleAction :: Action -> H.HalogenM (State m) Action _ _ m _
  handleAction = case _ of
    Initialize -> do
      lazyComponent <- liftAff $ toAffE (dynamicImport About.component)
      void $ H.put $ About $ Success $ lazyComponent unit
      pure unit

    LoadAbout -> handleAction Initialize

    LoadAdmin -> do
      lazyComponent <- liftAff $ toAffE (dynamicImport Admin.component)
      void $ H.put $ Admin $ Success $ lazyComponent unit
      pure unit

    LoadWithTypeClass -> do
      lazyComponent <- liftAff $ toAffE (dynamicImport WithTypeClass.component)
      void $ H.put $ WithTypeClass $ Success $ lazyComponent unit
      pure unit

    LoadNotIsolated -> do
      lazyComponent <- liftAff $ toAffE (dynamicImport NotIsolated.component)
      void $ H.put $ NotIsolated $ Success $ lazyComponent unit
      H.tell (Proxy :: _ "not-isolated") unit NotIsolated.Query
      pure unit

    SendQuery -> do
      H.tell (Proxy :: _ "not-isolated") unit Query

  render route = HH.div []
    [ HH.div []
        [ HH.button [ HE.onClick \_ -> LoadAdmin ] [ HH.text "Load Admin" ]
        , HH.button [ HE.onClick \_ -> LoadWithTypeClass ] [ HH.text "Load WithTypeClass" ]
        , HH.button [ HE.onClick \_ -> LoadNotIsolated ] [ HH.text "Load Not isolated" ]
        , HH.button [ HE.onClick \_ -> SendQuery ] [ HH.text "Send query" ]
        ]
    , case route of
        About (Success c) ->
          HH.slot_ (Proxy :: _ "about") unit c {}

        Admin (Success c) ->
          HH.slot_ (Proxy :: _ "admin") unit c {}

        WithTypeClass (Success c) ->
          HH.slot_ (Proxy :: _ "with-typeclass") unit c {}

        NotIsolated (Success c) ->
          HH.slot_ (Proxy :: _ "not-isolated") unit c {}

        _ -> HH.text "Loading"
    ]
