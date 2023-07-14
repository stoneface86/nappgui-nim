
import bindings/geom2d as binds
import private/butils

import std/strformat

type
  # this is jank but nothing else seems to work
  # alias the type via = (when float32: F else: D)
  # somehow makes the type not equal to its aliased type
  GeomObject[T: SomeFloat, F, D] {.packed.} = object
    when T is float32:
      impl*: F
    else:
      impl*: D

  V2D*[T: SomeFloat] = GeomObject[T, V2Df, V2Dd]
  S2D*[T: SomeFloat] = GeomObject[T, S2Df, S2Dd]
  R2D*[T: SomeFloat] = GeomObject[T, R2Df, R2Dd]
  T2D*[T: SomeFloat] = GeomObject[T, T2Df, T2Dd]
  Seg2D*[T: SomeFloat] = GeomObject[T, Seg2Df, Seg2Dd]
  Cir2D*[T: SomeFloat] = GeomObject[T, Cir2Df, Cir2Dd]
  Box2D*[T: SomeFloat] = GeomObject[T, Box2Df, Box2Dd]
  OBB2D*[T: SomeFloat] = GeomObject[T, OBB2Df, OBB2Dd]
  Tri2D*[T: SomeFloat] = GeomObject[T, Tri2Df, Tri2Dd]
  Pol2D*[T: SomeFloat] = GeomObject[T, Pol2Df, Pol2Dd]
  Col2D*[T: SomeFloat] = GeomObject[T, Col2Df, Col2Dd]

  # Aliases

  Vec* = V2D
    ## Alias for `V2D`
    ##
  Point* = V2D
    ## Alias for `V2D`, depending on the context a `V2D` can represent a point.
    ##
  Size* = S2D
    ## Alias for `S2D`
  Matrix* = T2D
    ## Alias for `T2D`
  Rect* = R2D
    ## Alias for `R2D`

  # gui lib uses the float32 variants of these

  SizeF* = Size[float32]
    ## Alias for S2D[float32]
    ##
  PointF* = Point[float32]
    ## Alias for V2D[float32]
    ##
  MatrixF* = Matrix[float32]
    ## Alias for T2D[float32]
    ##
  RectF* = Rect[float32]
    ## Alias for R2D[float32]
    ##

func underlying[T, F, D](ty: typedesc[GeomObject[T, F, D]]): typedesc {.compileTime.} =
  when T is float32: typedesc[F] else: typedesc[D]

# ========================================================================= V2D

template x*[T: SomeFloat](v: V2D[T]): T = v.impl.x
template y*[T: SomeFloat](v: V2D[T]): T = v.impl.y
template `x=`*[T: SomeFloat](v: var V2D[T], val: T) = v.impl.x = val
template `y=`*[T: SomeFloat](v: var V2D[T], val: T) = v.impl.y = val

template mkV2D(x: V2Df): V2D[float32] = V2D[float32](impl: x)
template mkV2D(x: V2Dd): V2D[float64] = V2D[float64](impl: x)

proc `$`*[T: SomeFloat](v: V2D[T]): string =
  ## Get a string representation of `v`.
  ##
  &"v2d({v.x}, {v.y})"

template v2d*[T: SomeFloat](x: T, y: T): V2D[T] =
  ## Create a vector with components x and y.
  ## 
  mkV2D fdispatch[T](v2df, v2dd, x, y)
template point*[T: SomeFloat](x: T, y: T): V2D[T] = v2d[T](x, y)
  ## Alias for v2d
  ##

template v2d*[T: SomeFloat](point: V2D[T], dir: V2D[T], len: T): V2D[T] =
  ## Create a vector from a point and direction.
  ## 
  mkV2D fdispatch[T](v2d_fromf, v2d_fromd, point.impl.getPtr, dir.impl.getPtr, len)

template v2d*[T: SomeFloat](angle: T): V2D[T] =
  ## Create a unit vector in the direction of `angle`, in radians.
  ##
  mkV2D fdispatch[T](v2d_from_anglef, v2d_from_angled, angle) 

template v2d*(v: V2D[float32]): V2D[float64] =
  ## Convert a float32 vector to a float64 one (upcast).
  ##
  mkV2D v2d_tod(v.impl.toPtr)

template v2d*(v: V2D[float64]): V2D[float32] =
  ## Convert a float64 vector to a float32 one (downcast).
  ##
  mkV2D v2d_tof(v.impl.toPtr)

template `+`*[T: SomeFloat](a: V2D[T], b: V2D[T]): V2D[T] =
  ## Adds two vectors. The resulting vector has its components being the
  ## sum of `a` and `b`'s components.
  ## 
  mkV2D fdispatch[T](v2d_addf, v2d_addd, a.impl.getPtr, b.impl.getPtr)

template `-`*[T: SomeFloat](a: V2D[T], b: V2D[T]): V2D[T] =
  ## Subtract two vectors.
  ## 
  mkV2D fdispatch[T](v2d_subf, v2d_subd, a.impl.getPtr, b.impl.getPtr)

template `*`*[T: SomeFloat](a: V2D[T], s: T): V2D[T] =
  ## Multiply a vector `a` by a scalar `s`.
  ##
  mkV2D fdispatch[T](v2d_mulf, v2d_muld, a.impl.getPtr, s)

template `*`*[T: SomeFloat](a: V2D[T], b: V2D[T]): T =
  ## Calculate the product of two vectors.
  ##
  fdispatch[T](v2d_dotf, v2d_dotd, a.impl.getPtr, b.impl.getPtr)

template mid*[T: SomeFloat](a: V2D[T], b: V2D[T]): V2D[T] =
  ## Get the midpoint of two points `a` and `b`.
  ##
  mkV2D fdispatch[T](v2d_midf, v2d_midd, a.impl.getPtr, b.impl.getPtr)

template unitImpl[T: SomeFloat](v1: V2D[T], v2: V2D[T], dist: ptr T): V2D[T] =
  mkV2D fdispatch[T](v2d_unitf, v2d_unitd, v1.impl.getPtr, v2.impl.getPtr, dist)

template unitImpl[T: SomeFloat](x1: T, y1: T, x2: T, y2: T, dist: ptr T): V2D[T] =
  mkV2D fdispatch[T](v2d_unit_xyf, v2d_unit_xyd, x1, y1, x2, y2, dist)

template unit*[T: SomeFloat](v1: V2D[T], v2: V2D[T]): V2D[T] =
  ## Calculate the unit vector from vectors `v1` and `v2`.
  ## 
  unitImpl[T](v1, v2, nil)

template unit*[T: SomeFloat](v1: V2D[T], v2: V2D[T], dist: var T): V2D[T] =
  ## Overload for `unit` that also stores the distance between `v1` and `v2` 
  ## in `dist`.
  ##
  unitImpl[T](v1, v2, dist.addr)

template unit*[T: SomeFloat](x1: T, y1: T, x2: T, y2: T): V2D[T] =
  ## Convenience overload taking two vectors as individual components.
  ##
  unitImpl[T](x1, y1, x2, y2, nil)

template unit*[T: SomeFloat](x1: T, y1: T, x2: T, y2: T, dist: var T): V2D[T] =
  ## Convenience overload taking two vectors as individual components, also
  ## stores the distance in `dist`.
  ##
  unitImpl[T](x1, y1, x2, y2, dist.addr)

template perpPos*[T: SomeFloat](v: V2D[T]): V2D[T] =
  ## Gets the vector perdendicular to `v` in the positive direction, or 90
  ## degrees counter-clockwise.
  ##
  mkV2D fdispatch[T](v2d_perp_posf, v2d_perp_posd, v.impl.getPtr)

template perpNeg*[T: SomeFloat](v: V2D[T]): V2D[T] =
  ## Gets the vector perdendicular to `v` in the negative direction, or 90
  ## degrees clockwise.
  ##
  mkV2D fdispatch[T](v2d_perp_negf, v2d_perp_negd, v.impl.getPtr)

template norm*[T: SomeFloat](v: var V2D[T]) =
  ## Normalize the vector `v`, or make its length = 1.
  ##
  discard fdispatch[T](v2d_normf, v2d_normd, v.addr)

template length*[T: SomeFloat](v: V2D[T]): T =
  ## Calculate the length of a vector `v`.
  ## 
  fdispatch[T](v2d_lengthf, v2d_lengthd, v.impl.getPtr)

template sqlength*[T: SomeFloat](v: V2D[T]): T =
  ## Calculate the length squared of a vector `v`. Prefer this function over
  ## `length` when comparing lengths as it is more efficient.
  ##
  fdispatch[T](v2d_sqlengthf, v2d_sqlengthd, v.impl.getPtr)

template distance*[T: SomeFloat](a: V2D[T], b: V2D[T]): T =
  ## Calculate the distance between points `a` and `b`.
  ##
  fdispatch[T](v2d_distf, v2d_distd, a.impl.getPtr, b.impl.getPtr)

template sqdistance*[T: SomeFloat](a: V2D[T], b: V2D[T]): T =
  ## Calculate the distance squared between points `a` and `b`. Prefer this
  ## function over `distance` when comparing distances as it is more efficient.
  ##
  fdispatch[T](v2d_sqdistf, v2d_sqdistd, a.impl.getPtr, b.impl.getPtr)

template angle*[T: SomeFloat](a: V2D[T], b: V2D[T]): T =
  ## Calculate the angle between two vectors `a` and `b`. The angle returned is
  ## in radians.
  ## 
  fdispatch[T](v2d_anglef, v2d_angled, a.impl.getPtr, b.impl.getPtr)

template rotate*[T: SomeFloat](v: var V2D[T], angle: T) =
  ## Rotates a vector `v` by `angle`, in radians.
  ##
  fdispatch[T](v2d_rotatef, v2d_rotated, v.addr, angle)

# ========================================================================= S2D


template width*[T: SomeFloat](s: S2D[T]): T = s.impl.width
  ## Get the width.
  ##
template `width=`*[T: SomeFloat](s: S2D[T], val: T) = s.impl.width = val
  ## Set the width.
  ##
template height*[T: SomeFloat](s: S2D[T]): T = s.impl.height
  ## Get the height.
  ##
template `height=`*[T: SomeFloat](s: S2D[T], val: T) = s.impl.height = val
  ## Set the height.
  ##

func `$`*[T: SomeFloat](s: S2D[T]): string =
  ## Get a string representation of the size
  ##
  &"s2d({s.width}, {s.height})"

template s2d*[T: SomeFloat](width: T, height: T): S2D =
  ## Creates a size with the given width and height.
  ## 
  S2D[T](impl: fdispatch[T](s2df, s2dd, width, height))

template size*[T: SomeFloat](width: T, height: T): S2D =
  ## Alias for `s2d`.
  ##
  s2d[T](width, height)

# ========================================================================= R2D

template pos*[T: SomeFloat](r: R2D[T]): V2D[T] = r.impl.pos
  ## Get the position of the rectangle
  ##
template `pos=`*[T: SomeFloat](r: var R2D[T], val: V2D[T]) = r.impl.pos = val
  ## Set the position of the rectangle
  ##
template size*[T: SomeFloat](r: R2D[T]): S2D[T] = r.impl.size
  ## Get the size of the rectangle
  ##
template `size=`*[T: SomeFloat](r: var R2D[T], val: S2D[T]) = r.impl.size = val
  ## Set the size of the rectangle
  ##

template x*[T: SomeFloat](r: R2D[T]): T = r.pos.x
  ## Get the x position of the rectangle.
  ##
template `x=`*[T: SomeFloat](r: var R2D[T], val: T) = r.impl.pos.x = val
  ## Set the x position of the rectangle.
  ##
template y*[T: SomeFloat](r: R2D[T]): T = r.pos.y
  ## Get the y position of the rectangle
  ##
template `y=`*[T: SomeFloat](r: var R2D[T], val: T) = r.impl.pos.y = val
  ## Set the y position of the rectangle.
  ##
template width*[T: SomeFloat](r: R2D[T]): T = r.size.width
  ## Get the width of the rectangle.
  ##
template `width=`*[T: SomeFloat](r: R2D[T], val: T) = r.impl.size.width = val
  ## Set the width of the rectangle.
  ## 
template height*[T: SomeFloat](r: R2D[T]): T = r.size.height
  ## Get the height of the rectangle.
  ##
template `height=`*[T: SomeFloat](r: R2D[T], val: T) = r.impl.size.height = val
  ## Set the height of the rectangle.
  ## 

template top*[T: SomeFloat](r: R2D[T]): T = r.y
  ## Get the top side position of the rectangle, same as `r.y`
  ##
template `top=`*[T: SomeFloat](r: var R2D[T], val: T) = r.y = val
  ## Set the top side position of the rectangle.
  ##
func bottom*[T: SomeFloat](r: R2D[T]): T = 
  ## Get the bottom side position of the rectangle, which is the y position
  ## plus the height.
  ##
  r.y + r.height
func `bottom=`*[T: SomeFloat](r: var R2D[T], val: T) =
  ## Set the bottom side position of the rectangle. Note: this changes the
  ## height of the rectangle
  ##
  r.impl.size.height = val - r.y

template left*[T: SomeFloat](r: R2D[T]): T = r.x
  ## Get the left side position of the rectangle, same as `r.x`
  ##
template `left=`*[T: SomeFloat](r: var R2D[T], val: T) = r.x = val
  ## Set the left side position of the rectangle.
  ##
func right*[T: SomeFloat](r: R2D[T]): T =
  ## Get the right side position of the rectangle, which is the x position
  ## plus the width.
  ##
  r.x + r.width
func `right=`*[T: SomeFloat](r: var R2D[T], val: T) =
  ## Set the right side position of the rectangle. Note: this changes the
  ## width of the rectangle.
  ##
  r.impl.size.width = val - r.x

func `$`*[T: SomeFloat](r: R2D[T]): string =
  &"r2d({r.x}, {r.y}, {r.width}, {r.height})"

template r2d*[T: SomeFloat](x: T, y: T, width: T, height: T): R2D[T] =
  ## Creates a rectangle with the given components.
  ##
  R2D[T](impl: fdispatch[T](r2df, r2dd, x, y, width, height))

template rect*[T: SomeFloat](x: T, y: T, width: T, height: T): R2D[T] =
  ## Alias for r2d.
  ##
  r2d(x, y, width, height)

template center*[T: SomeFloat](r: R2D[T]): V2D[T] =
  ## Calculate the center position of the rectangle.
  ##
  mkV2D fdispatch[T](r2d_centerf, r2d_centerd, r.impl.getPtr)

template collides*[T: SomeFloat](a: R2D[T], b: R2D[T]): bool =
  ## Check if two rectangles `a` and `b` collide or intersect with each other.
  ## 
  toBool fdispatch[T](r2d_collidef, r2d_collided, a.impl.getPtr, b.impl.getPtr)

template contains*[T: SomeFloat](r: R2D[T], x: T, y: T): bool =
  ## Check if a point is inside the rectangle.
  ##
  toBool fdispatch[T](r2d_containsf, r2d_containsd, r.impl.getPtr, x, y)

template contains*[T: SomeFloat](r: R2D[T], p: Point[T]): bool =
  ## Convenience overload taking a point/v2d instead of separate coordinates
  ## Works with `in`!
  ##
  contains(r, p.x, p.y)

template isClipped*[T: SomeFloat](viewport: R2D[T], r: R2D[T]): bool =
  ## Tests if a rectangle, `r`, is contained in the rectangle `viewport`.
  ## `true` is returned if `r` is completely outside of `viewport`.
  ##
  toBool fdispatch[T](r2d_clipf, r2d_clipd, viewport.impl.toPtr, r.impl.toPtr)

template join*[T: SomeFloat](r: var R2D[T], src: R2D[T]) =
  ## Adjusts the size and position of `r` so that it contains `src`.
  ##
  fdispatch[T](r2d_joinf, r2d_joind, r.impl.addr, src.impl.toPtr)

# ========================================================================= T2D

template i*[T: SomeFloat](t: T2D[T]): V2D[T] = cast[V2D[T]](t.impl.i)
  ## Get the ith component of the linear transformation matrix
  ##
template `i=`*[T: SomeFloat](t: var T2D[T], val: V2D[T]) = t.impl.i = val.impl
  ## Set the ith component of the linear transformation matrix
  ##
template j*[T: SomeFloat](t: T2D[T]): V2D[T] = cast[V2D[T]](t.impl.j)
  ## Get the jth component of the linear transformation matrix
  ##
template `j=`*[T: SomeFloat](t: var T2D[T], val: V2D[T]) = t.impl.j = val.impl
  ## Set the jth component of the linear transformation matrix
  ##
template p*[T: SomeFloat](t: T2D[T]): V2D[T] = cast[V2D[T]](t.impl.p)
  ## Get the position of the linear transformation matrix
  ##
template `p=`*[T: SomeFloat](t: var T2D[T], val: V2D[T]) = t.impl.p = val.impl
  ## Set the position of the linear transformation matrix
  ##

template t2d*[T: SomeFloat](): T2D[T] =
  ## Initializes a transformation matrix with the identity matrix.
  ##
  T2D[T](impl: when T is float32: kT2D_IDENTf else: kT2D_IDENTd)

template t2d*(t: T2D[float32]): T2D[float64] =
  ## Converts a transformation from float32 to float64
  ##
  block:
    var res: T2Dd
    t2d_tod(res.addr, t.impl.getPtr)
    res

template t2d*(t: T2D[float64]): T2D[float32] =
  ## Converts a transformation from float64 to float32
  ##
  block:
    var res: T2Df
    t2d_tof(res.addr, t.impl.getPtr)
    res

template move*[T: SomeFloat](t: var T2D[T], src: T2D[T], x: T, y: T) =
  ## Multiply a transformation by a translation operation
  ##
  fdispatch[T](t2d_movef, t2d_moved, t.impl.addr, src.impl.getPtr, x, y)

template rotate*[T: SomeFloat](t: var T2D[T], src: T2D[T], angle: T) =
  ## Multiply the transformation by a rotation operation
  ##
  fdispatch[T](t2d_rotatef, t2d_rotated, t.impl.addr, src.impl.getPtr, angle)

template scale*[T: SomeFloat](t: var T2D[T], src: T2D[T], sx: T, sy: T) =
  ## Multiply the transformation by a scale operation
  ##
  fdispatch[T](t2d_scalef, t2d_scaled, t.impl.addr, src.impl.getPtr, sx, sy)

template invfast*[T: SomeFloat](t: var T2D[T], src: T2D[T]) =
  ## Calculate the inverse transformation efficiently, assuming the input is
  ## orthogonal (only rotations and translations).
  ##
  fdispatch[T](t2d_invfastf, t2d_invfastd, t.impl.addr, src.impl.getPtr)

template inverse*[T: SomeFloat](t: var T2D[T], src: T2D[T]) =
  ## Calculate the inverse transformation.
  ##
  fdispatch[T](t2d_inversef, t2d_inversed, t.impl.addr, src.impl.getPtr)

template mult*[T: SomeFloat](t: var T2D[T], src1: T2D[T], src2: T2D[T]) =
  ## Multiple two transformations storing the result in `t`
  ##
  fdispatch[T](t2d_multf, t2d_multd, t.impl.addr, src1.impl.getPtr, src2.impl.getPtr)

template mult*[T: SomeFloat](v: var V2D[T], t: T2D[i], src: V2D[T]) =
  ## Transform a vector `src` using `t`, storing the result into `v`.
  ##
  fdispatch[T](t2d_vmultf, t2d_vmultd, v.impl.addr, t.impl.getPtr, t.impl.getPtr)

proc decompose*[T: SomeFloat](t: T2D[T]): tuple[pos: V2D[T], angle: T, scale: V2D[T]] =
  ## Decompose the transformation into a position vector, angle and scale
  ## vector. The result will not be valid if the `t` is not only composed of
  ## translations, rotations and scales.
  ##
  fdispatch[T](t2d_decomposef, t2d_decomposed, 
    t.impl.getPtr, 
    result.pos.impl.addr,
    result.angle.addr,
    result.scale.impl.addr
  )

# ======================================================================= Seg2D

template p0*[T: SomeFloat](s: Seg2D[T]): V2D[T] = cast[V2D[T]](s.impl.p0)
  ## Get the first point of the segment
  ##
template `p0=`*[T: SomeFloat](s: var Seg2D[T], val: V2D[T]) = s.impl.p0 = val.impl
  ## Set the first point of the segment
  ##

template p1*[T: SomeFloat](s: Seg2D[T]): V2D[T] = cast[V2D[T]](s.impl.p1)
  ## Get the second point of the segment
  ##
template `p1=`*[T: SomeFloat](s: var Seg2D[T], val: V2D[T]) = s.impl.p1 = val.impl
  ## Set the second point of the segment
  ##

proc `$`*[T: SomeFloat](s: Seg2D[T]): string =
  ## Get a string representation of the segment.
  ##
  &"seg2d({s.p0.x}, {s.p0.y}, {s.p1.x}, {s.p1.y})"

template seg2d*[T: SomeFloat](x0: T, y0: T, x1: T, y1: T): Seg2D[T] =
  ## Create a segment with its two points.
  ##
  Seg2D[T](impl: fdispatch[T](seg2df, seg2dd, x0, y0, x1, y1))

template seg2d*[T: SomeFloat](p0: V2D[T], p1: V2D[T]): Seg2D[T] =
  ## Create a segment with its two points using vectors.
  ##
  Seg2D[T](impl: fdispatch[T](seg2d_vf, seg2d_vd, p0.impl.getPtr, p1.impl.getPtr))

template length*[T: SomeFloat](s: Seg2D[T]): T =
  ## Calculate the length of the segment.
  ##
  fdispatch[T](seg2d_lengthf, seg2d_lengthd, s.impl.getPtr)

template sqlength*[T: SomeFloat](s: Seg2D[T]): T =
  ## Calculate the squared length of the segment.
  ##
  fdispatch[T](seg2d_sqlengthf, seg2d_sqlengthd, s.impl.getPtr)

template eval*[T: SomeFloat](s: Seg2D[T], t: T): V2D[T] =
  ## Given a parameter `t`, where `0 <= t <= 1`, get the point on the segment
  ## such that `t = 0` is `s.p0` and `t = 1` is `s.p1`
  ##
  V2D[T](impl: fdispatch[T](seg2d_evalf, seg2d_evald, s.impl.getPtr, t))

template closestParam*[T: SomeFloat](s: Seg2D[T], p: V2D[T]): T =
  ## Given a point `p`, find the the parameter of the segment that is closest
  ## to `p`.
  ##
  fdispatch[T](seg2d_close_paramf, seg2d_close_paramd, s.impl.getPtr, p.impl.getPtr)

proc sqdist*[T: SomeFloat](s: Seg2D[T], p: V2D[T]): tuple[dist: T, t: T] =
  ## Get the squared distance from a point to a segment, along with the
  ## parameter on the line.
  ##
  result.dist = fdispatch[T](seg2d_point_sqdistf, seg2d_point_sqdistd, s.impl.getPtr, p.impl.getPtr, result.t.addr)

proc sqdist*[T: SomeFloat](s1: Seg2D[T], s2: Seg2D[T]): tuple[dist: T, t1: T, t2: T] =
  ## Get the squared distance from two segments, along with their parameters.
  ##
  result.dist = fdispatch[T](seg2d_sqdistf, seg2d_sqdistd, s1.impl.getPtr,
                             s2.impl.getPtr, result.t1.addr, result.t2.addr)

# ======================================================================= Cir2D

template c*[T: SomeFloat](cir: Cir2D[T]): V2D[T] = cast[V2D[T]](cir.impl.c)
  ## Get the center point of the circle
  ##
template `c=`*[T: SomeFloat](cir: var Cir2D[T], val: V2D[T]) = cir.impl.c = val.impl
  ## Set the center point of the circle
  ##

template r*[T: SomeFloat](cir: Cir2D[T]): T = cir.impl.r
  ## Get the radius of the circle
  ##
template `r=`*[T: SomeFloat](cir: var Cir2D[T], val: T) = cir.impl.r = val
  ## Set the radius of the circle
  ##

proc `$`*[T: SomeFloat](cir: Cir2D[T]): string =
  ## Get a string representation of the circle
  ##
  &"cir2d({cir.c.x}, {cir.c.y}, {cir.r})"

template cir2d*[T: SomeFloat](x: T, y: T, r: T): Cir2D[T] =
  ## Create a circle with the given components. `x` and `y` is the center
  ## point of the circle and `r` is the radius.
  ##
  Cir2D[T](impl: fdispatch[T](cir2df, cir2dd, x, y, r))

template cir2d*[T: SomeFloat](box: Box2D[T]): Cir2D[T] =
  ## Create a circle that contains the given box
  ##
  Cir2D[T](impl: fdispatch[T](cir2d_from_boxf, cir2d_from_boxd, box.impl.getPtr))

# proc cir2d*[T: SomeFloat](points: openArray[V2D[T]]): Cir2D[T] =
#   ## Create a circle that contains a the given array of points.
#   ##
#   Cir2D[T](impl: fdispatch[T](cir2d_from_pointsf, cir2d_from_pointsd,
#     cast[ptr underlying(points[0].typeOf)](points[0].unsafeAddr), points.len.uint32
#   ))

# let cir = cir2d([v2d(1.0, 1.2), v2d(2.3, 43.3)])