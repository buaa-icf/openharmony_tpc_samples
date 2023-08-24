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

export default function testingXml2jsKey() {
  describe('TestingXml2jsKey', function () {
    var Changing_options_declarationKey = {
      compact: false, declarationKey: 'declaration'.slice(0, 3)
    };
    testItems('xml2js', Changing_options_declarationKey).forEach(function (test) {
      it('Changing_options_declarationKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, Changing_options_declarationKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var Changing_options_instructionKey = {
      compact: false, instructionKey: 'instruction'.slice(0, 3)
    };
    testItems('xml2js', Changing_options_instructionKey).forEach(function (test) {
      it('Changing_options_instructionKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, Changing_options_instructionKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var Changing_options_attributesKey = {
      compact: false, attributesKey: 'attributes'.slice(0, 3)
    };
    testItems('xml2js', Changing_options_attributesKey).forEach(function (test) {
      it('Changing_options_attributesKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, Changing_options_attributesKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var Changing_options_textKey = {
      compact: false, textKey: 'text'.slice(0, 3)
    };
    testItems('xml2js', Changing_options_textKey).forEach(function (test) {
      it('Changing_options_textKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, Changing_options_textKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var Changing_options_cdataKey = {
      compact: false, cdataKey: 'cdata'.slice(0, 3)
    };
    testItems('xml2js', Changing_options_cdataKey).forEach(function (test) {
      it('Changing_options_cdataKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, Changing_options_cdataKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var Changing_options_doctype_Key = {
      compact: false, doctypeKey: 'doctype'.slice(0, 3)
    };
    testItems('xml2js', Changing_options_doctype_Key).forEach(function (test) {
      it('Changing_options_doctype_Key_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, Changing_options_doctype_Key))).assertEqual(JSON.stringify(test.js));
      });
    });

    var changing_options_commentKey = {
      compact: false, commentKey: 'comment'.slice(0, 3)
    };
    testItems('xml2js', changing_options_commentKey).forEach(function (test) {
      it('changing_options_commentKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, changing_options_commentKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var changing_options_parentKey = {
      compact: false, parentKey: 'parent'.slice(0, 3)
    };
    testItems('xml2js', changing_options_parentKey).forEach(function (test) {
      it('changing_options_parentKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, changing_options_parentKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var changing_options_typeKey = {
      compact: false, typeKey: 'type'.slice(0, 3)
    };
    testItems('xml2js', changing_options_typeKey).forEach(function (test) {
      it('changing_options_typeKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, changing_options_typeKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var changing_options_nameKey = {
      compact: false, nameKey: 'name'.slice(0, 3)
    };
    testItems('xml2js', changing_options_nameKey).forEach(function (test) {
      it('changing_options_nameKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, changing_options_nameKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var changing_options_elementsKey = {
      compact: false, elementsKey: 'elements'.slice(0, 3)
    };
    testItems('xml2js', changing_options_elementsKey).forEach(function (test) {
      it('changing_options_elementsKey_ ' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, changing_options_elementsKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_changing_options_declarationKey = {
      compact: true, declarationKey: 'declaration'.slice(0, 3)
    };
    testItems('xml2js', compact_true_changing_options_declarationKey).forEach(function (test) {
      it('compact_true_changing_options_declarationKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_changing_options_declarationKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_changing_options_instructionKey = {
      compact: true, instructionKey: 'instruction'.slice(0, 3)
    };
    testItems('xml2js', compact_true_changing_options_instructionKey).forEach(function (test) {
      it('compact_true_changing_options_instructionKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_changing_options_instructionKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_changing_options_attributesKey = {
      compact: true, attributesKey: 'attributes'.slice(0, 3)
    };
    testItems('xml2js', compact_true_changing_options_attributesKey).forEach(function (test) {
      it('compact_true_changing_options_attributesKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_changing_options_attributesKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_changing_options_textKey = {
      compact: true, textKey: 'text'.slice(0, 3)
    };
    testItems('xml2js', compact_true_changing_options_textKey).forEach(function (test) {
      it('compact_true_changing_options_textKey_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_changing_options_textKey))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_changing_options_cdata_key = {
      compact: true, cdataKey: 'cdata'.slice(0, 3)
    };
    testItems('xml2js', compact_true_changing_options_cdata_key).forEach(function (test) {
      it('compact_true_changing_options_cdata_key_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_changing_options_cdata_key))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_changing_options_doctype_key = {
      compact: true, doctypeKey: 'doctype'.slice(0, 3)
    };
    testItems('xml2js', compact_true_changing_options_doctype_key).forEach(function (test) {
      it('compact_true_changing_options_doctype_key_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_changing_options_doctype_key))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_changing_options_comment_key = {
      compact: true, commentKey: 'comment'.slice(0, 3)
    };
    testItems('xml2js', compact_true_changing_options_comment_key).forEach(function (test) {
      it('compact_true_changing_options_comment_key_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_changing_options_comment_key))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_changing_options_parent_key = {
      compact: true, parentKey: 'parent'.slice(0, 3)
    };
    testItems('xml2js', compact_true_changing_options_parent_key).forEach(function (test) {
      it('compact_true_changing_options_parent_key_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_changing_options_parent_key))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_changing_options_type_key = {
      compact: true, typeKey: 'type'.slice(0, 3)
    };
    testItems('xml2js', compact_true_changing_options_type_key).forEach(function (test) {
      it('compact_true_changing_options_type_key_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_changing_options_type_key))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_changing_options_name_key = {
      compact: true, nameKey: 'name'.slice(0, 3)
    };
    testItems('xml2js', compact_true_changing_options_name_key).forEach(function (test) {
      it('compact_true_changing_options_name_key_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_changing_options_name_key))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_changing_options_elements_key = {
      compact: true, elementsKey: 'elements'.slice(0, 3)
    };
    testItems('xml2js', compact_true_changing_options_elements_key).forEach(function (test) {
      it('compact_true_changing_options_elements_key_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_changing_options_elements_key))).assertEqual(JSON.stringify(test.js));
      });
    });

  });
}