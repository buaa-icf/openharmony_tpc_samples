/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


class JumpBean {
  jumpPath: string = '';

  constructor(path) {
    this.jumpPath = path;
  }
}

export default class JumpPathConfig {
  public static dataList: Array<JumpBean>;

  public static getIndex(): number[] {
    this.initData();
    let tempArr: number[] = new Array<number>(this.dataList.length);
    for (let index = 0; index < this.dataList.length; index++) {
      tempArr[index] = index;
    }
    return tempArr;
  }

  public static getJumpPath(position: number): string {
    if (position < 0) {
      return 'pages/Index';
    }
    this.initData();
    if (position >= this.dataList.length) {
      return 'pages/Index';
    }
    return this.dataList[position].jumpPath;
  }

  private static initData() {
    if (!this.dataList) {
      this.dataList = new Array<JumpBean>();
    }
    if (this.dataList.length < 1) {
      let bean = new JumpBean('pages/Reconnect');
      this.dataList.push(bean)

      let bean0 = new JumpBean('pages/HttpsPlayer');
      this.dataList.push(bean0)

      let bean1 = new JumpBean('pages/IjkVideoPlayerPage');
      this.dataList.push(bean1)

      let bean2 = new JumpBean('pages/DiyCacheSizePage');
      this.dataList.push(bean2)

      let bean3 = new JumpBean('pages/DiyCacheCountPage');
      this.dataList.push(bean3)

      let bean4 = new JumpBean('pages/DiyCacheHeaderPage');
      this.dataList.push(bean4)

      let bean5 = new JumpBean('pages/DiyFileNameGeneratorPage');
      this.dataList.push(bean5)

      let cacheSizeBean = new JumpBean('pages/CacheSizeDemo');
      this.dataList.push(cacheSizeBean)

      let getRequestTestBean = new JumpBean('pages/GetRequestTestDemo');
      this.dataList.push(getRequestTestBean)

    }
  }
}

