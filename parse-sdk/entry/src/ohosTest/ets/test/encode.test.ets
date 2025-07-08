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
import { encode, ParseACL, ParseFile, ParseGeoPoint, ParseObject, ParseRelation } from '@ohos/parser-sdk';

export default function encodeTest() {

  describe('encodeTest', () => {
    it('ignores primitives',0, () => {
      expect(encode(undefined)).assertEqual(undefined);
      expect(encode(null)).assertEqual(null);
      expect(encode(true)).assertEqual(true);
      expect(encode(12)).assertEqual(12);
      expect(encode('string')).assertEqual('string');
    });

    it('encodes dates',0, () => {
      expect(encode(new Date(Date.UTC(2015, 1)))).assertDeepEquals({
        __type: 'Date',
        iso: '2015-02-01T00:00:00.000Z',
      });
    });

    it('encodes regular expressions',0, () => {
      expect(encode(new RegExp('^hello'))).assertEqual('^hello');
      expect(encode(/a[^b]+c/g)).assertEqual('a[^b]+c');
    });

    it('encodes GeoPoints',0, () => {
      const point :ESObject= new ParseGeoPoint(40.5, 50.4);
      expect(encode(point)).assertDeepEquals({
        __type: 'GeoPoint',
        latitude: 40.5,
        longitude: 50.4,
      });
    });

    it('encodes Files',0, () => {
      const file :ESObject= new ParseFile('parse.txt');
      expect(encode.bind(null, file)).assertThrowError('Tried to encode an unsaved file.');
      file._url = 'https://files.parsetfss.com/a/parse.txt';
      expect(encode(file)).assertDeepEquals({
        __type: 'File',
        name: 'parse.txt',
        url: 'https://files.parsetfss.com/a/parse.txt',
      });
    });

    it('encodes ACLs',0, () => {
      const acl :ESObject= new ParseACL({ aUserId: { read: true, write: false } });
      expect(encode(acl)).assertDeepEquals({
        aUserId: {
          read: true,
          write: false,
        },
      });
    });

    it('does not encode ParseObjects when they are disallowed',0, () => {
      const obj = new ParseObject('Item');
      expect(encode.bind(null, obj, true)).assertThrowError('Parse Objects not allowed here');
    });

    it('iterates over objects',0, () => {
      const obj :ESObject= {
        num: 12,
        date: new Date(Date.UTC(2015, 1)),
        str: 'abc',
      };
      expect(encode(obj)).assertDeepEquals({
        num: 12,
        date: { __type: 'Date', iso: '2015-02-01T00:00:00.000Z' },
        str: 'abc',
      });
    });
  })
}