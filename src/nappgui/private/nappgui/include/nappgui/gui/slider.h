/*
 * NAppGUI Cross-platform C SDK
 * 2015-2023 Francisco Garcia Collado
 * MIT Licence
 * https://nappgui.com/en/legal/license.html
 *
 * File: nappgui/gui/slider.h
 * https://nappgui.com/en/gui/slider.html
 *
 */

/* Slider */

#include "nappgui/gui/gui.hxx"

__EXTERN_C

_gui_api Slider *slider_create(void);

_gui_api Slider *slider_vertical(void);

_gui_api void slider_OnMoved(Slider *slider, Listener *listener);

_gui_api void slider_tooltip(Slider *slider, const char_t *text);

_gui_api void slider_steps(Slider *slider, const uint32_t steps);

_gui_api void slider_value(Slider *slider, const real32_t value);

_gui_api real32_t slider_get_value(const Slider *slider);

__END_C

