#include "napi/native_api.h"
#include "aki/jsbind.h"
#include <fpdfview.h>
#include <fpdf_formfill.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>


EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    aki::JSBind::BindSymbols(env, exports);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}


