/*
 * (The MIT License)

 * Copyright (c) 2021 Huawei Device Co., Ltd.

 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * 'Software'), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:

 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


import { oddpar } from './common'
import { expandkey } from './common'
import { bintohex } from './common'
import {Buffer} from '@ohos/Buffer'
import { MD4 } from '../crypto/md4'
import cryptoFramework from '@ohos.security.cryptoFramework';
/*
 * Generate the LM Hash
 */
export function lmhashbuf(inputstr) {
  /* ASCII --> uppercase */
  var x = inputstr.substring(0, 14).toUpperCase();
  var xl = Buffer.byteLength(x, 'ascii');

  /* null pad to 14 bytes */
  var y = new Buffer(14);

  y.write(x, 0, xl, 'ascii');
  y.fill(0, xl);

  // @ts-ignore
  let pandKey = y.slice(0, 7);
  // @ts-ignore
  let pandKey2 = y.slice(7, 14);

  /* insert odd parity bits in key */
  var halves = [
    oddpar(expandkey(pandKey)),
    oddpar(expandkey(pandKey2))
  ];
  /* DES encrypt magic number "KGS!@#$%" to two
   * 8-byte ciphertexts, (ECB, no padding)
   */
  var buf = new Buffer(16);
  var pos = 0;
  halves.forEach((z)=>{
    var cipher = cryptoFramework.createCipher('3DES192|ECB');
    // [82,167,211,200,115,201,196,100]
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator('3DES192')
    symKeyGenerator.convertKey(genKeyMaterialBlob(z)).then((symKey)=>{
      cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, null).then(()=>{
        let plainText = { data:stringToUint8Array('KGS!@#$%') };
        cipher.update(plainText, (err, output) => { // 加密过程举例
          if (err) {
            console.error('Failed to update cipher');
            return;
          }

          if(pos == 0) Buffer.from(output.data).copy(buf);
          else Buffer.from(output.data).copy(buf,pos,0,pos)

          //            buf.write(Buffer.from(output.data).toString('binary'),pos)
          pos += 8
          // 此处进行doFinal等后续操作
        })
      })
    })
  })
  return buf;
}


function stringToUint8Array(str) {
  let arr = [];
  for (let i = 0, j = str.length; i < j; ++i) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}


function genKeyMaterialBlob(z) {
  let arr = [z[0], z[1], z[2], z[3], z[4], z[5], z[6], z[7],
  0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0]; // keyLen = 192 (24 bytes)
  let keyMaterial = new Uint8Array(arr);
  return { data: keyMaterial };
}

export function nthashbuf(str) {
  /* take MD4 hash of UCS-2 encoded password */
  var ucs2 = Buffer.from(str, 'ucs2');
  MD4.update(ucs2);
  let tembuf = MD4.digest();
  return tembuf;
}

export function lmhash(is) {
  return bintohex(lmhashbuf(is));
}

export function nthash(is) {
  return bintohex(nthashbuf(is));
}

