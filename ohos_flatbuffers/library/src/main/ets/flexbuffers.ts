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
  * */

/* eslint-disable @typescript-eslint/no-namespace */
import { Builder } from './flexbuffers/builder.js'
import { toReference } from './flexbuffers/reference.js'
export { toReference } from './flexbuffers/reference.js'

export function builder(): Builder {
    return new Builder();
}

export function toObject(buffer: ArrayBuffer): unknown {
    return toReference(buffer).toObject();
}

export function encode(object: unknown, size = 2048, deduplicateStrings = true, deduplicateKeys = true, deduplicateKeyVectors = true): Uint8Array {
    const builder = new Builder(size > 0 ? size : 2048, deduplicateStrings, deduplicateKeys, deduplicateKeyVectors);
    builder.add(object);
    return builder.finish();
}
