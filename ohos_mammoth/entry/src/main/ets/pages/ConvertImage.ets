/**
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import * as mammoth from "@ohos/mammoth";
import { buffer, JSON } from "@kit.ArkTS";
import { WebDialog } from "../component/WebDialog"
import { Options, SrcData } from "../utils/Type";
import { Logger } from "../utils/Logger";
import { deleteFile, writeFile } from "../utils/FileUtils";
import { Image } from "@ohos/mammoth";
import { BusinessError } from "@ohos.base";

@Entry
@Component
struct ConvertImage {
  @State html: string = '';
  @State md: string = '';
  @State isShow: boolean = false
  private docxName = 'Image.docx';
  private webSrc: string = "index.html";
  private context: Context | undefined = this.getUIContext().getHostContext();
  private filesDir: string =  this.context!.filesDir;
  private inputDocx = this.filesDir + "/" + this.docxName;
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: WebDialog({
      src: this.filesDir + '/index.html',
      md: this.md
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: 20,
    backgroundColor: Color.White,
    shadow: ({
      radius: 20,
      color: Color.Grey,
      offsetX: 50,
      offsetY: 0
    }),
  });

  aboutToAppear(): void {
    if (this.context) {
      let content = this.context.resourceManager.getRawFileContentSync(this.docxName);
      if (content) {
        writeFile(this.context.filesDir, this.docxName,content.buffer);
      }else{
        Logger.error("get rawFile content error , message" + JSON.stringify(content))
      }
    }
  }

  aboutToDisappear(): void {
    deleteFile(this.filesDir + '/' + this.webSrc);
    deleteFile(this.filesDir + '/' + this.docxName);
  }

  convert(options: Options) {
    mammoth.convert({ path: this.inputDocx}, options)
      .then((result) => {
        this.html = result.value
        let html = result.value; // The generated HTML
        let messages = result.messages; // Any messages, such as warnings during conversion
        Logger.info(`convertToHtml html: ${html}`);
        Logger.info(`convertToHtml messages: ${JSON.stringify(messages)}`);
        this.md = "";
        writeFile(this.filesDir, this.webSrc, this.html);
        this.dialogController?.open();
      })
      .catch((error: BusinessError) => {
        Logger.error(`convertToHtml html, error.message: ${error.message}`);
        Logger.error(`convertToHtml html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  convertToHtml(options: Options) {
    mammoth.convertToHtml({ path: this.inputDocx}, options)
      .then((result) => {
        this.html = result.value
        let html = result.value; // The generated HTML
        let messages = result.messages; // Any messages, such as warnings during conversion
        Logger.info(`convertToHtml html: ${html}`);
        Logger.info(`convertToHtml messages: ${JSON.stringify(messages)}`);
        this.md = "";
        writeFile(this.filesDir, this.webSrc, this.html);
        this.dialogController?.open();
      })
      .catch((error: BusinessError) => {
        Logger.error(`convertToHtml html, error.message: ${error.message}`);
        Logger.error(`convertToHtml html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  convertToMarkdown(options: Options) {
    mammoth.convertToMarkdown({ path: this.inputDocx}, options)
      .then((result) => {
        let html = result.value; // The generated HTML
        let messages = result.messages; // Any messages, such as warnings during conversion
        console.info(`convertToMarkdown html: ${html}`);
        console.info(`convertToMarkdown messages: ${JSON.stringify(messages)}`);
        this.md = result.value;
        this.dialogController?.open();
      })
      .catch((error: BusinessError) => {
        console.error(`convertToMarkdown html, error.message: ${error.message}`);
        console.error(`convertToMarkdown html, error.stack: ${JSON.stringify(error.message)}`);
      });
  }

  build() {
    Scroll() {
      Column() {
        Text("ConvertImage Test")
          .width("100%")
          .fontSize(30)
          .textAlign(TextAlign.Center)

        // convert
        Column() {
          Text("part1: convert")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .width("90%")
            .margin({ bottom: 10, top: 30 })

          Text($r("app.string.convertImag_dataUri_text"))
          Button("convert>dataUri")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.dataUri
              }
              this.convert(option)
            })

          Text($r("app.string.convertImag_imgElement_read_text"))
          Button("convert>imgElement>read")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image: Image) => {
                  return image.read("base64").then((base64String: string) => {
                    let srcData: SrcData = {
                      src: "data:image/png;base64," + base64String
                    }
                    return srcData
                  })
                })
              }
              this.convert(option)
            })

          Text($r("app.string.convertImag_imgElement_readAsArrayBuffer_text"))
          Button("convert>imgElement--readAsArrayBuffer")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsArrayBuffer().then((imageBuffer) => {
                    let base64Str: string = buffer.from(imageBuffer).toString('base64');
                    let srcData: SrcData = {
                      src: "data:image/png;base64," + base64Str
                    }
                    return srcData
                  })
                })
              }
              this.convert(option)
            })

          Text($r("app.string.convertImag_imgElement_readAsBase64String_text"))
          Button("convert>imgElement>readAsBase64String")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsBase64String().then((base64) => {
                    let srcData: SrcData = {
                      src: "data:" + image.contentType + ";base64," + base64
                    }
                    return srcData
                  })
                })
              }
              this.convert(option)
            })

          Text($r("app.string.convertImag_imgElement_readAsBuffer_text"))
          Button("convert>imgElement>readAsBuffer")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsBuffer().then((buf) => {
                    let base64Str: string = buffer.from(buf).toString('base64');
                    let srcData: SrcData = {
                      src: "data:image/png;base64," + base64Str
                    }
                    return srcData
                  })
                })
              }
              this.convert(option)
            })

          Text($r("app.string.convertImag_imgElement_replace_text"))
          Button($r("app.string.convertImag_replace_text"))
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsArrayBuffer().then((imageBuffer) => {
                    let content = this.context!.resourceManager.getRawFileContentSync("dog.jpg");
                    let base64Str: string = buffer.from(content.buffer).toString('base64');
                    let srcData: SrcData = {
                      src: "data:image/png;base64," + base64Str
                    }
                    return srcData
                  })
                })
              }
              this.convert(option)
            })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ top: 20})

        // convertToHtml
        Column() {
          Text("part2: convertToHtml")
            .fontWeight(FontWeight.Bold)
            .fontSize(20)
            .margin({ bottom: 10 })

          Text($r("app.string.convertImag_dataUri_text"))
          Button("Html>dataUri")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.dataUri
              }
              this.convertToHtml(option)
            })

          Text($r("app.string.convertImag_imgElement_read_text"))
          Button("Html>imgElement>read")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image: ESObject) => {
                  return image.read("base64").then((base64String: string) => {
                    let srcData: SrcData = {
                      src: "data:image/png;base64," +base64String
                    }
                    return srcData
                  })
                })
              }
              this.convertToHtml(option)
            })

          Text($r("app.string.convertImag_imgElement_readAsArrayBuffer_text"))
          Button("Html>imgElement--readAsArrayBuffer")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsArrayBuffer().then((imageBuffer) => {
                    let base64Str: string = buffer.from(imageBuffer).toString('base64');
                    let srcData: SrcData = {
                      src: "data:image/png;base64," + base64Str
                    }
                    return srcData
                  })
                })
              }
              this.convertToHtml(option)
            })

          Text($r("app.string.convertImag_imgElement_readAsBase64String_text"))
          Button("Html>imgElement>readAsBase64String")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsBase64String().then((base64) => {
                    let srcData: SrcData = {
                      src: "data:" + image.contentType + ";base64," + base64
                    }
                    return srcData
                  })
                })
              }
              this.convertToHtml(option)
            })

          Text($r("app.string.convertImag_imgElement_readAsBuffer_text"))
          Button("Html>imgElement>readAsBuffer")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsBuffer().then((buf) => {
                    let base64Str: string = buffer.from(buf).toString('base64');
                    let srcData: SrcData = {
                      src: "data:image/png;base64," + base64Str
                    }
                    return srcData
                  })
                })
              }
              this.convertToHtml(option)
            })

          Text($r("app.string.convertImag_imgElement_replace_text"))
          Button($r("app.string.convertImag_replace_text"))
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsArrayBuffer().then((imageBuffer) => {
                    let content = this.context!.resourceManager.getRawFileContentSync("dog.jpg");
                    let base64Str: string = buffer.from(content.buffer).toString('base64');
                    let srcData: SrcData = {
                      src: "data:image/png;base64," + base64Str
                    }
                    return srcData
                  })
                })
              }
              this.convertToHtml(option)
            })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ top: 20})

        // convertToMarkdown
        Column() {
          Text("part3: convertToMarkdown")
            .fontWeight(FontWeight.Bold)
            .fontSize(20)
            .width("90%")
            .margin({ bottom: 10, top: 30 })

          Text($r("app.string.convertImag_dataUri_text"))
          Button("Markdown>dataUri")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.dataUri
              }
              this.convertToMarkdown(option)
            })

          Text($r("app.string.convertImag_imgElement_read_text"))
          Button("Markdown>imgElement>read")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image: ESObject) => {
                  return image.read("base64").then((base64String: string) => {
                    let srcData: SrcData = {
                      src: "data:image/png;base64," + base64String
                    }
                    return srcData
                  })
                })
              }
              this.convertToMarkdown(option)
            })

          Text($r("app.string.convertImag_imgElement_readAsArrayBuffer_text"))
          Button("Markdown>imgElement--readAsArrayBuffer")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsArrayBuffer().then((imageBuffer) => {
                    let base64Str: string = buffer.from(imageBuffer).toString('base64');
                    let srcData: SrcData = {
                      src: "data:image/png;base64," + base64Str
                    }
                    return srcData
                  })
                })
              }
              this.convertToMarkdown(option)
            })

          Text($r("app.string.convertImag_imgElement_readAsBase64String_text"))
          Button("Markdown>imgElement>readAsBase64String")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsBase64String().then((base64) => {
                    let srcData: SrcData = {
                      src: "data:" + image.contentType + ";base64," + base64
                    }
                    return srcData
                  })
                })
              }
              this.convertToMarkdown(option)
            })

          Text($r("app.string.convertImag_imgElement_readAsBuffer_text"))
          Button("Markdown>imgElement>readAsBuffer")
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsBuffer().then((buf) => {
                    let base64Str: string = buffer.from(buf).toString('base64');
                    let srcData: SrcData = {
                      src: "data:image/png;base64," + base64Str
                    }
                    return srcData
                  })
                })
              }
              this.convertToMarkdown(option)
            })

          Text($r("app.string.convertImag_imgElement_replace_text"))
          Button($r("app.string.convertImag_replace_text"))
            .margin({ top: 10, bottom: 10 })
            .width("90%")
            .onClick(() => {
              let option: Options = {
                convertImage: mammoth.images.imgElement((image) => {
                  return image.readAsArrayBuffer().then((imageBuffer) => {
                    let content = this.context!.resourceManager.getRawFileContentSync("dog.jpg");
                    let base64Str: string = buffer.from(content.buffer).toString('base64');
                    let srcData: SrcData = {
                      src: "data:image/png;base64," + base64Str
                    }
                    return srcData
                  })
                })
              }
              this.convertToMarkdown(option)
            })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ top: 20})
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .padding(20)
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
    .width('100%')
  }
}