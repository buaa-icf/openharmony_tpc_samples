import { describe, it, expect } from '@ohos/hypium';
import * as unzip from "@ohos/mammoth/src/main/ets/unzip";
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { ZipFile } from './Type';
import { BusinessError } from '@kit.BasicServicesKit';

const delegator = abilityDelegatorRegistry.getAbilityDelegator()
// 获取测试上下文
const context = delegator.getAppContext();

export default function unzipTest() {
  describe('unzipTest', () => {

    it("unzip fails if given empty object", 0, (done: Function) => {
      unzip.openZip({}).then(() => {
        expect().assertTrue();
      }, (error: BusinessError) => {
        expect("Could not find file in options").assertEqual(error.message);
        done();
      })
        .catch((error: BusinessError) => {
          expect().assertFail();
          done();
        })
    });

    it("unzip can open local zip file", 1, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/hello.zip");
      unzip.openZip({ arrayBuffer: content.buffer }).then((zipFile: ZipFile): Promise<ESObject> => {
        return zipFile.read("hello", "utf8");
      }).then((contents: string) => {
        expect(contents).assertEqual("Hello world\n");
        done();
      })
        .catch((error: BusinessError) => {
          expect().assertFail();
          done();
        })
    });

    it('unzip can open Buffer', 2, (done: Function) => {
      context.resourceManager.getRawFileContent("test-data/hello.zip")
        .then((buffer: Uint8Array): Promise<ESObject> => {
          return unzip.openZip({ arrayBuffer: buffer.buffer });
        })
        .then((zipFile: ZipFile): Promise<ESObject> => {
          return zipFile.read("hello", "utf8");
        })
        .then((contents: string) => {
          expect(contents).assertEqual("Hello world\n");
          done();
        })
        .catch((error: BusinessError) => {
          expect().assertFail();
          done();
        })
    });
  });
}