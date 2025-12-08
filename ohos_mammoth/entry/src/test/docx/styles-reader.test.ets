import { describe, it, expect } from '@ohos/hypium';
import * as XmlModule from "@ohos/mammoth/src/main/ets/xml";
import { readStylesXml } from "@ohos/mammoth/src/main/ets/docx/styles-reader";


// 假设 xml 模块中的类型定义
type XmlAttributes = Record<string, string>;

interface XmlElementInterface {
  name: string;
  attributes: XmlAttributes;
  children: XmlElementInterface[];

  getElementsByTagName(tagName: string): XmlElementInterface[];
  first(tagName: string): XmlElementInterface | null;
  firstOrEmpty(tagName: string): XmlElementInterface;
}

// 假设样式读取器的返回类型
interface Style {
  type: string;
  styleId: string;
  name?: string;
  numId?: string;
}

interface StylesInterface {
  findParagraphStyleById(styleId: string): Style | undefined;
  findCharacterStyleById(styleId: string): Style | undefined;
  findTableStyleById(styleId: string): Style | undefined;
  findNumberingStyleById(styleId: string): Style | undefined;
}

function paragraphStyleElement(id: string, name: string): XmlElementInterface {
  return styleElement("paragraph", id, name);
}

function characterStyleElement(id: string, name: string): XmlElementInterface {
  return styleElement("character", id, name);
}

function tableStyleElement(id: string, name: string): XmlElementInterface {
  return styleElement("table", id, name);
}

function styleElement(type: string, id: string, name: string): XmlElementInterface {
  return new XmlModule.Element("w:style", {"w:type": type, "w:styleId": id}, [
    new XmlModule.Element("w:name", {"w:val": name}, [])
  ]);
}

function styleWithoutWNameElement(type: string, id: string): XmlElementInterface {
  return new XmlModule.Element("w:style", {"w:type": type, "w:styleId": id}, []);
}

export default function StylesReaderTest() {
  describe('StylesReaderTest', () => {

    it('paragraph style is null if no style with that ID exists', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [])
      );
      expect(styles.findParagraphStyleById("Heading1")).assertUndefined();
      done();
    });

    it('paragraph style can be found by ID', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [
          paragraphStyleElement("Heading1", "Heading 1")
        ])
      );
      expect(styles.findParagraphStyleById("Heading1")?.styleId).assertEqual("Heading1");
      done();
    });

    it('table style can be found by ID', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [
          tableStyleElement("TableNormal", "Normal Table")
        ])
      );
      expect(styles.findTableStyleById("TableNormal")?.styleId).assertEqual("TableNormal");
      done();
    });

    it('character style can be found by ID', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [
          characterStyleElement("Heading1Char", "Heading 1 Char")
        ])
      );
      expect(styles.findCharacterStyleById("Heading1Char")?.styleId).assertEqual("Heading1Char");
      done();
    });

    it('paragraph and character styles are distinct', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [
          paragraphStyleElement("Heading1", "Heading 1"),
          characterStyleElement("Heading1Char", "Heading 1 Char")
        ])
      );
      expect(styles.findCharacterStyleById("Heading1")).assertUndefined();
      expect(styles.findParagraphStyleById("Heading1Char")).assertUndefined();
      done();
    });

    it('character and table styles are distinct', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [
          tableStyleElement("Heading1", "Heading 1")
        ])
      );
      expect(styles.findCharacterStyleById("Heading1")).assertUndefined();
      done();
    });

    it('styles include names', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [
          paragraphStyleElement("Heading1", "Heading 1")
        ])
      );
      expect(styles.findParagraphStyleById("Heading1")?.name).assertEqual("Heading 1");
      done();
    });

    it('style name is null if w:name element does not exist', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [
          styleWithoutWNameElement("paragraph", "Heading1"),
          styleWithoutWNameElement("character", "Heading1Char")
        ])
      );
      expect(styles.findParagraphStyleById("Heading1")?.name).assertNull();
      expect(styles.findCharacterStyleById("Heading1Char")?.name).assertNull();
      done();
    });

    it('numbering style is null if no style with that ID exists', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [])
      );
      expect(styles.findNumberingStyleById("List1")).assertUndefined();
      done();
    });

    it('numbering style has null numId if style has no paragraph properties', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [
          new XmlModule.Element("w:style", { "w:type": "numbering", "w:styleId": "List1" })
        ])
      );
      expect(styles.findNumberingStyleById("List1")?.numId).assertUndefined();
      done();
    });

    it('numbering style has numId read from paragraph properties', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [
          new XmlModule.Element("w:style", { "w:type": "numbering", "w:styleId": "List1" }, [
            new XmlModule.Element("w:pPr", {}, [
              new XmlModule.Element("w:numPr", {}, [
                new XmlModule.Element("w:numId", { "w:val": "42" })
              ])
            ])
          ])
        ])
      );
      expect(styles.findNumberingStyleById("List1")?.numId).assertEqual("42");
      done();
    });

    it('when multiple style elements have same style ID then only first element is used', 0, (done: Function) => {
      const styles: StylesInterface = readStylesXml(
        new XmlModule.Element("w:styles", {}, [
          tableStyleElement("TableNormal", "Normal Table"),
          tableStyleElement("TableNormal", "Table Normal")
        ])
      );
      expect(styles.findTableStyleById("TableNormal")?.name).assertEqual("Normal Table");
      done();
    });
  });
}
