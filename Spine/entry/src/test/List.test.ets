/**
 * Apache License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import localUnitTest from './LocalUnit.test';
import singleExampleRenderTest from './SingleExampleRender.test';
import networkExampleRenderTest from './NetworkExampleRender.test';
import example1RenderTest from './Example1Render.test';
import example2RenderTest from './Example2Render.test';
import example3RenderTest from './Example3Render.test';
import example4RenderTest from './Example4Render.test';

export default function testsuite() {
  localUnitTest();
  singleExampleRenderTest();
  networkExampleRenderTest();
  example1RenderTest();
  example2RenderTest();
  example3RenderTest();
  example4RenderTest();
}
