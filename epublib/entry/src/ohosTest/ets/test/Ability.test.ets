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
const HTTP_COUNT: number = 2;

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

    it('readEpubFile', 0,async (done:Function)=> {
      let startTime = new Date().getTime()
      console.log( "readEpubFile:startTime: " + startTime)
      let configUrlTest: (index: number) => void = async (index) => {
        EpubReader.readEpubFile(filePath)
        if(index < HTTP_COUNT){
          configUrlTest(index + 1)
        }else{
          let endTime = new Date().getTime()
          console.log( "readEpubFile:endTime: " + endTime)
          let averageTime = (endTime - startTime) * 1000/ HTTP_COUNT
          console.log( "readEpubFile averageTime: " + averageTime + ' μs')
          done()
        }
      }
      configUrlTest(0)
      let readEpubFile = EpubReader.readEpubFile(filePath)
      expect(readEpubFile.getResources().isEmpty()).assertTrue()
    })

    it('readEpubFile_err_path', 0, async (done:Function)=> {
      let startTime = new Date().getTime()
      console.log( "readEpubFile_err_path:startTime: " + startTime)
      let configUrlTest: (index: number) => void = async (index) => {
        EpubReader.readEpubFile('/data/storage/el2/base/haps/entry_test/files/abc/')
        if(index < HTTP_COUNT){
          configUrlTest(index + 1)
        }else{
          let endTime = new Date().getTime()
          console.log( "readEpubFile_err_path:endTime: " + endTime)
          let averageTime = (endTime - startTime) * 1000/ HTTP_COUNT
          console.log( "readEpubFile_err_path averageTime: " + averageTime + ' μs')
          done()
        }
      }
      configUrlTest(0)
      let readEpubFile = EpubReader.readEpubFile('/data/storage/el2/base/haps/entry_test/files/abc/')
      expect(readEpubFile).assertUndefined()
    })

    it('readEpubFile_null', 0, async (done:Function)=> {
      let startTime = new Date().getTime()
      console.log( "readEpubFile_null:startTime: " + startTime)
      let configUrlTest: (index: number) => void = async (index) => {
        EpubReader.readEpubFile(null)
        if(index < HTTP_COUNT){
          configUrlTest(index + 1)
        }else{
          let endTime = new Date().getTime()
          console.log( "readEpubFile_null:endTime: " + endTime)
          let averageTime = (endTime - startTime) * 1000/ HTTP_COUNT
          console.log( "readEpubFile_null averageTime: " + averageTime + ' μs')
          done()
        }
      }
      configUrlTest(0)
      let readEpubFile = EpubReader.readEpubFile(null)
      expect(readEpubFile).assertUndefined()
    })

    it('readEpubFile_empty', 0, async (done:Function)=> {
      let startTime = new Date().getTime()
      console.log( "readEpubFile_empty:startTime: " + startTime)
      let configUrlTest: (index: number) => void = async (index) => {
        EpubReader.readEpubFile('')
        if(index < HTTP_COUNT){
          configUrlTest(index + 1)
        }else{
          let endTime = new Date().getTime()
          console.log( "readEpubFile_empty:endTime: " + endTime)
          let averageTime = (endTime - startTime) * 1000/ HTTP_COUNT
          console.log( "readEpubFile_empty averageTime: " + averageTime + ' μs')
          done()
        }
      }
      configUrlTest(0)
      let readEpubFile = EpubReader.readEpubFile('')
      expect(readEpubFile).assertUndefined()
    })

    it('loadResourcesZip', 0, async (done:Function)=> {
      let startTime = new Date().getTime()
      console.log( "loadResourcesZip:startTime: " + startTime)
      let configUrlTest: (index: number) => void = async (index) => {
        ResourcesLoader.loadResourcesZip(filePath)
        if(index < HTTP_COUNT){
          configUrlTest(index + 1)
        }else{
          let endTime = new Date().getTime()
          console.log( "loadResourcesZip:endTime: " + endTime)
          let averageTime = (endTime - startTime) * 1000/ HTTP_COUNT
          console.log( "loadResourcesZip averageTime: " + averageTime + ' μs')
          done()
        }

      }
      configUrlTest(0)
      let zip = await ResourcesLoader.loadResourcesZip(filePath)
      expect(zip).assertEqual('/data/storage/el2/base/haps/entry_test/files/abc')
    })

    it('loadResourcesZip_err_path', 0, async (done:Function)=> {
      let startTime = new Date().getTime()
      console.log( "loadResourcesZip_err_path:startTime: " + startTime)
      let configUrlTest: (index: number) => void = async (index) => {
        ResourcesLoader.loadResourcesZip(filePath + 'test')
        if(index < HTTP_COUNT){
          configUrlTest(index + 1)
        }else{
          let endTime = new Date().getTime()
          console.log( "loadResourcesZip_err_path:endTime: " + endTime)
          let averageTime = (endTime - startTime) * 1000/ HTTP_COUNT
          console.log( "loadResourcesZip_err_path averageTime: " + averageTime + ' μs')
          done()
        }
      }
      configUrlTest(0)
      let zip = await ResourcesLoader.loadResourcesZip(filePath + 'test')
      expect(zip).assertNull()
    })

    it('loadResourcesZip_null', 0, async (done:Function)=> {
      let startTime = new Date().getTime()
      console.log( "loadResourcesZip_null:startTime: " + startTime)
      let configUrlTest: (index: number) => void = async (index) => {
        ResourcesLoader.loadResourcesZip(null)
        if(index < HTTP_COUNT){
          configUrlTest(index + 1)
        }else{
          let endTime = new Date().getTime()
          console.log( "loadResourcesZip_null:endTime: " + endTime)
          let averageTime = (endTime - startTime) * 1000/ HTTP_COUNT
          console.log( "loadResourcesZip_null averageTime: " + averageTime + ' μs')
          done()
        }
      }
      configUrlTest(0)
      try {
        await ResourcesLoader.loadResourcesZip(null)
      } catch (e) {
        expect(e.message).assertEqual('Cannot read property toLowerCase of null')
      }
    })

    it('loadResourcesZip_empty', 0, async (done:Function)=> {
      let startTime = new Date().getTime()
      console.log( "loadResourcesZip_empty:startTime: " + startTime)
      let configUrlTest: (index: number) => void = async (index) => {
        ResourcesLoader.loadResourcesZip('')
        if(index < HTTP_COUNT){
          configUrlTest(index + 1)
        }else{
          let endTime = new Date().getTime()
          console.log( "loadResourcesZip_empty:endTime: " + endTime)
          let averageTime = (endTime - startTime) * 1000/ HTTP_COUNT
          console.log( "loadResourcesZip_empty averageTime: " + averageTime + ' μs')
          done()
        }
      }
      configUrlTest(0)
      let zip = await ResourcesLoader.loadResourcesZip('')
      expect(zip).assertNull()
    })

    it('outFile', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("outFile:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.outFile(filePath);
      }
      endTime(startTime, 'outFile');
      let outfile = EpubReader.outFile(filePath)
      expect(outfile).assertEqual('/data/storage/el2/base/haps/entry_test/files/abc')
    })

    it('outFile_null', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("outFile_null:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.outFile(null);
      }
      endTime(startTime, 'outFile_null');
      try {
        EpubReader.outFile(null)
      } catch (e) {
        expect(e.message).assertEqual('Cannot read property substring of null')
      }
    })

    it('outFile_undefined', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("outFile_undefined:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.outFile(undefined);
      }
      endTime(startTime, 'outFile_undefined');
      try {
        EpubReader.outFile(undefined)
      } catch (e) {
        expect(e.message).assertEqual('Cannot read property substring of undefined')
      }
    })

    it('outFile_empty', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("outFile_empty:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.outFile('');
      }
      endTime(startTime, 'outFile_empty');
      let outfile = EpubReader.outFile('')
      expect(outfile).assertEqual('')
    })

    it('createResource', 0, ()=> {
      let buf = new ArrayBuffer(10);
      let startTime = new Date().getTime();
      console.log("createResource:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createResource("content.opf", new Uint8Array(buf));
      }
      endTime(startTime, 'createResource');
      let resource: EpubResource = ResourceUtil.createResource("content.opf", new Uint8Array(buf));
      expect(resource.getHref()).assertEqual('content.opf')
    })

    it('createResource_null', 0, ()=> {
      let buf = new ArrayBuffer(10);
      let startTime = new Date().getTime();
      console.log("createResource_null:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createResource(null, new Uint8Array(buf));
      }
      endTime(startTime, 'createResource_null');
      let resource: EpubResource = ResourceUtil.createResource(null, new Uint8Array(buf));
      expect(resource.getHref()).assertNull()
    })

    it('createResource_undefined', 0, ()=> {
      let buf = new ArrayBuffer(10);
      let startTime = new Date().getTime();
      console.log("createResource_undefined:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createResource(undefined, new Uint8Array(buf));
      }
      endTime(startTime, 'createResource_undefined');
      let resource: EpubResource = ResourceUtil.createResource(undefined, new Uint8Array(buf));
      expect(resource.getHref()).assertUndefined()
    })

    it('createResource_undefined_empty', 0, ()=> {
      let buf = new ArrayBuffer(10);
      let startTime = new Date().getTime();
      console.log("createResource_undefined_empty:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createResource('', new Uint8Array(buf));
      }
      endTime(startTime, 'createResource_undefined_empty');
      let resource: EpubResource = ResourceUtil.createResource('', new Uint8Array(buf));
      expect(resource.getHref()).assertEqual('')
    })

    it('createStrResource', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("createStrResource:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createStrResource("content.opf", "data");
      }
      endTime(startTime, 'createStrResource');
      let strResource: EpubResource = ResourceUtil.createStrResource("content.opf", "data");
      expect(strResource.getHref()).assertEqual('content.opf')
    })

    it('createStrResource_null', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("createStrResource_null:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createStrResource(null, "data");
      }
      endTime(startTime, 'createStrResource_null');
      let strResource: EpubResource = ResourceUtil.createStrResource(null, "data");
      expect(strResource.getHref()).assertNull()
    })

    it('createStrResource_undefined', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("createStrResource_undefined:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createStrResource(undefined, "data");
      }
      endTime(startTime, 'createStrResource_undefined');
      let strResource: EpubResource = ResourceUtil.createStrResource(undefined, "data");
      expect(strResource.getHref()).assertUndefined()
    })

    it('createStrResource_empty', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("createStrResource_empty:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.createStrResource("", "");
      }
      endTime(startTime, 'createStrResource_empty');
      let strResource: EpubResource = ResourceUtil.createStrResource("", "");
      expect(strResource.getHref()).assertEqual('')
    })

    it('decode', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("decode:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.decode(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9]));
      }
      endTime(startTime, 'decode');
      let decode = ResourceUtil.decode(new Uint8Array([1, 2, 3, 4, 5, 6, 7, 8, 9]))
      expect(decode).assertEqual("\u0001\u0002\u0003\u0004\u0005\u0006\u0007\b\t")
    })

    it('decode_complexity', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("decode_complexity:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourceUtil.decode(new Uint8Array([19, 28, 37, 46, 55, 64, 73, 82, 91]))
      }
      endTime(startTime, 'decode_complexity');
      let decode = ResourceUtil.decode(new Uint8Array([19, 28, 37, 46, 55, 64, 73, 82, 91]))
      expect(decode).assertEqual("\u0013\u001c%.7@IR[")
    })

    it('decode_null', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("decode_null:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          ResourceUtil.decode(null)
        } catch (e) {
          expect(e.message).assertEqual('The type of Parameter must be Uint8Array.')
        }
      }
      endTime(startTime, 'decode_null');
      try {
        ResourceUtil.decode(null)
      } catch (e) {
        expect(e.message).assertEqual('The type of Parameter must be Uint8Array.')
      }
    })

    it('decode_undefined', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("decode_undefined:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        try {
          ResourceUtil.decode(undefined)
        } catch (e) {
          expect(e.message).assertEqual('The type of Parameter must be Uint8Array.')
        }
      }
      endTime(startTime, 'decode_undefined');
      try {
        ResourceUtil.decode(undefined)
      } catch (e) {
        expect(e.message).assertEqual('The type of Parameter must be Uint8Array.')
      }
    })

    it('readEpubLazy', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("readEpubLazy:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubLazy(filePath)
      }
      endTime(startTime, 'readEpubLazy');
      let book = EpubReader.readEpubLazy(filePath)
      expect(book.getResources().isEmpty()).assertTrue()
    })

    it('readEpubLazy_null', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("readEpubLazy_null:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubLazy(null)
      }
      endTime(startTime, 'readEpubLazy_null');
      let book = EpubReader.readEpubLazy(null)
      expect(book.getResources().isEmpty()).assertTrue()
    })

    it('readEpubLazy_undefined', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("readEpubLazy_undefined:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubLazy(undefined)
      }
      endTime(startTime, 'readEpubLazy_undefined');
      let book = EpubReader.readEpubLazy(undefined)
      expect(book.getResources().isEmpty()).assertTrue()
    })

    it('readEpubLazy_empty', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("readEpubLazy_empty:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubLazy('');
      }
      endTime(startTime, 'readEpubLazy_empty');
      let book = EpubReader.readEpubLazy('')
      expect(book.getResources().isEmpty()).assertTrue()
    })

    it('loadResources', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("loadResources:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourcesLoader.loadResources(filePath, 'UTF-8');
      }
      endTime(startTime, 'loadResources');
      let resources = ResourcesLoader.loadResources(filePath, 'UTF-8')
      expect(resources.isEmpty()).assertTrue()
    })

    it('loadResources_null', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("loadResources_null:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourcesLoader.loadResources(null, 'UTF-8');
      }
      endTime(startTime, 'loadResources_null');
      let resources = ResourcesLoader.loadResources(null, 'UTF-8')
      expect(resources.isEmpty()).assertTrue()
    })

    it('loadResources_undefined', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("loadResources_undefined:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourcesLoader.loadResources(undefined, 'UTF-8');
      }
      endTime(startTime, 'loadResources_undefined');
      let resources = ResourcesLoader.loadResources(undefined, 'UTF-8')
      expect(resources.isEmpty()).assertTrue()
    })

    it('loadResources_empty', 0, ()=> {
      let startTime = new Date().getTime();
      console.log("loadResources_empty:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        ResourcesLoader.loadResources('', 'UTF-8');
      }
      endTime(startTime, 'loadResources_empty');
      let resources = ResourcesLoader.loadResources('', 'UTF-8')
      expect(resources.isEmpty()).assertTrue()
    })

    it('readEpubToBook', 0, ()=> {
      let resources = ResourcesLoader.loadResources(filePath, 'UTF-8')
      let book = EpubReader.readEpubToBook(resources)
      let startTime = new Date().getTime();
      console.log("readEpubToBook:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubToBook(resources);
      }
      endTime(startTime, 'readEpubToBook');
      expect(book.getMetadata().getAuthors().length).assertEqual(0)
    })

    it('readEpubToBook_null', 0, ()=> {
      let resources = ResourcesLoader.loadResources(null, 'UTF-8')
      let book = EpubReader.readEpubToBook(resources)
      let startTime = new Date().getTime();
      console.log("readEpubToBook_null:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubToBook(resources);
      }
      endTime(startTime, 'readEpubToBook_null');
      expect(book.getMetadata().getAuthors().length).assertEqual(0)
    })

    it('readEpubToBook_undefined', 0, ()=> {
      let resources = ResourcesLoader.loadResources(undefined, 'UTF-8')
      let book = EpubReader.readEpubToBook(resources)
      let startTime = new Date().getTime();
      console.log("readEpubToBook_undefined:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubToBook(resources);
      }
      endTime(startTime, 'readEpubToBook_undefined');
      expect(book.getMetadata().getAuthors().length).assertEqual(0)
    })

    it('readEpubToBook_empty', 0, ()=> {
      let resources = ResourcesLoader.loadResources('', 'UTF-8')
      let book = EpubReader.readEpubToBook(resources)
      let startTime = new Date().getTime();
      console.log("readEpubToBook_empty:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        EpubReader.readEpubToBook(resources);
      }
      endTime(startTime, 'readEpubToBook_empty');
      expect(book.getMetadata().getAuthors().length).assertEqual(0)
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
      let startTime = new Date().getTime();
      console.log("EpubWriter:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        epubWriter.write(book, "test1_book1.epub");
      }
      endTime(startTime, 'EpubWriter');
      let bookReader = EpubReader.readEpubToBook(resources)
      expect(bookReader != null).assertTrue()
    })

    it('EpubWriter_null', 0, ()=> {
      let epubWriter = new EpubWriter();
      // Write the Book as Epub
      epubWriter.write(null, "test1_book1.epub");
      let startTime = new Date().getTime();
      console.log("EpubWriter_null:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        epubWriter.write(null, "test1_book1.epub");
      }
      endTime(startTime, 'EpubWriter_null');
      let bookReader = EpubReader.readEpubToBook(resources)
      expect(bookReader != null).assertTrue()
    })

    it('EpubWriter_undefined', 0, ()=> {
      let epubWriter = new EpubWriter();
      // Write the Book as Epub
      epubWriter.write(undefined, "test1_book1.epub");
      let startTime = new Date().getTime();
      console.log("EpubWriter_undefined:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        epubWriter.write(undefined, "test1_book1.epub");
      }
      endTime(startTime, 'EpubWriter_undefined');
      let bookReader = EpubReader.readEpubToBook(resources)
      expect(bookReader != null).assertTrue()
    })

    it('EpubWriter_err', 0, ()=> {
      let epubWriter = new EpubWriter();
      // Write the Book as Epub
      epubWriter.write(book, "");
      let startTime = new Date().getTime();
      console.log("EpubWriter_err:startTime:" + startTime)
      for (let index = 0; index < BASE_COUNT; index++) {
        epubWriter.write(book, "");
      }
      endTime(startTime, 'EpubWriter_err');
      let bookReader = EpubReader.readEpubToBook(resources)
      expect(bookReader != null).assertTrue()
    })
  })
}

function endTime(startTime: number, tag: string) {
  let endTime: number = new Date().getTime();
  let averageTime = ((endTime - startTime) * 1000 / BASE_COUNT)
  console.log(tag + ":endTime:" + endTime)
  console.log(tag + ":averageTime:" + averageTime + "μs");
}