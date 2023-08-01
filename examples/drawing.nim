##
## drawings example
## 
## Creates a bunch of images using the draw2d library. The generated images
## are written to examples/out. Each image showcases a feature of a the
## 2D Drawing library provided by NAppGUI.
##

import nappgui/[draw2d, geom2d]

import std/os

const
  outDir = currentSourcePath().parentDir() / "out"

  cGray = Color(0xFFAAAAAA)

proc saveAsImage(ctx: var DCtx, filename: string) =
  var img = ctx.toImage()
  createDir(outDir)
  let err = img.toFile(outDir / filename)
  if err != FError.ok:
    echo "Could not save image: ", err


proc exampleLines() =
  ## Demonstrates the line drawing functions
  ##
  var ctx = DCtx.init(830, 640, Pixformat.rgba32)
  ctx.clear(cGray)
  ctx.setLineColor(cBlack)
  
  var matrix = IdentityF

  block: # line thickness and cap style
    var x = 15.0f
    for (thickness, cap) in [
      (5.0f, LineCap.flat),
      (10.0f, LineCap.flat),
      (20.0f, LineCap.flat),
      (20.0f, LineCap.flat),
      (20.0f, LineCap.square),
      (20.0f, LineCap.round)
    ]:
      ctx.setLineWidth(thickness)
      ctx.setLineCap(cap)
      ctx.drawLine(x, 115, x + 100, 15)
      x += 130

  block: # line joining
    ctx.setLineCap(LineCap.flat)
    let zigzag = [
      v2d(0.0f, 100.0f),
      v2d(100.0f, 0.0f),
      v2d(140.0f, 100.0f),
      v2d(300.0f, 0.0f),
      v2d(340.0f, 100.0f),
      v2d(400.0f, 0.0f)
    ]
    matrix.move(matrix, 15, 150)
    ctx.setMatrix(matrix)
    ctx.drawLines(false, zigzag)
    
    matrix.move(matrix, 400, 0)
    ctx.setMatrix(matrix)
    ctx.setLineJoin(Linejoin.round)
    ctx.drawLines(false, zigzag)

    matrix.move(matrix, -400, 150)
    ctx.setMatrix(matrix)
    ctx.setLineJoin(Linejoin.bevel)
    ctx.drawLines(false, zigzag)

  # colors
  ctx.setLineWidth(10)
  ctx.setLineCap(LineCap.flat)
  ctx.setMatrix(IdentityF)
  block:
    var y = 300.0f
    for color in [cRed, cGreen, cBlue, cYellow, cCyan, cMagenta]:
      ctx.setLineColor(color)
      ctx.drawLine(430, y, 815, y)
      y += 20

  # dashes
  block:
    ctx.setLineColor(cBlack)
    ctx.setLineDash([5.0f, 5.0f, 10.0f, 5.0f])
    ctx.drawLine(15, 450, 815, 450)
    ctx.setLineDash([1.0f, 1.0f])
    ctx.drawLine(15, 470, 815, 470)
    ctx.setLineDash([2.0f, 1.0f])
    ctx.drawLine(15, 490, 815, 490)
    ctx.setLineWidth(5)
    ctx.setLineDash([1.0f, 2.0f])
    ctx.drawLine(15, 510, 815, 510)
    ctx.setLineWidth(1)
    ctx.setLineDash([5.0f, 5.0f, 10.0f, 5.0f])
    ctx.drawLine(15, 530, 815, 530)
    ctx.resetLineDash()
    ctx.drawLine(15, 550, 815, 550)

  saveAsImage(ctx, "drawing-lines.png")

proc exampleFigures() =
  let pentagon = [
    v2d(-65.0f, 0.0f),
    v2d(0.0f, -37.5f),
    v2d(65.0f, 0.0f),
    v2d(32.5f, 37.5f),
    v2d(-32.5f, 37.5f)
  ]
  var ctx = DCtx.init(830, 640, Pixformat.rgba32)
  ctx.clear(cGray)
  ctx.setLineColor(cBlack)
  ctx.setLineWidth(10)
  ctx.setFillColor(cBlue)
  var y = 10.0f
  for op in DrawOp:
    ctx.drawRect(op, 10, y, 110, 75)
    ctx.drawRoundedRect(op, 140, y, 110, 75, 20)
    ctx.drawCircle(op, 312, y + 40, 40)
    ctx.drawEllipse(op, 430, y + 40, 55, 37)
    var p = pentagon
    # translate the pentagon
    for point in p.mitems:
      point.x += 580
      point.y += y + 40
    ctx.drawPolygon(op, p)
    y += 100
  
  saveAsImage(ctx, "drawing-figures.png")

proc exampleGradients() =
  var ctx = DCtx.init(400, 400, Pixformat.rgba32)
  ctx.clear(cGray)
  # rainbow
  block:
    var colors: array[8, Color]
    var stops: array[8, float32]
    const factor = 1.0f / 7
    for (i, color) in colors.mpairs:
      let stop = i.float32 * factor
      stops[i] = stop
      color = color(stop, 1.0f, 1.0f)
    ctx.setGradientFill(colors, stops, 10, 0, 390, 0)
    ctx.drawRect(DrawOp.fill, 10, 10, 380, 50)
  
  let 
    colors = [cRed, cBlue]
    stops = [0.0f, 1.0f]

  # top to bottom
  ctx.setGradientFill(colors, stops, 10, 70, 10, 225)
  ctx.drawRect(DrawOp.fill, 10, 70, 185, 155)

  # left to right 
  ctx.setGradientFill(colors, stops, 205, 70, 390, 70)
  ctx.drawRect(DrawOp.fill, 205, 70, 185, 155)

  # top-left to bottom-right
  ctx.setGradientFill(colors, stops, 10, 235, 195, 390)
  ctx.drawRect(DrawOp.fill, 10, 235, 185, 155)

  # go back to solid color fill
  ctx.setFillColor(cMagenta)
  ctx.drawRect(DrawOp.fill, 205, 235, 185, 155)

  saveAsImage(ctx, "drawing-gradients.png")

proc exampleFillwrap() =
  var ctx = DCtx.init(800, 450, Pixformat.rgba32)
  ctx.clear(cGray)

  ctx.setLineColor(cBlack)
  ctx.setLineWidth(2)
  let
    colors = [cMagenta, cCyan]
    stops = [0.0f, 1.0f]
  
  ctx.setGradientFill(colors, stops, 200, 0, 400, 0)
  ctx.setFillWrap(FillWrap.clamp)
  ctx.drawRect(DrawOp.fillStroke, 15, 100, 570, 100)
  ctx.setFillWrap(FillWrap.tile)
  ctx.drawRect(DrawOp.fillStroke, 15, 215, 570, 100)
  ctx.setFillWrap(FillWrap.flip)
  ctx.drawRect(DrawOp.fillStroke, 15, 330, 570, 100)
  
  ctx.drawLine(200, 90, 200, 440)
  ctx.drawLine(400, 90, 400, 440)

  let font = Font.init(DefaultFont.system, 24)
  ctx.setFont(font)
  ctx.setTextAlign(HAlign.left, VAlign.center)
  ctx.drawText("Fillwrap.clamp", 600, 150)
  ctx.drawText("Fillwrap.tile", 600, 265)
  ctx.drawText("Fillwrap.flip", 600, 380)

  ctx.setTextAlign(HAlign.left, VAlign.top)
  ctx.drawText("Gradient FillWrap example", 15, 15)

  saveAsImage(ctx, "drawing-gradients-fillwrap.png")

proc exampleText() =
  var ctx = DCtx.init(400, 400, Pixformat.rgba32)
  ctx.clear(cGray)

  let font = Font.init(DefaultFont.system, 20)
  ctx.setFont(font)
  ctx.setTextColor(cBlue)
  ctx.setTextAlign(HAlign.left, VAlign.top)
  ctx.drawText("Text 文本 Κείμενο", 25, 25)


  saveAsImage(ctx, "drawing-text.png")

proc main() =
  draw2dStart()
  
  exampleLines()
  exampleFigures()
  exampleGradients()
  exampleFillwrap()
  exampleText()

  draw2dFinish()
  

main()
