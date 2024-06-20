/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import harNAPI from 'libluaarkts.so'

export default function luaTest() {
  // Defines a test suite. Two parameters are supported: test suite name and test suite function.
  beforeAll(() => {
    // Presets an action, which is performed only once before all test cases of the test suite start.
    // This API supports only one parameter: preset action function.
  })
  beforeEach(() => {
    // Presets an action, which is performed before each unit test case starts.
    // The number of execution times is the same as the number of test cases defined by **it**.
    // This API supports only one parameter: preset action function.
  })
  afterEach(() => {
    // Presets a clear action, which is performed after each unit test case ends.
    // The number of execution times is the same as the number of test cases defined by **it**.
    // This API supports only one parameter: clear action function.
  })
  afterAll(() => {
    // Presets a clear action, which is performed after all test cases of the test suite end.
    // This API supports only one parameter: clear action function.
  })
  describe('ActsInitTest', () => {
    const filePath = '/data/storage/el1/bundle/entry/resources/resfile/unitTest.lua';
    harNAPI.InitLuaEnv(filePath);
    it('run_init__setVarInt', 0, async () => {
      harNAPI.T2lSetVarInt('testValInt', 12);
    })
    it('run_init__getVarInt', 0, async () => {
      const value: number = harNAPI.T2lGetVarInt('testValInt');
      expect(value).assertEqual(12);
    })
    it('run_init__setVarLong', 0, async () => {
      harNAPI.T2lSetVarLong('testValLong', 1234567890);
    })
    it('run_init__getVarLong', 0, async () => {
      const value: number = harNAPI.T2lGetVarLong('testValLong');
      expect(value).assertEqual(1234567890);
    })
    it('run_init__setVarDouble', 0, async () => {
      harNAPI.T2lSetVarDouble('testValDouble', 3.13456);
    })
  })
  // it('ActsInitTest', 0, () => {
  //   // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
  //   hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
  //   let a = 'abc';
  //   let b = 'b';
  //   // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
  //   expect(a).assertContain(b);
  //   expect(a).assertEqual(a);
  // })
}