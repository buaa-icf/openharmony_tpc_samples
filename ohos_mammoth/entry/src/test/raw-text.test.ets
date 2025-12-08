import { describe, it, expect } from '@ohos/hypium';
import * as documents from "@ohos/mammoth/src/main/ets/documents";
import { convertElementToRawText } from "@ohos/mammoth/src/main/ets/raw-text";
import { BaseElement } from '../../../main/ets/utils/Type';

let Text: ESObject = documents.Text;
let Document: ESObject = documents.Document;
let Paragraph: ESObject = documents.Paragraph;

export default function rawTextTest() {
  describe('rawTextTest', () => {
    it('text element is converted to text content', 0, (done: Function) => {
      let element: BaseElement = new Text("Hello.");
      let result: string = convertElementToRawText(element);
      expect(result).assertDeepEquals("Hello.");
      done();
    });

    it('tab element is converted to tab character', 1, (done: Function) => {
      let element: BaseElement = documents.tab();
      let result: string = convertElementToRawText(element);
      expect(result).assertDeepEquals("\t");
      done();
    });

    it('paragraphs are terminated with newlines', 2, (done: Function) => {
      let arr: Array<ESObject> = [
        new Text("Hello "),
        new Text("world.")
      ]
      let element: BaseElement = new Paragraph(arr, {});
      let result: string = convertElementToRawText(element);
      expect(result).assertDeepEquals("Hello world.\n\n");
      done();
    });

    it('children are recursively converted to text', 3, (done: Function) => {
      let arr: Array<ESObject> = [
        new Text("Hello "),
        new Text("world.")
      ];
      let element: BaseElement = new Document([
        new Paragraph(arr, {})
      ]);
      let result: string = convertElementToRawText(element);
      expect(result).assertDeepEquals("Hello world.\n\n");
      done();
    });


    it('non-text element without children is converted to empty string', 4, (done: Function) => {
      let element: BaseElement = documents.lineBreak;
      let result: string = convertElementToRawText(element);
      expect(result).assertDeepEquals("");
      done();
    });
  });
}
