/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import crc32 from './crc32';
import { APNG, Frame } from './structs';

const errNotPNG = new Error('Not a PNG');
const errNotAPNG = new Error('Not an animated PNG');

export function isNotPNG(err) {
  return err === errNotPNG;
}

export function isNotAPNG(err) {
  return err === errNotAPNG;
}

const PNGSignature = new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);

export default function parseAPNG(buffer) {
  const bytes = new Uint8Array(buffer);

  if (Array.prototype.some.call(PNGSignature, (b, i) => b !== bytes[i])) {
    return errNotPNG;
  }

  let isAnimated = false;
  eachChunk(bytes, type =>!(isAnimated = (type === 'acTL')));
  if (!isAnimated) {
    return errNotAPNG;
  }

  const
    preDataParts = [],
    postDataParts = [];
  let
    headerDataBytes = null,
    frame = null,
    frameNumber = 0,
    apng = new APNG();

  eachChunk(bytes, (type, bytes, off, length) => {
    const dv = new DataView(bytes.buffer);
    switch (type) {
      case 'IHDR':
        headerDataBytes = bytes.subarray(off + 8, off + 8 + length);
        apng.width = dv.getUint32(off + 8);
        apng.height = dv.getUint32(off + 12);
        break;
      case 'acTL':
        apng.numPlays = dv.getUint32(off + 8 + 4);
        break;
      case 'fcTL':
        if (frame) {
          apng.frames.push(frame);
          frameNumber++;
        }
        frame = new Frame();
        frame.width = dv.getUint32(off + 8 + 4);
        frame.height = dv.getUint32(off + 8 + 8);
        frame.left = dv.getUint32(off + 8 + 12);
        frame.top = dv.getUint32(off + 8 + 16);
        var delayN = dv.getUint16(off + 8 + 20);
        var delayD = dv.getUint16(off + 8 + 22);
        if (delayD === 0) {
          delayD = 100;
        }
        frame.delay = 1000 * delayN / delayD;
        if (frame.delay <= 10) {
          frame.delay = 100;
        }
        apng.playTime += frame.delay;
        frame.disposeOp = dv.getUint8(off + 8 + 24);
        frame.blendOp = dv.getUint8(off + 8 + 25);
        frame.dataParts = [];
        if (frameNumber === 0 && frame.disposeOp === 2) {
          frame.disposeOp = 1;
        }
        break;
      case 'fdAT':
        if (frame) {
          frame.dataParts.push(bytes.subarray(off + 8 + 4, off + 8 + length));
        }
        break;
      case 'IDAT':
        if (frame) {
          frame.dataParts.push(bytes.subarray(off + 8, off + 8 + length));
        }
        break;
      case 'IEND':
        postDataParts.push(subBuffer(bytes, off, 12 + length));
        break;
      default:
        preDataParts.push(subBuffer(bytes, off, 12 + length));
    }
  });

  if (frame) {
    apng.frames.push(frame);
  }

  if (apng.frames.length == 0) {
    return errNotAPNG;
  }

  const preBlob = new Blob(preDataParts),
    postBlob = new Blob(postDataParts);

  apng.frames.forEach(frame => {
    var bb = [];
    bb.push(PNGSignature);
    headerDataBytes.set(makeDWordArray(frame.width), 0);
    headerDataBytes.set(makeDWordArray(frame.height), 4);
    bb.push(makeChunkBytes('IHDR', headerDataBytes));
    bb.push(preBlob);
    frame.dataParts.forEach(p => bb.push(makeChunkBytes('IDAT', p)));
    bb.push(postBlob);
    frame.imageData = new Blob(bb, {
      'type': 'image/png'
    });
    delete frame.dataParts;
    bb = null;
  });

  return apng;
}

function eachChunk(bytes, callback) {
  const dv = new DataView(bytes.buffer);
  let off = 8, type, length, res;
  do {
    length = dv.getUint32(off);
    type = readString(bytes, off + 4, 4);
    res = callback(type, bytes, off, length);
    off += 12 + length;
  } while (res !== false && type != 'IEND' && off < bytes.length);
}

function readString(bytes, off, length) {
  const chars = Array.prototype.slice.call(bytes.subarray(off, off + length));
  return String.fromCharCode.apply(String, chars);
}

function makeStringArray(x) {
  const res = new Uint8Array(x.length);
  for (let i = 0; i < x.length; i++) {
    res[i] = x.charCodeAt(i);
  }
  return res;
}

function subBuffer(bytes, start, length) {
  const a = new Uint8Array(length);
  a.set(bytes.subarray(start, start + length));
  return a;
}

var makeChunkBytes = function (type, dataBytes) {
  const crcLen = type.length + dataBytes.length;
  const bytes = new Uint8Array(crcLen + 8);
  const dv = new DataView(bytes.buffer);

  dv.setUint32(0, dataBytes.length);
  bytes.set(makeStringArray(type), 4);
  bytes.set(dataBytes, 8);
  var crc = crc32(bytes, 4, crcLen);
  dv.setUint32(crcLen + 4, crc);
  return bytes;
};

var makeDWordArray = function (x) {
  return new Uint8Array([(x >>> 24) & 0xff, (x >>> 16) & 0xff, (x >>> 8) & 0xff, x & 0xff]);
};
