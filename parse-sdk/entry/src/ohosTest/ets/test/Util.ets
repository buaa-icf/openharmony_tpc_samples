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
export  default function createMockFn(): ESObject {
  const calls: ESObject[][] = [];
  let returnValue: ESObject;

  const fn = (...args: ESObject[]) => {
    calls.push(args);
    return Promise.resolve(returnValue);
  };

  return {
    fn,
    calls,
    mockResolvedValueOnce(value: ESObject) {
      returnValue = value;
    },
    reset() {
      calls.length = 0;
      returnValue = undefined;
    }
  } as ESObject;
}