module Page.Admin (admin, Input) where

import Prelude

import Data.NoQuery (NoQuery)
import Halogen as H
import Halogen.HTML as HH

type Input = {}

admin :: Unit -> forall m. H.Component NoQuery Input Void m
admin _ = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval
  }
  where
  initialState = identity

  render _ = HH.div [] [ HH.text "Admin" ]
