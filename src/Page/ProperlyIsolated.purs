module Page.ProperlyIsolated
  ( component
  , Input
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Class (class MonadEffect)
import Effect.Class.Console (log)
import Halogen as H
import Halogen.HTML as HH
import Page.ProperlyIsolated.Query (Query(..))

type Input = {}

component :: Unit -> forall m. MonadEffect m => H.Component Query Input Void m
component _ = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval { handleQuery = handleQuery }
  }
  where
  initialState = identity

  handleQuery :: forall a. Query a -> H.HalogenM _ _ _ _ _ (Maybe a)
  handleQuery = case _ of
    Query next -> do
      log "Got query in isolated"
      pure $ Just next

  render _ = HH.div [] [ HH.text "Properly isolated" ]
