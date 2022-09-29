/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import protobuf from 'protobufjs'
import { MyFs } from '../../../main/ets/pages/MyFs'

protobuf.Util.fetch = function (path, callback) {
  if (callback && typeof callback != 'function')
  callback = null;
  if (callback) {
    MyFs.readFile(path, function (err, data) {
      if (err)
      callback(null);
      else
      callback("" + data);
    });
  } else
  try {
    return MyFs.readFileSync(path);
  } catch (e) {
    return null;
  }
}
import { FileUtils } from '../../../main/ets/pages/FileUtils'
import util from '@ohos.util';

const protoStr = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';

const protoJson = JSON.stringify({
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
});

export default function serializedTest() {
  describe('ActProtoTest', function () {
    it('testLoadProtoInterface', 0, function () {
      //将proto数据写入内存
      var builder = protobuf.newBuilder();
      var root = protobuf.loadProto(protoStr, builder, "user.proto");

      var UserLoginResponse = root.build("com.user.UserLoginResponse");

      const userLogin = {
        sessionId: "testSynchronouslyLoadProtoFile",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };

      var msg = new UserLoginResponse(userLogin);
      var arrayBuffer = msg.toArrayBuffer();
      var decodeMsg = UserLoginResponse.decode(arrayBuffer);
      expect(decodeMsg.sessionId).assertContain("testSynchronouslyLoadProtoFile")
      expect(decodeMsg.userPrivilege).assertContain("John123")
      expect(decodeMsg.isTokenType).assertFalse()
      expect(decodeMsg.formatTimestamp).assertContain("12342222")
    })
  })

  it('testLoadJsonInterface', 0, function () {
    var builder = protobuf.newBuilder();
    var root = protobuf.loadJson(protoJson, builder, "user.json");

    var UserLoginResponse = root.build("com.user.UserLoginResponse");

    const userLogin = {
      sessionId: "testMethodLoadProto",
      userPrivilege: "John123",
      isTokenType: false,
      formatTimestamp: "12342222"
    };

    var msg = new UserLoginResponse(userLogin);
    var arrayBuffer = msg.toArrayBuffer();
    var decodeMsg = UserLoginResponse.decode(arrayBuffer);
    expect(decodeMsg.sessionId).assertContain("testMethodLoadProto")
    expect(decodeMsg.userPrivilege).assertContain("John123")
    expect(decodeMsg.isTokenType).assertFalse()
    expect(decodeMsg.formatTimestamp).assertContain("12342222")
  })
}