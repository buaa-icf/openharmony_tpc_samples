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
import { afterEach, beforeEach, describe, expect, it } from '@ohos/hypium'

export default function testing_js2xml_issue() {
  describe('Testing_js2xml_issue', function () {

    var issue_2_js = {
      _comment: ' Released under The MIT License ',
      snippet: {
        content: {
          _cdata: 'console.log($1)'
        },
        tabTrigger: {
          _text: 'log'
        },
        scope: {
          _text: 'source.js'
        }
      }
    };
    var issue_2_xml =
      '<!-- Released under The MIT License -->\n' +
      '<snippet>\n' +
      '\v<content><![CDATA[console.log($1)]]></content>\n' +
      '\v<tabTrigger>log</tabTrigger>\n' +
      '\v<scope>source.js</scope>\n' +
      '</snippet>';

    it('issue_2_should_output_cdata_and_text_unformatted', 0, function () {
      expect(convert.js2xml(issue_2_js, {
        compact: true
      })).assertEqual(issue_2_xml.replace(/\v|\n/g, ''));
    });
    it('issue_2_should_output_cdata_and_text_formatted', 0, function () {
      expect(convert.js2xml(issue_2_js, {
        compact: true, spaces: 4
      })).assertEqual(issue_2_xml.replace(/\v/g, '    '));
    });

    var issue_5_js1 = {
      a: {
        b: {
          _text: 'foo bar'
        }
      }
    };
    var issue_5_js2 = {
      elements: [{
        type: 'element',
        name: 'a',
        elements: [{
          type: 'element',
          name: 'b',
          elements: [{
            type: 'text',
            text: 'foo bar'
          }]
        }]
      }]
    };
    var issue_5_xml = '<a>\n' +
    '\v<b>foo bar</b>\n' +
    '</a>';
    it('issue_5_should_output_xml_of_compact_js_input', 0, function () {
      expect(convert.js2xml(issue_5_js1, {
        compact: true, spaces: 4
      })).assertEqual(issue_5_xml.replace(/\v/g, '    '));
    });
    it('issue_5_should_output_xml_of_extended_js_input', 0, function () {
      expect(convert.js2xml(issue_5_js2, {
        compact: false, spaces: 4
      })).assertEqual(issue_5_xml.replace(/\v/g, '    '));
    });

    var issue_13_json = {
      "_declaration": {
        "_attributes": {
          "version": "1.0",
          "encoding": "utf-8"
        }
      },
      "ServiceExceptionReport": {
        "_attributes": {
          "version": "1.1.1"
        },
        "_doctype": 'ServiceExceptionReport SYSTEM "http://schemas.opengis.net/wms/1.1.1/exception_1_1_1.dtd"',
        "ServiceException": {
          "_text": "foo"
        }
      }
    };
    var issue_13_xml =
      '<?xml version="1.0" encoding="utf-8"?>\n' +
      '<ServiceExceptionReport version="1.1.1">\n' +
      '  <!DOCTYPE ServiceExceptionReport SYSTEM "http://schemas.opengis.net/wms/1.1.1/exception_1_1_1.dtd">\n' +
      '  <ServiceException>foo</ServiceException>\n' +
      '</ServiceExceptionReport>';
    it('issue_13_should_output_as_expected_xml', 0, function () {
      expect(convert.js2xml(issue_13_json, {
        compact: true, spaces: 2
      })).assertEqual(issue_13_xml);
    });

    var issue_14_js = {
      _declaration: {
        _attributes: {
          version: '1.0'
        }
      },
      group: {
        name: {
          _cdata: 'An example name'
        }
      }
    };
    var issue_14_xml = '<?xml version="1.0"?>\n' +
    '<group>\n' +
    '\v<name><![CDATA[An example name]]></name>\n' +
    '</group>';
    it('issue_14_should_output_cdata_without_proceeding_indentation', 0, function () {
      expect(convert.js2xml(issue_14_js, {
        compact: true, spaces: 4, fullTagEmptyElement: true
      })).assertEqual(issue_14_xml.replace(/\v/g, '    '));
    });

    var issue_14_js2 = {
      declaration: {
        attributes: {
          version: '1.0'
        }
      },
      elements: [{
        type: 'element',
        name: 'group',
        elements: [{
          type: 'element',
          name: 'name',
          elements: [{
            type: 'text',
            text: 'The url '
          }, {
            type: 'cdata',
            cdata: 'http://www.test.com'
          }, {
            type: 'text',
            text: ' and name '
          }, {
            type: 'cdata',
            cdata: 'examplename'
          }, {
            type: 'text',
            text: ' are wrapped'
          }]
        }]
      }]
    };
    var issue_14_xml2 = '<?xml version="1.0"?>\n' +
    '<group>\n' +
    '\v<name>The url <![CDATA[http://www.test.com]]> and name <![CDATA[examplename]]> are wrapped</name>\n' +
    '</group>';
    it('issue_14_2_should_output_cdata_without_proceeding_indentation', 0, function () {
      expect(convert.js2xml(issue_14_js2, {
        compact: false, spaces: 4
      })).assertEqual(issue_14_xml2.replace(/\v/g, '    '));
    });

    var issue_20_js = {
      request: {
        user: {
          _text: 'username'
        },
        pass: {
          _text: 'password'
        },
        numbers: {
          number: [
            {
              _text: 1
            },
            {
              _text: 2
            }
          ]
        }
      }
    };
    var issue_20_xml =
      '<request>\n' +
      '\v<user>username</user>\n' +
      '\v<pass>password</pass>\n' +
      '\v<numbers>\n' +
      '\v\v<number>1</number>\n' +
      '\v\v<number>2</number>\n' +
      '\v</numbers>\n' +
      '</request>';
    it('issue_20_should_convert_javascript_object_to_xml_correctly', 0, function () {
      expect(convert.js2xml(issue_20_js, {
        spaces: 4, compact: true
      })).assertEqual(issue_20_xml.replace(/\v/g, '    '));
      // expect(convert.xml2js(xml, {compact: true, nativeType: true})).toEqual(js);
    });

    var issue_21_js = {
      "vertical": {
        "_attributes": {
          "-display_name": "Exercise"
        },
        "html": {
          "_attributes": {
            "-url_name": "12345"
          }
        },
        "lti_consumer": {
          "_attributes": {
            "-url_name": "12345",
            "-xblock-family": "xblock.v1",
            "-accept_grades_past_due": "false",
            "-weight": "14.0",
            "-has_score": "true",
            "-display_name": "Exercise",
            "-ask_to_send_username": "true",
            "-ask_to_send_email": "true",
            "-button_text": "Launch Exercise",
            "-custom_parameters": "none",
            "-lti_id": "id",
            "-launch_target": "new_window",
            "-launch_url": "url"
          }
        }
      }
    };
    var issue_21_xml =
      '<vertical -display_name="Exercise">\n' +
      '\v<html -url_name="12345"/>\n' +
      '\v<lti_consumer -url_name="12345" -xblock-family="xblock.v1" -accept_grades_past_due="false" -weight="14.0" -has_score="true" -display_name="Exercise" -ask_to_send_username="true" -ask_to_send_email="true" -button_text="Launch Exercise" -custom_parameters="none" -lti_id="id" -launch_target="new_window" -launch_url="url"/>\n' +
      '</vertical>';
    it('issue_21_should_convert_javascript_object_to_xml_correctly', 0, function () {
      expect(convert.js2xml(issue_21_js, {
        spaces: 4, compact: true
      })).assertEqual(issue_21_xml.replace(/\v/g, '    '));
    });

    var issue_28_js = {
      a: {
        _attributes: {
          num: 123
        }
      }
    };
    var issue_28_xml = '<a num="123"/>';
    it('issue_28_should_process_attribute_number_without_issue', 0, function () {
      expect(convert.js2xml(issue_28_js, {
        compact: true
      })).assertEqual(issue_28_xml);
    });

    var issue_30_js = {
      a: {
        _text: 'Hi There'
      }
    };
    var issue_30_xml = '<a>Hi There</a>';
    it('issue_30_should_convert_js_object_to_xml', 0, function () {
      expect(convert.js2xml(issue_30_js, {
        spaces: 3, fullTagEmptyElement: true, compact: true
      })).assertEqual(issue_30_xml);
    });

    var issue_31_js = {
      parent: {
        _attributes: {
          bar: 1,
          baz: 'hello'
        },
        child: {
          _attributes: {
            attr1: 'a',
            attr2: 'b'
          }
        }
      }
    };
    var issue_31_xml =
      '<parent\n' +
      '\vbar=1\n' +
      '\vbaz="hello"\n' +
      '>\n' +
      '\v<child\n' +
      '\v\vattr1="a"\n' +
      '\v\vattr2="b"\n' +
      '\v/>\n' +
      '</parent>';
    it('issue_31_should_be_able_to_indent_attributes', 0, function () {
      expect(convert.js2xml(issue_31_js, {
        indentAttributes: true, spaces: 2, compact: true
      })).assertEqual(issue_31_xml.replace(/\v/g, '  ').replace('=1', '="1"'));
    });
    it('issue_31_should_be_able_to_indent_attributes_and_no_quotes_for_native_attributes', 0, function () {
      expect(convert.js2xml(issue_31_js, {
        indentAttributes: true, spaces: 2, compact: true, noQuotesForNativeAttributes: true
      })).assertEqual(issue_31_xml.replace(/\v/g, '  '));
    });

    var issue_32_js = {
      example: 'value'
    };
    var issue_32_xml = '<example>value</example>';
    it('issue_32_should_convert_element_text_without__text_property', 0, function () {
      expect(convert.js2xml(issue_32_js, {
        compact: true
      })).assertEqual(issue_32_xml);
    });

    var issue_59_js = {
      textless: {
        calling_offer_code: '',
        mailing_code: '',
        vcpi: ''
      },
    };
    var issue_59_xml =
      '<textless>\n' +
      '  <calling_offer_code/>\n' +
      '  <mailing_code/>\n' +
      '  <vcpi/>\n' +
      '</textless>';
    it('issue_59_should_not_create_full_tag_for_empty_elements', 0, function () {
      var result = convert.js2xml(issue_59_js, {
        compact: true, spaces: 2, fullTagEmptyElement: false
      });
      expect(result).assertEqual(issue_59_xml);
    });


    var js = {
      container: {
        cdata_section: {
          _cdata: '<p><![CDATA[aaaa, one <bbbb>cccc</bbbb>]]></p>',
        },
      },
    };
    var xml =
      '<container>\n' +
      '  <cdata_section><![CDATA[<p><![CDATA[aaaa, one <bbbb>cccc</bbbb>]]]]><![CDATA[></p>]]></cdata_section>\n' +
      '</container>';
    it('should_handle_nested_CDATA_sections', 0, function () {
      expect(convert.js2xml(js, {
        compact: true, spaces: 2, fullTagEmptyElement: false
      })).assertEqual(xml);
    });
  });
}