
import ../bindings/sewer

# macro fdispatch2*[T: SomeFloat](fun32: untyped, fun64: untyped, args: varargs[untyped]) =
#   let fname = when T is float32: bindsym(fun32) else: bindsym(fun64)
#   result = quote do:
#     `fname`(`args`)



# macro genDestroy*(T: typedesc, destroyFunc) =
#   result = quote do:
#     proc `=destroy`*(x: var `T`) =
#       if x.impl != nil:
#         `destroy`(x.impl.addr)

# macro genMoveSemantics*(T: typedesc, destroy) =
#   result = quote do:
#     proc `=destroy`*(x: var `T`) =
#       if x.impl != nil:
#         `destroy`(x.impl.addr)
#     proc `=copy`*(x: var T, y: T) {.error.}
#     proc `=sink`*(x: var T, y: T) =
#       `=destroy`(x)
#       wasMoved(x)
#       x.impl = y.impl

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