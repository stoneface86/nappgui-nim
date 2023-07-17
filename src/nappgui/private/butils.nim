
import ../bindings/sewer

template fdispatch*[T: SomeFloat](fun32: untyped, fun64: untyped, args: varargs[untyped]): auto =
  when T is float32:
    fun32(args)
  else:
    fun64(args)

template getPtr*[T](x: T): ptr T =
  # gets the address of x if x has one. If x does not have an address, then
  # a variable is made with the value of x and that address is given.
  when compiles(x.unsafeAddr):
    x.unsafeAddr
  else:
    var copy = x
    copy.addr

template toBool*(b: bool_t): bool =
  b == TRUE