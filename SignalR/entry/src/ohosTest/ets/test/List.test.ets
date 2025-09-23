/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import errorClassesTest from './ErrorClasses.test';
import subjectTest from './Subject.test';
import jsonHubProtocolTest from './JsonHubProtocol.test';
import hubConnectionBuilderTest from './HubConnectionBuilder.test';
import hubConnectionTest, { 
  connectionLifecycleTest, 
  methodInvocationTest, 
  eventHandlingTest, 
  configurationOptionsTest, 
  errorScenariosTest, 
  stateManagementTest 
} from './HubConnection.test';
import defaultHttpClientTest from './DefaultHttpClient.test';
import harmonyHttpClientTest from './HarmonyHttpClient.test';
import nullLoggerTest from './NullLogger.test';
import streamTest from './Stream.test';
import longPollingTransportTest from './LongPollingTransport.test';

export default function testsuite() {
  errorClassesTest();
  subjectTest();
  jsonHubProtocolTest();
  hubConnectionBuilderTest();
  hubConnectionTest();
  connectionLifecycleTest();
  methodInvocationTest();
  eventHandlingTest();
  configurationOptionsTest();
  errorScenariosTest();
  stateManagementTest();
  defaultHttpClientTest();
  harmonyHttpClientTest();
  nullLoggerTest();
  streamTest();
  longPollingTransportTest();
}