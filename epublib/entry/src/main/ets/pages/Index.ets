/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  DOMParser,
  EpubReader,
  EpubWriter,
  Book,
  Author,
  EpubResource,
  MediaType,
  Metadata,
  MediatypeService
} from "@ohos/epublib"
import util from '@ohos.util';
import prompt from '@ohos.promptAction';
import fs from '@ohos.file.fs';

@Entry
@Component
struct Index {
  srcStr = '<?xml version="1.0"?>' +
  '<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">' +
  '<rootfiles>' +
  '<rootfile full-path="content.opf" media-type="application/oebps-package+xml"/>' +
  '</rootfiles>' +
  '</container>';
  @State text: string = '-Epub-'
  result: any
  @State Compressbg: Color = Color.Blue
  @State Clickbg: Color = Color.Blue

  build() {
    Column() {

      Button('Compress')
        .backgroundColor(this.Compressbg)
        .width(150)
        .height(60)
        .onClick(() => {
          console.info("- St -");
          this.funcUnEpub(globalThis.filePath + "/epub-book.epub");
        })
        .onTouch(() => {
          this.Compressbg = Color.Orange
        })
      Button('Click')
        .backgroundColor(this.Clickbg)
        .width(150)
        .height(60)
        .onClick(() => {
          console.info("- St -");
          this.funcStart(globalThis.filePath + "/epub-book.epub");
        })
        .onTouch(() => {
          this.Clickbg = Color.Orange
        })
        .margin({ top: 10 })

      TextArea({ placeholder: this.text })
        .height('100%')
        .padding(15)
        .fontSize(50)
        .fontColor("#070707")
        .margin({ top: 30 })
    }.height(800).width('100%').padding(35).margin({ top: 30 })
  }

  test() {
    console.info("- Test to unit system lib.dow.d.ts of  getElementsByTagNameNS(namespaceURI: string, localName: string)-");
    let dataStr = this.readerFile(globalThis.filePath + "/test", "mimetype");
    let domParser = new DOMParser();
    this.result = domParser.parseFromString(dataStr + "");
    //       this.result = domParser.parseFromString(this.srcStr);

    this.text = this.result.toString();
  }

  funcUnEpub(input: string) {
    try {
      EpubReader.unEpub(input).then((data) => {
        console.log("----unEpub----successful-----------" + data)
      });
    } catch (err) {
      prompt.showToast({ message: 'no input file found',
        duration: 2000 });
      console.log("----unEpub----failed-----------" + err)
    }
  }

  funcStart(epubFile: string) {
    let book = EpubReader.readEpubFile(EpubReader.outFile(epubFile))

    if (book != undefined) {
      this.text = book.getResources()
        .getResourceMap()
        .get("chapter_446465249.xhtml")
        .getStrData()
        .toString();
      console.error("----index-result-------" + this.text)
      this.testEpubWriter(book)
    }
  }

  private testEpubWriter1() {
    let book = new Book();
    // Set the title
    book.getMetadata().addTitle("Epublib test book 1");
    // Add an Author
    book.getMetadata().addAuthor(new Author("Joe", "Tester"));
    let res = new EpubResource("heft", new MediaType("name", "extend"))
    book.addResource(res)
    book.setMetadata(new Metadata())
    // Create EpubWriter
    let epubWriter = new EpubWriter();

    // Write the Book as Epub
    epubWriter.write(book, "test1_book1.epub");

  }

  private testEpubWriter(book: Book) {
    let epubWriter = new EpubWriter();
    // Write the Book as Epub
    epubWriter.write(book, "test1_book1.epub");

  }

  private testFileIO2() {
    console.log('test start')
    console.info("------------getFilesDir dir: " + globalThis.filePath);
    //      此处返回为："/data/storage/el2/base/haps/entry/files"
    //      真实路径为（带包名）："/data/app/el2/100/base/com.example.epublib.hmservice/haps/entry/files"
    //      push时需要使用真实路径（带包名）
    //      注意：push后文件owner属性为root，需修改为与files相同的owner
    let fullPath = globalThis.filePath + "/test/chapter_446465249.xhtml";
    let fileFD = fs.openSync(fullPath, 0o2);
    console.info("------openSync fileFD:" + fileFD);
    let buf = new ArrayBuffer(4096);
    let num = fs.readSync(fileFD.fd, buf);
    let fileRet = this.a2s(buf);
    var textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    let strData = textDecoder.decodeWithStream(new Uint8Array(buf));
    let testStr = fs.readTextSync(fullPath, { encoding: 'utf-8' })
    console.info("----------readSync num:" + num + ", testStr:" + testStr)
    console.info("----------readSync num:" + num + ", testStr:" + strData)
  }

  private a2s(buf: ArrayBuffer): string {
    return String.fromCharCode.apply(null, new Uint8Array(buf));
  }

  private readerFile(dirPath: string, nameFile: string): string {
    let fullpath = dirPath + "/" + nameFile;
    console.debug("---------fullpath----" + fullpath);
    let stat = fs.statSync(fullpath);
    let strData = fs.readTextSync(fullpath, { encoding: 'utf-8' });
    return strData;
  }

  copyStr(src: string) {
    let str = ""
    for (let i = 0; i < src.length; i++) {
      str += src[i]
    }
    return str
  }
}