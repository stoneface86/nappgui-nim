
import bindings/core as bcore
import bindings/sewer as bsewer

type
  KeyBuf* = object
    ## Keyboard buffer. Stores the state of a keyboard's button presses.
    impl: ptr bcore.KeyBuf

  Key* = enum
    ## Keyboard keys
    kUndef, kA, kS, kD, kF, kH, kG, kZ, kX, kC, kV, kBSlash, kB, kQ, kW, kE,
    kR, kY, kT, k1, k2, k3, k4, k6, k5, k9, k7, k8, k0, kRCurly, kO, kU,
    kLCurly, kI, kP, kReturn, kL, kJ, kSemicolon, kK, kQuest, kComma, kMinus,
    kN, kM, kPeriod, kTab, kSpace, kGtlt, kBack, kEsc, kF17, kNumDecimal,
    kNumMult, kNumAdd, kNumLock, kNumDiv, kNumRet, kNumMinus, kF18, kF19,
    kNumEqual, kNum0, kNum1, kNum2, kNum3, kNum4, kNum5, kNum6, kNum7, kNum8,
    kNum9, kF5, kF6, kF7, kF3, kF8, kF9, kF11, kF13, kF16, kF14, kF10, kF12,
    kPageUp, kHome, kSupr, kF4, kPageDown, kF2, kEnd, kF1, kLeft, kRight,
    kDown, kUp, kLShift, kRShift, kLCtrl, kRCtrl, kLAlt, kRAlt, kIns, kExclaim,
    kMenu, kLWin, kRWin, kCaps, kTilde, kGrave, kPlus

  Event* = distinct ptr bcore.Event
  EventHandler*[T] = proc(recv: T, evt: Event)
    ## Event handler proc. An event handler is a proc that takes a ref/ptr to
    ## some data type, which is known as the event's receiver, and an event
    ## object which contains information about the event that occurred.
    ## 
  
  Listener*[T: ptr|ref] = object
    impl*: ptr bcore.Listener

template toVoidPtr[T: ptr|ref](obj: T): pointer =
  cast[pointer](recv)

template fromVoidPtr[T: ptr|ref](obj: pointer): T =
  cast[T](recv)

template to_vkey_t(k: Key): bcore.vkey_t =
  k.ord.vkey_t

template toBool(b: bsewer.bool_t): bool =
  (b == bsewer.TRUE)

# Listener[T] / event handling ================================================

template toImpl(e: Event): ptr bcore.Event =
  cast[ptr bcore.Event](e)

proc `=destroy`*[T](l: var Listener[T]) =
  if l.impl != nil:
    bcore.listener_destroy(l.impl.addr)
proc `=copy`*[T](d: var Listener[T], s: Listener[T]) {.error.}
proc `=sink`*[T](d: var Listener[T], s: Listener[T]) =
  `=destroy`(d)
  wasMoved(d)
  d.impl = s.impl

proc listener*[T](recv: T, handler: static[EventHandler[T]]): Listener[T] =
  proc wrapper(recv: pointer, evt: ptr bcore.Event) {.noconv.} =
    handler(fromVoidPtr[T](recv), evt.Event)
  result.impl = bcore.listener_imp(
    toVoidPtr(recv), 
    cast[ptr bcore.FPtr_event_handler](wrapper)
  )

proc send*[T, S, P, R](
  l: var Listener[T],
  eventType: uint32,
  sender: S,
  params: P,
  result: R
) =
  ## Transmit an event from sender to receiver. 
  bcore.listener_event_imp(
    l.impl, eventType, sender.toVoidPtr, params.toVoidPtr, result.toVoidPtr,
    $S, $P, $R    
  )

proc pass*[T, S](l: var Listener[T], evt: Event, sender: S) =
  bcore.listener_pass_event_imp(l.impl, evt.toImpl, sender.toVoidPtr, $S)

proc code*(e: Event): uint32 =
  result = bcore.event_type(e.toImpl)

proc sender*(e: Event, S: typedesc): S =
  ## Get the event's sender, with the sender's type being `S`
  ## 
  fromVoidPtr[S](bcore.event_sender_imp(e.toImpl, $S))

proc params*(e: Event, P: typedesc): P =
  ## Get the event's parameters, with the parameter's type being `P`.
  ## 
  fromVoidPtr[P](bcore.event_params_imp(e.toImpl, $P))

proc result*(e: Event, R: typedesc): R =
  fromVoidPtr[R](bcore.event_result_imp(e.toImpl, $R))

type
  Foo = object
    counter: int

proc onClick(f: ptr Foo, evt: Event) =
  inc f[].counter

var foo: Foo
let l = listener(foo.addr, onClick)

# KeyBuf ======================================================================

proc `=destroy`*(b: var KeyBuf) =
  if b.impl != nil:
    bcore.keybuf_destroy(b.impl.addr)
proc `=copy`*(dest: var KeyBuf, src: KeyBuf) {.error.}
proc `=sink`*(dest: var KeyBuf, src: KeyBuf) =
  `=destroy`(dest)
  wasMoved(dest)
  dest.impl = src.impl


proc init*(T: typedesc[KeyBuf]): KeyBuf =
  ## Creates a new, empty KeyBuf.
  ## 
  KeyBuf(impl: bcore.keybuf_create())

proc clear*(k: var KeyBuf) =
  ## Clears the keyboard buffer. All keys are set as released.
  ## 
  bcore.keybuf_clear(k.impl)

proc setUp*(k: var KeyBuf, key: Key) =
  ## Sets the state of the given key to up, or released.
  ## 
  bcore.keybuf_OnUp(k.impl, key.to_vkey_t)

proc setDown*(k: var KeyBuf, key: Key) =
  ## Sets the state of the given key to down, or pressed.
  ## 
  bcore.keybuf_OnDown(k.impl, key.to_vkey_t)

func isPressed*(k: KeyBuf, key: Key): bool =
  ## Returns `true` if the state of `key` is down, `false` otherwise.
  ## 
  bcore.keybuf_pressed(k.impl, key.to_vkey_t).toBool

func toString*(key: Key): string =
  ## Returns a text representation of the given `key`.
  ## 
  result.add bcore.keybuf_str(key.to_vkey_t)