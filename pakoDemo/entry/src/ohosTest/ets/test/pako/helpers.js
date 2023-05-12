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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import pako from  'pako'

export function loadSamples(basename, resid, callback) {
  const result = {};
   globalThis.Ctx.resourceManager.getMediaContent(resid).then((uint8)=>{
    result[basename] = uint8;
    callback(result)
  })
}


export  function testInflate(samples, inflateOptions, deflateOptions) {
  let name, data, deflated, inflated;

  // inflate options have windowBits = 0 to force autodetect window size
  //
  for (name in samples) {
    if (!samples.hasOwnProperty(name)) continue;
    data = samples[name];

    deflated = pako.deflate(data, deflateOptions);
    inflated = pako.inflate(deflated, inflateOptions);

    // assert.deepStrictEqual(inflated, data);
    expect(inflated).assertDeepEquals(data)
  }
}

