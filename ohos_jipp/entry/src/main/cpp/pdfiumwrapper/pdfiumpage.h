
#ifndef PDFIUM_PAGE_H
#define PDFIUM_PAGE_H

#include <fpdfview.h>

class PdfiumPage {
public:
    napi_value Render(int32_t width, int32_t height);
    int32_t GetWidth();
    int32_t GetHeight();
//private:
    FPDF_PAGE page = nullptr;
};

#endif
