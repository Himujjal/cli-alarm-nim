import strformat
import times
import math
import sequtils
import strutils
import random
import times

randomize()

const pattern = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

proc getTime(): int  =
  toInt(epochTime() * 100000)

proc generateUUID*(): string =
  var d = getTime()
  proc fn(c : char): string =
    var r = toInt(toFloat(d) + rand(1.0) * 16) %% 16
    d = toInt(floor(toFloat(d) / 16))
    toHex(if c == 'x': r else: r and 0x3 or 0x8, 1)
  toLower(join(pattern.mapIt(if it == 'x' or it == 'y': fn(it) else: $it)))

proc timeModifier*(durtn: int):string =
  let hrs = durtn div 3600
  let mins = (durtn mod 3600) div 60
  let secs = durtn mod 60

  var ret = ""
  var minsMod = if mins < 10: "0" else: ""

  if hrs > 0:
    ret = &"{ret}{$hrs}h {minsMod}"
  let secsMod = if secs < 10: "0" else: ""
  ret = &"{ret}{$mins}m {secsMod}"
  ret = &"{ret}{$secs}s"
  return ret

proc timeModifier*(date: DateTime): string=
  var hrs = float(date.hour)
  let minutes = $date.minute
  let amPm = if hrs > 12.0: "PM" else: "AM"
  let hrsNormalized = int(hrs mod 12.0)
  return &"{$hrsNormalized}:{$minutes} {amPm}"