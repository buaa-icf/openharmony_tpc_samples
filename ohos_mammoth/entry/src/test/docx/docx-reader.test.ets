import { describe, it, expect } from '@ohos/hypium';
import * as docxReader from "@ohos/mammoth/src/main/ets/docx/docx-reader";
import * as documents from "@ohos/mammoth/src/main/ets/documents";
import * as xml from "@ohos/mammoth/src/main/ets/xml";
import { testData, createFakeDocxFile } from "../testing";
import { BusinessError } from '@kit.BasicServicesKit';

const createPackageRelationships = (mainDocumentPath: ESObject): ESObject => {
  return xml.writeString(xml.element("r:Relationships", {}, [
    xml.element("r:Relationship", {
      "Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument",
      "Target": mainDocumentPath
    })
  ]), relationshipNamespaces);
}

const TypeList: ESObject = [
  {
    name: "comments",
    type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/comments"
  },
  {
    name: "endnotes",
    type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/endnotes"
  },
  {
    name: "footnotes",
    type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/footnotes"
  },
  {
    name: "numbering",
    type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/numbering"
  },
  {
    name: "styles",
    type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"
  }
]

let relationshipNamespaces: ESObject = {
  "r": "http://schemas.openxmlformats.org/package/2006/relationships"
};

export default function docxReaderTest() {
  describe('docxReaderTest', () => {
    it("can read document with single paragraph with single run of text", 0, (done: Function) => {
      let expectedDocument: ESObject = documents.Document([
        documents.Paragraph([
          documents.Run([
            documents.Text("Hello.")
          ])
        ])
      ]);
      let docxFile = createFakeDocxFile({
        "word/document.xml": testData("simple/word/document.xml")
      });
      docxReader.read(docxFile).then((result: ESObject) => {
        expect(expectedDocument).assertDeepEquals(result.value);
        done();
      })
        .catch((error: BusinessError) => {
          expect().assertFail();
          done();
        })
    });

    it("hyperlink hrefs are read from relationships file", 1, (done: Function) => {
      let docxFile = createFakeDocxFile({
        "word/document.xml": testData("hyperlinks/word/document.xml"),
        "word/_rels/document.xml.rels": testData("hyperlinks/word/_rels/document.xml.rels")
      });
      docxReader.read(docxFile).then((result: ESObject) => {
        let paragraph: ESObject = result.value.children[0];
        expect(1).assertDeepEquals(paragraph.children.length);
        let hyperlink: ESObject = paragraph.children[0];
        expect(hyperlink.href).assertDeepEquals("http://www.example.com");
        expect(hyperlink.children.length).assertDeepEquals(1);
        done();
      }).catch((error: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it("main document is found using _rels/.rels", 2, (done: Function) => {
      let relationships: ESObject = xml.element("r:Relationships", {}, [
        xml.element("r:Relationship", {
          "Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument",
          "Target": "/word/document2.xml"
        })
      ]);

      let docxFile = createFakeDocxFile({
        "word/document2.xml": testData("simple/word/document.xml"),
        "_rels/.rels": xml.writeString(relationships, relationshipNamespaces)
      });
      let expectedDocument: ESObject = documents.Document([
        documents.Paragraph([
          documents.Run([
            documents.Text("Hello.")
          ])
        ])
      ]);
      docxReader.read(docxFile).then((result: ESObject) => {
        expect(expectedDocument).assertDeepEquals(result.value);
        done();
      }).catch((error: BusinessError) => {
        expect().assertFail();
        done();
      })
    });

    it("error is thrown when main document part does not exist", 3, (done: Function) => {
      let relationships: ESObject = xml.element("r:Relationships", {}, [
        xml.element("r:Relationship", {
          "Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument",
          "Target": "/word/document2.xml"
        })
      ]);

      let docxFile = createFakeDocxFile({
        "_rels/.rels": xml.writeString(relationships, relationshipNamespaces)
      });
      docxReader.read(docxFile).then((result: ESObject) => {
        expect().assertTrue();
      }, (error: ESObject) => {
        expect(error.message)
          .assertDeepEquals("Could not find main document part. Are you sure this is a valid .docx file?");
        done();
      }).catch((error: BusinessError) => {
        expect().assertFail();
        done()
      })
    });

    it("part paths main document part is found using package relationships", 4, (done: Function) => {
      let relationships: ESObject = xml.element("r:Relationships", {}, [
        xml.element("r:Relationship", {
          "Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument",
          "Target": "/word/document2.xml"
        })
      ]);

      let docxFile = createFakeDocxFile({
        "word/document2.xml": " ",
        "_rels/.rels": xml.writeString(relationships, relationshipNamespaces)
      });
      docxReader._findPartPaths(docxFile).then((partPaths: ESObject) => {
        expect(partPaths.mainDocument).assertEqual("word/document2.xml");
      });
      done();
    })

    it("part paths word/document.xml is used as fallback location for main document part", 5, (done: Function) => {
      let docxFile = createFakeDocxFile({
        "word/document.xml": " "
      });
      docxReader._findPartPaths(docxFile).then((partPaths: ESObject) => {
        expect(partPaths.mainDocument).assertEqual("word/document.xml");
        done();
      }).catch((error: BusinessError) => {
        expect().assertFail();
        done();
      })
    })

    for (let i = 0; i < TypeList.length; i++) {
      let options: ESObject = TypeList[i];
      it(options.name + " part is found using main document relationships", 6 + i, (done: Function) => {
        let docxFile = createFakeDocxFile({
          "_rels/.rels": createPackageRelationships("word/document.xml"),
          "word/document.xml": " ",
          "word/_rels/document.xml.rels": xml.writeString(xml.element("r:Relationships", {}, [
            xml.element("r:Relationship", {
              "Type": options.type,
              "Target": "target-path.xml"
            })
          ]), relationshipNamespaces),
          "word/target-path.xml": " "
        });
        docxReader._findPartPaths(docxFile).then((partPaths: ESObject) => {
          expect(partPaths[options.name]).assertEqual("word/target-path.xml");
          done();
        }).catch((error: BusinessError) => {
          expect().assertFail();
          done();
        })
      });
    }

    for (let i = 0; i < TypeList.length; i++) {
      let options: ESObject = TypeList[i];

      it("word/" + options.name + ".xml is used as fallback location for " + options.name + " part", 11 + i, (done: Function) => {
        let zipContents: ESObject = {
          "_rels/.rels": createPackageRelationships("word/document.xml"),
          "word/document.xml": " "
        };
        zipContents["word/" + options.name + ".xml"] = " ";
        let docxFile = createFakeDocxFile(zipContents);
        docxReader._findPartPaths(docxFile).then((partPaths: ESObject) => {
          expect(partPaths[options.name]).assertEqual("word/" + options.name + ".xml");
          done();
        }).catch((error: BusinessError) => {
          expect().assertFail();
          done();
        })
      });
    }
  })
}





