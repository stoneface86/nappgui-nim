## 
## Operating Systems Basic Services
## 
## Low-level bindings for the `osbs` library in the NAppGUI SDK.
## 

import ../private/libnappgui
import sewer

{. pragma: cenum, importc, size: sizeof(cint) .}

{. push header: "nappgui/osbs/osbs.hxx" .} #===================================

type
  platform_t* {.cenum.} = enum
    ekWINDOWS = 1 ## Microsoft Windows
    ekMACOS       ## Apple macOS
    ekLINUX       ## GNU/Linux
    ekIOS         ## Apple iOS
  
  device_t* {.cenum.} = enum
    ekDESKTOP = 1   ## Desktop or laptop computer
    ekPHONE         ## Phone
    ekTABLET        ## Tablet
  
  win_t* {.cenum.} = enum
    ekWIN_9x = 1      ## Windows 95, 98 or ME
    ekWIN_NT4         ## Windows NT4
    ekWIN_2K          ## Windows 2000
    ekWIN_XP          ## Windows XP
    ekWIN_XP1         ## Windows XP Service Pack 1
    ekWIN_XP2         ## Windows XP Service Pack 2
    ekWIN_XP3         ## Windows XP Service Pack 3
    ekWIN_VI          ## Windows Vista
    ekWIN_VI1         ## Windows Vista Service Pack 1
    ekWIN_VI2         ## Windows Vista Service Pack 2
    ekWIN_7           ## Windows 7
    ekWIN_71          ## Windows 7 Service Pack 1
    ekWIN_8           ## Windows 8
    ekWIN_81          ## Windows 8 Service Pack 1
    ekWIN_10          ## Windows 10
    ekWIN_NO          ## Not windows
  
  endian_t* {.cenum.} = enum
    ekLITEND = 1
    ekBIGEND
  
  week_day_t* {.cenum.} = enum
    ekSUNDAY
    ekMONDAY
    ekTUESDAY
    ekWEDNESDAY
    ekTHURSDAY
    ekFRIDAY
    ekSATURDAY
  
  month_t* {.cenum.} = enum
    ekJANUARY = 1
    ekFEBRUARY
    ekMARCH
    ekAPRIL
    ekMAY
    ekJUNE
    ekJULY
    ekAUGUST
    ekSEPTEMBER
    ekOCTOBER
    ekNOVEMBER
    ekDECEMBER

  file_type_t* {.cenum.} = enum
    ekARCHIVE = 1 ## Ordinary file
    ekDIRECTORY   ## Directory / folder
    ekOTHERFILE   ## Everything else
  
  file_mode_t* {.cenum.} = enum
    ekREAD = 1    ## Read only
    ekWRITE       ## Read and write
    ekAPPEND      ## Writing at end of file

  file_seek_t* {.cenum.} = enum
    ekSEEKSET = 1     ## Start of file
    ekSEEKCUR         ## Current pointer position
    ekSEEKEND         ## End of file
  
  ferror_t* {.cenum.} = enum
    ekFEXISTS = 1
    ekFNOPATH
    ekFNOFILE
    ekFBIGNAME
    ekFNOFILES
    ekFNOEMPTY
    ekFNOACCESS
    ekFLOCK
    ekFBIG
    ekFSEEKNEG
    ekFUNDEF
    ekFOK

  perror_t* {.cenum.} = enum
    ekPPIPE = 1
    ekPEXEC
    ekPOK
  
  serror_t* {.cenum.} = enum
    ekSNONET = 1
    ekSNOHOST
    ekSTIMEOUT
    ekSSTREAM
    ekSUNDEF
    ekSOK

type
  Date* {.importc.} = object
    year*: int16_t
    month*: uint8_t
    wday*: uint8_t
    mday*: uint8_t
    hour*: uint8_t
    minute*: uint8_t
    second*: uint8_t
  
  Dir* {.importc.} = object
  File* {.importc.} = object
  Mutex* {.importc.} = object
  Proc* {.importc.} = object
  DLib* {.importc.} = object
  Thread* {.importc.} = object
  Socket* {.importc.} = object
  
  FPtr_thread_main* {.importc.} = proc(data: pointer): uint32_t {.noconv.}
  FPtr_libproc* {.importc.} = proc() {.noconv.}

{. pop .} # header ...
{. push importc, header: "nappgui/osbs/osbs.h" .} #=====================================

proc osbs_start*()
proc osbs_finish*()
proc osbs_platform*(): platform_t
proc osbs_windows*(): win_t
proc osbs_endian*(): endian_t
#proc osbs_memory_mt*(mutex: ptr Mutex)

{. pop .} # header ...
{. push importc, header: "nappgui/osbs/bfile.h" .} #====================================


proc bfile_dir_work*(pathname: cstring, size: uint32_t): uint32_t
proc bfile_dir_set_work*(pathname: cstring, error: ptr ferror_t): bool_t
proc bfile_dir_home*(pathname: cstring, size: uint32_t): uint32_t
proc bfile_dir_data*(pathname: cstring, size: uint32_t): uint32_t
proc bfile_dir_exec*(pathname: cstring, size: uint32_t): uint32_t
proc bfile_dir_create*(pathname: cstring, error: ptr ferror_t): bool_t
proc bfile_dir_open*(pathname: cstring, error: ptr ferror_t): ptr Dir
proc bfile_dir_close*(dir: ptr ptr Dir)
proc bfile_dir_get*(dir: ptr Dir, name: cstring, size: uint32_t,
                    ty: ptr file_type_t, fsize: ptr uint64, updated: ptr Date,
                    error: ptr ferror_t): bool_t
proc bfile_dir_delete*(pathname: cstring, error: ptr ferror_t): bool_t
proc bfile_create*(pathname: cstring, error: ptr ferror_t): ptr File
proc bfile_open*(pathname: cstring, mode: file_mode_t, error: ptr ferror_t): ptr File
proc bfile_close*(file: ptr ptr File)
proc bfile_lstat*(pathname: cstring, ty: ptr file_type_t, size: ptr uint64,
                  updated: ptr Date, error: ptr ferror_t): bool_t
proc bfile_fstat*(file: ptr File, ty: ptr file_type_t, size: ptr uint64,
                  updated: ptr Date, error: ptr ferror_t): bool_t
proc bfile_read*(file: ptr File, data: ptr byte_t, size: uint32_t,
                 rsize: ptr uint32_t, error: ptr ferror_t): bool_t
proc bfile_write*(file: ptr File, data: ptr byte_t, size: uint32_t,
                  wsize: ptr uint32_t, error: ptr ferror_t): bool_t
proc bfile_seek*(file: ptr File, offset: int64, whence: file_seek_t,
                 error: ptr ferror_t): bool_t
proc bfile_pos*(file: ptr File): uint64
proc bfile_delete*(pathname: cstring, error: ptr ferror_t): bool_t

{. pop .} # header ...
{. push importc, header: "nappgui/osbs/bmutex.h" .} #===================================

proc bmutex_create*(): ptr Mutex
proc bmutex_close*(mutex: ptr ptr Mutex)
proc bmutex_lock*(mutex: ptr Mutex)
proc bmutex_unlock*(mutex: ptr Mutex)

{. pop .} # header ...
{. push importc, header: "nappgui/osbs/bproc.h" .} #====================================

proc bproc_exec*(command: cstring, error: ptr perror_t): ptr Proc
proc bproc_close*(p: ptr ptr Proc)
proc bproc_cancel*(p: ptr Proc): bool_t
proc bproc_wait*(p: ptr Proc): uint32_t
proc bproc_finish*(p: ptr Proc, code: ptr uint32_t): bool_t
proc bproc_read*(p: ptr Proc, data: ptr byte_t, size: uint32_t, rsize: ptr uint32_t,
                 error: ptr perror_t): bool_t
proc bproc_eread*(p: ptr Proc, data: ptr byte_t, size: uint32_t, rsize: ptr uint32_t,
                 error: ptr perror_t): bool_t
proc bproc_write*(p: ptr Proc, data: ptr byte_t, size: uint32_t, wsize: ptr uint32_t,
                 error: ptr perror_t): bool_t
proc bproc_read_close*(p: ptr Proc): bool_t
proc bproc_eread_close*(p: ptr Proc): bool_t
proc bproc_write_close*(p: ptr Proc): bool_t
proc bproc_exit*(code: uint32_t)

{. pop .} # header ...
{. push importc, header: "nappgui/osbs/bsocket.h" .} #==================================

proc bsocket_connect*(ip: uint32_t, port: uint16_t, timeout_ms: uint32_t,
                      error: ptr serror_t): ptr Socket
proc bsocket_server*(port: uint16_t, max_connect: uint32_t,
                     error: ptr serror_t): ptr Socket
proc bsocket_accept*(socket: ptr Socket, timeout_ms: uint32_t,
                     error: ptr serror_t): ptr Socket
proc bsocket_close*(socket: ptr ptr Socket)
proc bsocket_local_ip*(socket: ptr Socket, ip: ptr uint32_t, port: ptr uint16_t)
proc bsocket_remote_ip*(socket: ptr Socket, ip: ptr uint32_t, port: ptr uint16_t)
proc bsocket_read_timeout*(socket: ptr Socket, timeout_ms: uint32_t)
proc bsocket_write_timeout*(socket: ptr Socket, timeout_ms: uint32_t)
proc bsocket_read*(socket: ptr Socket, data: ptr byte_t, size: uint32_t,
                   rsize: ptr uint32_t, error: ptr serror_t): bool_t
proc bsocket_write*(socket: ptr Socket, data: ptr byte_t, size: uint32_t,
                    wsize: ptr uint32_t, error: ptr serror_t): bool_t                  
proc bsocket_url_ip*(url: cstring, error: ptr serror_t): uint32_t
proc bsocket_str_ip*(ip: cstring): uint32_t
proc bsocket_host_name*(buffer: cstring, size: uint32_t): cstring
proc bsocket_host_name_ip*(ip: uint32_t, buffer: cstring, size: uint32_t): cstring
proc bsocket_ip_str*(ip: uint32_t): cstring
proc bsocket_hton2*(dest: ptr byte_t, src: ptr byte_t)
proc bsocket_hton4*(dest: ptr byte_t, src: ptr byte_t)
proc bsocket_hton8*(dest: ptr byte_t, src: ptr byte_t)
proc bsocket_ntoh2*(dest: ptr byte_t, src: ptr byte_t)
proc bsocket_ntoh4*(dest: ptr byte_t, src: ptr byte_t)
proc bsocket_ntoh8*(dest: ptr byte_t, src: ptr byte_t)

{. pop .} # header ...
{. push importc, header: "nappgui/osbs/bthread.h" .} #==================================

proc bthread_create_imp*(thmain: ptr FPtr_thread_main,
                         data: pointer): ptr Thread
template bthread_create*[T](
  thmain: ptr FPtr_thread_main,
  data: ptr T
): ptr Thread =
  bthread_create_imp(thmain, data)
proc bthread_close*(thread: ptr ptr Thread)
proc bthread_cancel*(thread: ptr Thread): bool_t
proc bthread_wait*(thread: ptr Thread): uint32_t
proc bthread_finish*(thread: ptr Thread, code: ptr uint32_t): bool_t
proc bthread_sleep*(milliseconds: uint32_t)

{. pop .} # header ...
{. push importc, header: "nappgui/osbs/btime.h" .} #====================================

proc btime_now*(): uint64
proc btime_date*(date: ptr Date)
proc btime_to_micro*(date: ptr Date): uint64
proc btime_to_date*(micro: uint64, date: ptr Date)

{. pop .} # header ...
{. push importc, header: "nappgui/osbs/dlib.h" .} #=====================================

proc dlib_open*(path: cstring, libname: cstring): ptr DLib
proc dlib_close*(dlib: ptr ptr DLib)
proc dlib_proc_imp*(dlib: ptr DLib, procname: cstring): ptr FPtr_libproc
proc dlib_var_imp*(dlib: ptr DLib, varname: cstring): pointer

template dlib_proc*[T](dlib: ptr DLib, procname: cstring): ptr T =
  cast[ptr T](dlib_proc_imp(dlib, procname))
template dlib_var*[T](dlib: ptr DLib, varname: cstring): ptr T =
  cast[ptr T](dlib_var_imp(dlib, varname))

{. pop .} # header ...
{. push importc, header: "nappgui/osbs/log.h" .} #======================================

proc log_printf*(format: cstring): uint32_t {.varargs.}
proc log_output*(std: bool_t, err: bool_t)
proc log_file*(pathname: cstring)
proc log_get_file*(): cstring

{. pop .} # header ...
