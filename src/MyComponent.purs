module MyComponent where

import Prelude

import AClass (class GetAString, getAString)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class.Console (log)
import Halogen as H
import Halogen.HTML as HH

type Input = {}

type State = { aString :: String }

data Action = Initialize

data Query a = NoQuery a

component
  :: Unit
  -> forall m
   . GetAString m
  => MonadAff m
  => H.Component Query Input Void m
component _ = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval
      { initialize = Just Initialize
      , handleAction = handleAction
      }
  }
  where
  initialState :: Input -> State
  initialState _ = { aString: "" }

  handleAction = case _ of
    Initialize -> do
      void $ log "Something in the console"
      aString <- getAString
      H.modify_ _ { aString = aString }

  render { aString } = HH.text aString
