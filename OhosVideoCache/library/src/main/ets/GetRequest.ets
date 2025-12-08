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

import buffer from '@ohos.buffer';
import Preconditions from './Preconditions';
import { LogUtil } from './LogUtil';

export default class GetRequest {
  private RANGE_HEADER_PATTERN: RegExp = new RegExp("range:[ ]?bytes=(\\d*)-", "i");
  private URL_PATTERN: RegExp = new RegExp("(GET|HEAD) /(.*) HTTP");
  public uri: string;
  public rangeOffset: number;
  public partial: boolean;
  public method: string; // 请求方法: GET 或 HEAD

  constructor(request: string) {
    Preconditions.checkNotNull(request);
    let offset = this.findRangeOffset(request);
    this.rangeOffset = Math.max(0, offset);
    this.partial = offset >= 0;
    this.method = this.findMethod(request);
    this.uri = this.findUri(request);
  }

  public static read(inputStream: ArrayBuffer): GetRequest {
    let stringRequest: string = buffer.from(inputStream).toString("UTF-8");
    return new GetRequest(stringRequest);
  }

  private findRangeOffset(request: string): number {
    try {
      let matcher = this.RANGE_HEADER_PATTERN.exec(request);
      if (!matcher || matcher.length < 2) return -1;
      let rangeValue = matcher[1];
      return Number.parseInt(rangeValue);
    } catch (err) {
      LogUtil.error('findRangeOffset error: ' + JSON.stringify(err));
    }
    return -1;
  }

  private findMethod(request: string): string {
    let matcher = this.URL_PATTERN.exec(request);
    // matcher[0]: 完整匹配
    // matcher[1]: 请求方法 (GET|HEAD)
    // matcher[2]: URL路径
    if (!matcher || matcher.length < 2 || (matcher.length >= 2 && !matcher[1])) {
      throw new Error('Invalid request: method not found!');
    }
    return matcher[1];
  }

  private findUri(request: string): string {
    let matcher = this.URL_PATTERN.exec(request);
    // matcher[0]: 完整匹配
    // matcher[1]: 请求方法 (GET|HEAD)
    // matcher[2]: URL路径
    if (!matcher || matcher.length < 3 || (matcher.length >= 3 && !matcher[2])) {
      throw new Error("Invalid request `" + request + "`: url not found!");
    }
    return matcher[2];
  }


  public toString(): string {
    return "GetRequest{" +
      "method=" + this.method +
      ", rangeOffset=" + this.rangeOffset +
      ", partial=" + this.partial +
      ", uri='" + this.uri + '\'' +
      '}';
  }
}