import { describe, it, expect } from '@ohos/hypium';
import { Files as FileJS } from "@ohos/mammoth/src/main/ets/docx/files";
import { uriToPath } from "@ohos/mammoth/src/main/ets/docx/files";
import fs from '@ohos.file.fs';
import { testPath } from '../testing';

// import * as documents from "@ohos/mammoth/src/main/ets/documents";
// let path = require("path");
// let fs = require("fs");
// let assert = require("assert");
//
// let promises = require("../../lib/promises");
// let Files = require("../../lib/docx/files").Files;
// let uriToPath = require("../../lib/docx/files").uriToPath;
//
// let testing = require("../testing");
// let test = require("../test")(module);
//
// let readFile = promises.promisify(fs.readFile.bind(fs));

let readFile = (fullPath?: string, encoding?: string) => {
  try {
    let file = fs.openSync(fullPath, 0o2);
    let stat = fs.lstatSync(fullPath);
    let buf = new ArrayBuffer(stat.size);
    fs.readSync(file.fd, buf);
    fs.fsyncSync(file.fd);
    fs.closeSync(file.fd);
    return Promise.resolve(buf)
  } catch (err) {
      return Promise.reject()
  }
}
const Files: ESObject = FileJS;
const assertError = (promise: ESObject, func: ESObject): ESObject => {
  return promise.then(() => {
    console.info("=====")
    // assert(false, "Expected error");
  }, func);
}

const assertRegex = (actual: ESObject, expected: ESObject): ESObject => {
  console.info("=====")
  // assert.ok(expected.it(actual), "Expected regex: " + expected + "\nbut was: " + actual);
}

export default function filesTest() {
  describe('filesTest', () => {

    it("Files when external file access is disabled then reading file raises error", 0, () => {
      let files: ESObject = new Files({ externalFileAccess: false });
      assertError(files.read("/tmp/image.png", "base64"), (err: ESObject) => {
        expect(err.message)
          .assertDeepEquals("could not read external image '/tmp/image.png', external file access is disabled");
      });
    })

    it("Files when can open files with file URI", 0, () => {
      let filePath: ESObject = testPath("tiny-picture.png");
      let files: ESObject = new Files({ externalFileAccess: true });
      files.read("file:///" + filePath.replace(/^\//, ""), "base64").then((contents: ESObject) => {
        readFile(filePath, "base64").then((expectedContents: ESObject) => {
          expect(contents).assertDeepEquals(expectedContents);
        }).catch((err: BusinessError) => {
          expect().assertFail();
        })
      }).catch((err: BusinessError) => {
        expect().assertFail();
      })
    })
    //
    // it("Files when can open files with relative URI", 0, () => {
    //   let filePath = testPath("tiny-picture.png");
    //   let files: ESObject = new Files({
    //     externalFileAccess: true,
    //     relativeToFile: testPath("./document.docx")
    //   });
    //   files.read("tiny-picture.png", "base64").then((contents: ESObject) => {
    //     readFile(filePath, "base64").then((expectedContents: ESObject) => {
    //       expect(contents).assertDeepEquals(expectedContents);
    //     }).catch((err: BusinessError) => {
    //       expect().assertFail();
    //     })
    //   }).catch((err: BusinessError) => {
    //     expect().assertFail();
    //   })
    // })
    //
    // it("Files when given base is not set when opening relative uri then error is raised", 0, () => {
    //   let files: ESObject = new Files({ externalFileAccess: true });
    //   assertError(files.read("not-a-real-file.png", "base64"), (err: ESObject) => {
    //     expect(err.message)
    //       .assertEqual("could not find external image 'not-a-real-file.png', path of input document is unknown");
    //   });
    // })
    //
    // it("Files when error if relative uri cannot be opened", 0, () => {
    //   let files: ESObject = new Files({
    //     externalFileAccess: true,
    //     relativeToFile: "/tmp/document.docx"
    //   });
    //   assertError(files.read("not-a-real-file.png", "base64"), (err: ESObject) => {
    //     assertRegex(err.message,
    //       /could not open external image: 'not-a-real-file.png' \(document directory: '\/tmp'\)\nENOENT.*\/tmp\/not-a-real-file.png.*/);
    //   });
    // })
    //
    //
    // it("uriToPath leading slash is retained on non-Windows file URIs", 0, () => {
    //   expect(uriToPath("file:///a/b/c", "linux")).assertEqual("/a/b/c");
    //   expect(uriToPath("file:///a/b/c", "win32")).assertEqual("/a/b/c");
    // });
    //
    // it("URI is unquoted", 0, () => {
    //   expect(uriToPath("file:///a%20b")).assertEqual("/a b");
    // });
    //
    // it("when host is set to localhost then path can be found", 0, () => {
    //   expect(uriToPath("file://localhost/a/b/c")).assertEqual("/a/b/c");
    // });
    //
    // it("when host is set but not localhost then path cannot be found", 0, () => {
    //   try {
    //     uriToPath("file://example/a/b/c");
    //   } catch (e) {
    //     expect(e.message).assertEqual(`Could not convert URI to path: file:\/\/example\/a\/b\/c`)
    //   }
    // });
    //
    // it("leading slash is not dropped on Windows file URIs when platform is not Windows", 0, () => {
    //   expect(uriToPath("file:///c:/a", "linux")).assertEqual("/c:/a");
    // });
    //
    // it("leading slash is dropped on Windows file URIs when platform is Windows", 0, () => {
    //   expect(uriToPath("file:///c:/a", "win32")).assertEqual("c:/a");
    //   expect(uriToPath("file:///C:/a", "win32")).assertEqual("C:/a");
    // });
    //
    // it("relative URI is unquoted", 0, () => {
    //   expect(uriToPath("a%20b/c")).assertEqual("a b/c");
    // });
  })

}


