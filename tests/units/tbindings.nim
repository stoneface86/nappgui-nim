## This test just makes sure the bindings compile and link to nappgui.

{.used.}

import std/unittest

import nappgui/bindings/[
  osbs
]

{. deadCodeElim: off .}

proc test() =
  osbs_start()
  osbs_finish()
  discard osbs_platform()
  discard osbs_windows()
  discard osbs_endian()
  # there's only an implementation on windows for these
  #var ferror = ekFOK
  #discard bfile_dir_work("/nope", 0)
  #discard bfile_dir_set_work("/nope", ferror.addr)
  discard bfile_dir_home("", 0)

test "bindings":
  if false:
    test()
