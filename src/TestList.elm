module TestList where

import Test
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL

type alias Model =
    { Tests : List ( ID, Test.Model )
    , nextID : ID
    }

type alias ID = Int


init : Model
init =
    { Tests = []
    , nextID = 0
    }


-- UPDATE

type Action
    = Insert
    | Remove
    | Modify ID Test.Action


update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      let newTest = ( model.nextID, Test.init 0 )
          newTests = model.Tests ++ [ newTest ]
      in
          { model |
              Tests = newTests,
              nextID = model.nextID + 1
          }

    Remove ->
      { model | Tests = List.drop 1 model.Tests }

    Modify id TestAction ->
      let updateTest (TestID, TestModel) =
              if TestID == id then
                  (TestID, Test.update TestAction TestModel)
              else
                  (TestID, TestModel)
      in
          { model | Tests = List.map updateTest model.Tests }


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let Tests = List.map (viewTest address) model.Tests
      remove = button [ onClick address Remove ] [ text "Remove" ]
      insert = button [ onClick address Insert ] [ text "Add" ]
  in
      div [] ([remove, insert] ++ Tests)


viewTest : Signal.Address Action -> (ID, Test.Model) -> Html
viewTest address (id, model) =
  Test.view (Signal.forwardTo address (Modify id)) model
