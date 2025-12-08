import { describe, it, expect } from '@ohos/hypium';
import JSZip from "@ohos/jszip";
import * as zipfile from "@ohos/mammoth/src/main/ets/zipfile";
import { ZipFile } from './Type';
import { BusinessError } from '@kit.BasicServicesKit';

const emptyZipFile = () => {
  let zip = new JSZip();
  return zip.generateAsync({ type: "arraybuffer" }).then((arrayBuffer: ArrayBuffer): Promise<ESObject> => {
    return zipfile.openArrayBuffer(arrayBuffer);
  });
}

export default function zipfileTest() {
  describe('zipfileTest', () => {

    it('file in zip can be read after being written', 0, (done: Function) => {
      emptyZipFile().then((zip: ZipFile) => {
        zip.write("song/title", "Dark Blue");

        expect(zip.exists("song/title")).assertTrue();
        zip.read("song/title", "utf8").then((contents: string) => {
          expect(contents).assertEqual("Dark Blue")
          done();
        })
          .catch((error: BusinessError) => {
            expect().assertFail();
            done();
          })
      });
    });

    it('splitPath splits zip paths on last forward slash', 1, (done: Function) => {
      expect(zipfile.splitPath("a/b")).assertDeepEquals({ dirname: "a", basename: "b" });
      expect(zipfile.splitPath("a/b")).assertDeepEquals({ dirname: "a", basename: "b" });
      expect(zipfile.splitPath("a/b/c")).assertDeepEquals({ dirname: "a/b", basename: "c" });
      expect(zipfile.splitPath("/a/b/c")).assertDeepEquals({ dirname: "/a/b", basename: "c" });
      done();
    });

    it('when path has no forward slashes then splitPath returns empty dirname', 1, (done: Function) => {
      expect(zipfile.splitPath("name")).assertDeepEquals({ dirname: "", basename: "name" });
      done();
    });


    it("joinPath joins arguments with forward slashes", 2, (done: Function) => {
      expect(zipfile.joinPath("a", "b")).assertDeepEquals("a/b");
      expect(zipfile.joinPath("a/b", "c")).assertDeepEquals("a/b/c");
      expect(zipfile.joinPath("a", "b/c")).assertDeepEquals("a/b/c");
      expect(zipfile.joinPath("/a/b", "c")).assertDeepEquals("/a/b/c");
      done();
    });


    it("empty parts are ignored when joining paths", 3, (done: Function) => {
      expect(zipfile.joinPath("a", "")).assertDeepEquals("a");
      expect(zipfile.joinPath("", "b")).assertDeepEquals("b");
      expect(zipfile.joinPath("a", "", "b")).assertDeepEquals("a/b");
      done();
    });


    it("when joining paths then absolute paths ignore earlier paths", 4, (done: Function) => {
      expect(zipfile.joinPath("a", "/b")).assertDeepEquals("/b");
      expect(zipfile.joinPath("a", "/b", "c")).assertDeepEquals("/b/c");
      expect(zipfile.joinPath("/a", "/b")).assertDeepEquals("/b");
      expect(zipfile.joinPath("/a")).assertDeepEquals("/a");
      done();
    });
  });
}