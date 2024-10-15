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

export class BlufiDH {
  private mP: bigint;
  private mG: bigint;

  private mPrivateKey: cryptoFramework.PriKey;
  private mPublicKey: cryptoFramework.PubKey;

  private mSecretKey: Uint8Array;

  constructor() {
    this.createKey();
  }

  /*
   * 随机生成DH非对称密钥KeyPair
   * @return cryptoFramework.KeyPair
   **/
  private static generateKeys(): cryptoFramework.KeyPair {
    try {
      let keyGen: cryptoFramework.AsyKeyGenerator = cryptoFramework.createAsyKeyGenerator('DH_modp1536');
      let keyPairA: cryptoFramework.KeyPair = keyGen.generateKeyPairSync();
      return keyPairA;
    } catch (err) {
      return null;
    }
  }

  /*
   * 获取参数素数
   * @return bigint
   **/
  public getP(): bigint {
    return this.mP;
  }

  /*
   * 获取参数公数
   * @return bigint
   **/
  public getG(): bigint {
    return this.mG;
  }

  /*
   * 获取私钥数据
   * @return Uint8Array
   **/
  public getPrivateKey(): Uint8Array {
    return this.mPrivateKey.getEncoded().data;
  }

  /*
   * 获取公钥数据
   * @return Uint8Array
   **/
  public getPublicKey(): Uint8Array {
    return this.mPublicKey.getEncoded().data;
  }

  /*
   * 获取协商后的密钥数据
   * @return Uint8Array
   **/
  public getSecretKey(): Uint8Array {
    return this.mSecretKey;
  }

  /*
   * 生成共享密钥
   * @param y 需要交换的公钥
   * @return Promise<string>
   **/
  public async generateSecretKey(y: cryptoFramework.DataBlob): Promise<string> {
    if (this.mPrivateKey === null) {
      throw new Error('first createKey function');
    }

    let keyGen: cryptoFramework.AsyKeyGenerator = cryptoFramework.createAsyKeyGenerator('DH_modp1536');
    let keyAgreement: cryptoFramework.KeyAgreement = cryptoFramework.createKeyAgreement('DH_modp1536');
    let keyPair: cryptoFramework.KeyPair = await keyGen.convertKey(y, null);
    let yPuk = keyPair.pubKey;

    // 使用交换的公钥和自身的私钥进行密钥协商
    let secret1: cryptoFramework.DataBlob = await keyAgreement.generateSecret(this.mPrivateKey, yPuk);
    this.mSecretKey = secret1.data;
    return secret1.data.toString();
  }

  /*
   * 创建DH所需的公钥私钥
   *
   **/
  private createKey() {
    let keyPair: cryptoFramework.KeyPair = BlufiDH.generateKeys();
    if (keyPair !== null) {
      this.mPrivateKey = keyPair.priKey as cryptoFramework.PriKey;
      this.mPublicKey = keyPair.pubKey as cryptoFramework.PubKey;
      let mpStr: string = this.mPublicKey.getAsyKeySpec(cryptoFramework.AsyKeySpecItem.DH_P_BN).toString();
      this.mP = BigInt(mpStr);
      let mgStr: string = this.mPublicKey.getAsyKeySpec(cryptoFramework.AsyKeySpecItem.DH_G_BN).toString();
      this.mG = BigInt(mgStr);
    }
  }
}