module TestList where

import Test
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
    }

type alias ID = Int


init : Signal.Address () -> (Model, Effects.Effects Action)
init addr = (Model addr [] 0, Effects.none)
{-
init : Signal.Mailbox () -> (Model, Effects.Effects Action)
init mbx = (Model mbx [] 0, Effects.none)

  { startmbx= Signal.mailbox sig
  , tests= List.empty
  , nextID= 0
  }
-}

-- UPDATE

type Action
    = StartTests
    | Modify ID Test.Action
    | Dummy

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
      (model, Effects.task  
        (Task.andThen 
          (Signal.send model.startaddr ())
          (\_ -> Task.succeed Dummy)))
    Modify id testAction ->
      let updateTest (testID, testModel) =
              if testID == id then
                  (testID, Test.update testAction testModel)
              else
                  (testID, testModel)
      in
         ({ model | tests = List.map updateTest model.tests },
          Effects.none)
    Dummy -> (model, Effects.none)
        


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
