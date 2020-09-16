import DbOrm
import os
import strutils
import db_sqlite
import times
import random

type
  CliTimer* = ref object
    id: string
    elapsedTime: Duration
    endTime: DateTime
    start: DateTime
    db: DBOrm
    fileName: string
    ongoing: bool



proc decreaseTime(timer: CliTimer)=
  timer.elapsedTime -= initDuration(seconds = 1)

proc tick*(timer: CliTimer)=
  while timer.ongoing:
    timer.decreaseTime()
    sleep(1000)


proc startTimer*(fileName: string = "myAlarm.db", duration: int):CliTimer=
  let startTime = now()
  let endTime = startTime + initDuration(minutes = duration)
  let timer = CliTimer(id: $rand(100) , elapsedTime: endTime - startTime, start: startTime, endTime: endTime)
  timer.fileName = fileName
  timer.db = newDB(fileName);
  timer.db.createTableIfNotExists()
  timer.db.insertTime(now().nanosecond, now().nanosecond)
  timer.tick()
  result = timer

proc stopTimer*(timer: var CliTimer)=
  let endTime = now()
  discard timer.db.updateTime(timer.id, int(timer.start.toTime().toUnix()), int(endTime.toTime().toUnix()))
  timer.ongoing = false
  timer = nil
  echo "Session finished for <>H:<>M:<>S from (00:00)-(00:00) seconds!"

proc getRows*(timer: CliTimer, givenTime: string = "*"):seq[Row]=
  if givenTime == "*":
    return timer.db.getRows()
  else:
    return timer.db.getRowsByTime(givenTime.parseInt())


proc deleteRows*(timer: CliTimer, id: string = "*"):seq[Row]=
  if id == "*":
    return timer.db.deleteAll()
  else:
    return timer.db.deleteRow(id)

proc updateRow*(timer: CliTimer, id: string, startTime, endTime: int):Row=
  return timer.db.updateTime(id, startTime, endTime)

