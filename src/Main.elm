
import TestList exposing (init, update, view)
import StartApp.Simple exposing (start)

port starttests : Signal () 

main =
  start
    { model = init starttests
    , update = update
    , view = view
    }


