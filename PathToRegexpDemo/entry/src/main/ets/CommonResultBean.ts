/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export default class CommonResultBean {
  beforeStr: Array<string> = new Array<string>();
  afterStr: Array<string> = new Array<string>();

  constructor() {
    if (!this.beforeStr) {
      this.beforeStr = new Array<string>();
    }
    if (!this.afterStr) {
      this.afterStr = new Array<string>();
    }
  }

  public setBefore(arr: Array<string>) {
    if (!arr) {
      return;
    }
    this.beforeStr = arr;
  }

  public setAfter(arr: Array<string>) {
    if (!arr) {
      return;
    }
    this.afterStr = arr;
  }
}