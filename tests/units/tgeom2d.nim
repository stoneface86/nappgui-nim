{.used.}

import nappgui/geom2d

import std/unittest

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

test "V2D.mid":
  let p = mid(v2d(-1.0, -1.0), v2d(1.0, 1.0))
  check:
    p.x == 0.0
    p.y == 0.0

test "S2D.s2d":
  let sz = s2d(100.0, 200.0)
  check:
    sz.width == 100.0
    sz.height == 200.0

test "S2D.`$`":
  var sz: S2D[float32]
  check $sz == "s2d(0.0, 0.0)"