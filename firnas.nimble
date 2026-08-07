# Package
version       = "0.1.0"
author        = "Abdulrahman"
description   = "A 2d physics engine."
license       = "MIT"
srcDir        = "src"

# Dependencies
requires "nim >= 2.2.10"

#tasks
task example, "Run example":
  exec "nim c -r -p:src -d:wayland examples/example.nim"