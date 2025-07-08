/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */
import { describe, expect, it } from "@ohos/hypium";
import { Attributes, CoreManager, LocalDatastore, ParseError, ParseInstallation } from "@ohos/parser-sdk";

function createMockFn(): ESObject {
  const calls: ESObject[][] = [];

  const fn = (...args: ESObject[]) => {
    calls.push(args);
  };

  return {
    fn,
    calls,
    reset() {
      calls.length = 0;
    }
  } as ESObject;
}

const ParseInstall = ParseInstallation;
const Core = CoreManager;

export default function parseInstallationTest() {
  describe('ParseInstallation', () => {
    it('can create ParseInstallation', 0, () => {
      let installation = new ParseInstallation();
      expect(installation.className).assertEqual('_Installation');

      installation = new ParseInstallation({} as ESObject);
      expect(installation.className).assertEqual('_Installation');

      installation = new ParseInstallation({ deviceToken: 'token' } as ESObject);
      expect(installation.get('deviceToken')).assertEqual('token');

      expect(() => {
        new ParseInstallation({ 'invalid#name': 'foo' } as ESObject);
      }).assertThrowError("Can't create an invalid Installation");
    });

    it('can get device types', 0, () => {
      expect(ParseInstall.DEVICE_TYPES.WEB).assertEqual('web');
      expect(ParseInstall.DEVICE_TYPES.IOS).assertEqual('ios');
      expect(ParseInstall.DEVICE_TYPES.MACOS).assertEqual('macos');
      expect(ParseInstall.DEVICE_TYPES.TVOS).assertEqual('tvos');
      expect(ParseInstall.DEVICE_TYPES.FCM).assertEqual('fcm');
      expect(ParseInstall.DEVICE_TYPES.ANDROID).assertEqual('android');
    });

    it('can retrieve getters', 0, () => {
      const data: Attributes = {
        deviceType: 'web',
        installationId: '1234',
        deviceToken: '1234',
        badge: 1,
        appIdentifier: 'com.parse.server',
        appName: 'Parse JS SDK',
        appVersion: '1.0.0',
        parseVersion: '1.0.0',
        localeIdentifier: 'en-US',
        timeZone: 'GMT',
        channels: ['test'],
        GCMSenderId: '1234',
        pushType: 'test',
      };
      const installation = new ParseInstallation(data);
      Object.keys(data).forEach(key => {
        expect(installation[key]).assertEqual(data[key]);
      });
    });

    it('can save to disk', 0, async () => {
      const mockFunc: ESObject = createMockFn();
      const InstallationController: ESObject = {
        updateInstallationOnDisk: mockFunc.fn,
        async currentInstallationId() {},
        async currentInstallation() {},
      };
      Core.setInstallationController(InstallationController);
      Core.setRESTController({
        request() {
          return Promise.resolve({} as ESObject);
        },
        ajax(method, url, data: ESObject) {
          return Promise.resolve({} as ESObject)
        },
        handleError() {}
      });
      Core.setLocalDatastore(LocalDatastore);
      const installation = new ParseInstallation();
      installation.set('deviceToken', '1234');
      await installation.save();
      expect(mockFunc.calls.length).assertEqual(1);
    });

    it('can save if object not found', 0, async () => {
      const mockFunc: ESObject = createMockFn();
      const InstallationController: ESObject = {
        updateInstallationOnDisk: mockFunc.fn,
        async currentInstallationId() {},
        async currentInstallation() {},
      };
      let once = true; // save will be called twice first time will reject
      Core.setInstallationController(InstallationController);
      Core.setRESTController({
        request() {
          if (!once) {
            return Promise.resolve({} as ESObject);
          }
          once = false;
          const parseError = new ParseError(ParseError.OBJECT_NOT_FOUND, 'Object not found.');
          return Promise.reject(parseError);
        },
        ajax() {
          return Promise.resolve({} as ESObject)
        },
        handleError() {}
      });
      Core.setLocalDatastore(LocalDatastore);
      const installation = new ParseInstallation();
      installation.set('deviceToken', '1234');
      await installation.save();
      expect(mockFunc.calls.length).assertEqual(1);
    });
  });
}