module TestList where

import Test
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL

type alias Model =
    { tests : List ( ID, Test.Model )
    , nextID : ID
    }

type alias ID = Int


init : Model
init =
    { tests = []
    , nextID = 0
    }


-- UPDATE

type Action
    = StartTests
    | Modify ID Test.Action


update : Action -> Model -> Model
update action model =
  case action of
    StartTests ->
      -- start the tests!
      {-
      let newTest = ( model.nextID, Test.init 0 )
          newTests = model.tests ++ [ newTest ]
      in
          { model |
              tests = newTests,
              nextID = model.nextID + 1
          }
      -}
      model
    Modify id testAction ->
      let updateTest (testID, testModel) =
              if testID == id then
                  (testID, Test.update testAction testModel)
              else
                  (testID, testModel)
      in
          { model | tests = List.map updateTest model.tests }


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
