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

import { beforeEach, describe, expect, it } from '@ohos/hypium';
import { CoreManager, ParseInstallation, Storage,StorageController } from '@ohos/parser-sdk';
import InstallationController from '@ohos/parser-sdk/src/main/ets/InstallationController';

export default function installationControllerTest() {

  describe('installationControllerTest', () => {
    beforeEach(() => {
      CoreManager.setStorageController(StorageController)
      CoreManager.set('APPLICATION_ID', 'A');
      CoreManager.set('JAVASCRIPT_KEY', 'B');
      Storage._clear();
      InstallationController._clearCache();
    });

    it('generates a new installation id when there is none', 0,async () => {
      const iid = await InstallationController.currentInstallationId();
      expect(typeof iid).assertEqual('string');
      expect(iid.length).assertLarger(0);
    });

    it('caches the installation id', 0,async () => {
      const iid = await InstallationController.currentInstallationId();
      Storage._clear();
      const i = await InstallationController.currentInstallationId();
      expect(i).assertEqual(iid);
    });

    it('permanently stores the installation id', 0,async () => {
      const iid = await InstallationController.currentInstallationId();
      InstallationController._clearCache();
      const i = await InstallationController.currentInstallationId();
      expect(i).assertEqual(iid);
    });

    it('can set installation id', 0,async () => {
      const iid = '12345678';
      InstallationController._setInstallationIdCache(iid);
      const i = await InstallationController.currentInstallationId();
      expect(i).assertEqual(iid);
    });

    it('generates a new installation when there is none', 0,async () => {
      const installation = await InstallationController.currentInstallation();
      expect(installation instanceof ParseInstallation).assertEqual(true);
      expect(installation?.installationId).not().assertUndefined();
    });

    it('caches the current installation', 0,async () => {
      const iid = 'cached-installation-id';
      InstallationController._setInstallationIdCache(iid);
      const installation = await InstallationController.currentInstallation();
      Storage._clear();
      const i = await InstallationController.currentInstallation();
      expect(i?.installationId).assertEqual(installation?.installationId);
    });

    it('permanently stores the current installation', 0,async () => {
      const iid = 'stored-installation-id';
      InstallationController._setInstallationIdCache(iid);
      const installation = await InstallationController.currentInstallation();
      InstallationController._clearCache();
      const i = await InstallationController.currentInstallation();
      expect(i?.installationId).assertEqual(installation?.installationId);
    });

    it('can update installation on disk', 0,async () => {
      const installationId = 'new-installation-id';
      const installation :ESObject= new ParseInstallation({ installationId } as ESObject);
      InstallationController.updateInstallationOnDisk(installation);
      const i = await InstallationController.currentInstallation();
      expect(i?.installationId).assertEqual(installationId);
    });

    it('can handle cache not matching disk', 0,async () => {
      InstallationController._setCurrentInstallationCache(null, true);
      const i = await InstallationController.currentInstallation();
      expect(i).assertNull();
    });
  })
}