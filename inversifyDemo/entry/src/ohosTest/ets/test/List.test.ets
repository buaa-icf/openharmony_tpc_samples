/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import node_error_messagesTest from './node_error_messages.test'
import inversifyTest from './inversify.test'
import containerTest from './container.test';
import container_moduleTest from './container_module.test';
import exceptionsTest from './exceptions.test';
import injectTest from './inject.test';
import multiInjectTest from './multiInject.test';
import namedTest from './named.test';
import named_defaultTest from './named_default.test';
import optionalTest from './optional.test';
import post_constructTest from './post_construct.test';
import property_injectionTest from './property_injection.test';
import providerTest from './provider.test';
import proxiesTest from './proxies.test';
import transitive_bindingsTest from './transitive_bindings.test';

export default function testsuite() {
  containerTest();
  container_moduleTest();
  exceptionsTest();
  node_error_messagesTest();
  inversifyTest();
  injectTest();
  multiInjectTest();
  namedTest();
  named_defaultTest();
  optionalTest();
  post_constructTest();
  property_injectionTest();
  providerTest();
  proxiesTest();
  transitive_bindingsTest();
}