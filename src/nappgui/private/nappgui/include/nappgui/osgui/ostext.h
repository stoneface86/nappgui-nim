/*
 * NAppGUI Cross-platform C SDK
 * 2015-2023 Francisco Garcia Collado
 * MIT Licence
 * https://nappgui.com/en/legal/license.html
 *
 * File: nappgui/osgui/ostext.h
 *
 */

/* Operating System native text view */

#include "nappgui/osgui/osgui.hxx"

__EXTERN_C

_osgui_api OSText *ostext_create(const uint32_t flags);

_osgui_api void ostext_destroy(OSText **view);

_osgui_api void ostext_OnTextChange(OSText *view, Listener *listener);

_osgui_api void ostext_insert_text(OSText *view, const char_t *text);

_osgui_api void ostext_set_text(OSText *view, const char_t *text);

_osgui_api void ostext_set_rtf(OSText *view, Stream *rtf_in);

_osgui_api void ostext_property(OSText *view, const gui_prop_t prop, const void *value);

_osgui_api void ostext_editable(OSText *view, const bool_t is_editable);

_osgui_api const char_t *ostext_get_text(const OSText *view);

_osgui_api void ostext_set_need_display(OSText *view);


_osgui_api void ostext_attach(OSText *view, OSPanel *panel);

_osgui_api void ostext_detach(OSText *view, OSPanel *panel);

_osgui_api void ostext_visible(OSText *view, const bool_t visible);

_osgui_api void ostext_enabled(OSText *view, const bool_t enabled);

_osgui_api void ostext_size(const OSText *view, real32_t *width, real32_t *height);

_osgui_api void ostext_origin(const OSText *view, real32_t *x, real32_t *y);

_osgui_api void ostext_frame(OSText *view, const real32_t x, const real32_t y, const real32_t width, const real32_t height);

__END_C

