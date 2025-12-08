import { describe, it, expect } from '@ohos/hypium';
import * as documents from "@ohos/mammoth/src/main/ets/documents";
import { DocumentXmlReader } from "@ohos/mammoth/src/main/ets/docx/document-xml-reader";
import * as xml from "@ohos/mammoth/src/main/ets/xml";
import { BodyReader, DocumentXmlReaderType } from '../Type';
import { createBodyReaderForTests } from './testing'

const DocumentXmlReaderClass: ESObject = DocumentXmlReader;

export default function localUnitTest() {
  describe('localUnitTest', () => {
    it("when body element is present then body is read", 0, (done: Function) => {
      let bodyReader: BodyReader = createBodyReaderForTests({});
      let documentXmlReader: DocumentXmlReaderType = new DocumentXmlReaderClass({
        bodyReader: bodyReader
      });
      let textXml: ESObject = xml.element("w:t", {}, [xml.text("Hello!")]);
      let runXml: ESObject = xml.element("w:r", {}, [textXml]);
      let paragraphXml: ESObject = xml.element("w:p", {}, [runXml]);
      let bodyXml: ESObject = xml.element("w:body", {}, [paragraphXml]);
      let documentXml: ESObject = xml.element("w:document", {}, [bodyXml]);

      let result: ESObject = documentXmlReader.convertXmlToDocument(documentXml);

      expect(result.messages).assertDeepEquals([]);
      expect(result.value).assertDeepEquals(documents.document(
        [documents.paragraph([documents.run([documents.text("Hello!")])])],
        {}
      ));
      done();
    });

    it("when body element is not present then error is thrown", 1, (done: Function) => {
      let bodyReader: BodyReader = createBodyReaderForTests({});
      let documentXmlReader: DocumentXmlReaderType = new DocumentXmlReaderClass({
        bodyReader: bodyReader
      });
      let paragraphXml: ESObject = xml.element("w:p", {}, []);
      let bodyXml: ESObject = xml.element("w:body2", {}, [paragraphXml]);
      let documentXml: ESObject = xml.element("w:document", {}, [bodyXml]);

      try {
        documentXmlReader.convertXmlToDocument(documentXml);
      } catch (err) {
        expect(err.message).assertEqual("Could not find the body element: are you sure this is a docx file?");
      }
      done();
    });
  });
}
