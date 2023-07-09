##
## Core
## 
## Low-level bindings for the `core` library in the NAppGUI SDK.
##

import ../private/libnappgui
import sewer, osbs
import std/[macros, strformat]

# =============================================================================
{. push importc, header: "nappgui/core/core.hxx" .}
{. pragma: cenum, size: sizeof(cint) .}

# Core library types

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

  Array*[T] {.importc.} = object
  RBTree*[T] = object
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
  FPtr_event_handler* = proc(obj: pointer, evt: ptr Event) {.noconv.}
  FPtr_read* = proc(stream: ptr Stream): pointer {.noconv.}
  FPtr_read_init* = proc(stream: ptr Stream, obj: pointer) {.noconv.}
  FPtr_write* = proc(stream: ptr Stream, obj: pointer) {.noconv.}

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/core.h" .}

# Core library

proc core_start*()
proc core_finish*()

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/heap.h" .}

# Heap memory manager

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

# Buffers

proc buffer_create*(size: uint32_t): ptr Buffer
proc buffer_with_data*(data: ptr byte_t, size: uint32_t): ptr Buffer
proc buffer_destroy*(buffer: ptr ptr Buffer)
proc buffer_size*(buffer: ptr Buffer): uint32_t
proc buffer_data*(buffer: ptr Buffer): ptr byte_t
proc buffer_const*(buffer: ptr Buffer): ptr byte_t

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/string.h" .}

# Strings

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
proc str_reserve*(n: uint32_t): ptr String
proc str_fill*(n: uint32_t, c: char_t): ptr String
proc str_read*(stream: ptr Stream): ptr String
proc str_write*(stream: ptr Stream, str: ptr String)
proc str_writef*(stream: ptr Stream, str: ptr String)
proc str_copy_c*(dest: cstring, size: uint32_t, str: cstring)
proc str_copy_cn*(dest: cstring, size: uint32_t, str: cstring, n: uint32_t)
proc str_cat*(dest: ptr ptr String, src: cstring)
proc str_cat_c*(dest: cstring, size: uint32_t, src: cstring)
proc str_upd*(str: ptr ptr String, new_str: cstring)
proc str_destroy*(str: ptr ptr String)
proc str_destopt*(str: ptr ptr String)
proc str_len*(str: ptr String): uint32_t
proc str_len_c*(str: cstring): uint32_t
proc str_nchars*(str: ptr String): uint32_t
proc str_prefix*(str1: cstring, str2: cstring): uint32_t
proc str_is_prefix*(str: cstring, prefix: cstring): bool_t
proc str_is_suffix*(str: cstring, suffix: cstring): bool_t
proc str_scmp*(str1: ptr String, str2: ptr String): cint
proc str_cmp*(str1: ptr String, str2: cstring): cint
proc str_cmp_c*(str1: cstring, str2: cstring): cint
proc str_cmp_cn*(str1: cstring, str2: cstring, n: uint32_t): cint
proc str_empty*(str: ptr String): bool_t
proc str_empty_c*(str: cstring): bool_t
proc str_equ*(str1: ptr String, str2: cstring): bool_t
proc str_equ_c*(str1: cstring, str2: cstring): bool_t
proc str_equ_cn*(str1: cstring, str2: cstring, n: uint32_t): bool_t
proc str_equ_nocase*(str1: cstring, str2: cstring): bool_t
proc str_equ_end*(str: cstring, `end`: cstring): bool_t
proc str_upper*(str: ptr String)
proc str_lower*(str: ptr String)
proc str_upper_c*(str: cstring)
proc str_lower_c*(str: cstring)
proc str_subs*(str: ptr String, replace: char_t, with: char_t)
proc str_repl_c*(str: ptr String, replace: cstring, with: cstring)
proc str_str*(str: cstring, substr: cstring): cstring
proc str_split*(str: cstring, substr: cstring, left: ptr ptr String,
                right: ptr ptr String): bool_t
proc str_split_trim*(str: cstring, substr: cstring, left: ptr ptr String,
                     right: ptr ptr String): bool_t
proc str_split_pathname*(pathname: cstring, path: ptr ptr String,
                         file: ptr ptr String)
proc str_split_pathext*(pathname: cstring, path: ptr ptr String,
                        file: ptr ptr String, ext: ptr ptr String)
proc str_filename*(pathname: cstring): cstring
proc str_filext*(pathname: cstring): cstring
#proc str_find*()                                            
proc str_to_i8*(str: cstring, base: uint32_t, error: ptr bool_t): int8_t
proc str_to_i16*(str: cstring, base: uint32_t, error: ptr bool_t): int16_t
proc str_to_i32*(str: cstring, base: uint32_t, error: ptr bool_t): int32_t
proc str_to_i64*(str: cstring, base: uint32_t, error: ptr bool_t): int64_t
proc str_to_u8*(str: cstring, base: uint32_t, error: ptr bool_t): uint8_t
proc str_to_u16*(str: cstring, base: uint32_t, error: ptr bool_t): uint16_t
proc str_to_u32*(str: cstring, base: uint32_t, error: ptr bool_t): uint32_t
proc str_to_u64*(str: cstring, base: uint32_t, error: ptr bool_t): uint64_t
proc str_to_r32*(str: cstring, error: ptr bool_t): real32_t
proc str_to_r64*(str: cstring, error: ptr bool_t): real64_t

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/stream.h" .}

# Streams

let
  kSTDIN* {.nodecl.}: ptr Stream
  kSTDOUT* {.nodecl.}: ptr Stream
  kSTDERR* {.nodecl.}: ptr Stream
  kDEVNULL* {.nodecl.}: ptr Stream

proc stm_from_block*(data: ptr byte_t, size: uint32_t): ptr Stream
proc stm_memory*(size: uint32_t): ptr Stream
proc stm_from_file*(pathname: cstring, error: ptr ferror_t): ptr Stream
proc stm_to_file*(pathname: cstring, error: ptr ferror_t): ptr Stream
proc stm_append_file*(pathname: cstring, error: ptr ferror_t): ptr Stream
proc stm_socket*(socket: ptr Socket): ptr Stream
proc stm_close*(stm: ptr ptr Stream)
proc stm_get_write_endian*(stm: ptr Stream): endian_t
proc stm_get_read_endian*(stm: ptr Stream): endian_t
proc stm_set_write_endian*(stm: ptr Stream, endian: endian_t)
proc stm_set_read_endian*(stm: ptr Stream, endian: endian_t)
proc stm_get_write_utf*(stm: ptr Stream): unicode_t
proc stm_get_read_utf*(stm: ptr Stream): unicode_t
proc stm_set_write_utf*(stm: ptr Stream, unicode: unicode_t)
proc stm_set_read_utf*(stm: ptr Stream, unicode: unicode_t)
proc stm_is_memory*(stm: ptr Stream): bool_t
proc stm_bytes_written*(stm: ptr Stream): uint64_t
proc stm_bytes_readed*(stm: ptr Stream): uint64_t
proc stm_col*(stm: ptr Stream): uint32_t
proc stm_row*(stm: ptr Stream): uint32_t
proc stm_token_col*(stm: ptr Stream): uint32_t
proc stm_token_row*(stm: ptr Stream): uint32_t
proc stm_token_lexeme*(stm: ptr Stream): cstring
proc stm_token_escapes*(stm: ptr Stream, active_escapes: bool_t)
proc stm_token_spaces*(stm: ptr Stream, active_spaces: bool_t)
proc stm_token_comments*(stm: ptr Stream, active_comments: bool_t)
proc stm_state*(stm: ptr Stream): sstate_t
proc stm_file_err*(stm: ptr Stream): ferror_t
proc stm_sock_err*(stm: ptr Stream): serror_t
proc stm_corrupt*(stm: ptr Stream)
proc stm_str*(stm: ptr Stream): ptr String
proc stm_buffer*(stm: ptr Stream): ptr byte_t
proc stm_buffer_size*(stm: ptr Stream): uint32_t
proc stm_write*(stm: ptr Stream, data: ptr byte_t, size: uint32_t)
proc stm_write_char*(stm: ptr Stream, codepoint: uint32_t)
proc stm_printf*(stm: ptr Stream, format: cstring): uint32_t {.varargs.}
proc stm_writef*(stm: ptr Stream, str: cstring): uint32_t
proc stm_write_bool*(stm: ptr Stream, value: bool_t)
proc stm_write_i8*(stm: ptr Stream, value: int8_t)
proc stm_write_i16*(stm: ptr Stream, value: int16_t)
proc stm_write_i32*(stm: ptr Stream, value: int32_t)
proc stm_write_i64*(stm: ptr Stream, value: int64_t)
proc stm_write_u8*(stm: ptr Stream, value: uint8_t)
proc stm_write_u16*(stm: ptr Stream, value: uint16_t)
proc stm_write_u32*(stm: ptr Stream, value: uint32_t)
proc stm_write_u64*(stm: ptr Stream, value: uint64_t)
proc stm_write_r32*(stm: ptr Stream, value: real32_t)
proc stm_write_r64*(stm: ptr Stream, value: real64_t)
proc stm_read*(stm: ptr Stream, data: ptr byte_t, size: uint32_t): uint32_t
proc stm_read_char*(stm: ptr Stream): uint32_t
proc stm_read_chars*(stm: ptr Stream, n: uint32_t): cstring
proc stm_read_line*(stm: ptr Stream): cstring
proc stm_read_trim*(stm: ptr Stream): cstring
proc stm_read_token*(stm: ptr Stream): ltoken_t
proc stm_read_i8_tok*(stm: ptr Stream): int8_t
proc stm_read_i16_tok*(stm: ptr Stream): int16_t
proc stm_read_i32_tok*(stm: ptr Stream): int32_t
proc stm_read_i64_tok*(stm: ptr Stream): int64_t
proc stm_read_u8_tok*(stm: ptr Stream): uint8_t
proc stm_read_u16_tok*(stm: ptr Stream): uint16_t
proc stm_read_u32_tok*(stm: ptr Stream): uint32_t
proc stm_read_u64_tok*(stm: ptr Stream): uint64_t
proc stm_read_r32_tok*(stm: ptr Stream): real32_t
proc stm_read_r64_tok*(stm: ptr Stream): real64_t
proc stm_read_bool*(stm: ptr Stream): bool_t
proc stm_read_i8*(stm: ptr Stream): int8_t
proc stm_read_i16*(stm: ptr Stream): int16_t
proc stm_read_i32*(stm: ptr Stream): int32_t
proc stm_read_i64*(stm: ptr Stream): int64_t
proc stm_read_u8*(stm: ptr Stream): uint8_t
proc stm_read_u16*(stm: ptr Stream): uint16_t
proc stm_read_u32*(stm: ptr Stream): uint32_t
proc stm_read_u64*(stm: ptr Stream): uint64_t
proc stm_read_r32*(stm: ptr Stream): real32_t
proc stm_read_r64*(stm: ptr Stream): real64_t
proc stm_skip*(stm: ptr Stream, size: uint32_t)
proc stm_skip_bom*(stm: ptr Stream)
proc stm_skip_token*(stm: ptr Stream, token: ltoken_t)
proc stm_flush*(stm: ptr Stream)
proc stm_pipe*(`from`: ptr Stream, to: ptr Stream, n: uint32_t)

template stm_read_enum*(stm: ptr Stream, T: typedesc[enum]): T =
  cast[T](stm_read_i32(stm))

template stm_write_enum*[T: enum](stm: ptr Stream, value: T) =
  stm_write_i32(stm, cast[int32_t](value))

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/array.h" .}

proc array_create*[T](esize: uint16_t, `type`: cstring): ptr Array[T]
proc array_copy*[T](arr: ptr Array[T], func_copy: FPtr_scopy, ty: cstring): ptr Array[T]
proc array_copy_ptr*[T: ptr](arr: ptr Array[T], func_copy: FPtr_scopy, ty: cstring): ptr Array[T]
proc array_read*[T](stream: ptr Stream, esize: uint16_t, func_read_init: FPtr_read_init, ty: cstring): ptr Array[T]
proc array_read_ptr*[T: ptr](stream: ptr Stream, func_read_init: FPtr_read_init, ty: cstring): ptr Array[T]
proc array_destroy*[T](arr: ptr ptr Array[T], func_remove: FPtr_remove, ty: cstring)
proc array_destopt*[T](arr: ptr ptr Array[T], func_remove: FPtr_remove, ty: cstring)
proc array_destroy_ptr*[T: ptr](arr: ptr ptr Array[T], func_destroy: FPtr_destroy, ty: cstring)
proc array_destopt_ptr*[T: ptr](arr: ptr ptr Array[T], func_destroy: FPtr_destroy, ty: cstring)
proc array_clear*[T](arr: ptr Array[T], func_remove: FPtr_remove)
proc array_clear_ptr*[T: ptr](arr: ptr Array[T], func_remove: FPtr_remove)
proc array_write*[T](stream: ptr Stream, arr: ptr Array[T], func_write: FPtr_write)
proc array_write_ptr*[T: ptr](stream: ptr Stream, arr: ptr Array[T], func_write: FPtr_write)
proc array_size*[T](arr: ptr Array[T]): uint32_t
proc array_esize*[T](arr: ptr Array[T]): uint32_t
proc array_get*[T](arr: ptr Array[T], pos: uint32_t): ptr byte_t
proc array_get_last*[T](arr: ptr Array[T]): ptr byte_t
proc array_all*[T](arr: ptr Array[T]): ptr byte_t
proc array_insert*[T](arr: ptr Array[T], pos: uint32_t, n: uint32_t): ptr byte_t
proc array_insert0*[T](arr: ptr Array[T], pos: uint32_t, n: uint32_t): ptr byte_t
proc array_join*[T](dest: ptr Array[T], src: ptr Array[T], func_copy: FPtr_scopy)
proc array_join_ptr*[T: ptr](dest: ptr Array[T], src: ptr Array[T], func_copy: FPtr_scopy)
proc array_delete*[T](arr: ptr Array[T], pos: uint32_t, n: uint32_t, func_remove: FPtr_remove)
proc array_delete_ptr*[T: ptr](arr: ptr Array[T], pos: uint32_t, n: uint32_t, func_remove: FPtr_destroy)
proc array_pop*[T](arr: ptr Array[T], func_remove: FPtr_remove)
proc array_pop_ptr*[T: ptr](arr: ptr Array[T], func_destroy: FPtr_destroy)
proc array_sort*[T](arr: ptr Array[T], func_compare: FPtr_compare)
proc array_sort_ex*[T](arr: ptr Array[T], func_compare: FPtr_compare_ex, data: pointer)
proc array_sort_ptr*[T: ptr](arr: ptr Array[T], func_compare: FPtr_compare)
proc array_sort_ex_ptr*[T: ptr](arr: ptr Array[T], func_compare: FPtr_compare_ex, data: pointer)
proc array_search*[T](arr: ptr Array[T], func_compare: FPtr_compare, key: pointer, pos: ptr uint32_t): ptr byte_t
proc array_search_ptr*[T: ptr](arr: ptr Array[T], func_compare: FPtr_compare, key: pointer, pos: ptr uint32_t): ptr byte_t
proc array_bsearch*[T](arr: ptr Array[T], func_compare: FPtr_compare, key: pointer, pos: ptr uint32_t): ptr byte_t
proc array_bsearch_ptr*[T: ptr](arr: ptr Array[T], func_compare: FPtr_compare, key: pointer, pos: ptr uint32_t): ptr byte_t

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/rbtree.h" .}

proc rbtree_create*[T](cmp: FPtr_compare, esize: uint16_t, ksize: uint16_t,
                       ty: cstring): ptr RBTree[T]
proc rbtree_destroy*[T](tree: ptr ptr RBTree[T], rm: FPtr_remove,
                        destroyKey: FPtr_destroy, ty: cstring)
proc rbtree_destroy_ptr*[T: ptr](tree: ptr ptr RBTree[T], destroy: FPtr_destroy,
                                 destroyKey: FPtr_destroy, ty: cstring)
proc rbtree_size*[T](tree: ptr RBTree[T]): uint32_t
proc rbtree_get*[T](tree: ptr RBTree[T], key: pointer, isptr: bool_t): ptr byte_t
proc rbtree_insert*[T](tree: ptr RBTree[T], key: pointer, cp: FPtr_copy): ptr byte_t
proc rbtree_insert_ptr*[T: ptr](tree: ptr RBTree[T], p: pointer): bool_t
proc rbtree_delete*[T](tree: ptr RBTree[T], key: pointer, rm: FPtr_remove,
                       kdel: FPtr_destroy): bool_t
proc rbtree_delete_ptr*[T: ptr](tree: ptr RBTree[T], key: pointer,
                                rm: FPtr_destroy, kdel: FPtr_destroy): bool_t
proc rbtree_first*[T](tree: ptr RBTree[T]): ptr byte_t
proc rbtree_last*[T](tree: ptr RBTree[T]): ptr byte_t
proc rbtree_next*[T](tree: ptr RBTree[T]): ptr byte_t
proc rbtree_prev*[T](tree: ptr RBTree[T]): ptr byte_t
proc rbtree_first_ptr*[T: ptr](tree: ptr RBTree[T]): ptr byte_t
proc rbtree_last_ptr*[T: ptr](tree: ptr RBTree[T]): ptr byte_t
proc rbtree_next_ptr*[T: ptr](tree: ptr RBTree[T]): ptr byte_t
proc rbtree_prev_ptr*[T: ptr](tree: ptr RBTree[T]): ptr byte_t
proc rbtree_get_key*[T](tree: ptr RBTree[T]): cstring
proc rbtree_check*[T](tree: ptr RBTree[T]): bool_t                                            

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/regex.h" .}

# Regular expressions

proc regex_create*(pattern: cstring): ptr RegEx
proc regex_destroy*(regex: ptr ptr RegEx)
proc regex_match*(regex: ptr Regex, str: cstring): bool_t

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/dbind.h" .}

# Data binding

proc dbind_imp*(`type`: cstring, size: uint16_t, mname: cstring,
                mtype: cstring, moffset: uint16_t, msize: uint16_t)
proc dbind_enum_imp*(`type`: cstring, name: cstring, value: enum_t,
                     alias: cstring)
proc dbind_create_imp*(`type`: cstring): ptr byte_t
proc dbind_init_imp*(data: ptr byte_t, `type`: cstring)
proc dbind_remove_imp*(data: ptr byte_t, `type`: cstring)
proc dbind_destroy_imp*(data: ptr ptr byte_t, `type`: cstring)
proc dbind_destopt_imp*(data: ptr ptr byte_t, `type`: cstring)
proc dbind_read_imp*(stm: ptr Stream, `type`: cstring)
proc dbind_write_imp*(stm: ptr Stream, data: pointer, `type`: cstring)
proc dbind_default_imp*(`type`: cstring, mname: cstring, value: pointer)
proc dbind_range_imp*(`type`: cstring, mname: cstring, min: pointer, max: pointer)
proc dbind_precision_imp*(`type`: cstring, mname: cstring, prec: pointer)
proc dbind_increment_imp*(`type`: cstring, mname: cstring, incr: pointer)
proc dbind_suffix_imp*(`type`: cstring, mname: cstring, suffix: cstring)

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/event.h" .}

# Event handling

proc listener_imp*(obj: pointer, func_event_handler: ptr FPtr_event_handler): ptr Listener
proc listener_destroy*(listener: ptr ptr Listener)
proc listener_update*(listener: ptr ptr Listener, new_listener: ptr Listener)
proc listener_event_imp*(listener: ptr Listener, `type`: uint32_t,
                         sender: pointer, params: pointer, result: pointer,
                         sender_type: cstring, params_type: cstring,
                         result_type: cstring)
proc listener_pass_event_imp*(listener: ptr Listener, event: ptr Event,
                              sender: pointer, sender_type: cstring)
proc event_type*(event: ptr Event): uint32_t
proc event_sender_imp*(event: ptr Event, `type`: cstring): pointer
proc event_params_imp*(event: ptr Event, `type`: cstring): pointer
proc event_result_imp*(event: ptr Event, `type`: cstring): pointer


{. pop .} #====================================================================
{. push importc, header: "nappgui/core/keybuf.h" .}

# Keyboard Buffer

proc keybuf_create*(): ptr KeyBuf
proc keybuf_destroy*(buffer: ptr ptr KeyBuf)
proc keybuf_OnUp*(buffer: ptr KeyBuf, key: vkey_t)
proc keybuf_OnDown*(buffer: ptr KeyBuf, key: vkey_t)
proc keybuf_clear*(buffer: ptr KeyBuf)
proc keybuf_pressed*(buffer: ptr KeyBuf, key: vkey_t): bool_t
proc keybuf_str*(key: vkey_t): cstring
proc keybuf_dump*(buffer: ptr KeyBuf)

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/hfile.h" .}

# High level file/directory operations

proc hfile_dir*(pathname: cstring): bool_t
proc hfile_dir_create*(pathname: cstring, error: ptr ferror_t): bool_t
proc hfile_dir_destroy*(pathname: cstring, error: ptr ferror_t): bool_t
proc hfile_dir_list*(pathname: cstring, subdirs: bool_t, error: ptr ferror_t): ptr Array[DirEntry]
proc hfile_dir_entry_remove*(entry: ptr DirEntry)
proc hfile_date*(pathname: cstring, recursive: bool_t): Date
proc hfile_dir_sync*(src: cstring, dest: cstring, recursive: bool_t,
                     removeInDest: bool_t, excepts: cstringArray,
                     exceptsSize: uint32_t, error: ptr ferror_t): bool_t
proc hfile_exists*(pathname: cstring, fileType: file_type_t): bool_t
proc hfile_is_uptodate*(src: cstring, dest: cstring): bool_t
proc hfile_copy*(pathFrom: cstring, pathTo: cstring, error: ptr ferror_t): bool_t
proc hfile_buffer*(pathname: cstring, error: ptr ferror_t): ptr Buffer
proc hfile_string*(pathname: cstring, error: ptr ferror_t): ptr String
proc hfile_stream*(pathname: cstring, error: ptr ferror_t): ptr Stream
proc hfile_from_string*(pathname: cstring, str: ptr String,
                        error: ptr ferror_t): bool_t
proc hfile_from_data*(pathname: cstring, data: ptr byte_t, size: uint32_t,
                      error: ptr ferror_t): bool_t
proc hfile_dir_loop*(pathname: cstring, listener: ptr Listener,
                     subdirs: bool_t, hiddens: bool_t,
                     error: ptr ferror_t): bool_t                      
proc hfile_appdata*(filename: cstring): ptr String
proc hfile_home_dir*(path: cstring): ptr String

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/respack.h" .}

# Resource packs

proc respack_destroy*(pack: ptr ptr ResPack)
proc respack_text*(pack: ptr ResPack, id: ResId): cstring
proc respack_file*(pack: ptr ResPack, id: ResId, size: ptr uint32_t): ptr byte_t

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/date.h" .}

# Dates

let
  kDATE_NULL* {.nodecl.}: Date

proc date_system*(): Date
proc date_add_seconds*(date: ptr Date, seconds: int32_t): Date
proc date_add_minutes*(date: ptr Date, minutes: int32_t): Date
proc date_add_hours*(date: ptr Date, hours: int32_t): Date
proc date_add_days*(date: ptr Date, days: int32_t): Date
proc date_year*(): int16_t
proc date_cmp*(date1: ptr Date, date2: ptr Date): cint
proc date_between*(date: ptr Date, dateFrom: ptr Date, dateTo: ptr Date): bool_t
proc date_is_null*(date: ptr Date): bool_t
proc date_DD_MM_YYYY_HH_MM_SS*(date: ptr Date): ptr String
proc date_YYYY_MM_DD_HH_MM_SS*(date: ptr Date): ptr String
proc date_month_en*(month: month_t): cstring
proc date_month_es*(month: month_t): cstring

{. pop .} #====================================================================
{. push importc, header: "nappgui/core/clock.h" .}

# Clocks

proc clock_create*(interval: real64_t): ptr Clock
proc clock_destroy*(clk: ptr ptr Clock)
proc clock_frame*(clk: ptr Clock, prevFrame: ptr real64_t,
                  currFrame: ptr real64_t): bool_t
proc clock_reset*(clock: ptr Clock)
proc clock_elapsed*(clock: ptr Clock): real64_t

{. pop .} #====================================================================

