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
import { parseDate } from "@ohos/parser-sdk";

export default function parseDateTest() {
  describe('ParseDate', () => {
    it('returns a Date for valid strings', 0, () => {
      expect(Number(parseDate('2013-12-14T04:51:19.582Z'))).assertEqual(
        Number(new Date(Date.UTC(2013, 11, 14, 4, 51, 19, 582)))
      );
      expect(Number(parseDate('2013-12-14T04:51:19Z'))).assertEqual(
        Number(new Date(Date.UTC(2013, 11, 14, 4, 51, 19)))
      );
    });

    it('returns null for invalid strings', 0, () => {
      expect(parseDate('asdf')).assertNull();
    });
  });
}