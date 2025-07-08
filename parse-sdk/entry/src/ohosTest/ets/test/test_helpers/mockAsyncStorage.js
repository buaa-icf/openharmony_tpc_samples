/*
  * Copyright (c) 2022 Huawei Device Co., Ltd.
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
let mockStorage = {};
const mockAsyncStorage = {
  async: 1,
  async getItemAsync(path) {
    return mockStorage[path];
  },

  async setItemAsync(path, value) {
    mockStorage[path] = value;
  },

  async removeItemAsync(path) {
    delete mockStorage[path];
  },

  async getAllKeysAsync() {
    return Object.keys(mockStorage);
  },

  clear() {
    mockStorage = {};
  },
};

export default mockAsyncStorage;
