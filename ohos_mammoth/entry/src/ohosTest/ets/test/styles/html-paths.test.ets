import { describe, expect, it } from "@ohos/hypium";
import * as htmlPaths from '@ohos/mammoth/src/main/ets/styles/html-paths'

interface Element {
  tagName?: string;
  tagNames?: string[];
  attributes?: Record<string, string>;
}

function matches_1(element?: Element):boolean{
  return htmlPaths.element(["ul","ol"]).matchesElement(element) as boolean
}
function matches_2(element?: Element):boolean{
  return htmlPaths.element(["p"],{"class":"tip"}).matchesElement(element) as boolean
}

export default function html_pathsTest() {
  describe('html_pathsTest', () => {
    it('element can match multiple tag names', 0, (done: Function) => {
      expect(matches_1({ tagName: "ul"})).assertTrue();
      expect(matches_1({ tagName: "ol"})).assertTrue();
      expect(!matches_1({ tagName: "p"})).assertTrue();
      done();
    });
    it('element matches if attributes are the same', 0, (done: Function) => {
      expect(matches_2({ tagName: "p"})).assertFalse();
      expect(matches_2({ tagName: "p",attributes:{"class":"tip help"}})).assertFalse();
      expect(matches_2({ tagName: "p",attributes:{"class":"tip"}})).assertTrue();
      done();
    });
  })
}
