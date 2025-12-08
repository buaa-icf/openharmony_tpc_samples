import { describe, expect, it } from "@ohos/hypium";
import hilog from '@ohos.hilog';
import * as writer from "@ohos/mammoth/src/main/ets/xml/writer";
import * as xml from "@ohos/mammoth/src/main/ets/xml/index";
import { Element } from "@ohos/mammoth/src/main/ets/xml/nodes";

function assertXmlString(element: Element, namespaceMap: Record<string, string>, expected: string): void {
  const result = xml.writeString(element, namespaceMap) as string
  expect(result).assertEqual('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' + expected);
}

export default function writerTest() {
  describe('writerTest', () => {

    it('writing empty root element writes out xml declaration and empty root element', 0, (done: Function) => {
      const element = xml.element("root") as  Element;
      const namespaceMap: Record<string, string> = {};
      const expected = '<root/>';
      assertXmlString(element, namespaceMap, expected);
      done();
    });

    it('can write empty child elements', 0, (done: Function) => {
      const element = xml.element("root", {}, [
        xml.element("album"),
        xml.element("single")
      ]) as  Element;
      const namespaceMap: Record<string, string> = {};
      const expected = '<root><album/><single/></root>';
      assertXmlString(element, namespaceMap, expected);
      done();
    });

    it('can write empty descendant elements', 0, (done: Function) => {
      const element = xml.element("root", {}, [
        xml.element("album", {}, [
          xml.element("year"),
          xml.element("song")
        ])
      ]) as  Element;
      const namespaceMap: Record<string, string> = {};
      const expected = '<root><album><year/><song/></album></root>';
      assertXmlString(element, namespaceMap, expected);
      done();
    });

    it('can write element attributes', 0, (done: Function) => {
      const element = xml.element("root", {}, [
        xml.element("album", {"title": "Everything in Transit"})
      ]) as  Element;
      const namespaceMap: Record<string, string> = {};
      const expected = '<root><album title="Everything in Transit"/></root>';
      assertXmlString(element, namespaceMap, expected);
      done();
    });

    it('can write text nodes', 0, (done: Function) => {
      const element = xml.element("root", {}, [
        xml.element("album", {}, [
          xml.text("Everything in Transit")
        ])
      ]) as  Element;
      const namespaceMap: Record<string, string> = {};
      const expected = '<root><album>Everything in Transit</album></root>';
      assertXmlString(element, namespaceMap, expected);
      done();
    });

    it('can write root element with long-form prefix when URI is namespace', 0, (done: Function) => {
      const element = xml.element("{music}root") as  Element;
      const namespaceMap: Record<string, string> = {"m": "music"};
      const expected = '<m:root xmlns:m="music"/>';
      assertXmlString(element, namespaceMap, expected);
      done();
    });

    it('can write child elements with long-form prefix when URI is namespace', 0, (done: Function) => {
      const element = xml.element("root", {}, [
        xml.element("{music}album")
      ]) as  Element;
      const namespaceMap: Record<string, string> = {"m": "music"};
      const expected = '<root xmlns:m="music"><m:album/></root>';
      assertXmlString(element, namespaceMap, expected);
      done();
    });

    it('can write child elements with short-form prefix when URI is namespace', 0, (done: Function) => {
      const element = xml.element("root", {}, [
        xml.element("m:album")
      ]) as  Element;
      const namespaceMap: Record<string, string> = {"m": "music"};
      const expected = '<root xmlns:m="music"><m:album/></root>';
      assertXmlString(element, namespaceMap, expected);
      done();
    });

    it('default namespace has key of empty string', 0, (done: Function) => {
      const element = xml.element("root", {}, [
        xml.element("{music}album")
      ]) as  Element
      const namespaceMap: Record<string, string> = {"": "music"};
      const expected = '<root xmlns="music"><album/></root>';
      assertXmlString(element, namespaceMap, expected);
      done();
    });

    // 额外的测试用例：测试特殊字符转义
    it('should escape special characters in text', 0, (done: Function) => {
      const element = xml.element("root", {}, [
        xml.element("data", {}, [
          xml.text('Test & "special" <characters>')
        ])
      ]) as  Element
      const namespaceMap: Record<string, string> = {};
      const expected = '<root><data>Test &amp; "special" &lt;characters&gt;</data></root>';
      assertXmlString(element, namespaceMap, expected);
      done();
    });

    // 额外的测试用例：测试属性值的转义
    it('should escape special characters in attributes', 0, (done: Function) => {
      const element = xml.element("root", {}, [
        xml.element("data", {"value": 'Test & "quotes"'})
      ]) as  Element
      const namespaceMap: Record<string, string> = {};
      const expected = '<root><data value="Test &amp; &quot;quotes&quot;"/></root>';
      assertXmlString(element, namespaceMap, expected);
      done();
    });

  })
}
