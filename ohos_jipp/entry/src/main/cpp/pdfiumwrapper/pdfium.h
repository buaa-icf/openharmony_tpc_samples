#ifndef PDFIUM_H
#define PDFIUM_H

#include <fpdfview.h>
#include "pdfiumpage.h"

class Pdfium {
public:
    Pdfium(std::string fileName);
    PdfiumPage LoadPage(int32_t index);
    int32_t GetPageCount();
private:
    FPDF_DOCUMENT doc = nullptr;
};

#endif
