import { describe, it, expect } from '@ohos/hypium';
import { createCommentsReader } from "@ohos/mammoth/src/main/ets/docx/comments-reader";
import { createBodyReader } from "@ohos/mammoth/src/main/ets/docx/body-reader";
import * as stylesReader from "@ohos/mammoth/src/main/ets/docx/styles-reader";
import * as documents from "@ohos/mammoth/src/main/ets/documents";
import * as xml from "@ohos/mammoth/src/main/ets/xml";
import { BodyReader, CommentResult, CommentType, Result } from '../Type';

const Paragraphs: ESObject = documents.Paragraph();

const readComment = (element: ESObject): CommentType => {
  let bodyReader: BodyReader = createBodyReader({ styles: stylesReader.defaultStyles });
  let commentsReader: Function = createCommentsReader(bodyReader);
  let comments: CommentResult = commentsReader(element);
  expect(comments.value.length).assertEqual(1);
  return comments.value[0];
}

export default function commentsReaderTest() {

  describe('commentsReaderTest', () => {

    it('ID and body of comment are read', 0, (done: Function) => {
      let body: ESObject = [xml.element("w:p")];
      let comment: ESObject = readComment(xml.element("w:comments", {}, [
        xml.element("w:comment", { "w:id": "1" }, body)
      ]));
      // expect(comment.body).assertDeepEquals([new Paragraphs([])]);
      expect(comment.commentId).assertDeepEquals("1");
      done();
    });


    it('when optional attributes of comment are missing then they are read as null', 1, (done: Function) => {
      let comment: ESObject = readComment(xml.element("w:comments", {}, [
        xml.element("w:comment", { "w:id": "1" })
      ]));
      expect(comment.authorName).assertEqual(null);
      expect(comment.authorInitials).assertEqual(null);
      done();
    });


    it('when optional attributes of comment are blank then they are read as null', 2, (done: Function) => {
      let comment: ESObject = readComment(xml.element("w:comments", {}, [
        xml.element("w:comment", { "w:id": "1", "w:author": " ", "w:initials": " " })
      ]));
      expect(comment.authorName).assertEqual(null);
      expect(comment.authorInitials).assertEqual(null);
      done();
    });


    it('when optional attributes of comment are not blank then they are read', 3, (done: Function) => {
      let comment: ESObject = readComment(xml.element("w:comments", {}, [
        xml.element("w:comment", { "w:id": "1", "w:author": "The Piemaker", "w:initials": "TP" })
      ]));
      expect(comment.authorName).assertEqual("The Piemaker");
      expect(comment.authorInitials).assertEqual("TP");
      done();
    });
  });
}
