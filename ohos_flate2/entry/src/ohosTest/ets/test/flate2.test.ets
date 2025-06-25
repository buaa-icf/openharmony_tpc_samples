/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { describe, beforeAll, it, expect } from '@ohos/hypium'
import { deflate, inflate, gzip, ungzip, deflateRaw, inflateRaw } from '@ohos/flate2';
import { readRawFileUint8Array } from '../../../main/ets/pages/utils/TaskUtil';

export default function flate2Test() {
  describe('flate2Test', () => {
    let inputData: Uint8Array | undefined = undefined;

    beforeAll(() => {
      // 从资源文件读取数据
      inputData = readRawFileUint8Array("1MB.txt");
    })

    it('deflate_inflate', 0, () => {
      const deflated = deflate(inputData);
      const output = inflate(deflated)
      expect(inputData?.length).assertEqual(output.length);
    })

    it('deflateRaw_inflateRaw', 0, () => {
      const deflated = deflateRaw(inputData)
      const output = inflateRaw(deflated)
      expect(inputData?.length).assertEqual(output.length);
    })

    it('gzip_ungzip', 0, () => {
      const deflated = gzip(inputData)
      const output = ungzip(deflated)
      expect(inputData?.length).assertEqual(output.length);
    })

  })
}