import { describe, it, expect } from '@ohos/hypium';
import * as results from "@ohos/mammoth/src/main/ets/results";
import { ResultType } from './Type';

let Result: ESObject = results.Result;

export default function resultsTest() {
  describe('resultsTest', () => {
    it("Result.combine removes any duplicate messages", 0, (done: Function) => {
      let first:ResultType = new Result(null, [results.warning("Warning...")]);
      let second:ResultType = new Result(null, [results.warning("Warning...")]);

      let combined:ResultType = Result.combine([first, second]);

      expect(combined.messages).assertDeepEquals([results.warning("Warning...")]);
      done();
    });
  });
}
