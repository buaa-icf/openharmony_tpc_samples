/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { parse, compile, match, stringify } from "path-to-regexp";
import {
  PARSER_TESTS,
  COMPILE_TESTS,
  MATCH_TESTS,
  STRINGIFY_TESTS,
} from "./case";

export default function OriginTest() {
  describe('OriginTest', () => {
    beforeAll(() => {
    });

    it('PARSER_TESTS', 0, async (done :Function) => {
      PARSER_TESTS.forEach( (item) => {
        const data = parse(item.path, item.options);
        expect(JSON.stringify(data)).assertEqual(JSON.stringify(item.expected));
      })
      done()
    })

    it('STRINGIFY_TESTS', 0, async (done :Function) => {
      STRINGIFY_TESTS.forEach( (item) => {
        const path = stringify(item.data);
        expect(JSON.stringify(path)).assertEqual(JSON.stringify(item.expected));
      })
      done()
    })

    it('COMPILE_TESTS', 0, async (done :Function) => {
      COMPILE_TESTS.forEach( (item) => {
        item.tests.forEach( (test) => {
          const toPath = compile(item.path, item.options);
          if (test.expected === null) {
            try{
              toPath(test.input)
            } catch (err) {
              expect(err.message !== "").assertTrue()
            }
          } else {
            expect(JSON.stringify(toPath(test.input))).assertEqual(JSON.stringify(test.expected));
          }
        })
      })
      done()
    })

    it('MATCH_TESTS', 0, async (done :Function) => {
      MATCH_TESTS.forEach( (item) => {
        item.tests.forEach( (test) => {
          const fn = match(item.path, item.options)
          expect(JSON.stringify((fn(test.input) as ESObject).path)).assertEqual(JSON.stringify((test.expected as ESObject).path));
          expect(JSON.stringify((fn(test.input) as ESObject).params)).assertEqual(JSON.stringify((test.expected as ESObject).params));
        })
      })
      done()
    })

  })
}
