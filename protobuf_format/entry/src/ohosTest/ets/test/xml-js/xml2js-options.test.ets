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

export default function testingXml2jsOptions() {
  describe('TestingXml2jsOptions', function () {

    var options = {};
    testItems('xml2js', options).forEach(function (test) {
      it('no_options_supplied' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_default_options = {
      singleLine: false,
      compact: false,
      trim: false,
      sanitize: false,
      nativeType: false,
      alwaysChildren: false,
      addParent: false
    };
    testItems('xml2js', compact_false_default_options).forEach(function (test) {
      it('compact_false_default_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_default_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_options = {
      compact: false
    };
    testItems('xml2js', compact_false_options).forEach(function (test) {
      it('compact_false_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_trim_true_options = {
      compact: false, trim: true
    };
    testItems('xml2js', compact_false_trim_true_options).forEach(function (test) {
      it('compact_false_trim_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_trim_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_sanitize_true_options = {
      compact: false, sanitize: true
    };
    testItems('xml2js', compact_false_sanitize_true_options).forEach(function (test) {
      it('compact_false_sanitize_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_sanitize_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_nativeType_true_options = {
      compact: false, nativeType: true
    };
    testItems('xml2js', compact_false_nativeType_true_options).forEach(function (test) {
      it('compact_false_nativeType_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_nativeType_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_nativeTypeAttributes_true_options = {
      compact: false, nativeTypeAttributes: true
    };
    testItems('xml2js', compact_false_nativeTypeAttributes_true_options).forEach(function (test) {
      it('compact_false_nativeTypeAttributes_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_nativeTypeAttributes_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_alwaysChildren_true_options = {
      compact: false, alwaysChildren: true
    };
    testItems('xml2js', compact_false_alwaysChildren_true_options).forEach(function (test) {
      it('compact_false_alwaysChildren_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_alwaysChildren_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_addParent_true_options = {
      compact: false, addParent: true
    };
    testItems('xml2js', compact_false_addParent_true_options).forEach(function (test) {
      it('compact_false_addParent_true_options_' + test.desc, 0, function () {
        expect(!!(convert.xml2js(test.xml, compact_false_addParent_true_options))).assertTrue();
      });
    });


    var compact_false_ignoreText_true_options = {
      compact: false, ignoreText: true
    };
    testItems('xml2js', compact_false_ignoreText_true_options).forEach(function (test) {
      it('compact_false_ignoreText_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_ignoreText_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_ignoreComment_true_options = {
      compact: false, ignoreComment: true
    };
    testItems('xml2js', compact_false_ignoreComment_true_options).forEach(function (test) {
      it('compact_false_ignoreComment_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_ignoreComment_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_ignoreCdata_true_options = {
      compact: false, ignoreCdata: true
    };
    testItems('xml2js', compact_false_ignoreCdata_true_options).forEach(function (test) {
      it('compact_false_ignoreCdata_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_ignoreCdata_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_ignoreDoctype_true_options = {
      compact: false, ignoreDoctype: true
    };
    testItems('xml2js', compact_false_ignoreDoctype_true_options).forEach(function (test) {
      it('compact_false_ignoreDoctype_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_ignoreDoctype_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_ignoreDeclaration_true_options = {
      compact: false, ignoreDeclaration: true
    };
    testItems('xml2js', compact_false_ignoreDeclaration_true_options).forEach(function (test) {
      it('compact_false_ignoreDeclaration_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_ignoreDeclaration_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_false_ignoreInstruction_true_options = {
      compact: false, ignoreInstruction: true
    };
    testItems('xml2js', compact_false_ignoreInstruction_true_options).forEach(function (test) {
      it('compact_false_ignoreInstruction_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_false_ignoreInstruction_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_default_options = {
      compact: true,
      trim: false,
      sanitize: false,
      nativeType: false,
      alwaysChildren: false,
      addParent: false
    };
    testItems('xml2js', compact_true_default_options).forEach(function (test) {
      it('compact_true_default_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_default_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_options = {
      compact: true
    };
    testItems('xml2js', compact_true_options).forEach(function (test) {
      it('compact_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_trim_true_options = {
      compact: true, trim: true
    };
    testItems('xml2js', compact_true_trim_true_options).forEach(function (test) {
      it('compact_true_trim_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_trim_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_sanitize_true_options = {
      compact: true, sanitize: true
    };
    testItems('xml2js', compact_true_sanitize_true_options).forEach(function (test) {
      it('compact_true_sanitize_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_sanitize_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_alwaysArray_true_options = {
      compact: true, alwaysArray: true
    };
    testItems('xml2js', compact_true_alwaysArray_true_options).forEach(function (test) {
      it('compact_true_alwaysArray_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_alwaysArray_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_alwaysArray_options = {
      compact: true, alwaysArray: ['a', 'c']
    };
    testItems('xml2js', compact_true_alwaysArray_options).forEach(function (test) {
      it('compact_true_alwaysArray_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_alwaysArray_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_addParent_true_options = {
      compact: true, addParent: true
    };
    testItems('xml2js', compact_true_addParent_true_options).forEach(function (test) {
      it('compact_true_addParent_true_options_' + test.desc, 0, function () {
        expect(!!convert.xml2js(test.xml, compact_true_addParent_true_options)).assertTrue();
      });
    });

    var compact_true_ignoreText_true_options = {
      compact: true, ignoreText: true
    };
    testItems('xml2js', compact_true_ignoreText_true_options).forEach(function (test) {
      it('compact_true_ignoreText_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_ignoreText_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });


    var compact_true_ignoreComment_true_options = {
      compact: true, ignoreComment: true
    };
    testItems('xml2js', compact_true_ignoreComment_true_options).forEach(function (test) {
      it('compact_true_ignoreComment_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_ignoreComment_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_ignoreCdata_true_options = {
      compact: true, ignoreCdata: true
    };
    testItems('xml2js', compact_true_ignoreCdata_true_options).forEach(function (test) {
      it('compact_true_ignoreCdata_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_ignoreCdata_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_ignoreDoctype_true_options = {
      compact: true, ignoreDoctype: true
    };
    testItems('xml2js', compact_true_ignoreDoctype_true_options).forEach(function (test) {
      it('compact_true_ignoreDoctype_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_ignoreDoctype_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_ignoreDeclaration_true_options = {
      compact: true, ignoreDeclaration: true
    };
    testItems('xml2js', compact_true_ignoreDeclaration_true_options).forEach(function (test) {
      it('compact_true_ignoreDeclaration_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_ignoreDeclaration_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_ignoreInstruction_true_options = {
      compact: true, ignoreInstruction: true
    };
    testItems('xml2js', compact_true_ignoreInstruction_true_options).forEach(function (test) {
      it('compact_true_ignoreInstruction_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, compact_true_ignoreInstruction_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var varying_spaces_options = {};
    testItems('xml2js', varying_spaces_options).forEach(function (test) {
      it('varying_spaces_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, varying_spaces_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var varying_spaces_true_options = {
      spaces: true
    };
    testItems('xml2js', varying_spaces_true_options).forEach(function (test) {
      it('varying_spaces_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, varying_spaces_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var varying_spaces2_options = {
      spaces: 2
    };
    testItems('xml2js', varying_spaces2_options).forEach(function (test) {
      it('varying_spaces2_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, varying_spaces2_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var varying_spaces4_options = {
      spaces: 4
    };
    testItems('xml2js', varying_spaces4_options).forEach(function (test) {
      it('varying_spaces4_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, varying_spaces4_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var varying_spaces_whitespace_options = {
      spaces: '  '
    };
    testItems('xml2js', varying_spaces_whitespace_options).forEach(function (test) {
      it('varying_spaces_whitespace_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, varying_spaces_whitespace_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var varying_spaces_t_options = {
      spaces: '\t'
    };
    testItems('xml2js', varying_spaces_t_options).forEach(function (test) {
      it('varying_spaces_t_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, varying_spaces_t_options))).assertEqual(JSON.stringify(test.js));
      });
    });


    var various_trim_true_options = {
      trim: true
    };
    testItems('xml2js', various_trim_true_options).forEach(function (test) {
      it('various_trim_true_options_' + test.desc, 0, function () {
        expect(JSON.stringify(convert.xml2js(test.xml, various_trim_true_options))).assertEqual(JSON.stringify(test.js));
      });
    });

    var various_nativeType_true_options = {
      nativeType: true
    };

    it('various_nativeType_true_options_parse_number', 0, function () {
      expect(JSON.stringify(convert.xml2js('<a>123</a>', various_nativeType_true_options))).assertEqual(JSON.stringify({
        "elements": [{
          "type": "element", "name": "a", "elements": [{
            "type": "text", "text": 123
          }]
        }]
      }));
    });
    it('various_nativeType_true_options_parse_true', 0, function () {
      expect(JSON.stringify(convert.xml2js('<a>true</a>', various_nativeType_true_options))).assertEqual(JSON.stringify({
        "elements": [{
          "type": "element", "name": "a", "elements": [{
            "type": "text", "text": true
          }]
        }]
      }));
    });
    it('various_nativeType_true_options_parse_false', 0, function () {
      expect(JSON.stringify(convert.xml2js('<a>false</a>', various_nativeType_true_options))).assertEqual(JSON.stringify({
        "elements": [{
          "type": "element", "name": "a", "elements": [{
            "type": "text", "text": false
          }]
        }]
      }));
    });

    var various_nativeTypeAttributes_true_options = {
      nativeTypeAttributes: true
    };

    it('various_nativeTypeAttributes_true_options_parse_number', 0, function () {
      expect(JSON.stringify(convert.xml2js('<a data-value="123"></a>', various_nativeTypeAttributes_true_options))).assertEqual(JSON.stringify({
        "elements": [{
          "type": "element", "name": "a", "attributes": {
            "data-value": 123
          }
        }]
      }));
    });
    it('various_nativeTypeAttributes_true_options_parse_true', 0, function () {
      expect(JSON.stringify(convert.xml2js('<a data-value="true"></a>', various_nativeTypeAttributes_true_options))).assertEqual(JSON.stringify({
        "elements": [{
          "type": "element", "name": "a", "attributes": {
            "data-value": true
          }
        }]
      }));
    });
    it('various_nativeTypeAttributes_true_options_parse_false', 0, function () {
      expect(JSON.stringify(convert.xml2js('<a data-value="false"></a>', various_nativeTypeAttributes_true_options))).assertEqual(JSON.stringify({
        "elements": [{
          "type": "element", "name": "a", "attributes": {
            "data-value": false
          }
        }]
      }));
    });

    var various_instructionHasAttributes_true_options = {
      compact: true, instructionHasAttributes: true
    };

    it('various_instructionHasAttributes_true_options_Parse_attributes_in_processing_instruction', 0, function () {
      expect(JSON.stringify(convert.xml2js('<?go to="there"?>', various_instructionHasAttributes_true_options))).assertEqual(JSON.stringify({
        "_instruction": {
          "go": {
            "_attributes": {
              "to": "there"
            }
          }
        }
      }));
    });

    it('various_instructionHasAttributes_true_options_parse_attributes_in_processing_instruction', 0, function () {
      expect(JSON.stringify(convert.xml2js('<?go to="there"?>', {
        instructionHasAttributes: true
      }))).assertEqual(JSON.stringify({
        "elements": [{
          "type": "instruction", "name": "go", "attributes": {
            "to": "there"
          }
        }]
      }));
    });

    var xml2json_default_options = {};
    testItems('xml2js', xml2json_default_options).forEach(function (test) {
      it('xml2json_default_options_' + test.desc, 0, function () {
        expect(convert.xml2json(test.xml, xml2json_default_options)).assertEqual(JSON.stringify(test.js));
      });
    });

    var compact_true_addParent_true_options2 = {
      onlyItem: 6, compact: true, addParent: true
    };
    testItems('xml2js', compact_true_addParent_true_options2).forEach(function (test) {
      it('compact_true_addParent_true_options2_' + test.desc, 0, function () {
        expect(convert.xml2json(test.xml, compact_true_addParent_true_options2))
          .assertEqual(JSON.stringify(test.js, function (k, v) {
            return k === '_parent' ? '_' : v;
          }));
      });
    });

    var issue_3_xml =
      '<?xml version="1.0" encoding="utf-8"?>\n' +
      '<dp:ListServicesReply ReturnCode="0" xmlns:dp="http://www.cisco.com/vtg/diagnosticportal">\n' +
      '  <dp:Schema Version="1.0" />\n' +
      '  <dp:ServiceList>\n' +
      '    <dp:Service Name="Cisco ICM usgd1 LoggerA" Description="Provides Call Logging services for Instance usgd1" Status="Running" StartupType="Auto" LogOnAs="****" />\n' +
      '    <dp:Service Name="Cisco ICM Diagnostic Framework" Description="Provides a web-based diagnostic service for Cisco Unified ICM, Contact Center Enterprise application." Status="Running" StartupType="Auto" LogOnAs="LocalSystem" />\n' +
      '  </dp:ServiceList>\n' +
      '</dp:ListServicesReply>';
    var issue_3_json = {
      "_declaration": {
        "_attributes": {
          "version": "1.0",
          "encoding": "utf-8"
        }
      },
      "dp:ListServicesReply": {
        "_attributes": {
          "ReturnCode": "0",
          "xmlns:dp": "http://www.cisco.com/vtg/diagnosticportal"
        },
        "dp:Schema": {
          "_attributes": {
            "Version": "1.0"
          }
        },
        "dp:ServiceList": {
          "dp:Service": [
            {
              "_attributes": {
                "Name": "Cisco ICM usgd1 LoggerA",
                "Description": "Provides Call Logging services for Instance usgd1",
                "Status": "Running",
                "StartupType": "Auto",
                "LogOnAs": "****"
              }
            },
            {
              "_attributes": {
                "Name": "Cisco ICM Diagnostic Framework",
                "Description": "Provides a web-based diagnostic service for Cisco Unified ICM, Contact Center Enterprise application.",
                "Status": "Running",
                "StartupType": "Auto",
                "LogOnAs": "LocalSystem"
              }
            }
          ]
        }
      }
    };

    it('issue_3_should_output_as_expected_json', 0, function () {
      expect(convert.xml2json(issue_3_xml, {
        compact: true
      })).assertEqual(JSON.stringify(issue_3_json));
    });

    var issue_6_xml =
      '<ZohoCreator>\n' +
      '    <applicationslist>\n' +
      '        <application name="testapp">\n' +
      '            <formlist>\n' +
      '                <form name="Untitled_Form">\n' +
      '                    <add>\n' +
      '                        <field name="Subform_Single_Line">\n' +
      '                            <value>BEUHBALUGU</value>\n' +
      '                        </field>\n' +
      '                    </add>\n' +
      '                </form>\n' +
      '                <form name="Untitled_Form">\n' +
      '                    <add>\n' +
      '                        <field name="Subform_Single_Line">\n' +
      '                            <value>IF YOU CAN SEE THIS YOU DESERVE THE SUCC</value>\n' +
      '                        </field>\n' +
      '                    </add>\n' +
      '                </form>\n' +
      '            </formlist>\n' +
      '        </application>\n' +
      '        <application name="derp">\n' +
      '            <formlist></formlist>\n' +
      '        </application>\n' +
      '    </applicationslist>\n' +
      '</ZohoCreator>';

    var issue_6_json = convert.xml2json(issue_6_xml, {
      compact: true, spaces: 4
    });

    it('issue_6_should_output_json_and_reverse_it_back_to_xml', 0, function () {
      expect(convert.json2xml(issue_6_json, {
        compact: true, spaces: 4, fullTagEmptyElement: true
      })).assertEqual(issue_6_xml);
    });

    var issue_13_xml = '<!DOCTYPE svc_init SYSTEM "MLP_SVC_INIT_300.DTD" [<!ENTITY % extension SYSTEM "PIF_EXTENSION_100.DTD">%extension;]>';
    var issue_13_json = {
      "_doctype": "svc_init SYSTEM \"MLP_SVC_INIT_300.DTD\" [<!ENTITY % extension SYSTEM \"PIF_EXTENSION_100.DTD\">%extension;]"
    };

    it('issue_13_should_output_as_expected_json', 0, function () {
      expect(JSON.stringify(convert.xml2js(issue_13_xml, {
        compact: true
      }))).assertEqual(JSON.stringify(issue_13_json));
    });

    var issue_26_xml =
      '<?xml version="1.0" encoding="UTF-8"?>\n' +
      '<note>\n' +
      '\v<to>xml-js</to>\n' +
      '\v<from>ACraig</from>\n' +
      '\v<heading>Min Example</heading>\n' +
      '\v<body>Here are some characters that get sanitized: " \'</body>\n' +
      '</note>';
    var issue_26_js = {
      "_declaration": {
        "_attributes": {
          "version": "1.0",
          "encoding": "UTF-8"
        }
      },
      "note": {
        "to": {
          "_text": "xml-js"
        },
        "from": {
          "_text": "ACraig"
        },
        "heading": {
          "_text": "Min Example"
        },
        "body": {
          "_text": "Here are some characters that get sanitized: \" '"
        }
      }
    };

    it('issue_26_should_convert_xml_object_to_js_and_back_to_xml_correctly', 0, function () {
      issue_26_xml = issue_26_xml.replace(/\v/g, '  ');
      var js_ = convert.xml2js(issue_26_xml, {
        compact: true
      });
      expect(JSON.stringify(js_)).assertEqual(JSON.stringify(issue_26_js));
      expect(convert.js2xml(js_, {
        spaces: 2, compact: true
      })).assertEqual(issue_26_xml);
    });

    var issue_26_xml2 = '<title>Support &amp; resistance</title>';
    var issue_26_js2 = {
      elements: [{
        type: 'element',
        name: 'title',
        elements: [{
          type: 'text',
          text: 'Support & resistance'
        }]
      }]
    };

    it('issue_26_2_should_convert_xml_object_to_js_and_back_to_xml_correctly', 0, function () {
      var js_ = convert.xml2js(issue_26_xml2);
      expect(JSON.stringify(js_)).assertEqual(JSON.stringify(issue_26_js2));
      expect(convert.js2xml(js_)).assertEqual(issue_26_xml2);
    });

    var issue_29_xml = '<outer> This is <inner> some</inner> <inner>Text </inner> </outer>';
    var issue_29_js = {
      elements: [{
        type: 'element',
        name: 'outer',
        elements: [{
          type: 'text',
          text: ' This is '
        }, {
          type: 'element',
          name: 'inner',
          elements: [{
            type: 'text',
            text: ' some'
          }]
        }, {
          type: 'text',
          text: ' '
        }, {
          type: 'element',
          name: 'inner',
          elements: [{
            type: 'text',
            text: 'Text '
          }]
        }, {
          type: 'text',
          text: ' '
        }]
      }]
    };

    it('issue_29_should_convert_xml_object_to_js_and_back_to_xml_correctly', 0, function () {
      var js_ = convert.xml2js(issue_29_xml, {
        captureSpacesBetweenElements: true
      });
      expect(JSON.stringify(js_)).assertEqual(JSON.stringify(issue_29_js));
      expect(convert.js2xml(js_)).assertEqual(issue_29_xml);
    });
  });

  var issue_34_xml = '<?xml version=\'1.0\' encoding=\'UTF-8\'?>';
  var issue_34_js = {
    declaration: {
      attributes: {
        version: '1.0',
        encoding: 'UTF-8'
      }
    }
  };

  it('issue_34_should_accept_XML_declarations_that_use_single_quotes', 0, function () {
    expect(JSON.stringify(convert.xml2js(issue_34_xml))).assertEqual(JSON.stringify(issue_34_js));
  });

}