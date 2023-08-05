module Page.NotIsolated
  ( component
  , Input
  , Query(..)
  ) where

import Prelude

import Halogen as H
import Halogen.HTML as HH

type Input = {}

data Query a = Query a

component :: Unit -> forall m. H.Component Query Input Void m
component _ = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval
  }
  where
  initialState = identity

  render _ = HH.div [] [ HH.text "Not isolated" ]
