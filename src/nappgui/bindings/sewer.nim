##
## Sewer
## 
## Low-level bindings for the `sewer` library in the NAppGUI SDK.
## 

import ../private/libnappgui

{. push header: "nappgui/sewer/sewer.hxx" .} #=================================

type
  unicode_t* {. importc, size: sizeof(cint) .} = enum
    ekUTF8
    ekUTF16
    ekUTF32
  
  REnv* {.importc.} = object

  FPtr_destroy* {.importc.} = proc(item: ptr pointer) {.noconv.}
  FPtr_copy* {.importc.} = proc(item: pointer): pointer {.noconv.}
  FPtr_scopy* {.importc.} = proc(dest: pointer, src: pointer) {.noconv.}
  FPtr_compare* {.importc.} = proc(item1: pointer, item2: pointer): cint {.noconv.}
  FPtr_compare_ex* {.importc.} = proc(item1: pointer, item2: pointer, data: pointer): cint {.noconv.}
  FPtr_assert* {.importc.} = proc(item: pointer, group: uint32, caption: cstring, detail: cstring, file: cstring, line: uint32) {.noconv.}

  bool_t* {.importc.}   = cchar
  char_t* {.importc.}   = cchar
  int8_t* {.importc.}   = int8
  int16_t* {.importc.}  = int16
  int32_t* {.importc.}  = int32
  int64_t* {.importc.}  = int64
  uint8_t* {.importc.}  = uint8
  uint16_t* {.importc.} = uint16
  uint32_t* {.importc.} = uint32
  uint64_t* {.importc.} = uint64
  real* {.importc.}     = cfloat
  real32_t* {.importc.} = float32
  real64_t* {.importc.} = float64
  byte_t* {.importc.}   = uint8_t
  enum_t* {.importc.}   = cint

const
  TRUE*: bool_t = 1.bool_t
  FALSE*: bool_t = 0.bool_t

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/sewer/sewer.h" .}

proc sewer_start*()
proc sewer_stop*()

{. pop .} # ===================================================================
