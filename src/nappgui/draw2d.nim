##
## 2D Drawing
## 
## This module provides a high-level API of NAppGUI's draw2d library.
##  

import bindings/[core, sewer, geom2d, draw2d]
import private/butils

import std/strutils

import geom2d as hgeom2d

type
  Pixformat* {.pure.} = enum
    ## Enum of pixel formats. These specify the number of bits per pixel and
    ## color model.
    ## 
    index1    ## 1 bit per pixel, indexed, 2 colors
    index2    ## 2 bits per pixel, indexed, 4 colors
    index4    ## 4 bits per pixel, indexed, 16 colors
    index8    ## 8 bits per pixel, indexed, 256 colors
    gray8     ## 8 bits per pixel, grayscale, 256 colors
    rgb24     ## 24 bits per pixel, 8 bits per channel, 3 channels (red, green, blue)
    rgba32    ## 32 bits per pixel, same as rgb24 but adds an alpha channel
    fimage    ## Original format as the image
  
  Codec* {.pure.} = enum
    ## Enum of image encoding and compression formats
    ## 
    jpg = 1   ## Joint Photographic Experts Group
    png       ## Portable Network Graphics
    bmp       ## Bitmap
    gif       ## Graphics Interchange Format
  
  FontStyle* {. size: sizeof(cint) .} = enum
    ## Style settings for fonts. Use `set[FontStyle]` to specify multiple values.
    ## 
    fsBold      ## Bold
    fsItalic    ## Italics
    fsStrikeout ## Strikeout, or a horizontal line through the center of text.
    fsUnderline ## Underline
    fsSubscript ## Subscript
    fsSupscript ## Superscript
    fsPoints    ## Use point sizes instead of pixels.

  Linecap* {.pure.} = enum
    ## Style when drawing the ends of a line.
    ## 
    flat    ## Flat termination at the last point of the line
    square  ## Termination in a box, whose center is the last point of the line
    round   ## Termination in a circle, whose center is the last point of the line
  
  Linejoin* {.pure.} = enum
    ## Style when joining lines.
    ## 
    miter   ## Union at an angle. See https://en.wikipedia.org/wiki/Miter_joint
    round   ## Rounded union.
    bevel   ## Beveled union.
  
  Fillwrap* {.pure.} = enum
    ## Behavior of the fill pattern
    ## 
    clamp   ## Last limit value is used
    tile    ## Pattern is repeated, or tiled
    flip    ## Pattern is repeated, reversing the order.
  
  DrawOp* {.pure.} = enum
    ## Operation to be performed when drawing primitives.
    ## 
    stroke = 1  ## Draw the shape outline using the default line style.
    fill        ## Fill the shape area with a color or pattern
    strokeFill  ## Stroke first, then fill
    fillStroke  ## Fill first, then stroke
  
  VAlign* {.pure.} = enum
    ## Vertical Alignment
    ##
    top = 1     ## Align to top margin
    center      ## Centered vertically
    bottom      ## Align to bottom margin
    justify     ## Expand to content
  
  HAlign* {.pure.} = enum
    ## Horizontal Alignment
    ## 
    left = 1    ## Align to left margin
    center      ## Centered horizontally
    right       ## Align to right margin
    justify     ## Expand to content

  Ellipsis* {.pure.} = enum
    ## Position of ellipsis (...) when clipping text.
    ## 
    none = 1    ## No ellipsis
    atStart     ## At the start of the text 
    middle      ## In the middle/center of the text
    atEnd       ## At the end of the text
    multiline   ## Multi-line text, no ellipsis
  
  Color* = color_t
    ## Datatype representing a color of a pixel in RGBA format. This is a
    ## 32-bit integer with the lowest byte being the red channel, and the
    ## highest byte being the alpha channel.
    ##
  
  DCtx* = object
    ## 2D Drawing context. Allows for 2D drawing commands. Also known as a
    ## canvas or surface. This object is non-copyable.
    ## 
    impl*: ptr draw2d.DCtx
      ## Implementation. Uses an untraced reference to an NAppGUI DCtx. This
      ## reference is automatically destroyed.
      ## 
  
  Palette* = object
    ## Color palette, or a table of colors for use in indexed pixel formats.
    ## This object is non-copyable.
    ## 
    impl*: ptr draw2d.Palette
  
  Pixbuf* = object
    ## Pixel buffer, or an in-memory buffer of pixel data. This object is
    ## copyable.
    ## 
    impl*: ptr draw2d.Pixbuf
  
  Image* = object
    ## Bitmap image object.
    ## 
    impl*: ptr draw2d.Image
  
  Font* = object
    ## A font object for drawing text. A Font contains a family name, size
    ## and style which determine the appearance of the text when drawn. This
    ## object is copyable.
    ##
    impl*: ptr draw2d.Font

template toImpl(f: Pixformat): pixformat_t = f.ord.pixformat_t
template toImpl(c: Linecap): linecap_t = c.ord.linecap_t
template toImpl(j: Linejoin): linejoin_t = j.ord.linejoin_t
template toImpl(o: DrawOp): drawop_t = o.ord.drawop_t
template toImpl(w: Fillwrap): fillwrap_t = w.ord.fillwrap_t
template toImpl(e: Ellipsis): ellipsis_t = e.ord.ellipsis_t
template toImpl(a: HAlign|Valign): align_t = a.ord.align_t
template toImpl(s: set[FontStyle]): uint32 = cast[cint](s).uint32

template fromImpl(f: pixformat_t): Pixformat = f.ord.Pixformat

# ======================================================================== DCtx

proc `=destroy`*(c: var DCtx) =
  assert c.impl == nil
proc `=copy`*(c: var DCtx, s: DCtx) {.error.}

proc bitmap*(width: Natural, height: Natural, format: Pixformat): DCtx =
  result.impl = dctx_bitmap(width.uint32, height.uint32, format.toImpl)

proc toImage*(ctx: var DCtx): Image =
  result.impl = dctx_image(ctx.impl.addr)

proc clear*(ctx: var DCtx, color: Color) =
  draw_clear(ctx.impl, color)

proc `antialias=`*(ctx: var DCtx, val: bool) =
  draw_antialias(ctx.impl, val.bool_t)

# ---

proc drawLine*(ctx: var DCtx, x0: float32, x1: float32, y0: float32, y1: float32) =
  draw_line(ctx.impl, x0, y0, x1, y1)

proc drawLines*(ctx: var DCtx, closed: bool, points: openArray[PointF]) =
  draw_polyline(
    ctx.impl, closed.bool_t, 
    cast[ptr V2Df](points[0].unsafeAddr), 
    points.len.uint32_t
  )

proc drawArc*(ctx: var DCtx, x: float32, y: float32, radius: float32,
              start: float32, sweep: float32) =
  draw_arc(ctx.impl, x, y, radius, start, sweep)

proc `lineColor=`*(ctx: var DCtx, color: Color) =
  draw_line_color(ctx.impl, color)

proc `lineWidth=`*(ctx: var DCtx, width: float32) =
  draw_line_width(ctx.impl, width)

proc `lineCap=`*(ctx: var DCtx, cap: Linecap) =
  draw_line_cap(ctx.impl, cap.toImpl)

proc `lineJoin=`*(ctx: var DCtx, join: Linejoin) =
  draw_line_join(ctx.impl, join.toImpl)

proc setLineDash*(ctx: var DCtx, pattern: openArray[float32]) =
  draw_line_dash(ctx.impl,
    cast[ptr float32](pattern[0].unsafeAddr), 
    pattern.len.uint32_t
  )

proc setLineFill*(ctx: var DCtx) =
  draw_line_fill(ctx.impl)

proc drawRect*(ctx: var DCtx, op: DrawOp,
               x: float32, y: float32, width: float32, height: float32) =
  draw_rect(ctx.impl, op.toImpl, x, y, width, height)

proc drawRoundedRect*(ctx: var DCtx, op: DrawOp, x: float32, y: float32,
                      width: float32, height: float32, radius: float32) =
  draw_rndrect(ctx.impl, op.toImpl, x, y, width, height, radius)

proc drawCircle*(ctx: var DCtx, op: DrawOp, x: float32, y: float32,
                 radius: float32) =
  draw_circle(ctx.impl, op.toImpl, x, y, radius)

proc drawEllipse*(ctx: var DCtx, op: DrawOp, x: float32, y: float32,
                  radx: float32, rady: float32) =
  draw_ellipse(ctx.impl, op.toImpl, x, y, radx, rady)

proc drawPolygon*(ctx: var DCtx, op: DrawOp, points: openArray[PointF]) =
  discard

proc `fillColor=`*(ctx: var DCtx, color: Color) =
  draw_fill_color(ctx.impl, color)

proc setGradientFill*(ctx: var DCtx, colors: openArray[Color],
                      stops: openArray[float32], x0: float32, y0: float32,
                      x1: float32, y1: float32) =
  let n = min(colors.len, stops.len).uint32
  draw_fill_linear(
    ctx.impl,
    cast[ptr Color](colors[0].unsafeAddr),
    cast[ptr float32](stops[0].unsafeAddr),
    n, x0, y0, x1, y1
  )

proc `fillMatrix=`*(ctx: var DCtx, mat: MatrixF) =
  draw_fill_matrix(ctx.impl, mat.impl.getPtr)

proc `fillWrap=`*(ctx: var DCtx, wrap: Fillwrap) =
  draw_fill_wrap(ctx.impl, wrap.toImpl)

proc `font=`*(ctx: var DCtx, font: Font) =
  draw_font(ctx.impl, font.impl)

proc `textColor=`*(ctx: var DCtx, color: Color) =
  draw_text_color(ctx.impl, color)

proc drawText*(ctx: var DCtx, text: string, x: float32, y: float32) =
  draw_text(ctx.impl, text.cstring, x, y)

proc drawText*(ctx: var DCtx, op: DrawOp, text: string, x: float32, y: float32) =
  draw_text_path(ctx.impl, op.toImpl, text.cstring, x, y)

proc `textWidth=`*(ctx: var DCtx, width: float32) =
  draw_text_width(ctx.impl, width)

proc `textTrim=`*(ctx: var DCtx, ellipsis: Ellipsis) =
  draw_text_trim(ctx.impl, ellipsis.toImpl)

proc setTextAlign*(ctx: var DCtx, halign: HAlign, valign: VAlign) =
  draw_text_align(ctx.impl, halign.toImpl, valign.toImpl)

proc setMulitlineTextAlign*(ctx: var DCtx, halign: HAlign) =
  draw_text_halign(ctx.impl, halign.toImpl)

proc getExtents*(ctx: var DCtx, text: string, refwidth: float32): tuple[width: float32, height: float32] =
  draw_text_extents(
    ctx.impl, text.cstring, refwidth,
    result.width.addr, result.height.addr
  )

proc drawImage*(ctx: var DCtx, image: Image, x: float32, y: float32) =
  draw_image(ctx.impl, image.impl, x, y)

proc drawImage*(ctx: var DCtx, image: Image, frame: Natural, x: float32, y: float32) =
  draw_image_frame(ctx.impl, image.impl, frame.uint32, x, y)

proc setImageAlign*(ctx: var DCtx, halign: HAlign, valign: VAlign) =
  draw_image_align(ctx.impl, halign.toImpl, valign.toImpl)

import private/butils

proc drawV2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, v2d: V2D[T], radius: float32) =
  fdispatch[T](draw_v2df, draw_v2dd, ctx.impl, op.toImpl, v2d.unsafeAddr, radius)

proc drawSeg2d*[T: SomeFloat](ctx: var DCtx, seg: Seg2D[T]) =
  fdispatch[T](draw_seg2df, draw_seg2dd, ctx.impl, seg.unsafeAddr)

proc drawCir2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, cir: Cir2D[T]) =
  fdispatch[T](draw_cir2df, draw_cir2dd, ctx.impl, op.toImpl, cir.unsafeAddr)

proc drawBox2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, box: Box2D[T]) =
  fdispatch[T](draw_box2df, draw_box2dd, ctx.impl, op.toImpl, box.unsafeAddr)

proc drawObb2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, obb: OBB2D[T]) =
  fdispatch[T](draw_obb2df, draw_obb2dd, ctx.impl, op.toImpl, obb.unsafeAddr)

proc drawTri2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, tri: Tri2D[T]) =
  fdispatch[T](draw_tri2df, draw_tri2dd, ctx.impl, op.toImpl, tri.unsafeAddr)

proc drawPol2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, pol: Pol2D[T]) =
  fdispatch[T](draw_pol2df, draw_pol2dd, ctx.impl, op.toImpl, pol.unsafeAddr)

# ======================================================================= Color

proc color*(r: uint8, g: uint8, b: uint8): Color =
  color_rgb(r, g, b)

proc color*(r: uint8, g: uint8, b: uint8, a: uint8): Color =
  color_rgba(r, g, b, a)

proc color*(r: float32, g: float32, b: float32, a: float32): Color =
  color_rgbaf(r, g, b, a)

proc color*(hue: float32, sat: float32, bright: float32): Color =
  color_hsbf(hue, sat, bright)

proc color*(html: string): Color =
  color_html(html.cstring)

proc red*(amount: uint8): Color = color_red(amount)
proc blue*(amount: uint8): Color = color_blue(amount)
proc green*(amount: uint8): Color = color_green(amount)
proc gray*(amount: uint8): Color = color_gray(amount)
proc bgr*(val: uint32): Color = color_bgr(val)

proc toHsb*(color: Color): tuple[h: float32, s: float32, b: float32] =
  color_to_hsbf(color, result.h.addr, result.s.addr, result.b.addr)

proc toHtml*(color: Color): string =
  var buf: array[8, cchar]
  color_to_html(color, cast[cstring](buf[0].addr), buf.len.uint32)
  for ch in buf:
    if ch == '\0': break
    result.add(ch)

proc getRgb*(color: Color): tuple[r: uint8, g: uint8, b: uint8] =
  color_get_rgb(color, result.r.addr, result.g.addr, result.b.addr)

proc getRgbf*(color: Color): tuple[r: float32, g: float32, b: float32] =
  color_get_rgbf(color, result.r.addr, result.g.addr, result.b.addr)
  
proc getRgba*(color: Color): tuple[r: uint8, g: uint8, b: uint8, a: uint8] =
  color_get_rgba(color, result.r.addr, result.g.addr, result.b.addr, result.a.addr)

proc getRgbaf*(color: Color): tuple[r: float32, g: float32, b: float32, a: float32] =
  color_get_rgbaf(color, result.r.addr, result.g.addr, result.b.addr, result.a.addr)

proc alpha*(color: Color): uint8 =
  color_get_alpha(color)

proc `alpha=`*(color: var Color, alpha: uint8) =
  color = color_set_alpha(color, alpha)

proc `$`*(color: Color): string =
  let channels = color.getRgba()
  result = "color($1, $2, $3, $4)" % [$channels.r.int, $channels.g.int, $channels.b.int, $channels.a.int]

# ===================================================================== Palette

proc `=destroy`*(p: var Palette) =
  if p.impl != nil:
    palette_destoy(p.impl.addr)
proc `=copy`*(d: var Palette, s: Palette) {.error.}

proc init*(T: typedesc[Palette], size: Natural): Palette =
  result.impl = palette_create(size.uint32)

proc initCga2*(T: typedesc[Palette], mode: bool, intense: bool): Palette =
  result.impl = palette_cga2(mode.bool_t, intense.bool_t)

proc initEga4*(T: typedesc[Palette]): Palette =
  result.impl = palette_ega4()

proc initRgb8*(T: typedesc[Palette]): Palette =
  result.impl = palette_rgb8()

proc initGray1*(T: typedesc[Palette]): Palette =
  result.impl = palette_gray1()

proc initGray2*(T: typedesc[Palette]): Palette =
  result.impl = palette_gray1()

proc initGray4*(T: typedesc[Palette]): Palette =
  result.impl = palette_gray1()

proc initGray8*(T: typedesc[Palette]): Palette =
  result.impl = palette_gray1()

proc init*(T: typedesc[Palette], zero: Color, one: Color): Palette =
  result.impl = palette_binary(zero, one)

proc len*(p: Palette): int =
  palette_size(p.impl).int

template rawColors(p: Palette): ptr UncheckedArray[Color] =
  cast[ptr UncheckedArray[Color]](palette_colors(p.impl))

proc `[]`*(p: Palette, i: Natural): Color =
  p.rawColors[i]

proc `[]=`*(p: var Palette, i: Natural, color: Color) =
  p.rawColors[i] = color

proc colors*(p: Palette): seq[Color] =
  let len = p.len
  result.setLen(len)
  copyMem(result[0].addr, palette_colors(p.impl), len * Color.sizeof)

proc `colors=`*(p: var Palette, colors: openArray[Color]) =
  let toCopy = min(p.len, colors.len)
  copyMem(palette_colors(p.impl), colors[0].unsafeAddr, toCopy * Color.sizeof)

# ====================================================================== Pixbuf

proc `=destroy`*(p: var Pixbuf) =
  if p.impl != nil:
    pixbuf_destroy(p.impl.addr)
proc `=copy`*(d: var Pixbuf, s: Pixbuf) =
  `=destroy`(d)
  d.impl = pixbuf_copy(s.impl)

proc init*(T: typedesc[Pixbuf], width: Natural, height: Natural,
           format = Pixformat.rgba32): Pixbuf =
  result.impl = pixbuf_create(width.uint32, height.uint32, format.toImpl)

proc init*(T: typedesc[Pixbuf], pixbuf: Pixbuf, x: Natural, y: Natural,
           width: Natural, height: Natural): Pixbuf =
  result.impl = pixbuf_trim(
    pixbuf.impl, x.uint32, y.uint32, width.uint32, height.uint32
  )

proc init*(T: typedesc[Pixbuf], pixbuf: Pixbuf, palette: Palette, format: Pixformat): Pixbuf =
  result.impl = pixbuf_convert(pixbuf.impl, palette.impl, format.toImpl)

proc format*(pixbuf: Pixbuf): Pixformat =
  pixbuf_format(pixbuf.impl).fromImpl

proc width*(pixbuf: Pixbuf): int =
  pixbuf_width(pixbuf.impl).int

proc height*(pixbuf: Pixbuf): int =
  pixbuf_height(pixbuf.impl).int

proc size*(pixbuf: Pixbuf): int =
  pixbuf_size(pixbuf.impl).int

proc dataSize*(pixbuf: Pixbuf): int =
  pixbuf_dsize(pixbuf.impl).int

proc bpp*(format: Pixformat): int =
  pixbuf_format_bpp(format.toImpl).int

proc data*(pixbuf: var Pixbuf): ptr UncheckedArray[byte] =
  cast[ptr UncheckedArray[byte]](pixbuf_data(pixbuf.impl))

proc get*(pixbuf: Pixbuf, x: Natural, y: Natural): uint32 =
  pixbuf_get(pixbuf.impl, x.uint32, y.uint32)

proc set*(pixbuf: Pixbuf, x: Natural, y: Natural, val: uint32) =
  pixbuf_set(pixbuf.impl, x.uint32, y.uint32, val)

# ======================================================================= Image

proc `=destroy`*(i: var Image) =
  if i.impl != nil:
    image_destroy(i.impl.addr)
proc `=copy`*(d: var Image, s: Image) =
  `=destroy`(d)
  d.impl = image_copy(s.impl)

proc init*(T: typedesc[Image], width: Natural, height: Natural,
           format: Pixformat, data: openArray[byte],
           palette: openArray[Color]): Image =
  result.impl = image_from_pixels(
    width.uint32, height.uint32, format.toImpl,
    data[0].unsafeAddr, palette[0].unsafeAddr, palette.len.uint32
  )

proc init*(T: typedesc[Image], pixbuf: Pixbuf, palette: Palette): Image =
  result.impl = image_from_pixbuf(pixbuf.impl, palette.impl)

proc init*(T: typedesc[Image], pathname: string): Image =
  result.impl = image_from_file(pathname.cstring, nil)

proc init*(T: typedesc[Image], image: Image, x: Natural, y: Natural,
           width: Natural, height: Natural): Image =
  result.impl = image_trim(image.impl, x.uint32, y.uint32, width.uint32, height.uint32)

# ======================================================================== Font

type
  DefaultFont* {.pure.} = enum
    ## Enum of default font families.
    ## 
    system      ## The system default font
    monospace   ## The system default monospaced font
  
  DefaultSize* {.pure.} = enum
    ## Enum of default font sizes for UI controls.
    ## 
    regular     ## Default size for most controls
    small       ## Smaller size than regular
    mini        ## Smallest size

proc `=destroy`*(f: var Font) =
  if f.impl != nil:
    font_destroy(f.impl.addr)
proc `=copy`*(d: var Font, s: Font) =
  `=destroy`(d)
  d.impl = font_copy(s.impl)

proc init*(T: typedesc[Font], family: string, size: float32,
           style: set[FontStyle] = {}): Font =
  ## Initializes a font with the given family name, size and style. Note that
  ## the size is in pixels. For point-sized fonts, include `fsPoint` in your
  ## `style` parameter, ie `{fsPoint, ...}`.
  ##
  result.impl = font_create(family.cstring, size, cast[uint32](style))

proc init*(T: typedesc[Font], font: DefaultFont, size: float32,
           style: set[FontStyle] = {}): Font =
  ## Initializes a font using a system default font family.
  ## 
  result.impl = block:
    case font
    of DefaultFont.system:
      font_system(size, style.toImpl)
    of DefaultFont.monospace:
      font_monospace(size, style.toImpl)

proc init*(T: typedesc[Font], font: Font, style: set[FontStyle]): Font =
  ## Copies a font, overriding its style.
  ##
  result.impl = font_with_style(font.impl, style.toImpl)

proc `==`*(lhs: Font, rhs: Font): bool =
  ## Equality test for two fonts. `true` is returned if both fonts are equal,
  ## or if they have the same family, size and style.
  ## 
  font_equals(lhs.impl, rhs.impl) == TRUE

proc get*(sz: DefaultSize): float32 =
  ## Gets a default font size. See the `DefaultSize` enum for details.
  ## 
  case sz
  of regular:
    font_regular_size()
  of small:
    font_small_size()
  of mini:
    font_mini_size()

proc family*(f: Font): string =
  ## Gets the family name of the font.
  ## 
  $(font_family(f.impl))

proc size*(f: Font): float32 =
  ## Gets the size of the font. The unit is in pixels unless the font's style
  ## includes `fsPoint`, in which that case it is in points.
  ## 
  font_size(f.impl)

proc height*(f: Font): float32 =
  ## Gets the cell height of the font. Cell height is the sum of the baseline
  ## and char height.
  ## 
  font_height(f.impl)

proc style*(f: Font): set[FontStyle] =
  ## Gets the font's style.
  ## 
  cast[set[FontStyle]](font_style(f.impl))

proc extents*(f: Font, text: string, refwidth: float32,
              refheight: float32): tuple[width: float32, height: float32] =
  ## Calculates the size, in pixels, of a text string using this font.
  ## `refwidth` is the maximum width.
  font_extents(
    f.impl, text.cstring, refwidth, refheight,
    result.width.addr, result.height.addr
  )

proc fontFamilyExists*(family: string): bool =
  ## Check if a font exists in the system with the given family name.
  ## 
  font_exists_family(family.cstring) == TRUE

proc getInstalledFonts*(): seq[string] =
  ## Gets a list of font family names installed in the system, sorted
  ## alphabetically.
  ## 
  var arr = font_installed_families()
  let len = array_size(arr).int
  for i in 0..<len:
    let familyPString = cast[ptr ptr String](array_get(arr, i.uint32))[]
    result.add($(tc(familyPString)))
  array_destroy_ptr(arr.addr, cast[FPtr_destroy](str_destroy), "ArrPt::String")