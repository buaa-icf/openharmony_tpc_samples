/*
 * GNU LESSER GENERAL PUBLIC LICENSE
 * Version 3, 29 June 2007
 *
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * The Free Software Foundation may publish revised and/or new versions of the GNU Lesser
 * General Public License from time to time. Such new versions will be similar in spirit to the
 * present version, but may differ in detail to address new problems or concerns.

 * Each version is given a distinguishing version number. If the Library as you received it
 * specifies that a certain numbered version of the GNU Lesser General Public License “or any
 * later version” applies to it, you have the option of following the terms and conditions either
 * of that published version or of any later version published by the Free Software Foundation. If
 * the Library as you received it does not specify a version number of the GNU Lesser General
 * Public License, you may choose any version of the GNU Lesser General Public License ever
 * published by the Free Software Foundation.

 * If the Library as you received it specifies that a proxy can decide whether future versions of
 * the GNU Lesser General Public License shall apply, that proxy's public statement of
 * acceptance of any version is permanent authorization for you to choose that version
 * for the Library.
 */

import {
  Author,
  Book,
  EpubReader,
  EpubResource,
  EpubWriter,
  GlobalContext,
  MediaType,
  Metadata,
  ResourcesLoader
} from '@ohos/epublib';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import fs from '@ohos.file.fs';
import ResourceUtil from '@ohos/epublib/src/main/ets/components/util/ResourceUtil';
const BASE_COUNT: number = 2000;
let filePath: string = ''
export default function abilityTest() {
  describe('ActsAbilityTest',  ()=> {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      filePath = GlobalContext.getContext().getValue('filePath') as string
      let buffer: ArrayBufferLike = GlobalContext.getContext().getValue('buffer') as ArrayBufferLike
      filePath = filePath + '/abc.epub'
      let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.writeSync(file.fd, buffer)
      fs.closeSync(file);
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(()=> {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(()=> {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(()=> {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('readEpubFile', 0, async ()=> {
      let readEpubFile = EpubReader.readEpubFile(filePath)
      expect(readEpubFile.getResources().isEmpty()).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubFile(filePath)
      }
      endTime(startTime,'readEpubFile');
    })

    it('readEpubFile_err_path', 0, async ()=> {
      let readEpubFile = EpubReader.readEpubFile('/data/storage/el2/base/haps/entry_test/files/abc/')
      expect(readEpubFile).assertUndefined()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubFile('/data/storage/el2/base/haps/entry_test/files/abc/')
      }
      endTime(startTime,'readEpubFile_err_path');
    })

    it('readEpubFile_null', 0, async ()=> {
      let readEpubFile = EpubReader.readEpubFile(null)
      expect(readEpubFile).assertUndefined()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubFile(null)
      }
      endTime(startTime,'readEpubFile_null');
    })

    it('readEpubFile_empty', 0, async ()=> {
      let readEpubFile = EpubReader.readEpubFile('')
      expect(readEpubFile).assertUndefined()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubFile('')
      }
      endTime(startTime,'readEpubFile_empty');
    })

    it('loadResourcesZip', 0, async ()=> {
      let zip = await ResourcesLoader.loadResourcesZip(filePath)
      expect(zip).assertEqual('/data/storage/el2/base/haps/entry_test/files/abc')
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        await ResourcesLoader.loadResourcesZip(filePath)
      }
      endTime(startTime,'loadResourcesZip');
    })

    it('loadResourcesZip_err_path', 0, async ()=> {
      let zip = await ResourcesLoader.loadResourcesZip(filePath + 'test')
      expect(zip).assertNull()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        await ResourcesLoader.loadResourcesZip(filePath + 'test')
      }
      endTime(startTime,'loadResourcesZip_err_path');
    })

    it('loadResourcesZip_null', 0, async ()=> {
      try {
        await ResourcesLoader.loadResourcesZip(null)
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          await ResourcesLoader.loadResourcesZip(null)
        }
        endTime(startTime,'loadResourcesZip_null');
      } catch (e) {
        expect(e.message).assertEqual('Cannot read property toLowerCase of null')
      }
    })

    it('loadResourcesZip_empty', 0, async ()=> {
      let zip = await ResourcesLoader.loadResourcesZip('')
      expect(zip).assertNull()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        await ResourcesLoader.loadResourcesZip('')
      }
      endTime(startTime,'loadResourcesZip_empty');
    })

    it('outFile', 0, ()=> {
      let outfile = EpubReader.outFile(filePath)
      expect(outfile).assertEqual('/data/storage/el2/base/haps/entry_test/files/abc')
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.outFile(filePath)
      }
      endTime(startTime,'outFile');
    })

    it('outFile_null', 0, ()=> {
      try {
        EpubReader.outFile(null)
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          EpubReader.outFile(null)
        }
        endTime(startTime,'outFile_null');
      } catch (e) {
        expect(e.message).assertEqual('Cannot read property substring of null')
      }
    })

    it('outFile_undefined', 0, ()=> {
      try {
        EpubReader.outFile(undefined)
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          EpubReader.outFile(undefined)
        }
        endTime(startTime,'outFile_undefined');
      } catch (e) {
        expect(e.message).assertEqual('Cannot read property substring of undefined')
      }
    })

    it('outFile_empty', 0, ()=> {
      let outfile = EpubReader.outFile('')
      expect(outfile).assertEqual('')
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.outFile('')
      }
      endTime(startTime,'outFile_empty');
    })

    it('createResource', 0, ()=> {
      let buf = new ArrayBuffer(10);
      let resource: EpubResource = ResourceUtil.createResource("content.opf", new Uint8Array(buf));
      expect(resource.getHref()).assertEqual('content.opf')
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createResource("content.opf", new Uint8Array(buf));
      }
      endTime(startTime,'createResource');
    })

    it('createResource_null', 0, ()=> {
      let buf = new ArrayBuffer(10);
      let resource: EpubResource = ResourceUtil.createResource(null, new Uint8Array(buf));
      expect(resource.getHref()).assertNull()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createResource(null, new Uint8Array(buf));
      }
      endTime(startTime,'createResource_null');
    })

    it('createResource_undefined', 0, ()=> {
      let buf = new ArrayBuffer(10);
      let resource: EpubResource = ResourceUtil.createResource(undefined, new Uint8Array(buf));
      expect(resource.getHref()).assertUndefined()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createResource(undefined, new Uint8Array(buf));
      }
      endTime(startTime,'createResource_undefined');
    })

    it('createResource_undefined_empty', 0, ()=> {
      let buf = new ArrayBuffer(10);
      let resource: EpubResource = ResourceUtil.createResource('', new Uint8Array(buf));
      expect(resource.getHref()).assertEqual('')
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createResource('', new Uint8Array(buf));
      }
      endTime(startTime,'createResource_undefined_empty');
    })

    it('createStrResource', 0, ()=> {
      let strResource: EpubResource = ResourceUtil.createStrResource("content.opf", "data");
      expect(strResource.getHref()).assertEqual('content.opf')
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createStrResource("content.opf", "data");
      }
      endTime(startTime,'createStrResource');
    })

    it('createStrResource_null', 0, ()=> {
      let strResource: EpubResource = ResourceUtil.createStrResource(null, "data");
      expect(strResource.getHref()).assertNull()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createStrResource(null, "data");
      }
      endTime(startTime,'createStrResource_null');
    })

    it('createStrResource_undefined', 0, ()=> {
      let strResource: EpubResource = ResourceUtil.createStrResource(undefined, "data");
      expect(strResource.getHref()).assertUndefined()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createStrResource(undefined, "data");
      }
      endTime(startTime,'createStrResource_undefined');
    })

    it('createStrResource_empty', 0, ()=> {
      let strResource: EpubResource = ResourceUtil.createStrResource("", "");
      expect(strResource.getHref()).assertEqual('')
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createStrResource("", "");
      }
      endTime(startTime,'createStrResource_empty');
    })

    it('decode', 0, ()=> {
      let decode = ResourceUtil.decode(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9]))
      expect(decode).assertEqual("\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t")
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.decode(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9]))
      }
      endTime(startTime,'decode');
    })

    it('decode_complexity', 0, ()=> {
      let decode = ResourceUtil.decode(new Uint8Array([19, 28, 37, 46, 55, 64, 73, 82, 91]))
      expect(decode).assertEqual("\u0013\u001c%.7@IR[")
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.decode(new Uint8Array([19, 28, 37, 46, 55, 64, 73, 82, 91]))
      }
      endTime(startTime,'decode_complexity');
    })

    it('decode_null', 0, ()=> {
      try {
        ResourceUtil.decode(null)
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          ResourceUtil.decode(null)
        }
        endTime(startTime,'decode_null');
      } catch (e) {
        expect(e.message).assertEqual('Parameter error. The type of Parameter must be Uint8Array.')
      }
    })

    it('decode_undefined', 0, ()=> {
      try {
        ResourceUtil.decode(undefined)
        let startTime = new Date().getTime()
        for (let index = 0; index < BASE_COUNT; index++) {
          ResourceUtil.decode(undefined)
        }
        endTime(startTime,'decode_undefined');
      } catch (e) {
        expect(e.message).assertEqual('Parameter error. The type of Parameter must be Uint8Array.')
      }
    })

    it('readEpubLazy', 0, ()=> {
      let book = EpubReader.readEpubLazy(filePath)
      expect(book.getResources().isEmpty()).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubLazy(filePath)
      }
      endTime(startTime,'readEpubLazy');
    })

    it('readEpubLazy_null', 0, ()=> {
      let book = EpubReader.readEpubLazy(null)
      expect(book.getResources().isEmpty()).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubLazy(null)
      }
      endTime(startTime,'readEpubLazy_null');
    })

    it('readEpubLazy_undefined', 0, ()=> {
      let book = EpubReader.readEpubLazy(undefined)
      expect(book.getResources().isEmpty()).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubLazy(undefined)
      }
      endTime(startTime,'readEpubLazy_undefined');
    })

    it('readEpubLazy_empty', 0, ()=> {
      let book = EpubReader.readEpubLazy('')
      expect(book.getResources().isEmpty()).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubLazy('')
      }
      endTime(startTime,'readEpubLazy_empty');
    })

    it('loadResources', 0, ()=> {
      let resources = ResourcesLoader.loadResources(filePath, 'UTF-8')
      expect(resources.isEmpty()).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourcesLoader.loadResources(filePath, 'UTF-8')
      }
      endTime(startTime,'loadResources');
    })

    it('loadResources_null', 0, ()=> {
      let resources = ResourcesLoader.loadResources(null, 'UTF-8')
      expect(resources.isEmpty()).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourcesLoader.loadResources(null, 'UTF-8')
      }
      endTime(startTime,'loadResources_null');
    })

    it('loadResources_undefined', 0, ()=> {
      let resources = ResourcesLoader.loadResources(undefined, 'UTF-8')
      expect(resources.isEmpty()).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourcesLoader.loadResources(undefined, 'UTF-8')
      }
      endTime(startTime,'loadResources_undefined');
    })

    it('loadResources_empty', 0, ()=> {
      let resources = ResourcesLoader.loadResources('', 'UTF-8')
      expect(resources.isEmpty()).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourcesLoader.loadResources('', 'UTF-8')
      }
      endTime(startTime,'loadResources_empty');
    })

    it('readEpubToBook', 0, ()=> {
      let resources = ResourcesLoader.loadResources(filePath, 'UTF-8')
      let book = EpubReader.readEpubToBook(resources)
      expect(book.getMetadata().getAuthors().length).assertEqual(0)
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubToBook(resources)
      }
      endTime(startTime,'readEpubToBook');
    })

    it('readEpubToBook_null', 0, ()=> {
      let resources = ResourcesLoader.loadResources(null, 'UTF-8')
      let book = EpubReader.readEpubToBook(resources)
      expect(book.getMetadata().getAuthors().length).assertEqual(0)
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubToBook(resources)
      }
      endTime(startTime,'readEpubToBook_null');
    })

    it('readEpubToBook_undefined', 0, ()=> {
      let resources = ResourcesLoader.loadResources(undefined, 'UTF-8')
      let book = EpubReader.readEpubToBook(resources)
      expect(book.getMetadata().getAuthors().length).assertEqual(0)
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubToBook(resources)
      }
      endTime(startTime,'readEpubToBook_undefined');
    })

    it('readEpubToBook_empty', 0, ()=> {
      let resources = ResourcesLoader.loadResources('', 'UTF-8')
      let book = EpubReader.readEpubToBook(resources)
      expect(book.getMetadata().getAuthors().length).assertEqual(0)
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubToBook(resources)
      }
      endTime(startTime,'readEpubToBook_empty');
    })

    let book = new Book();
    // Set the title
    book.getMetadata().addTitle("Epublib test book 1");
    // Add an Author
    book.getMetadata().addAuthor(new Author("Joe", "Tester"));
    let res = new EpubResource("heft", new MediaType("name", "extend"))
    book.addResource(res)
    book.setMetadata(new Metadata())
    let resources = ResourcesLoader.loadResources('/data/storage/el2/base/haps/entry_test/files/test1_book1', 'UTF-8')

    it('EpubWriter', 0, ()=> {
      let epubWriter = new EpubWriter();
      // Write the Book as Epub
      epubWriter.write(book, "test1_book1.epub");
      let bookReader = EpubReader.readEpubToBook(resources)
      expect(bookReader != null).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        epubWriter.write(book, "test1_book1.epub");
      }
      endTime(startTime,'EpubWriter');
    })

    it('EpubWriter_null', 0, ()=> {
      let epubWriter = new EpubWriter();
      // Write the Book as Epub
      epubWriter.write(null, "test1_book1.epub");
      let bookReader = EpubReader.readEpubToBook(resources)
      expect(bookReader != null).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        epubWriter.write(null, "test1_book1.epub");
      }
      endTime(startTime,'EpubWriter_null');
    })

    it('EpubWriter_undefined', 0, ()=> {
      let epubWriter = new EpubWriter();
      // Write the Book as Epub
      epubWriter.write(undefined, "test1_book1.epub");
      let bookReader = EpubReader.readEpubToBook(resources)
      expect(bookReader != null).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        epubWriter.write(undefined, "test1_book1.epub");
      }
      endTime(startTime,'EpubWriter_undefined');
    })

    it('EpubWriter_err', 0, ()=> {
      let epubWriter = new EpubWriter();
      // Write the Book as Epub
      epubWriter.write(book, "");
      let bookReader = EpubReader.readEpubToBook(resources)
      expect(bookReader != null).assertTrue()
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        epubWriter.write(book, "");
      }
      endTime(startTime,'EpubWriter_err');
    })
  })
}

function endTime(startTime: number, tag: string) {
  console.log(tag + ":startTime:" + startTime)
  let endTime: number = new Date().getTime();
  let averageTime = ((endTime - startTime) * 1000 / BASE_COUNT)
  console.log(tag + ":endTime:" + endTime)
  console.log(tag + ":averageTime:" + averageTime + "μs");
}
