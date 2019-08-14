# Package

version       = "0.2.6"
author        = "nayefhaidir"
description   = "Polyester Bot"
license       = "GNU GPL 3.0"
srcDir        = "src"
bin           = @["pol_pkg"]


# Dependencies

requires "nim >= 0.20.0"
requires "telebot >= 0.6.8", "regex >= 0.11.2", "dotenv >=1.1.1"


# Tasks
task test, "Run tests":
  exec "nimble build -y"