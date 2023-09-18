# Package

version       = "1.3.1.0"
author        = "stoneface86"
description   = "Bindings for nappgui, cross-platform GUI toolkit"
license       = "MIT"
srcDir        = "src"
#installExt    = @["nim"]
#bin           = @["nappgui"]


# Dependencies

requires "nim >= 1.4.0"

import std/os

task docs, "Generate documentation":
  selfExec quoteShellCommand [
    "--hints:off",
    "--project",
    "--index:on",
    "--git.url:https://github.com/stoneface86/nappgui-nim",
    "--git.commit:" & version,
    "-p:" & srcDir,
    "--outdir:htmldocs",
    "doc",
    srcDir / "nappgui.nim"
  ]
