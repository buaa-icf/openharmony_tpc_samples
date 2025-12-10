import { describe, it, expect } from '@ohos/hypium';
import * as htmlPaths from "@ohos/mammoth/src/main/ets/styles/html-paths";
import * as documentMatchers from "@ohos/mammoth/src/main/ets/styles/document-matchers";
import * as styleReader from "@ohos/mammoth/src/main/ets/style-reader";
import * as results from "@ohos/mammoth/src/main/ets/results";

let readHtmlPath: Function = styleReader.readHtmlPath;
let readDocumentMatcher: Function = styleReader.readDocumentMatcher;
let readStyle: Function = styleReader.readStyle;

const assertHtmlPath = (input: string, expected: ESObject) => {
  expect(readHtmlPath(input)).assertDeepEquals(results.success(expected));
}

const assertDocumentMatcher = (input: string, expected: ESObject) => {
  expect(readDocumentMatcher(input)).assertDeepEquals(results.success(expected));
}

const assertStyleMapping = (input: string, expected: ESObject) => {
  expect(readStyle(input)).assertDeepEquals(results.success(expected));
}

export default function styleReaderTest() {
  describe('styleReaderTest', () => {
    it('styleReader.readHtmlPath reads empty path', 0, (done: Function) => {
      assertHtmlPath("", htmlPaths.empty);
      done();
    })

    it('styleReader.readHtmlPath reads single element', 1, (done: Function) => {
      assertHtmlPath("p", htmlPaths.elements(["p"]));
      done();
    })

    it('styleReader.readHtmlPath reads choice of elements', 2, (done: Function) => {
      assertHtmlPath(
        "ul|ol",
        htmlPaths.elements([
          htmlPaths.element(["ul", "ol"])
        ])
      );
      done();
    })


    it('styleReader.readHtmlPathreads nested elements', 3, (done: Function) => {
      assertHtmlPath("ul > li", htmlPaths.elements(["ul", "li"]));
      done();
    })

    it('styleReader.readHtmlPathreads class on element', 4, (done: Function) => {
      let expected: ESObject = htmlPaths.elements([
        htmlPaths.element("p", { "class": "tip" })
      ]);
      assertHtmlPath("p.tip", expected);
      done();
    })

    it('styleReader.readHtmlPathreads class with escaped colon', 5, (done: Function) => {
      let expected: ESObject = htmlPaths.elements([
        htmlPaths.element("p", { "class": "a:b" })
      ]);
      assertHtmlPath("p.a\\:b", expected);
      done();
    })

    it('styleReader.readHtmlPathreads multiple classes on element', 6, (done: Function) => {
      let expected: ESObject = htmlPaths.elements([
        htmlPaths.element("p", { "class": "tip help" })
      ]);
      assertHtmlPath("p.tip.help", expected);
      done();
    })

    it('styleReader.readHtmlPathreads attribute on element', 7, (done: Function) => {
      let expected: ESObject = htmlPaths.elements([
        htmlPaths.element("p", { "lang": "fr" })
      ]);
      assertHtmlPath("p[lang='fr']", expected);
      done();
    })

    it('styleReader.readHtmlPathreads multiple attributes on element', 8, (done: Function) => {
      let expected: ESObject = htmlPaths.elements([
        htmlPaths.element("p", { "lang": "fr", "data-x": "y" })
      ]);
      assertHtmlPath("p[lang='fr'][data-x='y']", expected);
      done();
    })

    it('styleReader.readHtmlPathreads when element must be fresh', 9, (done: Function) => {
      let expected: ESObject = htmlPaths.elements([
        htmlPaths.element("p", {}, { "fresh": true })
      ]);
      assertHtmlPath("p:fresh", expected);
      done();
    })

    it('styleReader.readHtmlPathreads separator for elements', 10, (done: Function) => {
      let expected: ESObject = htmlPaths.elements([
        htmlPaths.element("p", {}, { separator: "x" })
      ]);
      assertHtmlPath("p:separator('x')", expected);
      done();
    })

    it('styleReader.readHtmlPathreads separator with escape sequence', 11, (done: Function) => {
      let expected: ESObject = htmlPaths.elements([
        htmlPaths.element("p", {}, { separator: "\r\n\t\'\\" })
      ]);
      assertHtmlPath("p:separator('\\r\\n\\t\\'\\\\')", expected);
      done();
    })

    it('styleReader.readHtmlPathreads ignore element', 12, (done: Function) => {
      assertHtmlPath("!", htmlPaths.ignore);
      done();
    })

    it("styleReader.readDocumentMatcher reads plain paragraph", 13, (done: Function) => {
      assertDocumentMatcher("p", documentMatchers.paragraph());
      done();
    })

    it("styleReader.readDocumentMatcher reads paragraph with style ID", 14, (done: Function) => {
      assertDocumentMatcher(
        "p.Heading1",
        documentMatchers.paragraph({ styleId: "Heading1" })
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads paragraph with exact style name", 15, (done: Function) => {
      assertDocumentMatcher(
        "p[style-name='Heading 1']",
        documentMatchers.paragraph({ styleName: documentMatchers.equalTo("Heading 1") })
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads paragraph with style name prefix", 16, (done: Function) => {
      assertDocumentMatcher(
        "p[style-name^='Heading']",
        documentMatchers.paragraph({ styleName: documentMatchers.startsWith("Heading") })
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads p:ordered-list(1) as ordered list with index of 0", 17, (done: Function) => {
      assertDocumentMatcher(
        "p:ordered-list(1)",
        documentMatchers.paragraph({ list: { isOrdered: true, levelIndex: 0 } })
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads p:unordered-list(1) as unordered list with index of 0", 18, (done: Function) => {
      assertDocumentMatcher(
        "p:unordered-list(1)",
        documentMatchers.paragraph({ list: { isOrdered: false, levelIndex: 0 } })
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads plain run", 19, (done: Function) => {
      assertDocumentMatcher(
        "r",
        documentMatchers.run()
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads plain table", 20, (done: Function) => {
      assertDocumentMatcher("table", documentMatchers.table());
      done();
    })

    it("styleReader.readDocumentMatcher reads table with style ID", 21, (done: Function) => {
      assertDocumentMatcher(
        "table.TableNormal",
        documentMatchers.table({
          styleId: "TableNormal"
        })
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads table with style name", 22, (done: Function) => {
      assertDocumentMatcher(
        "table[style-name='Normal Table']",
        documentMatchers.table({
          styleName: documentMatchers.equalTo("Normal Table")
        })
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads bold", 23, (done: Function) => {
      assertDocumentMatcher(
        "b",
        documentMatchers.bold
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads italic", 24, (done: Function) => {
      assertDocumentMatcher(
        "i",
        documentMatchers.italic
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads underline", 25, (done: Function) => {
      assertDocumentMatcher(
        "u",
        documentMatchers.underline
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads strikethrough", 26, (done: Function) => {
      assertDocumentMatcher(
        "strike",
        documentMatchers.strikethrough
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads all-caps", 27, (done: Function) => {
      assertDocumentMatcher(
        "all-caps",
        documentMatchers.allCaps
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads small-caps", 28, (done: Function) => {
      assertDocumentMatcher(
        "small-caps",
        documentMatchers.smallCaps
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads highlight without color", 29, (done: Function) => {
      assertDocumentMatcher(
        "highlight",
        documentMatchers.highlight()
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads highlight with color", 30, (done: Function) => {
      assertDocumentMatcher(
        "highlight[color='yellow']",
        documentMatchers.highlight({ color: "yellow" })
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads comment-reference", 31, (done: Function) => {
      assertDocumentMatcher(
        "comment-reference",
        documentMatchers.commentReference
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads line breaks", 32, (done: Function) => {
      assertDocumentMatcher(
        "br[type='line']",
        documentMatchers.lineBreak
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads page breaks", 33, (done: Function) => {
      assertDocumentMatcher(
        "br[type='page']",
        documentMatchers.pageBreak
      );
      done();
    })

    it("styleReader.readDocumentMatcher reads column breaks", 34, (done: Function) => {
      assertDocumentMatcher(
        "br[type='column']",
        documentMatchers.columnBreak
      );
      done();
    })

    it("styleReader.read document matcher is mapped to HTML path using arrow", 35, (done: Function) => {
      assertStyleMapping(
        "p => h1",
        {
          from: documentMatchers.paragraph(),
          to: htmlPaths.elements(["h1"])
        }
      );
      done();
    })

    it("styleReader.read document reads style mapping with no HTML path", 36, (done: Function) => {
      assertStyleMapping(
        "r =>",
        {
          from: documentMatchers.run(),
          to: htmlPaths.empty
        }
      );
      done();
    })

    it("styleReader.read document error when not all input is consumed", 37, (done: Function) => {
      expect(readStyle("r => span a")).assertDeepEquals(
        new results.Result(null,
          [results.warning("Did not understand this style mapping, so ignored it: r => span a\nError was at character number 10: Expected end but got whitespace")])
      );
      done();
    })
  })
}




