##
## Sewer
## 
## Low-level bindings for the `sewer` library in the NAppGUI SDK.
## 

import ../private/libnappgui

{. push importc, header: "nappgui/sewer/sewer.hxx" .} #=================================

type
  unicode_t* {. size: sizeof(cint) .} = enum
    ekUTF8
    ekUTF16
    ekUTF32
  
  REnv* = object

  FPtr_destroy* = proc(item: ptr pointer) {.noconv.}
  FPtr_copy* = proc(item: pointer): pointer {.noconv.}
  FPtr_scopy* = proc(dest: pointer, src: pointer) {.noconv.}
  FPtr_compare* = proc(item1: pointer, item2: pointer): cint {.noconv.}
  FPtr_compare_ex* = proc(item1: pointer, item2: pointer, data: pointer): cint {.noconv.}
  FPtr_assert* = proc(item: pointer, group: uint32, caption: cstring, detail: cstring, file: cstring, line: uint32) {.noconv.}

  bool_t*   = cchar
  char_t*   = cchar
  int8_t*   = int8
  int16_t*  = int16
  int32_t*  = int32
  int64_t*  = int64
  uint8_t*  = uint8
  uint16_t* = uint16
  uint32_t* = uint32
  uint64_t* = uint64
  real*     = cfloat
  real32_t* = float32
  real64_t* = float64
  byte_t*   = uint8_t
  enum_t*   = cint

const
  TRUE*: bool_t = 1.bool_t
  FALSE*: bool_t = 0.bool_t

{. pop .} # ===================================================================
{. push importc, header: "nappgui/sewer/sewer.h" .}

proc sewer_start*()
proc sewer_stop*()

{. pop .} # ===================================================================
