##
## Application
## 
## Low-level bindings for the `osapp` library in the NAppGUI SDK.
##

import ../private/libnappgui
import sewer

# =============================================================================
{. push importc, header: "nappgui/osapp/osapp.hxx" .}

type
  FPtr_task_main* = proc(data: pointer): uint32 {.noconv.}
  FPtr_task_update* = proc(data: pointer) {.noconv.}
  FPtr_task_end* = proc(data: pointer, rvalue: uint32) {.noconv.}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/osapp/osapp.h" .}

proc osapp_finish*()
proc osapp_task_imp*(data: pointer, updtime: float32,
                     func_task_main: ptr FPtr_task_main,
                     func_task_update: ptr FPtr_task_update,
                     func_task_end: ptr FPtr_task_end)
proc osapp_menubar*(menu: ptr Menu, window: ptr Window)
proc osapp_open_url(url: cstring)

{. pop .} # ===================================================================
{. push importc, header: "nappgui/osapp/osmain.hxx" .}

type
  FPtr_app_create* = proc() {.noconv.}
  FPtr_app_update* = proc(app: pointer, prtime: float64, ctime: float64)

{. pop .} # ===================================================================
{. push importc, header: "nappgui/osapp/osmain.h" .}

proc osmain_imp*(argc: uint32, argv: cstringArray, instance: pointer,
                 lframe: float64, func_create: ptr FPtr_app_create,
                 func_update: ptr FPtr_app_update,
                 func_destroy: ptr FPtr_destroy,
                 options: cstring)

# NOTE: osmain and osmain_sync are C macros that implement a main function so
# a binding for those are not available as their use makes no sense in Nim code.

{. pop .} # ===================================================================