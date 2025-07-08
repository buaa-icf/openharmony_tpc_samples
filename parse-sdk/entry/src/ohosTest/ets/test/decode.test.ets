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

import { describe, expect, it } from '@ohos/hypium';
import { CoreManager } from '@ohos/parser-sdk';

export default function decodeTest() {

  describe('decodeTest', () => {
    it('is initialized with default values',0, () => {
      expect(CoreManager.get('SERVER_URL')).assertEqual('https://api.parse.com/1');
    });

    it('can set and retrieve arbitrary values',0, () => {
      expect(CoreManager.get.bind(null, 'something')).assertThrowError(
        'Configuration key not found: something'
      );
      CoreManager.set('something', 'a string');
      expect(CoreManager.get('something')).assertEqual('a string');
    });

    it('requires AnalyticsController to implement certain functionality',0, () => {
      expect(CoreManager.setAnalyticsController.bind(null, {})).assertThrowError(
        'AnalyticsController must implement track()'
      );

      expect(
        CoreManager.setAnalyticsController.bind(null, {
          track: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get AnalyticsController',0, () => {
      const controller:ESObject = {
        track: () =>{},
      };

      CoreManager.setAnalyticsController(controller);
      expect(CoreManager.getAnalyticsController()).assertEqual(controller);
    });

    it('requires CloudController to implement certain functionality',0, () => {
      expect(CoreManager.setCloudController.bind(null, {})).assertThrowError(
        'CloudController must implement run()'
      );

      expect(
        CoreManager.setCloudController.bind(null, {
          run: () =>{},
          getJobsData: () =>{},
          startJob: () =>{},
          getJobStatus: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get CloudController',0, () => {
      const controller :ESObject= {
        run: () =>{},
        getJobsData: () =>{},
        startJob: () =>{},
        getJobStatus: () =>{},
      };

      CoreManager.setCloudController(controller);
      expect(CoreManager.getCloudController()).assertEqual(controller);
    });

    it('requires ConfigController to implement certain functionality',0, () => {
      expect(CoreManager.setConfigController.bind(null, {})).assertThrowError(
        'ConfigController must implement current()'
      );

      expect(
        CoreManager.setConfigController.bind(null, {
          current: () =>{},
        })
      ).assertThrowError('ConfigController must implement get()');

      expect(
        CoreManager.setConfigController.bind(null, {
          current: () =>{},
          get: () =>{},
          save: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get ConfigController',0, () => {
      const controller:ESObject = {
        current: () =>{},
        get: () =>{},
        save: () =>{},
      };

      CoreManager.setConfigController(controller);
      expect(CoreManager.getConfigController()).assertEqual(controller);
    });

    it('requires FileController to implement certain functionality',0, () => {
      expect(CoreManager.setFileController.bind(null, {})).assertThrowError(
        'FileController must implement saveFile()'
      );

      expect(
        CoreManager.setFileController.bind(null, {
          saveFile: () =>{},
        })
      ).assertThrowError('FileController must implement saveBase64()');

      expect(
        CoreManager.setFileController.bind(null, {
          saveFile: () =>{},
          saveBase64: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get FileController',0, () => {
      const controller :ESObject= {
        saveFile: () =>{},
        saveBase64: () =>{},
      };

      CoreManager.setFileController(controller);
      expect(CoreManager.getFileController()).assertEqual(controller);
    });

    it('requires InstallationController to implement certain functionality',0, () => {
      expect(CoreManager.setInstallationController.bind(null, {})).assertThrowError(
        'InstallationController must implement currentInstallationId()'
      );

      expect(
        CoreManager.setInstallationController.bind(null, {
          currentInstallationId: () =>{},
          currentInstallation: () =>{},
        })
      ).assertThrowError('InstallationController must implement updateInstallationOnDisk()');

      expect(
        CoreManager.setInstallationController.bind(null, {
          currentInstallationId: () =>{},
          updateInstallationOnDisk: () =>{},
        })
      ).assertThrowError('InstallationController must implement currentInstallation()');

      expect(
        CoreManager.setInstallationController.bind(null, {
          currentInstallationId: () =>{},
          currentInstallation: () =>{},
          updateInstallationOnDisk: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get InstallationController',0, () => {
      const controller :ESObject= {
        currentInstallationId: () =>{},
        currentInstallation: () =>{},
        updateInstallationOnDisk: () =>{},
      };

      CoreManager.setInstallationController(controller);
      expect(CoreManager.getInstallationController()).assertEqual(controller);
    });

    it('requires PushController to implement certain functionality',0, () => {
      expect(CoreManager.setPushController.bind(null, {})).assertThrowError(
        'PushController must implement send()'
      );

      expect(
        CoreManager.setPushController.bind(null, {
          send: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get PushController',0, () => {
      const controller :ESObject= {
        send: () =>{},
      };

      CoreManager.setPushController(controller);
      expect(CoreManager.getPushController()).assertEqual(controller);
    });

    it('requires ObjectController to implement certain functionality',0, () => {
      expect(CoreManager.setObjectController.bind(null, {})).assertThrowError(
        'ObjectController must implement save()'
      );

      expect(
        CoreManager.setObjectController.bind(null, {
          save: () =>{},
        })
      ).assertThrowError('ObjectController must implement fetch()');

      expect(
        CoreManager.setObjectController.bind(null, {
          save: () =>{},
          fetch: () =>{},
        })
      ).assertThrowError('ObjectController must implement destroy()');

      expect(
        CoreManager.setObjectController.bind(null, {
          save: () =>{},
          fetch: () =>{},
          destroy: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get ObjectController',0, () => {
      const controller :ESObject= {
        save: () =>{},
        fetch: () =>{},
        destroy: () =>{},
      };

      CoreManager.setObjectController(controller);
      expect(CoreManager.getObjectController()).assertEqual(controller);
    });

    it('can set and get ObjectStateController',0, () => {
      const controller :ESObject= {
        getState: () =>{},
        initializeState: () =>{},
        removeState: () =>{},
        getServerData: () =>{},
        setServerData: () =>{},
        getPendingOps: () =>{},
        setPendingOp: () =>{},
        pushPendingState: () =>{},
        popPendingState: () =>{},
        mergeFirstPendingState: () =>{},
        getObjectCache: () =>{},
        estimateAttribute: () =>{},
        estimateAttributes: () =>{},
        commitServerChanges: () =>{},
        enqueueTask: () =>{},
        clearAllState: () =>{},
      };

      CoreManager.setObjectStateController(controller);
      expect(CoreManager.getObjectStateController()).assertEqual(controller);
    });

    it('requires QueryController to implement certain functionality',0, () => {
      expect(CoreManager.setQueryController.bind(null, {})).assertThrowError(
        'QueryController must implement find()'
      );

      expect(
        CoreManager.setQueryController.bind(null, {
          find: () =>{},
          aggregate: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get QueryController',0, () => {
      const controller:ESObject = {
        find: () =>{},
        aggregate: () =>{},
      };

      CoreManager.setQueryController(controller);
      expect(CoreManager.getQueryController()).assertEqual(controller);
    });

    it('requires RESTController to implement certain functionality',0, () => {
      expect(CoreManager.setRESTController.bind(null, {})).assertThrowError(
        'RESTController must implement request()'
      );

      expect(
        CoreManager.setRESTController.bind(null, {
          request: () =>{},
        })
      ).assertThrowError('RESTController must implement ajax()');

      expect(
        CoreManager.setRESTController.bind(null, {
          request: () =>{},
          ajax: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get RESTController',0, () => {
      const controller :ESObject= {
        request: () =>{},
        ajax: () =>{},
      };

      CoreManager.setRESTController(controller);
      expect(CoreManager.getRESTController()).assertEqual(controller);
    });

    it('requires StorageController to implement certain functionality',0, () => {
      expect(CoreManager.setStorageController.bind(null, { async: 0 })).assertThrowError(
        'A synchronous StorageController must implement getItem()'
      );

      expect(
        CoreManager.setStorageController.bind(null, {
          async: 0,
          getItem: () =>{},
        })
      ).assertThrowError('A synchronous StorageController must implement setItem()');

      expect(
        CoreManager.setStorageController.bind(null, {
          async: 0,
          getItem: () =>{},
          setItem: () =>{},
        })
      ).assertThrowError('A synchronous StorageController must implement removeItem()');

      expect(
        CoreManager.setStorageController.bind(null, {
          async: 0,
          getItem: () =>{},
          setItem: () =>{},
          removeItem: () =>{},
          getAllKeys: () =>{},
        })
      ).not().assertThrowError("");

      expect(CoreManager.setStorageController.bind(null, { async: 1 })).assertThrowError(
        'An async StorageController must implement getItemAsync()'
      );

      expect(
        CoreManager.setStorageController.bind(null, {
          async: 1,
          getItemAsync: () =>{},
        })
      ).assertThrowError('An async StorageController must implement setItemAsync()');

      expect(
        CoreManager.setStorageController.bind(null, {
          async: 1,
          getItemAsync: () =>{},
          setItemAsync: () =>{},
        })
      ).assertThrowError('An async StorageController must implement removeItemAsync()');

      expect(
        CoreManager.setStorageController.bind(null, {
          async: 1,
          getItemAsync: () =>{},
          setItemAsync: () =>{},
          removeItemAsync: () =>{},
          getAllKeysAsync: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get StorageController',0, () => {
      const controller :ESObject= {
        async: 0,
        getItem: () =>{},
        setItem: () =>{},
        removeItem: () =>{},
        getAllKeys: () =>{},
      };

      CoreManager.setStorageController(controller);
      expect(CoreManager.getStorageController()).assertEqual(controller);
    });

    it('requires SchemaController to implement certain functionality',0, () => {
      expect(CoreManager.setSchemaController.bind(null, {})).assertThrowError(
        'SchemaController must implement get()'
      );

      expect(
        CoreManager.setSchemaController.bind(null, {
          send: () =>{},
          get: () =>{},
          create: () =>{},
          update: () =>{},
          delete: () =>{},
          purge: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get SchemaController',0, () => {
      const controller :ESObject= {
        send: () =>{},
        get: () =>{},
        create: () =>{},
        update: () =>{},
        delete: () =>{},
        purge: () =>{},
      };

      CoreManager.setSchemaController(controller);
      expect(CoreManager.getSchemaController()).assertEqual(controller);
    });

    it('requires LocalDatastoreController to implement certain functionality',0, () => {
      expect(CoreManager.setLocalDatastoreController.bind(null, {})).assertThrowError(
        'LocalDatastoreController must implement pinWithName()'
      );

      expect(
        CoreManager.setLocalDatastoreController.bind(null, {
          fromPinWithName: () =>{},
          pinWithName: () =>{},
          unPinWithName: () =>{},
          getAllContents: () =>{},
          clear: () =>{},
        })
      ).not().assertThrowError("");
    });

    it('can set and get setLocalDatastoreController',0, () => {
      const controller:ESObject = {
        fromPinWithName: () =>{},
        pinWithName: () =>{},
        unPinWithName: () =>{},
        getAllContents: () =>{},
        clear: () =>{},
      };

      CoreManager.setLocalDatastoreController(controller);
      expect(CoreManager.getLocalDatastoreController()).assertEqual(controller);
    });

    it('can set and get WebSocketController',0, () => {
      const controller :ESObject= {
        onopen: () =>{},
        onmessage: () =>{},
        onclose: () =>{},
        onerror: () =>{},
        send: () =>{},
        close: () =>{},
      };

      CoreManager.setWebSocketController(controller);
      expect(CoreManager.getWebSocketController()).assertEqual(controller);
    });
  })
}