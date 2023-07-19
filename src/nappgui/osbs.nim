##
## Operating Systems Basic Services
## 
## This module provides a high-level API of NAppGUI's osbs library.
## 
## `NAppGUI Draw2D Docs<https://nappgui.com/en/osbs/osbs.html>`_
## `NAppGUI Docs<https://nappgui.com/en/sdk/sdk.html>`_
##

import bindings/[osbs]

type
  Platform* {.pure.} = enum
    ## Operating system
    ##
    windows = platform_t.low.ord  ## Microsoft Windows
    macos                         ## Apple MacOSX
    linux                         ## GNU/Linux
    ios                           ## Apple iOS
  
  Device* {.pure.} = enum
    ## Device type
    ##
    desktop = device_t.low.ord    ## Desktop or laptop computer
    phone                         ## Phone
    tablet                        ## Tablet
  
  WinVer* = enum
    ## Windows versions.
    ##
    win9x = win_t.low.ord         ## Windows 95, 98 or ME
    winNt4                        ## Windows NT4
    win2k                         ## Windows 2000
    winXp                         ## Windows XP
    winXpSp1                      ## Windows XP Service Pack 1
    winXpSp2                      ## Windows XP Service Pack 2
    winXpSp3                      ## Windows XP Service Pack 3
    winVi                         ## Windows Vista
    winViSp1                      ## Windows Vista Service Pack 1
    winViSp2                      ## Windows Vista Service Pack 2
    win7                          ## Windows 7
    win7Sp1                       ## Windows 7 Service Pack 1
    win8                          ## Windows 8
    win8Sp1                       ## Windows 8 Service Pack 1
    win10                         ## Windows 10
    winNone                       ## Not windows
  
  Endian* {.pure.} = enum
    ## Endianess
    ##
    little = endian_t.low.ord     ## Little endian
    big                           ## Big endian
  
  WeekDay* {.pure.} = enum
    ## Days of the week
    ##
    sunday, monday, tuesday, wednesday, thursday, friday, saturday
  
  Month* {.pure.} = enum
    ## Months of the year
    ##
    january = month_t.low.ord
    february, march, april, may, june, july, august
    september, october, november, december
  
  FileType* {.pure.} = enum
    ## Types of files.
    ##
    file = file_type_t.low.ord  ## Ordinary file
    directory                   ## Directory/folder
    other                       ## OS reserved, ie devices, pipes, etc.
  
  FileMode* {.pure.} = enum
    ## File open modes
    ##
    read = file_mode_t.low.ord  ## Read only
    write                       ## Read and write
    append                      ## Writing at end of file
  
  FileSeek* {.pure.} = enum
    ## Initial position of the file pointer.
    ##
    start                       ## Start of file
    cur                         ## Current pointer position
    eof                         ## End of file
  
  FError* {.pure.} = enum
    ## File errors.
    ##
    exists = ferror_t.low.ord   ## The file already exists.
    noPath                      ## The directory does not exist.
    noFile                      ## The file does not exist.
    bigName                     ## The name of the file is too big.
    noFiles                     ## No more files when traversing a directory.
    noEmpty                     ## The directory is not empty.
    noAccess                    ## File cannot be accessed (ie due to permissions).
    lock                        ## File is being used by another process.
    big                         ## File size is too big.
    seekNeg                     ## Attempt to seek to a negative position.
    undef                       ## Unknown/undefined error.
    ok                          ## No error reported.
  
  PError* {.pure.} = enum
    ## Process errors.
    ##
    pipe = perror_t.low.ord     ## Error in the standard I/O channel.
    exec                        ## Error when launching a process.
    ok                          ## No error reported.
  
  SError* {.pure.} = enum
    ## Socket errors.
    ##
    noNet = serror_t.low.ord    ## No internet connection.
    noHost                      ## Unable to connect to host.
    timeout                     ## Connection timed out.
    stream                      ## Error in I/O channel when reading or writing.
    undef                       ## Uknown/undefined error.
    ok                          ## No error reported.