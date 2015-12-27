module TestList where

import Test
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal
import Effects

-- MODEL

type alias Model =
    { startmbx: Signal.Mailbox () 
    , tests : List ( ID, Test.Model )
    , nextID : ID
    }

type alias ID = Int


init : Signal () -> Model
init sig =
    { startmbx = Signal.mailbox sig
    , tests = []
    , nextID = 0
    }


-- UPDATE

type Action
    = StartTests
    | Modify ID Test.Action



update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case action of
    StartTests ->
      -- start the tests!
      -- let mbx = Signal.mailbox model.startsig in
      
      {-
      let newTest = ( model.nextID, Test.init 0 )
          newTests = model.tests ++ [ newTest ]
      in
          { model |
              tests = newTests,
              nextID = model.nextID + 1
          }
      -}
      (model, Signal.send model.mbx ())
    Modify id testAction ->
      let updateTest (testID, testModel) =
              if testID == id then
                  (testID, Test.update testAction testModel)
              else
                  (testID, testModel)
      in
         ({ model | tests = List.map updateTest model.tests },
          Effects.none)


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let tests = List.map (viewTest address) model.tests
      start = button [ onClick address StartTests ] [ text "Start Tests" ]
  in
      div [] ([start] ++ tests)


viewTest : Signal.Address Action -> (ID, Test.Model) -> Html
viewTest address (id, model) =
  Test.view (Signal.forwardTo address (Modify id)) model
