
import TestList 
--import StartApp.Simple exposing (start)
import StartApp exposing (start)
import Signal  
import Task
import Effects

mbx = Signal.mailbox ()

port starttests : Signal ()
port starttests = mbx.signal 

port testIncome : Signal Int

app =
  start
    { init = TestList.init mbx.address 
    , update = TestList.update
    , view = TestList.view
    , inputs = [Signal.map (\i -> TestList.InitTests i) testIncome]
    }

main = app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks



