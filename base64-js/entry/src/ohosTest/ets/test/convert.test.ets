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

import b64 from 'base64-js'
import { describe, it, expect } from '@ohos/hypium'
const checks = [
  'a',
  'aa',
  'aaa',
  'hi',
  'hi!',
  'hi!!',
  'sup',
  'sup?',
  'sup?!'
]
function equal(a: ESObject, b: ESObject) {
  let i:number
  const length :number= a.length
  if (length !== b.length) return false
  for (i = 0; i < length; ++i) {
    if ((a[i] & 0xFF) !== (b[i] & 0xFF)) return false
  }
  return true
}
function  map(arr: ESObject, callback: ESObject): ESObject[] {
  const res: ESObject[] = []
  let kValue: ESObject
  let mappedValue: ESObject
  for (let k: number = 0, len: number = arr.length; k < len; k++) {
    if ((typeof arr === 'string' && !!arr.charAt(k))) {
      kValue = arr.charAt(k)
      mappedValue = callback(kValue, k, arr)
      res[k] = mappedValue
    } else if (typeof arr !== 'string'&& arr.indexOf(k)) {
      kValue = arr[k]
      mappedValue = callback(kValue, k, arr)
      res[k] = mappedValue
    }
  }
  return res
}

export default function convertTest() {
  describe('convertTest', ()=> {
    it('convert_to_base64_and_back',0, ()=> {
      for (let i = 0; i < checks.length; i++) {
        const check = checks[i]
        const b64Str = b64.fromByteArray(new Uint8Array(map(check, (char: ESObject): ESObject => {
          return char.charCodeAt(0)
        })))
        const arr = b64.toByteArray(b64Str)
        expect(b64.byteLength(b64Str)).assertEqual(arr.length)
      }
    })

    const data = [
      [[0, 0, 0], 'AAAA'],
      [[0, 0, 1], 'AAAB'],
      [[0, 1, -1], 'AAH/'],
      [[1, 1, 1], 'AQEB'],
      [[0, -73, 23], 'ALcX']
    ]

    it('convert_known_data_to_string',0, ()=> {
      for (let i = 0; i < data.length; i++) {
        const bytes: ESObject = data[i][0]
        const expected: ESObject = data[i][1]
        const actual = b64.fromByteArray( new Uint8Array(bytes))
        expect(actual).assertEqual(expected)
      }
    })

    it('convert_known_data_from_string',0, ()=> {
      for (let i = 0; i < data.length; i++) {
        const expected: ESObject = data[i][0]
        const string: ESObject = data[i][1]
        const actual = b64.toByteArray(string)
        expect(equal(actual, expected)).assertTrue()
        const length: ESObject = b64.byteLength(string)
        expect(length).assertEqual( expected.length)
      }
    })
  })
}
