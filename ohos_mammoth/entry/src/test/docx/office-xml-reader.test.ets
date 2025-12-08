// office-xml-reader.test.ets
import { describe, it, expect } from '@ohos/hypium';
import * as xml from "@ohos/mammoth/src/main/ets/xml";
import * as officeXmlReader from "@ohos/mammoth/src/main/ets/docx/office-xml-reader";

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

// 测试用例
export default function officeXmlReaderTest() {
  describe('officeXmlReaderTest', () => {
    it("when mc:Fallback is present then mc:Fallback is read", 0, async (done: Function) => {
      const xmlString = 
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
        '<numbering xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006">' +
        '<mc:AlternateContent>' +
        '<mc:Choice Requires="w14">' +
        '<choice/>' +
        '</mc:Choice>' +
        '<mc:Fallback>' +
        '<fallback/>' +
        '</mc:Fallback>' +
        '</mc:AlternateContent>' +
        '</numbering>';
      const element: ElementInterface = await officeXmlReader.read(xmlString) as ElementInterface;
      expect(element.children).assertDeepEquals([xml.element("fallback") as ElementInterface]);
      done();
    });

    it("when mc:Fallback is not present then element is ignored", 1, async (done: Function) => {
      const xmlString = 
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
        '<numbering xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006">' +
        '<mc:AlternateContent>' +
        '<mc:Choice Requires="w14">' +
        '<choice/>' +
        '</mc:Choice>' +
        '</mc:AlternateContent>' +
        '</numbering>';
      const element: ElementInterface = await officeXmlReader.read(xmlString) as ElementInterface;
      expect(element.children).assertDeepEquals([]);
      done();
    });
  });
}
