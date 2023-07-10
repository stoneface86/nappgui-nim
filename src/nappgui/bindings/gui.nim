##
## GUI
## 
## Low-level bindings for the `gui` library in the NAppGUI SDK.
## 

import ../private/libnappgui
import sewer, core, geom2d, draw2d

# =============================================================================
{. push header: "nappgui/gui/gui.hxx" .}
{. pragma: cenum, importc, size: sizeof(cint) .}

# gui types

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

  Control* {.importc.}    = object
  Label* {.importc.}      = object
  Button* {.importc.}     = object
  PopUp* {.importc.}      = object
  Edit* {.importc.}       = object
  Combo* {.importc.}      = object
  ListBox* {.importc.}    = object
  UpDown* {.importc.}     = object
  Slider* {.importc.}     = object
  Progress* {.importc.}   = object
  View* {.importc.}       = object
  TextView* {.importc.}   = object
  ImageView* {.importc.}  = object
  TableView* {.importc.}  = object
  SplitView* {.importc.}  = object
  Layout* {.importc.}     = object
  Cell* {.importc.}       = object
  Panel* {.importc.}      = object
  Window* {.importc.}     = object
  Menu* {.importc.}       = object
  MenuItem* {.importc.}   = object
  
  EvButton* {.importc.} = object
    index*: uint32
    state*: gui_state_t
    text*: cstring
  
  EvSlider* {.importc.} = object
    pos*: float32
    incr*: float32
    step*: float32
  
  EvText* {.importc.} = object
    text*: cstring
    cpos*: uint32
  
  EvTextFilter* {.importc.} = object
    apply*: bool_t
    text*: cstring
    cpos*: uint32
  
  EvDraw* {.importc.} = object
    ctx*: ptr DCtx
    x*: float32
    y*: float32
    width*: float32
    height*: float32

  EvMouse* {.importc.} = object
    x*: float32
    y*: float32
    button*: gui_mouse_t
    count*: uint32

  EvWheel* {.importc.} = object
    x*: float32
    y*: float32
    dx*: float32
    dy*: float32
    dz*: float32

  EvKey* {.importc.} = object
    key*: vkey_t
  
  EvPos* {.importc.} = object
    x*: float32
    y*: float32

  EvSize* {.importc.} = object
    width*: float32
    height*: float32

  EvWinClose* {.importc.} = object
    origin*: gui_close_t

  EvMenu* {.importc.} = object
    index*: uint32
    state*: gui_state_t
    str*: cstring

  EvTbPos* {.importc.} = object
    col*: uint32
    row*: uint32

  EvTbRect* {.importc.} = object
    stcol*: uint32
    edcol*: uint32
    strow*: uint32
    edrow*: uint32

  EvTbSel* {.importc.} = object
    sel*: ptr Array[uint32_t]

  EvTbCell* {.importc.} = object

  FPtr_respack* {.importc.} = proc(locale: cstring): ptr ResPack {.noconv.}
  
{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/gui/gui.h" .}

# Gui

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
proc evbind_object_imp*(e: ptr Event, ty: cstring): pointer
proc evbind_modify_imp*(e: ptr Event,  ty: cstring, size: uint16_t,
                        mname: cstring, mty: cstring, moffset: uint16_t,
                        msize: uint16_t): bool_t

{. pop .} # ===================================================================
{. push importc, noconv, header: "nappgui/gui/label.h" .}

# Label

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
{. push importc, noconv, header: "nappgui/gui/button.h" .}

# Button

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
{. push importc, noconv, header: "nappgui/gui/popup.h" .}

# PopUp

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
{. push importc, noconv, header: "nappgui/gui/edit.h" .}

# Edit

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
{. push importc, noconv, header: "nappgui/gui/combo.h" .}

# Combo

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
{. push importc, noconv, header: "nappgui/gui/listbox.h" .}

# ListBox

proc listbox_create*(): ptr ListBox
proc listbox_OnSelect*(listbox: ptr ListBox, listener: ptr Listener)
proc listbox_size*(listbox: ptr ListBox, size: S2Df)
proc listbox_checkbox*(listbox: ptr ListBox, show: bool_t)
proc listbox_multisel*(listbox: ptr ListBox, multiset: bool_t)
proc listbox_add_elem*(listbox: ptr ListBox, text: cstring, image: ptr Image)
proc listbox_set_elem*(listbox: ptr ListBox, index: uint32_t, text: cstring,
                       image: ptr Image)
proc listbox_clear*(listbox: ptr ListBox)
proc listbox_color*(listbox: ptr ListBox, index: uint32_t, color: color_t)
proc listbox_select*(listbox: ptr ListBox, index: uint32_t, select: bool_t)
proc listbox_check*(listbox: ptr ListBox, index: uint32_t, check: bool_t)
proc listbox_count*(listbox: ptr ListBox): uint32_t
proc listbox_text*(listbox: ptr ListBox, index: uint32_t): cstring
proc listbox_selected*(listbox: ptr ListBox, index: uint32_t): bool_t
proc listbox_checked*(listbox: ptr ListBox, index: uint32_t): bool_t


{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/updown.h" .}

# UpDown

proc updown_create*(): ptr UpDown
proc updown_OnClick*(updown: ptr UpDown, listener: ptr Listener)
proc updown_tooltip*(updown: ptr UpDown, text: cstring)

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/slider.h" .}

# Slider

proc slider_create*(): ptr Slider
proc slider_vertical*(): ptr Slider
proc slider_OnMoved*(slider: ptr Slider, listener: ptr Listener)
proc slider_tooltip*(slider: ptr Slider, text: cstring)
proc slider_steps*(slider: ptr Slider, steps: uint32_t)
proc slider_value*(slider: ptr Slider, value: real32_t)
proc slider_get_value*(slider: ptr Slider): real32_t

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/progress.h" .}

# Progress

proc progress_create*(): ptr Progress
proc progress_undefined*(progress: ptr Progress, running: bool_t)
proc progress_value*(progress: ptr Progress, value: real32_t)

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/view.h" .}

# View

proc view_create*(): ptr View
proc view_scroll*(): ptr View
proc view_data_imp*(view: ptr View, data: ptr pointer, destroy: FPtr_destroy)
proc view_get_data_imp*(view: ptr View): pointer
proc view_size*(view: ptr View, size: S2Df)
proc view_OnDraw*(view: ptr View, listener: ptr Listener)
proc view_OnOverlay*(view: ptr View, listener: ptr Listener)
proc view_OnSize*(view: ptr View, listener: ptr Listener)
proc view_OnEnter*(view: ptr View, listener: ptr Listener)
proc view_OnExit*(view: ptr View, listener: ptr Listener)
proc view_OnMove*(view: ptr View, listener: ptr Listener)
proc view_OnDown*(view: ptr View, listener: ptr Listener)
proc view_OnUp*(view: ptr View, listener: ptr Listener)
proc view_OnClick*(view: ptr View, listener: ptr Listener)
proc view_OnDrag*(view: ptr View, listener: ptr Listener)
proc view_OnWheel*(view: ptr View, listener: ptr Listener)
proc view_OnKeyDown*(view: ptr View, listener: ptr Listener)
proc view_OnKeyUp*(view: ptr View, listener: ptr Listener)
proc view_OnFocus*(view: ptr View, listener: ptr Listener)
proc view_keybuf*(view: ptr View, buffer: ptr KeyBuf)
proc view_get_size*(view: ptr View, size: ptr S2Df)
proc view_content_size*(view: ptr View, size: S2Df, line: S2Df)
proc view_scroll_x*(view: ptr View, pos: real32_t)
proc view_scroll_y*(view: ptr View, pos: real32_t)
proc view_scroll_size*(view: ptr View, width: ptr real32_t,
                       height: ptr real32_t)
proc view_viewport*(view: ptr View, pos: ptr V2Df, size: ptr S2Df)
proc view_point_scale*(view: ptr View, scale: ptr real32_t)
proc view_update*(view: ptr View)
proc view_native*(view: ptr View): pointer

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/textview.h" .}

# TextView

proc textview_create*(): ptr TextView
proc textview_size*(view: ptr TextView, size: S2Df)
proc textview_clear*(view: ptr TextView)
proc textview_printf*(view: ptr TextView, fmt: cstring): uint32_t {.varargs.}
proc textview_writef*(view: ptr TextView, text: cstring)
proc textview_rtf*(view: ptr TextView, rtfIn: ptr Stream)
proc textview_units*(view: ptr TextView, units: uint32_t)
proc textview_family*(view: ptr TextView, family: cstring)
proc textview_fsize*(view: ptr TextView, size: real32_t)
proc textview_fstyle*(view: ptr TextView, fstyle: uint32_t)
proc textview_color*(view: ptr TextView, color: color_t)
proc textview_bgcolor*(view: ptr TextView, color: color_t)
proc textview_pgcolor*(view: ptr TextView, color: color_t)
proc textview_halign*(view: ptr TextView, align: align_t)
proc textview_lspacing*(view: ptr TextView, scale: real32_t)
proc textview_bfspace*(view: ptr TextView, space: real32_t)
proc textview_afspace*(view: ptr TextView, space: real32_t)
proc textview_scroll_down*(view: ptr TextView)
proc textview_editable*(view: ptr TextView, isEditable: bool_t)

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/imageview.h" .}

# ImageView

proc imageview_create*(): ptr ImageView
proc imageview_size*(view: ptr ImageView, size: S2Df)
proc imageview_scale*(view: ptr ImageView, scale: gui_scale_t)
proc imageview_image*(view: ptr ImageView, image: ptr Image)
proc imageview_OnClick*(view: ptr ImageView, listener: ptr Listener)
proc imageview_OnOverDraw*(view: ptr ImageView, listener: ptr Listener)

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/tableview.h" .}

# TableView

proc tableview_create*(): ptr TableView
proc tableview_OnData*(view: ptr TableView, listener: ptr Listener)
proc tableview_OnSelect*(view: ptr TableView, listener: ptr Listener)
proc tableview_OnHeaderClick*(view: ptr TableView, listener: ptr Listener)
proc tableview_font*(view: ptr TableView, font: ptr Font)
proc tableview_size*(view: ptr TableView, size: S2Df)
proc tableview_new_column_text*(view: ptr TableView): uint32_t
proc tableview_column_width*(view: ptr TableView, column: uint32_t,
                             width: real32_t)
proc tableview_column_limits*(view: ptr TableView, column: uint32_t,
                              min: real32_t, max: real32_t)
proc tableview_column_resizable*(view: ptr TableView, column: uint32_t,
                                 resizable: bool_t)                                                      
proc tableview_column_freeze*(view: ptr TableView, lastColumn: uint32_t)                                 
proc tableview_header_title*(view: ptr TableView, column: uint32_t,
                             text: cstring)
proc tableview_header_align*(view: ptr TableView, column: uint32_t,
                             align: align_t)
proc tableview_header_indicator*(view: ptr TableView, column: uint32_t,
                                 indicator: uint32_t)
proc tableview_header_visible*(view: ptr TableView, visible: bool_t)
proc tableview_header_clickable*(view: ptr TableView, clickable: bool_t)
proc tableview_header_resizable*(view: ptr TableView, resizable: bool_t)
proc tableview_multisel*(view: ptr TableView, multisel: bool_t,
                         preserve: bool_t)
proc tableview_grid*(view: ptr TableView, hlines: bool_t, vlines: bool_t)
proc tableview_update*(view: ptr TableView)
proc tableview_select*(view: ptr TableView, rows: ptr uint32_t, n: uint32_t)
proc tableview_deselect*(view: ptr TableView, rows: ptr uint32_t, n: uint32_t)
proc tableview_deselect_all*(view: ptr TableView)
proc tableview_selected*(view: ptr TableView): ptr Array[uint32_t]

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/splitview.h" .}

# SplitView

proc splitview_horizontal*(): ptr SplitView
proc splitview_vertical*(): ptr SplitView
proc splitview_size*(split: ptr SplitView, size: S2Df)
proc splitview_view*(split: ptr SplitView, view: ptr View)
proc splitview_text*(split: ptr SplitView, view: ptr TextView)
proc splitview_split*(split: ptr SplitView, child: ptr SplitView)
proc splitview_panel*(split: ptr SplitView, panel: ptr Panel)
proc splitview_pos*(split: ptr SplitView, pos: real32_t)

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/layout.h" .}

# Layout

proc layout_create*(ncols: uint32_t, nrows: uint32_t): ptr Layout
proc layout_cell*(layout: ptr Layout, col: uint32_t, row: uint32_t): ptr Cell
proc layout_label*(layout: ptr Layout, label: ptr Label, col: uint32_t,
                   row: uint32_t)
proc layout_button*(layout: ptr Layout, label: ptr Button, col: uint32_t,
                    row: uint32_t)
proc layout_popup*(layout: ptr Layout, label: ptr PopUp, col: uint32_t,
                   row: uint32_t)
proc layout_edit*(layout: ptr Layout, label: ptr Edit, col: uint32_t,
                  row: uint32_t)
proc layout_combo*(layout: ptr Layout, label: ptr Combo, col: uint32_t,
                   row: uint32_t)
proc layout_listbox*(layout: ptr Layout, label: ptr ListBox, col: uint32_t,
                     row: uint32_t)
proc layout_updown*(layout: ptr Layout, label: ptr UpDown, col: uint32_t,
                    row: uint32_t)
proc layout_slider*(layout: ptr Layout, label: ptr Slider, col: uint32_t,
                    row: uint32_t)
proc layout_progress*(layout: ptr Layout, label: ptr Progress, col: uint32_t,
                      row: uint32_t)
proc layout_view*(layout: ptr Layout, label: ptr View, col: uint32_t,
                  row: uint32_t)
proc layout_textview*(layout: ptr Layout, label: ptr TextView, col: uint32_t,
                      row: uint32_t)
proc layout_imageview*(layout: ptr Layout, label: ptr ImageView, col: uint32_t,
                       row: uint32_t)
proc layout_tableview*(layout: ptr Layout, label: ptr TableView, col: uint32_t,
                       row: uint32_t)
proc layout_splitview*(layout: ptr Layout, label: ptr SplitView, col: uint32_t,
                       row: uint32_t)
proc layout_panel*(layout: ptr Layout, label: ptr Panel, col: uint32_t,
                   row: uint32_t)
proc layout_layout*(layout: ptr Layout, label: ptr Layout, col: uint32_t,
                    row: uint32_t)
proc layout_get_control_imp*(layout: ptr Layout, col: uint32_t, row: uint32_t,
                             ty: cstring): pointer
proc layout_get_layout*(layout: ptr Layout, col: uint32_t,
                        row: uint32_t): ptr Layout
proc layout_taborder*(layout: ptr Layout, order: gui_orient_t)
proc layout_tabstop*(layout: ptr Layout, col: uint32_t, row: uint32_t,
                     tabstop: bool_t)
proc layout_next_tabstop*(layout: ptr Layout)
proc layout_prev_tabstop*(layout: ptr Layout)
proc layout_hsize*(layout: ptr Layout, col: uint32_t, width: real32_t)
proc layout_vsize*(layout: ptr Layout, row: uint32_t, height: real32_t)
proc layout_hmargin*(layout: ptr Layout, col: uint32_t, margin: real32_t)
proc layout_vmargin*(layout: ptr Layout, row: uint32_t, margin: real32_t)
proc layout_hexpand*(layout: ptr Layout, col: uint32_t)
proc layout_hexpand2*(layout: ptr Layout, col1: uint32_t, col2: uint32_t,
                      exp: real32_t)
proc layout_hexpand3*(layout: ptr Layout, col1: uint32_t, col2: uint32_t,
                      col3: uint32_t, exp1: real32_t, exp2: real32_t)
proc layout_vexpand*(layout: ptr Layout, row: uint32_t)
proc layout_vexpand2*(layout: ptr Layout, row1: uint32_t, row2: uint32_t,
                      exp: real32_t)
proc layout_vexpand3*(layout: ptr Layout, row1: uint32_t, row2: uint32_t,
                      row3: uint32_t, exp1: real32_t, exp2: real32_t)                      
proc layout_halign*(layout: ptr Layout, col: uint32_t, row: uint32_t,
                    align: align_t)
proc layout_valign*(layout: ptr Layout, col: uint32_t, row: uint32_t,
                    align: align_t)                  
proc layout_show_col*(layout: ptr Layout, col: uint32_t, visible: bool_t)
proc layout_show_row*(layout: ptr Layout, row: uint32_t, visible: bool_t)
proc layout_margin*(layout: ptr Layout, mall: real32_t)
proc layout_margin2*(layout: ptr Layout, mtb: real32_t, mlr: real32_t)
proc layout_margin4*(layout: ptr Layout, mt: real32_t, mr: real32_t,
                     mb: real32_t, ml: real32_t)
proc layout_bgcolor*(layout: ptr Layout, color: color_t)
proc layout_skcolor*(layout: ptr Layout, color: color_t)                
proc layout_update*(layout: ptr Layout)
proc layout_dbind_imp*(layout: ptr Layout, listener: ptr Listener, ty: cstring,
                       size: uint16_t)
proc layout_dbind_obj_imp*(layout: ptr Layout, obj: pointer, ty: cstring)
proc layout_dbind_update_imp*(layout: ptr Layout, ty: cstring, size: uint16_t,
                              mname: cstring, mty: cstring, moffset: uint16_t,
                              msize: uint16_t)                       

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/cell.h" .}

# Cell

proc cell_control_imp*(cell: ptr Cell, ty: cstring): pointer
proc cell_layout*(cell: ptr Cell): ptr Layout
proc cell_enabled*(cell: ptr Cell, enabled: bool_t)
proc cell_visible*(cell: ptr Cell, visible: bool_t)
proc cell_focus*(cell: ptr Cell)
proc cell_padding*(cell: ptr Cell, pall: real32_t)
proc cell_padding2*(cell: ptr Cell, ptb: real32_t, plr: real32_t)
proc cell_padding4*(cell: ptr Cell, pt: real32_t, pr: real32_t, pb: real32_t,
                    pl: real32_t)
proc cell_dbind_imp*(cell: ptr Cell, ty: cstring, size: uint16_t,
                     mname: cstring, mty: cstring, moffset: uint16_t,
                     msize: uint16_t)                  

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/panel.h" .}

proc panel_create*(): ptr Panel
proc panel_scroll*(hscroll: bool_t, vscroll: bool_t): ptr Panel
proc panel_data_imp*(panel: ptr Panel, data: ptr pointer,
                     destroy: FPtr_destroy)
proc panel_get_data_imp*(panel: ptr Panel): pointer
proc panel_size*(panel: ptr Panel, size: S2Df)
proc panel_layout*(panel: ptr Panel, layout: ptr Layout): uint32_t
proc panel_get_layout*(panel: ptr Panel, index: uint32_t): ptr Layout
proc panel_visible_layout*(panel: ptr Panel, index: uint32_t)
proc panel_update*(panel: ptr Panel)
proc panel_scroll_width*(panel: ptr Panel): real32_t
proc panel_scroll_height*(panel: ptr Panel): real32_t                     

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/window.h" .}

proc window_create*(flags: uint32_t): ptr Window
proc window_destroy*(window: ptr ptr Window)
proc window_panel*(window: ptr Window, panel: ptr Panel)
proc window_OnClose*(window: ptr Window, listener: ptr Listener)
proc window_OnMoved*(window: ptr Window, listener: ptr Listener)
proc window_OnResize*(window: ptr Window, listener: ptr Listener)
proc window_title*(window: ptr Window, title: cstring)
proc window_show*(window: ptr Window)
proc window_hide*(window: ptr Window)
proc window_modal*(window: ptr Window, parent: ptr Window): uint32_t
proc window_stop_modal*(window: ptr Window, returnVal: uint32_t)
proc window_hotkey*(window: ptr Window, key: vkey_t, modifiers: uint32_t,
                    listener: ptr Listener)
proc window_next_tabstop*(window: ptr Window)
proc window_previous_tabstop*(window: ptr Window)
proc window_update*(window: ptr Window)
proc window_origin*(window: ptr Window, origin: V2Df)
proc window_size*(window: ptr Window, size: S2Df)
proc window_get_origin*(window: ptr Window): V2Df
proc window_get_size*(window: ptr Window): S2Df
proc window_get_client_size*(window: ptr Window): S2Df
proc window_defbutton*(window: ptr Window, button: ptr Button)
proc window_cursor*(window: ptr Window, cursor: gui_cursor_t, image: ptr Image,
                    hotx: real32_t, hoty: real32_t)
proc window_imp*(window: ptr Window): pointer                    

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/menu.h" .}

proc menu_create*(): ptr Menu
proc menu_destroy*(menu: ptr ptr Menu)
proc menu_item*(menu: ptr Menu, item: ptr MenuItem)
proc menu_launch*(menu: ptr Menu, position: V2Df)
proc menu_hide*(menu: ptr Menu)
proc menu_off_items*(menu: ptr Menu)
proc menu_get_item*(menu: ptr Menu, index: uint32_t)
proc menu_size*(menu: ptr Menu): uint32_t
proc menu_imp*(menu: ptr Menu): pointer

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/menuitem.h" .}

proc menuitem_create*(): ptr MenuItem
proc menuitem_separator*(): ptr MenuItem
proc menuitem_OnClick*(item: ptr MenuItem, listener: ptr Listener)
proc menuitem_enabled*(item: ptr MenuItem, enabled: bool_t)
proc menuitem_visible*(item: ptr MenuItem, visible: bool_t)
proc menuitem_text*(item: ptr MenuItem, text: cstring)
proc menuitem_image*(item: ptr MenuItem, image: ptr Image)
proc menuitem_key*(item: ptr MenuItem, key: vkey_t, modifiers: uint32_t)
proc menuitem_submenu*(item: ptr MenuItem, submenu: ptr ptr Menu)
proc menuitem_state*(item: ptr MenuItem, state: gui_state_t)

{. pop .} # ===================================================================
{. push importc, header: "nappgui/gui/comwin.h" .}

proc comwin_open_file*(parent: ptr Window, ftypes: cstringArray,
                       size: uint32_t, startDir: cstring): cstring
proc comwin_save_file*(parent: ptr Window, ftypes: cstringArray,
                       size: uint32_t, startDir: cstring): cstring
proc comwin_color*(parent: ptr Window, title: cstring, x: real32_t,
                   y: real32_t, halign: align_t, valign: align_t,
                   current: color_t, colors: ptr color_t, n: uint32_t,
                   onChange: ptr Listener)

{. pop .} # ===================================================================
