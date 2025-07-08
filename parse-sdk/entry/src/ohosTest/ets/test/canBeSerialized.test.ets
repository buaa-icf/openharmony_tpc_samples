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
import { canBeSerialized, ParseFile, ParseObject, ParseRelation } from '@ohos/parser-sdk';

export default function canBeSerializedTest() {

  describe('canBeSerialized', () => {
    it('validates_primitives',0, () => {
      let test:ESObject={
        a: 12,
        b: 'string',
        c: false,
      }
      const o :ParseObject= new ParseObject('oid',test );
      expect(canBeSerialized(o)).assertTrue();
    });

    it('returns_true_for_relations',0,() => {
      const relation:ESObject = new ParseRelation(undefined, undefined);
      const parent :ESObject= new ParseObject(undefined, {
        child: relation,
      } as ESObject);
      expect(canBeSerialized(parent)).assertTrue();
    });



    it('traverses_nested_arrays_and_objects',0, () => {
      let o : ESObject= new ParseObject('oid', {
        a: {
          a: {
            a: {
              b: new ParseObject(),
            }as ESObject,
          }as ESObject,
        }as ESObject,
      }as ESObject);
      expect(canBeSerialized(o)).assertFalse();
    });
  })
}