import { image } from '@kit.ImageKit';

export class PdfiumPage {
  Render : (width: number, height: number) => image.PixelMap
  GetWidth : () => number
  GetHeight : () => number

}

export class Pdfium {
  public
  constructor(path : string)
  LoadPage : (index: number) => PdfiumPage
  GetPageCount : () => number
}

