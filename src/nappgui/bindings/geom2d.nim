## 
## 2D Geometry
## 
## Low-level bindings for the `geom2d` library in the NAppGUI SDK.
## 

import ../private/libnappgui
import sewer, core

{. push header: "nappgui/geom2d/geom2d.hxx" .} #======================

type
  V2Df* {.importc.} = object
    x*: real32_t
    y*: real32_t
  
  V2Dd* {.importc.} = object
    x*: real64_t
    y*: real64_t
  
  S2Df* {.importc.} = object
    width*: real32_t
    height*: real32_t
  
  S2Dd* {.importc.} = object
    width*: real64_t
    height*: real64_t

  R2Df* {.importc.} = object
    pos*: V2Df
    size*: S2Df
  
  R2Dd* {.importc.} = object
    pos*: V2Dd
    size*: S2Dd
  
  T2Df* {.importc.} = object
    i*: V2Df
    j*: V2Df
    p*: V2Df

  T2Dd* {.importc.} = object
    i*: V2Dd
    j*: V2Dd
    p*: V2Dd

  Seg2Df* {.importc.} = object
    p0*: V2Df
    p1*: V2Df
  
  Seg2Dd* {.importc.} = object
    p0*: V2Dd
    p1*: V2Dd
  
  Cir2Df* {.importc.} = object
    c*: V2Df
    r*: real32_t
  
  Cir2Dd* {.importc.} = object
    c*: V2Dd
    r*: real64_t
  
  Box2Df* {.importc.} = object
    min*: V2Df
    max*: V2Df
  
  Box2Dd* {.importc.} = object
    min*: V2Dd
    max*: V2Dd
  
  OBB2Df* {.importc.} = object
  OBB2Dd* {.importc.} = object
  
  Tri2Df* {.importc.} = object
    p0*: V2Df
    p1*: V2Df
    p2*: V2Df
  
  Tri2Dd* {.importc.} = object
    p0*: V2Dd
    p1*: V2Dd
    p2*: V2Dd

  Pol2Df* {.importc.} = object
  Pol2Dd* {.importc.} = object

  Col2Df* {.importc.} = object
  Col2Dd* {.importc.} = object

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/geom2d/v2d.h" .}

# 2D Vectors

let
  kV2D_ZEROf* {.nodecl.}: V2Df
  kV2D_ZEROd* {.nodecl.}: V2Dd
  kV2D_Xf* {.nodecl.}: V2Df
  kV2D_Xd* {.nodecl.}: V2Dd
  kV2D_Yf* {.nodecl.}: V2Df
  kV2D_Yd* {.nodecl.}: V2Dd

proc v2df*(x: real32_t, y: real32_t): V2Df
proc v2d_tof*(v: ptr V2Dd): V2df
proc v2d_addf*(v1: ptr V2Df, v2: ptr V2Df): V2Df
proc v2d_subf*(v1: ptr V2Df, v2: ptr V2Df): V2Df
proc v2d_mulf*(v1: ptr V2Df, s: real32_t): V2Df
proc v2d_fromf*(v: ptr V2Df, dir: ptr V2Df, length: real32_t): V2Df
proc v2d_midf*(v1: ptr V2Df, v2: ptr V2Df): V2Df
proc v2d_unitf*(v1: ptr V2Df, v2: ptr V2Df, dist: ptr real32_t): V2Df
proc v2d_unit_xyf*(x1: real32_t, y1: real32_t, x2: real32_t, y2: real32_t,
                  dist: ptr real32_t): V2Df
proc v2d_perp_posf*(v: ptr V2Df): V2Df 
proc v2d_perp_negf*(v: ptr V2Df): V2Df                
proc v2d_from_anglef*(a: real32_t): V2Df
proc v2d_normf*(v: ptr V2Df): bool_t
proc v2d_lengthf*(v: ptr V2Df): real32_t
proc v2d_sqlengthf*(v: ptr V2Df): real32_t
proc v2d_dotf*(v1: ptr V2Df, v2: ptr V2Df): real32_t
proc v2d_distf*(v1: ptr V2Df, v2: ptr V2Df): real32_t
proc v2d_sqdistf*(v1: ptr V2Df, v2: ptr V2Df): real32_t
proc v2d_anglef*(v1: ptr V2Df, v2: ptr V2Df): real32_t
proc v2d_rotatef*(v: ptr V2Df, a: real32_t)


proc v2dd*(x: real64_t, y: real64_t): V2Dd
proc v2d_tod*(v: ptr V2Df): V2dd
proc v2d_addd*(v1: ptr V2Dd, v2: ptr V2Dd): V2Dd
proc v2d_subd*(v1: ptr V2Dd, v2: ptr V2Dd): V2Dd
proc v2d_muld*(v1: ptr V2Dd, s: real64_t): V2Dd
proc v2d_fromd*(v: ptr V2Dd, dir: ptr V2Dd, length: real64_t): V2Dd
proc v2d_midd*(v1: ptr V2Dd, v2: ptr V2Dd): V2Dd
proc v2d_unitd*(v1: ptr V2Dd, v2: ptr V2Dd, dist: ptr real64_t): V2Dd
proc v2d_unit_xyd*(x1: real64_t, y1: real64_t, x2: real64_t, y2: real64_t,
                  dist: ptr real64_t): V2Dd
proc v2d_perp_posd*(v: ptr V2Dd): V2Dd 
proc v2d_perp_negd*(v: ptr V2Dd): V2Dd                
proc v2d_from_angled*(a: real64_t): V2Dd
proc v2d_normd*(v: ptr V2Dd): bool_t
proc v2d_lengthd*(v: ptr V2Dd): real64_t
proc v2d_sqlengthd*(v: ptr V2Dd): real64_t
proc v2d_dotd*(v1: ptr V2Dd, v2: ptr V2Dd): real64_t
proc v2d_distd*(v1: ptr V2Dd, v2: ptr V2Dd): real64_t
proc v2d_sqdistd*(v1: ptr V2Dd, v2: ptr V2Dd): real64_t
proc v2d_angled*(v1: ptr V2Dd, v2: ptr V2Dd): real64_t
proc v2d_rotated*(v: ptr V2Dd, a: real64_t)

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/geom2d/s2d.h" .}

# 2D Size

let
  kS2D_ZEROf* {.nodecl.}: S2Df
  kS2D_ZEROd* {.nodecl.}: S2Df

proc s2df*(width: real32_t, height: real32_t): S2Df
proc s2dd*(width: real64_t, height: real64_t): S2Dd

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/geom2d/r2d.h" .}

# 2D Rectangles

let
  kR2D_ZEROf* {.nodecl.}: R2Df
  kR2D_ZEROd* {.nodecl.}: R2Dd

proc r2df*(x: real32_t, y: real32_t, width: real32_t, height: real32_t): R2Df
proc r2d_centerf*(r2d: ptr R2Df): V2Df
proc r2d_collidef*(r2d1: ptr R2Df, r2d2: ptr R2Df): bool_t
proc r2d_containsf*(r2d1: ptr R2Df, x: real32_t, y: real32_t): bool_t
proc r2d_clipf*(viewport: ptr R2Df, r2d: ptr R2Df): bool_t
proc r2d_joinf*(r2d: ptr R2Df, src: ptr R2Df)

proc r2dd*(x: real64_t, y: real64_t, width: real64_t, height: real64_t): R2Dd
proc r2d_centerd*(r2d: ptr R2Dd): V2Df
proc r2d_collided*(r2d1: ptr R2Dd, r2d2: ptr R2Dd): bool_t
proc r2d_containsd*(r2d1: ptr R2Dd, x: real64_t, y: real64_t): bool_t
proc r2d_clipd*(viewport: ptr R2Dd, r2d: ptr R2Dd): bool_t
proc r2d_joind*(r2d: ptr R2Dd, src: ptr R2Dd)


{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/geom2d/t2d.h" .}

# 2D Transformations

let
  kT2D_IDENTf* {.nodecl.}: T2Df
  kT2D_IDENTd* {.nodecl.}: T2Dd

proc t2d_tof*(dest: ptr T2Df, src: ptr T2Dd)
proc t2d_movef*(dest: ptr T2Df, src: ptr T2Df, x: real32_t, y: real32_t)
proc t2d_rotatef*(dest: ptr T2Df, src: ptr T2Df, angle: real32_t)
proc t2d_scalef*(dest: ptr T2Df, src: ptr T2Df, sx: real32_t, sy: real32_t)
proc t2d_invfastf*(dest: ptr T2Df, src: ptr T2Df)
proc t2d_inversef*(dest: ptr T2Df, src: ptr T2Df)
proc t2d_multf*(dest: ptr T2Df, src1: ptr T2Df,  src2: ptr T2Df)
proc t2d_vmultf*(dest: ptr T2Df, t2d: ptr T2Df,  v2d: ptr V2Df)
proc t2d_vmultnf*(dest: ptr T2Df, t2d: ptr T2Df,  v2d: ptr V2Df, n: uint32_t)
proc t2d_decomposef*(td2: ptr T2Df, pos: ptr V2Df, angle: ptr real32_t,
                     sc: ptr V2Df)

proc t2d_tod*(dest: ptr T2Dd, src: ptr T2Dd)
proc t2d_moved*(dest: ptr T2Dd, src: ptr T2Dd, x: real64_t, y: real64_t)
proc t2d_rotated*(dest: ptr T2Dd, src: ptr T2Dd, angle: real64_t)
proc t2d_scaled*(dest: ptr T2Dd, src: ptr T2Dd, sx: real64_t, sy: real64_t)
proc t2d_invfastd*(dest: ptr T2Dd, src: ptr T2Dd)
proc t2d_inversed*(dest: ptr T2Dd, src: ptr T2Dd)
proc t2d_multd*(dest: ptr T2Dd, src1: ptr T2Dd,  src2: ptr T2Dd)
proc t2d_vmultd*(dest: ptr T2Dd, t2d: ptr T2Dd,  v2d: ptr V2Dd)
proc t2d_vmultnd*(dest: ptr T2Dd, t2d: ptr T2Dd,  v2d: ptr V2Dd, n: uint32_t)
proc t2d_decomposed*(td2: ptr T2Dd, pos: ptr V2Dd, angle: ptr real64_t,
                     sc: ptr V2Dd)

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/geom2d/seg2d.h" .}

# 2D Segments

proc seg2df*(x0: real32_t, y0: real32_t, x1: real32_t, y1: real32_t): Seg2Df
proc seg2d_vf*(p0: ptr V2Df, p1: ptr V2Df): Seg2Df
proc seg2d_lengthf*(seg: ptr Seg2Df): real32_t
proc seg2d_sqlengthf*(seg: ptr Seg2Df): real32_t
proc seg2d_evalf*(seg: ptr Seg2Df, t: real32_t): V2Df
proc seg2d_close_paramf*(seg: ptr Seg2Df, pnt: ptr V2Df): real32_t
proc seg2d_point_sqdistf*(seg: ptr Seg2Df, pnt: ptr V2Df, t: ptr real32_t): real32_t
proc seg2d_sqdistf*(seg1: ptr Seg2Df, seg2: ptr Seg2Df, t1: ptr real32_t,
                    t2: ptr real32_t): real32_t

proc seg2dd*(x0: real64_t, y0: real64_t, x1: real64_t, y1: real64_t): Seg2Dd
proc seg2d_vd*(p0: ptr V2Dd, p1: ptr V2Dd): Seg2Dd
proc seg2d_lengthd*(seg: ptr Seg2Dd): real64_t
proc seg2d_sqlengthd*(seg: ptr Seg2Dd): real64_t
proc seg2d_evald*(seg: ptr Seg2Dd, t: real64_t): V2Dd
proc seg2d_close_paramd*(seg: ptr Seg2Dd, pnt: ptr V2Dd): real64_t
proc seg2d_point_sqdistd*(seg: ptr Seg2Dd, pnt: ptr V2Dd, t: ptr real64_t): real64_t
proc seg2d_sqdistd*(seg1: ptr Seg2Dd, seg2: ptr Seg2Dd, t1: ptr real64_t,
                    t2: ptr real64_t): real64_t                  

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/geom2d/cir2d.h" .}

# 2D Circles

let
  kCIR2D_NULLf* {.nodecl.}: Cir2Df
  kCIR2D_NULLd* {.nodecl.}: Cir2Dd

proc cir2df*(x: real32_t, y: real32_t, r: real32_t): Cir2Df
proc cir2d_from_boxf*(box: ptr Box2Df): Cir2Df
proc cir2d_from_pointsf*(p: ptr V2Df, n: uint32_t): Cir2Df
proc cir2d_minimumf*(p: ptr V2Df, n: uint32_t): Cir2Df
proc cir2d_areaf*(cir: ptr Cir2Df): real32_t
proc cir2d_is_nullf*(cir: ptr Cir2Df): bool_t

proc cir2dd*(x: real64_t, y: real64_t, r: real64_t): Cir2Dd
proc cir2d_from_boxd*(box: ptr Box2Dd): Cir2Dd
proc cir2d_from_pointsd*(p: ptr V2Df, n: uint32_t): Cir2Dd
proc cir2d_minimumd*(p: ptr V2Df, n: uint32_t): Cir2Dd
proc cir2d_aread*(cir: ptr Cir2Dd): real64_t
proc cir2d_is_nulld*(cir: ptr Cir2Dd): bool_t

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/geom2d/box2d.h" .}

# 2D Boxes

let
  kBOX2D_NULLf* {.nodecl.}: Box2Df
  kBOX2D_NULLd* {.nodecl.}: Box2Dd

proc box2df*(minX: real32_t, minY: real32_t, maxX: real32_t, maxY: real32_t): Box2Df
proc box2d_from_pointsf*(p: ptr V2Df, n: uint32_t): Box2Df
proc box2d_centerf*(box: ptr Box2Df): V2Df
proc box2d_addf*(box: ptr Box2Df, p: ptr V2Df)
proc box2d_addnf*(box: ptr Box2Df, p: ptr V2Df, n: uint32_t)
proc box2d_add_circlef*(box: ptr Box2Df, cir: ptr Cir2Df)
proc box2d_mergef*(dest: ptr Box2Df, src: ptr Box2Df)
proc box2d_segmentsf*(box: ptr Box2Df, segs: ptr Seg2Df)
proc box2d_areaf*(box: ptr Box2Df): real32_t
proc box2d_is_nullf*(box: ptr Box2Df): bool_t

proc box2dd*(minX: real64_t, minY: real64_t, maxX: real64_t, maxY: real64_t): Box2Dd
proc box2d_from_pointsd*(p: ptr V2Dd, n: uint32_t): Box2Dd
proc box2d_centerd*(box: ptr Box2Dd): V2Dd
proc box2d_addd*(box: ptr Box2Dd, p: ptr V2Dd)
proc box2d_addnd*(box: ptr Box2Dd, p: ptr V2Dd, n: uint32_t)
proc box2d_add_circled*(box: ptr Box2Dd, cir: ptr Cir2Dd)
proc box2d_merged*(dest: ptr Box2Dd, src: ptr Box2Dd)
proc box2d_segmentsd*(box: ptr Box2Dd, segs: ptr Seg2Dd)
proc box2d_aread*(box: ptr Box2Dd): real64_t
proc box2d_is_nulld*(box: ptr Box2Dd): bool_t

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/geom2d/obb2d.h" .}

# 2D Oriented Boxes

proc obb2d_createf*(center: ptr V2Df, width: real32_t, height: real32_t,
                    angle: real32_t): ptr OBB2Df
proc obb2d_from_linef*(p0: ptr V2Df, p1: ptr V2Df, thickness: real32_t): ptr OBB2Df
proc obb2d_from_pointsf*(p: ptr V2Df, n: uint32_t): ptr OBB2Df
proc obb2d_copyf*(p: ptr OBB2Df): ptr OBB2Df
proc obb2d_destroyf*(obb: ptr ptr OBB2Df)
proc obb2d_updatef*(obb: ptr OBB2Df, center: ptr V2Df, width: real32_t,
                    height: real32_t, angle: real32_t)
proc obb2d_movef*(obb: ptr OBB2Df, offset_x: real32_t, offset_y: real32_t)
proc obb2d_transformf*(obb: ptr OBB2Df, t2d: ptr T2Df)
proc obb2d_cornersf*(obb: ptr OBB2Df): ptr V2Df
proc obb2d_centerf*(obb: ptr OBB2Df): V2Df
proc obb2d_widthf*(obb: ptr OBB2Df): real32_t
proc obb2d_heightf*(obb: ptr OBB2Df): real32_t
proc obb2d_anglef*(obb: ptr OBB2Df): real32_t
proc obb2d_areaf*(obb: ptr OBB2Df): real32_t
proc obb2d_boxf*(obb: ptr OBB2Df): Box2Df

proc obb2d_created*(center: ptr V2Dd, width: real64_t, height: real64_t,
                    angle: real64_t): ptr OBB2Dd
proc obb2d_from_lined*(p0: ptr V2Dd, p1: ptr V2Dd, thickness: real64_t): ptr OBB2Dd
proc obb2d_from_pointsd*(p: ptr V2Dd, n: uint32_t): ptr OBB2Dd
proc obb2d_copyd*(p: ptr OBB2Dd): ptr OBB2Dd
proc obb2d_destroyd*(obb: ptr ptr OBB2Dd)
proc obb2d_updated*(obb: ptr OBB2Dd, center: ptr V2Dd, width: real64_t,
                    height: real64_t, angle: real64_t)
proc obb2d_moved*(obb: ptr OBB2Dd, offset_x: real64_t, offset_y: real64_t)
proc obb2d_transformd*(obb: ptr OBB2Dd, t2d: ptr T2Dd)
proc obb2d_cornersd*(obb: ptr OBB2Dd): ptr V2Dd
proc obb2d_centerd*(obb: ptr OBB2Dd): V2Dd
proc obb2d_widthd*(obb: ptr OBB2Dd): real64_t
proc obb2d_heightd*(obb: ptr OBB2Dd): real64_t
proc obb2d_angled*(obb: ptr OBB2Dd): real64_t
proc obb2d_aread*(obb: ptr OBB2Dd): real64_t
proc obb2d_boxd*(obb: ptr OBB2Dd): Box2Dd

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/geom2d/tri2d.h" .}

# 2D Triangles

proc tri2df*(x0: real32_t, y0: real32_t, x1: real32_t, y1: real32_t,
             x2: real32_t, y2: real32_t): Tri2Df
proc tri2d_vf*(p0: ptr V2Df, p1: ptr V2Df, p2: ptr V2Df): Tri2Df
proc tri2d_transformf*(tri: ptr Tri2Df, t2d: ptr T2Df)
proc tri2d_areaf*(tri: ptr Tri2Df): real32_t
proc tri2d_ccwf*(tri: ptr Tri2Df): bool_t
proc tri2d_centroidf*(tri: ptr Tri2Df): V2Df

proc tri2dd*(x0: real64_t, y0: real64_t, x1: real64_t, y1: real64_t,
             x2: real64_t, y2: real64_t): Tri2Dd
proc tri2d_vd*(p0: ptr V2Dd, p1: ptr V2Dd, p2: ptr V2Dd): Tri2Dd
proc tri2d_transformd*(tri: ptr Tri2Dd, t2d: ptr T2Df)
proc tri2d_aread*(tri: ptr Tri2Dd): real64_t
proc tri2d_ccwd*(tri: ptr Tri2Dd): bool_t
proc tri2d_centroidd*(tri: ptr Tri2Dd): V2Dd

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/geom2d/pol2d.h" .}

# 2D Polygons

proc pol2d_createf*(points: ptr V2Df, n: uint32_t): ptr Pol2Df
proc pol2d_convex_hullf*(points: ptr V2Df, n: uint32_t): ptr Pol2Df
proc pol2d_copyf*(pol: ptr Pol2Df): ptr Pol2Df
proc pol2d_destroyf*(pol: ptr ptr Pol2Df)
proc pol2d_transformf*(pol: ptr Pol2Df, t2d: ptr T2Df)
proc pol2d_pointsf*(pol: ptr Pol2Df): ptr V2Df
proc pol2d_nf*(pol: ptr Pol2Df): uint32_t
proc pol2d_areaf*(pol: ptr Pol2Df): real32_t
proc pol2d_boxf*(pol: ptr Pol2Df): Box2Df
proc pol2d_ccwf*(pol: ptr Pol2Df): bool_t
proc pol2d_convexf*(pol: ptr Pol2Df): bool_t
proc pol2d_centroidf*(pol: ptr Pol2Df): V2Df
proc pol2d_visual_centerf*(pol: ptr Pol2Df): V2Df
proc pol2d_trianglesf*(pol: ptr Pol2Df): ptr Array[Tri2Df]
proc pol2d_convex_partitionf*(pol: ptr Pol2Df): ptr Array[ptr Pol2Df]

proc pol2d_created*(points: ptr V2Dd, n: uint32_t): ptr Pol2Dd
proc pol2d_convex_hulld*(points: ptr V2Dd, n: uint32_t): ptr Pol2Dd
proc pol2d_copyd*(pol: ptr Pol2Dd): ptr Pol2Dd
proc pol2d_destroyd*(pol: ptr ptr Pol2Dd)
proc pol2d_transformd*(pol: ptr Pol2Dd, t2d: ptr T2Dd)
proc pol2d_pointsd*(pol: ptr Pol2Dd): ptr V2Dd
proc pol2d_nd*(pol: ptr Pol2Dd): uint32_t
proc pol2d_aread*(pol: ptr Pol2Dd): real32_t
proc pol2d_boxd*(pol: ptr Pol2Dd): Box2Dd
proc pol2d_ccwd*(pol: ptr Pol2Dd): bool_t
proc pol2d_convexd*(pol: ptr Pol2Dd): bool_t
proc pol2d_centroidd*(pol: ptr Pol2Dd): V2Dd
proc pol2d_visual_centerd*(pol: ptr Pol2Dd): V2Dd
proc pol2d_trianglesd*(pol: ptr Pol2Dd): ptr Array[Tri2Dd]
proc pol2d_convex_partitiond*(pol: ptr Pol2Dd): ptr Array[ptr Pol2Dd]

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/geom2d/col2d.h" .}

# 2D Collisions

proc col2d_point_pointf*(pnt1: ptr V2Df, pnt2: ptr V2Df, tol: real32_t, col: ptr Col2Df): bool_t

{. pop .} # ===================================================================
