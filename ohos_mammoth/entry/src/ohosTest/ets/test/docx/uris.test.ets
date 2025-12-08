// uris.test.ets
import { describe, it, expect } from '@ohos/hypium';
import * as uris from "@ohos/mammoth/src/main/ets/docx/uris";

// 测试用例
export default function urisTest() {
  describe('urisTest', () => {
    it("uriToZipEntryName when path does not have leading slash then path is resolved relative to base", 0, (done: Function) => {
      expect(
        uris.uriToZipEntryName("one/two", "three/four")
      ).assertEqual("one/two/three/four");
      done();
    });

    it("uriToZipEntryName when path has leading slash then base is ignored", 1, (done: Function) => {
      expect(
        uris.uriToZipEntryName("one/two", "/three/four")
      ).assertEqual("three/four");
      done();
    });
  });
}
