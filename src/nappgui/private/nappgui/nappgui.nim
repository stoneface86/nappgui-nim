import std/[strutils, macros, os]

type
  CmakeConfig* = enum
    ccDebug
    ccRelease
    ccReleaseWithAssert

const
  nappguiVersion*: tuple[
    major, minor, patch, build: int
  ] = (1, 3, 1, 4181)
  nappguiVersionStr* = "$1.$2.$3.$4" % [
    $nappguiVersion.major,
    $nappguiVersion.minor,
    $nappguiVersion.patch,
    $nappguiVersion.build
  ]
  compiler*: string = block:
    when defined(windows) and defined(vcc):
      "vcc"
    elif defined(linux) and defined(gcc):
      "gcc"
    elif defined(macosx) and defined(clang):
      "clang"
    else:
      ""

  thisDir = currentSourcePath().parentDir()
  includeDir = thisDir / "include"

{. push compileTime .}

func getDefine(cc: CmakeConfig): string =
  case cc
  of ccDebug: "CMAKE_DEBUG"
  of ccRelease: "CMAKE_RELEASE"
  of ccReleaseWithAssert: "CMAKE_RELEASEWITHASSERT"

func prefixQuoteShell(input: string, prefix: string): string =
  result.add(prefix)
  result.add(input.quoteShell())

func cdefine(def: string): string =
  prefixQuoteShell(def, when defined(vcc): "/D" else: "-D")

func cinclude(path: string): string =
  prefixQuoteShell(path, when defined(vcc): "/I" else: "-I")

func getPassC(config: CmakeConfig): string =
  var args: seq[string]
  args.add cdefine(config.getDefine)
  args.add cinclude(includeDir)
  when defined(windows):
    args.add cdefine("_WINDOWS")
  result = join(args, " ")

func getPassL(): string =
  var args: seq[string]
  when defined(linux):
    # libgtk3
    const gtkLibs = gorge("pkg-config gtk+-3.0 --libs", "", "0")
    args.add gtkLibs
    args.add "-lstdc++"
  elif defined(macosx):
    args.add "-framework Cocoa"
    const osxVersionMajor = block:
      var res = 0
      var parts = gorge("sw_vers -productVersion", "", "0").split('.')
      if parts.len == 3:
        res = parts[0].parseInt()
      res
    when osxVersionMajor >= 12:
      args.add "-framework UniformTypeIdentifiers"
  elif defined(windows):
    # windows standard libraries
    args.add "kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib"

  result = args.join(" ")

func name*(cc: CmakeConfig): string =
  case cc
  of ccDebug: "Debug"
  of ccRelease: "Release"
  of ccReleaseWithAssert: "ReleaseWithAssert"

{. pop .}

macro useNappguiLib*(config: static[CmakeConfig]) =
  let
    pubpassc = getPassC(config)
    pubpassl = getPassL()
  result = quote do:
    {. passC: `pubpassc` .}
    {. passL: `pubpassl` .}

macro checkCompiler*() =
  result = quote do:
    when compiler == "":
      {. error: "Cannot compile nappgui with the current compiler" .}

when isMainModule:
  import std/[compilesettings, strformat]
  
  const
    srcDir = thisDir / "src"
    buildDir = querySetting(SingleValueSetting.nimcacheDir)

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


  checkCompiler()

  const
    configInt {.intdefine.} = CmakeConfig.low.ord
    config = configInt.CmakeConfig
    
    # C flags passed when building nappgui source
    nappguiPrivateFlags = block:
      var res = joinArgs(
        cdefine(&"NAPPGUI_MAJOR={nappguiVersion.major}"),
        cdefine(&"NAPPGUI_MINOR={nappguiVersion.minor}"),
        cdefine(&"NAPPGUI_REVISION={nappguiVersion.patch}"),
        cdefine(&"NAPPGUI_BUILD={nappguiVersion.build}"),
        cdefine(&"NAPPGUI_SOURCE_DIR=\"{srcDir}\""),
        cdefine(&"NAPPGUI_BUILD_DIR=\"{buildDir}\""),
        cinclude(srcDir / "core"),
        cinclude(srcDir / "draw2d"),
        cinclude(srcDir / "geom2d"),
        cinclude(srcDir / "gui"),
        cinclude(srcDir / "inet"),
        cinclude(srcDir / "osapp"),
        cinclude(srcDir / "osbs"),
        cinclude(srcDir / "osgui"),
        cinclude(srcDir / "sewer")
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
      elif defined(linux):
        res = joinArgs(
          res,
          staticExec("pkg-config gtk+-3.0 --cflags-only-I"),
          cdefine("__GTK3__")
        )
      res


  template libraryBuilder(libname: string, body: untyped) =
    block:
      const 
        libpath = srcDir / libname
        
      macro compile(path: static[string], flags: static[string] = "") {. inject .} =
        result = newCompilePragma(libpath / path, joinArgs(nappguiPrivateFlags, flags))
      body

  {. passC: getPassC(config) .}

  libraryBuilder("sewer"):
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

  libraryBuilder("osbs"):
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

  libraryBuilder("core"):
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

  libraryBuilder("geom2d"):
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

  libraryBuilder("draw2d"):
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
      compile "gtk3/dctx_gtk.c"
      compile "gtk3/draw_gtk.c"
      compile "gtk3/osfont.c"
      compile "gtk3/osimage.c"
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

  libraryBuilder("gui"):
    compile "button.c"
    compile "combo.c"
    compile "component.c"
    compile "comwin.c"
    compile "drawctrl.c"
    compile "edit.c"
    compile "gbind.c"
    compile "globals.c"
    compile "gui.c"
    compile "imageview.c"
    compile "label.c"
    compile "layout.c"
    compile "listbox.c"
    compile "menu.c"
    compile "menuitem.c"
    compile "panel.c"
    compile "popup.c"
    compile "progress.c"
    compile "res_gui.c"
    compile "slider.c"
    compile "splitview.c"
    compile "tableview.c"
    compile "textview.c"
    compile "updown.c"
    compile "view.c"
    compile "window.c"

  libraryBuilder("osgui"):
    compile "osgui.c"
    compile "osguictx.c"
    when defined(linux):
      compile "gtk3/osbutton.c"
      compile "gtk3/oscombo.c"
      compile "gtk3/oscomwin.c"
      compile "gtk3/oscontrol.c"
      compile "gtk3/osdrawctrl.c"
      compile "gtk3/osedit.c"
      compile "gtk3/osglobals.c"
      compile "gtk3/osgui_gtk.c"
      compile "gtk3/oslabel.c"
      compile "gtk3/oslistener.c"
      compile "gtk3/osmenu.c"
      compile "gtk3/osmenuitem.c"
      compile "gtk3/ospanel.c"
      compile "gtk3/ospopup.c"
      compile "gtk3/osprogress.c"
      compile "gtk3/osslider.c"
      compile "gtk3/ossplit.c"
      compile "gtk3/ostext.c"
      compile "gtk3/osupdown.c"
      compile "gtk3/osview.c"
      compile "gtk3/oswindow.c"
    elif defined(macosx):
      compile "osx/osbutton.m"
      compile "osx/oscolor.m"
      compile "osx/oscombo.m"
      compile "osx/oscomwin.m"
      compile "osx/oscontrol.m"
      compile "osx/osdrawctrl.m"
      compile "osx/osedit.m"
      compile "osx/osglobals.m"
      compile "osx/osgui_osx.m"
      compile "osx/oslabel.m"
      compile "osx/oslistener.m"
      compile "osx/osmenu.m"
      compile "osx/osmenuitem.m"
      compile "osx/ospanel.m"
      compile "osx/ospopup.m"
      compile "osx/osprogress.m"
      compile "osx/osslider.m"
      compile "osx/ossplit.m"
      compile "osx/ostext.m"
      compile "osx/osupdown.m"
      compile "osx/osview.m"
      compile "osx/oswindow.m"
    elif defined(windows):
      compile "win/osbutton.c"
      compile "win/oscombo.c"
      compile "win/oscomwin.c"
      compile "win/oscontrol.cpp"
      compile "win/osdrawctrl.cpp"
      compile "win/osedit.c"
      compile "win/osglobals.c"
      compile "win/osimg.cpp"
      compile "win/osimglist.c"
      compile "win/osgui_win.cpp"
      compile "win/oslabel.c"
      compile "win/oslistener.c"
      compile "win/osmenu.c"
      compile "win/osmenuitem.c"
      compile "win/ospanel.c"
      compile "win/ospopup.c"
      compile "win/osprogress.c"
      compile "win/osscroll.c"
      compile "win/osslider.c"
      compile "win/ossplit.c"
      compile "win/osstyleXP.c"
      compile "win/ostext.c"
      compile "win/ostooltip.c"
      compile "win/osupdown.c"
      compile "win/osview.cpp"
      compile "win/oswindow.c"
    
  libraryBuilder("osapp"):
    compile "osapp.c"
    when defined(linux):
      compile "gtk3/osapp_gtk.c"
    elif defined(macosx):
      compile "osx/osapp_osx.m"
    elif defined(windows):
      compile "win/osapp_win.c"

  when defined(nappguiInet):
    libraryBuilder("inet"):
      compile "base64.c"
      compile "httpreq.c"
      compile "inet.c"
      compile "json.c"
      compile "url.c"
      when defined(linux):
        compile "linux/oshttpreq.c"
      elif defined(macosx):
        compile "osx/oshttpreq.m"
      elif defined(windows):
        compile "win/oshttpreq.c"
