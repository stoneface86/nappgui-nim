
# nappgui source

This directory contains this repo's vendored copy of NAppGUI. The code is taken
from this repository, https://github.com/frang75/nappgui_src.

## Modifications

 - Replaced `README.md` with this file
 - Added `include` with all of NAppGUI's public headers
 - Removed:
   - `prj/`
   - `src/demo/`
   - `src/howto/`
   - `src/**/CMakeLists.txt`
 - Renamed:
   - `src/osbs/win/bsocket.c` -> `src/osbs/win/bsocket_win.c`
   - `src/osbs/unix/bsocket.c` -> `src/osbs/unix/bsocket_unix.c`
   - `src/osbs/win/sinfo.c` -> `src/osbs/win/bsinfo_win.c`
   - `src/osbs/osx/sinfo.c` -> `src/osbs/win/bsinfo_osx.c`
   - `src/osbs/linux/sinfo.c` -> `src/osbs/linux/bsinfo_linux.c`
   - `src/osbs/unix/sinfo.c` -> `src/osbs/win/bsinfo_unix.c`

## Source info

- Repository URL: https://github.com/frang75/nappgui_src
- Version: 1.3.0
- Git tag: v1.3.0
- License: MIT
- Author(s): Francisco García Collado
