{.used.}

import nappgui/geom2d

import std/unittest

# Note: these tests are not comprehensive as we are not testing the correctness
#       of NAppGUI but the wrapper.

# A test with just a `skip()` is a stub, and should be implemented when able.

# ========================================================================= V2D

test "V2D.`$`":
  var v: Vec[float64]
  check $v == "v2d(0.0, 0.0)"

test "V2D.get/set":
  var v: Vec[float32]
  check:
    v.x == 0.0f
    v.y == 0.0f
  v.x = 1.0f
  v.y = -1.0f
  check:
    v.x == 1.0f
    v.y == -1.0f

test "V2D.v2d":
  var v = v2d(1.0, 2.0)
  check:
    v.x == 1.0
    v.y == 2.0
  
  v = v2d(0.0)
  check:
    v.x == 1.0
    v.y == 0.0
  v = v2d(v2d(0.0, 0.0), v2d(0.0, 4.0), 3.0)
  check:
    v.x == 0.0
    v.y == 12.0

test "V2D.`+`":
  let v = v2d(1.0, 2.0) + v2d(-1.0, -2.0)
  check:
    v.x == 0.0
    v.y == 0.0

test "V2D.`-`":
  let v = v2d(1.0f, 2.0f)
  let z = v - v
  check:
    z.x == 0.0f
    z.y == 0.0f

test "V2D.`*`":
  let v = v2d(1.0, 2.0) * 2.0
  check:
    v.x == 2.0
    v.y == 4.0
  # dot product
  check v2d(1.0, 2.0) * v2d(3.0, 4.0) == 11.0

test "V2D.mid":
  let p = mid(v2d(-1.0, -1.0), v2d(1.0, 1.0))
  check:
    p.x == 0.0
    p.y == 0.0

test "V2D.unit":
  let
    p0 = point(-2.0f, 0.0f)
    p1 = point(-10.0f, 0.0f)
    expected = point(-1.0f, 0.0f)
  var dist: float32
  check unit(p0, p1) == expected
  discard unit(p0, p1, dist)
  check dist == 8.0f
  check unit(p0.x, p0.y, p1.x, p1.y) == expected
  dist = 0.0f
  discard unit(p0.x, p0.y, p1.x, p1.y, dist)
  check dist == 8.0f

test "V2D.perpPos":
  let v = v2d(2.0, 2.0)
  check v.perpPos() == v2d(-2.0, 2.0)

test "V2D.perpNeg":
  let v = v2d(2.0, 2.0)
  check v.perpNeg() == v2d(2.0, -2.0)

test "V2D.norm":
  var v = v2d(0.0, -100.0)
  v.norm()
  check v == v2d(0.0, -1.0)
  # norm'ing a zero vector should result in a zero vector
  v.reset()
  v.norm()
  check v == V2D[float64].default

test "V2D.length,sqlength":
  var v: V2D[float32]
  check:
    v.length() == 0.0f
    v.sqlength() == 0.0f
  v = v2d(3.0f, 4.0f)
  check:
    v.length() == 5.0f
    v.sqlength() == 25.0f

test "V2D.distance,sqdistance":
  let
    v1 = v2d(1.0, 1.0)
    v2 = v2d(5.0, 4.0)
  check:
    distance(v1, v2) == 5.0
    sqdistance(v1, v2) == 25.0

test "V2D.angle":
  let
    v1 = v2d(120.22132, 0.0)
    v2 = v2d(0.0, 3.53)
  # 90 degrees or pi/2 
  check angle(v1, v2) in 1.4..1.6

test "V2D.rotate":
  var v = v2d(1.0f, 1.0f)
  v.rotate(0.0f)
  check:
    v.x in 0.9f..1.1f
    v.y in 0.9f..1.1f

# ========================================================================= S2D

test "S2D.s2d":
  let 
    sz = s2d(100.0, 200.0)
    sz2 = size(480.0f, 240.0f)
  check:
    sz.width == 100.0
    sz.height == 200.0
    sz2.width == 480.0f
    sz2.height == 240.0f

test "S2D.`$`":
  var sz: S2D[float32]
  check $sz == "s2d(0.0, 0.0)"

# ========================================================================= R2D

test "R2D.x":
  var r: R2D[float32]
  check:
    r.x == 0.0f
    r.x == r.pos.x
  r.x = 0.2f
  check:
    r.x == 0.2f
    r.x == r.pos.x

test "R2D.y":
  var r: R2D[float64]
  check:
    r.y == 0.0
    r.y == r.pos.y
  r.y = 1.0
  check:
    r.y == 1.0
    r.y == r.pos.y

test "R2D.width":
  var r: R2D[float64]
  check:
    r.width == 0.0
    r.width == r.size.width
  r.width = 100
  check:
    r.width == 100.0
    r.width == r.size.width

test "R2D.height":
  var r: Rect[float64]
  check:
    r.height == 0.0
    r.height == r.size.height
  r.height = 2.0
  check:
    r.height == 2.0
    r.height == r.size.height

const testRect = rect(10.0, 10.0, 90.0, 90.0)
# top, left, bottom, right = 10, 10, 100, 100

test "R2D.top":
  var r = testRect
  check:
    r.top == 10.0
    r.top == r.y
    r.bottom == 100.0
    r.height == 90.0
  r.top = 0
  check:
    r.top == 0
    r.top == r.y
    r.bottom == 100.0
    r.height == 100.0

test "R2D.bottom":
  var r = testRect
  r.bottom = 50.0
  check:
    r.top == 10.0
    r.bottom == 50.0
    r.height == 40.0

test "R2D.left":
  var r = testRect
  check:
    r.left == 10.0
    r.left == r.x
    r.right == 100.0
    r.width == 90.0
  r.left = 0.0
  check:
    r.left == 0.0
    r.left == r.x
    r.right == 100.0
    r.width == 100.0

test "R2D.right":
  var r = testRect
  r.right = 50.0
  check:
    r.left == 10.0
    r.right == 50.0
    r.width == 40.0

test "R2D.`$`":
  check:
    $testRect == "r2d(10.0, 10.0, 90.0, 90.0)"

test "R2D.r2d":
  let 
    r = r2d(1.0, 2.0, 3.0, 4.0)
    r2 = rect(1.0, 2.0, 3.0, 4.0)
  check:
    r.x == 1.0
    r.y == 2.0
    r.width == 3.0
    r.height == 4.0
    r == r2

test "R2D.center":
  let r = testRect
  check:
    r.center() == v2d(55.0, 55.0)

test "R2D.collides":
  let
    r1 = testRect
    r2 = block:
      var res = testRect
      res.x += 20.0
      res.y += 20.0
      res
    r3 = rect(200.0, 20.0, 25.0, 25.0)
  check:
    r1.collides(r1)
    r1.collides(r2)
    r2.collides(r1)
    not r1.collides(r3)
    not r3.collides(r1)

test "R2D.contains":
  let p = v2d(11.0, 34.0)
  check:
    testRect.contains(p.x, p.y)
    not testRect.contains(0.0, 0.0)
    p in testRect
    V2D[float64].default notin testRect

test "R2D.isClipped":
  let viewport = testRect
  var r = testRect
  check not viewport.isClipped(r)
  r.x = 50.0
  r.y = 40.0
  # r is partially contained in the viewport
  check not viewport.isClipped(r)
  r.x = viewport.right + 10.0
  r.y = viewport.bottom + 12.0
  # r is completely outside of viewport
  check viewport.isClipped(r)
    
test "R2D.join":
  var r = testRect
  r.join(rect(0.0, 0.0, 10.0, 10.0))
  check:
    r.x == 0.0
    r.y == 0.0
    r.width == 100.0
    r.height == 100.0

# ========================================================================= T2D

test "T2D.`$`":
  skip()

test "T2D.t2d":
  skip()

test "T2D.move":
  skip()

test "T2D.rotate":
  skip()

test "T2D.scale":
  skip()

test "T2D.invfast":
  skip()

test "T2D.inverse":
  skip()

test "T2D.mult":
  skip()

test "T2D.decompose":
  skip()

# ======================================================================= Seg2D

test "Seg2D.`$`":
  skip()

test "Seg2D.seg2d":
  skip()

test "Seg2D.length":
  skip()

test "Seg2D.sqlength":
  skip()

test "Seg2D.eval":
  skip()

test "Seg2D.closestParam":
  skip()

test "Seg2D.sqdist":
  skip()

# ======================================================================= Cir2D

test "Cir2D.`$`":
  skip()

test "Cir2D.cir2d":
  skip()

test "Cir2D.minimum":
  skip()

test "Cir2D.area":
  skip()

test "Cir2D.isNull":
  skip()

# ======================================================================= Box2D

test "Box2D.`$`":
  skip()

test "Box2D.box2d":
  skip()

test "Box2D.center":
  skip()

test "Box2D.add":
  skip()

test "Box2D.merge":
  skip()

test "Box2D.segments":
  skip()

test "Box2D.area":
  skip()

test "Box2D.isNull":
  skip()

# ======================================================================= Obb2D

test "Obb2D.obb2d":
  skip()

test "Obb2D.update":
  skip()

test "Obb2D.move":
  skip()

test "Obb2D.transform":
  skip()

test "Obb2D.corners":
  skip()

test "Obb2D.width":
  skip()

test "Obb2D.height":
  skip()

test "Obb2D.angle":
  skip()

test "Obb2D.area":
  skip()

test "Obb2D.toBox":
  skip()

# ======================================================================= Tri2D

test "Tri2D.`$`":
  skip()

test "Tri2D.tri2d":
  skip()

test "Tri2D.transform":
  skip()

test "Tri2D.area":
  skip()

test "Tri2D.isCounterClockwise":
  skip()

test "Tri2D.centroid":
  skip()

# ======================================================================= Pol2D

test "Pol2D.pol2d":
  skip()

test "Pol2D.convexHull":
  skip()

test "Pol2D.transform":
  skip()

test "Pol2D.len":
  skip()

test "Pol2D.rawPoints":
  skip()

test "Pol2D.points":
  skip()

test "Pol2D.area":
  skip()

test "Pol2D.toBox":
  skip()

test "Pol2D.isCounterClockwise":
  skip()

test "Pol2D.centroid":
  skip()

test "Pol2D.visualCenter":
  skip()

test "Pol2D.triangles":
  skip()

test "Pol2D.convexPartition":
  skip()

# ======================================================================= Col2D

test "Col2D.PointPoint":
  skip()

test "Col2D.SegmentPoint":
  skip()

test "Col2D.SegmentSegment":
  skip()

test "Col2D.CirclePoint":
  skip()

test "Col2D.CircleSegment":
  skip()

test "Col2D.CircleCircle":
  skip()

test "Col2D.BoxPoint":
  skip()

test "Col2D.BoxSegment":
  skip()

test "Col2D.BoxCircle":
  skip()

test "Col2D.BoxBox":
  skip()

test "Col2D.ObbPoint":
  skip()    

test "Col2D.ObbSegment":
  skip()

test "Col2D.ObbCircle":
  skip()

test "Col2D.ObbBox":
  skip()

test "Col2D.ObbObb":
  skip()

test "Col2D.TriPoint":
  skip()

test "Col2D.TriSegment":
  skip()

test "Col2D.TriCircle":
  skip()

test "Col2D.TriBox":
  skip()

test "Col2D.TriObb":
  skip()

test "Col2D.TriTri":
  skip()

test "Col2D.PolyPoint":
  skip()

test "Col2D.PolySegment":
  skip()

test "Col2D.PolyCircle":
  skip()

test "Col2D.PolyBox":
  skip()

test "Col2D.PolyObb":
  skip()

test "Col2D.PolyTri":
  skip()

test "Col2D.PolyPoly":
  skip()
