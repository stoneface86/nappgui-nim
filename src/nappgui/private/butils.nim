
import ../bindings/sewer

template fdispatch*[T: SomeFloat](fun32: untyped, fun64: untyped, args: varargs[untyped]): auto =
  ## Calls `fun32` with `args` when `T` is `float32`, otherwise calls `fun64`.
  ##
  when T is float32:
    fun32(args)
  else:
    fun64(args)

template fcast*[T: SomeFloat](x: untyped, ty32: untyped, ty64: untyped): auto =
  ## Cast `x` as `ty32` when `T` is `float32`, otherwise cast it as `ty64`.
  ##
  when T is float32:
    cast[ty32](x)
  else:
    cast[ty64](x)

template fget*[F, D](x: F|D): typedesc[SomeFloat] =
  ## Get `float32` when x is `F`, `float64` when x is `D`
  ##
  when x is F:
    float32
  else:
    float64

template getPtr*[T](x: ptr T): ptr T = x
  ## Gets `x`. Only useful in generic functions/templates.
  ##

template getPtr*[T: not ptr](x: T): ptr T =
  ## gets the address of x if x has one. If x does not have an address, then
  ## a variable is made with the value of x and that address is given.
  ##
  when compiles(x.unsafeAddr):
    x.unsafeAddr
  else:
    var copy = x
    copy.addr

template toBool*(b: bool_t): bool =
  ## Converts an nappgui bool to a nim bool
  ##
  b == TRUE

template castEnum*[E: enum](src: E, D: typedesc[enum]): D =
  block:
    static:
      assert E.low.ord == D.low.ord
      assert E.high.ord == D.high.ord
    D(src.ord)
