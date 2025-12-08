import { describe, it, expect } from '@ohos/hypium';
import fs from '@ohos.file.fs';
import * as mammoth from "@ohos/mammoth";
import * as results from "@ohos/mammoth/src/main/ets/results";
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { Options, ParagraphElement, SrcData } from '../../../main/ets/utils/Type';
import { ResultType } from './Type';
import Buffer from '@ohos.buffer';
import underscore from "underscore";
import { BusinessError } from '@kit.BasicServicesKit';
import { createFakeDocxFile, testData } from './testing';
import { writeFile } from '../../../main/ets/utils/FileUtils';

const _: ESObject = underscore

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
// 获取测试上下文
const context = delegator.getAppContext();

export default function mammothTest() {
  describe('mammothTest', () => {

    it('should convert docx containing one paragraph to single p element', 0, (done: Function) => {
      let content: Uint8Array = context.resourceManager.getRawFileContentSync("test-data/single-paragraph.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value).assertEqual("<p>Walking on imported air</p>");
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('should convert docx represented by a Buffer', 1, (done: Function) => {
      context.resourceManager.getRawFileContent("test-data/single-paragraph.docx")
        .then((buffer: Uint8Array) => {
          return mammoth.convertToHtml({ arrayBuffer: buffer.buffer });
        })
        .then((result: ResultType) => {
          expect(result.value).assertEqual("<p>Walking on imported air</p>");
          expect(result.messages).assertDeepEquals([]);
          done();
        })
        .catch((err: BusinessError) => {
          expect().assertFail();
          done();
        })
    });

    it('should read docx xml files with unicode byte order mark', 2, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/utf8-bom.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value).assertEqual("<p>This XML has a byte order mark.</p>");
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('empty paragraphs are ignored by default', 3, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/empty.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value).assertEqual("");
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('empty paragraphs are preserved if ignoreEmptyParagraphs is false', 4, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/empty.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, { ignoreEmptyParagraphs: false }).then((result) => {
        expect(result.value).assertEqual("<p></p>");
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('style map can be expressed as string', 5, (done: Function) => {
      let docxFile: ESObject = createFakeDocxFile({
        "word/document.xml": testData("simple/word/document.xml")
      });
      let options: Options = {
        styleMap: "p => h1"
      };
      let mam: ESObject = mammoth;
      mam.convertToHtml({ file: docxFile }, options).then((result: ResultType) => {
        expect("<h1>Hello.</h1>").assertEqual(result.value);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('style map can be expressed as array of style mappings', 6, (done: Function) => {
      let docxFile: ESObject = createFakeDocxFile({
        "word/document.xml": testData("simple/word/document.xml")
      });
      let options: Options = {
        styleMap: ["p => h1"]
      };
      let mam: ESObject = mammoth;
      mam.convertToHtml({ file: docxFile }, options).then((result: ResultType) => {
        expect("<h1>Hello.</h1>").assertEqual(result.value);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('embedded style map is used if present', 7, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/embedded-style-map.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value).assertEqual("<h1>Walking on imported air</h1>");
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('explicit style map takes precedence over embedded style map', 8, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/embedded-style-map.docx");
      let options: Options = {
        styleMap: ["p => p"]
      };
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, options).then((result) => {
        expect(result.value).assertEqual("<p>Walking on imported air</p>");
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('explicit style map is combined with embedded style map', 9, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/embedded-style-map.docx");
      let options: Options = {
        styleMap: ["r => strong"]
      };
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, options).then((result) => {
        expect(result.value).assertEqual("<h1><strong>Walking on imported air</strong></h1>");
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('embedded style maps can be disabled', 10, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/embedded-style-map.docx");
      let options: Options = {
        includeEmbeddedStyleMap: false
      };
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, options).then((result) => {
        expect(result.value).assertEqual("<p>Walking on imported air</p>");
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('embedded style map can be written using toBuffer() and then read', 11, (done: Function) => {
      context.resourceManager.getRawFileContent("test-data/single-paragraph.docx")
        .then((buffer: Uint8Array) => {
          return mammoth.embedStyleMap({ buffer: Buffer.from(buffer) }, "p => h1");
        })
        .then((docx) => {
          let buffer = docx.toBuffer();
          expect(Buffer.isBuffer(buffer)).assertTrue();
          return mammoth.convertToHtml({ buffer: buffer });
        })
        .then((result) => {
          expect(result.value).assertEqual("<h1>Walking on imported air</h1>");
          expect(result.messages).assertDeepEquals([]);
          done();
        })
        .catch((err: BusinessError) => {
          expect().assertFail();
          done();
        })
    });

    it('embedded style map can be written using toArrayBuffer() and then read', 12, (done: Function) => {
      context.resourceManager.getRawFileContent("test-data/single-paragraph.docx")
        .then((buffer: Uint8Array) => {
          return mammoth.embedStyleMap({ buffer: Buffer.from(buffer) }, "p => h1");
        })
        .then((docx) => {
          let arrayBuffer = docx.toArrayBuffer();
          expect(!Buffer.isBuffer(arrayBuffer)).assertTrue();
          return mammoth.convertToHtml({ buffer: Buffer.from(arrayBuffer) });
        })
        .then((result) => {
          expect(result.value).assertEqual("<h1>Walking on imported air</h1>");
          expect(result.messages).assertDeepEquals([]);
          done();
        })
        .catch((err: BusinessError) => {
          expect().assertFail();
          done();
        })
    });

    it('embedded style map can be retrieved', 13, (done: Function) => {
      context.resourceManager.getRawFileContent("test-data/single-paragraph.docx")
        .then((buffer: Uint8Array) => {
          return mammoth.embedStyleMap({ buffer: Buffer.from(buffer) }, "p => h1");
        })
        .then((docx) => {
          return mammoth.readEmbeddedStyleMap({ buffer: docx.toBuffer() });
        })
        .then((styleMap) => {
          expect(styleMap).assertEqual("p => h1");
          done();
        })
        .catch((err: BusinessError) => {
          expect().assertFail();
          done();
        })
    });

    it('warning if style mapping is not understood', 14, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/single-paragraph.docx");
      let options: Options = {
        styleMap: "????\np => h1"
      };
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, options).then((result) => {
        expect("<h1>Walking on imported air</h1>").assertEqual(result.value);
        let warning = "Did not understand this style mapping, so ignored it: ????\n" +
          'Error was at character number 1: Expected element type but got unrecognisedCharacter "?"';
        expect(result.messages).assertDeepEquals([results.warning(warning)]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('options are passed to document converter when calling mammoth.convertToHtml', 15, (done: Function) => {
      let docxFile: ESObject = createFakeDocxFile({
        "word/document.xml": testData("simple/word/document.xml")
      });
      let options: Options = {
        styleMap: "p => h1"
      };
      let mam: ESObject = mammoth;
      mam.convertToHtml({ file: docxFile }, options).then((result: ResultType) => {
        expect("<h1>Hello.</h1>").assertEqual(result.value);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('options.transformDocument is used to transform document if set', 16, (done: Function) => {
      let docxFile: ESObject = createFakeDocxFile({
        "word/document.xml": testData("simple/word/document.xml")
      });

      let options: Options = {
        transformDocument: (document: ESObject): ESObject => {
          document.children[0].styleId = "Heading1";
          return document;
        }
      };
      let mam: ESObject = mammoth;
      mam.convertToHtml({ file: docxFile }, options).then((result: ResultType) => {
        expect("<h1>Hello.</h1>").assertEqual(result.value);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('mammoth.transforms.paragraph only transforms paragraphs', 17, (done: Function) => {
      let docxFile: ESObject = createFakeDocxFile({
        "word/document.xml": testData("simple/word/document.xml")
      });
      let options: Options = {
        transformDocument: mammoth.transforms.paragraph((paragraph: ParagraphElement) => {
          return _.extend(paragraph, { styleId: "Heading1" });
        })
      };
      let mam: ESObject = mammoth;
      mam.convertToHtml({ file: docxFile }, options).then((result: ResultType) => {
        expect("<h1>Hello.</h1>").assertEqual(result.value);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('inline images referenced by path relative to part are included in output', 18, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/tiny-picture.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value)
          .assertEqual('<p><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAIAAAACUFjqAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOvgAADr4B6kKxwAAAABNJREFUKFNj/M+ADzDhlWUYqdIAQSwBE8U+X40AAAAASUVORK5CYII=" /></p>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('inline images referenced by path relative to base are included in output', 19, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/tiny-picture-target-base-relative.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value)
          .assertEqual('<p><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAIAAAACUFjqAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOvgAADr4B6kKxwAAAABNJREFUKFNj/M+ADzDhlWUYqdIAQSwBE8U+X40AAAAASUVORK5CYII=" /></p>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('src of inline images can be changed using read("base64")', 20, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/tiny-picture.docx");
      let convertImage = mammoth.images.imgElement((element) => {
        return element.read("base64").then((encodedImage) => {
          let data: SrcData = { src: encodedImage.substring(0, 2) + "," + element.contentType };
          return data;
        });
      });
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, { convertImage: convertImage }).then((result) => {
        expect(result.messages).assertDeepEquals([]);
        expect(result.value).assertEqual('<p><img src="iV,image/png" /></p>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('src of inline images can be changed using readAsBase64String()', 21, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/tiny-picture.docx");
      let convertImage = mammoth.images.imgElement((element) => {
        return element.readAsBase64String().then((encodedImage) => {
          let data: SrcData = { src: encodedImage.substring(0, 2) + "," + element.contentType };
          return data
        });
      });
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, { convertImage: convertImage }).then((result) => {
        expect(result.messages).assertDeepEquals([]);
        expect(result.value).assertEqual('<p><img src="iV,image/png" /></p>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('src of inline images can be changed using readAsArrayBuffer()', 22, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/tiny-picture.docx");
      let convertImage = mammoth.images.imgElement((element) => {
        return element.readAsArrayBuffer().then((arrayBuffer) => {
          expect(!Buffer.isBuffer(arrayBuffer)).assertTrue();
          let encodedImage: string = Buffer.from(arrayBuffer).toString("base64");
          let data: SrcData = { src: encodedImage.substring(0, 2) + "," + element.contentType };
          return data
        });
      });
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, { convertImage: convertImage }).then((result) => {
        expect(result.messages).assertDeepEquals([]);
        expect(result.value).assertEqual('<p><img src="iV,image/png" /></p>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('src of inline images can be changed using read()', 23, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/tiny-picture.docx");
      let convertImage = mammoth.images.imgElement((element) => {
        return element.read().then((buffer) => {
          expect(Buffer.isBuffer(buffer)).assertTrue();
          let encodedImage: string = buffer.toString("base64");
          let data: SrcData = { src: encodedImage.substring(0, 2) + "," + element.contentType };
          return data;
        });
      });
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, { convertImage: convertImage }).then((result) => {
        expect(result.messages).assertDeepEquals([]);
        expect(result.value).assertEqual('<p><img src="iV,image/png" /></p>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('src of inline images can be changed using readAsBuffer()', 24, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/tiny-picture.docx");
      let convertImage = mammoth.images.imgElement((element) => {
        return element.readAsBuffer().then((buffer) => {
          expect(Buffer.isBuffer(buffer)).assertTrue();
          let encodedImage: string = buffer.toString("base64");
          let data: SrcData = { src: encodedImage.substring(0, 2) + "," + element.contentType };
          return data
        });
      });
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, { convertImage: convertImage }).then((result) => {
        expect(result.messages).assertDeepEquals([]);
        expect(result.value).assertEqual('<p><img src="iV,image/png" /></p>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    // todo
    // it('when external file access is enabled then images stored outside of document are included in output', 25, (done: Function) => {
    //   let content = context.resourceManager.getRawFileContentSync("test-data/external-picture.docx");
    //   writeFile(context.filesDir + "/test-data", "external-picture.docx", content.buffer);
    //   mammoth.convertToHtml({ path: context.filesDir + "test-data/external-picture.docx" }, { externalFileAccess: true }).then((result) => {
    //     expect(result.value)
    //       .assertEqual('<p><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAIAAAACUFjqAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAOvgAADr4B6kKxwAAAABNJREFUKFNj/M+ADzDhlWUYqdIAQSwBE8U+X40AAAAASUVORK5CYII=" /></p>');
    //     expect(result.messages).assertDeepEquals([]);
    //     done();
    //   }).catch((err: BusinessError) => {
    //     expect().assertFail();
    //     done();
    //   })
    // });
    //
    // todo
    // it('when external file access is enabled then error if images stored outside of document are specified when passing file without path',
    //   26, (done: Function) => {
    //     let content = context.resourceManager.getRawFileContentSync("test-data/external-picture.docx");
    //     writeFile(context.filesDir + "/test-data", "external-picture.docx", content.buffer);
    //     mammoth.convertToHtml({ path: context.filesDir + "test-data/external-picture.docx"  }, { externalFileAccess: true }).then((result) => {
    //       expect(result.value).assertEqual('');
    //       expect(result.messages[0].message)
    //         .assertEqual("could not find external image 'tiny-picture.png', path of input document is unknown");
    //       expect(result.messages[0].type).assertEqual("error");
    //       done();
    //     }).catch((err: BusinessError) => {
    //       expect().assertFail();
    //       done();
    //     })
    //   });
    //
    // todo
    // it('given external file access is disabled by default then error if images stored outside of document are specified',
    //   27, (done: Function) => {
    //     let content = context.resourceManager.getRawFileContentSync("test-data/external-picture.docx");
    //     writeFile(context.filesDir + "/test-data", "external-picture.docx", content.buffer);
    //     mammoth.convertToHtml({ path: context.filesDir + "test-data/external-picture.docx"  }).then((result) => {
    //       expect(result.value).assertEqual('');
    //       expect(result.messages[0].message)
    //         .assertEqual("could not read external image 'tiny-picture.png', external file access is disabled");
    //       expect(result.messages[0].type).assertEqual("error");
    //       done();
    //     }).catch((err: BusinessError) => {
    //       expect().assertFail();
    //       done();
    //     })
    //   });

    it('simple list is converted to list elements', 28, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/simple-list.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value).assertEqual('<ul><li>Apple</li><li>Banana</li></ul>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('word tables are converted to html tables', 29, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/tables.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        let expectedHtml = "<p>Above</p>" +
          "<table>" +
          "<tr><td><p>Top left</p></td><td><p>Top right</p></td></tr>" +
          "<tr><td><p>Bottom left</p></td><td><p>Bottom right</p></td></tr>" +
          "</table>" +
          "<p>Below</p>";
        expect(result.value).assertEqual(expectedHtml);
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('footnotes are appended to text', 30, (done: Function) => {
      // TODO: don't duplicate footnotes with multiple references
      let content = context.resourceManager.getRawFileContentSync("test-data/footnotes.docx");
      let options: Options = {
        idPrefix: "doc-42-"
      };
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, options).then((result) => {
        let expectedOutput = '<p>Ouch' +
          '<sup><a href="#doc-42-footnote-1" id="doc-42-footnote-ref-1">[1]</a></sup>.' +
          '<sup><a href="#doc-42-footnote-2" id="doc-42-footnote-ref-2">[2]</a></sup></p>' +
          '<ol><li id="doc-42-footnote-1"><p> A tachyon walks into a bar. <a href="#doc-42-footnote-ref-1">↑</a></p></li>' +
          '<li id="doc-42-footnote-2"><p> Fin. <a href="#doc-42-footnote-ref-2">↑</a></p></li></ol>';
        expect(result.value).assertEqual(expectedOutput);
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('endnotes are appended to text', 31, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/endnotes.docx");
      let options: Options = {
        idPrefix: "doc-42-"
      };
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, options).then((result) => {
        let expectedOutput = '<p>Ouch' +
          '<sup><a href="#doc-42-endnote-2" id="doc-42-endnote-ref-2">[1]</a></sup>.' +
          '<sup><a href="#doc-42-endnote-3" id="doc-42-endnote-ref-3">[2]</a></sup></p>' +
          '<ol><li id="doc-42-endnote-2"><p> A tachyon walks into a bar. <a href="#doc-42-endnote-ref-2">↑</a></p></li>' +
          '<li id="doc-42-endnote-3"><p> Fin. <a href="#doc-42-endnote-ref-3">↑</a></p></li></ol>';
        expect(result.value).assertEqual(expectedOutput);
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('relationships are handled properly in footnotes', 32, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/footnote-hyperlink.docx");
      let options: Options = {
        idPrefix: "doc-42-"
      };
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, options).then((result) => {
        let expectedOutput =
          '<p><sup><a href="#doc-42-footnote-1" id="doc-42-footnote-ref-1">[1]</a></sup></p>' +
            '<ol><li id="doc-42-footnote-1"><p> <a href="http://www.example.com">Example</a> <a href="#doc-42-footnote-ref-1">↑</a></p></li></ol>';
        expect(result.value).assertEqual(expectedOutput);
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('when style mapping is defined for comment references then comments are included', 33, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/comments.docx");
      let options: Options = {
        idPrefix: "doc-42-",
        styleMap: "comment-reference => sup"
      };
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, options).then((result) => {
        let expectedOutput = (
          '<p>Ouch' +
            '<sup><a href="#doc-42-comment-0" id="doc-42-comment-ref-0">[MW1]</a></sup>.' +
            '<sup><a href="#doc-42-comment-2" id="doc-42-comment-ref-2">[MW2]</a></sup></p>' +
            '<dl><dt id="doc-42-comment-0">Comment [MW1]</dt><dd><p>A tachyon walks into a bar. <a href="#doc-42-comment-ref-0">↑</a></p></dd>' +
            '<dt id="doc-42-comment-2">Comment [MW2]</dt><dd><p>Fin. <a href="#doc-42-comment-ref-2">↑</a></p></dd></dl>'
        );
        expect(result.value).assertEqual(expectedOutput);
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('textboxes are read', 34, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/text-box.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        let expectedOutput = '<p>Datum plane</p>';
        expect(result.value).assertEqual(expectedOutput);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('underline is ignored by default', 35, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/underline.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value).assertEqual('<p><strong>The Sunset Tree</strong></p>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('underline can be configured with style mapping', 36, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/underline.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, { styleMap: "u => em" }).then((result) => {
        expect(result.value).assertEqual('<p><strong>The <em>Sunset</em> Tree</strong></p>');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('strikethrough is converted to <s> by default', 37, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/strikethrough.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value).assertEqual("<p><s>Today's Special: Salmon</s> Sold out</p>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('strikethrough conversion can be configured with style mappings', 38, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/strikethrough.docx");
      mammoth.convertToHtml({ arrayBuffer: content.buffer }, { styleMap: "strike => del" }).then((result) => {
        expect(result.value).assertEqual("<p><del>Today's Special: Salmon</del> Sold out</p>");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('indentation is used if prettyPrint is true', 39, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/single-paragraph.docx");
      let mam: ESObject = mammoth;
      mam.convertToHtml({ arrayBuffer: content.buffer }, { prettyPrint: true }).then((result: ResultType) => {
        expect(result.value).assertEqual("<p>\n  Walking on imported air\n</p>");
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('using styleMapping throws error', 40, (done: Function) => {
      try {
        let mam: ESObject = mammoth;
        mam.styleMapping();
      } catch (error) {
        expect(
          error.message).assertEqual(
          'Use a raw string instead of mammoth.styleMapping e.g. "p[style-name=\'Title\'] => h1" instead of mammoth.styleMapping("p[style-name=\'Title\'] => h1")'
        );
        done();
      }
    });

    it('can convert single paragraph to markdown', 41, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/single-paragraph.docx");
      mammoth.convertToMarkdown({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value).assertEqual("Walking on imported air\n\n");
        expect(result.messages).assertDeepEquals([]);
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it('extractRawText only retains raw text', 42, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/simple-list.docx");
      mammoth.extractRawText({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value).assertEqual('Apple\n\nBanana\n\n');
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      });
    });

    it('extractRawText can use .docx files represented by a Buffer', 43, (done: Function) => {
      context.resourceManager.getRawFileContent("test-data/single-paragraph.docx")
        .then((buffer) => {
          return mammoth.extractRawText({ buffer: buffer });
        })
        .then((result: ResultType) => {
          expect(result.value).assertEqual("Walking on imported air\n\n");
          expect(result.messages).assertDeepEquals([]);
          done();
        })
        .catch((err: BusinessError) => {
          expect().assertFail();
          done();
        })
    });

    it('can read strict format', 44, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/strict-format.docx");

      mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        expect(result.value).assertEqual("<p>Test</p>");
        expect(result.messages).assertDeepEquals([]);
        done();
      })
        .catch((err: BusinessError) => {
          expect().assertFail();
          done();
        })
    })


    it('should throw error if file is not a valid docx document', 45, (done: Function) => {
      let content = context.resourceManager.getRawFileContentSync("test-data/empty.zip");
      return mammoth.convertToHtml({ arrayBuffer: content.buffer }).then((result) => {
        expect().assertFail();
      }, (error: BusinessError) => {
        expect(error.message)
          .assertEqual("Could not find main document part. Are you sure this is a valid .docx file?");
        done();
      }).catch((err: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

  });
}
