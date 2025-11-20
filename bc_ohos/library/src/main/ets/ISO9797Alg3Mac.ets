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

import { CryptoJS } from '@ohos/crypto-js'
import { BlockCipherPadding } from './Padding'
import { KeyParameter, ParametersWithIV } from './Params';
import { LogUtil } from './utils/LogUtil'

/**
 * ISO 9797 Algorithm 3 MAC 实现
 * 基于 DES 的 CBC 块加密 MAC，符合 ISO9797 标准，算法 3（ANSI X9.19 Retail MAC）
 */
class ISO9797Alg3Mac {
  // mac值: 存储上一个块加密后的结果,在CBC模式中,每个新块都会先与这个值进行异或
  private mac: Uint8Array;
  // 缓冲区: 用于存储当前块的数据,你输入了 5 个字节,先放这里 等凑够 8 个字节了再处理
  private buf: Uint8Array;
  // 缓冲区偏移量: 记录 buf 里已经存了多少字节.例如:bufOff = 3 表示 buf 里有 3 个字节了,还差 5 个凑满
  private bufOff: number;
  // 填充方案: 决定了不足 8 字节时如何填充,null 表示用零填充
  private padding: BlockCipherPadding | null;
  // 第一个 DES 密钥（K1）用于 CBC 加密的主密钥,密钥的前 8 字节
  private key1: Uint8Array | null;
  // 第二个 DES 密钥（K2）用于 CBC 模式解密时使用的密钥,密钥的第 9 字节到第 16 字节
  private key2: Uint8Array | null;
  // 第三个 DES 密钥（K3）用于 CBC 模式最后一步的加密,如果是 16 字节密钥,则与第一个密钥K1相同如果是 24 字节密钥,则是密钥的第 17 字节到第 24 字节
  private key3: Uint8Array | null;
  // 初始向量: CBC 模式下的第一个块的初始向量,CBC 模式下,第一个块的密文结果将作为第二个块的明文输入,如果没有提供，就用全零
  private iv: Uint8Array | null;
  // 认证码长度: 通常是 8 字节,也可以设置为 4 字节
  private macSize: number;
  // 块大小: DES 固定是 8 字节
  private blockSize: number;

  /**
   * 创建基于 CBC 块加密的 Retail-MAC
   * 这将生成块大小长度的认证码
   */
  constructor()

  constructor(padding: BlockCipherPadding | null)

  constructor(macSizeInBits: number)

  constructor(macSizeInBits: number, padding: BlockCipherPadding | null)

  constructor(arg1?: number | BlockCipherPadding | null, arg2?: BlockCipherPadding | null) {
    this.blockSize = 8; // DES 块大小

    if (arg1 === undefined) {
      // 无参构造：使用默认 MAC 大小（块大小）
      this.macSize = this.blockSize;
      this.padding = null;
    } else if (typeof arg1 === 'number') {
      // MAC大小必须是8的倍数
      if ((arg1 % 8) !== 0) {
        throw new Error('MAC大小必须是8的倍数');
      }
      this.macSize = arg1 / 8;
      this.padding = arg2 !== undefined ? arg2 : null;
    } else {
      // padding
      this.macSize = this.blockSize;
      this.padding = arg1;
    }

    this.mac = new Uint8Array(this.blockSize);
    this.buf = new Uint8Array(this.blockSize);
    this.bufOff = 0;
    this.key1 = null;
    this.key2 = null;
    this.key3 = null;
    this.iv = null;
  }

  /**
   * 获取算法名称
   * @returns 算法名称
   */
  getAlgorithmName(): string {
    return 'ISO9797Alg3';
  }

  /**
   * 初始化 MAC
   * @param params 密钥参数或带 IV 的参数
   */
  init(params: KeyParameter | ParametersWithIV): void {
    // 先设置 IV，再调用 reset()
    let kp: KeyParameter;
    const paramsWithIV = params as ParametersWithIV;
    if (paramsWithIV.parameters !== undefined && paramsWithIV.iv !== undefined) {
      // ParametersWithIV
      kp = paramsWithIV.parameters;
      this.iv = paramsWithIV.iv;
      // 验证 IV 长度必须与块大小相同
      if (this.iv.length !== this.blockSize) {
        throw new Error('初始化向量必须与块大小相同');
      }
    } else {
      // KeyParameter
      kp = params as KeyParameter;
      this.iv = null;
    }

    // 现在调用 reset()，会正确使用 IV
    this.reset();

    const keyValue: Uint8Array = kp.key;

    if (keyValue.length === 16) {
      // 双长度 DES 密钥
      this.key1 = keyValue.slice(0, 8);
      this.key2 = keyValue.slice(8, 16);
      this.key3 = this.key1; // K3 = K1
    } else if (keyValue.length === 24) {
      // 三长度 DES 密钥
      this.key1 = keyValue.slice(0, 8);
      this.key2 = keyValue.slice(8, 16);
      this.key3 = keyValue.slice(16, 24);
    } else {
      throw new Error('密钥必须是112位或168位长');
    }
  }

  /**
   * 获取 MAC 大小
   * @returns MAC 大小（字节）
   */
  getMacSize(): number {
    return this.macSize;
  }

  /**
   * 更新 MAC（单字节）
   * @param input 输入字节
   */
  updateByte(input: number): void {
    if (this.bufOff === this.buf.length) {
      this.processBlock();
      this.bufOff = 0;
    }
    this.buf[this.bufOff++] = input & 0xFF;
  }

  /**
   * 更新 MAC（字节数组）
   * @param input 输入字节数组
   * @param inOff 起始偏移,从 input 的哪个位置开始读取
   * @param len 长度,要读取多少个字节
   */
  update(input: Uint8Array, inOff: number, len: number): void {
    if (len < 0) {
      return LogUtil.error('输入长度不能为负数');
    }
    // 缓冲区剩余空间
    let gapLen: number = this.blockSize - this.bufOff;

    // 判断输入数据是否超过缓冲区剩余空间
    if (len > gapLen) {
      // 填充缓冲区并处理
      this.buf.set(input.slice(inOff, inOff + gapLen), this.bufOff);
      this.processBlock();
      this.bufOff = 0;
      len -= gapLen; // 剩余待处理的字节数
      inOff += gapLen; // 移动输入位置

      // 循环处理完整的块（每次8字节）
      while (len > this.blockSize) {
        this.buf.set(input.slice(inOff, inOff + this.blockSize), 0);
        this.processBlock();
        len -= this.blockSize;
        inOff += this.blockSize;
      }
      // 循环结束后，len < 8，剩下的不够一个完整块
    }

    // 复制剩余数据到缓冲区（等待下次凑满）
    this.buf.set(input.slice(inOff, inOff + len), this.bufOff);
    this.bufOff += len;
  }

  /**
   * 完成 MAC 计算
   * @param out 输出缓冲区
   * @param outOff 输出偏移
   * @returns MAC 大小
   */
  doFinal(out: Uint8Array, outOff: number): number {
    if (this.padding === null) {
      // 零填充
      while (this.bufOff < this.blockSize) {
        this.buf[this.bufOff++] = 0;
      }
    } else {
      if (this.bufOff === this.blockSize) {
        this.processBlock();
        this.bufOff = 0;
      }
      this.padding.addPadding(this.buf, this.bufOff);
    }

    // 处理最后一个块
    this.processBlock();

    // Algorithm 3 的核心：Encrypt-Decrypt-Encrypt
    // 使用 K2 解密，然后使用 K3 加密
    if (this.key2 !== null && this.key3 !== null) {
      this.mac = this.desDecrypt(this.mac, this.key2);
      this.mac = this.desEncrypt(this.mac, this.key3);
    }

    // 复制 MAC 到输出
    out.set(this.mac.slice(0, this.macSize), outOff);

    this.reset();

    return this.macSize;
  }

  /**
   * 重置 MAC 生成器
   */
  reset(): void {
    // 清空缓冲区
    for (let i = 0; i < this.buf.length; i++) {
      this.buf[i] = 0;
    }
    // 重置偏移量 - bufOff = 0，表示缓冲区是空的
    this.bufOff = 0;

    // 初始化 MAC 为 IV（如果有），否则为零
    if (this.iv !== null) {
      for (let i = 0; i < this.blockSize && i < this.iv.length; i++) {
        this.mac[i] = this.iv[i];
      }
    } else {
      for (let i = 0; i < this.mac.length; i++) {
        this.mac[i] = 0;
      }
    }
  }

  /**
   * 处理一个块（CBC 模式）  每个明文块在加密前，先与前一个密文块进行异或
   */
  private processBlock(): void {
    if (this.key1 === null) {
      return LogUtil.error('MAC未初始化');
    }

    // CBC 模式：buf 与 mac 逐字节异或
    for (let i = 0; i < this.blockSize; i++) {
      // 二进制位运算: 相同为 0，不同为 1
      this.buf[i] ^= this.mac[i];
    }

    // DES 加密
    this.mac = this.desEncrypt(this.buf, this.key1);
  }

  /**
   * DES 加密（ECB 模式，用于单块加密）
   * 注意：我们已经在 processBlock() 中手动实现了 CBC 逻辑，
   * 这里只需要进行单块 ECB 加密，不能再使用 CBC 模式！
   */
  private desEncrypt(data: Uint8Array, key: Uint8Array): Uint8Array {
    const keyWords: CryptoJS.lib.WordArray = this.bytesToWordArray(key);
    const dataWords: CryptoJS.lib.WordArray = this.bytesToWordArray(data);

    const encrypted: CryptoJS.lib.CipherParams = CryptoJS.DES.encrypt(dataWords, keyWords, {
      mode: CryptoJS.mode.ECB, // ✓ 必须使用 ECB 模式
      padding: CryptoJS.pad.NoPadding
    })

    return this.wordArrayToBytes(encrypted.ciphertext);
  }

  /**
   * DES 解密
   */
  private desDecrypt(data: Uint8Array, key: Uint8Array): Uint8Array {
    const keyWords: CryptoJS.lib.WordArray = this.bytesToWordArray(key);
    const dataWords: CryptoJS.lib.WordArray = this.bytesToWordArray(data);

    const decrypted: CryptoJS.lib.WordArray = CryptoJS.DES.decrypt(
      CryptoJS.lib.CipherParams.create({ ciphertext: dataWords }),
      keyWords,
      {
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.NoPadding
      }
    )

    return this.wordArrayToBytes(decrypted);
  }

  /**
   * Uint8Array 转 WordArray
   */
  private bytesToWordArray(bytes: Uint8Array): CryptoJS.lib.WordArray {
    const words: number[] = [];
    for (let i = 0; i < bytes.length; i += 4) {
      let word = 0;
      for (let j = 0; j < 4 && i + j < bytes.length; j++) {
        word |= bytes[i + j] << (24 - j * 8);
      }
      words.push(word);
    }
    return CryptoJS.lib.WordArray.create(words, bytes.length);
  }

  /**
   * WordArray 转 Uint8Array
   */
  private wordArrayToBytes(wordArray: CryptoJS.lib.WordArray): Uint8Array {
    const words: number[] = wordArray.words;
    const sigBytes: number = wordArray.sigBytes;
    const bytes: Uint8Array = new Uint8Array(sigBytes);

    for (let i = 0; i < sigBytes; i++) {
      const wordIndex: number = Math.floor(i / 4);
      const byteIndex: number = i % 4;
      bytes[i] = (words[wordIndex] >>> (24 - byteIndex * 8)) & 0xFF;
    }

    return bytes;
  }
}

export default ISO9797Alg3Mac;

export { ISO9797Alg3Mac };
