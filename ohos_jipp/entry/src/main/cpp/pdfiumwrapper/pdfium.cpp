#include "aki/jsbind.h"
#include "pdfium.h"

Pdfium::Pdfium(std::string filename)
{
    FPDF_InitLibrary();
    doc = FPDF_LoadDocument(filename.c_str(), NULL);
    
    AKI_LOG(INFO) << "new Pdfium filename : " << filename << " doc = " << (void*)doc;
    return;
}

PdfiumPage Pdfium::LoadPage(int32_t index)
{
    AKI_LOG(INFO) << "Pdfium LoadPage index : " << index << " doc = " << doc;
    
    FPDF_PAGE page = FPDF_LoadPage(doc, index);
    int width = (int)FPDF_GetPageWidth(page);
    int height = (int)FPDF_GetPageHeight(page);
    AKI_LOG(INFO) << "Pdfium LoadPage width : " << width << " height " << height;
    
    PdfiumPage *newPage = new PdfiumPage();
    newPage->page = page;
    return *newPage;
}

int32_t Pdfium::GetPageCount()
{
    int32_t count = FPDF_GetPageCount(doc);
    AKI_LOG(INFO) << "Pdfium GetPageCount count : " << count;
    return count;
}

JSBIND_CLASS(Pdfium)
{
    JSBIND_CONSTRUCTOR<std::string>();
    JSBIND_METHOD(LoadPage);
    JSBIND_METHOD(GetPageCount);
}