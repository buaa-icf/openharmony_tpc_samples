import { describe, it, expect } from '@ohos/hypium';
import { readContentTypesFromXml } from "@ohos/mammoth/src/main/ets/docx/content-types-reader";
import { Element as XmlElement } from "@ohos/mammoth/src/main/ets/xml";

export default function contentTypesReaderTest() {
  describe('contentTypesReaderTest', () => {
    it('reads default-per-extension from XML', 0, (done: Function) => {
      let contentTypes: ESObject = readContentTypesFromXml(
        new XmlElement("content-types:Types", {}, [
          new XmlElement("content-types:Default", { Extension: "png", ContentType: "image/png" })
        ])
      );
      expect(contentTypes.findContentType("word/media/hat.png")).assertEqual("image/png");
      done();
    });

    it('reads overrides in preference to defaults', 1, (done: Function) => {
      let contentTypes: ESObject = readContentTypesFromXml(
        new XmlElement("content-types:Types", {}, [
          new XmlElement("content-types:Default", { Extension: "png", ContentType: "image/png" }),
          new XmlElement("content-types:Override", { PartName: "/word/media/hat.png", ContentType: "image/hat" })
        ])
      );
      expect(contentTypes.findContentType("word/media/hat.png")).assertEqual("image/hat");
      done();
    });

    it('fallback content types have common image types', 2, (done: Function) => {
      let contentTypes: ESObject = readContentTypesFromXml(
        new XmlElement("content-types:Types", {}, [])
      );
      expect(contentTypes.findContentType("word/media/hat.png")).assertEqual("image/png");
      expect(contentTypes.findContentType("word/media/hat.gif")).assertEqual("image/gif");
      expect(contentTypes.findContentType("word/media/hat.jpg")).assertEqual("image/jpeg");
      expect(contentTypes.findContentType("word/media/hat.jpeg")).assertEqual("image/jpeg");
      expect(contentTypes.findContentType("word/media/hat.bmp")).assertEqual("image/bmp");
      expect(contentTypes.findContentType("word/media/hat.tif")).assertEqual("image/tiff");
      expect(contentTypes.findContentType("word/media/hat.tiff")).assertEqual("image/tiff");
      done();
    });

    it('fallback content types are case insensitive on extension', 3, (done: Function) => {
      let contentTypes: ESObject = readContentTypesFromXml(
        new XmlElement("content-types:Types", {}, [])
      );
      expect(contentTypes.findContentType("word/media/hat.PnG")).assertEqual("image/png");
      done();
    });
  });
}
