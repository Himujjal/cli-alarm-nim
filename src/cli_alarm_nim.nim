import terminal
import rdstdin
import strutils

import cliTimer

proc runCommand*()

var timer: CliTimer = nil

proc printHelp()=
  echo """WELCOME TO THE ULTIMATE TIMER APPLICATION!
COMMANDS:
'get `*`|<time_in_Number> -- to get all entries from yesterday to today
'delete <id>|`*`' -- to delete entry with the particular id
'start <minutes>' -- to start the timer for <minutes> minutes
'stop' -- to stop the timer instantly and enter the current date in db
'update <id>,<startDate>,<endDate>' -- to update the entry
'help' to show this menu
'exit' -- to exit"""

proc getResponse(): string = readLineFromStdin("|>|> ")

proc error()=
  echo "Wrong input. Press `help` for the Help menu!"
  runCommand()

proc readAndExecRestInput(res: string)=
  let resSeq = res.strip().split()
  echo resSeq

  if resSeq.len <= 1:
    if resSeq.len == 0:
      error()
    elif resSeq[0] == "get":
      echo timer.getRows()
  elif resSeq.len == 2:
    case resSeq[0]:
    of "delete": discard timer.deleteRows(resSeq[1])
    of "update":
      let splitted = resSeq[1].split(",")
      discard timer.updateRow(splitted[0], splitted[1].parseInt(), splitted[2].parseInt())
    of "start":  timer = startTimer(duration = resSeq[1].parseInt())
    of "get":
      echo timer.getRows(resSeq[1])
    else: error()
  else:
    error()

proc runCommand()=
  let res = getResponse()
  case res:
  of "exit": quit("Bye", 0)
  of "help": printHelp(); runCommand()
  of "cls", "clear": terminal.eraseScreen(); runCommand()
  of "stop": timer.stopTimer()
  else: readAndExecRestInput(res)

when isMainModule:
  printHelp()
  runCommand()