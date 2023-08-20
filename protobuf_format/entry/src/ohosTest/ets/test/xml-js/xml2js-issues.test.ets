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
import { describe, expect, it } from '@ohos/hypium'

export default function testingXml2jsIssue() {
  describe('TestingXml2jsIssue', function () {

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
      expect(JSON.stringify(convert.json2xml(issue_6_json, {
        compact: true, spaces: 4, fullTagEmptyElement: true
      }))).assertEqual(JSON.stringify(issue_6_xml));
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


    var issue_26_xml1 = '<title>Support &amp; resistance</title>';
    var issue_26_js1 = {
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
      var js_ = convert.xml2js(issue_26_xml1);
      expect(JSON.stringify(js_)).assertEqual(JSON.stringify(issue_26_js1));
      expect(convert.js2xml(js_)).assertEqual(issue_26_xml1);
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
      expect(JSON.stringify(convert.js2xml(js_))).assertEqual('"'+issue_29_xml+'"');
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

    var issue_41_xml1 =
      '<d:multistatus xmlns="DAV:">\n' +
      '  <response>\n' +
      '    <href>/</href>\n' +
      '        <propstat>\n' +
      '          <prop>\n' +
      '          <current-user-principal>\n' +
      '            <href>/principals/users/johndoe/</href>\n' +
      '          </current-user-principal>\n' +
      '          </prop>\n' +
      '      <status>HTTP/1.1 200 OK</status>\n' +
      '    </propstat>\n' +
      '  </response>\n' +
      '</d:multistatus>';
    var issue_41_xml2 =
      '<d:multistatus xmlns:d="DAV:">\n' +
      '  <d:response>\n' +
      '      <d:href>/</d:href>\n' +
      '      <d:propstat>\n' +
      '          <d:prop>\n' +
      '              <d:current-user-principal>\n' +
      '                  <d:href>/principals/users/johndoe/</d:href>\n' +
      '              </d:current-user-principal>\n' +
      '          </d:prop>\n' +
      '          <d:status>HTTP/1.1 200 OK</d:status>\n' +
      '      </d:propstat>\n' +
      '  </d:response>\n' +
      '</d:multistatus>';
    var issue_41_js1 = {
      "d:multistatus": {
        "_attributes": {
          "xmlns": "DAV:"
        },
        "response": {
          "href": {
            "_text": "/"
          },
          "propstat": {
            "prop": {
              "current-user-principal": {
                "href": {
                  "_text": "/principals/users/johndoe/"
                }
              }
            },
            "status": {
              "_text": "HTTP/1.1 200 OK"
            }
          }
        }
      }
    };
    var issue_41_js2 = {
      "d:multistatus": {
        "_attributes": {
          "xmlns:d": "DAV:"
        },
        "d:response": {
          "d:href": {
            "_text": "/"
          },
          "d:propstat": {
            "d:prop": {
              "d:current-user-principal": {
                "d:href": {
                  "_text": "/principals/users/johndoe/"
                }
              }
            },
            "d:status": {
              "_text": "HTTP/1.1 200 OK"
            }
          }
        }
      }
    };
    var issue_41_js = {
      "d:multistatus": {
        "_attributes": {
          "xmlns:d": "DAV:"
        },
        "DAV:response": {
          "DAV:href": {
            "_text": "/"
          },
          "DAV:propstat": {
            "DAV:prop": {
              "DAV:current-user-principal": {
                "DAV:href": {
                  "_text": "/principals/users/johndoe/"
                }
              }
            },
            "DAV:status": {
              "_text": "HTTP/1.1 200 OK"
            }
          }
        }
      }
    };

    it('issue_41_should_convert_without_resolving_namespace', 0, function () {
      expect(JSON.stringify(convert.xml2js(issue_41_xml1, {
        compact: true, resolveNamespace: false
      }))).assertEqual(JSON.stringify(issue_41_js1));
      expect(JSON.stringify(convert.xml2js(issue_41_xml2, {
        compact: true, resolveNamespace: false
      }))).assertEqual(JSON.stringify(issue_41_js2));
    });

    it('issue_41_should_convert_and_resolve_namespace', 0, function () {
      expect(JSON.stringify(convert.xml2js(issue_41_xml1, {
        compact: true, resolveNamespace: true
      }))).assertEqual(JSON.stringify(issue_41_js1));
    });

    var issue_26_xml2 = '<parser start="^\\s*?&lt;name&gt;regex&lt;/name&gt;$"/>';
    var issue_26_js_2 = {
      parser: {
        _attributes: {
          start: '^\\s*?<name>regex</name>$'
        }
      }
    };

    it('issue_26_should_xml_to_json_and_back_to_xml', 0, function () {
      expect(JSON.stringify(convert.xml2js(issue_26_xml2, {
        compact: true
      }))).assertEqual(JSON.stringify(issue_26_js_2));
      expect(convert.js2xml(issue_26_js_2, {
        compact: true, attributeValueFn: function (value) {
          return value.replace(/</g, '&lt;').replace(/>/g, '&gt;');
        }
      })).assertEqual(issue_26_xml2);
    });

    var issue_44_xml = '<material><font size="14"/></material><material><font size="14"/></material>';
    var issue_44_js = {
      "material": [{
        "font": {
          "_attributes": {
            "size": "14"
          }
        }
      }, {
        "font": {
          "_attributes": {
            "size": "14"
          }
        }
      }]
    };
    it('issue_44_should_json_to_xml_and_back_to_json', 0, function () {
      expect(JSON.stringify(convert.xml2json(issue_44_xml, {
        compact: true
      }))).assertEqual(JSON.stringify(JSON.stringify(issue_44_js)));
    });
  });
}