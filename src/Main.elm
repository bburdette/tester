
import TestList 
--import StartApp.Simple exposing (start)
import StartApp exposing (start)
import Signal  

mbx = Signal.mailbox ()

port starttests : Signal ()
port starttests = mbx.signal 

main =
  (start
    { init = TestList.init mbx.address 
    , update = TestList.update
    , view = TestList.view
    , inputs = []
    }).html



