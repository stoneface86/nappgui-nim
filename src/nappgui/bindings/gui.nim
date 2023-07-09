##
## GUI
## 
## Low-level bindings for the `gui` library in the NAppGUI SDK.
## 


import ../private/libnappgui
import sewer, core, geom2d

# =============================================================================
{. push importc, header: "nappgui/gui/gui.hxx" .}
{. pragma: cenum, size: sizeof(cint) .}

type  
  gui_orient_t* {.cenum.} = enum
    ekGUI_HORIZONTAL
    ekGUI_VERTICAL

  gui_state_t* {.cenum.} = enum
    ekGUI_OFF
    ekGUI_ON
    ekGUI_MIXED
  
  gui_mouse_t* {.cenum.} = enum
    ekGUI_MOUSE_LEFT
    ekGUI_MOUSE_RIGHT
    ekGUI_MOUSE_MIDDLE

  gui_cursor_t* {.cenum.} = enum
    ekGUI_CURSOR_ARROW
    ekGUI_CURSOR_HAND
    ekGUI_CURSOR_IBEAM
    ekGUI_CURSOR_CROSS
    ekGUI_CURSOR_SIZEWE
    ekGUI_CURSOR_SIZENS
    ekGUI_CURSOR_USER

  gui_close_t* {.cenum.} = enum
    ekGUI_CLOSE_ESC
    ekGUI_CLOSE_INTRO
    ekGUI_CLOSE_BUTTON
    ekGUI_CLOSE_DEACT

  gui_scale_t* {.cenum.} = enum
    ekGUI_SCALE_AUTO
    ekGUI_SCALE_NONE
    ekGUI_SCALE_ASPECT
    ekGUI_SCALE_ASPECTDW
  
  gui_event_t* {.cenum.} = enum
    ekGUI_EVENT_LABEL
    ekGUI_EVENT_BUTTON
    ekGUI_EVENT_POPUP
    ekGUI_EVENT_LISTBOX
    ekGUI_EVENT_SLIDER
    ekGUI_EVENT_UPDOWN
    ekGUI_EVENT_TXTFILTER
    ekGUI_EVENT_TXTCHANGE
    ekGUI_EVENT_FOCUS
    ekGUI_EVENT_MENU
    ekGUI_EVENT_DRAW
    ekGUI_EVENT_RESIZE
    ekGUI_EVENT_ENTER
    ekGUI_EVENT_EXIT
    ekGUI_EVENT_MOVED
    ekGUI_EVENT_DOWN
    ekGUI_EVENT_UP
    ekGUI_EVENT_CLICK
    ekGUI_EVENT_DRAG
    ekGUI_EVENT_WHEEL
    ekGUI_EVENT_KEYDOWN
    ekGUI_EVENT_KEYUP
    ekGUI_EVENT_WND_MOVED
    ekGUI_EVENT_WND_SIZING
    ekGUI_EVENT_WND_SIZE
    ekGUI_EVENT_WND_CLOSE
    ekGUI_EVENT_COLOR
    ekGUI_EVENT_THEME
    ekGUI_EVENT_OBJCHANGE
    ekGUI_EVENT_TBL_NROWS
    ekGUI_EVENT_TBL_BEGIN
    ekGUI_EVENT_TBL_END
    ekGUI_EVENT_TBL_CELL
    ekGUI_EVENT_TBL_SEL
    ekGUI_EVENT_TBL_HEADCLICK

  gui_window_flag_t* {.cenum.} = enum
    ekWINDOW_FLAG
    ekWINDOW_EDGE
    ekWINDOW_TITLE
    ekWINDOW_MAX
    ekWINDOW_MIN
    ekWINDOW_CLOSE
    ekWINDOW_RESIZE
    ekWINDOW_RETURN
    ekWINDOW_ESC
    ekWINDOW_STD
    ekWINDOW_STDRES
  
  gui_notif_t* {. cenum .} = enum
    ekGUI_NOTIF_LANGUAGE = 1
    ekGUI_NOTIF_WIN_DESTROY
    ekGUI_NOTIF_MENU_DESTROY

  Control* = object
  Label* = object
  Button* = object
  PopUp* = object
  Edit* = object
  Combo* = object
  ListBox* = object
  UpDown* = object
  Slider* = object
  Progress* = object
  View* = object
  TextView* = object
  ImageView* = object
  TableView* = object
  SplitView* = object
  Layout* = object
  Cell* = object
  Panel* = object
  Window* = object
  Menu* = object
  MenuItem* = object
  
  EvButton* = object
    index*: uint32
    state*: gui_state_t
    text*: cstring
  
  EvSlider* = object
    pos*: float32
    incr*: float32
    step*: float32
  
  EvText* = object
    text*: cstring
    cpos*: uint32
  
  EvTextFilter* = object
    apply*: bool_t
    text*: cstring
    cpos*: uint32
  
  EvDraw* = object
    ctx*: ptr DCtx
    x*: float32
    y*: float32
    width*: float32
    height*: float32

  EvMouse* = object
    x*: float32
    y*: float32
    button*: gui_mouse_t
    count*: uint32

  EvWheel* = object
    x*: float32
    y*: float32
    dx*: float32
    dy*: float32
    dz*: float32

  EvKey* = object
    key*: vkey_t
  
  EvPos* = object
    x*: float32
    y*: float32

  EvSize* = object
    width*: float32
    height*: float32

  EvWinClose* = object
    origin*: gui_close_t

  EvMenu* = object
    index*: uint32
    state*: gui_state_t
    str*: cstring

  EvTbPos* = object
    col*: uint32
    row*: uint32

  EvTbRect* = object
    stcol*: uint32
    edcol*: uint32
    strow*: uint32
    edrow*: uint32

  EvTbSel* = object
    sel*: ptr Array[uint32_t]

  EvTbCell* = object

  FPtr_respack* = proc(locale: cstring): ptr ResPack {.noconv.}
  
{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/gui.h" .}

proc gui_start*()
proc gui_finish*()
proc gui_respack*(func_respack: ptr FPtr_respack)
proc gui_text*(id: ResId): cstring
proc gui_image*(id: ResId): ptr Image
proc gui_file*(id: ResId, size: ptr uint32_t): ptr byte_t
proc gui_dark_mode*(): bool_t
proc gui_alt_color*(light_color: color_t, dark_color: color_t): color_t
proc gui_label_color*(): color_t
proc gui_view_color*(): color_t
proc gui_line_color*(): color_t
proc gui_link_color*(): color_t
proc gui_border_color*(): color_t
proc gui_resolution*(): S2Df
proc gui_mouse_pos*(): V2Df
proc gui_update*()
proc gui_OnThemeChanged*(listener: ptr Listener)
proc gui_update_transitions*(prtime: real64_t, crtime: real64_t)
proc gui_OnNotification*(listener: ptr Listener)
template evbind_object*(e: ptr Event, Ty: typedesc): ptr Ty =
  block:
    var res: ptr Ty
    {. emit: [res, " = evbind_object(", e, ",", Ty, ");"] .}
    res
# template evbind_modify*(e: ptr Event, Ty: typedesc, member: untyped): bool_t =
#   block:
#     type mtype = typeof(Ty.member)
#     var res: bool_t
#     {. emit: [
#       res, "= evbind_modify(", 
#       e, ",", 
#       Ty, ",", 
#       mtype, 
#       &",{astToStr(member)});" ]
#     .}
#     res

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/label.h" .}

proc label_create*(): ptr Label
proc label_multiline*(): ptr Label
proc label_OnClick*(label: ptr Label, listener: ptr Listener)
proc label_text*(label: ptr Label, text: cstring)
proc label_font*(label: ptr Label, font: ptr Font)
proc label_style_over*(label: ptr Label, style: uint32_t)
proc label_align*(label: ptr Label, align: align_t)
proc label_color*(label: ptr Label, color: color_t)
proc label_color_over*(label: ptr Label, color: color_t)
proc label_bgcolor*(label: ptr Label, color: color_t)
proc label_bgcolor_over*(label: ptr Label, color: color_t)

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/button.h" .}

proc button_push*(): ptr Button
proc button_check*(): ptr Button
proc button_check3*(): ptr Button
proc button_radio*(): ptr Button
proc button_flat*(): ptr Button
proc button_flatgle*(): ptr Button
proc button_OnClick*(button: ptr Button, listener: ptr Listener)
proc button_text*(button: ptr Button, text: cstring)
proc button_text_alt*(button: ptr Button, text: cstring)
proc button_tooltip*(button: ptr Button, text: cstring)
proc button_font*(button: ptr Button, font: ptr Font)
proc button_image*(button: ptr Button, image: ptr Image)
proc button_image_alt*(button: ptr Button, image: ptr Image)
proc button_state*(button: ptr Button, state: gui_state_t)
proc button_get_state*(button: ptr Button): gui_state_t
proc button_tag*(button: ptr Button, tag: uint32_t)
proc button_get_tag*(button: ptr Button): uint32_t

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/popup.h" .}

proc popup_create*(): ptr PopUp
proc popup_OnSelect*(popup: ptr PopUp, listener: ptr Listener)
proc popup_tooltip*(popup: ptr PopUp, text: cstring)
proc popup_add_elem*(popup: ptr PopUp, text: cstring, image: ptr Image)
proc popup_set_elem*(popup: ptr PopUp, index: uint32_t,
                     text: cstring, image: ptr Image)
proc popup_clear*(popup: ptr PopUp)
proc popup_count*(popup: ptr PopUp): uint32_t
proc popup_list_height*(popup: ptr PopUp, elems: uint32_t)
proc popup_selected*(popup: ptr PopUp, index: uint32_t)
proc popup_get_selected*(popup: ptr PopUp): uint32_t

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/edit.h" .}

proc edit_create*(): ptr Edit
proc edit_multiline*(): ptr Edit
proc edit_OnFilter*(edit: ptr Edit, listener: ptr Listener)
proc edit_OnChange*(edit: ptr Edit, listener: ptr Listener)
proc edit_text*(edit: ptr Edit, text: cstring)
proc edit_font*(edit: ptr Edit, font: ptr Font)
proc edit_align*(edit: ptr Edit, align: align_t)
proc edit_passmode*(edit: ptr Edit, passmode: bool_t)
proc edit_editable*(edit: ptr Edit, is_editable: bool_t)
proc edit_autoselect*(edit: ptr Edit, autoselect: bool_t)
proc edit_tooltip*(edit: ptr Edit, text: cstring)
proc edit_color*(edit: ptr Edit, color: color_t)
proc edit_color_focus*(edit: ptr Edit, color: color_t)
proc edit_bgcolor*(edit: ptr Edit, color: color_t)
proc edit_bgcolor_focus*(edit: ptr Edit, color: color_t)
proc edit_phtext*(edit: ptr Edit, text: cstring)
proc edit_phcolor*(edit: ptr Edit, color: color_t)
proc edit_phstyle*(edit: ptr Edit, style: uint32_t)
proc edit_get_text*(edit: ptr Edit): cstring

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/combo.h" .}

proc combo_create*(): ptr Combo
proc combo_OnFilter*(combo: ptr Combo, listener: ptr Listener)
proc combo_OnChange*(combo: ptr Combo, Listener: ptr Listener)
proc combo_text*(combo: ptr Combo, text: cstring)
proc combo_align*(combo: ptr Combo, align: align_t)
proc combo_tooltip*(combo: ptr Combo, text: cstring)
proc combo_color*(combo: ptr Combo, color: color_t)
proc combo_color_focus*(combo: ptr Combo, color: color_t)
proc combo_bgcolor*(combo: ptr Combo, color: color_t)
proc combo_bgcolor_focus*(combo: ptr Combo, color: color_t)
proc combo_phtext*(combo: ptr Combo, text: cstring)
proc combo_phcolor*(combo: ptr Combo, color: color_t)
proc combo_phstyle*(combo: ptr Combo, style: uint32_t)
proc combo_get_text*(combo: ptr Combo): cstring
proc combo_count*(combo: ptr Combo): uint32_t
proc combo_add_elem*(combo: ptr Combo, text: cstring, image: ptr Image)
proc combo_set_elem*(combo: ptr Combo, index: uint32_t, text: cstring,
                     image: ptr Image)
proc combo_ins_elem*(combo: ptr Combo, index: uint32_t, text: cstring,
                     image: ptr Image)
proc combo_del_elem*(combo: ptr Combo, index: uint32_t)
proc combo_duplicates*(combo: ptr Combo, duplicates: bool_t)

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/listbox.h" .}

proc listbox_create*(): ptr ListBox
proc listbox_OnSelect*(listbox: ptr ListBox, listener: ptr Listener)
proc listbox_size*(listbox: ptr ListBox, size: S2Df)

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/updown.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/slider.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/progress.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/view.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/textview.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/imageview.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/tableview.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/splitview.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/layout.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/cell.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/panel.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/window.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/menu.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/menuitem.h" .}

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/comwin.h" .}

{. pop .} # ===================================================================
