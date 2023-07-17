##
## 2D Drawing
## 
## Low-level bindings for the `draw2d` library in the NAppGUI SDK.
##

import ../private/libnappgui
import sewer, osbs, core, geom2d

# =============================================================================
{. push header: "nappgui/draw2d/draw2d.hxx" .}
{. pragma: cenum, importc, size: sizeof(cint) .}

# draw2d types

type
  pixformat_t* {.cenum.} = enum
    ekINDEX1
    ekINDEX2
    ekINDEX4
    ekINDEX8
    ekGRAY8
    ekRGB24
    ekRGBA32
    ekFIMAGE
  
  codec_t* {.cenum.} = enum
    ekJPG = 1
    ekPNG
    ekBMP
    ekGIF
  
  fstyle_t* {.cenum.} = enum
    ekFNORMAL       = 0
    ekFBOLD         = 1
    ekFITALIC       = 2
    ekFSTRIKEOUT    = 4
    ekFUNDERLINE    = 8
    ekFSUBSCRIPT    = 16
    ekFSUPSCRIPT    = 32
    ekFPOINTS       = 64

const
  ekFPIXELS* = ekFNORMAL

type
  linecap_t* {.cenum.} = enum
    ekLCFLAT
    ekLCSQUARE
    ekLCROUND
  
  linejoin_t* {.cenum.} = enum
    ekLJMITER
    ekLJROUND
    ekLJBEVEL
  
  fillwrap_t* {.cenum.} = enum
    ekFCLAMP
    ekFTILE
    ekFFLIP
  
  drawop_t* {.cenum.} = enum
    ekSTROKE = 1
    ekFILL
    ekSKFILL
    ekFILLSK
  
  align_t* {.cenum.} = enum
    ekLEFT = 1
    ekCENTER = 2
    ekRIGHT = 3
    ekJUSTIFY = 4

const
  ekTOP* = ekLEFT
  ekBOTTOM* = ekRIGHT

type
  ellipsis_t* {.cenum.} = enum
    ekELLIPNONE = 1
    ekELLIPBEGIN
    ekELLIPMIDDLE
    ekELLIPEND
    ekELLIPMLINE
  
  indicator_t* {.cenum.} = enum
    ekINDNONE = 0
    ekINDUP_ARROW
    ekINDDOWN_ARROW
  
  color_t* {.importc.}  = uint32_t
  DCtx* {.importc.}     = object
  Palette* {.importc.}  = object
  Pixbuf* {.importc.}   = object
  Image* {.importc.}    = object
  Font* {.importc.}     = object

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/draw2d/dctx.h" .}

# 2D Contexts

proc dctx_bitmap*(width: uint32_t, height: uint32_t, format: pixformat_t): ptr DCtx
proc dctx_image*(ctx: ptr ptr DCtx): ptr Image
proc draw_clear*(ctx: ptr DCtx, color: color_t)
proc draw_matrixf*(ctx: ptr DCtx, t2d: ptr T2Df)
proc draw_matrixd*(ctx: ptr DCtx, t2d: ptr T2Dd)
proc draw_matrix_cartesianf*(ctx: ptr DCtx, t2d: ptr T2Df)
proc draw_matrix_cartesiand*(ctx: ptr DCtx, t2d: ptr T2Dd)
proc draw_antialias*(ctx: ptr DCtx, on: bool_t)

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/draw2d/draw.h" .}

# Drawing primitives

proc draw_line*(ctx: ptr DCtx, x0: real32_t, y0: real32_t, x1: real32_t, y1: real32_t)
proc draw_polyline*(ctx: ptr DCtx, closed: bool_t, points: ptr V2Df, n: uint32_t)
proc draw_arc*(ctx: ptr DCtx, x: real32_t, y: real32_t, radius: real32_t,
               start: real32_t, sweep: real32_t)
proc draw_bezier*(ctx: ptr DCtx, x0: real32_t, y0: real32_t, x1: real32_t,
                  y1: real32_t, x2: real32_t, y2: real32_t, x3: real32_t,
                  y3: real32_t)
proc draw_line_color*(ctx: ptr DCtx, color: color_t)                            
proc draw_line_fill*(ctx: ptr DCtx)
proc draw_line_width*(ctx: ptr DCtx, width: real32_t)
proc draw_line_cap*(ctx: ptr DCtx, cap: linecap_t)
proc draw_line_join*(ctx: ptr DCtx, join: linejoin_t)
proc draw_line_dash*(ctx: ptr DCtx, pattern: ptr real32_t, n: uint32_t)
proc draw_rect*(ctx: ptr DCtx, op: drawop_t, x: real32_t, y: real32_t,
                width: real32_t, height: real32_t)
proc draw_rndrect*(ctx: ptr DCtx, op: drawop_t, x: real32_t, y: real32_t,
                   width: real32_t, height: real32_t, radius: real32_t)               
proc draw_circle*(ctx: ptr DCtx, op: drawop_t, x: real32_t, y: real32_t,
                  radius: real32_t)
proc draw_ellipse*(ctx: ptr DCtx, op: drawop_t, x: real32_t, y: real32_t,
                   radx: real32_t, rady: real32_t)
proc draw_polygon*(ctx: ptr DCtx, op: drawop_t, points: ptr V2Df, n: uint32_t)
proc draw_fill_color*(ctx: ptr DCtx, color: color_t)                                  
proc draw_fill_linear*(ctx: ptr DCtx, color: ptr color_t, stop: ptr real32_t,
                       n: uint32_t, x0: real32_t, y0: real32_t,
                       x1: real32_t, y1: real32_t)
proc draw_fill_matrix*(ctx: ptr DCtx, t2d: ptr T2Df)                      
proc draw_fill_wrap*(ctx: ptr DCtx, wrap: fillwrap_t)
proc draw_font*(ctx: ptr DCtx, font: ptr Font)
proc draw_text_color*(ctx: ptr DCtx, color: color_t)
proc draw_text*(ctx: ptr DCtx, text: cstring, x: real32_t, y: real32_t)
proc draw_text_path*(ctx: ptr DCtx, op: drawop_t, text: cstring,
                     x: real32_t, y: real32_t)
proc draw_text_width*(ctx: ptr DCtx, width: real32_t)
proc draw_text_trim*(ctx: ptr DCtx, ellipsis: ellipsis_t)
proc draw_text_align*(ctx: ptr DCtx, halign: align_t, valign: align_t)
proc draw_text_halign*(ctx: ptr DCtx, halign: align_t)
proc draw_text_extents*(ctx: ptr DCtx, text: cstring, refwidth: real32_t,
                        width: ptr real32_t, height: ptr real32_t)
proc draw_image*(ctx: ptr DCtx, img: ptr Image, x: real32_t, y: real32_t)
proc draw_image_frame*(ctx: ptr DCtx, img: ptr Image, frame: uint32_t, x: real32_t, y: real32_t)
proc draw_image_align*(ctx: ptr DCtx, halign: align_t, valign: align_t)                        

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/draw2d/drawg.h" .}

# geom2d entities

proc draw_v2df*(ctx: ptr DCtx, op: drawop_t, v2d: ptr V2Df, radius: real32_t)
proc draw_v2dd*(ctx: ptr DCtx, op: drawop_t, v2d: ptr V2Dd, radius: real32_t)
proc draw_seg2df*(ctx: ptr DCtx, seg: ptr Seg2Df)
proc draw_seg2dd*(ctx: ptr DCtx, seg: ptr Seg2Dd)
proc draw_cir2df*(ctx: ptr DCtx, op: drawop_t, cir: ptr Cir2Df)
proc draw_cir2dd*(ctx: ptr DCtx, op: drawop_t, cir: ptr Cir2Dd)
proc draw_box2df*(ctx: ptr DCtx, op: drawop_t, box: ptr Box2Df)
proc draw_box2dd*(ctx: ptr DCtx, op: drawop_t, box: ptr Box2Dd)
proc draw_obb2df*(ctx: ptr DCtx, op: drawop_t, box: ptr OBB2Df)
proc draw_obb2dd*(ctx: ptr DCtx, op: drawop_t, box: ptr OBB2Dd)
proc draw_tri2df*(ctx: ptr DCtx, op: drawop_t, box: ptr Tri2Df)
proc draw_tri2dd*(ctx: ptr DCtx, op: drawop_t, box: ptr Tri2Dd)
proc draw_pol2df*(ctx: ptr DCtx, op: drawop_t, box: ptr Pol2Df)
proc draw_pol2dd*(ctx: ptr DCtx, op: drawop_t, box: ptr Pol2Dd)

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/draw2d/color.h" .}

# colors

let
  kCOLOR_TRANSPARENT* {.nodecl.}: color_t
  kCOLOR_DEFAULT* {.nodecl.}: color_t
  kCOLOR_BLACK* {.nodecl.}: color_t
  kCOLOR_WHITE* {.nodecl.}: color_t
  kCOLOR_RED* {.nodecl.}: color_t
  kCOLOR_GREEN* {.nodecl.}: color_t
  kCOLOR_BLUE* {.nodecl.}: color_t
  kCOLOR_YELLOW* {.nodecl.}: color_t
  kCOLOR_CYAN* {.nodecl.}: color_t
  kCOLOR_MAGENTA* {.nodecl.}: color_t

proc color_rgb*(r: uint8_t, g: uint8_t, b: uint8_t): color_t
proc color_rgba*(r: uint8_t, g: uint8_t, b: uint8_t, a: uint8_t): color_t
proc color_rgbaf*(r: real32_t, g: real32_t, b: real32_t, a: real32_t): color_t
proc color_hsbf*(hue: real32_t, sat: real32_t, bright: real32_t): color_t
proc color_red*(r: uint8_t): color_t
proc color_green*(g: uint8_t): color_t
proc color_blue*(b: uint8_t): color_t
proc color_gray*(l: uint8_t): color_t
proc color_bgr*(bgr: uint32_t): color_t
proc color_html*(html: cstring): color_t
proc color_to_hsbf*(color: color_t, hue: ptr real32_t, sat: ptr real32_t,
                    bright: ptr real32_t)
proc color_to_html*(color: color_t, html: cstring, size: uint32_t)
proc color_get_rgb*(color: color_t, r: ptr uint8_t, g: ptr uint8_t, b: ptr uint8_t)
proc color_get_rgbf*(color: color_t, r: ptr real32_t, g: ptr real32_t, b: ptr real32_t)
proc color_get_rgba*(color: color_t, r: ptr uint8_t, g: ptr uint8_t,
                     b: ptr uint8_t, a: ptr uint8_t)
proc color_get_rgbaf*(color: color_t, r: ptr real32_t, g: ptr real32_t,
                      b: ptr real32_t, a: ptr real32_t)
proc color_get_alpha*(color: color_t): uint8_t
proc color_set_alpha*(color: color_t, alpha: uint8_t): color_t                     

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/draw2d/palette.h" .}

# palettes

proc palette_create*(size: uint32_t): ptr Palette
proc palette_cga2*(mode: bool_t, intense: bool_t): ptr Palette
proc palette_ega4*(): ptr Palette
proc palette_rgb8*(): ptr Palette
proc palette_gray1*(): ptr Palette
proc palette_gray2*(): ptr Palette
proc palette_gray4*(): ptr Palette
proc palette_gray8*(): ptr Palette
proc palette_binary*(zero: color_t, one: color_t): ptr Palette
proc palette_destoy*(palette: ptr ptr Palette)
proc palette_size*(palette: ptr Palette): uint32_t
proc palette_colors*(palette: ptr Palette): ptr color_t
proc palette_ccolors*(palette: ptr Palette): ptr color_t

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/draw2d/pixbuf.h" .}

# pixel buffer

proc pixbuf_create*(width: uint32_t, height: uint32_t,
                    format: pixformat_t): ptr Pixbuf
proc pixbuf_copy*(pixbuf: ptr Pixbuf): ptr Pixbuf
proc pixbuf_trim*(pixbuf: ptr Pixbuf, x: uint32_t, y: uint32_t,
                  width: uint32_t, height: uint32_t): ptr Pixbuf           
proc pixbuf_convert*(pixbuf: ptr Pixbuf, palette: ptr Palette,
                     oformat: pixformat_t): ptr Pixbuf
proc pixbuf_destroy*(pixbuf: ptr ptr Pixbuf)
proc pixbuf_format*(pixbuf: ptr Pixbuf): pixformat_t
proc pixbuf_width*(pixbuf: ptr Pixbuf): uint32_t
proc pixbuf_height*(pixbuf: ptr Pixbuf): uint32_t
proc pixbuf_size*(pixbuf: ptr Pixbuf): uint32_t
proc pixbuf_dsize*(pixbuf: ptr Pixbuf): uint32_t
proc pixbuf_cdata*(pixbuf: ptr Pixbuf): ptr byte_t
proc pixbuf_data*(pixbuf: ptr Pixbuf): ptr byte_t
proc pixbuf_format_bpp*(format: pixformat_t): uint32_t
proc pixbuf_get*(pixbuf: ptr Pixbuf, x: uint32_t, y: uint32_t): uint32_t
proc pixbuf_set*(pixbuf: ptr Pixbuf, x: uint32_t, y: uint32_t, value: uint32_t)                   

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/draw2d/image.h" .}

# images

proc image_from_pixels*(width: uint32_t, height: uint32_t, format: pixformat_t,
                        data: ptr byte_t, palette: ptr color_t,
                        palsize: uint32_t): ptr Image
proc image_from_pixbuf*(pixbuf: ptr Pixbuf, palette: ptr Palette): ptr Image
proc image_from_file*(pathname: cstring, error: ptr ferror_t): ptr Image
proc image_from_data*(data: ptr byte_t, size: uint32_t): ptr Image
proc image_from_resource*(pack: ptr ResPack, id: ResId): ptr Image
proc image_copy*(image: ptr Image): ptr Image
proc image_trim*(image: ptr Image, x: uint32_t, y: uint32_t,
                 width: uint32_t, height: uint32_t): ptr Image
proc image_rotate*(image: ptr Image, angle: real32_t, nsize: bool_t,
                   background: color_t, t2d: ptr T2Df): ptr Image
proc image_scale*(image: ptr Image, nwidth: uint32_t, nheight: uint32_t): ptr Image
proc image_read*(stm: ptr Stream): ptr Image
proc image_to_file*(image: ptr Image, pathname: cstring, error: ptr ferror_t): bool_t
proc image_write*(stm: ptr Stream, image: ptr Image)
proc image_destroy*(image: ptr ptr Image)
proc image_format*(image: ptr Image): pixformat_t
proc image_width*(image: ptr Image): uint32_t
proc image_height*(image: ptr Image): uint32_t
proc image_pixels*(image: ptr Image, format: pixformat_t): ptr Pixbuf
proc image_codec*(image: ptr Image, codec: codec_t): bool_t
proc image_get_codec*(image: ptr Image): codec_t
proc image_num_frames*(image: ptr Image): uint32_t
proc image_frame_length*(image: ptr Image, findex: uint32_t): real32_t
proc image_data_imp*(image: ptr Image, data: pointer, destroy: FPtr_destroy)
proc image_get_data_imp*(image: ptr Image): pointer
proc image_native*(image: ptr Image): pointer

{. pop .} #====================================================================
{. push importc, noconv, header: "nappgui/draw2d/font.h" .}

# Typography fonts

proc font_create*(family: cstring, size: real32_t, style: uint32_t): ptr Font
proc font_system*(size: real32_t, style: uint32_t): ptr Font
proc font_monospace*(size: real32_t, style: uint32_t): ptr Font
proc font_with_style*(font: ptr Font, style: uint32_t): ptr Font
proc font_copy*(font: ptr Font): ptr Font
proc font_destroy*(font: ptr ptr Font)
proc font_equals*(font1: ptr Font, font2: ptr Font): bool_t
proc font_regular_size*(): real32_t
proc font_small_size*(): real32_t
proc font_mini_size*(): real32_t
proc font_family*(font: ptr Font): cstring
proc font_size*(font: ptr Font): real32_t
proc font_height*(font: ptr Font): real32_t
proc font_style*(font: ptr Font): uint32_t
proc font_extents*(font: ptr Font, text: cstring, 
                   refwidth: real32_t, refheight: real32_t,
                   width: ptr real32_t, height: ptr real32_t)
proc font_exists_family*(family: cstring): bool_t
proc font_installed_families*(): ptr Array[ptr String]
proc font_native*(font: ptr Font): pointer

{. pop .} #====================================================================
