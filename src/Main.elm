
import TestList 
--import StartApp.Simple exposing (start)
import StartApp exposing (start)
import Signal  

port starttests : Signal ()
port starttests = mbx.signal 

mbx = Signal.mailbox ()

main =
  (start
    { init = TestList.init mbx.address 
    , update = TestList.update
    , view = TestList.view
    , inputs = []
    }).html



