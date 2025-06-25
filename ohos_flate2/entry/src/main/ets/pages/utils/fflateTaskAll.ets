/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import { PerformanceResults } from './TaskUtil'
import { deflate, inflate, gzip, ungzip, deflateRaw, inflateRaw} from '@ohos/flate2';

@Concurrent
export async function fflateTaskAll(inputData: Uint8Array): Promise<PerformanceResults> {
  const results: PerformanceResults = {
    deflate: { time: 0, ratio: 0 },
    gzip: { time: 0, ratio: 0 },
    deflateRaw: { time: 0 , ratio: 0 },
    inflate: { time: 0 },
    ungzip: { time: 0 },
    inflateRaw: { time: 0 }
  }

  // 测试 deflate
  const deflateStart = Date.now()
  const deflated = deflate(inputData)
  results.deflate.time = Date.now() - deflateStart
  results.deflate.ratio = (deflated.length / inputData.length) * 100

  // 测试 inflate
  const inflateStart = Date.now()
  inflate(deflated)
  results.inflate.time = Date.now() - inflateStart


  // 测试 gzip
  const gzipStart = Date.now()
  const gzipped = gzip(inputData)
  results.gzip.time = Date.now() - gzipStart
  results.gzip.ratio = (gzipped.length / inputData.length) * 100

  // // 测试 ungzip
  const ungzipStart = Date.now()
  ungzip(gzipped)
  results.ungzip.time = Date.now() - ungzipStart


  // 测试 deflateRaw
  const deflateRawStart = Date.now()
  const deflateRawed = deflateRaw(inputData)
  results.deflateRaw.time = Date.now() - deflateRawStart
  results.deflateRaw.ratio = (deflated.length / inputData.length) * 100

  const inflateRawStart = Date.now()
  inflateRaw(deflateRawed)
  results.inflateRaw.time = Date.now() - inflateRawStart

  return results
}