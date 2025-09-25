/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */

import { PclmSettings } from './PclmSettings';
import { fileIo } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';
import { RenderablePage } from '../RenderablePage';
import { PdlUtil } from '../PdlUtil';
import { ColorSpace } from '../OhColorSpace';
import pako from 'pako';
import { Sides } from '../model/Sides';
import { PclmRasterBackSide } from '../model/PclmRasterBackSide';

// 条带数据结构（）
class Swath {
  imageNumber: number;
  objectNumber: number
  height: number
  yOffset: number

  constructor(objectNumber: number, imageNumber: number, height: number, yOffset: number) {
    this.objectNumber = objectNumber;
    this.imageNumber = imageNumber;
    this.height = height
    this.yOffset = yOffset
  }
}

export class PclmWriter {
  private settings: PclmSettings;
  private outputStream: fileIo.Stream;
  private crossReferences: number[] = Array<number>()
  private written: number = 0
  private pageObjectNumbers: number[] = Array<number>()

  /**
   * 构造函数：新增文件路径参数，用于打开文件描述符
   * @param stream 写入流
   * @param setting PCLm配置
   * @param filePath 输出文件路径（用于随机访问）
   */
  constructor(outputStream: fileIo.Stream, setting: PclmSettings) {
    this.outputStream = outputStream
    this.settings = setting;
  }

  public async write(renderablePages: RenderablePage[]) {
    this.crossReferences.push(-1)
    this.crossReferences.push(-1)
    this.crossReferences.push(-1)
    console.info('ohos_jipp--> start  convert..' );
    this.startDoc();
    for (let i = 0; i < renderablePages.length; i++) {
      await this.writePage(renderablePages[i])
    }
    this.endDoc()
  }

  public close() {
    this.outputStream.closeSync()
  }

  public flush() {
    this.outputStream.flushSync()
  }

  public calculateJobPagesPerSet(renderablePages: RenderablePage[]): number {
    let pageCount = renderablePages.length
    if (this.settings.output.sides !== Sides.oneSided && PdlUtil.isOdd(pageCount)) {
      pageCount + 1
    } else {
      pageCount
    }
    return pageCount
  }

  private transform(number: number, renderablePage: RenderablePage): RenderablePage|PclmWriter {
    if (PdlUtil.isEven(number)) {
      return this;
    } else if (
      this.settings.output.sides === Sides.twoSidedLongEdge &&
        this.settings.backSide === PclmRasterBackSide.rotated
    ) {
      return renderablePage.rotated();
    } else if (
      this.settings.output.sides === Sides.twoSidedLongEdge &&
        this.settings.backSide === PclmRasterBackSide.flipped
    ) {
      return renderablePage.flipY();
    } else if (
      this.settings.output.sides === Sides.twoSidedLongEdge &&
        this.settings.backSide === PclmRasterBackSide.flipped
    ) {
      return renderablePage.flipX(); 
    } else {
      return this;
    }
  }

  private startDoc() {
    const header = "%PDF-1.7\n%PCLm 1.0\n";
    this.writeData(header);
  }


  public async writePage(page: RenderablePage) {
    let swaths = new Array<Swath>();
    const stripHeight = this.settings.stripHeight;
    const totalHeight = page.heightPixels;
    const stripCount = Math.ceil(totalHeight / stripHeight);
    let yOffset: number = 0
    for (let i = 0; i < stripCount; i++) {
      let height: number = 0
      if (i == stripCount - 1) {
        height = page.heightPixels - (stripCount - 1) * this.settings.stripHeight
      } else {
        height = this.settings.stripHeight
      }

      let currentYOffset = yOffset;
      yOffset += height;

      swaths.push(new Swath(this.crossReferences.length + 2 + (i * 2), i, height,
        currentYOffset));
    }


    //Write the page object
    let pageObjectNumber: number = this.pbObject(this.crossReferences.length, (context) => {
      this.writeData("/Type /Page\n")
      this.writeData(`/Parent ${Const.PAGE_TREE_OBJECT_NUMBER} 0 R\n`)
      this.writeData("/Resources <<\n")
      this.writeData("/XObject <<\n")
      for (let i = 0; i < swaths.length; i++) {
        let swath = swaths[i]
        this.writeData(`/Image${swath.imageNumber} ${swath.objectNumber} 0 R\n`)
      }
      this.writeData(">>\n")
      this.writeData(">>\n")
      let widthPoints: number = Math.floor(page.widthPixels * Const.POINTS_PER_INCH / page.DPI)
      let heightPoints: number = Math.floor(page.heightPixels * Const.POINTS_PER_INCH / page.DPI)
      this.writeData(`/MediaBox [ 0 0 ${widthPoints} ${heightPoints} ]\n`)
      this.writeData(`/Contents [ ${context.objectNumber + 1} 0 R ]\n`)
    })
    this.pageObjectNumbers.push(pageObjectNumber)

    // Write the page content stream object
    this.pbObject(this.crossReferences.length, (context) => {
      let content: string = ''
      const scale = Const.POINTS_PER_INCH / page.DPI;
      content += `${scale} 0 0 ` + `${scale} 0 0 cm\n`
      content += "/P <</MCID 0>> BDC q\n"
      for (let i = 0; i < swaths.length; i++) {
        let swath = swaths[i]
        let pageYOffset = page.heightPixels - swath.yOffset - swath.height
        content += `${page.widthPixels} 0 0 ${swath.height} 0 ${pageYOffset} cm\n`
        content += `/Image${swath.imageNumber} Do Q\n`
        content += "/P <</MCID 0>> BDC q\n"
      }
      context.charStream = content
      let len = new util.TextEncoder().encodeInto(content).byteLength;
      this.writeData(`/Length ${len}\n`)
    })

    //write swaths
    await this.writeSwaths(page, swaths, page.widthPixels)
  }

  async writeSwaths(page: RenderablePage, swaths: Array<Swath>, widthPixels: number) {
    let first: boolean = true
    for (let i = 0; i < swaths.length; i++) {
      let swath = swaths[i]
      this.pbObject(this.crossReferences.length, async (context) => {
        let rawBytes: Uint8Array | undefined = undefined
        let curBytes: Uint8Array = this.getBytes(page, swath, first, widthPixels, rawBytes)
        rawBytes = curBytes
        context.byteStream = pako.deflate(rawBytes).buffer as ArrayBuffer
        this.writeData(`/Width ${widthPixels}\n`)
        let colorSpace = this.settings.output.colorSpace
        if (colorSpace === ColorSpace.Rgb) {
          this.writeData("/ColorSpace /DeviceRGB\n")
        } else if (colorSpace === ColorSpace.Grayscale) {
          this.writeData("/ColorSpace /DeviceGray\n")
        } else {
          new Error(JSON.stringify(this.settings.output.colorSpace) + 'not supported')
        }

        this.writeData(`/Height ${swath.height}\n`)
        this.writeData("/Filter /FlateDecode\n")
        this.writeData("/Subtype /Image\n")
        this.writeData(`/Length ${context.byteStream.byteLength}\n`)
        this.writeData("/Type /XObject\n")
        this.writeData("/BitsPerComponent 8\n")
        this.writeData("/Name /ColorStrip\n")
      })

      this.pbObject(this.crossReferences.length, (context) => {
        const str = "q /Image Do Q\n";
        const byteArray = new util.TextEncoder().encodeInto(str);
        context.charStream = str
        this.writeData(`/Length ${byteArray.byteLength}\n`)
      })
      first = false
    }
  }

  pbObject(objectNumber: number = this.crossReferences.length, block: (context: InObject) => void) {
    let context = new InObject(objectNumber)
    if (objectNumber < this.crossReferences.length) {
      this.crossReferences[objectNumber] = this.written
    } else if (objectNumber === this.crossReferences.length) {
      this.crossReferences[objectNumber] = this.written
    } else {
      new Error("Cannot create object beyond last position")
    }

    this.writeData(`${context.objectNumber} 0 obj\n`)
    this.writeData("<<\n")
    block(context);
    this.writeData(">>\n")
    if (context.byteStream != null) {
      this.writeData("stream\n")
      this.writeData(context.byteStream)
      this.written += context.byteStream.byteLength
      this.writeData("\nendstream\n")
    } else if (context.charStream != null) {
      this.writeData("stream\n")
      this.writeData(context.charStream!!)
      this.writeData("\nendstream\n")
    }
    this.writeData("endobj\n")
    return objectNumber
  }


  private endDoc() {
    this.pbObject(Const.CATALOG_OBJECT_NUMBER, (context) => {
      this.writeData("/Type /Catalog\n")
      this.writeData(`/Pages ${context.objectNumber + 1} 0 R\n`)
    })

    this.pbObject(Const.PAGE_TREE_OBJECT_NUMBER, (context) => {
      this.writeData(`/Count ${this.pageObjectNumbers.length}\n`)
      this.writeData("/Kids [ ")
      for (let i = 0; i < this.pageObjectNumbers.length; i++) {
        this.writeData(`${this.pageObjectNumbers[i]} 0 R `)
      }
      this.writeData("]\n")
      this.writeData("/Type /Pages\n")
    })

    let xrefOffset = this.written
    this.writeData("xref\n")
    this.writeData(`1 ${this.crossReferences.length - 1}\n`)

    for (let i = 1; i < this.crossReferences.length; i++) {
      const offset = this.crossReferences[i];
      this.writeData(`${offset.toString().padStart(10, '0')} 00000 n \n`)
    }

    // Write the trailer
    this.writeData("trailer\n")
    this.writeData("<<\n")
    this.writeData(`/Size ${this.crossReferences.length - 1}\n`)
    this.writeData(`/Root ${Const.CATALOG_OBJECT_NUMBER} 0 R\n`)
    this.writeData(">>\n")
    this.writeData("startxref\n")
    this.writeData(`${xrefOffset}\n`)
    this.writeData("%%EOF\n")
  }

  private getBytes(page: RenderablePage, swath: Swath, forceNonBlank: boolean, widthPixels: number,
    bytes?: Uint8Array): Uint8Array {
    let renderBytes = bytes
    let size = swath.height * widthPixels * this.getBytesPerPixel(this.settings.output.colorSpace)
    if (renderBytes?.byteLength != size) {
      renderBytes = new Uint8Array(size)
    }
    page.render(swath.yOffset, swath.height, this.settings.output.colorSpace, renderBytes)
    return renderBytes
  }

  getBytesPerPixel(colorSpace: ColorSpace): number {
    switch (colorSpace) {
      case ColorSpace.Rgba:
        return 4;
      case ColorSpace.Rgb:
        return 3;
      case ColorSpace.Grayscale:
        return 1;
      default:
        throw new Error(`Unsupported color space: ${colorSpace}`);
    }
  }

  private writeData(data: string | ArrayBuffer /*,options?: WriteOptions*/) {
    let length = this.outputStream.writeSync(data)
    this.outputStream.flushSync()
    return length
  }
}

class Const {
  static readonly BLANK: number = 0xFF;
  static readonly POINTS_PER_INCH: number = 72;
  static readonly CATALOG_OBJECT_NUMBER: number = 1;
  static readonly PAGE_TREE_OBJECT_NUMBER: number = Const.CATALOG_OBJECT_NUMBER + 1;
}

class InObject {
  objectNumber: number;
  byteStream: ArrayBuffer | null = null;
  charStream: string | null = null;

  constructor(objectNumber: number) {
    this.objectNumber = objectNumber;
  }
}




