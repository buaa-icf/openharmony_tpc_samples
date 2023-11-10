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
 * Copyright (C) 2012  Joshua M. Clulow <josh@sysmgr.org>
 */

var log = console.log;
import { oddpar } from './common'
import { expandkey } from './common'
import { bintohex } from './common'
// @ts-ignore
const {Buffer} = require('buffer')

import { lmhashbuf } from './smbhash'
import { nthashbuf } from './smbhash'
import cryptoFramework from '@ohos.security.cryptoFramework';


var globalEncodeBuff;

function encodeType1(hostname, ntdomain) {
  hostname = hostname.toUpperCase();
  ntdomain = ntdomain.toUpperCase();
  var hostnamelen = Buffer.byteLength(hostname, 'ascii');
  var ntdomainlen = Buffer.byteLength(ntdomain, 'ascii');

  const ab = new ArrayBuffer(32 + hostnamelen + ntdomainlen);
  var input = Buffer.from(ab);
  let bb = Buffer.from('NTLMSSP').toString('ascii')
  input.write(bb, 0)
  input.writeUInt8(0, 7)
  input.writeUInt8(0x01, 8); // byte type;
  input.fill(0x00, 9, 12); // byte zero[3];
  input.writeUInt16LE(0xb203, 12);
  input.fill(0x00, 14, 16);
  input.writeUInt16LE(ntdomainlen, 16);
  input.writeUInt16LE(ntdomainlen, 18);
  var ntdomainoff = 0x20 + hostnamelen;
  input.writeUInt16LE(ntdomainoff, 20); // short dom_off;
  input.fill(0x00, 22, 24);
  input.writeUInt16LE(hostnamelen, 24);
  input.writeUInt16LE(hostnamelen, 26)
  input.writeUInt16LE(0x20, 28)
  input.fill(0x00, 30, 32);
  let ipBuffer = Buffer.from(hostname).toString('ascii')
  let domainBuff = Buffer.from(ntdomain).toString('ascii')
  input.write(ipBuffer, 0x20);
  input.write(domainBuff, ntdomainoff);
  console.info("smb setup_step0 :" + JSON.stringify(input))

  return input;
}


/*
 *
 */
function decodeType2(buf) {
  var temBuf = Buffer.from(buf);
  var proto = temBuf.toString('ascii', 0, 7)
  if (temBuf[7] !== 0x00 || proto !== 'NTLMSSP')
  throw new Error('magic was not NTLMSSP');

  var type = temBuf.readUInt8(8);
  if (type !== 0x02)
  throw new Error('message was not NTLMSSP type 0x02');

  var nonce = temBuf.subarray(24, 32);
  return nonce;
}

async function sleep(ms: number) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve('');
    }, ms)
  })
}

export function encodeType3(username, hostname, ntdomain, nonce, password) {
  hostname = hostname.toUpperCase();
  ntdomain = ntdomain.toUpperCase();

  var lmh = Buffer.alloc(21);
  var nth = Buffer.alloc(21);
  let hashbuf = lmhashbuf(password)
  setTimeout(() => {
    hashbuf.copy(lmh)
    lmh.fill(0x00, 16); // null pad to 21 bytes
    console.info('smb encodeType3 lmhashbuf done:' + JSON.stringify(lmh))

    nthashbuf(password).copy(nth);
    nth.fill(0x00, 16); // null pad to 21 bytes
    console.info('smb encodeType3 nthashbuf done:' + JSON.stringify(nth))
  }, 20)

  var lmr;
  var ntr;
  setTimeout(() => {
    console.info("smb handle makeResponseStart")
    lmr = makeResponse(lmh, nonce);
    console.info("smb handle makeResponseEnd")
  }, 40)
  setTimeout(() => {
    console.info("smb handle ntr makeResponseStart")
    ntr = makeResponse(nth, nonce);
    console.info("smb handle  ntr makeResponseEnd")
  }, 70)

  var usernamelen = Buffer.byteLength(username, 'ucs2');
  var hostnamelen = Buffer.byteLength(hostname, 'ucs2');
  var ntdomainlen = Buffer.byteLength(ntdomain, 'ucs2');
  var lmrlen = 0x18;
  var ntrlen = 0x18;

  var ntdomainoff = 0x40;
  var usernameoff = ntdomainoff + ntdomainlen;
  var hostnameoff = usernameoff + usernamelen;
  var lmroff = hostnameoff + hostnamelen;
  var ntroff = lmroff + lmrlen;

  var pos = 0;
  var msg_len = 64 + ntdomainlen + usernamelen + hostnamelen + lmrlen + ntrlen;
  var buf = Buffer.alloc(msg_len);

  setTimeout(() => {

    console.info("smb handle makeResponseEnd lmr:" + JSON.stringify(lmr))
    console.info("smb handle makeResponseEnd ntr:" + JSON.stringify(ntr))
    let bb = Buffer.from('NTLMSSP').toString('ascii')
    buf.write(bb, pos); // byte protocol[8];
    pos += 7;
    buf.writeUInt8(0, pos);
    pos++;

    buf.writeUInt8(0x03, pos); // byte type;
    pos++;

    buf.fill(0x00, pos, pos + 3); // byte zero[3];
    pos += 3;

    buf.writeUInt16LE(lmrlen, pos); // short lm_resp_len;
    pos += 2;
    buf.writeUInt16LE(lmrlen, pos); // short lm_resp_len;
    pos += 2;
    buf.writeUInt16LE(lmroff, pos); // short lm_resp_off;
    pos += 2;
    buf.fill(0x00, pos, pos + 2); // byte zero[2];
    pos += 2;

    buf.writeUInt16LE(ntrlen, pos); // short nt_resp_len;
    pos += 2;
    buf.writeUInt16LE(ntrlen, pos); // short nt_resp_len;
    pos += 2;
    buf.writeUInt16LE(ntroff, pos); // short nt_resp_off;
    pos += 2;
    buf.fill(0x00, pos, pos + 2); // byte zero[2];
    pos += 2;

    buf.writeUInt16LE(ntdomainlen, pos); // short dom_len;
    pos += 2;
    buf.writeUInt16LE(ntdomainlen, pos); // short dom_len;
    pos += 2;
    buf.writeUInt16LE(ntdomainoff, pos); // short dom_off;
    pos += 2;
    buf.fill(0x00, pos, pos + 2); // byte zero[2];
    pos += 2;

    buf.writeUInt16LE(usernamelen, pos); // short user_len;
    pos += 2;
    buf.writeUInt16LE(usernamelen, pos); // short user_len;
    pos += 2;
    buf.writeUInt16LE(usernameoff, pos); // short user_off;
    pos += 2;
    buf.fill(0x00, pos, pos + 2); // byte zero[2];
    pos += 2;

    buf.writeUInt16LE(hostnamelen, pos); // short host_len;
    pos += 2;
    buf.writeUInt16LE(hostnamelen, pos); // short host_len;
    pos += 2;
    buf.writeUInt16LE(hostnameoff, pos); // short host_off;
    pos += 2;
    buf.fill(0x00, pos, pos + 6); // byte zero[6];
    pos += 6;

    buf.writeUInt16LE(msg_len, pos); // short msg_len;
    pos += 2;
    buf.fill(0x00, pos, pos + 2); // byte zero[2];
    pos += 2;

    buf.writeUInt16LE(0x8201, pos); // short flags;
    pos += 2;
    buf.fill(0x00, pos, pos + 2); // byte zero[2];
    pos += 2;

    buf.write(ntdomain, ntdomainoff, ntdomainlen, 'ucs2');
    buf.write(username, usernameoff, usernamelen, 'ucs2');
    buf.write(hostname, hostnameoff, hostnamelen, 'ucs2');
    lmr.copy(buf, lmroff, 0, lmrlen);
    ntr.copy(buf, ntroff, 0, ntrlen);
    globalEncodeBuff = buf;
  }, 110)


  return buf;
}

export function getGlobBuff() {
  return globalEncodeBuff;
}

function makeResponse(hash, nonce) {
  var out = Buffer.alloc(24);
  var pos = 0;


  for (var i = 0; i < 3; i++) {
    var cipher = cryptoFramework.createCipher('3DES192|ECB');
    let symKeyGenerator = cryptoFramework.createSymKeyGenerator('3DES192')
    var keybuf = oddpar(expandkey(hash.subarray(i * 7, i * 7 + 7)));

    symKeyGenerator.convertKey(genKeyMaterialBlob(keybuf)).then((symKey) => {

      cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, null, (err,) => {
        if (err) {
          console.error('Failed to init cipher');
          return;
        }
        console.log('smb Init cipher success');
        // 此处进行update等后续操作
      })

      let plainText = { data: stringToUint8Array(nonce.toString('binary')) };
      cipher.update(plainText, (err, output) => { // 加密过程举例
        if (err) {
          console.error('Failed to update cipher');
          return;
        }
        if (pos == 0) Buffer.from(output.data).copy(out);
        else Buffer.from(output.data).copy(out, pos, 0, pos)
        pos += 8;
      })

    })
  }
  return out;

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

