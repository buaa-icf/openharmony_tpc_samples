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

import { describe, expect, it } from '@ohos/hypium';
import { equals, ParseACL, ParseFile, ParseGeoPoint, ParseObject } from '@ohos/parser-sdk';

export default function equalTest() {

  describe('equalTest', () => {
    it('tests equality of primitives', 0 , () => {
      expect(equals(1, 'string')).assertEqual(false);
      expect(equals(1, true)).assertEqual(false);
      expect(equals(1, undefined)).assertEqual(false);
      expect(equals(1, null)).assertEqual(false);
      expect(equals(1, {})).assertEqual(false);
      expect(equals(1, 4)).assertEqual(false);
      expect(equals(1, 1)).assertEqual(true);

      expect(equals(null, 'string')).assertEqual(false);
      expect(equals(true, 'string')).assertEqual(false);
      expect(equals(undefined, 'string')).assertEqual(false);
      expect(equals(true, 'string')).assertEqual(false);
      expect(equals({}, 'string')).assertEqual(false);
      expect(equals('abc', 'def')).assertEqual(false);
      expect(equals('abc', 'abc')).assertEqual(true);

      expect(equals(false, false)).assertEqual(true);
      expect(equals(true, true)).assertEqual(true);
      expect(equals(true, false)).assertEqual(false);

      expect(equals(null, null)).assertEqual(true);
      expect(equals(undefined, undefined)).assertEqual(true);
      expect(equals(null, undefined)).assertEqual(false);
    });

    it('tests equality of objects and arrays', 0 , () => {
      const a :ESObject= {};
      expect(equals(a, a)).assertEqual(true);
      expect(equals({}, {})).assertEqual(true);
      expect(equals({ a: 1 }, { a: 1 })).assertEqual(true);
      expect(equals({ a: 1 }, { a: 2 })).assertEqual(false);
      expect(equals({ a: 1, b: 2 }, { b: 2, a: 1 })).assertEqual(true);
      expect(equals({ a: 1, b: 2 }, { b: 2 })).assertEqual(false);
      expect(equals({ a: {} }, { a: {} })).assertEqual(true);

      expect(equals([], [])).assertEqual(true);
      expect(equals([], {})).assertEqual(false);
      expect(equals([1, 2, 3], [1, 2, 3])).assertEqual(true);
      expect(equals([1, 2, 3], [3, 2, 1])).assertEqual(false);
      expect(equals([1, 2, 3], [1, 2])).assertEqual(false);
      expect(equals([{ c: 3 }, 2, 1], [{ c: 3 }, 2, 1])).assertEqual(true);
    });

    it('tests equality of ACLs', 0 , () => {
      // Defer to ParseACL tests for the majority of testing
      const a = new ParseACL();
      const b = new ParseACL();

      expect(equals(a, a)).assertEqual(true);
      expect(equals(a, b)).assertEqual(true);
      expect(equals(b, a)).assertEqual(true);

      a.setPublicReadAccess(true);
      expect(equals(a, a)).assertEqual(true);
      expect(equals(a, b)).assertEqual(false);
      expect(equals(b, a)).assertEqual(false);
    });

    it('tests equality of GeoPoints', 0 , () => {
      // Defer to ParseGeoPoint tests for the majority of testing
      const a = new ParseGeoPoint(40, 40);
      expect(equals(a, a)).assertEqual(true);

      let b = new ParseGeoPoint(40, 40);
      expect(equals(a, b)).assertEqual(true);
      expect(equals(b, a)).assertEqual(true);

      b = new ParseGeoPoint(50, 40);
      expect(equals(a, b)).assertEqual(false);
      expect(equals(b, a)).assertEqual(false);
    });

    it('tests equality of Files', 0 , () => {
      // Defer to ParseFile tests for the majority of testing
      let a = new ParseFile('parse.txt', [61, 170, 236, 120]);
      let b = new ParseFile('parse.txt', [61, 170, 236, 120]);

      expect(equals(a, a)).assertEqual(true);
      // unsaved files are never equal
      expect(equals(a, b)).assertEqual(false);
      a = ParseFile.fromJSON({
        __type: 'File',
        name: 'parse.txt',
        url: 'http://files.parsetfss.com/a/parse.txt',
      });
      b = ParseFile.fromJSON({
        __type: 'File',
        name: 'parse.txt',
        url: 'http://files.parsetfss.com/a/parse.txt',
      });

      expect(equals(a, b)).assertEqual(true);
    });

    it('tests equality of ParseObjects', 0 , () => {
      // Defer to ParseObject tests for the majority of testing
      const a = new ParseObject('Item');
      const b = new ParseObject('Item');
      expect(equals(a, a)).assertEqual(true);
      expect(equals(a, b)).assertEqual(false);

      a.id = 'myobj';
      b.id = 'myobj';
      expect(equals(a, b)).assertEqual(true);

      const c :ESObject= {
        __type: 'Pointer',
        className: 'Item',
        objectId: 'myobj',
      };
      const d :ESObject= {
        __type: 'Object',
        className: 'Item',
        objectId: 'myobj',
      };
      const e :ESObject= {
        __type: 'Unknown',
        className: 'Item',
        objectId: 'myobj',
      };
      expect(equals(c, b)).assertEqual(true);
      expect(equals(d, b)).assertEqual(true);
      expect(equals(e, b)).assertEqual(false);
    });

    it('tests equality of Date', 0 , () => {
      const a = new Date('2018-08-09T00:01:53.964Z');
      const b = new Date('2018-08-10T00:00:00.000Z');

      expect(equals(a, a)).assertEqual(true);
      expect(equals(a, b)).assertEqual(false);
      expect(equals(b, a)).assertEqual(false);

      const c = [];
      expect(equals(a, c)).assertEqual(false);
    });
  })
}