
import nappgui/bindings/[core, sewer]

import std/unittest

test "array":
  var arr = array_create[int](sizeof(int).uint16, $int)
  check arr != nil
  block:
    let elem = cast[ptr int](array_insert(arr, 0, 1))
    elem[] = 1
  check array_size(arr) == 1
  array_destroy(arr.addr, nil, $int)
  check arr == nil

test "string array":
  var arr = array_create[ptr String](sizeof(pointer).uint16, $(ptr String))
  block:
    let elem = cast[ptr ptr String](array_insert(arr, 0, 1))
    elem[] = str_c("foo")
  check str_find(arr, "foo") == 0
  array_destroy_ptr(arr.addr, cast[FPtr_destroy](str_destroy), $(ptr String))