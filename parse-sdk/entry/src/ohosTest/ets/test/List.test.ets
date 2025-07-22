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

import abilityTest from './Ability.test';
import arrayContainsObjectTest from './arrayContainsObject.test';
import canBeSerializedTest from './canBeSerialized.test';
import coreManagerTest from './CoreManager.test';
import decodeTest from './decode.test';
import encodeTest from './encode.test';
import equalTest from './equal.test';
import escapeTest from './escape.test';
import installationControllerTest from './InstallationController.test';
import parseACLTest from './ParseACL.test';
import parseCLPTest from './ParseCLP.test';
import parseConfigTest from './ParseConfig.test';
import parseDateTest from './ParseDate.test';
import parseErrorTest from './ParseError.test';
import parseGeoPointTest from './ParseGeoPoint.test';
import parseInstallationTest from './ParseInstallation.test';
import offlineQueryTest from './OfflineQuery.test';

export default function testsuite() {
  abilityTest();
  parseACLTest();
  parseCLPTest();
  parseConfigTest();
  parseDateTest();
  parseErrorTest();
  parseGeoPointTest();
  arrayContainsObjectTest();
  canBeSerializedTest();
  coreManagerTest();
  decodeTest();
  encodeTest();
  equalTest();
  escapeTest();
  installationControllerTest();
  parseInstallationTest();
  offlineQueryTest();
}
