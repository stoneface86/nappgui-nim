##
## 2D Geometry
## 
## This module provides a high-level API of NAppGUI's geom2d library. Types
## and operations for common geometric objects in two dimensional space are
## provided. This library also provides collision checking.
## 
## This module provides its own versions of the types provided by the low-level
## bindings module, so that we can take advantage of generics and static
## dispatch provided by Nim. Conversion between either is zero-cost, and is
## implemented as a cast to the target type, since both have the exact
## same structure.
## 
## Since these types are not imported and some of the procedures are
## reimplemented in Nim, you can use them at compile-time.
## 
## This module also provides alias types for readability and common vocabulary
## with other GUI frameworks.
## 
## `NAppGUI Geom2D Docs<https://nappgui.com/en/geom2d/geom2d.html>`_
## `NAppGUI Docs<https://nappgui.com/en/sdk/sdk.html>`_
##


import bindings/geom2d
import private/butils

import std/[strformat]


type
  V2D*[T: SomeFloat] = object
    ## 2D Vector composed of x and y components. Can represent either a vector
    ## or a point. For an in-depth overview of a vector, see
    ## `here<https://nappgui.com/en/geom2d/v2d.html>`_.
    ##
    x*: T
      ## x component of the vector, or its position on the x-axis
    y*: T
      ## y component of the vector, or its position on the y-axis

  S2D*[T: SomeFloat] = object
    ## 2D Size. Contains width and height dimensions.
    ##
    width*: T
      ## The width.
      ##
    height*: T
      ## The height.
      ##

  R2D*[T: SomeFloat] = object
    ## 2D Rectangle. Contains a position vector and a size that represents a
    ## rectangle.
    ##
    pos*: V2D[T]
      ## The point or position of the origin of the rectangle
      ##
    size*: S2D[T]
      ## The size of the rectangle.
      ##
  
  T2D*[T: SomeFloat] = object
    ## 2D Transformation matrix. Contains three vectors that can be used to
    ## transform coordinates from one system to another. For more details
    ## on 2D transformations, see `here<https://nappgui.com/en/geom2d/t2d.html>`_.
    ## 
    i*: V2D[T]
      ## The i component of the linear transformation
      ##
    j*: V2D[T]
      ## The j component of the linear transformation
      ##
    p*: V2D[T]
      ## The position vector.
      ##
  
  Seg2D*[T: SomeFloat] = object
    ## 2D line segment. Contains two points that represent a line segment.
    ##
    p0*: V2D[T]
      ## The starting point of the segment.
      ##
    p1*: V2D[T]
      ## The ending point of the segment.
      ##
  
  Cir2D*[T: SomeFloat] = object
    ## 2D Circle. Contains a center point and a radius that represent a circle.
    ##
    c*: V2D[T]
      ## The center point of the circle.
      ##
    r*: T
      ## The radius of the circle.
      ##
  
  Box2D*[T: SomeFloat] = object
    ## 2D Bounding box. Similar to an `R2D`, but instead contains two points,
    ## min and max, that make up the boundaries of the box. Useful in collision
    ## detection and clipping operations.
    ##
    min*: V2D[T]
      ## The smallest point possible in the box.
      ## 
    max*: V2D[T]
      ## The largest point possible in the box.
      ##

  Tri2D*[T: SomeFloat] = object
    ## 2D Triangle. Contains three points which make up the three vertices of
    ## a triangle.
    ##
    p0*: V2D[T]
      ## The position of the first vertex.
      ##
    p1*: V2D[T]
      ## The position of the second vertex.
      ##
    p2*: V2D[T]
      ## The position of the third vertex.
      ##
  
  Switch[T: SomeFloat, F, D] = object
    when T is float32:
      impl*: F
    else:
      impl*: D

  Obb2D*[T: SomeFloat] {.borrow: `.`.} = distinct Switch[T, ptr OBB2Df, ptr OBB2Dd]
    ## 2D Oriented box. A bounding box that can rotate about its center.
    ## Provides a better "fit" for collision detection of objects that rotate,
    ## at a cost of being more complicated than typical bounding boxes.
    ## 
    ## See `here<https://nappgui.com/en/geom2d/obb2d.html>`_ for more details
    ## on oriented boxes in NAppGUI.
    ## 
    ## This object is copyable. This object contains a reference that is
    ## managed/owned by NAppGUI and is automatically destroyed.
    ##
  
  Pol2D*[T: SomeFloat] {.borrow: `.`.} = distinct Switch[T, ptr Pol2Df, ptr Pol2Dd]
    ## 2D Polygon. A versatile figure that is defined by several line segments
    ## that do not intersect each other, also known as simple polygons.
    ## 
    ## See `here<https://nappgui.com/en/geom2d/pol2d.html>`_ for more details
    ## on polygons in NAppGUI.
    ## 
    ## This object is copyable. This object contains a reference that is
    ## managed/owned by NAppGUI and is automatically destroyed.
    ##
  
  Col2D*[T: SomeFloat] = object
    ## 2D Collision. Contains data about a collision.
    ## 
    ## See `here<https://nappgui.com/en/geom2d/col2d.html>`_ for more details
    ## on how collision detection is handled by NAppGUI.
    ##
    p*: V2D[T]
    n*: V2D[T]
    d*: T

  CollideGeom*[T: SomeFloat] = V2D[T]|Seg2D[T]|Cir2D[T]|Box2D[T]|Obb2D[T]|Tri2D[T]|Pol2D[T]
    ## Type class for all geometric objects that support collision checking.
    ##

  # Aliases

  Vec* = V2D
    ## Alias for `V2D`
    ##
  Point* = V2D
    ## Alias for `V2D`, depending on the context a `V2D` can represent a point.
    ##
  Size* = S2D
    ## Alias for `S2D`
    ##
  Matrix* = T2D
    ## Alias for `T2D`
    ##
  Rect* = R2D
    ## Alias for `R2D`
    ##

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

# ========================================================================= V2D

template fromNag*(x: V2Df|V2Dd): auto = cast[V2D[fget[V2Df, V2Dd](x)]](x)
  ## Convert **from** an NAppGUI V2D to a Nim one
  ##

template toNag*[T](x: V2D[T]): auto = fcast[T](x, V2Df, V2Dd)
  ## Convert from a Nim V2D **to** an NAppGUI one.
  ##

template toNag[T](x: ptr V2D[T]): auto = fcast[T](x, ptr V2Df, ptr V2Dd)
template fromNag[T](x: ptr V2Df|ptr V2Dd): auto = cast[ptr V2D[fget(x)]](x)

proc `$`*[T: SomeFloat](v: V2D[T]): string =
  ## Get a string representation of `v`.
  ##
  &"v2d({v.x}, {v.y})"

template v2d*[T: SomeFloat](valx: T, valy: T): V2D[T] =
  ## Create a vector with components x and y.
  ## 
  V2D[T](x: valx, y: valy)
template point*[T: SomeFloat](x: T, y: T): V2D[T] = v2d[T](x, y)
  ## Alias for v2d
  ##

template v2d*[T: SomeFloat](point: V2D[T], dir: V2D[T], len: T): V2D[T] =
  ## Create a vector from a point and direction.
  ## 
  fromNag fdispatch[T](v2d_fromf, v2d_fromd, point.toNag.getPtr, dir.toNag.getPtr, len)

template v2d*[T: SomeFloat](angle: T): V2D[T] =
  ## Create a unit vector in the direction of `angle`, in radians.
  ##
  fromNag fdispatch[T](v2d_from_anglef, v2d_from_angled, angle) 

template v2d*(v: V2D[float32]): V2D[float64] =
  ## Convert a float32 vector to a float64 one (upcast).
  ##
  fromNag v2d_tod(v.toNag.toPtr)

template v2d*(v: V2D[float64]): V2D[float32] =
  ## Convert a float64 vector to a float32 one (downcast).
  ##
  fromNag v2d_tof(v.toNag.toPtr)

template `+`*[T: SomeFloat](a: V2D[T], b: V2D[T]): V2D[T] =
  ## Adds two vectors. The resulting vector has its components being the
  ## sum of `a` and `b`'s components.
  ## 
  fromNag fdispatch[T](v2d_addf, v2d_addd, a.toNag.getPtr, b.toNag.getPtr)

template `-`*[T: SomeFloat](a: V2D[T], b: V2D[T]): V2D[T] =
  ## Subtract two vectors.
  ## 
  fromNag fdispatch[T](v2d_subf, v2d_subd, a.toNag.getPtr, b.toNag.getPtr)

template `*`*[T: SomeFloat](a: V2D[T], s: T): V2D[T] =
  ## Multiply a vector `a` by a scalar `s`.
  ##
  fromNag fdispatch[T](v2d_mulf, v2d_muld, a.toNag.getPtr, s)

template `*`*[T: SomeFloat](a: V2D[T], b: V2D[T]): T =
  ## Calculate the product of two vectors.
  ##
  fdispatch[T](v2d_dotf, v2d_dotd, a.toNag.getPtr, b.toNag.getPtr)

template mid*[T: SomeFloat](a: V2D[T], b: V2D[T]): V2D[T] =
  ## Get the midpoint of two points `a` and `b`.
  ##
  fromNag fdispatch[T](v2d_midf, v2d_midd, a.toNag.getPtr, b.toNag.getPtr)

template unitImpl[T: SomeFloat](v1: V2D[T], v2: V2D[T], dist: ptr T): V2D[T] =
  fromNag fdispatch[T](v2d_unitf, v2d_unitd, v1.toNag.getPtr, v2.toNag.getPtr, dist)

template unitImpl[T: SomeFloat](x1: T, y1: T, x2: T, y2: T, dist: ptr T): V2D[T] =
  fromNag fdispatch[T](v2d_unit_xyf, v2d_unit_xyd, x1, y1, x2, y2, dist)

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
  fromNag fdispatch[T](v2d_perp_posf, v2d_perp_posd, v.toNag.getPtr)

template perpNeg*[T: SomeFloat](v: V2D[T]): V2D[T] =
  ## Gets the vector perdendicular to `v` in the negative direction, or 90
  ## degrees clockwise.
  ##
  fromNag fdispatch[T](v2d_perp_negf, v2d_perp_negd, v.toNag.getPtr)

template norm*[T: SomeFloat](v: var V2D[T]) =
  ## Normalize the vector `v`, or make its length = 1. If `v` is the zero
  ## vector then this operation does nothing.
  ##
  discard fdispatch[T](v2d_normf, v2d_normd, toNag(addr(v)))

template length*[T: SomeFloat](v: V2D[T]): T =
  ## Calculate the length of a vector `v`.
  ## 
  fdispatch[T](v2d_lengthf, v2d_lengthd, v.toNag.getPtr)

template sqlength*[T: SomeFloat](v: V2D[T]): T =
  ## Calculate the length squared of a vector `v`. Prefer this function over
  ## `length` when comparing lengths as it is more efficient.
  ##
  fdispatch[T](v2d_sqlengthf, v2d_sqlengthd, v.toNag.getPtr)

template distance*[T: SomeFloat](a: V2D[T], b: V2D[T]): T =
  ## Calculate the distance between points `a` and `b`.
  ##
  fdispatch[T](v2d_distf, v2d_distd, a.toNag.getPtr, b.toNag.getPtr)

template sqdistance*[T: SomeFloat](a: V2D[T], b: V2D[T]): T =
  ## Calculate the distance squared between points `a` and `b`. Prefer this
  ## function over `distance` when comparing distances as it is more efficient.
  ##
  fdispatch[T](v2d_sqdistf, v2d_sqdistd, a.toNag.getPtr, b.toNag.getPtr)

template angle*[T: SomeFloat](a: V2D[T], b: V2D[T]): T =
  ## Calculate the angle between two vectors `a` and `b`. The angle returned is
  ## in radians.
  ## 
  fdispatch[T](v2d_anglef, v2d_angled, a.toNag.getPtr, b.toNag.getPtr)

template rotate*[T: SomeFloat](v: var V2D[T], angle: T) =
  ## Rotates a vector `v` by `angle`, in radians.
  ##
  fdispatch[T](v2d_rotatef, v2d_rotated, toNag(v.addr), angle)

# ========================================================================= S2D

template fromNag*(x: S2Df|S2Dd): auto = cast[S2D[fget[S2Df, S2Dd](x)]](x)
  ## Convert **from** an NAppGUI S2D to a Nim one.
  ##
template toNag*[T: SomeFloat](x: S2D[T]): auto = fcast[T](x, S2Df, S2Dd)
  ## Convert from a Nim S2D **to** an NAppGUI one.
  ##

func `$`*[T: SomeFloat](s: S2D[T]): string =
  ## Get a string representation of the size
  ##
  &"s2d({s.width}, {s.height})"

template s2d*[T: SomeFloat](pwidth: T, pheight: T): S2D[T] =
  ## Creates a size with the given width and height.
  ## 
  S2D[T](width: pwidth, height: pheight)

template size*[T: SomeFloat](width: T, height: T): S2D =
  ## Alias for `s2d`.
  ##
  s2d[T](width, height)

# ========================================================================= R2D

template fromNag*(x: R2Df|R2Dd): auto = cast[R2D[fget[R2Df, R2Dd](x)]](x)
  ## Convert **from** an NAppGUI R2D to a Nim one
  ##

template toNag*[T: SomeFloat](x: R2D[T]): auto = fcast[T](x, R2Df, R2Dd)
  ## Convert from a Nim R2D **to** an NAppGUI one.
  ##

template toNag[T: SomeFloat](x: ptr R2D[T]): auto = fcast[T](x, ptr R2Df, ptr R2Dd)

template x*[T: SomeFloat](r: R2D[T]): T = r.pos.x
  ## Get the x position of the rectangle.
  ##
template `x=`*[T: SomeFloat](r: var R2D[T], val: T) = r.pos.x = val
  ## Set the x position of the rectangle.
  ##
template y*[T: SomeFloat](r: R2D[T]): T = r.pos.y
  ## Get the y position of the rectangle
  ##
template `y=`*[T: SomeFloat](r: var R2D[T], val: T) = r.pos.y = val
  ## Set the y position of the rectangle.
  ##
template width*[T: SomeFloat](r: R2D[T]): T = r.size.width
  ## Get the width of the rectangle.
  ##
template `width=`*[T: SomeFloat](r: R2D[T], val: T) = r.size.width = val
  ## Set the width of the rectangle.
  ## 
template height*[T: SomeFloat](r: R2D[T]): T = r.size.height
  ## Get the height of the rectangle.
  ##
template `height=`*[T: SomeFloat](r: R2D[T], val: T) = r.size.height = val
  ## Set the height of the rectangle.
  ## 

template top*[T: SomeFloat](r: R2D[T]): T = r.y
  ## Get the top side position of the rectangle, same as `r.y`
  ##
func `top=`*[T: SomeFloat](r: var R2D[T], val: T) =
  ## Set the top side position of the rectangle, adjusting the height so that
  ## bottom side position remains the same.
  ##
  r.height += r.y - val
  r.y = val
func bottom*[T: SomeFloat](r: R2D[T]): T = 
  ## Get the bottom side position of the rectangle, which is the y position
  ## plus the height.
  ##
  r.y + r.height
func `bottom=`*[T: SomeFloat](r: var R2D[T], val: T) =
  ## Set the bottom side position of the rectangle. Note: this changes the
  ## height of the rectangle
  ##
  r.height = val - r.y

template left*[T: SomeFloat](r: R2D[T]): T = r.x
  ## Get the left side position of the rectangle, same as `r.x`
  ##
template `left=`*[T: SomeFloat](r: var R2D[T], val: T) =
  ## Set the left side position of the rectangle, adjusting the width so that
  ## the right side position remains the same.
  ##
  r.width += r.x - val
  r.x = val
func right*[T: SomeFloat](r: R2D[T]): T =
  ## Get the right side position of the rectangle, which is the x position
  ## plus the width.
  ##
  r.x + r.width
func `right=`*[T: SomeFloat](r: var R2D[T], val: T) =
  ## Set the right side position of the rectangle. Note: this changes the
  ## width of the rectangle.
  ##
  r.width = val - r.x

func `$`*[T: SomeFloat](r: R2D[T]): string =
  &"r2d({r.x}, {r.y}, {r.width}, {r.height})"

template r2d*[T: SomeFloat](x: T, y: T, width: T, height: T): R2D[T] =
  ## Creates a rectangle with the given components.
  ##
  R2D[T](pos: v2d(x, y), size: s2d(width, height))

template rect*[T: SomeFloat](x: T, y: T, width: T, height: T): R2D[T] =
  ## Alias for r2d.
  ##
  r2d(x, y, width, height)

template center*[T: SomeFloat](r: R2D[T]): V2D[T] =
  ## Calculate the center position of the rectangle.
  ##
  fromNag fdispatch[T](r2d_centerf, r2d_centerd, getPtr(toNag(r))) 

template collides*[T: SomeFloat](a: R2D[T], b: R2D[T]): bool =
  ## Check if two rectangles `a` and `b` collide or intersect with each other.
  ## 
  toBool fdispatch[T](r2d_collidef, r2d_collided, getPtr(toNag(a)), getPtr(toNag(b)))

template contains*[T: SomeFloat](r: R2D[T], x: T, y: T): bool =
  ## Check if a point is inside the rectangle.
  ##
  toBool fdispatch[T](r2d_containsf, r2d_containsd, getPtr(toNag(r)), x, y)

template contains*[T: SomeFloat](r: R2D[T], p: Point[T]): bool =
  ## Convenience overload taking a point/v2d instead of separate coordinates
  ## Works with `in`!
  ##
  contains(r, p.x, p.y)

template isClipped*[T: SomeFloat](viewport: R2D[T], r: R2D[T]): bool =
  ## Tests if a rectangle, `r`, is contained in the rectangle `viewport`.
  ## `true` is returned if `r` is completely outside of `viewport`.
  ##
  toBool fdispatch[T](r2d_clipf, r2d_clipd, getPtr(toNag(viewport)), getPtr(toNag(r)))

template join*[T: SomeFloat](r: var R2D[T], src: R2D[T]) =
  ## Adjusts the size and position of `r` so that it contains `src`.
  ##
  fdispatch[T](r2d_joinf, r2d_joind, toNag(addr(r)), getPtr(toNag(src)))

# ========================================================================= T2D

template fromNag*(x: T2Df|T2Dd): auto = cast[T2D[fget[T2Df, T2Dd](x)]](x)
  ## Convert **from** an NAppGUI T2D to a Nim one
  ##

template toNag*[T: SomeFloat](x: T2D[T]): auto = fcast[T](x, T2Df, T2Dd)
  ## Convert from a Nim T2D **to** an NAppGUI one.
  ##

template toNag[T: SomeFloat](x: ptr T2D[T]): auto = fcast[T](x, ptr T2Df, ptr T2Dd)

func `$`*[T: SomeFloat](t: T2D[T]): string =
  ## Get a string representation of a transformation matrix.
  ##
  &"t2d({t.i}, {t.j}, {t.pos})"

template t2d*[T: SomeFloat](): T2D[T] =
  ## Initializes a transformation matrix with the identity matrix.
  ##
  T2D[T]( i: v2d(T(1), T(0)), j: v2d(T(0), T(1)), pos: default(V2D[T]) )

func t2d*(t: T2D[float32]): T2D[float64] =
  ## Converts a transformation from float32 to float64
  ##
  t2d_tod(cast[ptr T2Dd](result.addr), t.toNag.getPtr)

func t2d*(t: T2D[float64]): T2D[float32] =
  ## Converts a transformation from float64 to float32
  ##
  t2d_tof(cast[ptr T2Df](result.addr), t.toNag.getPtr)

template move*[T: SomeFloat](t: var T2D[T], src: T2D[T], x: T, y: T) =
  ## Multiply a transformation by a translation operation
  ##
  fdispatch[T](t2d_movef, t2d_moved, t.toNag.addr, src.toNag.getPtr, x, y)

template move*[T: SomeFloat](t: var T2D[T], x: T, y: T) =
  ## Translates `t` by `x` and `y`.
  ##
  move[T](t, t, x, y)

template rotate*[T: SomeFloat](t: var T2D[T], src: T2D[T], angle: T) =
  ## Multiply the transformation by a rotation operation
  ##
  fdispatch[T](t2d_rotatef, t2d_rotated, t.addr.toNag, src.getPtr.toNag, angle)

template rotate*[T: SomeFloat](t: var T2D[T], angle: T) =
  ## Transforms `t` by rotating `angle` radians.
  ##
  rotate[T](t, t, angle)

template scale*[T: SomeFloat](t: var T2D[T], src: T2D[T], sx: T, sy: T) =
  ## Multiply the transformation by a scale operation
  ##
  fdispatch[T](t2d_scalef, t2d_scaled, t.toNag.addr, src.toNag.getPtr, sx, sy)

template scale*[T: SomeFloat](t: var T2D[T], sx: T, sy: T) =
  ## Transforms `t` by scaling it by `sx` and `sy`.
  ##
  scale[T](t, t, sx, sy)

template invfast*[T: SomeFloat](t: var T2D[T], src: T2D[T]) =
  ## Calculate the inverse transformation efficiently, assuming the input is
  ## orthogonal (only rotations and translations).
  ##
  fdispatch[T](t2d_invfastf, t2d_invfastd, t.impl.addr, src.impl.getPtr)

template invfast*[T: SomeFloat](t: var T2D[T]) =
  ## Invert `t` efficiently. 
  ## 
  ## Note:: `t` must be orthogonal!
  ##
  invfast[T](t, t)

template inverse*[T: SomeFloat](t: var T2D[T], src: T2D[T]) =
  ## Calculate the inverse transformation. The inverse transformation is a
  ## matrix that when multiplied by its original matrix, yields the identity
  ## matrix.
  ##
  fdispatch[T](t2d_inversef, t2d_inversed, t.impl.addr, src.impl.getPtr)

template inverse*[T: SomeFloat](t: var T2D[T]) =
  ## Invert `t`.
  ##
  inverse[T](t, t)

template mult*[T: SomeFloat](t: var T2D[T], src1: T2D[T], src2: T2D[T]) =
  ## Multiple two transformations storing the result in `t`
  ##
  fdispatch[T](t2d_multf, t2d_multd, t.impl.addr, src1.impl.getPtr, src2.impl.getPtr)

template mult*[T: SomeFloat](dest: var T2D[T], src: T2D[T]) =
  mult[T](dest, dest, src)

template mult*[T: SomeFloat](v: var V2D[T], t: T2D[T], src: V2D[T]) =
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

template fromNag*(x: Seg2Df|Seg2Dd): auto = cast[Seg2D[fget[Seg2Df, Seg2Dd](x)]](x)
  ## Convert **from** an NAppGUI Seg2D to a Nim one
  ##

template toNag*[T: SomeFloat](x: Seg2D[T]): auto = fcast[T](x, Seg2Df, Seg2Dd)
  ## Convert from a Nim Seg2D **to** an NAppGUI one.
  ##

template toNag[T: SomeFloat](x: ptr Seg2D[T]): auto = fcast[T](x, ptr Seg2Df, ptr Seg2Dd)


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

template fromNag*(x: Cir2Df|Cir2Dd): auto = cast[Cir2D[fget[Cir2Df, Cir2Dd](x)]](x)
  ## Convert **from** an NAppGUI Cir2D to a Nim one
  ##

template toNag*[T: SomeFloat](x: Cir2D[T]): auto = fcast[T](x, Cir2Df, Cir2Dd)
  ## Convert from a Nim Cir2D **to** an NAppGUI one.
  ##

proc `$`*[T: SomeFloat](cir: Cir2D[T]): string =
  ## Get a string representation of the circle
  ##
  &"cir2d({cir.c.x}, {cir.c.y}, {cir.r})"

template cir2d*[T: SomeFloat](px: T, py: T, pr: T): Cir2D[T] =
  ## Create a circle with the given components. `x` and `y` is the center
  ## point of the circle and `r` is the radius.
  ##
  Cir2D[T](c: v2d(px, py), r: pr)

template cir2d*[T: SomeFloat](box: Box2D[T]): Cir2D[T] =
  ## Create a circle that contains the given box
  ##
  fromNag fdispatch[T](cir2d_from_boxf, cir2d_from_boxd, getPtr(toNag(box)))

proc cir2d*[T: SomeFloat](points: openArray[V2D[T]]): Cir2D[T] =
  ## Create a circle that contains a the given array of points.
  ##
  fromNag fdispatch[T](cir2d_from_pointsf, cir2d_from_pointsd,
    toNag(unsafeAddr(points[0])), points.len.uint32
  )

proc minimum*[T: SomeFloat](points: openArray[V2D[T]]): Cir2D[T] =
  ## Calculates a circle of minimum radius that contains the given array of
  ## points. Slower than `cir2d(points)`.
  ##
  fromNag fdispatch[T](cir2d_minimumf, cir2d_minimumd,
    toNag(unsafeAddr(points[0])), points.len.uint32
  )

template area*[T: SomeFloat](c: Cir2D[T]): T =
  ## Calculate the area of the circle.
  ##
  fdispatch[T](cir2d_areaf, cir2d_aread, getPtr(toNag(c)))

func isNull*[T: SomeFloat](c: Cir2D): bool =
  ## Check if a circle is null (dimensionless), or has a radius less than 0.
  ##
  c.r < T(0.0)

# ======================================================================= Box2D

template fromNag*(x: Box2Df|Box2Dd): auto = cast[Box2D[fget[Box2Df, Box2Dd](x)]](x)
  ## Convert **from** an NAppGUI Box2D to a Nim one
  ##

template toNag*[T: SomeFloat](x: Box2D[T]): auto = fcast[T](x, Box2Df, Box2Dd)
  ## Convert from a Nim Box2D **to** an NAppGUI one.
  ##

template toNag[T: SomeFloat](x: ptr Box2D[T]): auto = fcast[T](x, ptr Box2Df, ptr Box2Dd)

func `$`*[T: SomeFloat](b: Box2D[T]): string =
  ## Get a string representation of a box.
  ##
  ""

template box2d*[T: SomeFloat](minX: T, minY: T, maxX: T, maxY: T): Box2D[T] =
  ## Create a new box with the given limits.
  ##
  Box2D[T](min: v2d(minX, minY), max: v2d(maxX, maxY))

proc box2d*[T: SomeFloat](points: openArray[V2D[T]]): Box2D[T] =
  ## Create a new box that contains the given array of points.
  ##
  fromNag fdispatch[T](box2d_from_pointsf, box2d_from_pointsd,
    toNag(unsafeAddr(points[0])), points.len.uint32
  )

template center*[T: SomeFloat](b: Box2D[T]): V2D[T] =
  ## Calculate the center point of the box
  ##
  fromNag fdispatch[T](box2d_centerf, box2d_centerd, getPtr(toNag(b)))

template add*[T: SomeFloat](box: var Box2D[T], p: V2D[T]) =
  ## Adjusts the box so that it contains point `p`. If `p` is already contained
  ## in this box, then the box is not modified.
  ##
  fdispatch[T](box2d_addf, box2d_addd, toNag(addr(box)), getPtr(toNag(p)))

template add*[T: SomeFloat](box: var Box2D[T], points: openArray[V2D[T]]) =
  ## Adjusts the box so that it contains all points in the given array.
  ##
  fdispatch[T](box2d_addnf, box2d_addnd,
    toNag(unsafeAddr(points[0])), points.len.uint32
  )

template add*[T: SomeFloat](box: var Box2D[T], circle: Cir2D[T]) =
  ## Adjusts the box so that it contains the given circle.
  ##
  fdispatch[T](box2d_add_circlef, box2d_add_circled, toNag(addr(box)), getPtr(toNag(circle)))

template merge*[T: SomeFloat](dest: var Box2D[T], src: Box2D[T]) =
  ## Merges both boxes and stores the result into `dest`. Or in other words,
  ## `dest` is adjusted so that it contains `src`.
  ##
  fdispatch[T](box2d_mergef, box2d_merged, toNag(addr(dest)), getPtr(toNag(src)))

proc segments*[T: SomeFloat](box: Box2D[T]): array[4, Seg2D[T]] =
  ## Gets the four segments that make up this box.
  ##
  fdispatch[T](box2d_segmentsf, box2d_segmentsd, getPtr(toNag(box)), toNag(addr(result[0])))

template area*[T: SomeFloat](box: Box2D[T]): T =
  ## Calculate the area of the box.
  ##
  fdispatch[T](box2d_areaf, box2d_aread, getPtr(toNag(box)))

template isNull*[T: SomeFloat](box: Box2D[T]): bool =
  ## Check if the box is null or has no geometry (the box's minium is greater
  ## than its maximum).
  ## 
  toBool fdispatch[T](box2d_is_nullf, box2d_is_nulld, getPtr(toNag(box)))

# ======================================================================= Obb2D

proc `=destroy`*[T: SomeFloat](b: var Obb2D[T]) =
  ## Destructor for Obb2D objects. The reference to an NAppGUI OBB2D is
  ## destroyed.
  ##
  if b.impl != nil:
    fdispatch[T](obb2d_destroyf, obb2d_destroyd, b.impl.addr)
proc `=copy`*[T: SomeFloat](dest: var Obb2D[T], src: Obb2D[T]) =
  ## Copy operator for Obb2D objects. `dest` is destroyed and gets its own
  ## copy of `src`.
  ##
  if dest.impl != src.impl:
    `=destroy`(dest)
    wasMoved(dest)
    dest.impl = fdispatch[T](obb2d_copyf, obb2d_copyd, src.impl)
proc `=sink`*[T: SomeFloat](dest: var Obb2D[T], src: Obb2D[T]) =
  ## Sink operator for Obb2D objects. `dest` is destroyed and takes the
  ## reference from `src`.
  ##
  `=destroy`(dest)
  wasMoved(dest)
  dest.impl = src.impl

template toNag[T: SomeFloat](obb: Obb2D[T]): auto = obb.impl

template obb2d*[T: SomeFloat](center: V2D[T], width: T, height: T, angle: T): Obb2D[T] =
  ## Create a new oriented box with center point, dimensions and angle. `angle`
  ## is in radians, with respect to the x-axis.
  ##
  Obb2D[T](impl: fdispatch[T](obb2d_createf, obb2d_created,
    getPtr(toNag(center)), width, height, angle))

template obb2d*[T: SomeFloat](p0: V2D[T], p1: V2D[T], thickness: T): Obb2D[T] =
  ## Create a new oriented box from a line segment.
  ##
  Obb2D[T](impl: fdispatch[T](obb2d_from_linef, obb2d_from_lined,
    getPtr(toNag(p0)), getPtr(toNag(p1)), thickness
  ))

proc obb2d*[T: SomeFloat](points: openArray[V2D[T]]): Obb2D[T] =
  ## Create an oriented box from the given array of points.
  ##
  result.impl = fdispatch[T](obb2d_from_pointsf, obb2d_from_pointsd,
    toNag(unsafeAddr(points[0])), points.len.uint32
  )

template update*[T: SomeFloat](o: var Obb2D[T], center: V2D[T], width: T,
                               height: T, angle: T) =
  ## Update the box's parameters.
  ##
  fdispatch[T](obb2d_updatef, obb2d_updated, o.impl,
    getPtr(toNag(center)), width, height, angle
  )

template move*[T: SomeFloat](o: var Obb2D[T], offsetX: T, offsetY: T) =
  ## Move by box by the given displacements.
  ##
  fdispatch[T](obb2d_movef, obb2d_moved, o.impl, offsetX, offsetY)

template transform*[T: SomeFloat](o: var Obb2D[T], t2d: T2D[T]) =
  ## Apply a transformation to the box.
  ##
  fdispatch[T](obb2d_transformf, obb2d_transformd, o.impl, getPtr(toNag(t2d)))

proc corners*[T: SomeFloat](o: Obb2D[T]): array[4, V2D[T]] =
  ## Get the vertices of the box, as an array of 4 vectors.
  ##
  let buf = fdispatch[T](obb2d_cornersf, obb2d_cornersd, o.impl)
  copyMem(result[0].addr, buf, sizeof(V2D[T]) * 4)

template center*[T: SomeFloat](o: Obb2D[T]): V2D[T] =
  ## Get the center point of the box.
  ##
  fromNag fdispatch[T](obb2d_centerf, obb2d_centerd, o.impl)

template width*[T: SomeFloat](o: Obb2D[T]): T =
  ## Get the width of the box.
  ##
  fdispatch[T](obb2d_widthf, obb2d_widthd, o.impl)

template height*[T: SomeFloat](o: Obb2D[T]): T =
  ## Get the height of the box.
  ##
  fdispatch[T](obb2d_heightf, obb2d_heightd, o.impl)

template angle*[T: SomeFloat](o: Obb2D[T]): T =
  ## Get the angle of the box.
  ##
  fdispatch[T](obb2d_anglef, obb2d_angled, o.impl)

template area*[T: SomeFloat](o: Obb2D[T]): T =
  ## Calculate the area of the box.
  ##
  fdispatch[T](obb2d_areaf, obb2d_aread, o.impl)

template toBox*[T: SomeFloat](o: Obb2D[T]): Box2D[T] =
  fromNag fdispatch[T](obb2d_boxf, obb2d_boxd, o.impl)

# ======================================================================= Tri2D

template fromNag*(x: Tri2Df|Tri2Dd): auto = cast[Tri2D[fget[Tri2Df, Tri2Dd](x)]](x)
  ## Convert **from** an NAppGUI Tri2D to a Nim one
  ##

template toNag*[T: SomeFloat](x: Tri2D[T]): auto = fcast[T](x, Tri2Df, Tri2Dd)
  ## Convert from a Nim Tri2D **to** an NAppGUI one.
  ##
template toNag*[T: SomeFloat](x: ptr Tri2D[T]): auto = fcast[T](x, ptr Tri2Df, ptr Tri2Dd)


func `$`*[T: SomeFloat](t: Tri2D[T]): string =
  ## Get a string representation of a triangle.
  ##
  &"tri2d({t.p0.x}, {t.p0.y}, {t.p1.x}, {t.p1.y}, {t.p2.x}, {t.p2.y})"

template tri2d*[T: SomeFloat](pp0: V2D[T], pp1: V2D[T], pp2: V2D[T]): Tri2D[T] =
  ## Create a triangle from the coordinates as vectors of its three vertices.
  ##
  Tri2D[T](p0: pp0, p1: pp1, p2: pp2)

template tri2d*[T: SomeFloat](x0: T, y0: T, x1: T, y1: T, x2: T, y2: T): Tri2D[T] =
  ## Create a triangle from the coordinates of its three vertices.
  ##
  tri2d(v2d(x0, y0), v2d(x1, y1), v2d(x2, y2))

template transform*[T: SomeFloat](tri: var Tri2D[T], t2d: T2D[T]) =
  ## Apply a transformation to the triangle.
  ##
  fdispatch[T](tri2d_transformf, tri2d_transformd, toNag(addr(tri)), getPtr(toNag(t2d)))

template area*[T: SomeFloat](tri: Tri2D[T]): T =
  ## Calculate the area of the triangle.
  ##
  fdispatch[T](tri2d_areaf, tri2d_aread, getPtr(toNag(tri)))

template isCounterClockwise*[T: SomeFloat](tri: Tri2D[T]): bool =
  ## Determines the order of the travel of points in the triangle. `true` is
  ## returned if the order is counter-clockwise, and `false` is returned for
  ## clockwise order.
  ##
  toBool fdispatch[T](tri2d_ccwf, tri2d_ccwd, getPtr(toNag(tri)))

template isClockwise*[T: SomeFloat](tri: Tri2D[T]): bool =
  ## Convenience template for `not tri.isCounterClockwise`.
  ##
  not isCounterClockwise[T](tri)

template centroid*[T: SomeFloat](tri: Tri2D[T]): V2D[T] =
  ## Calculates the centroid, or center of mass, of the triangle.
  ##
  fromNag fdispatch[T](tri2d_centroidf, tri2d_centroidd, getPtr(toNag(tri)))

# ======================================================================= Pol2D

proc `=destroy`*[T: SomeFloat](p: var Pol2D[T]) =
  ## Destructor for Pol2D objects. The reference to an NAppGUI Pol2D is
  ## destroyed.
  ##
  if p.impl != nil:
    fdispatch[T](pol2d_destroyf, pol2d_destroyd, p.impl.addr)
proc `=copy`*[T: SomeFloat](dest: var Pol2D[T], src: Pol2D[T]) =
  ## Copy operator for Pol2D objects. `dest` is destroyed and gets its own
  ## copy of `src`.
  ##
  if dest.impl != src.impl:
    `=destroy`(dest)
    wasMoved(dest)
    dest.impl = fdispatch[T](pol2d_copyf, pol2d_copyd, src.impl)
proc `=sink`*[T: SomeFloat](dest: var Pol2D[T], src: Pol2D[T]) =
  ## Sink operator for Pol2D objects. `dest` is destroyed and takes the
  ## reference from `src`.
  ##
  `=destroy`(dest)
  wasMoved(dest)
  dest.impl = src.impl

template toNag[T](pol: Pol2D[T]): auto = pol.impl

template pol2d*[T: SomeFloat](points: openArray[V2D[T]]): Pol2D[T] =
  ## Creates a polygon from the given array of points.
  ##
  Pol2D[T](impl: fdispatch[T](pol2d_createf, pol2d_created,
    toNag(unsafeAddr(points[0])), points.len.uint32
  ))

template convexHull*[T: SomeFloat](points: openArray[V2D[T]]): Pol2D[T] =
  ## Creates the minimum convex polygon that surrounds the given array of
  ## points.
  ##
  Pol2D[T](impl: fdispatch[T](pol2d_convex_hullf, pol2d_convex_hulld,
    toNag(unsafeAddr(points[0])), points.len.uint32
  ))

template transform*[T: SomeFloat](pol: var Pol2D[T], t2d: T2D[T]) =
  ## Applies a transformation to the polygon.
  ##
  fdispatch[T](pol2d_transformf, pol2d_transformd, pol.impl, getPtr(toNag(t2d)))

template len*[T: SomeFloat](pol: Pol2D[T]): int =
  fdispatch[T](pol2d_nf, pol2d_nd, pol.impl).int

template rawPoints*[T: SomeFloat](pol: Pol2D[T]): ptr UncheckedArray[V2D[T]] =
  ## Gets the vertices that make up this polygon, as an unchecked array. Get
  ## the number of points in this array via `pol.len`.
  ## 
  ## WARNING: This function is unsafe but is provided for convenience. Prefer to
  ## use `pol.points` instead when able. Do not modify this array! 
  ##
  cast[ptr UncheckedArray[V2D[T]]](
    fromNag fdispatch[T](pol2d_pointsf, pol2d_pointsd, pol.impl)
  )

proc points*[T: SomeFloat](pol: Pol2D[T]): seq[V2D[T]] =
  ## Gets a seq of the vertices that make up this polygon.
  ##
  let n = pol.len
  result.setLen(n)
  copyMem(result[0].addr, pol.rawPoints()[][0].addr, n * sizeof(V2D[T]))

template area*[T: SomeFloat](pol: Pol2D[T]): T =
  ## Calculates the area of the polygon.
  ##
  fdispatch[T](pol2d_areaf, pol2d_aread, pol.impl)

template toBox*[T: SomeFloat](pol: Pol2D[T]): Box2D[T] =
  ## Gets a box with the geometric limits of the polygon.
  ##
  fromNag fdispatch[T](pol2d_boxf, pol2d_boxd, pol.impl)

template isCounterClockwise*[T: SomeFloat](pol: Pol2D[T]): bool =
  ## Determine the winding order of the polygon points. `true` is returned if
  ## the order is counter-clockwise, otherwise `false` is returned for
  ## clockwise order.
  ##
  toBool fdispatch[T](pol2d_ccwf, pol2d_ccwd, pol.impl)

template isClockwise*[T: SomeFloat](pol: Pol2D[T]): bool =
  ## Convenience template for `not pol.isCounterClockwise`.
  ##
  not isCounterClockwise[T](pol)

template isConvex*[T: SomeFloat](pol: Pol2D[T]): bool =
  ## Determine if the polygon is convex. A convex polygon has all its interior
  ## angles being less than 180 degrees.
  ##
  toBool fdispatch[T](pol2d_convexf, pol2d_convexd, pol.impl)

template centroid*[T: SomeFloat](pol: Pol2D[T]): V2D[T] =
  ## Calculate the centroid, or center of mass, of a polygon.
  ##
  fromNag fdispatch[T](pol2d_centroidf, pol2d_centroidd, pol.impl)

template visualCenter*[T: SomeFloat](pol: Pol2D[T]): V2D[T] =
  ## Calculate the visual center, or label point, of a polygon. Uses an
  ## adaptation of the polylabel algorithm from `MapBox<https://github.com/mapbox/polylabel>`_.
  ##
  fromNag fdispatch[T](pol2d_visual_centerf, pol2d_visual_centerd, pol.impl)

proc triangles*[T: SomeFloat](pol: Pol2D[T]): seq[Tri2D[T]] =
  ## Gets a list of the triangles that make up this polygon.
  ##
  doAssert false, "not yet implemented"

proc convexPartition*[T: SomeFloat](pol: Pol2D[T]): seq[Pol2D[T]] =
  ## Gets a list of convex polygons that make up this polygon.
  ##
  doAssert false, "not yet implemented"

# ======================================================================= Col2D

template collisionImpl[T: SomeFloat](
  fun32: typed, fun64: typed,
  col: var Col2D[T],
  obj1: CollideGeom[T], obj2: CollideGeom[T],
  tol: T
): bool =
  toBool fdispatch[T](fun32, fun64, getPtr(toNag(obj1)), getPtr(toNag(obj2)),
                      tol, toNag(addr(col)))

template collisionImpl[T: SomeFloat](
  fun32: typed, fun64: typed,
  col: var Col2D[T],
  obj1: CollideGeom[T], obj2: CollideGeom[T]
): bool =
  toBool fdispatch[T](fun32, fun64, getPtr(toNag(obj1)), getPtr(toNag(obj2)),
                      toNag(addr(col)))

template collision*[T: SomeFloat](col: var Col2D[T], p1: V2D[T], p2: V2D[T], tol: T): bool =
  ## Point vs Point
  ## 
  ## Check for a collision between two points. If a collision occurred, details
  ## about it are stored into `col`. The tolerance, `tol`, is the minimum
  ## distance needed to be considered a collision.
  ##
  collisionImpl[T](col2d_point_pointf, col2d_point_pointd, col, p1, p2, tol)

template collision*[T: SomeFloat](col: var Col2D[T], seg: Seg2D[T], p: V2D[T], tol: T): bool =
  ## Segment vs Point.
  ## 
  ## Check for a collision between a segment and a point. If a collision
  ## occurred, details about it are stored into `col`. The tolerance, `tol`,
  ## is the minimum distance needed to be considered a collision.
  ##
  collisionImpl[T](col2d_segment_pointf, col2d_segment_pointd, col, p1, p2, tol)

template collision*[T: SomeFloat](col: var Col2D[T], seg1: Seg2D[T], seg2: Seg2D[T]): bool =
  ## Segment vs Segment.
  ##
  ## Check for a collision between two segments. If a collision occurred,
  ## details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_segment_segmentf, col2d_segment_segmentd, col, seg1, seg2)

template collision*[T: SomeFloat](col: var Col2D[T], cir: Cir2D[T], p: V2D[T]): bool =
  ## Circle vs Point.
  ##
  ## Check for a collision between a circle and a point. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_circle_pointf, col2d_circle_pointd, col, cir, p)

template collision*[T: SomeFloat](col: var Col2D[T], cir: Cir2D[T], seg: Seg2D[T]): bool =
  ## Circle vs Segment.
  ##
  ## Check for a collision between a circle and a segment. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_circle_segmentf, col2d_circle_segmentd, col, cir, seg)

template collision*[T: SomeFloat](col: var Col2D[T], cir1: Cir2D[T], cir2: Cir2D[T]): bool =
  ## Circle vs Circle.
  ##
  ## Check for a collision between two circles. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_circle_circlef, col2d_circle_circled, col, cir1, cir2)

template collision*[T: SomeFloat](col: var Col2D[T], box: Box2D[T], p: V2D[T]): bool =
  ## Box vs Point.
  ##
  ## Check for a collision between a box and a point. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_box_pointf, col2d_box_pointd, col, box, p)

template collision*[T: SomeFloat](col: var Col2D[T], box: Box2D[T], seg: Seg2D[T]): bool =
  ## Box vs Segment.
  ##
  ## Check for a collision between a box and a segment. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_box_segmentf, col2d_box_segmentd, col, box, seg)

template collision*[T: SomeFloat](col: var Col2D[T], box: Box2D[T], cir: Cir2D[T]): bool =
  ## Box vs Circle.
  ##
  ## Check for a collision between a box and a circle. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_box_circlef, col2d_box_circled, col, box, cir)

template collision*[T: SomeFloat](col: var Col2D[T], box1: Box2D[T], box2: Box2D[T]): bool =
  ## Box vs Box.
  ##
  ## Check for a collision between two boxes. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_box_boxf, col2d_box_boxd, col, box1, box2)

template collision*[T: SomeFloat](col: var Col2D[T], obb: Obb2D[T], p: V2D[T]): bool =
  ## Oriented Box vs Point.
  ##
  ## Check for a collision between an oriented box and a point. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_obb_pointf, col2d_obb_pointd, col, obb, p)

template collision*[T: SomeFloat](col: var Col2D[T], obb: Obb2D[T], seg: Seg2D[T]): bool =
  ## Oriented Box vs Segment.
  ##
  ## Check for a collision between an oriented box and a segment. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_obb_segmentf, col2d_obb_segmentd, col, obb, seg)

template collision*[T: SomeFloat](col: var Col2D[T], obb: Obb2D[T], cir: Cir2D[T]): bool =
  ## Oriented Box vs Circle.
  ##
  ## Check for a collision between an oriented box and a point. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_obb_circlef, col2d_obb_circled, col, obb, cir)

template collision*[T: SomeFloat](col: var Col2D[T], obb: Obb2D[T], box: Box2D[T]): bool =
  ## Oriented Box vs Box.
  ##
  ## Check for a collision between an oriented box and a box. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_obb_boxf, col2d_obb_boxd, col, obb, box)

template collision*[T: SomeFloat](col: var Col2D[T], obb1: Obb2D[T], obb2: Obb2D[T]): bool =
  ## Oriented Box vs Oriented Box.
  ##
  ## Check for a collision between two oriented boxes. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_obb_obbf, col2d_obb_obbd, col, obb1, obb2)

template collision*[T: SomeFloat](col: var Col2D[T], tri: Tri2D[T], p: V2D[T]): bool =
  ## Triangle vs Point.
  ##
  ## Check for a collision between a triangle and a point. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_tri_pointf, col2d_tri_pointd, col, tri, p)

template collision*[T: SomeFloat](col: var Col2D[T], tri: Tri2D[T], seg: Seg2D[T]): bool =
  ## Triangle vs Segment.
  ##
  ## Check for a collision between a triangle and a segment. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_tri_segmentf, col2d_tri_segmentd, col, tri, seg)

template collision*[T: SomeFloat](col: var Col2D[T], tri: Tri2D[T], cir: Cir2D[T]): bool =
  ## Triangle vs Circle.
  ##
  ## Check for a collision between a triangle and a circle. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_tri_circlef, col2d_tri_circled, col, tri, cir)

template collision*[T: SomeFloat](col: var Col2D[T], tri: Tri2D[T], box: Box2D[T]): bool =
  ## Triangle vs Box.
  ##
  ## Check for a collision between a triangle and a box. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_tri_boxf, col2d_tri_boxd, col, tri, box)

template collision*[T: SomeFloat](col: var Col2D[T], tri: Tri2D[T], obb: Obb2D[T]): bool =
  ## Triangle vs Oriented Box.
  ##
  ## Check for a collision between a triangle and an oriented box. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_tri_obbf, col2d_tri_obbd, col, tri, obb)

template collision*[T: SomeFloat](col: var Col2D[T], tri1: Tri2D[T], tri2: Tri2D[T]): bool =
  ## Triangle vs Triangle.
  ##
  ## Check for a collision between two triangles. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_tri_trif, col2d_tri_trid, col, tri1, tri2)

template collision*[T: SomeFloat](col: var Col2D[T], pol: Pol2D[T], p: V2D[T]): bool =
  ## Polygon vs Point.
  ##
  ## Check for a collision between a polygon and a point. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_poly_pointf, col2d_poly_pointd, col, pol, p)

template collision*[T: SomeFloat](col: var Col2D[T], pol: Pol2D[T], seg: Seg2D[T]): bool =
  ## Polygon vs Segment.
  ##
  ## Check for a collision between a polygon and a segment. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_poly_segmentf, col2d_poly_segmentd, col, pol, seg)

template collision*[T: SomeFloat](col: var Col2D[T], pol: Pol2D[T], cir: Cir2D[T]): bool =
  ## Polygon vs Circle.
  ##
  ## Check for a collision between a polygon and a circle. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_poly_circlef, col2d_poly_circled, col, pol, cir)

template collision*[T: SomeFloat](col: var Col2D[T], pol: Pol2D[T], box: Box2D[T]): bool =
  ## Polygon vs Box.
  ##
  ## Check for a collision between a polygon and a box. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_poly_boxf, col2d_poly_boxd, col, pol, box)

template collision*[T: SomeFloat](col: var Col2D[T], pol: Pol2D[T], obb: Obb2D[T]): bool =
  ## Polygon vs Oriented Box.
  ##
  ## Check for a collision between a polygon and an oriented box. If a
  ## collision occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_poly_obbf, col2d_poly_obbd, col, pol, obb)

template collision*[T: SomeFloat](col: var Col2D[T], pol: Pol2D[T], tri: Tri2D[T]): bool =
  ## Polygon vs Triangle.
  ##
  ## Check for a collision between a polygon and a triangle. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_poly_trif, col2d_poly_trid, col, pol, tri)

template collision*[T: SomeFloat](col: var Col2D[T], pol1: Pol2D[T], pol2: Pol2D[T]): bool =
  ## Polygon vs Polygon.
  ##
  ## Check for a collision between two polygons. If a collision
  ## occurred, details about it are stored into `col`.
  ## 
  collisionImpl[T](col2d_poly_polyf, col2d_poly_polyd, col, pol1, pol2)
