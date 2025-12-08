import { describe, it, expect } from '@ohos/hypium';
import * as documents from "@ohos/mammoth/src/main/ets/documents";
import * as documentToHtml from "@ohos/mammoth/src/main/ets/document-to-html";
import * as htmlPaths from "@ohos/mammoth/src/main/ets/styles/html-paths";
import * as xml from "@ohos/mammoth/src/main/ets/xml";
import * as results from "@ohos/mammoth/src/main/ets/results";
import * as documentMatchers from "@ohos/mammoth/src/main/ets/styles/document-matchers";
import * as Html from "@ohos/mammoth/src/main/ets/html";
import { CheckBoxType, CommentReference, CommentType, Converter, Result } from './Type';
import { buffer as Buffer } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

let DocumentConverter: ESObject = documentToHtml.DocumentConverter;
let commentAuthorLabel: ESObject = documentToHtml.commentAuthorLabel;
const Document: ESObject = documents.Document;
const Paragraph: ESObject = documents.Paragraph;
const Text: ESObject = documents.Text;
const Run: ESObject = documents.Run;
const NoteReference: ESObject = documents.NoteReference;
const Image: ESObject = documents.Image;
const Hyperlink: ESObject = documents.Hyperlink;
const BookmarkStart: ESObject = documents.BookmarkStart;
const Tab: ESObject = documents.Tab;
const Table: ESObject = documents.Table;
const TableRow: ESObject = documents.TableRow;
const TableCell: ESObject = documents.TableCell;
const Notes: ESObject = documents.Notes;
const Note: ESObject = documents.Note;

const paragraphOfText = (text: string, styleId?: string, styleName?: string): documents.Notes => {
  let run: documents.Notes = runOfText(text);
  return new Paragraph([run], {
    styleId: styleId,
    styleName: styleName
  });
}

const runOfText = (text?: string, properties?: ESObject): documents.Notes => {
  let textElement: documents.Notes = new Text(text);
  return new Run([textElement], properties);
}

interface StyleMap{
  from: ESObject;
  to: ESObject;
}

export default function documentToHtmlTest() {
  describe('documentToHtmlTest', () => {
    it('should empty document to empty string', 0, (done: Function) => {
      let document: documents.Notes = new Document([]);
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value).assertEqual("");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('should convert document containing one paragraph to single p element', 1, (done: Function) => {
      let document: documents.Notes = new Document([
        paragraphOfText("Hello.")
      ]);
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value).assertEqual("<p>Hello.</p>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('ignores empty paragraphs', 2, (done: Function) => {
      let document: documents.Notes = new Document([
        paragraphOfText("")
      ]);
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value).assertEqual("");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    })

    it('text is HTML-escaped', 3, (done: Function) => {
      let document: documents.Notes = new Document([
        paragraphOfText("1 < 2")
      ]);
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value).assertEqual("<p>1 &lt; 2</p>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('should convert document containing multiple paragraphs to multiple p elements', 4, (done: Function) => {
      let document: documents.Notes = new Document([
        paragraphOfText("Hello."),
        paragraphOfText("Goodbye.")
      ]);
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value).assertEqual("<p>Hello.</p><p>Goodbye.</p>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('uses style mappings to pick HTML element for docx paragraph', 5, (done: Function) => {
      let document: documents.Notes = new Document([
        paragraphOfText("Hello.", "Heading1", "Heading 1")
      ]);
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.paragraph({ styleName: documentMatchers.equalTo("Heading 1") }),
          to: htmlPaths.topLevelElement("h1")
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value).assertEqual("<h1>Hello.</h1>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('mappings for style names are case insensitive', 6, (done: Function) => {
      let document: documents.Notes = new Document([
        paragraphOfText("Hello.", "Heading1", "heading 1")
      ]);
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.paragraph({ styleName: documentMatchers.equalTo("Heading 1") }),
          to: htmlPaths.topLevelElement("h1")
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value).assertEqual("<h1>Hello.</h1>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('can use non-default HTML element for unstyled paragraphs', 7, (done: Function) => {
      let document: documents.Notes = new Document([
        paragraphOfText("Hello.")
      ]);
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.paragraph(),
          to: htmlPaths.topLevelElement("h1")
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value).assertEqual("<h1>Hello.</h1>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('warning is emitted if paragraph style is unrecognised', 8, (done: Function) => {
      let document: documents.Notes = new Document([
        paragraphOfText("Hello.", "Heading1", "Heading 1")
      ]);
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.messages)
          .assertDeepEquals([results.warning("Unrecognised paragraph style: 'Heading 1' (Style ID: Heading1)")]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('can use stacked styles to generate nested HTML elements', 9, (done: Function) => {
      let document: documents.Notes = new Document([
        paragraphOfText("Hello.")
      ]);
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.paragraph(),
          to: htmlPaths.elements(["h1", "span"])
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value).assertEqual("<h1><span>Hello.</span></h1>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('bold runs are wrapped in <strong> tags by default', 10, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isBold: true });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<strong>Hello.</strong>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('bold runs can be configured with style mapping', 11, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isBold: true });
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.bold,
          to: htmlPaths.elements([htmlPaths.element("em")])
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<em>Hello.</em>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('bold runs can exist inside other tags', 12, (done: Function) => {
      let run: documents.Notes = new Paragraph([
        runOfText("Hello.", { isBold: true })
      ]);
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<p><strong>Hello.</strong></p>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('consecutive bold runs are wrapped in a single <strong> element', 13, (done: Function) => {
      let paragraph: documents.Notes = new Paragraph([
        runOfText("Hello", { isBold: true }),
        runOfText(".", { isBold: true })
      ]);
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(paragraph).then((result: Result) => {
        expect(result.value).assertEqual("<p><strong>Hello.</strong></p>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('underline runs are ignored by default', 14, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isUnderline: true });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("Hello.");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('underline runs can be mapped using style mapping', 15, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isUnderline: true });
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.underline,
          to: htmlPaths.elements([htmlPaths.element("u")])
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<u>Hello.</u>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('style mapping for underline runs does not close parent elements', 16, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isUnderline: true, isBold: true });
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.underline,
          to: htmlPaths.elements([htmlPaths.element("u")])
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<strong><u>Hello.</u></strong>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('strikethrough runs are wrapped in <s> tags by default', 17, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isStrikethrough: true });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<s>Hello.</s>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('strikethrough runs can be configured with style mapping', 18, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isStrikethrough: true });
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.strikethrough,
          to: htmlPaths.elements([htmlPaths.element("del")])
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<del>Hello.</del>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('italic runs are wrapped in <em> tags', 19, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isItalic: true });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<em>Hello.</em>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('italic runs can be configured with style mapping', 20, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isItalic: true });
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.italic,
          to: htmlPaths.elements([htmlPaths.element("strong")])
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<strong>Hello.</strong>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('run can be both bold and italic', 21, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isBold: true, isItalic: true });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<strong><em>Hello.</em></strong>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('superscript runs are wrapped in <sup> tags', 22, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", {
        verticalAlignment: documents.verticalAlignment.superscript
      });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<sup>Hello.</sup>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('subscript runs are wrapped in <sub> tags', 23, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", {
        verticalAlignment: documents.verticalAlignment.subscript
      });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<sub>Hello.</sub>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('all caps runs are ignored by default', 24, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isAllCaps: true });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("Hello.");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('all caps runs can be configured with style mapping', 25, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isAllCaps: true });
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.allCaps,
          to: htmlPaths.elements([htmlPaths.element("span")])
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<span>Hello.</span>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });


    it('small caps runs are ignored by default', 26, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isSmallCaps: true });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("Hello.");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('small caps runs can be configured with style mapping', 27, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { isSmallCaps: true });
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.smallCaps,
          to: htmlPaths.elements([htmlPaths.element("span")])
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<span>Hello.</span>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });


    it('highlighted runs are ignored by default', 28, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { highlight: "yellow" });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("Hello.");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      });
    });

    it('highlighted runs can be configured with style mapping for all highlights', 29, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { highlight: "yellow" });
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.highlight(null),
          to: htmlPaths.elements([htmlPaths.element("mark")])
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<mark>Hello.</mark>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('highlighted runs can be configured with style mapping for specific highlight color', 30, (done: Function) => {
      let paragraph: documents.Notes = new Paragraph([
        runOfText("Yellow", { highlight: "yellow" }),
        runOfText("Red", { highlight: "red" })
      ]);
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.highlight({ color: "yellow" }),
          to: htmlPaths.elements([htmlPaths.element("mark", { "class": "yellow" })])
        },
        {
          from: documentMatchers.highlight({ color: undefined }),
          to: htmlPaths.elements([htmlPaths.element("mark")])
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(paragraph).then((result: Result) => {
        expect(result.value).assertEqual('<p><mark class="yellow">Yellow</mark><mark>Red</mark></p>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });


    it('run styles are converted to HTML if mapping exists', 31, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { styleId: "Heading1Char", styleName: "Heading 1 Char" });
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.run({ styleName: documentMatchers.equalTo("Heading 1 Char") }),
          to: htmlPaths.elements(["strong"])
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual("<strong>Hello.</strong>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('warning is emitted if run style is unrecognised', 32, (done: Function) => {
      let run: documents.Notes = runOfText("Hello.", { styleId: "Heading1Char", styleName: "Heading 1 Char" });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(run).then((result: Result) => {
        expect(result.messages)
          .assertDeepEquals([results.warning("Unrecognised run style: 'Heading 1 Char' (Style ID: Heading1Char)")]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('docx hyperlink is converted to <a>', 33, (done: Function) => {
      let hyperlink: documents.Notes = new Hyperlink(
        [runOfText("Hello.")],
        { href: "http://www.example.com" }
      );
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(hyperlink).then((result: Result) => {
        expect(result.value).assertEqual('<a href="http://www.example.com">Hello.</a>');
        done();
      });
    });

    it('docx hyperlink can be collapsed', 34, (done: Function) => {
      let hyperlink: documents.Notes = new Document([
        new Hyperlink(
          [runOfText("Hello ")],
          { href: "http://www.example.com" }
        ),
        new Hyperlink(
          [runOfText("world")],
          { href: "http://www.example.com" }
        )
      ]);
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(hyperlink).then((result: Result) => {
        expect(result.value).assertEqual('<a href="http://www.example.com">Hello world</a>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('docx hyperlink with anchor is converted to <a>', 35, (done: Function) => {
      let hyperlink: documents.Notes = new Hyperlink(
        [runOfText("Hello.")],
        { anchor: "_Peter" }
      );
      let converter: Converter = new DocumentConverter({
        idPrefix: "doc-42-"
      });
      converter.convertToHtml(hyperlink).then((result: Result) => {
        expect(result.value).assertEqual('<a href="#doc-42-_Peter">Hello.</a>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('hyperlink target frame is used as anchor target', 36, (done: Function) => {
      let hyperlink: documents.Notes = new Hyperlink(
        [runOfText("Hello.")],
        { anchor: "start", targetFrame: "_blank" }
      );
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(hyperlink).then((result: Result) => {
        expect(result.value).assertEqual('<a href="#start" target="_blank">Hello.</a>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('unchecked checkbox is converted to unchecked checkbox input', 37, (done: Function) => {
      let checkbox: CheckBoxType= documents.checkbox({ checked: false });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(checkbox).then((result: Result) => {
        expect(result.value).assertEqual('<input type="checkbox" />');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('checked checkbox is converted to checked checkbox input', 38, (done: Function) => {
      let checkbox: CheckBoxType = documents.checkbox({ checked: true });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(checkbox).then((result: Result) => {
        expect(result.value).assertEqual('<input type="checkbox" checked="checked" />');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('bookmarks are converted to anchors', 39, (done: Function) => {
      let bookmarkStart: documents.Notes = new BookmarkStart({ name: "_Peter" });
      let converter: Converter = new DocumentConverter({
        idPrefix: "doc-42-"
      });
      let document: documents.Notes = new Document([bookmarkStart]);
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value).assertEqual('<a id="doc-42-_Peter"></a>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('docx tab is converted to tab in HTML', 40, (done: Function) => {
      let tab: documents.Notes = new Tab();
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(tab).then((result: Result) => {
        expect(result.value).assertEqual("\t");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('docx table is converted to table in HTML', 41, (done: Function) => {
      let table: documents.Notes = new Table([
        new TableRow([
          new TableCell([paragraphOfText("Top left")]),
          new TableCell([paragraphOfText("Top right")])
        ]),
        new TableRow([
          new TableCell([paragraphOfText("Bottom left")]),
          new TableCell([paragraphOfText("Bottom right")])
        ])
      ]);
      let converter: Converter = new DocumentConverter();

      converter.convertToHtml(table).then((result: Result) => {
        let expectedHtml = "<table>" +
          "<tr><td><p>Top left</p></td><td><p>Top right</p></td></tr>" +
          "<tr><td><p>Bottom left</p></td><td><p>Bottom right</p></td></tr>" +
          "</table>";
        expect(result.value).assertEqual(expectedHtml);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('table style mappings can be used to map tables', 42, (done: Function) => {
      let table: documents.Notes = new Table([], { styleName: "Normal Table" });
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.table({ styleName: documentMatchers.equalTo("Normal Table") }),
          to: htmlPaths.topLevelElement("table", { "class": "normal-table" })
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });

      converter.convertToHtml(table).then((result: Result) => {
        let expectedHtml = '<table class="normal-table"></table>';
        expect(result.value).assertEqual(expectedHtml);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('header rows are wrapped in thead', 43, (done: Function) => {
      let table: documents.Notes = new Table([
        new TableRow([new TableCell([])], { isHeader: true }),
        new TableRow([new TableCell([])], { isHeader: true }),
        new TableRow([new TableCell([])], { isHeader: false })
      ]);
      let converter: Converter = new DocumentConverter();

      converter.convertToHtml(table).then((result: Result) => {
        let expectedHtml = "<table>" +
          "<thead><tr><th></th></tr><tr><th></th></tr></thead>" +
          "<tbody><tr><td></td></tr></tbody>" +
          "</table>";
        expect(result.value).assertEqual(expectedHtml);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('tbody is omitted if all rows are headers', 44, (done: Function) => {
      let table: documents.Notes = new Table([
        new TableRow([new TableCell([])], { isHeader: true })
      ]);
      let converter: Converter = new DocumentConverter();

      converter.convertToHtml(table).then((result: Result) => {
        let expectedHtml = "<table>" +
          "<thead><tr><th></th></tr></thead>" +
          "</table>";
        expect(result.value).assertEqual(expectedHtml);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('unexpected table children do not cause error', 45, (done: Function) => {
      let table: documents.Notes = new Table([
        new Tab()
      ]);
      let converter: Converter = new DocumentConverter();

      converter.convertToHtml(table).then((result: Result) => {
        let expectedHtml = "<table>\t</table>";
        expect(result.value).assertEqual(expectedHtml);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('empty cells are preserved in table', 46, (done: Function) => {
      let table: documents.Notes = new Table([
        new TableRow([
          new TableCell([paragraphOfText("")]),
          new TableCell([paragraphOfText("Top right")])
        ])
      ]);
      let converter: Converter = new DocumentConverter();

      converter.convertToHtml(table).then((result: Result) => {
        let expectedHtml = "<table>" +
          "<tr><td></td><td><p>Top right</p></td></tr>" +
          "</table>";
        expect(result.value).assertEqual(expectedHtml);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('empty rows are preserved in table', 47, (done: Function) => {
      let table: documents.Notes = new Table([
        new TableRow([
          new TableCell([paragraphOfText("Row 1")])
        ]),
        new TableRow([])
      ]);
      let converter: Converter = new DocumentConverter();

      converter.convertToHtml(table).then((result: Result) => {
        let expectedHtml = "<table>" +
          "<tr><td><p>Row 1</p></td></tr><tr></tr>" +
          "</table>";
        expect(result.value).assertEqual(expectedHtml);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('table cells are written with colSpan if not equal to one', 48, (done: Function) => {
      let table: documents.Notes = new Table([
        new TableRow([
          new TableCell([paragraphOfText("Top left")], { colSpan: 2 }),
          new TableCell([paragraphOfText("Top right")])
        ])
      ]);
      let converter: Converter = new DocumentConverter();

      converter.convertToHtml(table).then((result: Result) => {
        let expectedHtml = "<table>" +
          "<tr><td colspan=\"2\"><p>Top left</p></td><td><p>Top right</p></td></tr>" +
          "</table>";
        expect(result.value).assertEqual(expectedHtml);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('table cells are written with rowSpan if not equal to one', 49, (done: Function) => {
      let table: documents.Notes = new Table([
        new TableRow([
          new TableCell([], { rowSpan: 2 })
        ])
      ]);
      let converter: Converter = new DocumentConverter();

      converter.convertToHtml(table).then((result: Result) => {
        let expectedHtml = "<table>" +
          "<tr><td rowspan=\"2\"></td></tr>" +
          "</table>";
        expect(result.value).assertEqual(expectedHtml);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('line break is converted to <br>', 50, (done: Function) => {
      let converter: Converter = new DocumentConverter();

      converter.convertToHtml(documents.lineBreak).then((result: Result) => {
        expect(result.value).assertEqual("<br />");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('breaks that are not line breaks are ignored',51, (done: Function) => {
      let converter: Converter = new DocumentConverter();

      converter.convertToHtml(documents.pageBreak).then((result: Result) => {
        expect(result.value).assertEqual("");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('breaks can be mapped using style mappings', 52, (done: Function) => {
      let styleMap: StyleMap[] = [
        {
          from: documentMatchers.pageBreak,
          to: htmlPaths.topLevelElement("hr")
        },
        {
          from: documentMatchers.lineBreak,
          to: htmlPaths.topLevelElement("br", { class: "line-break" })
        }
      ]
      let converter: Converter = new DocumentConverter({
        styleMap: styleMap
      });

      let run: ESObject = documents.run([documents.pageBreak, documents.lineBreak]);

      converter.convertToHtml(run).then((result: Result) => {
        expect(result.value).assertEqual('<hr /><br class="line-break" />');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('footnote reference is converted to superscript intra-page link', 53, (done: Function) => {
      let footnoteReference: documents.Notes = new NoteReference({
        noteType: "footnote",
        noteId: "4"
      });
      let converter: Converter = new DocumentConverter({
        idPrefix: "doc-42-"
      });
      converter.convertToHtml(footnoteReference).then((result: Result) => {
        expect(result.value).assertEqual('<sup><a href="#doc-42-footnote-4" id="doc-42-footnote-ref-4">[1]</a></sup>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('footnotes are included after the main body', 54, (done: Function) => {
      let footnoteReference: documents.Notes = new NoteReference({
        noteType: "footnote",
        noteId: "4"
      });
      let document: documents.Notes = new Document(
        [new Paragraph([
          runOfText("Knock knock"),
          new Run([footnoteReference])
        ])],
        {
          notes: new Notes({
            '4': new Note({
              noteType: "footnote",
              noteId: "4",
              body: [paragraphOfText("Who's there?")]
            })
          })
        }
      );

      let converter: Converter = new DocumentConverter({
        idPrefix: "doc-42-"
      });
      converter.convertToHtml(document).then((result: Result) => {
        let expectedOutput =
          '<p>Knock knock<sup><a href="#doc-42-footnote-4" id="doc-42-footnote-ref-4">[1]</a></sup></p>' +
            '<ol><li id="doc-42-footnote-4"><p>Who\'s there? <a href="#doc-42-footnote-ref-4">↑</a></p></li></ol>';
        expect(result.value).assertEqual(expectedOutput);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('comments are ignored by default', 55, (done: Function) => {
      let reference: CommentReference = documents.commentReference({ commentId: "4" });
      let comment: CommentType = documents.comment({
        commentId: "4",
        body: [paragraphOfText("Who's there?")]
      });
      let document: ESObject = documents.document([
        documents.paragraph([
          runOfText("Knock knock"),
          documents.run([reference])
        ])
      ], { comments: [comment] });

      let converter: Converter = new DocumentConverter({});
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value).assertEqual('<p>Knock knock</p>');
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('comment references are linked to comment after main body', 56, (done: Function) => {
      let reference: CommentReference = documents.commentReference({ commentId: "4" });
      let comment: CommentType = documents.comment({
        commentId: "4",
        body: [paragraphOfText("Who's there?")],
        authorName: "The Piemaker",
        authorInitials: "TP"
      });
      let document: ESObject = documents.document([
        documents.paragraph([
          runOfText("Knock knock"),
          documents.run([reference])
        ])
      ], { comments: [comment] });

      let styleMap: StyleMap[] = [
        { from: documentMatchers.commentReference, to: htmlPaths.element("sup") }
      ]
      let converter: Converter = new DocumentConverter({
        idPrefix: "doc-42-",
        styleMap: styleMap
      });
      converter.convertToHtml(document).then((result: Result) => {
        let expectedHtml = (
          '<p>Knock knock<sup><a href="#doc-42-comment-4" id="doc-42-comment-ref-4">[TP1]</a></sup></p>' +
            '<dl><dt id="doc-42-comment-4">Comment [TP1]</dt><dd><p>Who\'s there? <a href="#doc-42-comment-ref-4">↑</a></p></dd></dl>'
        );
        expect(result.value).assertEqual(expectedHtml);
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('images are written with data URIs', 57, (done: Function) => {
      let imageBuffer: Buffer.Buffer = Buffer.from("Not an image at all!");
      let image: documents.Notes = new Image({
        readImage: (encoding: string) => {
          return Promise.resolve(imageBuffer.toString(encoding));
        },
        contentType: "image/png"
      });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(image).then((result: Result) => {
        expect(result.value).assertEqual('<img src="data:image/png;base64,' + imageBuffer.toString("base64") + '" />');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('images have alt attribute if available', 58, (done: Function) => {
      let imageBuffer = Buffer.from("Not an image at all!");
      let image: documents.Notes = new Image({
        readImage: () => {
          return Promise.resolve(imageBuffer);
        },
        altText: "It's a hat"
      });
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(image)
        .then((result: Result): ESObject => {
          return xml.readString(result.value);
        })
        .then((htmlImageElement: ESObject) => {
          expect(htmlImageElement.attributes.alt).assertDeepEquals("It's a hat");
          done();
        }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('can add custom handler for images', 59, (done: Function) => {
      let imageBuffer = Buffer.from("Not an image at all!");
      let image: documents.Notes = new Image({
        readImage: (encoding: string) => {
          return Promise.resolve(imageBuffer.toString(encoding));
        },
        contentType: "image/png"
      });
      let converter: Converter = new DocumentConverter({
        convertImage: (element: ESObject, messages: string): ESObject => {
          return element.read("utf8").then((altText: string) => {
            return [Html.freshElement("img", { alt: altText })];
          });
        }
      });
      converter.convertToHtml(image).then((result: Result) => {
        expect(result.value).assertEqual('<img alt="Not an image at all!" />');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('when custom image handler throws error then error is stored in error message', 60, (done: Function) => {
      let error = new Error("Failed to convert image");
      let image: documents.Notes = new Image({
        readImage: (encoding: string) => {
          return Promise.resolve(Buffer.from('').toString(encoding));
        },
        contentType: "image/png"
      });
      let converter: Converter = new DocumentConverter({
        convertImage: (element: ESObject, messages: string) => {
          throw error;
        }
      });
      converter.convertToHtml(image).then((result: Result) => {
        expect(result.value).assertEqual('');
        expect(result.messages.length).assertEqual(1);
        let message: ESObject = result.messages[0];
        expect("error").assertEqual(message.type);
        expect("Failed to convert image").assertEqual(message.message);
        expect(error).assertDeepEquals(message.error);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('long documents do not cause stack overflow', 61, (done: Function) => {
      let paragraphs: Array<documents.Notes> = [];
      for (let i = 0; i < 1000; i++) {
        paragraphs.push(paragraphOfText("Hello."));
      }
      let document: documents.Notes = new Document(paragraphs);
      let converter: Converter = new DocumentConverter();
      converter.convertToHtml(document).then((result: Result) => {
        expect(result.value.indexOf("<p>Hello.</p>")).assertEqual(0);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('when initials are not blank then comment author label is initials', 62, (done: Function) => {
      expect(commentAuthorLabel({ authorInitials: "TP" })).assertEqual("TP");
      done();
    });

    it('when initials are blank then comment author label is blank', 63, (done: Function) => {
      expect(commentAuthorLabel({ authorInitials: "" })).assertEqual("");
      expect(commentAuthorLabel({ authorInitials: undefined })).assertEqual("");
      expect(commentAuthorLabel({ authorInitials: null })).assertEqual("");
      done();
    });
  });
}
