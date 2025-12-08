import { describe, it, expect } from '@ohos/hypium';
import _ from "underscore";
import * as documents from "@ohos/mammoth/src/main/ets/documents";
import * as transforms from "@ohos/mammoth/src/main/ets/transforms";
import { Children } from './Type';
import { BaseElement, ParagraphElement, RunElement } from '../../../main/ets/utils/Type';

export default function transformsTest() {
  describe('transformsTest', () => {
    it("paragraph() paragraph is transformed", 0, (done: Function) => {
      let paragraph: ParagraphElement = documents.paragraph([]);
      let result: BaseElement = transforms.paragraph((): BaseElement => {
        return documents.tab();
      })(paragraph);
      expect(result).assertDeepEquals(documents.tab());
      done();
    })

    it("paragraph() non-paragraph elements are not transformed", 1, (done: Function) => {
      let run: RunElement = documents.run([]);
      let result: BaseElement = transforms.paragraph((): BaseElement => {
        return documents.tab();
      })(run);
      expect(result).assertDeepEquals(documents.run([]));
      done();
    });


    it("run() run is transformed", 2, (done: Function) => {
      let run: RunElement = documents.run([]);
      let result: BaseElement = transforms.run((): BaseElement => {
        return documents.tab();
      })(run);
      expect(result).assertDeepEquals(documents.tab());
      done();
    })

    it("run() non-run elements are not transformed", 3, (done: Function) => {
      let paragraph: ParagraphElement = documents.paragraph([]);
      let result: BaseElement = transforms.run((): BaseElement => {
        return documents.tab();
      })(paragraph);
      expect(result).assertDeepEquals(documents.paragraph([]));
      done();
    });


    it("elements() all descendants are transformed", 4, (done: Function) => {
      let children: Array<ESObject> = [{}];
      let root: Children = {
        children: [
          {
            children: children
          }
        ]
      };
      let currentCount = 0;
      const setCount = (node: ESObject): ESObject => {
        currentCount++;
        let under: ESObject = _;
        return under.extend(node, { count: currentCount });
      }

      let result: ESObject = transforms._elements(setCount)(root);

      expect(result).assertDeepEquals({
        count: 3,
        children: [
          {
            count: 2,
            children: [
              { count: 1 }
            ]
          }
        ]
      });
      done();

    });


    it("getDescendants() returns nothing if element has no children property", 5, (done: Function) => {
      expect(transforms.getDescendants({})).assertDeepEquals([]);
      done();
    })

    it("getDescendants() returns nothing if element has empty children", 6, (done: Function) => {
      expect(transforms.getDescendants({ children: [] })).assertDeepEquals([]);
      done();
    });

    it("getDescendants() includes children", 7, (done: Function) => {
      let element: Children = {
        children: [{ name: "child 1" }, { name: "child 2" }]
      };
      expect(
        transforms.getDescendants(element)).assertDeepEquals(
        [{ name: "child 1" }, { name: "child 2" }]
      );
      done();
    })

    it("getDescendants() includes indirect descendants", 8, (done: Function) => {
      let grandchild: Children = { name: "grandchild" };
      let child: Children = { name: "child", children: [grandchild] };
      let element: Children = { children: [child] };
      expect(
        transforms.getDescendants(element)).assertDeepEquals(
        [grandchild, child]
      );
      done();
    });


    it("getDescendantsOfType() filters descendants to type", 9, (done: Function) => {
      let paragraph: Children = { type: "paragraph" };
      let run: Children = { type: "run" };
      let element: Children = {
        children: [paragraph, run]
      };
      expect(
        transforms.getDescendantsOfType(element, "run")).assertDeepEquals(
        [run]
      );
      done();

    });
  });
}