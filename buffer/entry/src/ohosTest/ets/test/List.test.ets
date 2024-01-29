/**
 *  MIT License
 *
 *  Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import abilityTest from './Ability.test';
import allocTest from './alloc.test';
import arrayBufferTest from './arraybuffer.test';
import asciiTest from './ascii.test';
import badHexTest from './badhex.test';
import byteLengthTest from './byteLength.test';
import comparseOffestTest from './compareOffest.test';
import comparseTest from './comparse.test';
import connectTest from './connect.test';
import includeTest from './includes.test';
import indexOfTest from './indexof.test';
import interatorTest from './interator.test';
import isencodingTest from './isencoding.test';
import sliceTest from './slice.test';
import swapTest from './swap.test';
import bufferTest from './test-buffer.test';
import toJsonTest from './tojson.test';
import toStringTest from './tostring.test';
import unsafeTest from './unsafe.test';
import writeTest from './write.test';
import fillTest from './zeroFill.test';
import fillResetTest from './zeroFillReset.test';

export default function testsuite() {
  abilityTest();
  allocTest()
  arrayBufferTest()
  asciiTest()
  badHexTest()
  byteLengthTest()
  comparseOffestTest()
  comparseTest()
  connectTest()
  includeTest()
  indexOfTest()
  isencodingTest()
  interatorTest()
  unsafeTest()
  sliceTest()
  swapTest()
  toJsonTest()
  toStringTest()
  writeTest()
  fillResetTest()
  fillTest()
  bufferTest()
}