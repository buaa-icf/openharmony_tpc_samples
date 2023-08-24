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

var args;

function manipulate(val) {
  args = arguments;
  args[0] = val.toUpperCase();
  return val.toUpperCase();
}

function manipulateAttribute(obj) {
  args = arguments;
  var key, temp;
  for (key in obj) {
    try {
      temp = obj[key];
      delete obj[key];
      obj[key.toUpperCase()] = temp.toUpperCase();
    } catch (e) {
    }
  }
  return obj;
}

export default function testingXml2js() {
  describe('testingXml2js', function () {

    var doctype_options = {
      compact: false, doctypeFn: manipulate
    };
    testItems('xml2js', doctype_options).forEach(function (test) {
      it('doctype_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, doctype_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js.elements && test.js.elements[0].doctype) {
        it('doctype_options_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js.elements[test.js.elements.length-1].doctype));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
        });
      }
    });

    var instruction_options = {
      compact: false, instructionFn: manipulate
    };
    testItems('xml2js', instruction_options).forEach(function (test) {
      it('instruction_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, instruction_options))).assertEqual(JSON.stringify(test.js));
        // console.log(JSON.stringify(convert.xml2js(test.xml, options)));
      });
      if (test.js.elements && test.js.elements[0].instruction) {
        it('instruction_options_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js.elements[test.js.elements.length-1].instruction));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
          // console.log(JSON.stringify(args), '---------', test.js.elements[0].instruction);
        });
      }
    });

    var cdata_options = {
      compact: false, cdataFn: manipulate
    };
    testItems('xml2js', cdata_options).forEach(function (test) {
      it('cdata_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, cdata_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js.elements && test.js.elements[0].cdata) {
        it('cdata_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js.elements[test.js.elements.length-1].cdata));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
        });
      }
    });

    var comment_options = {
      compact: false, commentFn: manipulate
    };
    testItems('xml2js', comment_options).forEach(function (test) {
      it('comment_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, comment_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js.elements && test.js.elements[0].comment) {
        it('comment_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js.elements[test.js.elements.length-1].comment));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
        });
      }
    });

    var text_options = {
      compact: false, textFn: manipulate
    };
    testItems('xml2js', text_options).forEach(function (test) {
      it('text_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, text_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js.elements && test.js.elements[0].text) {
        it('text_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js.elements[test.js.elements.length-1].text));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
        });
      }
    });

    var instructionName_options = {
      compact: false, instructionNameFn: manipulate
    };
    testItems('xml2js', instructionName_options).forEach(function (test) {
      it('instructionName_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, instructionName_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js.elements && test.js.elements[0].instruction) {
        it('instructionName_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js.elements[test.js.elements.length-1].name));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
        });
      }
    });

    var elementName_options = {
      compact: false, elementNameFn: manipulate
    };
    testItems('xml2js', elementName_options).forEach(function (test) {
      it('elementName_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, elementName_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js.elements && test.js.elements[test.js.elements.length-1].type === 'element' && !test.js.elements[test.js.elements.length-1].elements) {
        it('elementName_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js.elements[test.js.elements.length-1].name));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
        });
      }
    });

    var attributeName_options = {
      compact: false, attributeNameFn: manipulate
    };
    testItems('xml2js', attributeName_options).forEach(function (test) {
      it('attributeName_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, attributeName_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var attributeValue_options = {
      compact: false, attributeValueFn: manipulate
    };
    testItems('xml2js', attributeValue_options).forEach(function (test) {
      it('attributeValue_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, attributeValue_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var attributes_options = {
      compact: false, attributesFn: manipulateAttribute
    };
    testItems('xml2js', attributes_options).forEach(function (test) {
      it('attributes_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, attributes_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js.elements && test.js.elements[test.js.elements.length-1].attributes) {
        it('attributes_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js.elements[test.js.elements.length-1].attributes));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
        });
      }
    });

    var compact_false_options = {
      compact: false,
      doctypeFn: manipulate,
      instructionFn: manipulate,
      cdataFn: manipulate,
      commentFn: manipulate,
      textFn: manipulate
    };
    testItems('xml2js', compact_false_options).forEach(function (test) {
      it('compact_false_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_options2 = {
      compact: false,
      instructionNameFn: manipulate,
      elementNameFn: manipulate,
      attributeNameFn: manipulate,
      attributeValueFn: manipulate
    };
    testItems('xml2js', compact_false_options2).forEach(function (test) {
      it('compact_false_options2_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_options2))).assertEqual(JSON.stringify(test.js));
      });
    });

    var doctype_callback_options = {
      compact: true, doctypeFn: manipulate
    };
    testItems('xml2js', doctype_callback_options).forEach(function (test) {
      it('doctype_callback_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, doctype_callback_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js._doctype) {
        it('doctype_callback_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js._doctype instanceof Array ? test.js._doctype[1] : test.js._doctype));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
        });
      }
    });

    var instruction_callback_options = {
      compact: true, instructionFn: manipulate
    };
    testItems('xml2js', instruction_callback_options).forEach(function (test) {
      it('instruction_callback_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, instruction_callback_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var cdata_callback_options = {
      compact: true, cdataFn: manipulate
    };
    testItems('xml2js', cdata_callback_options).forEach(function (test) {
      it('cdata_callback_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, cdata_callback_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js._cdata) {
        it('cdata_callback_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js._cdata instanceof Array ? test.js._cdata[1] : test.js._cdata));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
        });
      }
    });

    var comment_callback_options = {
      compact: true, commentFn: manipulate
    };
    testItems('xml2js', comment_callback_options).forEach(function (test) {
      it('comment_callback_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, comment_callback_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js._comment) {
        it('comment_callback_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js._comment instanceof Array ? test.js._comment[1] : test.js._comment));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
        });
      }
    });

    var text_callback_options = {
      compact: true, textFn: manipulate
    };
    testItems('xml2js', text_callback_options).forEach(function (test) {
      it('text_callback_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, text_callback_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js.a && test.js.a._text) {
        it('text_callback_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js.a._text));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js.a));
        });
      }
    });

    var instructionName_callback_options = {
      compact: true, instructionNameFn: manipulate
    };
    testItems('xml2js', instructionName_callback_options).forEach(function (test) {
      it('instructionName_callback_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, instructionName_callback_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var elementName_callback_options = {
      compact: true, elementNameFn: manipulate
    };
    testItems('xml2js', elementName_callback_options).forEach(function (test) {
      it('elementName_callback_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, elementName_callback_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var attributeName_callback_options = {
      compact: true, attributeNameFn: manipulate
    };
    testItems('xml2js', attributeName_callback_options).forEach(function (test) {
      it('attributeName_callback_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, attributeName_callback_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var attributeValue_callback_options = {
      compact: true, attributeValueFn: manipulate
    };
    testItems('xml2js', attributeValue_callback_options).forEach(function (test) {
      it('attributeValue_callback_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, attributeValue_callback_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var attributes_callback_options = {
      compact: true, attributesFn: manipulateAttribute
    };
    testItems('xml2js', attributes_callback_options).forEach(function (test) {
      it('attributes_callback_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, attributes_callback_options))).assertEqual(JSON.stringify(test.js));
      });
      if (test.js.a && test.js.a._attributes) {
        it('attributes_callback_should_provide_correct_arguments', 0, function () {
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js.a._attributes));
          expect(JSON.stringify(args)).assertContain(JSON.stringify(test.js));
        });
      }
    });

    var compact_true_options = {
      compact: true,
      doctypeFn: manipulate,
      instructionFn: manipulate,
      cdataFn: manipulate,
      commentFn: manipulate,
      textFn: manipulate
    };
    testItems('xml2js', compact_true_options).forEach(function (test) {
      it('compact_true_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_options2 = {
      compact: true,
      instructionNameFn: manipulate,
      elementNameFn: manipulate,
      attributeNameFn: manipulate,
      attributeValueFn: manipulate
    };
    testItems('xml2js', compact_true_options2).forEach(function (test) {
      it('compact_true2_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_options2))).assertEqual(JSON.stringify(test.js));
      });
    });
  })
}
