/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect, diff } from '../utils/utils'
import mime, { Mime } from "mime"
import { testGetType, testGetExtension } from "../utils/utils"
import { getTypeData,getExtensionData } from "../utils/model"
export default function mimeTest() {
  describe('mimeTest',  () => {

    _it('new constructor()', () => {
      const mime = new Mime({
        'text/a': ['a', 'a1']
      }, {
        'text/b': ['b', 'b1']
      });

      testGetType(
        mime,
        [
          {
            input: 'a', expected: 'text/a'
          },
          {
            input: 'a1', expected: 'text/a'
          },
          {
            input: 'b', expected: 'text/b'
          },
          {
            input: 'b1', expected: 'text/b'
          },
        ],
      );

      testGetExtension(
        mime,
        [
          {
            input: 'text/a', expected: 'a'
          },
          {
            input: 'text/b', expected: 'b'
          },
        ],
      );
    });

    _it('define()', () => {
      const mime = new Mime({
        'text/a': ['a']
      }, {
        'text/b': ['b']
      });
      testGetType(mime, [
        {
          input: 'a', expected: 'text/a'
        },
        {
          input: 'b', expected: 'text/b'
        },

      ]);
      testGetExtension(mime, [
        {
          input: 'text/a', expected: 'a'
        },
        {
          input: 'text/b', expected: 'b'
        },

      ]);
    });

    _it("define() *'ed types", () => {
      const mime = new Mime({
        'text/a': ['*b']
      }, {
        'text/b': ['b']
      });

      testGetType(mime, [{
        input: 'b', expected: 'text/b'
      }]);

      testGetExtension(mime, [
        {
          input: 'text/a', expected: 'b'
        },
        {
          input: 'text/b', expected: 'b'
        },
      ]);
    });

    _it('case-insensitive', () => {
      const mime = new Mime({
        'TEXT/UPPER': ['UP'],
        'text/lower': ['low'],
      });

      testGetType(mime, [
        {
          input: 'up', expected: 'text/upper'
        },
        {
          input: 'UP', expected: 'text/upper'
        },
        {
          input: 'low', expected: 'text/lower'
        },
        {
          input: 'LOW', expected: 'text/lower'
        },
      ]);

      testGetExtension(mime, [
        {
          input: 'text/upper', expected: 'up'
        },
        {
          input: 'text/lower', expected: 'low'
        },
        {
          input: 'TEXT/UPPER', expected: 'up'
        },
        {
          input: 'TEXT/LOWER', expected: 'low'
        },
      ]);
    });

    _it('getType()', () => {
      testGetType(mime, getTypeData);
    });

    _it('getExtension()',  () =>  {
      testGetExtension(mime, getExtensionData);
    });

    _it('getAllExtensions()', () => {
      const mime = new Mime({
        'text/a': ['a', 'b']
      }, {
        'text/a': ['b', 'c']
      });
      expect(diff(Array.from(mime.getAllExtensions('text/a') as Set<string>).sort(), [
        'a',
        'b',
        'c',
      ])).to.equal(true)
    });

    _it('Consistency', () => {
      const state = mime._getTestState();
      const types:Map<string,string> = state.types;
      const extensions:Map<string,string> = state.extensions;
      Object.keys(types).forEach(ext => {
        expect(ext).to.equal(extensions[types[ext]])
      })
    });

    _it('Specific types', () => {
      testGetType(mime, [
        {
          input: 'html', expected: 'text/html'
        },
        {
          input: 'js', expected: 'text/javascript'
        },
        {
          input: 'json', expected: 'application/json'
        },
        {
          input: 'rtf', expected: 'application/rtf'
        },
        {
          input: 'txt', expected: 'text/plain'
        },
        {
          input: 'xml', expected: 'application/xml'
        },
        {
          input: 'wasm', expected: 'application/wasm'
        },
      ]);

      testGetExtension(mime, [{
        input: 'text/xml', expected: 'xml'
      }]);
    });

    _it('charset parameter', () => {
      testGetExtension(mime, [
        {
          input: 'text/html;charset=UTF-8', expected: 'html'
        },
        {
          input: 'text/HTML; charset=UTF-8', expected: 'html'
        },
        {
          input: 'text/html; charset=UTF-8', expected: 'html'
        },
        {
          input: 'text/html; charset=UTF-8 ', expected: 'html'
        },
        {
          input: 'text/html ; charset=UTF-8', expected: 'html'
        },
        {
          input: 'application/octet-stream', expected: 'bin'
        },
        {
          input: 'application/octet-stream ', expected: 'bin'
        },
        {
          input: ' text/html; charset=UTF-8', expected: 'html'
        },
        {
          input: 'text/html; charset=UTF-8 ', expected: 'html'
        },
        {
          input: 'text/html; charset=UTF-8', expected: 'html'
        },
        {
          input: 'text/html ; charset=UTF-8', expected: 'html'
        },
        {
          input: 'text/html;charset=UTF-8', expected: 'html'
        },
        {
          input: 'text/Html;charset=UTF-8', expected: 'html'
        },
      ]);
    });
  })
}