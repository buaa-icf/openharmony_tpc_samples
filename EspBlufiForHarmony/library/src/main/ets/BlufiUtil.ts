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

export class BlufiUtil {
  private static SEXADECIMAL_NUMBER_SYSTEM: number = 16;
  private static TWO: number = 2;
  /*
   * uInt8Array To hex string
   * @param fileData
   * @return string
   * */
  public static uint8ArrayToHex = (fileData: Uint8Array): string => {
    let hexStr: string = '';

    fileData.forEach((data) => {
      let hex = data.toString(BlufiUtil.SEXADECIMAL_NUMBER_SYSTEM);
      if (hex.length === 1) {
        hex = '0' + hex;
      }
      hexStr += hex;
    });

    return hexStr;
  }

  /*
   * uInt8Array To string
   * @param str
   * @return string
   * */
  public static uint8ArrayToString = (fileData: Uint8Array): string => {
    let dataString: string = '';
    fileData.forEach(byte => {
      dataString += String.fromCharCode(byte);
    });
    return dataString;
  }

  /*
   * Hex string To uInt8Array
   * @param str
   * @param len
   * @return Uint8Array
   * */
  public static stringToUint8Array = (str: string, len?: number): Uint8Array => {
    let arr: number[] = [];
    if (len === undefined) {
      len = str.length;
    }

    str.split('').forEach((char, i) => {
      if (i < len) {
        arr.push(char.charCodeAt(0));
      } else {
        arr.push(0);
      }
    });
    let tmpUint8Array: Uint8Array = new Uint8Array(arr);
    return tmpUint8Array;
  }

  /*
 * Hex string To IntArray
 * @param hexStr
 * @return number[]
 * */
  static hexToIntArray = (hexStr: string): number[] => {
    let arr: number[] = [];
    if (hexStr.length % BlufiUtil.TWO != 0) {
      hexStr = '0' + hexStr;
    }
    for (let i = 0; i < hexStr.length; i += BlufiUtil.TWO) {
      arr.push(parseInt(hexStr.substring(i, i + BlufiUtil.TWO), BlufiUtil.SEXADECIMAL_NUMBER_SYSTEM));
    }
    return arr;
  }


  /*
   * check string is empty
   * @param data
   * @return boolean
   * */
  public static isEmpty = (data: string): boolean => {
    if (!(data === '' || data === null || data === undefined || data === 'null' || data === 'undefined')) {
      return false;
    }
    return true;
  }

  /*
   * promise timeout
   * @param ms
   * @return promise<void>
   * */
  public static sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  /*
   * number to format 0~255
   * @param b
   * @return promise<void>
   * */
  public static toInt(b: number) {
    return b & 0xff;
  }
}