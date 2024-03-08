/*
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import EventSource from '@ohos/eventsource'

export default function abilityTest() {
  describe('sse', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    let url = 'http://localhost:8080/sse';
    let a: string = '';
    let b: string = '';
    it('addEventListener', 0, async (done: Function) => {
      let es: EventSource = new EventSource(url);
      try {
        es.onFailure((e: Record<'message', string>) => {
          b = e.message;
          console.info('-------04------' + b);
          expect(b == "Co11uldn't connect to server").assertTrue();
          done();
        })
        es.addEventListener('server-time', (e: Record<'data', string>) => {
          a = e.data;
          expect(!!a).assertTrue();
          console.info('-------06------')
          done()
        })
      }
      catch (e) {
        console.info('-------01------');
      }
      let nowTime = (new Date()).getTime();
      let endTime = (new Date()).getTime();
      while (endTime - nowTime < 5000) {
        endTime = (new Date()).getTime();
      }
      console.info('-------03------');
    })
    it('removeEventListener', 0, async (done: Function) => {
      let es: EventSource = new EventSource(url);
      try {
        es.onFailure((e: Record<'message', string>) => {
          b = e.message;
          console.info('-------04------' + b);
          expect(b == "Co11uldn't connect to server").assertTrue();
          done();
        })
        es.addEventListener('server-time', (e: Record<'data', string>) => {
          a = e.data;
          expect(!!a).assertTrue();
          console.info('-------06------');
          done();
        })
        es.removeEventListener('server-time', (e: Record<'data', string>) => {
          a = e.data;
          expect(!!e.data).assertFalse();
          done();
        })
      }
      catch (e) {
        console.info('-------01------');
      }
      let nowTime = (new Date()).getTime();
      let endTime = (new Date()).getTime();
      while (endTime - nowTime < 5000) {
        endTime = (new Date()).getTime();
      }
      console.info('-------03------');
    })
    it('close', 0, () => {
      let es = new EventSource(url);
      es.close();
      es.addEventListener('server-time', (e: Record<'data', string>) => {
        expect(!!e.data).assertFalse();
      })
    })
    it('onFailure', 0, async (done: Function) => {
      let es: EventSource = new EventSource(url);
      try {
        es.onFailure((e: Record<'message', string>) => {
          b = e.message;
          console.info('-------04------' + b);
          expect(b == "Co11uldn't connect to server").assertTrue();
          done();
        })
        es.addEventListener('server-time', (e: Record<'data', string>) => {
          a = e.data;
          expect(!!a).assertTrue();
          console.info('-------06------');
          done();
        })
      }
      catch (e) {
        console.info('-------01------');
      }
      let nowTime = (new Date()).getTime();
      let endTime = (new Date()).getTime();
      while (endTime - nowTime < 5000) {
        endTime = (new Date()).getTime();
      }
      console.info('-------03------');
    })
  })
}
