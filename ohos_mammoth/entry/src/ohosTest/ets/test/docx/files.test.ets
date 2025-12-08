// files.test.ets
import { describe, it, expect } from '@ohos/hypium';
import * as files from "@ohos/mammoth/src/main/ets/docx/files";
import { testPath } from '../testing';
import fs from '@ohos.file.fs';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { writeFile } from '../../../../main/ets/utils/FileUtils';

const Files: ESObject = files.Files;

// 定义必要的接口
interface FilesInterface {
  read: (path: string, encoding?: string) => Promise<Object>;
}

// 辅助函数
const assertError = async (promise: Promise<Object>, func: (error: Error) => void): Promise<void> => {
  try {
    await promise;
    expect(false).assertFalse();
    console.error("Expected error but none was thrown");
  } catch (error) {
    func(error as Error);
  }
};

// let readFile = (fullPath?: string, encoding?: string) => {
//   try {
//     let file = fs.openSync(fullPath, 0o2);
//     let stat = fs.lstatSync(fullPath);
//     let buf = new ArrayBuffer(stat.size);
//     fs.readSync(file.fd, buf);
//     fs.fsyncSync(file.fd);
//     fs.closeSync(file.fd);
//     return Promise.resolve(buf)
//   } catch (err) {
//     return Promise.reject()
//   }
// }

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
// 获取测试上下文
const context = delegator.getAppContext();

// 测试用例
export default function filesTest() {
  describe('filesTest', () => {
    it("Files when external file access is disabled then reading file raises error", 0, async (done: Function) => {
      const filesInstance: FilesInterface = files.Files({ externalFileAccess: false }) as FilesInterface;
      await assertError(
        filesInstance.read("/tmp/image.png", "base64") as Promise<ArrayBuffer | string>,
        (err: Error) => {
          expect(err.message).assertEqual("could not read external image '/tmp/image.png', external file access is disabled");
          done();
        }
      );
    });

    // todo
    // it("Files when can open files with file URI", 1, (done: Function) => {
    //   let filePath: ESObject = testPath("tiny-picture.png");
    //   let content = context.resourceManager.getRawFileContentSync(filePath);
    //   writeFile(context.filesDir, "tiny-picture.png", content.buffer);
    //   let files: ESObject = new Files({ externalFileAccess: true });
    //   files.read("file:///" + filePath.replace(/^\//, ""), "base64").then((contents: ESObject) => {
    //     readFile(filePath, "base64").then((expectedContents: ESObject) => {
    //       expect(contents).assertDeepEquals(expectedContents);
    //       done();
    //     }).catch((err: BusinessError) => {
    //       expect().assertFail();
    //       done();
    //     })
    //   }).catch((err: BusinessError) => {
    //     expect().assertFail();
    //     done();
    //   })
    // })

    // todo
    // it("Files when can open files with relative URI", 2, (done: Function) => {
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
    //     done();
    //   })
    // })

    it("Files when given base is not set when opening relative uri then error is raised", 3, (done: Function) => {
      let files: ESObject = new Files({ externalFileAccess: true });
      assertError(files.read("not-a-real-file.png", "base64"), (err: ESObject) => {
        expect(err.message)
          .assertEqual("could not find external image 'not-a-real-file.png', path of input document is unknown");
        done();
      });
    })

    // todo
    // it("Files when error if relative uri cannot be opened", 4, async (done: Function) => {
    //   let filesInstance: FilesInterface = new Files({
    //     externalFileAccess: true,
    //     relativeToFile: "/tmp/document.docx"
    //   }) as FilesInterface
    //   await assertError(filesInstance.read("not-a-real-file.png", "base64") as Promise<ArrayBuffer | string>, (err: Error) => {
    //     expect(err.message).assertEqual(`could not open external image: 'not-a-real-file.png' (document directory: '/tmp/document.docx')\nPermission denied`);
    //     done();
    //   });
    // })

    it("uriToPath leading slash is retained on non-Windows file URIs", 5, (done: Function) => {
      // 测试非Windows文件URI的前导斜杠保留
      expect(files.uriToPath("file:///a/b/c", "linux")).assertEqual("/a/b/c");
      expect(files.uriToPath("file:///a/b/c", "win32")).assertEqual("/a/b/c");
      done();
    });

    it("uriToPath URI is unquoted", 6, (done: Function) => {
      // 测试URI被正确解码
      expect(files.uriToPath("file:///a%20b")).assertEqual("/a b");
      done();
    });

    it("uriToPath when host is set to localhost then path can be found", 7, (done: Function) => {
      // 测试主机设置为localhost时可以找到路径
      expect(files.uriToPath("file://localhost/a/b/c")).assertEqual("/a/b/c");
      done();
    });

    it("uriToPath when host is set but not localhost then path cannot be found", 8, (done: Function) => {
      // 测试当主机设置但不是localhost时，找不到路径
      try {
        files.uriToPath("file://example/a/b/c");
      } catch (e) {
        expect(e.message).assertEqual(`Could not convert URI to path: file:\/\/example\/a\/b\/c`);
        done();
      }
    });

    it("uriToPath leading slash is not dropped on Windows file URIs when platform is not Windows", 9, (done: Function) => {
      // 测试当平台不是Windows时，Windows文件URI上的前导斜杠不会被删除
      expect(files.uriToPath("file:///c:/a", "linux")).assertEqual("/c:/a");
      done();
    });

    it("uriToPath leading slash is dropped on Windows file URIs when platform is Windows", 10, (done: Function) => {
      // 测试当平台是Windows时，Windows文件URI上的前导斜杠被删除
      expect(files.uriToPath("file:///c:/a", "win32")).assertEqual("c:/a");
      expect(files.uriToPath("file:///C:/a", "win32")).assertEqual("C:/a");
      done();
    });

    it("uriToPath relative URI is unquoted", 11, (done: Function) => {
      // 测试相对URI被正确解码
      expect(files.uriToPath("a%20b/c")).assertEqual("a b/c");
      done();
    });
  });
}
