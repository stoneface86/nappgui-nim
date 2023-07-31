{.used.}
# this module builds the nappgui library from our vendored source

import std/os
import nappgui/nappgui

template trace(msg: string) =
  when defined(nappguiTrace):
    static:
      echo "[NAPPGUI] ", msg


const
  thisDir = currentSourcePath().parentDir()
  config = block:
    when defined(release):
      when compileoption("assertions"):
        ccReleaseWithAssert
      else:
        ccRelease
    else:
      ccDebug

  # root path to build the nappgui library
  # if not provided, we will default to using this project's bin directory
  # with an nappgui subdirectory.
  nappguiRoot {.strdefine.} = thisDir.parentDir.parentDir.parentDir / "bin" / "nappgui"
  # <nappguiRoot>/<config>
  binDir = nappguiRoot / config.name()
  # <nappguiRoot>/<config>/nimcache
  nimcacheDir = binDir / "nimcache"
  projFile = thisDir / "nappgui" / "nappgui.nim"

  nimExe = getCurrentCompilerExe()

  # The built static library will be located at
  # Linux/MacOSX:   <projectRoot>/bin/nappgui/<config>/libnappgui.a
  # Windows:        <projectRoot>/bin/nappgui/<config>/nappgui.lib
  libnappgui = binDir / (
    when defined(windows):
      "nappgui.lib"
    else:
      "libnappgui.a"
  )

# Build the nappgui library as a separate nim process
# this way the library only needs to built once for each config
# nappguiVersionStr is used as the cache, so it will only be rebuilt if
# this changes (ie a newer version of nappgui is vendored) or if the `-f`
# option is specified.

checkCompiler()

const traceMsgPrefix = "Building " & libnappgui
trace traceMsgPrefix

const nappguiBuildResult = gorgeEx(
  quoteShellCommand([
    nimExe, "c", "--nimcache:" & nimcacheDir, "--outdir:" & binDir,
    "--cc:" & compiler,
    "-d:nappguiConfig:" & $config.ord,
    projFile
  ]), "", nappguiVersionStr
)
when nappguiBuildResult.exitCode == 0:
  trace traceMsgPrefix & ": DONE"
else:
  trace traceMsgPrefix & ": FAILED"
  static: 
    echo "===== [NAPPGUI] Build output start =========="
    echo nappguiBuildResult.output
    echo "===== [NAPPGUI] Build output end   =========="
  {. error: "Failed to build nappgui library." .}


{. passL: libnappgui .}
useNappguiLib(config)
