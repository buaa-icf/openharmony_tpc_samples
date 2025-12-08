// style-map.test.ets
import { describe, it, expect } from '@ohos/hypium';
import * as styleMap from "@ohos/mammoth/src/main/ets/docx/style-map";
import * as zipfile from "@ohos/mammoth/src/main/ets/zipfile";
import JSZip from "@ohos/jszip";
import { ZipFile } from "../Type";

// 定义预期结果常量
const expectedRelationshipsXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
  '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">' +
  '<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings" Target="settings.xml"/>' +
  '<Relationship Id="rMammothStyleMap" Type="http://schemas.zwobble.org/mammoth/style-map" Target="/mammoth/style-map"/>' +
  '</Relationships>';

const expectedContentTypesXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
  '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">' +
  '<Default Extension="png" ContentType="image/png"/>' +
  '<Override PartName="/mammoth/style-map" ContentType="text/prs.mammoth.style-map"/>' +
  '</Types>';

// 辅助函数：创建空的ZipFile对象
const createEmptyZipFile = async (): Promise<ZipFile> => {
  const jsZip = new JSZip();
  const arrayBuffer = await jsZip.generateAsync({ type: "arraybuffer" });
  return zipfile.openArrayBuffer(arrayBuffer) as Promise<ZipFile>;
};

// 辅助函数：创建包含基础XML的docx文件
const normalDocx = async (): Promise<ZipFile> => {
  // 创建一个简单的docx文件
  const jsZip = new JSZip();
  const originalRelationshipsXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
    '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">' +
    '<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings" Target="settings.xml"/>' +
    '</Relationships>';
  const originalContentTypesXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
    '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">' +
    '<Default Extension="png" ContentType="image/png"/>' +
    '</Types>';
  jsZip.file("word/_rels/document.xml.rels", originalRelationshipsXml);
  jsZip.file("[Content_Types].xml", originalContentTypesXml);
  const arrayBuffer = await jsZip.generateAsync({ type: "arraybuffer" });
  return zipfile.openArrayBuffer(arrayBuffer) as Promise<ZipFile>;
};

// 测试用例
export default function styleMapTest() {
  describe('styleMapTest', () => {
    it('reading embedded style map on document without embedded style map returns null', 0, async (done: Function) => {
      const zip = await normalDocx();
      expect(await styleMap.readStyleMap(zip)).assertEqual(null);
      done();
    });

    it('embedded style map can be read after being written', 1, async (done: Function) => {
      const zip = await normalDocx();
      await styleMap.writeStyleMap(zip, "p => h1");
      expect(await styleMap.readStyleMap(zip)).assertEqual("p => h1");
      done();
    });

    it('embedded style map is written to separate file', 2, async (done: Function) => {
      const zip = await normalDocx();
      await styleMap.writeStyleMap(zip, "p => h1");
      expect(await zip.read("mammoth/style-map", "utf8")).assertEqual("p => h1");
      done();
    });

    it('embedded style map is referenced in relationships', 3, async (done: Function) => {
      const zip = await normalDocx();
      await styleMap.writeStyleMap(zip, "p => h1");
      expect(await zip.read("word/_rels/document.xml.rels", "utf8")).assertEqual(expectedRelationshipsXml);
      done();
    });

    it('re-embedding style map replaces original', 4, async (done: Function) => {
      const zip = await normalDocx();
      await styleMap.writeStyleMap(zip, "p => h1");
      await styleMap.writeStyleMap(zip, "p => h2");
      expect(await zip.read("word/_rels/document.xml.rels", "utf8")).assertEqual(expectedRelationshipsXml);
      expect(await styleMap.readStyleMap(zip)).assertEqual("p => h2");
      done();
    });

    it('embedded style map has override content type in [Content_Types].xml', 5, async (done: Function) => {
      const zip = await normalDocx();
      await styleMap.writeStyleMap(zip, "p => h1");
      expect(await zip.read("[Content_Types].xml", "utf8")).assertEqual(expectedContentTypesXml);
      done();
    });

    it('replacing style map keeps content type', 6, async (done: Function) => {
      const zip = await normalDocx();
      await styleMap.writeStyleMap(zip, "p => h1");
      await styleMap.writeStyleMap(zip, "p => h2");
      expect(await zip.read("[Content_Types].xml", "utf8")).assertEqual(expectedContentTypesXml);
      done();
    });
  });
}
