import DbOrm
import os
import strutils
import db_sqlite
import times
import utils
import terminal
import asciitext
import strformat
import os

type
  CliTimer* = ref object
    id: string
    remainingTime: Duration
    endTime: DateTime
    startTime: DateTime
    db: DBOrm
    fileName: string
    ongoing: bool

proc playMusic() =
  when hostOS == "windows":
    discard execShellCmd(".\\play.mp3")
  else:
    discard execShellCmd("vlc ~/Music/tones/play.mp3")

proc printTime(timer: CliTimer)=
  terminal.eraseScreen()
  terminal.setCursorPos(0, 0)
  echo timeModifier(int(timer.remainingTime.inSeconds())).asciiText()

proc decreaseTime(timer: CliTimer)=
  if timer.remainingTime == initDuration(seconds = 1):
    timer.ongoing = false
  timer.remainingTime = timer.remainingTime - initDuration(seconds = 1)
  let endTime = int((timer.startTime + timer.remainingTime).toTime().toUnix())
  discard timer.db.updateEndTime(timer.id, endTime)
  timer.printTime()

proc tick*(timer: CliTimer)=
  timer.remainingTime = timer.endTime - timer.startTime
  while timer.ongoing:
    timer.decreaseTime()
    if timer.ongoing == false:
      echo fmt"Session finished for {timer.endTime.hour}H:{timer.endTime.minute}M from ({timeModifier(timer.startTime)}-{timeModifier(timer.endTime)})!"
      playMusic()
      break;
    sleep(1000)

proc initTimer*(fileName: string =  "myAlarm.db"):CliTimer=
  let id = generateUUID()
  let timer = CliTimer(id: id, fileName: fileName, db: newDb(fileName))
  timer.db.createTableIfNotExists()
  result = timer

proc startTimer*(timer: CliTimer, duration: float)=
  let startTime = now()
  let endTime = startTime + initDuration(milliseconds = int(duration * 60000))
  timer.startTime = startTime
  timer.endTime = endTime
  timer.db.createTableIfNotExists()
  timer.db.insertTime(timer.id, int(startTime.toTime().toUnix()), int(endTime.toTime().toUnix()))
  timer.ongoing = true
  timer.tick()

proc stopTimer*(timer: var CliTimer)=
  if timer != nil and timer.ongoing == true:
    let endTime = now()
    discard timer.db.updateTime(timer.id, int(timer.startTime.toTime().toUnix()), int(endTime.toTime().toUnix()))
    timer.ongoing = false
    timer = nil
    echo fmt"Session finished for {timer.endTime.hour}H:{timer.endTime.minute}M from ({timeModifier(timer.startTime)}-{timeModifier(timer.endTime)})!"
  else:
    echo "No running timer on now"

proc getRows*(timer: CliTimer, givenTime: string = "*"):seq[Row]=
  if givenTime.strip() == "*":
    return timer.db.getAllRows()
  else:
    return timer.db.getRowsByTime(givenTime.parseInt())

proc deleteRows*(timer: CliTimer, id: string = "*"):seq[Row]=
  if id.strip() == "*":
    return timer.db.deleteAll()
  else:
    return timer.db.deleteRow(id)

proc updateRow*(timer: CliTimer, id: string, startTime, endTime: int):Row=
  return timer.db.updateTime(id, startTime, endTime)

