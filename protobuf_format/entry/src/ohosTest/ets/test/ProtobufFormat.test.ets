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
import ProtoBufFormat from '@ohos/protobuf_format'
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'

export default function protobufFormatTest() {
  const protoStr = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
  const protoJson = `
      {
        "package": "com.user",
        "syntax": "proto3",
        "messages": [
          {
            "name": "UserLoginResponse",
            "fields": [
              {
                "rule": "optional",
                "type": "string",
                "name": "sessionId",
                "id": 1,
              },
              {
                "rule": "optional",
                "type": "string",
                "name": "userPrivilege",
                "id": 2,
              },
              {
                "rule": "optional",
                "type": "bool",
                "name": "isTokenType",
                "id": 3
              },
              {
                "rule": "optional",
                "type": "string",
                "name": "formatTimestamp",
                "id": 4,
              }
            ]
          }
        ]
      }`;
  const innerProto = `
       syntax = "proto3";
       package js;

       message ResultResponse{
          message Result{
            string url = 1;
            string title = 2;
            repeated string spinner = 3;
          }
          repeated Result result = 4;
       }
    `;
  const personProto = `
      syntax = "proto3";
      package tutorial;

      message Person{
        string name = 1;
        fixed64 id = 2;
        string email = 3;

        enum PhoneType {
          MOBILE = 0;
          HOME = 1;
          WORK = 2;
        }

        message PhoneNumber{
          string number = 1;
          PhoneType type = 2;
        }

        repeated PhoneNumber phones = 4;
      }
      `;
  describe('ProtobufFormatTest', function () {
    it('protobuf_load_proto_str', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      let UserLoginResponse = root.build("com.user.UserLoginResponse");
      const userLogin = {
        sessionId: "loadProtoString",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      }

      let msg = new UserLoginResponse(userLogin);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(userLogin));
    })

    it('protobuf_load_json_str', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadJson(protoJson, null, 'user.proto');
      let UserLoginResponse = root.build("com.user.UserLoginResponse");
      const userLogin = {
        sessionId: "loadProtoJson",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      }

      let msg = new UserLoginResponse(userLogin);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(userLogin));
    })

    it('protobuf_load_proto_file', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProtoFile('userproto.proto', null, null, globalThis.resourceManager);
      let UserLoginResponse = root.build("com.user.UserLoginResponse");
      const userLogin = {
        sessionId: "loadProtoFile",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      }

      let msg = new UserLoginResponse(userLogin);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(userLogin));
    })

    it('protobuf_load_json_file', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadJsonFile('user.json', null, null, globalThis.resourceManager);
      let UserLoginResponse = root.build("com.user.UserLoginResponse");
      const userLogin = {
        sessionId: "loadJsonFile",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      }

      let msg = new UserLoginResponse(userLogin);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(userLogin));
    })

    it('protobuf_lookup_message', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      let message = root.lookup("com.user.UserLoginResponse");
      let UserLoginResponse = message.build();
      const userLogin = {
        sessionId: "lookupMessage",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      }

      let msg = new UserLoginResponse(userLogin);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(userLogin));
    })

    it('format_message_to_json_null', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      let UserLoginResponse = root.build("com.user.UserLoginResponse");
      let json = ProtoBufFormat.Format.messageToJson(UserLoginResponse);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.messageToJson('')
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.messageToJson(null);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.messageToJson(undefined);
      expect(json).assertEqual(null);
    })

    it('format_json_to_message_null', 0, async function () {
      let root = ProtoBufFormat.Protobuf.newBuilder();
      let json = ProtoBufFormat.Format.jsonToMessage(root, "com.user.UserLoginResponse", '');
      expect(json).assertEqual(null);
      root = ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      json = ProtoBufFormat.Format.jsonToMessage(root, "com.user.UserLoginResponse", '');
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.jsonToMessage(root, "com.user.UserLoginResponse1", '');
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.jsonToMessage(root, "com.user.UserLoginResponse", null);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.jsonToMessage(root, null, null);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.jsonToMessage(root, undefined, null);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.jsonToMessage(root, undefined, undefined);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.jsonToMessage(null, undefined, undefined);
      expect(json).assertEqual(null);
    })

    it('format_message_to_xml_null', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      let UserLoginResponse = root.build("com.user.UserLoginResponse");
      let json = ProtoBufFormat.Format.messageToXml(UserLoginResponse);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.messageToXml('')
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.messageToXml(null);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.messageToXml(undefined);
      expect(json).assertEqual(null);
    })

    it('format_xml_to_message_null', 0, async function () {
      let root = ProtoBufFormat.Protobuf.newBuilder();
      let json = ProtoBufFormat.Format.xmlToMessage(root, "com.user.UserLoginResponse", '');
      expect(json).assertEqual(null);
      root = ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      json = ProtoBufFormat.Format.xmlToMessage(root, "com.user.UserLoginResponse", '');
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.xmlToMessage(root, "com.user.UserLoginResponse1", '');
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.xmlToMessage(root, "com.user.UserLoginResponse", null);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.xmlToMessage(root, null, null);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.xmlToMessage(root, undefined, null);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.xmlToMessage(root, undefined, undefined);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.xmlToMessage(null, undefined, undefined);
      expect(json).assertEqual(null);
    })

    it('format_message_to_html_null', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      let UserLoginResponse = root.build("com.user.UserLoginResponse");
      let json = ProtoBufFormat.Format.messageToHtml(UserLoginResponse);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.messageToHtml('')
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.messageToHtml(null);
      expect(json).assertEqual(null);
      json = ProtoBufFormat.Format.messageToHtml(undefined);
      expect(json).assertEqual(null);
    })

    it('format_user_message_to_json', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      let UserLoginResponse = root.build("com.user.UserLoginResponse");
      const userLogin = {
        sessionId: "message_to_json",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };
      let msg = new UserLoginResponse(userLogin);
      let json = ProtoBufFormat.Format.messageToJson(msg);
      let jsonResult = '{"sessionId": "message_to_json","userPrivilege": "John123","isTokenType": false,"formatTimestamp": "12342222"}';
      expect(json).assertEqual(jsonResult);
    })

    it('format_user_json_to_message', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      const userLogin = {
        sessionId: "json_to_message",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };
      let msg = ProtoBufFormat.Format.jsonToMessage(root, 'com.user.UserLoginResponse', userLogin);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(userLogin));
    })

    it('format_user_message_to_xml_string_not_null', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      let UserLoginResponse = root.build("com.user.UserLoginResponse");
      const userLogin = {
        sessionId: "message_to_xml",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };
      let msg = new UserLoginResponse(userLogin);
      let xml = ProtoBufFormat.Format.messageToXml(msg);
      let xmlResult = '<UserLoginResponse><sessionId>message_to_xml</sessionId><userPrivilege>John123</userPrivilege><isTokenType>false</isTokenType><formatTimestamp>12342222</formatTimestamp></UserLoginResponse>';
      expect(xml).assertEqual(xmlResult);
    })

    it('format_user_message_to_xml_string_null', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      let UserLoginResponse = root.build("com.user.UserLoginResponse");
      const userLogin = {
        sessionId: "message_to_xml",
        userPrivilege: "",
        isTokenType: false,
        formatTimestamp: "12342222"
      };
      let msg = new UserLoginResponse(userLogin);
      let xml = ProtoBufFormat.Format.messageToXml(msg);
      let xmlResult = '<UserLoginResponse><sessionId>message_to_xml</sessionId><userPrivilege/><isTokenType>false</isTokenType><formatTimestamp>12342222</formatTimestamp></UserLoginResponse>';
      expect(xml).assertEqual(xmlResult);
    })

    it('format_user_xml_to_message', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      const userLogin = {
        sessionId: "xml_to_message",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };

      let xml = '<UserLoginResponse><sessionId>xml_to_message</sessionId><userPrivilege>John123</userPrivilege><isTokenType>false</isTokenType><formatTimestamp>12342222</formatTimestamp></UserLoginResponse>';
      let msg = ProtoBufFormat.Format.xmlToMessage(root, 'com.user.UserLoginResponse', xml);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(userLogin));
    })

    it('format_user_message_to_html', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');
      let UserLoginResponse = root.build("com.user.UserLoginResponse");
      const userLogin = {
        sessionId: "message_to_html",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };
      let msg = new UserLoginResponse(userLogin);
      let html = ProtoBufFormat.Format.messageToHtml(msg);
      let result = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>.com.user.UserLoginResponse</title></head><body><div style="color: black; font-size: 14px; font-family: sans-serif; font-weight: bolder; margin-bottom: 10px;">message : .com.user.UserLoginResponse</div><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">sessionId</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"message_to_html"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">userPrivilege</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"John123"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">isTokenType</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">false</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">formatTimestamp</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"12342222"</span><br/></body></html>';
      expect(html).assertEqual(result);
    })

    it('format_inner_message_to_json', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(innerProto, null, 'inner.proto');
      let ResultResponse = root.build("js.ResultResponse");
      const innerData = {
        result: [{
          url: 'innerUrl1',
          title: 'innerMessageToJson1',
          spinner: ["array111", "array2222"]
        }, {
          url: 'innerUrl2',
          title: 'innerMessageToJson2',
          spinner: ["spinner1", "spinner2"]
        }]
      };
      let msg = new ResultResponse(innerData);
      let json = ProtoBufFormat.Format.messageToJson(msg);
      let result = '{"result": [{"url": "innerUrl1","title": "innerMessageToJson1","spinner": ["array111","array2222"]},{"url": "innerUrl2","title": "innerMessageToJson2","spinner": ["spinner1","spinner2"]}]}';
      expect(json).assertEqual(result);
    })

    it('format_inner_json_to_message', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(innerProto, null, 'inner.proto');
      const innerData = {
        result: [{
          url: 'json_to_message1',
          title: 'innerJsonToMessage1',
          spinner: ["array111", "array2222"]
        }, {
          url: 'json_to_message2',
          title: 'innerJsonToMessage2',
          spinner: ["spinner1", "spinner2"]
        }]
      };
      let msg = ProtoBufFormat.Format.jsonToMessage(root, "js.ResultResponse", innerData);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(innerData));
    })
    it('format_inner_message_to_xml', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(innerProto, null, 'inner.proto');
      let ResultResponse = root.build("js.ResultResponse");
      const innerData = {
        result: [{
          url: 'message_to_xml1',
          title: 'innerMessageToXml1',
          spinner: ["array111", "array2222"]
        }, {
          url: 'message_to_xml1',
          title: 'innerMessageToXml2',
          spinner: ["spinner1", "spinner2"]
        }]
      };
      let msg = new ResultResponse(innerData);
      let xml = ProtoBufFormat.Format.messageToXml(msg);
      let xmlResult = '<ResultResponse><result><url>message_to_xml1</url><title>innerMessageToXml1</title><spinner>array111</spinner><spinner>array2222</spinner></result><result><url>message_to_xml1</url><title>innerMessageToXml2</title><spinner>spinner1</spinner><spinner>spinner2</spinner></result></ResultResponse>';
      expect(xml).assertEqual(xmlResult);
    })

    it('format_inner_xml_to_message', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(innerProto, null, 'inner.proto');
      const innerData = {
        result: [{
          url: 'xml_to_message1',
          title: 'innerXmlToMessage1',
          spinner: ["array111", "array2222"]
        }, {
          url: 'xml_to_message2',
          title: 'innerXmlToMessage2',
          spinner: ["spinner1", "spinner2"]
        }]
      };
      let xml = '<ResultResponse><result><url>xml_to_message1</url><title>innerXmlToMessage1</title><spinner>array111</spinner><spinner>array2222</spinner></result><result><url>xml_to_message2</url><title>innerXmlToMessage2</title><spinner>spinner1</spinner><spinner>spinner2</spinner></result></ResultResponse>';
      let msg = ProtoBufFormat.Format.xmlToMessage(root, 'js.ResultResponse', xml);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(innerData));
    })

    it('format_inner_message_to_html', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(innerProto, null, 'inner.proto');
      let ResultResponse = root.build("js.ResultResponse");
      const innerData = {
        result: [{
          url: 'message_to_html1',
          title: 'innerMessageToHtml1',
          spinner: ["array111", "array2222"]
        }, {
          url: 'message_to_html2',
          title: 'innerMessageToHtml2',
          spinner: ["spinner1", "spinner2"]
        }]
      };
      let msg = new ResultResponse(innerData);
      let html = ProtoBufFormat.Format.messageToHtml(msg);
      let xmlResult = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>.js.ResultResponse</title></head><body><div style="color: black; font-size: 14px; font-family: sans-serif; font-weight: bolder; margin-bottom: 10px;">message : .js.ResultResponse</div><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">result</span> <span style="color: red;">{</span><br/><div style="margin-left: 25px"><span style="color: #3300FF;font-size: 13px; font-family: sans-serif;"><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">url</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"message_to_html1"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">title</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"innerMessageToHtml1"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">spinner</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"array111"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">spinner</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"array2222"</span><br/></span></div><span style="color: red;">}</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">result</span> <span style="color: red;">{</span><br/><div style="margin-left: 25px"><span style="color: #3300FF;font-size: 13px; font-family: sans-serif;"><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">url</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"message_to_html2"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">title</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"innerMessageToHtml2"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">spinner</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"spinner1"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">spinner</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"spinner2"</span><br/></span></div><span style="color: red;">}</span><br/></body></html>';
      expect(html).assertEqual(xmlResult);
    })

    it('format_imports_message_to_json', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProtoFile('imports.proto', null, null, globalThis.resourceManager);
      let Test3 = root.build("js.Test3");
      const test3Data = {
        test1: {
          a: 10
        },
        test2: {
          b: 'this is test2 string:10'
        }
      };
      let msg = new Test3(test3Data);
      let json = ProtoBufFormat.Format.messageToJson(msg);
      let result = '{"test1": {"a": 10},"test2": {"b": "this is test2 string:10"}}';
      expect(json).assertEqual(result);
    })

    it('format_imports_json_to_message', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProtoFile('imports.proto', null, null, globalThis.resourceManager);
      const test3Data = {
        test1: {
          a: 20
        },
        test2: {
          b: 'this is test2 string:20'
        }
      };
      let msg = ProtoBufFormat.Format.jsonToMessage(root, "js.Test3", test3Data);
      let result = '{"test1":{"a":20},"test2":{"b":"this is test2 string:20"}}';
      expect(JSON.stringify(msg)).assertEqual(result);
    })

    it('format_imports_message_to_xml', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProtoFile('imports.proto', null, null, globalThis.resourceManager);
      let Test3 = root.build("js.Test3");
      const test3Data = {
        test1: {
          a: 30
        },
        test2: {
          b: 'this is test2 string:30'
        }
      };
      let msg = new Test3(test3Data);
      let xml = ProtoBufFormat.Format.messageToXml(msg);
      let result = '<Test3><test1><a>30</a></test1><test2><b>this is test2 string:30</b></test2></Test3>';
      expect(xml).assertEqual(result);
    })

    it('format_imports_xml_to_message', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProtoFile('imports.proto', null, null, globalThis.resourceManager);
      const test3Data = {
        test1: {
          a: 40
        },
        test2: {
          b: 'this is test2 string:40'
        }
      };
      let result = '<Test3><test1><a>40</a></test1><test2><b>this is test2 string:40</b></test2></Test3>';
      let msg = ProtoBufFormat.Format.xmlToMessage(root, "js.Test3", result);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(test3Data));
    })

    it('format_imports_message_to_html', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProtoFile('imports.proto', null, null, globalThis.resourceManager);
      let Test3 = root.build("js.Test3");
      const test3Data = {
        test1: {
          a: 50
        },
        test2: {
          b: 'this is test2 string:50'
        }
      };
      let msg = new Test3(test3Data);
      let html = ProtoBufFormat.Format.messageToHtml(msg);
      let result = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>.js.Test3</title></head><body><div style="color: black; font-size: 14px; font-family: sans-serif; font-weight: bolder; margin-bottom: 10px;">message : .js.Test3</div><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">test1</span> <span style="color: red;">{</span><br/><div style="margin-left: 25px"><span style="color: #3300FF;font-size: 13px; font-family: sans-serif;"><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">a</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">50</span><br/></span></div><span style="color: red;">}</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">test2</span> <span style="color: red;">{</span><br/><div style="margin-left: 25px"><span style="color: #3300FF;font-size: 13px; font-family: sans-serif;"><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">b</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"this is test2 string:50"</span><br/></span></div><span style="color: red;">}</span><br/></body></html>';
      expect(html).assertEqual(result);
    })

    it('format_imports_message_to_json_2', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProtoFile('imports.proto', null, null, globalThis.resourceManager);
      let Test1 = root.build("Test1");
      const test1Data = {
        a: 10
      };
      let msg = new Test1(test1Data);
      let json = ProtoBufFormat.Format.messageToJson(msg);
      let result = '{"a": 10}';
      expect(json).assertEqual(result);
    })

    it('format_imports_json_to_message_2', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProtoFile('imports.proto', null, null, globalThis.resourceManager);
      const test1Data = {
        a: 20
      };
      let msg = ProtoBufFormat.Format.jsonToMessage(root, "Test1", test1Data);
      let result = '{"a":20}';
      expect(JSON.stringify(msg)).assertEqual(result);
    })

    it('format_imports_message_to_xml_2', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProtoFile('imports.proto', null, null, globalThis.resourceManager);
      let Test1 = root.build("Test1");
      const test1Data = {
        a: 30
      };
      let msg = new Test1(test1Data);
      let xml = ProtoBufFormat.Format.messageToXml(msg);
      let result = '<Test1><a>30</a></Test1>';
      expect(xml).assertEqual(result);
    })

    it('format_imports_xml_to_message_2', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProtoFile('imports.proto', null, null, globalThis.resourceManager);
      const test1Data = {
        a: 40
      };
      let result = '<Test1><a>40</a></Test1>';
      let msg = ProtoBufFormat.Format.xmlToMessage(root, "Test1", result);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(test1Data));
    })

    it('format_imports_message_to_html_2', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProtoFile('imports.proto', null, null, globalThis.resourceManager);
      let Test1 = root.build("Test1");
      const test1Data = {
        a: 50
      };
      let msg = new Test1(test1Data);
      let html = ProtoBufFormat.Format.messageToHtml(msg);
      let result = '<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>.Test1</title></head><body><div style="color: black; font-size: 14px; font-family: sans-serif; font-weight: bolder; margin-bottom: 10px;">message : .Test1</div><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">a</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">50</span><br/></body></html>';
      expect(html).assertEqual(result);
    })

    it('format_person_message_to_json', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(personProto, null, 'person.proto');
      let Person = root.build("tutorial.Person");
      const personData = {
        name: "personName@<>'*-.", id: 256, email: "personEmail@xxx.com",
        phones: [{
          number: "13812341234", type: 0
        }, {
          number: "0431-81234567", type: 1
        }]
      };
      let msg = new Person(personData);
      let json = ProtoBufFormat.Format.messageToJson(msg);
      let result = `{"name": "personName@<>'*-.","id": 256,"email": "personEmail@xxx.com","phones": [{"number": "13812341234","type": "MOBILE"},{"number": "0431-81234567","type": "HOME"}]}`;
      expect(json).assertEqual(result);
    })

    it('format_person_json_to_message', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(personProto, null, 'person.proto');
      const personData = {
        name: "personName@<>.", id: 256, email: "personEmail@xxx1.com",
        phones: [{
          number: "13812341234", type: 0
        }, {
          number: "0431-81234567", type: 1
        }]
      };
      let msg = ProtoBufFormat.Format.jsonToMessage(root, "tutorial.Person", personData);
      let result = '{"name":"personName@<>.","id":{"low":256,"high":0,"unsigned":true},"email":"personEmail@xxx1.com","phones":[{"number":"13812341234","type":0},{"number":"0431-81234567","type":1}]}';
      expect(JSON.stringify(msg)).assertEqual(result);
    })

    it('format_person_message_to_xml', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(personProto, null, 'person.proto');
      let Person = root.build("tutorial.Person");
      const personData = {
        name: "personName@<>‘.", id: 256, email: "personEmail@xxx2.com",
        phones: [{
          number: "13812341234", type: 0
        }, {
          number: "0431-81234567", type: 1
        }]
      };
      let msg = new Person(personData);
      let xml = ProtoBufFormat.Format.messageToXml(msg);
      let result = '<Person><name>personName@&lt;&gt;‘.</name><id>256</id><email>personEmail@xxx2.com</email><phones><number>13812341234</number><type>MOBILE</type></phones><phones><number>0431-81234567</number><type>HOME</type></phones></Person>';
      expect(xml).assertEqual(result);
    })

    it('format_person_xml_to_message', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(personProto, null, 'person.proto');
      let idValue = ProtoBufFormat.Protobuf.Long.fromValue({
        high: 0, low: 256, unsigned: true
      });

      const personData = {
        name: "personName@<>‘'\".", id: idValue, email: "personEmail@xxx3.com",
        phones: [{
          number: "13812355679", type: 0
        }, {
          number: "0431-82324568", type: 1
        }]
      };
      let xml = `<Person><name>personName@&lt;&gt;‘'".</name><id>256</id><email>personEmail@xxx3.com</email><phones><number>13812355679</number><type>0</type></phones><phones><number>0431-82324568</number><type>1</type></phones></Person>`;
      let msg = ProtoBufFormat.Format.xmlToMessage(root, "tutorial.Person", xml);
      expect(JSON.stringify(msg)).assertEqual(JSON.stringify(personData));
    })

    it('format_person_message_to_html', 0, async function () {
      let root = await ProtoBufFormat.Protobuf.loadProto(personProto, null, 'person.proto');
      var Person = root.build("tutorial.Person");
      let idIntValue = ProtoBufFormat.Protobuf.Long.fromValue({
        high: 0, low: 256, unsigned: true
      });
      const personData = {
        name: "personName@<>‘'\".*", id: idIntValue, email: "personEmail@xxx4.com",
        phones: [{
          number: "13812355689", type: 0
        }, {
          number: "0431-82324569", type: 1
        }]
      };
      let msg = new Person(personData);
      let html = ProtoBufFormat.Format.messageToHtml(msg);
      let result = `<html><head><meta http-equiv="content-type" content="text/html; charset=UTF-8" /><title>.tutorial.Person</title></head><body><div style="color: black; font-size: 14px; font-family: sans-serif; font-weight: bolder; margin-bottom: 10px;">message : .tutorial.Person</div><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">name</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"personName@<>‘'".*"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">id</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">256</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">email</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"personEmail@xxx4.com"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">phones</span> <span style="color: red;">{</span><br/><div style="margin-left: 25px"><span style="color: #3300FF;font-size: 13px; font-family: sans-serif;"><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">number</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"13812355689"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">type</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">MOBILE</span><br/></span></div><span style="color: red;">}</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">phones</span> <span style="color: red;">{</span><br/><div style="margin-left: 25px"><span style="color: #3300FF;font-size: 13px; font-family: sans-serif;"><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">number</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">"0431-82324569"</span><br/><span style="font-weight: bold; color: #669966;font-size: 14px; font-family: sans-serif;">type</span>: <span style="color: #3300FF;font-size: 13px; font-family: sans-serif;">HOME</span><br/></span></div><span style="color: red;">}</span><br/></body></html>`;
      expect(html).assertEqual(result);
    })
  })
}