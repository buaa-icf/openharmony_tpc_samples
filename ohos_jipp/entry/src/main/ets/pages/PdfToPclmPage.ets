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

// import  pdfService  from '@hms.officeservice.pdfservice';
import { image } from '@kit.ImageKit';
import { fileIo, fileUri, picker } from '@kit.CoreFileKit';
import {
  ColorSpace,
  ImageType,
  MediaSource,
  OutputSettings,
  PclmSettings,
  PclmWriter,
  RenderablePage,
  Sides
} from '@ohos/jipp_pdl';
import { BusinessError } from '@kit.BasicServicesKit';
import { taskpool } from '@kit.ArkTS';

@Concurrent
async function pdfToPclm(pdfPath: string, outputPath: string, DPI: number,
  RED_COEFFICIENT: number,
  GREEN_COEFFICIENT: number,
  BLUE_COEFFICIENT: number) {
  // let pix: ArrayBuffer | undefined = undefined
  // let colorSpace: ColorSpace = ColorSpace.Rgb;
  // let outputSettings: OutputSettings =
  //   new OutputSettings(colorSpace, Sides.oneSided, MediaSource.auto, null, false);
  // let setting: PclmSettings = new PclmSettings(outputSettings, 16);
  // let writeStream = fileIo.createStreamSync(outputPath, 'w+');
  // let writer = new PclmWriter(writeStream, setting);
  //
  // let renderablePages: RenderablePage[] = new Array<RenderablePage>();
  // let pdfDocument: pdfService.PdfDocument = new pdfService.PdfDocument();
  // let loadResult: pdfService.ParseResult = pdfDocument.loadDocument(new fileUri.FileUri(pdfPath).path, '');
  // if (pdfService.ParseResult.PARSE_SUCCESS === loadResult) {
  //   let pageCount: number = pdfDocument.getPageCount();
  //   for (let i = 0; i < pageCount; i++) {
  //     let page: pdfService.PdfPage = pdfDocument.getPage(i);
  //     let pixelMap: image.PixelMap = page.getPagePixelMap();
  //     pixelMap.scaleSync(DPI / 72, DPI / 72)
  //     let size: image.Size = pixelMap.getImageInfoSync().size;
  //     let renderablePage = new RenderablePage(size.width, size.height, DPI,
  //       (yOffset: number, swathHeight: number, colorSpace: ColorSpace, byteArray: Uint8Array) => {
  //         if (pix == undefined || pix.byteLength != size.width * swathHeight) {
  //           pix = new ArrayBuffer(size.width * swathHeight * 4)
  //         }
  //         const area: image.PositionArea = {
  //           pixels: pix,
  //           offset: 0,
  //           stride: size.width * 4,
  //           region: { size: { width: size.width, height: swathHeight, }, x: 0, y: yOffset }
  //         };
  //         //BGRA_8888格式
  //         pixelMap.readPixelsSync(area);
  //
  //         let uint8Data = new Uint8Array(pix);
  //         let red: number;
  //         let green: number;
  //         let blue: number;
  //
  //         let byteIndex: number = 0;
  //         for (let y = 0; y < swathHeight; y++) {
  //           for (let x = 0; x < size.width; x++) {
  //             const pixelIndex = (y * size.width + x) * 4;
  //             blue = uint8Data[pixelIndex]; // Blue通道
  //             green = uint8Data[pixelIndex + 1]; // Green通道
  //             red = uint8Data[pixelIndex + 2]; // Red通道
  //
  //             if (colorSpace == ColorSpace.Grayscale) {
  //               const grayValue = RED_COEFFICIENT * red +
  //                 GREEN_COEFFICIENT * green +
  //                 BLUE_COEFFICIENT * blue;
  //               byteArray[byteIndex++] = grayValue;
  //             } else {
  //               byteArray[byteIndex++] =
  //                 red;
  //               byteArray[byteIndex++] =
  //                 green;
  //               byteArray[byteIndex++] =
  //                 blue;
  //             }
  //           }
  //         }
  //       })
  //     renderablePages.push(renderablePage)
  //   }
  //   await writer.write(renderablePages);
  //   writer.close()
  //   pdfDocument.releaseDocument();
  //   console.info('PCLm conversion completed successfully!');
  // } else {
  //   console.info('test--> load pdf fail:' + JSON.stringify(loadResult));
  // }

}


@Entry
@Component
struct PdfToPclmPage {
  path: string = '';
  context: Context | undefined = undefined;
  outputPath: string = '';
  RED_COEFFICIENT: number = 0.2126;
  GREEN_COEFFICIENT: number = 0.7512;
  BLUE_COEFFICIENT: number = 0.0722;
  DPI: number = 300;
  @State resizePixelMap: image.PixelMap | undefined = undefined

  aboutToAppear(): void {
    this.context = this.getUIContext().getHostContext() as Context;
    this.outputPath = this.context.filesDir + '/harmony.pclm';
  }

  convertImageTypeToColorSpace(imageType: ImageType): number {
    switch (imageType) {
      case ImageType.BINARY:
      case ImageType.GRAY:
        return ColorSpace.Grayscale;
      default:
        return ColorSpace.Rgb;
    }
  }

  build() {
    Column() {
      Button('pdf 转 pclm')
        .fontSize(18)
        .height(45)
        .width('90%')
        .margin({ top: 10 })
        .fontWeight(FontWeight.Bold)
        .onClick(async () => {
          try {
            let DocumentSelectOptions = new picker.DocumentSelectOptions();
            DocumentSelectOptions.maxSelectNumber = 1
            DocumentSelectOptions.fileSuffixFilters = ['.pdf', '.doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'];
            let documentPicker = new picker.DocumentViewPicker();
            documentPicker.select(DocumentSelectOptions).then((DocumentSelectResult) => {
              if (DocumentSelectResult !== null && DocumentSelectResult !== undefined) {
                DocumentSelectResult.forEach(async (value: string) => {
                  let task =
                    new taskpool.Task(pdfToPclm, value, this.outputPath, this.DPI, this.RED_COEFFICIENT,
                      this.GREEN_COEFFICIENT, this.BLUE_COEFFICIENT);
                  await taskpool.execute(task)
                })
              }
            }).catch((err: BusinessError) => {
              console.error('test-->', 'DocumentViewPicker.select failed with err: ' + JSON.stringify(err));
            });
          } catch (err) {
            console.error('test-->', 'DocumentViewPicker failed with err: ' + JSON.stringify(err));
          }
        });

      Image(this.resizePixelMap)
        .width('100%')
        .margin({ top: 10 })
        .height('50%')

    }
    .height('100%')
    .width('100%');
  }
}