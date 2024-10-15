/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import cryptoFramework from '@ohos.security.cryptoFramework';
import LogUtil from '../Logger';

const TAG: string = 'BlufiMD5';

export class BlufiMD5 {
  /*
   * 创建MD5数据
   * @param data 需要加密的数据
   * @return Promise<Uint8Array>
   **/
  public static async getMD5Bytes(data: Uint8Array): Promise<Uint8Array> {
    try {
      let mdAlgName: string = 'MD5';
      let md: cryptoFramework.Md = cryptoFramework.createMd(mdAlgName);
      await md.update({ data });
      let mdResult: cryptoFramework.DataBlob = await md.digest();
      return mdResult.data;
    } catch (error) {
      LogUtil.error(TAG, `Error calculating MD5:, ${error.code}`);
      return null;
    }
  }
}
