/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import helper from '@ohos/xml_js/src/main/ets/options-helper'
import { describe, expect, it } from '@ohos/hypium'

export default function optionsHelperTest() {
  describe('OptionsHelperTest', function () {

    it('Copy_unprovided_options', 0, function () {
      expect(JSON.stringify(helper.copyOptions())).assertEqual(JSON.stringify({}));
    });

    it('Copy_provided_options', 0, function () {
      var options = {
        ignoreText: true, textKey: true
      };
      expect(JSON.stringify(helper.copyOptions(options))).assertEqual(JSON.stringify(options));
    });

    it('New_flag', 0, function () {
      var options = {};
      helper.ensureFlagExists('foo', options);
      expect(JSON.stringify(options)).assertEqual(JSON.stringify({
        foo: false
      }));
    });

    it('Existing_flag_not_boolean', 0, function () {
      var options = {
        foo: 123
      };
      helper.ensureFlagExists('foo', options);
      expect(JSON.stringify(options)).assertEqual(JSON.stringify({
        foo: false
      }));
    });

    it('Existing_flag', 0, function () {
      var options = {
        foo: true
      };
      helper.ensureFlagExists('foo', options);
      expect(JSON.stringify(options)).assertEqual(JSON.stringify({
        foo: true
      }));
    });

    it('New_key', 0, function () {
      var options = {};
      helper.ensureKeyExists('foo', options);
      expect(JSON.stringify(options)).assertEqual(JSON.stringify({
        fooKey: 'foo'
      }));
    });

    it('Existing_key_not_string', 0, function () {
      var options = {
        fooKey: 123
      };
      helper.ensureKeyExists('foo', options);
      expect(JSON.stringify(options)).assertEqual(JSON.stringify({
        fooKey: 'foo'
      }));
    });

    it('Existing_key_string', 0, function () {
      var options = {
        fooKey: 'baa'
      };
      helper.ensureKeyExists('foo', options);
      expect(JSON.stringify(options)).assertEqual(JSON.stringify({
        fooKey: 'baa'
      }));
    });
  });
}