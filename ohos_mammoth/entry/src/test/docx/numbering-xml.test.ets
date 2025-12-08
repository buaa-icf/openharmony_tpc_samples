import { describe, it, expect } from '@ohos/hypium';
import { readNumberingXml } from "@ohos/mammoth/src/main/ets/docx/numbering-xml";
import * as stylesReader from "@ohos/mammoth/src/main/ets/docx/styles-reader";
import { Element as XmlElement } from "@ohos/mammoth/src/main/ets/xml";

export default function numberingXmlTest() {
  describe('numberingXmlTest', () => {
    it('w:num element inherits levels from w:abstractNum', 0, (done: Function) => {
      let numbering: ESObject = readNumberingXml(
        new XmlElement("w:numbering", {}, [
          new XmlElement("w:abstractNum", { "w:abstractNumId": "42" }, [
            new XmlElement("w:lvl", { "w:ilvl": "0" }, [
              new XmlElement("w:numFmt", { "w:val": "bullet" })
            ]),
            new XmlElement("w:lvl", { "w:ilvl": "1" }, [
              new XmlElement("w:numFmt", { "w:val": "decimal" })
            ])
          ]),
          new XmlElement("w:num", { "w:numId": "47" }, [
            new XmlElement("w:abstractNumId", { "w:val": "42" })
          ])
        ]),
        { styles: stylesReader.defaultStyles }
      );

      expect(numbering.findLevel("47", "0").isOrdered).assertEqual(false);
      expect(numbering.findLevel("47", "1").isOrdered).assertEqual(true);
      done();
    });

    it('w:num element referencing non-existent w:abstractNumId is ignored', 1, (done: Function) => {
      let numbering: ESObject = readNumberingXml(
        new XmlElement("w:numbering", {}, [
          new XmlElement("w:num", { "w:numId": "47" }, [
            new XmlElement("w:abstractNumId", { "w:val": "42" })
          ])
        ]),
        { styles: stylesReader.defaultStyles }
      );
      expect(numbering.findLevel("47", "0")).assertDeepEquals(null);
      done();
    });

    it('given no other levels with index of 0 when level is missing w:ilvl then level index is 0', 2, (done: Function) => {
      let numbering: ESObject = readNumberingXml(
        new XmlElement("w:numbering", {}, [
          new XmlElement("w:abstractNum", { "w:abstractNumId": "42" }, [
            new XmlElement("w:lvl", {}, [
              new XmlElement("w:numFmt", { "w:val": "decimal" })
            ])
          ]),
          new XmlElement("w:num", { "w:numId": "47" }, [
            new XmlElement("w:abstractNumId", { "w:val": "42" })
          ])
        ]),
        { styles: stylesReader.defaultStyles }
      );
      expect(numbering.findLevel("47", "0").isOrdered).assertDeepEquals(true);
      done();
    });

    it('given previous other level with index of 0 when level is missing w:ilvl then level is ignored', 3, (done: Function) => {
      let numbering: ESObject = readNumberingXml(
        new XmlElement("w:numbering", {}, [
          new XmlElement("w:abstractNum", { "w:abstractNumId": "42" }, [
            new XmlElement("w:lvl", { "w:ilvl": "0" }, [
              new XmlElement("w:numFmt", { "w:val": "bullet" })
            ]),
            new XmlElement("w:lvl", {}, [
              new XmlElement("w:numFmt", { "w:val": "decimal" })
            ])
          ]),
          new XmlElement("w:num", { "w:numId": "47" }, [
            new XmlElement("w:abstractNumId", { "w:val": "42" })
          ])
        ]),
        { styles: stylesReader.defaultStyles }
      );
      expect(numbering.findLevel("47", "0").isOrdered).assertDeepEquals(false);
      done();
    });

    it('given subsequent other level with index of 0 when level is missing w:ilvl then level is ignored', 4, (done: Function) => {
      let numbering: ESObject = readNumberingXml(
        new XmlElement("w:numbering", {}, [
          new XmlElement("w:abstractNum", { "w:abstractNumId": "42" }, [
            new XmlElement("w:lvl", {}, [
              new XmlElement("w:numFmt", { "w:val": "decimal" })
            ]),
            new XmlElement("w:lvl", { "w:ilvl": "0" }, [
              new XmlElement("w:numFmt", { "w:val": "bullet" })
            ])
          ]),
          new XmlElement("w:num", { "w:numId": "47" }, [
            new XmlElement("w:abstractNumId", { "w:val": "42" })
          ])
        ]),
        { styles: stylesReader.defaultStyles }
      );
      expect(numbering.findLevel("47", "0").isOrdered).assertDeepEquals(false);
      done();
    });

    it('when level is missing w:numFmt then level is ordered', 5, (done: Function) => {
      let numbering: ESObject = readNumberingXml(
        new XmlElement("w:numbering", {}, [
          new XmlElement("w:abstractNum", { "w:abstractNumId": "42" }, [
            new XmlElement("w:lvl", { "w:ilvl": "0" })
          ]),
          new XmlElement("w:num", { "w:numId": "47" }, [
            new XmlElement("w:abstractNumId", { "w:val": "42" })
          ])
        ]),
        { styles: stylesReader.defaultStyles }
      );
      expect(numbering.findLevel("47", "0").isOrdered).assertDeepEquals(true);
      done();
    });

    it('when w:abstractNum has w:numStyleLink then style is used to find w:num', 6, (done: Function) => {
      let Styles: ESObject = stylesReader.Styles;
      let List1: ESObject = { numId: "200" }
      let numbering: ESObject = readNumberingXml(
        new XmlElement("w:numbering", {}, [
          new XmlElement("w:abstractNum", { "w:abstractNumId": "100" }, [
            new XmlElement("w:lvl", { "w:ilvl": "0" }, [
              new XmlElement("w:numFmt", { "w:val": "decimal" })
            ])
          ]),
          new XmlElement("w:abstractNum", { "w:abstractNumId": "101" }, [
            new XmlElement("w:numStyleLink", { "w:val": "List1" })
          ]),
          new XmlElement("w:num", { "w:numId": "200" }, [
            new XmlElement("w:abstractNumId", { "w:val": "100" })
          ]),
          new XmlElement("w:num", { "w:numId": "201" }, [
            new XmlElement("w:abstractNumId", { "w:val": "101" })
          ])
        ]),
        { styles: new Styles({}, {}, {}, { "List1": List1 }) }
      );
      expect(numbering.findLevel("201", "0").isOrdered).assertDeepEquals(true);
      done();
    });

    // See: 17.9.23 pStyle (Paragraph Style's Associated Numbering Level) in ECMA-376, 4th Edition
    it('numbering level can be found by paragraph style ID', 7, (done: Function) => {
      let numbering: ESObject = readNumberingXml(
        new XmlElement("w:numbering", {}, [
          new XmlElement("w:abstractNum", { "w:abstractNumId": "42" }, [
            new XmlElement("w:lvl", { "w:ilvl": "0" }, [
              new XmlElement("w:numFmt", { "w:val": "bullet" })
            ])
          ]),
          new XmlElement("w:abstractNum", { "w:abstractNumId": "43" }, [
            new XmlElement("w:lvl", { "w:ilvl": "0" }, [
              new XmlElement("w:pStyle", { "w:val": "List" }),
              new XmlElement("w:numFmt", { "w:val": "decimal" })
            ])
          ])
        ]),
        { styles: stylesReader.defaultStyles }
      );
      expect(numbering.findLevelByParagraphStyleId("List").isOrdered).assertDeepEquals(true);
      expect(numbering.findLevelByParagraphStyleId("Paragraph")).assertDeepEquals(null);
      done();
    });

    it('when styles is missing then error is thrown', 8, (done: Function) => {
      try {
        readNumberingXml(new XmlElement("w:numbering", {}, []))
      } catch (err) {
        expect(err.message).assertDeepEquals(`styles is missing`);
        done();
      }
    });
  });
}
