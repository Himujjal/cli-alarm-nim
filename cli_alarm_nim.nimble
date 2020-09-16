# Package

version       = "0.0.1"
author        = "Himujjal"
description   = "A CLI Alarm for me to keep track of my productivity"
license       = "MIT"
srcDir        = "src"
bin           = @["cli_alarm_nim"]


# Test
task test, "Runs the test suite":
  exec "nim c -r tests/test_main.nim"
  exec "rm tests/*.exe"



# Dependencies
requires "nim >= 1.2.6"
