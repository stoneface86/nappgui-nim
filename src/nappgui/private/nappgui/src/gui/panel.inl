/*
 * NAppGUI Cross-platform C SDK
 * 2015-2023 Francisco Garcia Collado
 * MIT Licence
 * https://nappgui.com/en/legal/license.html
 *
 * File: panel.inl
 *
 */

/* Panel */

#include "gui.ixx"

__EXTERN_C

void _panel_destroy(Panel **panel);

void _panel_destroy_all(Panel **panel);

void _panel_attach_component(Panel *panel, GuiComponent *component);

void _panel_detach_components(Panel *panel);

void _panel_destroy_component(Panel *panel, GuiComponent *component);

void _panel_hide_all(Panel *panel);

GuiComponent *_panel_get_component(Panel *panel);

void _panel_invalidate_layout(Panel *panel, Layout *layout);

void _panel_panels(const Panel *panel, uint32_t *num_panels, Panel **panels);

void _panel_window(Panel *panel, Window *parent_window);

Window *_panel_get_window(Panel *panel);

void _panel_compose(Panel *panel, const S2Df *required_size, S2Df *final_size);

void _panel_dimension(Panel *panel, const uint32_t di, real32_t *dim0, real32_t *dim1);

void _panel_expand(Panel *panel, const uint32_t di, const real32_t current_size, const real32_t required_size, real32_t *final_size);

void _panel_taborder(const Panel *panel, Window *window);

void _panel_locate(Panel *panel);

void _panel_locale(Panel *panel);

ArrPt(Layout) *_panel_layouts(const Panel *panel);

bool_t _panel_with_scroll(const Panel *panel);

__END_C

