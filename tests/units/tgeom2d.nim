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
  check $Identity == "t2d(v2d(1.0, 0.0), v2d(0.0, 1.0), v2d(0.0, 0.0))"

test "T2D.t2d":
  check:
    Identity == t2d(IdentityF)
    IdentityF == t2d(Identity)
  let t = t2d(1.0, 2.0, 3.0, 4.0, 5.0, 6.0)
  check:
    t.i.x == 1.0
    t.i.y == 2.0
    t.j.x == 3.0
    t.j.y == 4.0
    t.p.x == 5.0
    t.p.y == 6.0

test "T2D.move":
  var t = Identity
  t.move(2.0, 3.0)
  check t.p == v2d(2.0, 3.0)

test "T2D.rotate":
  var t = IdentityF
  t.rotate(1.0f)
  check t != IdentityF

test "T2D.scale":
  var t = Identity
  t.scale(2.0, 2.0)
  check:
    t.i.x == 2.0
    t.j.y == 2.0

test "T2D.invfast":
  var 
    t = Identity
    tinv: t.typeOf
  t.move(1.5, 2.25)
  t.rotate(3)
  tinv.invfast(t)
  # t * tinv should be equal to Identity

test "T2D.inverse":
  var 
    t = Identity
    tinv: t.typeOf
  t.move(1.5, 2.25)
  t.rotate(3)
  t.scale(1.25, 3.0)
  tinv.inverse(t)
  # t * tinv should be approx. equal to Identity

test "T2D.multMatrix":
  var t = IdentityF
  t.move(1.0f, 0.0f)
  t.rotate(-2)
  check:
    t * IdentityF == t

test "T2D.multVector":
  var t = Identity
  t.move(1.0, 1.0)
  t.scale(2.0, 1.0)
  let v = t * v2d(1.0, 1.0)
  check:
    v.x == 3.0
    v.y == 2.0

test "T2D.decompose":
  var t = t2d[float64]()
  t.move(-1.0, 5.0)
  t.scale(1.5, 1.0)
  t.rotate(-3.0)
  let decomp = t.decompose()
  check:
    decomp.pos.x in   -1.1 .. -0.9
    decomp.pos.y in    4.9 ..  5.1
    decomp.angle in   -3.1 .. -2.9
    decomp.scale.x in  1.4 ..  1.6
    decomp.scale.y in  0.9 ..  1.1

# ======================================================================= Seg2D

const testSeg = seg2d(1.0, 1.0, 10.0, 10.0)

test "Seg2D.`$`":
  check $testSeg == "seg2d(1.0, 1.0, 10.0, 10.0)"

test "Seg2D.seg2d":
  # testSeg was initialized by seg2d
  check:
    testSeg.p0 == v2d(1.0, 1.0)
    testSeg.p1 == v2d(10.0, 10.0)

test "Seg2D.length":
  # length of testSeg is 12.72792206
  check testSeg.length() in 12.6 .. 12.8

test "Seg2D.sqlength":
  # 9^2 + 9^2 = 162
  check testSeg.sqlength() == 162.0

test "Seg2D.eval":
  check:
    testSeg.eval(0.0) == v2d(1.0, 1.0)
    testSeg.eval(1.0) == v2d(10.0, 10.0)

test "Seg2D.closestParam":
  check testSeg.closestParam(v2d(100.0, -2.0)) in 0.0 .. 1.0

test "Seg2D.sqdist":
  block:
    let res = testSeg.sqdist(v2d(3.0, 5.0))
    check:
      res.dist >= 0.0
      res.t in 0.0 .. 1.0
  block:
    let res = testSeg.sqdist(seg2d(0.0, 0.0, 1.0, 1.0))
    check:
      res.dist >= 0.0
      res.t1 in 0.0 .. 1.0
      res.t2 in 0.0 .. 1.0


# ======================================================================= Cir2D

const testCircle = cir2d(2.0, 4.0, 5.0)

test "Cir2D.`$`":
  check $testCircle == "cir2d(2.0, 4.0, 5.0)"

test "Cir2D.cir2d":
  check:
    testCircle.c.x == 2.0
    testCircle.c.y == 4.0
    testCircle.r == 5.0

test "Cir2D.minimum":
  let cir = minimum([
    point(1.0, 0.0),
    point(0.0, 2.0),
    point(-3.0, 0.0),
    point(0.0, -2.0)
  ])
  check not cir.isNull()

test "Cir2D.area":
  check testCircle.area >= 0.0

test "Cir2D.isNull":
  check not testCircle.isNull()

# ======================================================================= Box2D

const testBox = box2d(2.0, 2.0, 10.0, 15.0)

test "Box2D.`$`":
  check $testBox == "box2d(2.0, 2.0, 10.0, 15.0)"

test "Box2D.box2d":
  check:
    testBox.min.x == 2.0
    testBox.min.y == 2.0
    testBox.max.x == 10.0
    testBox.max.y == 15.0
  # rect conversion
  check box2d(rect(2.0, 2.0, 8.0, 13.0)) == testBox

test "Box2D.center":
  check testBox.center() == point(6.0, 8.5)

test "Box2D.add":
  var b = testBox
  b.add(point(0.0, 0.0))
  check b.min == point(0.0, 0.0)

test "Box2D.merge":
  var b = testBox
  b.merge(box2d(9.0, 14.0, 20.0, 20.0))
  check b == box2d(2.0, 2.0, 20.0, 20.0)

test "Box2D.segments":
  let segments = testBox.segments()
  check:
    segments[0] == seg2d(2.0, 2.0, 10.0, 2.0)
    segments[1] == seg2d(10.0, 2.0, 10.0, 15.0)
    segments[2] == seg2d(10.0, 15.0, 2.0, 15.0)
    segments[3] == seg2d(2.0, 15.0, 2.0, 2.0)

test "Box2D.area":
  check testBox.area() == 104.0

test "Box2D.isNull":
  check not testBox.isNull()

# ======================================================================= Obb2D

test "Obb2D.obb2d":
  block:
    let obb = obb2d(point(0.0, 0.0), 100.0, 100.0, 0.0)
    check obb.impl != nil
  block:
    let obb = obb2d(point(0.0, 0.0), point(1.0, 1.0), 4.0)
    check obb.impl != nil
  block:
    let obb = obb2d([
      point(1.0, 1.0),
      point(-1.0, 1.0),
      point(-1.0, -1.0),
      point(1.0, -1.0)
    ])
    check obb.impl != nil

test "Obb2D.update":
  var obb = obb2d(point(1.0, 1.0), 10.0, 20.0, 0.0)
  obb.update(point(0.0, 0.0), 12.0, 25.0, 1.0)
  check:
    obb.center() == point(0.0, 0.0)
    obb.width() == 12.0
    obb.height() == 25.0
    obb.angle() == 1.0

test "Obb2D.move":
  const
    origin = point(-1.0f, 1.0f)
    newOrigin = point(1.0f, -1.0f)
  var obb = obb2d(origin, 1.0f, 1.0f, 0.0f)
  obb.move(newOrigin.x - origin.x, newOrigin.y - origin.y)
  check:
    obb.center() == newOrigin

test "Obb2D.transform":
  var t = Identity
  t.move(1.0, 2.0)
  var obb = obb2d(point(0.0, 0.0), 1.0, 1.0, 0.0)
  obb.transform(t)
  check obb.center() == point(1.0, 2.0)

test "Obb2D.corners":
  let obb = obb2d(point(0.0, 0.0), 2.0, 2.0, 0.0)
  let corners = obb.corners()
  check:
    corners[0] == point(-1.0, -1.0)
    corners[1] == point(1.0, -1.0)
    corners[2] == point(1.0, 1.0)
    corners[3] == point(-1.0, 1.0)

test "Obb2D.area":
  let obb = obb2d(point(0.0, 0.0), 3.0, 2.0, 0.0)
  check obb.area() == 6.0

test "Obb2D.toBox":
  let obb = obb2d(point(0.0, 0.0), 2.0, 2.0, 0.0)
  check obb.toBox() == box2d(-1.0, -1.0, 1.0, 1.0)

# ======================================================================= Tri2D

const testTri = tri2d(-2.0, -1.0, 0.0, 1.0, 2.0, -1.0)

test "Tri2D.`$`":
  check $testTri == "tri2d(-2.0, -1.0, 0.0, 1.0, 2.0, -1.0)"

test "Tri2D.tri2d":
  check:
    testTri.p0 == point(-2.0, -1.0)
    testTri.p1 == point(0.0, 1.0)
    testTri.p2 == point(2.0, -1.0)

test "Tri2D.transform":
  var t = Identity
  t.move(-1.0, 1.0)
  var tri = testTri
  tri.transform(t)
  check:
    tri.p0 == point(-3.0, 0.0)
    tri.p1 == point(-1.0, 2.0)
    tri.p2 == point(1.0, 0.0)

test "Tri2D.area":
  check testTri.area() == 4.0

test "Tri2D.isCounterClockwise":
  check testTri.isClockwise()

test "Tri2D.centroid":
  discard testTri.centroid()

# ======================================================================= Pol2D

const testPolygonPoints = [
    point(0.0, 1.0),
    point(0.0, 0.0),
    point(1.0, 0.0)
  ]

func getTestPolygon(): Pol2D[float64] =
  result = pol2d(testPolygonPoints)

test "Pol2D.pol2d":
  let p = getTestPolygon()
  check p.impl != nil

test "Pol2D.convexHull":
  skip()

test "Pol2D.transform":
  var p = getTestPolygon()
  var t = Identity
  t.scale(1.0, 2.0)
  p.transform(t)

test "Pol2D.len":
  var p = getTestPolygon()
  check p.len() == 3

test "Pol2D.rawPoints":
  let p = getTestPolygon()
  let points = p.rawPoints()
  check:
    points[][0] == testPolygonPoints[0]
    points[][1] == testPolygonPoints[1]
    points[][2] == testPolygonPoints[2]

test "Pol2D.points":
  let p = getTestPolygon()
  let points = p.points()
  check points == testPolygonPoints

test "Pol2D.area":
  let p = getTestPolygon()
  check p.area() == 0.5

test "Pol2D.toBox":
  let p = getTestPolygon()
  check p.toBox() == box2d(0.0, 0.0, 1.0, 1.0)

test "Pol2D.isCounterClockwise":
  let p = getTestPolygon()
  check p.isCounterClockwise()

test "Pol2D.centroid":
  let p = getTestPolygon()
  let c = p.centroid()
  check:
    c.x in 0.0 .. 1.0
    c.y in 0.0 .. 1.0

test "Pol2D.visualCenter":
  let p = getTestPolygon()
  let c = p.visualCenter(1.0)
  check:
    c.x in 0.0 .. 1.0
    c.y in 0.0 .. 1.0

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
