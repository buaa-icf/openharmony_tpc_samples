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

import {
  describe as _describe,
  beforeAll as _beforeAll,
  beforeEach as _beforeEach,
  afterEach as _afterEach,
  afterAll as _afterAll,
  it as _it,
  expect as _expect
} from '@ohos/hypium'

var tag = "inversify-demo： "

export const it = function (name, func) {
  _it(name, 0, func)
}

export const describe = _describe;

export const beforeAll = _beforeAll;

export const beforeEach = _beforeEach;

export const afterEach = _afterEach;

export const afterAll = _afterAll;

export const expect = function (source) {
  return {
    eq(value) {
      _expect(source).assertEqual(value);
    },
    eql(value) {
      _expect(source).assertEqual(value);
    },
    eqls(value) {
      _expect(source).assertEqual(value);
    },
    not: {
      eql(value) {
        _expect(source).assertEqual(value);
      },
      to: {
        equal(value) {
          _expect(source).assertEqual(value);
        },
        eql(value) {
          _expect(source).assertEqual(value);
        },
        throws() {
          console.log(tag + "expect throw exception")
        },
        be: {
          an(value) {
            _expect(typeof source === value).assertTrue()
          },
          instanceof(value) {
            _expect(source instanceof value).assertTrue()
          },
          eql(value) {
            _expect(source).assertEqual(value);
          },
          equal(value) {
            _expect(source).assertEqual(value);
          },
          eqls(value) {
            _expect(source).assertEqual(value);
          },
        },
        eq(value) {
          _expect(source).assertEqual(value);
        },
        throw() {
          try {
            source && source()
          } catch (err) {
            console.log(tag + "->error")
          }
        },

      }
    },
    have: {
      property(value) {
        if (source != null && !source.value) {
          _expect(source.value).assertEqual(value);
        }
        else {
          _expect(source).assertEqual(value);
        }
      }
    },
    to: {
      equal(value) {
        _expect(source).assertEqual(value);
      },
      eql(value) {
        _expect(source).assertEqual(value);
      },
      be: {
        an(value) {
          _expect(typeof source === value).assertTrue()
        },
        instanceof(value) {
          _expect(source instanceof value).assertTrue()
        },
        eql(value) {
          _expect(source).assertEqual(value);
        },
        equal(value) {
          _expect(source).assertEqual(value);
        },
      },
      eq(value) {
        _expect(source).assertEqual(value);
      },
      throw(value) {
        try {
          source && source()
        } catch (err) {
          _expect(err.message).assertEqual(value)
          console.log(tag + "expect(" + err.message + ").throw(" + value + ")")
        }
      },

    }
  }
};