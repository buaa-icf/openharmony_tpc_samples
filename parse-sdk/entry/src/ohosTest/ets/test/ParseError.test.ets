/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */
import { describe, expect, it } from "@ohos/hypium";
import { CoreManager, ParseError } from "@ohos/parser-sdk";

export default function parseErrorTest() {
  describe('ParseError', () => {
    it('have sensible string representation', 0, () => {
      const error = new ParseError(123, 'some error message');

      expect(error.toString().match('ParseError')?.toString()).assertEqual('ParseError');
      expect(error.toString().match('123')?.toString()).assertEqual('123');
      expect(error.toString().match('some error message')?.toString()).assertEqual('some error message');
    });

    it('has a proper json representation', 0, () => {
      const error = new ParseError(123, 'some error message');
      expect(JSON.parse(JSON.stringify(error))).assertDeepEquals({
        message: 'some error message',
        code: 123,
      });
    });

    it('can override message', 0, () => {
      CoreManager.set('PARSE_ERRORS', [{ code: 123, message: 'Oops.' }]);
      const error = new ParseError(123, 'some error message');
      expect(JSON.parse(JSON.stringify(error))).assertDeepEquals({
        message: 'Oops.',
        code: 123,
      });
      // CoreManager.default.set('PARSE_ERRORS', []);
    });
  });
}