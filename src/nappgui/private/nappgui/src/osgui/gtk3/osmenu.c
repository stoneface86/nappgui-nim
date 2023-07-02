/*
 * NAppGUI Cross-platform C SDK
 * 2015-2023 Francisco Garcia Collado
 * MIT Licence
 * https://nappgui.com/en/legal/license.html
 *
 * File: osmenu.c
 *
 */

/* Operating System native menu */

#include "osgui.inl"
#include "osgui_gtk.inl"
#include "osmenuitem.inl"
#include "osmenu.h"
#include "osmenu.inl"
#include "arrpt.h"
#include "cassert.h"
#include "heap.h"

#if !defined(__GTK3__)
#error This file is only for GTK Toolkit
#endif

struct _osmenu_t
{
    GtkWidget *widget;
    OSWindow *window;
    bool_t is_popup;
    OSMenuItem *parent;
    ArrPt(OSMenuItem) *items;

    #if defined (__ASSERTS__)
    bool_t is_alive;
    #endif
};

#if defined (__ASSERTS__)

/*---------------------------------------------------------------------------*/

static void i_count(GtkWidget *widget, gpointer n)
{
    unref(widget);
    *((uint32_t*)n) += 1;
}

/*---------------------------------------------------------------------------*/

static uint32_t i_num_children(GtkContainer *container)
{
    uint32_t n = 0;
    gtk_container_foreach(container, i_count, (gpointer)&n);
    return n;
}

/*---------------------------------------------------------------------------*/

static void i_OnDestroy(GtkWidget *obj, OSMenu *menu)
{
    cassert(menu->is_alive == TRUE);
    unref(obj);
    menu->is_alive = FALSE;
}

#endif

/*---------------------------------------------------------------------------*/

OSMenu *osmenu_create(const enum_t flags)
{
    OSMenu *menu = heap_new0(OSMenu);
    unref(flags);
    menu->widget = gtk_menu_new();
    menu->window = NULL;
    menu->is_popup = TRUE;
    menu->parent = NULL;
    menu->items = arrpt_create(OSMenuItem);
    return menu;
}

/*---------------------------------------------------------------------------*/

void osmenu_destroy(OSMenu **menu)
{
    cassert_no_null(menu);
    cassert_no_null(*menu);
    cassert((*menu)->window == NULL);
    cassert((*menu)->parent == NULL);
    cassert(arrpt_size((*menu)->items, OSMenuItem) == 0);
    cassert(i_num_children(GTK_CONTAINER((*menu)->widget)) == 0);
    arrpt_destroy(&(*menu)->items, NULL, OSMenuItem);
    #if defined (__ASSERTS__)
    (*menu)->is_alive = TRUE;
    g_signal_connect((*menu)->widget, "destroy", G_CALLBACK(i_OnDestroy), (gpointer)*menu);
    #endif
    g_object_unref((*menu)->widget);
    cassert((*menu)->is_alive == FALSE);
    heap_delete(menu, OSMenu);
}

/*---------------------------------------------------------------------------*/

void osmenu_add_item(OSMenu *menu, OSMenuItem *item)
{
	cassert_no_null(menu);
    _osmenuitem_set_parent(item, menu, GTK_MENU_SHELL(menu->widget));
    arrpt_append(menu->items, item, OSMenuItem);
}

/*---------------------------------------------------------------------------*/

void osmenu_delete_item(OSMenu *menu, OSMenuItem *item)
{
    #if defined (__ASSERTS__)
    uint32_t c = i_num_children(GTK_CONTAINER(menu->widget));
    #endif
    uint32_t pos;
    cassert_no_null(menu);
    pos = arrpt_find(menu->items, item, OSMenuItem);
    arrpt_delete(menu->items, pos, NULL, OSMenuItem);
    _osmenuitem_unset_parent(item, menu, GTK_MENU_SHELL(menu->widget));
    cassert(i_num_children(GTK_CONTAINER(menu->widget)) == c - 1);
}

/*---------------------------------------------------------------------------*/

void osmenu_launch(OSMenu *menu, OSWindow *window, const real32_t x, const real32_t y)
{
    unref(menu);
    unref(window);
    unref(x);
    unref(y);
    cassert_msg(FALSE, "Not implemented");
}

/*---------------------------------------------------------------------------*/

void osmenu_hide(OSMenu *menu)
{
    unref(menu);
    cassert_msg(FALSE, "Not implemented");
}

/*---------------------------------------------------------------------------*/

GtkWidget *_osmenu_widget(OSMenu *menu)
{
    cassert_no_null(menu);
    return menu->widget;
}

/*---------------------------------------------------------------------------*/

static void i_remove_all_items(OSMenu *menu)
{
    cassert_no_null(menu);
    cassert(arrpt_size(menu->items, OSMenuItem) == i_num_children(GTK_CONTAINER(menu->widget)));
    arrpt_foreach(item, menu->items, OSMenuItem)
    GtkWidget *widget = _osmenuitem_widget(item);
    g_object_ref(widget);
    gtk_container_remove(GTK_CONTAINER(menu->widget), widget);
    arrpt_end();
    cassert(i_num_children(GTK_CONTAINER(menu->widget)) == 0);
}

/*---------------------------------------------------------------------------*/

static void i_add_all_items_to_bar(OSMenu *menu)
{
    cassert_no_null(menu);
    cassert_no_null(menu->widget);
    arrpt_foreach(item, menu->items, OSMenuItem)
    GtkWidget *widget = _osmenuitem_bar_widget(item);
    gtk_menu_shell_append(GTK_MENU_SHELL(menu->widget), widget);
    g_object_unref(widget);
    arrpt_end();
}

/*---------------------------------------------------------------------------*/

void _osmenu_menubar(OSMenu *menu, OSWindow *window)
{
    cassert_no_null(menu);
    cassert_no_null(menu->widget);
    cassert(menu->window == NULL);
    menu->window = window;
    if (menu->is_popup == TRUE)
    {
        i_remove_all_items(menu);
        #if defined (__ASSERTS__)
        menu->is_alive = TRUE;
        g_signal_connect(menu->widget, "destroy", G_CALLBACK(i_OnDestroy), (gpointer)menu);
        #endif
        g_object_ref_sink(menu->widget);
        g_object_unref(menu->widget);
        cassert(menu->is_alive == FALSE);
        menu->widget = gtk_menu_bar_new();
        menu->is_popup = FALSE;
        i_add_all_items_to_bar(menu);
    }
}

/*---------------------------------------------------------------------------*/

void _osmenu_menubar_unlink(OSMenu *menu, OSWindow *window)
{
    cassert_no_null(menu);
    cassert_unref(menu->window == window, window);
    cassert(menu->is_popup == FALSE);
    menu->window = NULL;
}

/*---------------------------------------------------------------------------*/

void _osmenu_attach_to_item(OSMenu *menu, OSMenuItem *item, GtkMenuItem *menuitem)
{
    cassert_no_null(menu);
    cassert(menu->parent == NULL);
    menu->parent = item;
    cassert(menu->is_popup == TRUE);
    gtk_menu_item_set_submenu(menuitem, menu->widget);
}

/*---------------------------------------------------------------------------*/

void _osmenu_detach_from_item(OSMenu *menu, OSMenuItem *item, GtkMenuItem *menuitem)
{
    cassert_no_null(menu);
    cassert_unref(menu->parent == item, item);
    menu->parent = NULL;
    cassert(menu->is_popup == TRUE);
    cassert(gtk_menu_item_get_submenu(menuitem) == menu->widget);
    g_object_ref(menu->widget);
    gtk_menu_item_set_submenu(menuitem, NULL);
}

/*---------------------------------------------------------------------------*/

void _osmenu_set_accel(OSMenu *menu, GtkAccelGroup *accel)
{
    cassert_no_null(menu);
    arrpt_foreach(item, menu->items, OSMenuItem)
    _osmenuitem_set_accel(item, accel);
    arrpt_end();
}

/*---------------------------------------------------------------------------*/

void _osmenu_unset_accel(OSMenu *menu, GtkAccelGroup *accel)
{
    cassert_no_null(menu);
    arrpt_foreach(item, menu->items, OSMenuItem)
    _osmenuitem_unset_accel(item, accel);
    arrpt_end();
}
