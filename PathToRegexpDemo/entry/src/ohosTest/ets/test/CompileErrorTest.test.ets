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

export default function CompileErrorTest() {

  describe('CompileErrorTest', () => {
    beforeAll(() => {
    });

    it('should throw when a param is missing', 0, async (done :Function) => {
      try{
        const toPath = compile("/a/:b/c");
        toPath();
      }catch (err){
        expect(err.message).assertEqual("Missing parameters: b");
        done();
      }
    })
    it('should throw when expecting a repeated value', 0, async (done :Function) => {
      try{
        const toPath = compile("/*foo");
        toPath({ foo: [] });
      }catch (err){
        expect(err.message).assertEqual('Expected "foo" to be a non-empty array');
        done();
      }
    })
    it('should throw when param gets an array', 0, async (done :Function) => {
      try{
        const toPath = compile("/:foo");
        toPath({ foo: [] });
      }catch (err){
        expect(err.message).assertEqual('Expected "foo" to be a string');
        done();
      }
    })
    it('should throw when a wildcard is not an array', 0, async (done :Function) => {
      try{
        const toPath = compile("/*foo");
        toPath({ foo: "a" });
      }catch (err){
        expect(err.message).assertEqual('Expected "foo" to be a non-empty array');
        done();
      }
    })
    it('should throw when a wildcard array value is not a string', 0, async (done :Function) => {
      try{
        const toPath = compile("/*foo");
        toPath({ foo: [1, "a"] as ESObject });
      }catch (err){
        expect(err.message).assertEqual('Expected "foo/0" to be a string');
        done();
      }
    })
  })
}
