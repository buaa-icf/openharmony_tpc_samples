import { describe, expect, it } from "@ohos/hypium";
import * as htmlPaths from '@ohos/mammoth/src/main/ets/styles/html-paths'

interface Element {
  tagname?: string;
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
      expect(matches_1({ tagname: "ul"})).assertTrue();
      expect(matches_1({ tagname: "ol"})).assertTrue();
      expect(matches_1({ tagname: "p"})).assertTrue();
      done();
    });
    it('element matches if attributes are the same', 0, (done: Function) => {
      expect(matches_2({ tagname: "p"})).assertFalse();
      expect(matches_2({ tagname: "p",attributes:{"class":"tip help"}})).assertFalse();
      expect(matches_2({ tagname: "p",attributes:{"class":"tip"}})).assertTrue();
      done();
    });
  })
}
