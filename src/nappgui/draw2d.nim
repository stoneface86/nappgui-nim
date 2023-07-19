##
## 2D Drawing
## 
## This module provides a high-level API of NAppGUI's draw2d library.
## 
## `NAppGUI Draw2D Docs<https://nappgui.com/en/draw2d/draw2d.html>`_
## `NAppGUI Docs<https://nappgui.com/en/sdk/sdk.html>`_
##  

import bindings/[core, osbs, sewer, geom2d, draw2d]
import private/butils

import std/strutils

import geom2d as hgeom2d
import osbs as hosbs

export FError
export draw2d_start, draw2d_finish

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

  LineCap* {.pure.} = enum
    ## Style when drawing the ends of a line.
    ## 
    flat    ## Flat termination at the last point of the line
    square  ## Termination in a box, whose center is the last point of the line
    round   ## Termination in a circle, whose center is the last point of the line
  
  LineJoin* {.pure.} = enum
    ## Style when joining lines.
    ## 
    miter   ## Union at an angle. See https://en.wikipedia.org/wiki/Miter_joint
    round   ## Rounded union.
    bevel   ## Beveled union.
  
  FillWrap* {.pure.} = enum
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
    ## canvas or surface. This object is non-copyable. If you create a context
    ## yourself, you must destroy it by calling `toImage`.
    ## 
    impl*: ptr draw2d.DCtx
      ## Implementation. Uses an untraced reference to an NAppGUI DCtx.
      ## 
  
  Palette* = object
    ## Color palette, or a table of colors for use in indexed pixel formats.
    ## This object is non-copyable.
    ## 
    impl*: ptr draw2d.Palette
      ## Implementation. Untraced reference to an NAppGUI Palette.
      ##
  
  Pixbuf* = object
    ## Pixel buffer, or an in-memory buffer of pixel data. This object is
    ## copyable.
    ##
    impl*: ptr draw2d.Pixbuf
      ## Implementation. Untraced reference to an NAppGUI Pixbuf.
      ##
  
  Image* = object
    ## Bitmap image object. This object is copyable.
    ## 
    impl*: ptr draw2d.Image
      ## Implementation. Untraced reference to an NAppGUI Image.
      ##
  
  Font* = object
    ## A font object for drawing text. A Font contains a family name, size
    ## and style which determine the appearance of the text when drawn. This
    ## object is copyable.
    ##
    impl*: ptr draw2d.Font
      ## Implementation. Untraced reference to an NAppGUI Font.
      ##

const
  cTransparent* = Color(0x00000000)
    ## Color constant for a completely transparent color, or black with an
    ## alpha value of 0.
    ##
  cBlack*       = Color(0xFF000000)
    ## Color constant for black, #000000.
    ##
  cWhite*       = Color(0xFFFFFFFF)
    ## Color constant for white, #FFFFFF.
    ##
  cRed*         = Color(0xFF0000FF)
    ## Color constant for red, #FF0000.
    ##
  cGreen*       = Color(0xFF00FF00)
    ## Color constant for green, #00FF00.
    ##
  cBlue*        = Color(0xFFFF0000)
    ## Color constant for blue, #0000FF.
    ##
  cYellow*      = Color(0xFF00FFFF)
    ## Color constant for yellow, #FFFF00.
    ##
  cCyan*        = Color(0xFFFFFF00)
    ## Color constant for cyan, #00FFFF.
    ##
  cMagenta*     = Color(0xFFFF00FF)
    ## Color constant for magenta, #FF00FF.

template toImpl(s: set[FontStyle]): uint32 =
  block:
    {.push warning[CastSizes]:off.}
    let res = cast[cint](s).uint32
    {.pop.}
    res

# ======================================================================== DCtx

proc `=destroy`*(c: var DCtx) =
  ## Asserts the content's implementation context has been freed. If this fails
  ## you are missing a call to `toImage`.
  ##
  assert c.impl == nil, "DCtx.impl not freed, must call toImage!"
proc `=copy`*(c: var DCtx, s: DCtx) {.error.}
  ## DCtx objects are non-copyable.
  ## 

proc init*(T: typedesc[DCtx], width: Natural, height: Natural,
           format: Pixformat): DCtx =
  ## Creates a DCtx for drawing to an in-memory pixel buffer. You must call
  ## `toImage` when finished drawing in order to destroy this context.
  ##
  result.impl = dctx_bitmap(width.uint32, height.uint32, castEnum(format, pixformat_t))

proc toImage*(ctx: var DCtx): Image =
  ## Gets the resulting image from the context. The context will be destroyed
  ## after generating the image.
  ##
  result.impl = dctx_image(ctx.impl.addr)

template clear*(ctx: var DCtx, color: Color) =
  ## Clears the entire context area with a solid color.
  ##
  draw_clear(ctx.impl, color)

template setMatrix*[T: SomeFloat](ctx: var DCtx, matrix: Matrix[T]) =
  ## Set the transformation matrix for the context. Origin is in the top-left
  ## corner, X increases rightwards and Y increases downwards.
  ##
  fdispatch[T](draw_matrixf, draw_matrixd, ctx.impl, matrix.impl.getPtr)

template setCartesianMatrix*[T: SomeFloat](ctx: var DCtx, matrix: Matrix[T]) =
  ## Sets the reference system in cartesian coordinates and sets the
  ## transformation matrix for the context. Origin is in the lower-left corner,
  ## X increases rightwards and Y increases upwards.
  ##
  fdispatch[T](draw_matrix_cartesianf, draw_matrix_cartesiand, ctx.impl, matrix.impl.getPtr)

template setAntialias*(ctx: var DCtx, antialias: bool) =
  ## Enable or disable antialiasing when drawing.
  ##
  draw_antialias(ctx.impl, antialias.bool_t)

# ---

template drawLine*(ctx: var DCtx, x0: float32, y0: float32, x1: float32, y1: float32) =
  ## Draw a line using the given coordinates.
  ##
  draw_line(ctx.impl, x0, y0, x1, y1)

proc drawLines*(ctx: var DCtx, closed: bool, points: openArray[PointF]) =
  ## Draw several joined lines. If `closed` is `true` then a line will be
  ## drawn from the last point to the first point.
  ##
  draw_polyline(
    ctx.impl, closed.bool_t, 
    cast[ptr V2Df](points[0].unsafeAddr), 
    points.len.uint32_t
  )

template drawArc*(ctx: var DCtx, x: float32, y: float32, radius: float32,
                  start: float32, sweep: float32) =
  ## Draw an arc or a segment of a circle. `start` is the starting angle of
  ## the arc with respect to vector [1,0]. `sweep` is angle from the starting
  ## angle that the arc will be drawn.
  ##
  draw_arc(ctx.impl, x, y, radius, start, sweep)

template drawBezier*(ctx: var DCtx, x0: float32, y0: float32, x1: float32,
                     y1: float32, x2: float32, y2: float32, x3: float32,
                     y3: float32) =
  ## Draw a cubic bezier curve using two endpoints and two intermediate points.
  ##
  draw_bezier(ctx.impl, x0, y0, x1, y1, x2, y2, x3, y3)

template setLineColor*(ctx: var DCtx, color: Color) =
  ## Sets the line color for drawing lines and contours.
  ##
  draw_line_color(ctx.impl, color)

template setLineWidth*(ctx: var DCtx, width: float32) =
  ## Sets the width or thickness for lines.
  ##
  draw_line_width(ctx.impl, width)

template setLineCap*(ctx: var DCtx, cap: LineCap) =
  ## Set the style of line ends.
  ##
  draw_line_cap(ctx.impl, castEnum(cap, linecap_t))

template setLineJoin*(ctx: var DCtx, join: LineJoin) =
  ## Set the style of line junctions.
  ##
  draw_line_join(ctx.impl, castEnum(join, linejoin_t))

proc setLineDash*(ctx: var DCtx, pattern: openArray[float32]) =
  ## Set a pattern for line drawing.
  ##
  draw_line_dash(ctx.impl,
    cast[ptr float32](pattern[0].unsafeAddr), 
    pattern.len.uint32_t
  )

template resetLineDash*(ctx: var DCtx) =
  ## Removes the pattern for line dashes.
  ##
  draw_line_dash(ctx.impl, nil, 0)

template setLineFill*(ctx: var DCtx) =
  ## Uses the current fill pattern for line drawing.
  ##
  draw_line_fill(ctx.impl)

template drawRect*(ctx: var DCtx, op: DrawOp,
               x: float32, y: float32, width: float32, height: float32) =
  ## Draws a rectangle.
  ##
  draw_rect(ctx.impl, castEnum(op, drawop_t), x, y, width, height)

template drawRoundedRect*(ctx: var DCtx, op: DrawOp, x: float32, y: float32,
                          width: float32, height: float32, radius: float32) =
  ## Draws a rectangle with rounded corners.
  ##                      
  draw_rndrect(ctx.impl, castEnum(op, drawop_t), x, y, width, height, radius)

template drawCircle*(ctx: var DCtx, op: DrawOp, x: float32, y: float32,
                     radius: float32) =
  ## Draws a circle.
  ##
  draw_circle(ctx.impl, castEnum(op, drawop_t), x, y, radius)

template drawEllipse*(ctx: var DCtx, op: DrawOp, x: float32, y: float32,
                      radx: float32, rady: float32) =
  ## Draws an ellipse.
  ##
  draw_ellipse(ctx.impl, castEnum(op, drawop_t), x, y, radx, rady)

template drawPolygon*(ctx: var DCtx, op: DrawOp, points: openArray[PointF]) =
  ## Draws a polygon made up of the given points array.
  ##
  draw_polygon(ctx.impl, castEnum(op, drawop_t), 
    cast[ptr V2Df](points[0].unsafeAddr),
    points.len.uint32
  )

template setFillColor*(ctx: var DCtx, color: Color) =
  ## Sets a solid color for filling areas.
  ##
  draw_fill_color(ctx.impl, color)

proc setGradientFill*(ctx: var DCtx, colors: openArray[Color],
                      stops: openArray[float32], x0: float32, y0: float32,
                      x1: float32, y1: float32) =
  ## Sets a linear gradient for filling areas. If `colors` and `stops` are not
  ## the same length, then both will be treated with the length of the smallest
  ## one.
  ##
  let n = min(colors.len, stops.len).uint32
  draw_fill_linear(
    ctx.impl,
    cast[ptr Color](colors[0].unsafeAddr),
    cast[ptr float32](stops[0].unsafeAddr),
    n, x0, y0, x1, y1
  )

template setFillMatrix*(ctx: var DCtx, mat: MatrixF) =
  ## Sets a transformation matrix for the fill pattern.
  ##
  draw_fill_matrix(ctx.impl, mat.impl.getPtr)

template setFillWrap*(ctx: var DCtx, wrap: Fillwrap) =
  ## Sets the behavior of the gradient or fill pattern.
  ##
  draw_fill_wrap(ctx.impl, castEnum(wrap, fillwrap_t))

template setFont*(ctx: var DCtx, font: Font) =
  ## Sets the font for text drawing.
  ##
  draw_font(ctx.impl, font.impl)

template setTextColor*(ctx: var DCtx, color: Color) =
  ## Sets the text color.
  ##
  draw_text_color(ctx.impl, color)

template drawText*(ctx: var DCtx, text: string, x: float32, y: float32) =
  ## Draw a block of text.
  ##
  draw_text(ctx.impl, text.cstring, x, y)

template drawText*(ctx: var DCtx, op: DrawOp, text: string, x: float32,
                   y: float32) =
  ## Draw a block of text as a geometric area. This overload of drawText allows
  ## you to use gradients, only draw the outline, etc. Keep in mind that this
  ## operation is much less efficient than the the plain drawText overload.
  ##
  draw_text_path(ctx.impl, castEnum(op, drawop_t), text.cstring, x, y)

template setTextWidth*(ctx: var DCtx, width: float32) =
  ## Sets the width of the text block for drawing text. If the text to draw
  ## exceeds this width, it span multiple lines. Use `-1.0f` to always draw
  ## the text on a single line.
  ##
  draw_text_width(ctx.impl, width)

template setTextTrim*(ctx: var DCtx, ellipsis: Ellipsis) =
  ## Set the trim style for when the text is trimmed when it exceeds the width
  ## of the text block.
  ##
  draw_text_trim(ctx.impl, castEnum(ellipsis, ellipsis_t))

template setTextAlign*(ctx: var DCtx, halign: HAlign, valign: VAlign) =
  ## Sets the alignment of the text with respect to the insertion point.
  ##
  draw_text_align(ctx.impl, castEnum(halign, align_t), castEnum(valign, align_t))

template setMulitlineTextAlign*(ctx: var DCtx, halign: HAlign) =
  ## Sets the horizontal alignment of text for a multi-line text block. This
  ## setting only applies to multi-line text.
  ##
  draw_text_halign(ctx.impl, castEnum(halign, align_t))

proc getExtents*(ctx: var DCtx, text: string, refwidth: float32): tuple[width: float32, height: float32] =
  ## Gets the size of a block of text. If `refwidth > 0` then the resulting
  ## width will be bounded by this value and the resulting height will expand
  ## to accomodate all the text.
  ##
  draw_text_extents(
    ctx.impl, text.cstring, refwidth,
    result.width.addr, result.height.addr
  )

template drawImage*(ctx: var DCtx, image: Image, x: float32, y: float32) =
  ## Draw an image.
  ##
  draw_image(ctx.impl, image.impl, x, y)

template drawImage*(ctx: var DCtx, image: Image, frame: Natural, x: float32, y: float32) =
  ## Draw a frame in an image. Only images created from a GIF support multiple
  ## frames.
  ##
  draw_image_frame(ctx.impl, image.impl, frame.uint32, x, y)

template setImageAlign*(ctx: var DCtx, halign: HAlign, valign: VAlign) =
  ## Sets the alignments used when drawing images.
  ##
  draw_image_align(ctx.impl, castEnum(halign, align_t), castEnum(valign, align_t))

template drawV2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, v2d: V2D[T], radius: float32) =
  ## Draws a point representing the given vector.
  ##
  fdispatch[T](draw_v2df, draw_v2dd, ctx.impl, castEnum(op, drawop_t), v2d.unsafeAddr, radius)

template drawSeg2d*[T: SomeFloat](ctx: var DCtx, seg: Seg2D[T]) =
  ## Draws a line segment.
  ##
  fdispatch[T](draw_seg2df, draw_seg2dd, ctx.impl, seg.unsafeAddr)

template drawCir2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, cir: Cir2D[T]) =
  ## Draws a circle.
  ##
  fdispatch[T](draw_cir2df, draw_cir2dd, ctx.impl, castEnum(op, drawop_t), cir.unsafeAddr)

template drawBox2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, box: Box2D[T]) =
  ## Draws a box.
  ##
  fdispatch[T](draw_box2df, draw_box2dd, ctx.impl, castEnum(op, drawop_t), box.unsafeAddr)

template drawObb2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, obb: OBB2D[T]) =
  ## Draws an oriented box.
  ##
  fdispatch[T](draw_obb2df, draw_obb2dd, ctx.impl, castEnum(op, drawop_t), obb.unsafeAddr)

template drawTri2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, tri: Tri2D[T]) =
  ## Draws a triangle.
  ##
  fdispatch[T](draw_tri2df, draw_tri2dd, ctx.impl, castEnum(op, drawop_t), tri.unsafeAddr)

template drawPol2d*[T: SomeFloat](ctx: var DCtx, op: DrawOp, pol: Pol2D[T]) =
  ## Draws a polygon.
  ## 
  fdispatch[T](draw_pol2df, draw_pol2dd, ctx.impl, castEnum(op, drawop_t), pol.unsafeAddr)

# ======================================================================= Color

template color*(r: uint8, g: uint8, b: uint8): Color =
  ## Create a color using the given values for red, green and blue.
  ##
  color_rgb(r, g, b)

template color*(r: uint8, g: uint8, b: uint8, a: uint8): Color =
  ## Create a color using the given values for red, green, blue and alpha.
  ##
  color_rgba(r, g, b, a)

template color*(r: float32, g: float32, b: float32, a: float32): Color =
  ## Convenience overload for float values in range 0.0f-1.0f.
  ##
  color_rgbaf(r, g, b, a)

template color*(hue: float32, sat: float32, bright: float32): Color =
  ## Create a color from a HSB pair (hue, saturation, brightness)
  ##
  color_hsbf(hue, sat, bright)

template color*(html: string): Color =
  ## Create a color from html notation. The string must be a hexadecimal number
  ## in format `#RRGGBB` where `RR` is the red channel, `GG` is green and 
  ## `BB` is blue.
  ##
  color_html(html.cstring)

template red*(amount: uint8): Color = color_red(amount)
  ## Creates a color using only the red channel.
  ##

template blue*(amount: uint8): Color = color_blue(amount)
  ## Creates a color using only the blue channel.
  ##

template green*(amount: uint8): Color = color_green(amount)
  ## Creates a color using only the green channel.
  ##

template gray*(amount: uint8): Color = color_gray(amount)
  ## Creates a grayscale color, or a color with all channels set to `amount`.
  ##

template bgr*(val: uint32): Color = color_bgr(val)
  ## Creates a color from a BGR value.
  ##

proc toHsb*(color: Color): tuple[h: float32, s: float32, b: float32] =
  ## Gets the HSB components of a color.
  ##
  color_to_hsbf(color, result.h.addr, result.s.addr, result.b.addr)

proc toHtml*(color: Color): string =
  ## Gets the HTML string of a color.
  ##
  var buf: array[8, cchar]
  color_to_html(color, cast[cstring](buf[0].addr), buf.len.uint32)
  for ch in buf:
    if ch == '\0': break
    result.add(ch)

proc getRgb*(color: Color): tuple[r: uint8, g: uint8, b: uint8] =
  ## Gets the individual RGB components of a color.
  ##
  color_get_rgb(color, result.r.addr, result.g.addr, result.b.addr)

proc getRgbf*(color: Color): tuple[r: float32, g: float32, b: float32] =
  ## Gets the individual RGB components of a color, in floating point.
  ##
  color_get_rgbf(color, result.r.addr, result.g.addr, result.b.addr)
  
proc getRgba*(color: Color): tuple[r: uint8, g: uint8, b: uint8, a: uint8] =
  ## Gets the individual RGB components of a color, including alpha.
  ##
  color_get_rgba(color, result.r.addr, result.g.addr, result.b.addr, result.a.addr)

proc getRgbaf*(color: Color): tuple[r: float32, g: float32, b: float32, a: float32] =
  ## Gets the individual RGB components of a color, including alpha, in
  ## floating point.
  ##
  color_get_rgbaf(color, result.r.addr, result.g.addr, result.b.addr, result.a.addr)

template alpha*(color: Color): uint8 =
  ## Gets the alpha component of a color.
  ##
  color_get_alpha(color)

template `alpha=`*(color: var Color, alpha: uint8) =
  ## Sets the alpha component of a color.
  ##
  color = color_set_alpha(color, alpha)

proc `$`*(color: Color): string =
  ## Get a string representation of a color.
  ##
  let channels = color.getRgba()
  result = "color($1, $2, $3, $4)" % [$channels.r.int, $channels.g.int, $channels.b.int, $channels.a.int]

# ===================================================================== Palette

proc `=destroy`*(p: var Palette) =
  ## Destructor for `Palette`. Destroys the NAppGUI Palette reference.
  ##
  if p.impl != nil:
    palette_destoy(p.impl.addr)
proc `=copy`*(d: var Palette, s: Palette) {.error.}
  ## The Palette object is not copyable.
  ##

proc init*(T: typedesc[Palette], size: Natural): Palette =
  ## Initialize a Palette with a given size.
  ##
  result.impl = palette_create(size.uint32)

proc initCga2*(T: typedesc[Palette], mode: bool, intense: bool): Palette =
  ## Initialize a 2-bit palette with CGA colors. Use `mode = true` for CGA
  ## mode 1. Use `intense = true` for bright colors.
  ##
  result.impl = palette_cga2(mode.bool_t, intense.bool_t)

proc initEga4*(T: typedesc[Palette]): Palette =
  ## Initialize a default palette for EGA cards (16 colors, 4 bits).
  ##
  result.impl = palette_ega4()

proc initRgb8*(T: typedesc[Palette]): Palette =
  ## Initialize a default 8-bit RGB palette.
  ##
  result.impl = palette_rgb8()

proc initGray1*(T: typedesc[Palette]): Palette =
  ## Initialize a monochrome palette (2 colors, 1 bit).
  ##
  result.impl = palette_gray1()

proc initGray2*(T: typedesc[Palette]): Palette =
  ## Initialize a grayscale palette of 4 shades (2 bits).
  ##
  result.impl = palette_gray1()

proc initGray4*(T: typedesc[Palette]): Palette =
  ## Initialize a grayscale palette of 16 shades (4 bits).
  ##
  result.impl = palette_gray1()

proc initGray8*(T: typedesc[Palette]): Palette =
  ## Initialize a grayscale palette of 256 shades (8 bits).
  ##
  result.impl = palette_gray1()

proc init*(T: typedesc[Palette], zero: Color, one: Color): Palette =
  ## Create a 2-color palette with the given colors for indices 0 and 1.
  ##
  result.impl = palette_binary(zero, one)

template len*(p: Palette): int =
  ## Gets the number of colors in the palette.
  ##
  palette_size(p.impl).int

template rawColors(p: Palette): ptr UncheckedArray[Color] =
  cast[ptr UncheckedArray[Color]](palette_colors(p.impl))

template `[]`*(p: Palette, i: Natural): Color =
  ## Get a color for index `i`.
  ##
  p.rawColors[i]

template `[]=`*(p: var Palette, i: Natural, color: Color) =
  ## Set a color for index `i`.
  ##
  p.rawColors[i] = color

proc colors*(p: Palette): seq[Color] =
  ## Get a `seq` of all colors in the palette.
  ##
  let len = p.len
  result.setLen(len)
  copyMem(result[0].addr, palette_colors(p.impl), len * Color.sizeof)

proc `colors=`*(p: var Palette, colors: openArray[Color]) =
  ## Sets the color palette to the given list of colors. `colors.len` should be
  ## equal to `p.len` otherwise a partial assignment will be done.
  ##
  let toCopy = min(p.len, colors.len)
  copyMem(palette_colors(p.impl), colors[0].unsafeAddr, toCopy * Color.sizeof)

# ====================================================================== Pixbuf

proc `=destroy`*(p: var Pixbuf) =
  ## Destructor for Pixbuf. Destroys its reference to an NAppGUI Pixbuf.
  if p.impl != nil:
    pixbuf_destroy(p.impl.addr)
proc `=copy`*(d: var Pixbuf, s: Pixbuf) =
  ## Copy override for Pixbuf. An entire copy of `s` is made and assigned to
  ## `d`.
  ##
  `=destroy`(d)
  d.impl = pixbuf_copy(s.impl)

proc init*(T: typedesc[Pixbuf], width: Natural, height: Natural,
           format = Pixformat.rgba32): Pixbuf =
  ## Creates a Pixbuf with the given width, height and pixel format.
  ##
  result.impl = pixbuf_create(width.uint32, height.uint32, castEnum(format, pixformat_t))

proc init*(T: typedesc[Pixbuf], pixbuf: Pixbuf, x: Natural, y: Natural,
           width: Natural, height: Natural): Pixbuf =
  ## Creates a Pixbuf from an existing one, trimming the contents.
  ##
  result.impl = pixbuf_trim(
    pixbuf.impl, x.uint32, y.uint32, width.uint32, height.uint32
  )

proc init*(T: typedesc[Pixbuf], pixbuf: Pixbuf, palette: Palette, format: Pixformat): Pixbuf =
  ## Converts a pixbuf to another format. Depending on the format of `pixbuf`
  ## and the destination format, loss of information is possible.
  ##
  result.impl = pixbuf_convert(pixbuf.impl, palette.impl, castEnum(format, pixformat_t))

template format*(pixbuf: Pixbuf): Pixformat =
  ## Get the format of the pixbuf.
  ##
  castEnum(pixbuf_format(pixbuf.impl), Pixformat)

template width*(pixbuf: Pixbuf): int =
  ## Get the width, in pixels, of the pixbuf.
  ##
  pixbuf_width(pixbuf.impl).int

template height*(pixbuf: Pixbuf): int =
  ## Get the height, in pixels, of the pixbuf.
  ##
  pixbuf_height(pixbuf.impl).int

template size*(pixbuf: Pixbuf): int =
  ## Get the buffer size, in pixels, of the pixbuf.
  ##
  pixbuf_size(pixbuf.impl).int

template dataSize*(pixbuf: Pixbuf): int =
  ## Get the buffer size, in bytes, of the pixbuf.
  ##
  pixbuf_dsize(pixbuf.impl).int

template bpp*(format: Pixformat): int =
  ## Get the number of bytes per pixel (bpp) for a given Pixformat.
  ##
  pixbuf_format_bpp(castEnum(format, pixformat_t)).int

template data*(pixbuf: var Pixbuf): ptr UncheckedArray[byte] =
  ## Gets an untraced reference to the pixel buffer, as a byte array.
  ## Use `dataSize` to get the length of this buffer.
  ##
  cast[ptr UncheckedArray[byte]](pixbuf_data(pixbuf.impl))

template get*(pixbuf: Pixbuf, x: Natural, y: Natural): uint32 =
  ## Gets a pixel in the buffer at the given x and y coordinates.
  ##
  pixbuf_get(pixbuf.impl, x.uint32, y.uint32)

template set*(pixbuf: Pixbuf, x: Natural, y: Natural, val: uint32) =
  ## Sets a pixel in the buffer at the given x and y coordinates.
  ##
  pixbuf_set(pixbuf.impl, x.uint32, y.uint32, val)

# ======================================================================= Image

proc `=destroy`*(i: var Image) =
  ## Destructor for Image. Destroys the reference to an NAppGUI Image.
  ##
  if i.impl != nil:
    image_destroy(i.impl.addr)
proc `=copy`*(d: var Image, s: Image) =
  ## Copy assignment for Image. A copy of `s` is made and assigned to `d`.
  ##
  `=destroy`(d)
  d.impl = image_copy(s.impl)

proc init*(T: typedesc[Image], width: Natural, height: Natural,
           format: Pixformat, data: openArray[byte]): Image =
  ## Creates an image from a pixel buffer. Ensure that the size of `data` is
  ## correct, or equal to `width * height * bpp(format)`
  ##
  result.impl = image_from_pixels(
    width.uint32, height.uint32, castEnum(format, pixformat_t),
    data[0].unsafeAddr, nil, 0
  )


proc init*(T: typedesc[Image], width: Natural, height: Natural,
           format: Pixformat, data: openArray[byte],
           palette: openArray[Color]): Image =
  ## Creates an image from a pixel buffer and color palette.
  ##
  result.impl = image_from_pixels(
    width.uint32, height.uint32, castEnum(format, pixformat_t),
    data[0].unsafeAddr, palette[0].unsafeAddr, palette.len.uint32
  )

proc init*(T: typedesc[Image], pixbuf: Pixbuf, palette = Palette()): Image =
  ## Creates an image from a pixbuf and palette.
  ##
  result.impl = image_from_pixbuf(pixbuf.impl, palette.impl)

proc init*(T: typedesc[Image], pathname: string): tuple[image: Image, error: FError] =
  ## Loads an image from a file.
  ##
  var err = ekFOK
  result.image.impl = image_from_file(pathname.cstring, err.addr)
  result.error = castEnum(err, FError)

proc init*(T: typedesc[Image], image: Image, x: Natural, y: Natural,
           width: Natural, height: Natural): Image =
  ## Creates an image by trimming an existing one. The new image will contain
  ## only the content within the given rectangle coordinates.
  ##
  result.impl = image_trim(image.impl, x.uint32, y.uint32, width.uint32, height.uint32)

proc rotateImpl(image: Image, angle: float32, nsize: bool, background: Color, t2d: ptr MatrixF): Image =
  result.impl = image_rotate(image.impl, angle, nsize.bool_t, background, t2d.impl.addr)

proc init*(T: typedesc[Image], image: Image, angle: float32, nsize: bool, 
           background: Color, t2d: var MatrixF): Image =
  ## Create an image by rotating an existing one by `angle` radians. To keep
  ## the same dimensions, set `nsize = false`. The transformation matrix that
  ## was used to perform this rotation will be stored in the `t2d` variable.
  ## 
  result = rotateImpl(image, angle, nsize, background, t2d.addr)

proc init*(T: typedesc[Image], image: Image, angle: float32, nsize: bool, 
           background: Color): Image =
  ## Create an image by rotating an existing one by `angle` radians. This
  ## overload does not save the transformation matrix used.
  ##
  result = rotateImpl(image, angle, nsize, background, nil)

proc init*(T: typedesc[Image], image: Image, nwidth: Natural, nheight: Natural): Image =
  ## Create an image by scaling an existing one to a new width and height.
  ##
  result.impl = image_scale(image.impl, nwidth.uint32, nheight.uint32)

template toFile*(image: Image, pathname: string): FError =
  ## Saves an image to a file.
  ##
  block:
    var res: ferror_t
    discard image_to_file(image.impl, pathname.cstring, res.addr)
    castEnum(res, FError)

template format*(image: Image): Pixformat =
  ## Gets the pixel format of the image.
  ##
  castEnum(image_format(image.impl), Pixformat)

template width*(image: Image): int =
  ## Gets the width of the image.
  ##
  image_width(image.impl).int

template height*(image: Image): int =
  ## Gets the height of the image.
  ##
  image_height(image.impl).int

template pixels*(image: Image): Pixbuf =
  ## Gets a pixel buffer of the image data.
  ##
  Pixbuf(impl: image_pixels(image.impl))

template codec*(image: Image): Codec =
  ## Gets the image codec associated with the image.
  ##
  castEnum(image_get_codec(image.impl), Codec)

template setCodec*(image: var Image, val: Codec): bool =
  ## Sets the image codec. `true` is returned on success. This can fail when
  ## setting the codec to `Codec.gif` on certain versions of Linux.
  ##
  image_codec(image.impl, castEnum(val, codec_t)).toBool

template frames*(image: Image): int =
  ## Get the number of frames or subimages an Image has. Only images with the
  ## GIF codec can have more than 1 frame.
  ##
  image_num_frames(image.impl).int

template frameLength*(image: Image, index: Natural): float32 =
  ## Get the time between frames of an animation sequence. You should only use
  ## this property with GIF images.
  ##
  image_frame_length(image.impl, index.uint32)

template data*(image: Image): pointer =
  ## Gets the user set data pointer attached to this Image.
  ##
  image_get_data_imp(image.impl)

template setData*(image: var Image, data: pointer, destroy: FPtr_destroy = nil) =
  ## Attach user data to this Image, with an optional destroyer proc.
  ##
  image_data_imp(image.impl, data, destroy)

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

template `==`*(lhs: Font, rhs: Font): bool =
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

template size*(f: Font): float32 =
  ## Gets the size of the font. The unit is in pixels unless the font's style
  ## includes `fsPoint`, in which that case it is in points.
  ## 
  font_size(f.impl)

template height*(f: Font): float32 =
  ## Gets the cell height of the font. Cell height is the sum of the baseline
  ## and char height.
  ## 
  font_height(f.impl)

template style*(f: Font): set[FontStyle] =
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

template fontFamilyExists*(family: string): bool =
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
