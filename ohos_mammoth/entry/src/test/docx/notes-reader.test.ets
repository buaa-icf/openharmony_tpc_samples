import { describe, it, expect } from '@ohos/hypium';
import { createFootnotesReader } from "@ohos/mammoth/src/main/ets/docx/notes-reader";
import { createBodyReader } from "@ohos/mammoth/src/main/ets/docx/body-reader";
import * as stylesReader from "@ohos/mammoth/src/main/ets/docx/styles-reader";
import * as documents from "@ohos/mammoth/src/main/ets/documents";
import { Element as XmlElement } from "@ohos/mammoth/src/main/ets/xml";

const createBodyReaderClass: ESObject = createBodyReader;
const Paragraph: ESObject = documents.Paragraph;
const footnoteTypeIsIgnored = (type: ESObject) => {
  it('footnotes of type ' + type + ' are ignored', 0, () => {
    let footnotes: ESObject = createFootnotesReader()(
      new XmlElement("w:footnotes", {}, [
        new XmlElement("w:footnote", { "w:id": "1", "w:type": type }, [])
      ])
    );
    expect(footnotes.value.length).assertEqual(0);
  });
}

footnoteTypeIsIgnored('continuationSeparator');
footnoteTypeIsIgnored('separator');

export default function notesReaderTest() {
  describe('notesReaderTest', () => {
    it('ID and body of footnote are read', 0, (done: Function) => {
      let bodyReader: ESObject = new createBodyReaderClass({ styles: stylesReader.defaultStyles });
      let footnoteBody: ESObject = [new XmlElement("w:p", {}, [])];
      let footnotes: ESObject = createFootnotesReader(bodyReader)(
        new XmlElement("w:footnotes", {}, [
          new XmlElement("w:footnote", { "w:id": "1" }, footnoteBody)
        ])
      );
      expect(footnotes.value.length).assertEqual(1);
      expect(footnotes.value[0].body).assertDeepEquals([new Paragraph([])]);
      expect(footnotes.value[0].noteId).assertDeepEquals("1");
      done();
    });
  });
}
