module TestList where

import Test exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal
import Effects
import Task

-- MODEL

type alias Model =
    { startaddr: Signal.Address () 
    , tests : List ( ID, Test.Model )
    , nextID : ID
    , count: Int
    }

type alias ID = Int


init : Signal.Address () -> (Model, Effects.Effects Action)
init addr = (Model addr [] 0 0, Effects.none)

-- UPDATE
type alias InitStuff = 
  { count: Int
  , descriptions: List String
  }

type Action
    = StartTests
    | Modify ID Test.Action
    | InitTests InitStuff
    | Dummy

update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case action of
    StartTests ->
      -- start the tests!
      (model, Effects.task  
        (Task.andThen 
          (Signal.send model.startaddr ())
          (\_ -> Task.succeed Dummy)))
    InitTests initstuff ->
      let l = List.length initstuff.descriptions
          tests = List.map2 (\i d -> (i, Test.init d Test.Running)) 
                     [1..l] initstuff.descriptions in  
      ({model | count = initstuff.count, tests = tests }, Effects.none)
    Modify id testAction ->
      let updateTest (testID, testModel) =
              if testID == id then
                  (testID, Test.update testAction testModel)
              else
                  (testID, testModel)
      in
         ({ model | tests = List.map updateTest model.tests },
          Effects.none)
    Dummy -> 
      (model, Effects.none)
        


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
