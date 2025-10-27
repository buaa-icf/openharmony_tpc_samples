/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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

/**
 * 填充接口
 */
export interface BlockCipherPadding {
  /**
   * 初始化填充器（如果需要随机数）
   */
  init?(): void;

  /**
   * 获取填充名称
   */
  getPaddingName(): string;

  /**
   * 添加填充字节
   * @param buf 缓冲区
   * @param offset 起始偏移
   * @returns 添加的字节数
   */
  addPadding(buf: Uint8Array, offset: number): number;
}

/**
 * ISO7816-4 填充实现
 * 第一个字节为 0x80，后续字节为 0x00
 */
export class ISO7816d4Padding implements BlockCipherPadding {
  getPaddingName(): string {
    return 'ISO7816-4';
  }

  addPadding(buf: Uint8Array, offset: number): number {
    const added: number = buf.length - offset;
    buf[offset] = 0x80;
    for (let i = offset + 1; i < buf.length; i++) {
      buf[i] = 0x00;
    }
    return added;
  }
}

/**
 * 零字节填充实现
 * 所有填充字节为 0x00
 */
export class ZeroBytePadding implements BlockCipherPadding {
  getPaddingName(): string {
    return 'ZeroByte';
  }

  addPadding(buf: Uint8Array, offset: number): number {
    const added: number = buf.length - offset;
    for (let i = offset; i < buf.length; i++) {
      buf[i] = 0x00;
    }
    return added;
  }
}

/**
 * PKCS7 填充实现 (PKCS#7/PKCS#5)
 * 所有填充字节的值为填充字节数
 * 例如：需要填充 3 个字节，则填充 [0x03, 0x03, 0x03]
 */
export class PKCS7Padding implements BlockCipherPadding {
  getPaddingName(): string {
    return 'PKCS7';
  }

  addPadding(buf: Uint8Array, offset: number): number {
    const code: number = buf.length - offset;
    for (let i = offset; i < buf.length; i++) {
      buf[i] = code;
    }
    return code;
  }
}

/**
 * ISO10126-2 填充实现
 * 填充字节为随机值，最后一个字节为填充长度
 * 例如：需要填充 3 个字节，则填充 [random, random, 0x03]
 */
export class ISO10126d2Padding implements BlockCipherPadding {
  getPaddingName(): string {
    return 'ISO10126-2';
  }

  addPadding(buf: Uint8Array, offset: number): number {
    const code: number = buf.length - offset;

    // 填充随机字节
    while (offset < buf.length - 1) {
      buf[offset] = Math.floor(Math.random() * 256);
      offset++;
    }

    // 最后一个字节为填充长度
    buf[offset] = code;

    return code;
  }
}

/**
 * X9.23 填充实现
 * 填充字节为 0x00 或随机值（如果初始化时启用了随机），最后一个字节为填充长度
 */
export class X923Padding implements BlockCipherPadding {
  private useRandom: boolean = false;

  /**
   * 初始化，启用随机填充
   */
  init(): void {
    this.useRandom = true;
  }

  getPaddingName(): string {
    return 'X9.23';
  }

  addPadding(buf: Uint8Array, offset: number): number {
    const code: number = buf.length - offset;

    // 填充随机字节或零字节
    while (offset < buf.length - 1) {
      if (this.useRandom) {
        buf[offset] = Math.floor(Math.random() * 256);
      } else {
        buf[offset] = 0x00;
      }
      offset++;
    }

    // 最后一个字节为填充长度
    buf[offset] = code;

    return code;
  }
}

/**
 * TBC (Trailing Bit Complement) 填充实现
 * 根据明文最后一个字节的最低位来填充：
 * - 如果最低位为 0，则填充 0xFF
 * - 如果最低位为 1，则填充 0x00
 */
export class TBCPadding implements BlockCipherPadding {
  getPaddingName(): string {
    return 'TBC';
  }

  addPadding(buf: Uint8Array, offset: number): number {
    const count: number = buf.length - offset;
    let code: number;

    // 获取上一个字节的最低位
    if (offset > 0) {
      code = (buf[offset - 1] & 0x01) === 0 ? 0xFF : 0x00;
    } else {
      // 如果 offset 为 0，说明整个块都需要填充，使用上一个块的最后一个字节
      code = (buf[buf.length - 1] & 0x01) === 0 ? 0xFF : 0x00;
    }

    // 填充
    while (offset < buf.length) {
      buf[offset] = code;
      offset++;
    }

    return count;
  }
}