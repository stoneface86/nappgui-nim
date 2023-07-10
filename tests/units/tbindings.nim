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
  var ferror = ekFOK
  #discard bfile_dir_work("/nope", 0)
  #discard bfile_dir_set_work("/nope", ferror.addr)
  discard bfile_dir_home("", 0)
  discard bfile_dir_data("", 0)
  discard bfile_dir_exec("", 0)
  discard bfile_dir_create("", ferror.addr)
  
  var dir = bfile_dir_open("", ferror.addr)
  bfile_dir_close(dir.addr)
  var 
    ftype: file_type_t
    fsize: uint64
    updated: Date
  discard bfile_dir_get(dir, "", 0, ftype.addr, fsize.addr, updated.addr, ferror.addr)


test "bindings":
  if false:
    test()
