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

import { util } from "@kit.ArkTS";

export function fromUTF8Array(data: Uint8Array): string {
  const decoder = new util.TextDecoder();
  return decoder.decodeWithStream(data);
}

export function toUTF8Array(str: string) : Uint8Array {
  const encoder = new util.TextEncoder();
  return encoder.encodeInto(str);
}