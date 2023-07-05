
import ../private/libnappgui
import sewer, osbs
import std/[macros, strformat]

{. push importc, header: "nappgui/core/core.hxx" .}
{. pragma: cenum, size: sizeof(cint) .}

type
  core_event_t* {.cenum.} = enum
    ekEASSERT = 0x100
    ekEFILE
    ekEENTRY
    ekEEXIT

  sstate_t* {.cenum.} = enum
    ekSTOK
    ekSTEND
    ekSTCORRUPT
    ekSTBROKEN
  
  vkey_t* {.cenum.} = enum
    ekKEY_UNDEF             = 0
    ekKEY_A                 = 1
    ekKEY_S                 = 2
    ekKEY_D                 = 3
    ekKEY_F                 = 4
    ekKEY_H                 = 5
    ekKEY_G                 = 6
    ekKEY_Z                 = 7
    ekKEY_X                 = 8
    ekKEY_C                 = 9
    ekKEY_V                 = 10
    ekKEY_BSLASH            = 11
    ekKEY_B                 = 12
    ekKEY_Q                 = 13
    ekKEY_W                 = 14
    ekKEY_E                 = 15
    ekKEY_R                 = 16
    ekKEY_Y                 = 17
    ekKEY_T                 = 18
    ekKEY_1                 = 19
    ekKEY_2                 = 20
    ekKEY_3                 = 21
    ekKEY_4                 = 22
    ekKEY_6                 = 23
    ekKEY_5                 = 24
    ekKEY_9                 = 25
    ekKEY_7                 = 26
    ekKEY_8                 = 27
    ekKEY_0                 = 28
    ekKEY_RCURLY            = 29
    ekKEY_O                 = 30
    ekKEY_U                 = 31
    ekKEY_LCURLY            = 32
    ekKEY_I                 = 33
    ekKEY_P                 = 34
    ekKEY_RETURN            = 35
    ekKEY_L                 = 36
    ekKEY_J                 = 37
    ekKEY_SEMICOLON         = 38
    ekKEY_K                 = 39
    ekKEY_QUEST             = 40
    ekKEY_COMMA             = 41
    ekKEY_MINUS             = 42
    ekKEY_N                 = 43
    ekKEY_M                 = 44
    ekKEY_PERIOD            = 45
    ekKEY_TAB               = 46
    ekKEY_SPACE             = 47
    ekKEY_GTLT              = 48
    ekKEY_BACK              = 49
    ekKEY_ESCAPE            = 50
    ekKEY_F17               = 51
    ekKEY_NUMDECIMAL        = 52
    ekKEY_NUMMULT           = 53
    ekKEY_NUMADD            = 54
    ekKEY_NUMLOCK           = 55
    ekKEY_NUMDIV            = 56
    ekKEY_NUMRET            = 57
    ekKEY_NUMMINUS          = 58
    ekKEY_F18               = 59
    ekKEY_F19               = 60
    ekKEY_NUMEQUAL          = 61
    ekKEY_NUM0              = 62
    ekKEY_NUM1              = 63
    ekKEY_NUM2              = 64
    ekKEY_NUM3              = 65
    ekKEY_NUM4              = 66
    ekKEY_NUM5              = 67
    ekKEY_NUM6              = 68
    ekKEY_NUM7              = 69
    ekKEY_NUM8              = 70
    ekKEY_NUM9              = 71
    ekKEY_F5                = 72
    ekKEY_F6                = 73
    ekKEY_F7                = 74
    ekKEY_F3                = 75
    ekKEY_F8                = 76
    ekKEY_F9                = 77
    ekKEY_F11               = 78
    ekKEY_F13               = 79
    ekKEY_F16               = 80
    ekKEY_F14               = 81
    ekKEY_F10               = 82
    ekKEY_F12               = 83
    ekKEY_F15               = 84
    ekKEY_PAGEUP            = 85
    ekKEY_HOME              = 86
    ekKEY_SUPR              = 87
    ekKEY_F4                = 88
    ekKEY_PAGEDOWN          = 89
    ekKEY_F2                = 90
    ekKEY_END               = 91
    ekKEY_F1                = 92
    ekKEY_LEFT              = 93
    ekKEY_RIGHT             = 94
    ekKEY_DOWN              = 95
    ekKEY_UP                = 96
    ekKEY_LSHIFT            = 97
    ekKEY_RSHIFT            = 98
    ekKEY_LCTRL             = 99
    ekKEY_RCTRL             = 100
    ekKEY_LALT              = 101
    ekKEY_RALT              = 102
    ekKEY_INSERT            = 103
    ekKEY_EXCLAM            = 104
    ekKEY_MENU              = 105
    ekKEY_LWIN              = 106
    ekKEY_RWIN              = 107
    ekKEY_CAPS              = 108
    ekKEY_TILDE             = 109
    ekKEY_GRAVE             = 110
    ekKEY_PLUS              = 111

  mkey_t* {.cenum.} = enum
    ekMKEY_NONE     = 0
    ekMKEY_SHIFT    = 1
    ekMKEY_CONTROL  = 1 shl 1
    ekMKEY_ALT      = 1 shl 2
    ekMKEY_COMMAND  = 1 shl 3

  ltoken_t* {.cenum.} = enum
    ekTSLCOM = 1
    ekTMLCOM
    ekTSPACE
    ekTEOL

    ekTLESS         # <
    ekTGREAT        # >
    ekTCOMMA        # ,
    ekTPERIOD       # .
    ekTSCOLON       # ;
    ekTCOLON        # :

    ekTOPENPAR      # (
    ekTCLOSPAR      # )
    ekTOPENBRAC     # [
    ekTCLOSBRAC     # ]
    ekTOPENCURL     # {
    ekTCLOSCURL     # }

    ekTPLUS         # +
    ekTMINUS        # -
    ekTASTERK       # *
    ekTEQUALS       # =

    ekTDOLLAR       # $
    ekTPERCENT      # %
    ekTPOUND        # #
    ekTAMPER        # &

    ekTAPOST        # '
    ekTQUOTE        # "
    ekTCIRCUM       # ^
    ekTTILDE        # ~
    ekTEXCLA        # !
    ekTQUEST        # ?
    ekTVLINE        # |
    ekTSLASH        # /
    ekTBSLASH       # \
    ekTAT           # @

    ekTINTEGER
    ekTOCTAL
    ekTHEX
    ekTREAL
    ekTSTRING
    ekTIDENT

    ekTUNDEF
    ekTCORRUP
    ekTEOF

    ekTRESERVED
  
  Buffer* = object
  String* = object
  Stream* = object
  RegEx* = object
  Event* = object
  KeyBuf* = object
  Listener* = object
  DirEntry* = object
    name*: ptr String
    `type`*: file_type_t
    size*: uint64_t
    date*: Date
  EvFileDir* = object
    pathname*: cstring
    level*: uint32_t
  ResPack* = object
  ResId* = object
  Clock* = object

  FPtr_remove* = proc(obj: pointer) {.noconv.}
  FPtr_event_handler* = proc(obj: pointer) {.noconv.}
  FPtr_read* = proc(stream: ptr Stream): pointer {.noconv.}
  FPtr_read_init* = proc(stream: ptr Stream, obj: pointer) {.noconv.}
  FPtr_write* = proc(stream: ptr Stream, obj: pointer) {.noconv.}

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/core.h" .}

proc core_start*()
proc core_finish*()

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/heap.h" .}

proc heap_start_mt*()
proc heap_end_mt*()
proc heap_verbose*(verbose: bool_t)
proc heap_stats*(stats: bool_t)
proc heap_leaks*(): bool_t
proc heap_malloc*(size: uint32_t, name: cstring): ptr byte_t
proc heap_calloc*(size: uint32_t, name: cstring): ptr byte_t
proc heap_realloc*(mem: ptr byte_t, size: uint32_t, new_size: uint32_t,
                   name: cstring): ptr byte_t
proc heap_aligned_malloc*(size: uint32_t, align: uint32_t,
                         name: cstring): ptr byte_t
proc heap_aligned_calloc*(size: uint32_t, align: uint32_t,
                         name: cstring): ptr byte_t                        
proc heap_aligned_realloc*(mem: ptr byte_t, size: uint32_t, new_size: uint32_t,
                           align: uint32_t, name: cstring): ptr byte_t
proc heap_free*(mem: ptr ptr byte_t, size: uint32_t, name: cstring)                          

template mallocName(T: typedesc): cstring = ($T).cstring
template genheapnew(T: typedesc, heapfunc: untyped): untyped =
  heapfunc(T.sizeof.uint32_t, mallocName(T))

template heap_new*(T: typedesc): ptr T =
  mixin genheapnew
  genheapnew(T, heap_malloc)

template heap_new0*(T: typedesc): ptr T =
  mixin genheapnew
  genheapnew(T, heap_calloc)

template mallocNameN(T: typedesc): cstring = ($T & "::arr").cstring

template genheapnewn(T: typedesc, n: int, heapfunc: untyped): untyped =
  heapfunc((T.sizeof * n).uint32_t, mallocNameN(T))

template heap_new_n*(T: typedesc, n: int): ptr T =
  mixin genheapnewn
  genheapnewn(T, n, heap_malloc)

template heap_new_n0*(T: typedesc, n: int): ptr T =
  mixin genheapnewn
  genheapnewn(T, n, heap_malloc)

template heap_realloc_n*[T](
  mem: ptr T, size: uint32_t, new_size: uint32_t
): ptr T =
  heap_realloc(
    cast[ptr byte_t](mem),
    size * sizeof(T).uint32_t,
    new_size * sizeof(T).uint32_t,
    mallocNameN(T)
  )

template heap_delete*[T](obj: ptr ptr T) =
  heap_free(cast[ptr ptr byte](obj), sizeof(T).uint32_t, mallocName(T))

template heap_delete_n*[T](obj: ptr ptr T, n: uint32_t) =
  heap_free(cast[ptr ptr byte](obj), n * sizeof(T).uint32, mallocNameN(T))

proc heap_auditor_add*(name: cstring)
proc heap_auditor_delete*(name: cstring)

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/buffer.h" .}

proc buffer_create*(size: uint32_t): ptr Buffer
proc buffer_with_data*(data: ptr byte_t, size: uint32_t): ptr Buffer
proc buffer_destroy*(buffer: ptr ptr Buffer)
proc buffer_size*(buffer: ptr Buffer): uint32_t
proc buffer_data*(buffer: ptr Buffer): ptr byte_t
proc buffer_const*(buffer: ptr Buffer): ptr byte_t

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/string.h" .}

proc tc*(str: ptr String): cstring
proc tcc*(str: ptr String): cstring
proc str_c*(str: cstring): ptr String
proc str_cn*(str: cstring, n: uint32_t): ptr String
proc str_trim*(str: cstring): ptr String
proc str_trim_n*(str: cstring, n: uint32_t): ptr String
proc str_copy*(str: ptr String): ptr String
proc str_printf*(format: cstring): ptr String {.varargs.}
proc str_path*(platform: platform_t, format: cstring): ptr String {.varargs.}
proc str_cpath*(format: cstring): ptr String {.varargs.}
proc str_relpath*(path1: cstring, path2: cstring): ptr String
proc str_repl*(str: cstring): ptr String {.varargs.}


{. pop .} #====================================================================
{. push importc, header: "nappgui/core/stream.h" .}

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/regex.h" .}

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/dbind.h" .}

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/event.h" .}

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/keybuf.h" .}

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/hfile.h" .}

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/respack.h" .}

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/date.h" .}

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/clock.h" .}

{. pop .} #====================================================================

macro ArrSt*(T: typedesc): typedesc = newIdentNode(&"ArrSt{T}")
macro ArrPt*(T: typedesc): typedesc = newIdentNode(&"ArrPt{T}")
macro SetSt*(T: typedesc): typedesc = newIdentNode(&"SetSt{T}")
macro SetPt*(T: typedesc): typedesc = newIdentNode(&"SetPt{T}")

func declArrSetImpl(T: NimNode, classname: string): NimNode {.compileTime.} =
  let 
    importc = &"{classname}({T})"
    name = newIdentNode(&"{classname}{T}")
  result = quote do:
    type `name`* {.importc: `importc`.} = object

macro declArrSt*(T: typedesc) = declArrSetImpl(T, "ArrSt")
macro declArrPt*(T: typedesc) = declArrSetImpl(T, "ArrPt")
macro declSetSt*(T: typedesc) = declArrSetImpl(T, "SetSt")
macro declSetPt*(T: typedesc) = declArrSetImpl(T, "SetPt")

declArrSt(bool_t)
declArrSt(int8_t)
declArrSt(int16_t)
declArrSt(int32_t)
declArrSt(int64_t)
declArrSt(uint8_t)
declArrSt(uint16_t)
declArrSt(uint32_t)
declArrSt(uint64_t)
declArrSt(real32_t)
declArrSt(real64_t)
