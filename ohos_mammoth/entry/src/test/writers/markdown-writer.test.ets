import { describe, expect, it } from "@ohos/hypium";
import * as mdWriter from "@ohos/mammoth/src/main/ets/writers/markdown-writer";

interface MdWriter {
  open(tag: string, attributes?: Record<string, string>): void;
  close(tag: string): void;
  text(content: string): void;
  selfClosing(tag: string, attributes?: Record<string, string>): void;
  asString(): string;
}
interface Attributes {
  id: string;
}

function createWriter(): MdWriter {
  return mdWriter.writer();
}

export default function markdown_writerTest() {
  describe('markdown_writerTest', () => {

    it('special markdown characters are escaped', 0, (done: Function) => {
      const writer = createWriter();
      writer.text("\\*");
      const expected = "\\\\\\*";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('unrecognised elements are treated as normal text', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("blah");
      writer.text("Hello");
      writer.close("blah");
      const expected = "Hello";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('paragraphs are terminated with double new line', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("p");
      writer.text("Hello");
      writer.close("p");
      const expected = "Hello\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('h1 elements are converted to heading with leading hash', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("h1");
      writer.text("Hello");
      writer.close("h1");
      const expected = "# Hello\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('h6 elements are converted to heading with six leading hashes', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("h6");
      writer.text("Hello");
      writer.close("h6");
      const expected = "###### Hello\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('br is written as two spaces followed by new line', 0, (done: Function) => {
      const writer = createWriter();
      writer.text("Hello World");
      writer.selfClosing("br");
      const expected = "Hello World  \n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('strong text is surrounded by two underscores', 0, (done: Function) => {
      const writer = createWriter();
      writer.text("Hello ");
      writer.open("strong");
      writer.text("World");
      writer.close("strong");
      const expected = "Hello __World__";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('emphasised text is surrounded by one asterisk', 0, (done: Function) => {
      const writer = createWriter();
      writer.text("Hello ");
      writer.open("em");
      writer.text("World");
      writer.close("em");
      const expected = "Hello *World*";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('anchor tags are written as hyperlinks', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("a", { "href": "http://example.com" });
      writer.text("Hello");
      writer.close("a");
      const expected = "[Hello](http://example.com)";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('anchor tags without href attribute are treated as ordinary text', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("a");
      writer.text("Hello");
      writer.close("a");
      const expected = "Hello";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('elements with IDs have anchor tags with IDs appended to start of markdown element', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("h1", { "id": "start" });
      writer.text("Hello");
      writer.close("h1");
      const expected = '# <a id="start"></a>Hello\n\n';
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('links have anchors before opening square bracket', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("a", { "href": "http://example.com", "id": "start" });
      writer.text("Hello");
      writer.close("a");
      const expected = '<a id="start"></a>[Hello](http://example.com)';
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('can generate images', 0, (done: Function) => {
      const writer = createWriter();
      writer.selfClosing("img", { "src": "http://example.com/image.jpg", "alt": "Alt Text" });
      const expected = "![Alt Text](http://example.com/image.jpg)";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('can generate images with missing alt attribute', 0, (done: Function) => {
      const writer = createWriter();
      writer.selfClosing("img", { "src": "http://example.com/image.jpg" });
      const expected = "![](http://example.com/image.jpg)";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('can generate images with missing src attribute', 0, (done: Function) => {
      const writer = createWriter();
      writer.selfClosing("img", { "alt": "Alt Text" });
      const expected = "![Alt Text]()";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it("doesn't display empty images", 0, (done: Function) => {
      const writer = createWriter();
      writer.selfClosing("img");
      const expected = "";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('list item outside of list is treated as unordered list', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("li");
      writer.text("Hello");
      writer.close("li");
      const expected = "- Hello\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('can generate an ordered list', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("ol");
      writer.open("li");
      writer.text("Hello");
      writer.close("li");
      writer.open("li");
      writer.text("World");
      writer.close("li");
      writer.close("ol");
      const expected = "1. Hello\n2. World\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('can generate an unordered list', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("ul");
      writer.open("li");
      writer.text("Hello");
      writer.close("li");
      writer.open("li");
      writer.text("World");
      writer.close("li");
      writer.close("ul");
      const expected = "- Hello\n- World\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('can generate a nested ordered list with correct numbering', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("ol");
      writer.open("li");
      writer.text("Outer One");

      writer.open("ol");
      writer.open("li");
      writer.text("Nested One");
      writer.close("li");
      writer.open("li");
      writer.text("Nested Two");
      writer.close("li");
      writer.close("ol");

      writer.close("li");
      writer.open("li");
      writer.text("Outer Two");
      writer.close("li");
      writer.close("ol");
      const expected = "1. Outer One\n\t1. Nested One\n\t2. Nested Two\n2. Outer Two\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('can generate a multi-level nested ordered list', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("ol");
      writer.open("li");
      writer.text("Outer One");

      writer.open("ol");
      writer.open("li");
      writer.text("Nested One");

      writer.open("ol");
      writer.open("li");
      writer.text("Inner One");
      writer.close("li");
      writer.close("ol");

      writer.close("li");
      writer.close("ol");

      writer.close("li");
      writer.close("ol");
      const expected = "1. Outer One\n\t1. Nested One\n\t\t1. Inner One\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('new ordered list resets numbering', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("ol");
      writer.open("li");
      writer.text("First");
      writer.close("li");
      writer.close("ol");

      writer.open("p");
      writer.text("Hello");
      writer.close("p");

      writer.open("ol");
      writer.open("li");
      writer.text("Second");
      writer.close("li");
      writer.close("ol");

      const expected = "1. First\n\nHello\n\n1. Second\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('can generate a nested unordered list', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("ul");
      writer.open("li");
      writer.text("Outer One");

      writer.open("ul");
      writer.open("li");
      writer.text("Nested One");
      writer.close("li");
      writer.open("li");
      writer.text("Nested Two");
      writer.close("li");
      writer.close("ul");

      writer.close("li");
      writer.open("li");
      writer.text("Outer Two");
      writer.close("li");
      writer.close("ul");
      const expected = "- Outer One\n\t- Nested One\n\t- Nested Two\n- Outer Two\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('can nest inline elements', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("p");
      writer.text("Lorem ");
      writer.open("strong");
      writer.text("ipsum ");
      writer.open("em");
      writer.text("dolor");
      writer.close("em");
      writer.text(" sit");
      writer.close("strong");
      writer.text(" amet");
      writer.close("p");
      const expected = "Lorem __ipsum *dolor* sit__ amet\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('can emphasise list text', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("ol");
      writer.open("li");
      writer.text("Hello ");
      writer.open("strong");
      writer.text("Strong");
      writer.close("strong");
      writer.text(" World");
      writer.close("li");
      writer.open("li");
      writer.text("Hello ");
      writer.open("em");
      writer.text("Emphasis");
      writer.close("em");
      writer.text(" World");
      writer.close("li");
      writer.close("ol");
      const expected = "1. Hello __Strong__ World\n2. Hello *Emphasis* World\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

    it('generates correct spacing between paragraphs and lists', 0, (done: Function) => {
      const writer = createWriter();
      writer.open("p");
      writer.text("Hello World");
      writer.close("p");
      writer.open("ul");
      writer.open("li");
      writer.text("First Item");
      writer.close("li");
      writer.open("li");
      writer.text("Second Item");
      writer.close("li");
      writer.close("ul");
      writer.open("p");
      writer.text("Hello World");
      writer.close("p");
      const expected = "Hello World\n\n- First Item\n- Second Item\n\nHello World\n\n";
      expect(writer.asString()).assertEqual(expected);
      done();
    });

  })
}
