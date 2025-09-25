#include "aki/jsbind.h"
#include "pdfiumpage.h"
#include <multimedia/image_framework/image_mdk_common.h>
#include <multimedia/image_framework/image_pixel_map_mdk.h>
#include <stdlib.h>

napi_value PdfiumPage::Render(int32_t width, int32_t height)
{
    AKI_LOG(INFO) << "PdfiumPage Render page = " << (void*)page;
    AKI_LOG(INFO) << "PdfiumPage Render width = " << width << " height "  << height;
    aki::JSBind::GetScopedEnv();
    napi_value udfVar = nullptr;
    napi_value pixelMap = nullptr;    
    
    
    FPDF_BITMAP bitmap = FPDFBitmap_Create(width, height, 0);
    FPDFBitmap_FillRect(bitmap, 0, 0, width, height, 0xFFFFFF);
    //FPDF_RenderPageBitmap(bitmap, page, 0, 0, width, height, 0, FPDF_ANNOT);
    FPDF_RenderPageBitmap(bitmap, page, 0, 0, width, height, 0, FPDF_LCD_TEXT | FPDF_RENDER_FORCEHALFTONE);

    const char *pixels = (char *)FPDFBitmap_GetBuffer(bitmap);
    
    struct OhosPixelMapCreateOps createOps;
    createOps.width = width;
    createOps.height = height;
    createOps.pixelFormat = 4;
    createOps.alphaType = 0;
    size_t bufferSize = createOps.width * createOps.height * 4;

    int32_t res = OH_PixelMap_CreatePixelMap(aki::JSBind::GetScopedEnv(), createOps, (uint8_t *)pixels, bufferSize, &pixelMap);
    if (res != IMAGE_RESULT_SUCCESS || pixelMap == nullptr) {
        return udfVar;
    }
    return pixelMap;
    
    return 0;
}

int32_t PdfiumPage::GetWidth()
{
    AKI_LOG(INFO) << "PdfiumPage GetWidth page = " << (void*)page;
    int width = (int)FPDF_GetPageWidth(page);
    AKI_LOG(INFO) << "PdfiumPage GetWidth width = " << width;
    return width;
}

int32_t PdfiumPage::GetHeight()
{
    int height = (int)FPDF_GetPageHeight(page);
    AKI_LOG(INFO) << "PdfiumPage GetWidth height = " << height;
    return height;
}

JSBIND_CLASS(PdfiumPage)
{
    JSBIND_METHOD(Render);
    JSBIND_METHOD(GetWidth);
    JSBIND_METHOD(GetHeight);
}