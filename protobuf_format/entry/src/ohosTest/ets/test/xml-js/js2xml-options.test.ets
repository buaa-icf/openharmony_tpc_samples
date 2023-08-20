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
import convert from '@ohos/xml_js'
import testItems from '../../xml_js_util/test-items'
import { describe, expect, it } from '@ohos/hypium'
import buffer from '@ohos.buffer';

export default function js2xmlOptionsTest() {
  describe('Js2xmlOptionsTest', function () {

    var options = {};
    testItems('js2xml', options).forEach(function (test) {
      it('No_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, options)).assertEqual(test.xml);
      });
    });

    var default_options = {
      compact: false,
      spaces: 0,
      ignoreText: false,
      ignoreComment: false,
      ignoreCdata: false,
      fullTagEmptyElement: false
    };
    testItems('js2xml', default_options).forEach(function (test) {
      it('default_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, default_options)).assertEqual(test.xml);
      });
    });

    var spaces4_options = {
      spaces: 4, onlyItem: 8
    };
    testItems('js2xml', spaces4_options).forEach(function (test) {
      it('spaces4_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, spaces4_options)).assertEqual(test.xml);
      });
    });

    var spaces0_options = {
      spaces: 0
    };
    testItems('js2xml', spaces0_options).forEach(function (test) {
      it('spaces0_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, spaces0_options)).assertEqual(test.xml);
      });
    });

    var spaces_0_ignoreText_true_options = {
      spaces: 0, ignoreText: true
    };
    testItems('js2xml', spaces_0_ignoreText_true_options).forEach(function (test) {
      it('spaces_0_ignoreText_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, spaces_0_ignoreText_true_options)).assertEqual(test.xml);
      });
    });

    var spaces_0_ignoreComment_true_options = {
      spaces: 0, ignoreComment: true
    };
    testItems('js2xml', spaces_0_ignoreComment_true_options).forEach(function (test) {
      it('spaces_0_ignoreComment_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, spaces_0_ignoreComment_true_options)).assertEqual(test.xml);
      });
    });

    var spaces_0_ignoreCdata_true_options = {
      spaces: 0, ignoreCdata: true
    };
    testItems('js2xml', spaces_0_ignoreCdata_true_options).forEach(function (test) {
      it('spaces_0_ignoreCdata_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, spaces_0_ignoreCdata_true_options)).assertEqual(test.xml);
      });
    });

    var spaces_0_ignore_Doctype_true_options = {
      spaces: 0, ignoreDoctype: true
    };
    testItems('js2xml', spaces_0_ignore_Doctype_true_options).forEach(function (test) {
      it('spaces_0_ignore_Doctype_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, spaces_0_ignore_Doctype_true_options)).assertEqual(test.xml);
      });
    });

    var spaces_0_ignoreDeclaration_true_options = {
      spaces: 0, ignoreDeclaration: true
    };
    testItems('js2xml', spaces_0_ignoreDeclaration_true_options).forEach(function (test) {
      it('spaces_0_ignoreDeclaration_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, spaces_0_ignoreDeclaration_true_options)).assertEqual(test.xml);
      });
    });

    var spaces_0_ignoreInstruction_true_options = {
      spaces: 0, ignoreInstruction: true
    };
    testItems('js2xml', spaces_0_ignoreInstruction_true_options).forEach(function (test) {
      it('spaces_0_ignoreInstruction_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, spaces_0_ignoreInstruction_true_options)).assertEqual(test.xml);
      });
    });

    var spaces_0_fullTagEmptyElement_true_options = {
      spaces: 0, fullTagEmptyElement: true
    };
    testItems('js2xml', spaces_0_fullTagEmptyElement_true_options).forEach(function (test) {
      it('spaces_0_fullTagEmptyElement_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, spaces_0_fullTagEmptyElement_true_options)).assertEqual(test.xml);
      });
    });


    var compact_true_options = {
      compact: true,
      spaces: 0,
      ignoreText: false,
      ignoreComment: false,
      ignoreCdata: false,
      fullTagEmptyElement: false
    };
    testItems('js2xml', compact_true_options).forEach(function (test) {
      it('compact_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, compact_true_options)).assertEqual(test.xml);
      });
    });

    var compact_true_spaces4_options = {
      compact: true, spaces: 4
    };
    testItems('js2xml', compact_true_spaces4_options).forEach(function (test) {
      it('compact_true_spaces4_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, compact_true_spaces4_options)).assertEqual(test.xml);
      });
    });

    var compact_true_spaces0_options = {
      compact: true, spaces: 0
    };
    testItems('js2xml', compact_true_spaces0_options).forEach(function (test) {
      it('compact_true_spaces0_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, compact_true_spaces0_options)).assertEqual(test.xml);
      });
    });

    var compact_true_spaces0_ignoreText_true_options = {
      compact: true, spaces: 0, ignoreText: true
    };
    testItems('js2xml', compact_true_spaces0_ignoreText_true_options).forEach(function (test) {
      it('compact_true_spaces0_ignoreText_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, compact_true_spaces0_ignoreText_true_options)).assertEqual(test.xml);
      });
    });

    var compact_true_spaces0_ignoreComment_true_options = {
      compact: true, spaces: 0, ignoreComment: true
    };
    testItems('js2xml', compact_true_spaces0_ignoreComment_true_options).forEach(function (test) {
      it('compact_true_spaces0_ignoreComment_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, compact_true_spaces0_ignoreComment_true_options)).assertEqual(test.xml);
      });
    });

    var compact_true_spaces0_ignoreCdata_true_options = {
      compact: true, spaces: 0, ignoreCdata: true
    };
    testItems('js2xml', compact_true_spaces0_ignoreCdata_true_options).forEach(function (test) {
      it('compact_true_spaces0_ignoreCdata_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, compact_true_spaces0_ignoreCdata_true_options)).assertEqual(test.xml);
      });
    });

    var compact_true_spaces0_ignore_Doctype_true_options = {
      compact: true, spaces: 0, ignoreDoctype: true
    };
    testItems('js2xml', compact_true_spaces0_ignore_Doctype_true_options).forEach(function (test) {
      it('compact_true_spaces0_ignore_Doctype_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, compact_true_spaces0_ignore_Doctype_true_options)).assertEqual(test.xml);
      });
    });

    var compact_true_spaces0_ignoreDeclaration_true_options = {
      compact: true, spaces: 0, ignoreDeclaration: true
    };
    testItems('js2xml', compact_true_spaces0_ignoreDeclaration_true_options).forEach(function (test) {
      it('compact_true_spaces0_ignoreDeclaration_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, compact_true_spaces0_ignoreDeclaration_true_options)).assertEqual(test.xml);
      });
    });

    var compact_true_spaces0_ignoreInstruction_true_options = {
      compact: true, spaces: 0, ignoreInstruction: true
    };
    testItems('js2xml', compact_true_spaces0_ignoreInstruction_true_options).forEach(function (test) {
      it('compact_true_spaces0_ignoreInstruction_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, compact_true_spaces0_ignoreInstruction_true_options)).assertEqual(test.xml);
      });
    });

    var compact_true_spaces0_fullTagEmptyElement_true_options = {
      compact: true, spaces: 0, fullTagEmptyElement: true
    };
    testItems('js2xml', compact_true_spaces0_fullTagEmptyElement_true_options).forEach(function (test) {
      it('compact_true_spaces0_fullTagEmptyElement_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, compact_true_spaces0_fullTagEmptyElement_true_options)).assertEqual(test.xml);
      });
    });


    var varying_spaces_options = {};
    testItems('js2xml', varying_spaces_options).forEach(function (test) {
      it('varying_spaces_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, varying_spaces_options)).assertEqual(test.xml);
      });
    });

    var varying_spaces_true_options = {
      spaces: true
    };
    testItems('js2xml', varying_spaces_true_options).forEach(function (test) {
      it('varying_spaces_true_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, varying_spaces_true_options)).assertEqual(test.xml);
      });
    });

    var varying_spaces2_options = {
      spaces: 2
    };
    testItems('js2xml', varying_spaces2_options).forEach(function (test) {
      it('varying_spaces2_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, varying_spaces2_options)).assertEqual(test.xml);
      });
    });

    var varying_spaces4_options = {
      spaces: 4
    };
    testItems('js2xml', varying_spaces4_options).forEach(function (test) {
      it('varying_spaces4_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, varying_spaces4_options)).assertEqual(test.xml);
      });
    });

    var varying_spaces_2whitespaces_options = {
      spaces: '  '
    };
    testItems('js2xml', varying_spaces_2whitespaces_options).forEach(function (test) {
      it('varying_spaces_2whitespaces_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, varying_spaces_2whitespaces_options)).assertEqual(test.xml);
      });
    });

    var varying_spaces_t_options = {
      spaces: '\t'
    };
    testItems('js2xml', varying_spaces_t_options).forEach(function (test) {
      it('varying_spaces_t_options_' + test.desc, 0, function () {
        expect(convert.js2xml(test.js, varying_spaces_t_options)).assertEqual(test.xml);
      });
    });

    var using_default_options = {};
    testItems('js2xml', using_default_options).forEach(function (test) {
      it('using_default_options_' + test.desc, 0, function () {
        expect(convert.json2xml(JSON.stringify(test.js), using_default_options)).assertEqual(test.xml);
      });
    });

    var submitting_json_as_javascript_object_options = {};
    testItems('js2xml', submitting_json_as_javascript_object_options).forEach(function (test) {
      it('submitting_json_as_javascript_object_options_' + test.desc, 0, function () {
        expect(convert.json2xml(test.js, submitting_json_as_javascript_object_options)).assertEqual(test.xml);
      });
    });

    it('Write_processing_instruction_attributes_compact_true', 0, function () {
      expect(convert.js2xml({
        "_instruction": {
          "go": {
            "_attributes": {
              "to": "there"
            }
          }
        }
      }, {
        compact: true
      })).assertEqual('<?go to="there"?>');
    });

    it('Write_processing_instruction_attributes_compact_false', 0, function () {
      expect(convert.js2xml({
        "elements": [{
          "type": "instruction", "name": "go", "attributes": {
            "to": "there"
          }
        }]
      })).assertEqual('<?go to="there"?>');
    });
  });
}