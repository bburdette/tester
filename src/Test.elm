module Test (Model, init, Action(TestUpdate), TestStatus(Running,Passed,Failed), update, view) where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)


-- MODEL

-- The current status of each test (Not Started Yet, Running, Passed, or Failed)

type TestStatus = NotStartedYet | 
                  Running | 
                  Passed |  
                  Failed

tsToString : TestStatus -> String
tsToString ts = 
  case ts of 
    NotStartedYet -> "test not started! " 
    Running -> "test is running." 
    Passed -> "test passed."
    Failed -> "test failed."


type alias Model = 
  { description: String 
  , status: TestStatus 
  } 

init : String -> TestStatus -> Model
init desc ts = Model desc ts 

-- UPDATE

type Action = TestUpdate TestStatus 


update : Action -> Model -> Model
update action model =
  case action of
    TestUpdate ts -> 
      { model | status = ts }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ div [ statusStyle ] 
      [ (text model.description), (text (tsToString model.status)) ]
    ]


statusStyle : Attribute
statusStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]
