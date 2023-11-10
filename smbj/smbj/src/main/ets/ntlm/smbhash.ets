/*
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * Copyright (C) 2011-2012  Joshua M. Clulow <josh@sysmgr.org>
 */


import { oddpar } from './common'
import { expandkey } from './common'
import { bintohex } from './common'
// @ts-ignore
const {Buffer} = require('buffer')
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

