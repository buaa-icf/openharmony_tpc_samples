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

const TAG: string = 'BlufiAES';

export class BlufiAES {
  private readonly mKey: Uint8Array;
  private readonly mIV: cryptoFramework.IvParamsSpec;
  private readonly mTransformation: string;
  private readonly mEncryptCipher: cryptoFramework.Cipher;
  private readonly mDecryptCipher: cryptoFramework.Cipher;

  constructor(key: Uint8Array, transformation: string, iv: cryptoFramework.IvParamsSpec) {
    this.mKey = key;
    this.mIV = iv ?? null;
    this.mTransformation = transformation;
    this.mEncryptCipher = this.createEncryptCipher();
    this.mDecryptCipher = this.createDecryptCipher();
  }

  /*
   * 加密异步方法
   * @param content 需要的加密数据
   * @return Promise<cryptoFramework.DataBlob | null>
   **/
  public async encrypt(content: cryptoFramework.DataBlob): Promise<cryptoFramework.DataBlob | null> {
    try {
      let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher(this.mTransformation);
      let symKeyGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
      let symKey: cryptoFramework.SymKey | null = await symKeyGenerator.convertKey({ data: this.mKey });
      if (this.mIV === null) {
        await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, null);
      } else {
        await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, this.mIV);
      }
      if (!cipher) {
        cipher = this.mEncryptCipher;
      }
      return await cipher.doFinal(content);
    } catch (err) {
      LogUtil.error(TAG, `encrypt-Failed to finalize cipher, ${err.code}`);
      return null;
    }
  }

  /*
   * 加密同步方法
   * @param content 需要的加密数据
   * @return Promise<cryptoFramework.DataBlob | null>
   **/
  public encryptSync(content: cryptoFramework.DataBlob): cryptoFramework.DataBlob {
    try {
      let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher(this.mTransformation);
      let symKeyGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
      let symKey: cryptoFramework.SymKey | null = symKeyGenerator.convertKeySync({ data: this.mKey });
      if (this.mIV === null) {
        cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, null);
      } else {
        cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, this.mIV);
      }
      if (!cipher) {
        cipher = this.mEncryptCipher;
      }
      let data = cipher.doFinalSync(content);
      return data;
    } catch (err) {
      LogUtil.error(TAG, `encryptSync-Failed to finalize cipher, ${err.code}`);
      return null;
    }
  }

  /*
   * 解密异步
   * @param content 需要的解密数据
   * @return Promise<cryptoFramework.DataBlob | null>
   **/
  public async decrypt(content: cryptoFramework.DataBlob): Promise<cryptoFramework.DataBlob | null> {
    try {
      let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher(this.mTransformation);
      let symKeyGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
      let symKey: cryptoFramework.SymKey | null = await symKeyGenerator.convertKey({ data: this.mKey });
      if (this.mIV === null) {
        await cipher.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, null);
      } else {
        await cipher.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, this.mIV);
      }
      if (!cipher) {
        cipher = this.mDecryptCipher;
      }
      return await cipher.doFinal(content);
    } catch (err) {
      LogUtil.error(TAG, `decrypt-Failed to finalize cipher, ${err.code}`);
      return null;
    }
  }

  /*
   * 解密同步
   * @param content 需要的解密数据
   * @return Promise<cryptoFramework.DataBlob | null>
   **/
  public decryptSync(content: cryptoFramework.DataBlob): cryptoFramework.DataBlob {
    try {
      let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher(this.mTransformation);
      let symKeyGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
      let symKey: cryptoFramework.SymKey | null = symKeyGenerator.convertKeySync({ data: this.mKey });
      if (this.mIV === null) {
        cipher.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, null);
      } else {
        cipher.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, this.mIV);
      }
      if (!cipher) {
        cipher = this.mDecryptCipher;
      }
      return cipher.doFinalSync(content);
    } catch (error) {
      LogUtil.error(TAG, `decryptSync-Failed to finalize cipher, ${error.code}`);
      return null
    }
  }

  private createEncryptCipher(): cryptoFramework.Cipher {
    try {
      let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher(this.mTransformation);
      let symKeyGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
      let symKey: cryptoFramework.SymKey | null = symKeyGenerator.convertKeySync({ data: this.mKey })
      if (this.mIV === null) {
        cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, null);
      } else {
        cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, this.mIV);
      }
      return cipher;
    } catch (error) {
      LogUtil.error(TAG, `createEncryptCipher-error, ${error.code}`);
      return null;
    }
  }

  private createDecryptCipher(): cryptoFramework.Cipher {
    try {
      let cipher: cryptoFramework.Cipher = cryptoFramework.createCipher(this.mTransformation);
      let symKeyGenerator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES128');
      let symKey: cryptoFramework.SymKey | null = symKeyGenerator.convertKeySync({ data: this.mKey });
      if (this.mIV === null) {
        cipher.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, null);
      } else {
        cipher.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, this.mIV);
      }
      return cipher;
    } catch (error) {
      LogUtil.error(TAG, `createDecryptCipher-error, ${error.code}`);
      return null;
    }
  }
}
