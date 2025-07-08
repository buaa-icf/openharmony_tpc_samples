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
import { beforeEach, describe, expect, it } from "@ohos/hypium";
import { CoreManager, ParseConfig, ParseGeoPoint, Storage, StorageController } from "@ohos/parser-sdk";
import mockAsyncStorage from "./test_helpers/mockAsyncStorage";

export default function parseConfigTest() {
  const Core = CoreManager;
  Core.set('APPLICATION_ID', 'A');
  Core.set('JAVASCRIPT_KEY', 'B');
  Core.set('StorageController', StorageController);

  describe('ParseConfig', () => {
    beforeEach(() => {
      ParseConfig._clearCache();
    });

    it('exposes attributes via get()', 0, () => {
      const c = new ParseConfig();
      c.attributes = {
        str: 'hello',
        num: 44,
      };
      expect(c.get('str')).assertEqual('hello');
      expect(c.get('num')).assertEqual(44);
      expect(c.get('nonexistent')).assertUndefined();
    });

    it('exposes escaped attributes', 0, () => {
      const c = new ParseConfig();
      c.attributes = {
        brackets: '<>',
        phone: 'AT&T',
      };
      expect(c.escape('brackets')).assertEqual('&lt;&gt;');
      expect(c.escape('phone')).assertEqual('AT&amp;T');
      expect(c.escape('phone')).assertEqual('AT&amp;T');
    });

    it('can retrieve the current config from disk or cache', 0, () => {
      const path = Storage.generatePath('currentConfig');
      Storage.setItem(
        path,
        JSON.stringify({
          count: 12,
          point: {
            __type: 'GeoPoint',
            latitude: 20.02,
            longitude: 30.03,
          } as ESObject,
        })
      );
      expect((ParseConfig.current() as ParseConfig).attributes).assertDeepEquals({
        count: 12,
        point: new ParseGeoPoint(20.02, 30.03),
      });
      expect((ParseConfig.current() as ParseConfig).attributes).assertDeepEquals({
        count: 12,
        point: new ParseGeoPoint(20.02, 30.03),
      });
    });

    it('can handle decodedData error', 0, async () => {
      const currentStorage = Core.getStorageController();
      Core.setStorageController(mockAsyncStorage as ESObject);
      const path = Storage.generatePath('currentConfig');
      await Storage.setItemAsync(path, {} as ESObject);
      const config = await ParseConfig.current();
      expect(config.attributes).assertDeepEquals({});
      Core.setStorageController(currentStorage);
    });

    it('can retrieve the current config from async storage', 0, async () => {
      const currentStorage = Core.getStorageController();
      Core.setStorageController(mockAsyncStorage as ESObject);
      const path = Storage.generatePath('currentConfig');
      await Storage.setItemAsync(
        path,
        JSON.stringify({
          count: 12,
          point: {
            __type: 'GeoPoint',
            latitude: 20.02,
            longitude: 30.03,
          } as ESObject,
        })
      );
      const config = await ParseConfig.current();
      expect(config.attributes).assertDeepEquals({
        count: 12,
        point: new ParseGeoPoint(20.02, 30.03),
      });
      Core.setStorageController(currentStorage);
    });

    // it('can get a config object from the network', done => {
    //   CoreManager.setRESTController({
    //     request() {
    //       return Promise.resolve({
    //         params: {
    //           str: 'hello',
    //           num: 45,
    //           file: {
    //             __type: 'File',
    //             name: 'parse.txt',
    //             url: 'https://files.parsetfss.com/a/parse.txt',
    //           },
    //         },
    //       });
    //     },
    //     ajax() {},
    //   });
    //   ParseConfig.get().then(config => {
    //     expect(config.get('str')).toBe('hello');
    //     expect(config.get('num')).toBe(45);
    //     expect(config.get('file').name()).toBe('parse.txt');
    //     const path = Storage.generatePath('currentConfig');
    //     expect(JSON.parse(Storage.getItem(path))).toEqual({
    //       str: 'hello',
    //       num: 45,
    //       file: {
    //         __type: 'File',
    //         name: 'parse.txt',
    //         url: 'https://files.parsetfss.com/a/parse.txt',
    //       },
    //     });
    //
    //     done();
    //   });
    // });

    // it('can save a config object with masterkey', done => {
    //   //Load a request that match the get() & save() request
    //   CoreManager.setRESTController({
    //     request() {
    //       return Promise.resolve({
    //         params: {
    //           str: 'hello2',
    //           num: 46,
    //         },
    //         result: true,
    //       });
    //     },
    //     ajax() {},
    //   });
    //   ParseConfig.save({ str: 'hello2', num: 46 }).then(config => {
    //     expect(config.get('str')).toBe('hello2');
    //     expect(config.get('num')).toBe(46);
    //     const path = Storage.generatePath('currentConfig');
    //     expect(JSON.parse(Storage.getItem(path))).toEqual({
    //       str: 'hello2',
    //       num: 46,
    //     });
    //     done();
    //   });
    // });

    it('can save a config object that be retrieved with masterkey only', 0, async () => {
      Core.setRESTController({
        request(method, path, body: ESObject, options) {
          if (method === 'PUT') {
            expect(method).assertEqual('PUT');
            expect(path).assertEqual('config');
            expect(body).assertDeepEquals({
              params: { internal: 'i', number: 12 },
              masterKeyOnly: { internal: true },
            });
            expect(options).assertDeepEquals({ useMasterKey: true });
            return Promise.resolve({
              params: {
                internal: 'i',
                number: 12,
              } as ESObject,
              result: true,
            } as ESObject);
          } else if (method === 'GET') {
            expect(method).assertDeepEquals('GET');
            expect(path).assertEqual('config');
            expect(body).assertDeepEquals({});
            expect(options).assertDeepEquals({ useMasterKey: true });
            return Promise.resolve({
              params: {
                internal: 'i',
                number: 12,
              } as ESObject,
            } as ESObject);
          }

          return Promise.resolve({} as ESObject);
        },
        ajax(method, url, data: ESObject) {
          return Promise.resolve({} as ESObject);
        },
        handleError() {}
      });
      const config = await ParseConfig.save({ internal: 'i', number: 12 }, { internal: true });
      expect(config.get('internal')).assertEqual('i');
      expect(config.get('number')).assertEqual(12);
    });

    it('can get a config object with master key', 0, async () => {
      Core.setRESTController({
        request(method, path, body: ESObject, options) {
          expect(method).assertEqual('GET');
          expect(path).assertEqual('config');
          expect(body).assertDeepEquals({});
          expect(options).assertDeepEquals({ useMasterKey: true });
          return Promise.resolve({
            params: {
              str: 'hello',
              num: 45,
            } as ESObject,
          } as ESObject);
        },
        ajax(method, url, data: ESObject) {
          return Promise.resolve({} as ESObject);
        },
        handleError() {}
      });
      const config = await ParseConfig.get({ useMasterKey: true });
      expect(config.get('str')).assertEqual('hello');
      expect(config.get('num')).assertEqual(45);
      const path = Storage.generatePath('currentConfig');
      expect(JSON.parse(Storage.getItem(path) as string)).assertDeepEquals({
        str: 'hello',
        num: 45,
      });
    });

    // it('rejects save on invalid response', done => {
    //   CoreManager.setRESTController({
    //     request() {
    //       return Promise.resolve({ result: false });
    //     },
    //     ajax() {},
    //   });
    //   ParseConfig.save({ str: 'hello2', num: 46 }).then(
    //     config => {
    //       expect(config).toBe(1);
    //       done();
    //     },
    //     error => {
    //       expect(error.code).toBe(1);
    //       done();
    //     }
    //   );
    // });

    // it('rejects the promise when an invalid payload comes back', done => {
    //   CoreManager.setRESTController({
    //     request() {
    //       return Promise.resolve(null);
    //     },
    //     ajax() {},
    //   });
    //   ParseConfig.get().then(null, error => {
    //     expect(error.code).toBe(107);
    //     expect(error.message).toBe('Config JSON response invalid.');
    //     done();
    //   });
    // });

    // it('rejects the promise when the http request fails', done => {
    //   CoreManager.setRESTController({
    //     request() {
    //       return Promise.reject('failure');
    //     },
    //     ajax() {},
    //   });
    //   ParseConfig.get().then(null, error => {
    //     expect(error).toBe('failure');
    //     done();
    //   });
    // });
  });
}