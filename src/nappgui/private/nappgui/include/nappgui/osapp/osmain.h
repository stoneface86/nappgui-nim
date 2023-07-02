/*
 * NAppGUI Cross-platform C SDK
 * 2015-2023 Francisco Garcia Collado
 * MIT Licence
 * https://nappgui.com/en/legal/license.html
 *
 * File: nappgui/osapp/osmain.h
 *
 */

/* Cross-platform main */

#include "nappgui/osapp/osmain.hxx"

__EXTERN_C

_osapp_api void osmain_imp(uint32_t argc, char_t **argv, void *instance, const real64_t lframe, FPtr_app_create func_create, FPtr_app_update func_update, FPtr_destroy func_destroy, char_t *options);

__END_C

#if defined(__WINDOWS__)
    #include "nappgui/osapp/osmain_win.h"
#elif defined(__MACOS__)
    #include "nappgui/osapp/osmain_osx.h"
#elif defined(__LINUX__)
    #include "nappgui/osapp/osmain_gtk.h"
#else
    #error Unknown platform
#endif
