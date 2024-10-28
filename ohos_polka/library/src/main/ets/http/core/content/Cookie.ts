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

const DEFAULT_EXPIRE_NUM: number = 30;

/**
 * 提供一个基本的cookie类
 */
export default class Cookie {
  protected name: string;
  protected value: string;
  protected expires: string | number;

  /**
   * @param names: cookie的key
   * @param values: cookie的value
   * @param expire: cookie的过期时间
   **/
  constructor(names: string, values: string, expire?: number | string) {
    this.name = names;
    this.value = values;
    this.expires = this.getExpires(expire ? expire : DEFAULT_EXPIRE_NUM);
  }

  /**
   * 将输入数字转换为日期格式
   *
   * @param days: number
   * @return 返回一个toUTCString时间字符串
   **/
  public getHTTPTime(days: number): string {
    const nowTime: Date = new Date();
    nowTime.setUTCDate(days);
    return nowTime.toUTCString();
  }

  /**
   * 获取一个Cookie类的字符串
   *
   * @return 返回一个cookie字符串
   **/
  public getHTTPHeader(): string {
    return `${this.name}=${this.value};expires=${this.expires}`;
  }

  /**
   * 格式化cookie过期时间
   *
   * @param expire: cookie的过期时间
   * @return 如果值是日期格式为数字则转换为日期格式的字符串，否则直接返回该字符串
   **/
  private getExpires(expire: number | string): string {
    if (typeof expire === 'number') {
      return this.getHTTPTime(expire);
    }
    return expire;
  }
}