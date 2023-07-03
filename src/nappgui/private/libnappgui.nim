

# this module builds the nappgui library from our vendored source

import std/[compilesettings, macros, os, strutils, strformat]

type
  CmakeConfig = enum
    ccDebug
    ccRelease
    ccReleaseWithAssert

{. push compileTime .}

func getDefine(cc: CmakeConfig): string =
  case cc
  of ccDebug:
    "CMAKE_DEBUG"
  of ccRelease:
    "CMAKE_RELEASE"
  of ccReleaseWithAssert:
    "CMAKE_RELEASEWITHASSERT"

func prefixQuoteShell(input: string, prefix: string): string =
  result.add(prefix)
  result.add(input.quoteShell())

func cdefine(def: string): string =
  prefixQuoteShell(def, when defined(vcc): "/D" else: "-D")

func cinclude(path: string): string =
  prefixQuoteShell(path, when defined(vcc): "/I" else: "-I")

func joinArgs(args: varargs[string]): string =
  args.join(" ")

func newCompilePragma(file, flags: string): NimNode =
  result = newTree(
    nnkPragma,
    newTree(
      nnkCall,
      newIdentNode("compile"),
      file.newLit,
      flags.newLit
    )
  )
{. pop .}

const
  nappguiVersion: tuple[major, minor, patch, build: int] = (1, 3, 1, 4181)
  thisDir = currentSourcePath().parentDir()
  nappguiDir = thisDir / "nappgui"
  nappguiSrcDir = nappguiDir / "src"
  nappguiIncludeDir = nappguiDir / "include"
  buildDir = querySetting(SingleValueSetting.nimcacheDir)
  
  config = block:
    when defined(release):
      when compileoption("assertions"):
        ccReleaseWithAssert
      else:
        ccRelease
    else:
      ccDebug

  # C flags when using the library in user code
  nappguiPublicFlags = block:
    var res = cdefine(getDefine(config))
    when defined(windows):
      res = joinArgs(
        res,
        cdefine("_WINDOWS")
      )
    res
  
  # C flags passed when building nappgui source
  nappguiPrivateFlags = block:
    var res = joinArgs(
      cdefine(&"NAPPGUI_MAJOR={nappguiVersion.major}"),
      cdefine(&"NAPPGUI_MINOR={nappguiVersion.minor}"),
      cdefine(&"NAPPGUI_REVISION={nappguiVersion.patch}"),
      cdefine(&"NAPPGUI_BUILD={nappguiVersion.build}"),
      cdefine(&"NAPPGUI_SOURCE_DIR=\"{nappguiSrcDir}\""),
      cdefine(&"NAPPGUI_BUILD_DIR=\"{buildDir}\""),
    )
    when defined(windows):
      # nim adds /DWIN32_LEAN_AND_MEAN for some reason, but we need /DWIN32 when compiling
      # this include file undefs and defines what we need. It gets included
      # first when compiling using the /FI option
      const defs = quoteShell(thisDir/"windows-defines.h")
      res = joinArgs(
        res,
        &"/EHsc /FI {defs}"
      )
    res


template libraryBuilder(libname: string, depends: openArray[string], body: untyped) =
  block:
    const 
      libpath = nappguiSrcDir / libname
      passc = block:
        var res = nappguiPrivateFlags
        for dep in depends:
          res.add(' ')
          res.add(cinclude(nappguiSrcDir / dep))
        res
      
    macro compile(path: static[string], flags: static[string] = "") {. inject .} =
      result = newCompilePragma(libpath / path, joinArgs(passc, flags))
    body

libraryBuilder("sewer", ["sewer"]):
  compile "blib.c"
  compile "bmath.cpp"
  compile "bmem.c"
  compile "cassert.c"
  compile "ptr.c"
  compile "qsort.c"
  compile "sewer.c"
  compile "types.c"
  compile "unicode.c"

  when defined(windows):
    compile "win/bmem_win.c"
    compile "win/bstdimp.c"
  else:
    compile "unix/bmem_unix.c"
    compile "unix/bstdimp.c"

libraryBuilder("osbs", ["osbs", "sewer"]):
  compile "bsocket.c"
  compile "log.c"
  compile "osbs.c"

  when defined(windows):
    compile "win/bfile.c"
    compile "win/bmutex.c"
    compile "win/bproc.c"
    compile "win/bsocket_win.c"
    compile "win/bthread.c"
    compile "win/btime.c"
    compile "win/dlib.c"
    compile "win/sinfo_win.c"
  elif defined(macosx) or defined(linux):
    when defined(linux):
      compile "linux/sinfo_linux.c"
    else:
      compile "osx/sinfo_osx.m"
    compile "unix/bfile.c"
    compile "unix/bmutex.c"
    compile "unix/bproc.c"
    compile "unix/bsocket_unix.c"
    compile "unix/bthread.c"
    compile "unix/btime.c"
    compile "unix/dlib.c"
    compile "unix/sinfo_unix.c"

libraryBuilder("core", ["core", "osbs", "sewer"]):
    compile "array.c"
    compile "bhash.c"
    compile "buffer.c"
    compile "clock.c"
    compile "date.c"
    compile "dbind.c"
    compile "heap.c"
    compile "hfile.c"
    compile "keybuf.c"
    compile "lex.c"
    compile "nfa.c"
    compile "obj.c"
    compile "rbtree.c"
    compile "regex.c"
    compile "respack.c"
    compile "stream.c"
    compile "strings.c"
    compile "tfilter.c"
    compile "core.cpp"
    compile "event.cpp"

libraryBuilder("geom2d", ["geom2d", "core", "osbs", "sewer"]):
  compile "box2d.cpp"
  compile "cir2d.cpp"
  compile "col2d.cpp"
  compile "obb2d.cpp"
  compile "pol2d.cpp"
  compile "polabel.cpp"
  compile "polpart.cpp"
  compile "r2d.cpp"
  compile "s2d.cpp"
  compile "seg2d.cpp"
  compile "t2d.cpp"
  compile "tri2d.cpp"
  compile "v2d.cpp"

libraryBuilder("draw2d", ["draw2d", "geom2d", "core", "osbs", "sewer"]):
  compile "color.c"
  compile "dctx.c"
  compile "draw2d.c"
  compile "font.c"
  compile "guictx.c"
  compile "image.c"
  compile "imgutil.c"
  compile "palette.c"
  compile "pixbuf.c"
  compile "drawg.cpp"

  when defined(linux):
    const 
      linuxflags = joinArgs(
        staticExec("pkg-config gtk+-3.0 --cflags-only-I"),
        cdefine("__GTK3__")
      )
    compile "gtk3/dctx_gtk.c", linuxflags
    compile "gtk3/draw_gtk.c", linuxflags
    compile "gtk3/osfont.c", linuxflags
    compile "gtk3/osimage.c", linuxflags
  elif defined(macosx):
    compile "osx/dctx_osx.m"
    compile "osx/draw_osx.m"
    compile "osx/osfont.m"
    compile "osx/osimage.m"
  elif defined(windows):
    compile "win/dctx_win.cpp"
    compile "win/draw_win.cpp"
    compile "win/osfont.cpp"
    compile "win/osimage.cpp"

# public C flags
{. passC: nappguiPublicFlags .}
# headers
{. passC: cinclude(nappguiIncludeDir) .}

# linking
when defined(linux):
  # libgtk3, pkg-config needs to be installed
  {. passL: staticExec("pkg-config gtk+-3.0 --libs") .}
elif defined(windows):
  # windows standard libraries
  {. passL: "kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib" .}
elif defined(macosx):
  {. passL: "-framework Cocoa" .}
  const osxVersionMajor = block:
    var res = 0
    var parts = gorge("sw_vers -productVersion").split('.')
    if parts.len == 3:
      res = parts[0].parseInt()
    res
  when osxVersionMajor >= 12:
    {. passL: "-framework UniformTypeIdentifiers" .}
