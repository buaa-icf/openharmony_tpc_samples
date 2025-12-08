// relationships-reader.test.ets
import { describe, it, expect } from '@ohos/hypium';
import * as relationshipsReader from "@ohos/mammoth/src/main/ets/docx/relationships-reader";
import * as xml from "@ohos/mammoth/src/main/ets/xml";

// 定义必要的接口
interface ElementInterface {
  type: string;
  name: string;
  attributes: Record<string, string>;
  children: ElementInterface[];
  first: (name: string) => ElementInterface | null;
  firstOrEmpty: (name: string) => ElementInterface;
  getElementsByTagName: (name: string) => ElementInterface[];
  text?: () => string;
}

// 辅助函数
const relationshipsElement = (children: ElementInterface[]): ElementInterface => {
  return xml.element("relationships:Relationships", {}, children) as ElementInterface;
};

const relationshipElement = (attributes: Record<string, string>): ElementInterface => {
  return xml.element("relationships:Relationship", attributes, []) as ElementInterface;
};

// 测试用例
export default function relationshipsReaderTest() {
  describe('relationshipsReaderTest', () => {
    it("relationships can be found by ID", 0, (done: Function) => {
      expect(relationshipsReader.readRelationships(relationshipsElement([
        relationshipElement({
          "Id": "rId1",
          "Target": "http://example.com/",
          "Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink"
        }),
        relationshipElement({
          "Id": "rId2",
          "Target": "http://example.net/",
          "Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink"
        })
      ])).findTargetByRelationshipId("rId1")).assertEqual("http://example.com/");
      done();
    });

    it("relationships can be found by type", 1, (done: Function) => {
      expect(relationshipsReader.readRelationships(relationshipsElement([
        relationshipElement({
          "Id": "rId2",
          "Target": "docProps/core.xml",
          "Type": "http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties"
        }),
        relationshipElement({
          "Id": "rId1",
          "Target": "word/document.xml",
          "Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument"
        }),
        relationshipElement({
          "Id": "rId3",
          "Target": "word/document2.xml",
          "Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument"
        })
      ])).findTargetsByType("http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument")).assertDeepEquals(["word/document.xml", "word/document2.xml"]);
      done();
    });

    it("when there are no relationships of requested type then empty array is returned", 2, (done: Function) => {
      expect(relationshipsReader.readRelationships(relationshipsElement([])).findTargetsByType("http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument")).assertDeepEquals([]);
      done();
    });
  });
}
