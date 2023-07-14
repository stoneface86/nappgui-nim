{.used.}

import nappgui/draw2d
import std/unittest


test "color.toHtml":
  var c = color(255, 0, 0)
  check c.toHtml() == "#FF0000"
  let 
    c2 = color(23, 23, 20)
    c2html = c2.toHtml()
  check color(c2html) == c2

test "color.alpha":
  var c = color(0, 0, 0, 0)
  check c.alpha == 0
  c.alpha = 23
  check c.alpha == 23

test "getInstalledFonts()":
  let fonts = getInstalledFonts()
  check fonts.len > 0

test "Font.`=copy`":
  let font = Font.init(DefaultFont.system, 12)
  let copy = font
  check font == copy