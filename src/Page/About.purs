module Page.About (component, Input) where

import Prelude

import Data.NoQuery (NoQuery)
import Halogen as H
import Halogen.HTML as HH

type Input = {}

component :: Unit -> forall m. H.Component NoQuery Input Void m
component _ = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval
  }
  where
  initialState = identity

  render _ = HH.div [] [ HH.text "About" ]
