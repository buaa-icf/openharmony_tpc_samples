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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import http from '@ohos.net.http';
import { common } from '@kit.AbilityKit';
import polka, { IncomingMessage, NextFunction, Request, ServerResponse } from 'polka'
import { Methods } from '../../../../../library/src/main/ets/polka/trouter/index.js';

interface SelfRequest extends Request {
  foo: string | number;
  bar: string | number;
  hello: string;
  one: string;
  two: string;
  subgroup: boolean;
  aaa: string;
  bbb: string;
}

const context = getContext(this) as common.UIAbilityContext;
const METHODS = ['GET', 'POST', 'PUT', 'DELETE'];

function foo(req: SelfRequest, res: ServerResponse, next: NextFunction) {
  req.foo = req.foo || 0;
  (req.foo as number) += 250;
  next();
}

function bar(req: SelfRequest, res: ServerResponse, next: NextFunction) {
  req.bar = req.bar || '';
  req.bar += 'bar';
  next();
}

function onError(err: Error, req: SelfRequest, res: ServerResponse, next: NextFunction) {
  expect(err).assertEqual('error');
  expect(req.foo).assertEqual(500);
  expect(req.bar).assertEqual('bar');
  res.statusCode = 400;
  res.end('error');
}

export default function polkaTest() {
  describe('PolkaTest', async () => {
    beforeAll(() => {

    })

    it('polka', 0, () => {
      expect(typeof polka).assertEqual('function');
    })

    it('polka::internals', 0, async () => {
      let app = polka();

      expect(typeof app.server).assertUndefined;
      app.listen();
      expect(app.server).assertInstanceOf('Object');
      app.server?.stop();
      expect(typeof app.parse).assertEqual('function');
      expect(typeof app.handler).assertEqual('function');
      expect(typeof app.use).assertEqual('function');
      expect(typeof app.listen).assertEqual('function');

      METHODS.forEach(k => {
        expect(typeof app[k.toLowerCase()]).assertEqual('function');
      });
    })

    it('polka::usage::basic', 0, () => {
      let app = polka();
      let arr = [['GET','/'], ['POST','/users'], ['PUT','/users/:id']];

      arr.forEach((arr) => {
        let m = arr[0];
        let p = arr[1];
        app.add(m as Methods, p, _ => console.log(`~> matched ${m}(${p}) route`));
      });

      arr.forEach((arr) => {
        let m = arr[0];
        let p = arr[1];
        app.find(m as Methods, p).handlers.forEach(fn => {
          fn()
        });
      });
    })

    it('polka::usage::variadic', 0, async (done: Function) => {
      let app = polka<SelfRequest>({ onError }).use(foo, bar)
        .get('/one', foo, bar, (req: SelfRequest, res: ServerResponse) => {
          expect(req.foo).assertEqual(500);
          expect(req.bar).assertEqual('barbar');
          res.setHeader('Content-Type', "text/plain");
          res.end('one');
        })
        .get('/two', foo, (req, res, next) => {
          expect(req.foo).assertEqual(500);
          expect(req.bar).assertEqual('bar');
          req.hello = 'world';
          next();
        }, (req, res) => {
          expect(req.hello).assertEqual('world');
          expect(req.foo).assertEqual(500);
          res.end('two');
        })
        .get('/err', foo, (req, res, next) => {
          if (true) next('error');
        }, (req, res) => {
          res.end('wut');
        })
        .listen(9990, (e) => {
          console.log('testrunn: ' + e)
        });

      let httpRequest = http.createHttp();
      let opt: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
      }
      // 发送http请求
      const res: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9990/one", opt);
      expect(res.responseCode).assertEqual(200);
      expect(res.result).assertEqual('one');

      const res1: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9990/two", opt);
      expect(res1.responseCode).assertEqual(200);
      expect(res1.result).assertEqual('two');

      const res2: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9990/err", opt);
      expect(res2.responseCode).assertEqual(400);
      expect(res2.result).assertEqual('error');

      app.server?.stop();
      done();
    })

    it('polka::usage::middleware', 0, async (done: Function) => {
      let app = polka<SelfRequest>().use((req: SelfRequest, res: ServerResponse, next: NextFunction) => {
        (req.one='hello') && next();
      }).use('/', (req: SelfRequest, res: ServerResponse, next: NextFunction) => {
        (req.two='world') && next();
      }).use('/about', (req: SelfRequest, res: ServerResponse, next: NextFunction) => {
        expect(req.one).assertEqual('hello');
        expect(req.two).assertEqual('world');
        res.end('About');
      }).use('/subgroup', (req: SelfRequest, res: ServerResponse, next: NextFunction) => {
        req.subgroup = true;
        expect(req.one).assertEqual('hello');
        expect(req.two).assertEqual('world');
        next();
      }).post('/subgroup', (req: SelfRequest, res: ServerResponse, next: NextFunction) => {
        expect(req.subgroup).assertTrue();
        res.setHeader('Content-Type', "text/plain");
        res.end('POST /subgroup');
      }).get('/subgroup/foo', (req: SelfRequest, res: ServerResponse) => {
        expect(req.subgroup).assertTrue();
        res.end('GET /subgroup/foo');
      }).get('/', (req: SelfRequest, res: ServerResponse) => {
        expect(req.one).assertEqual('hello');
        expect(req.two).assertEqual('world');
        res.setHeader('x-type', 'text/foo');
        res.end('Hello');
      }).listen(9991, (e) => {
        console.log('testrunn: ' + e)
      });

      let httpRequest = http.createHttp();
      let opt: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
      }
      // 发送http请求
      const res: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9991/", opt);
      expect(res.responseCode).assertEqual(200);
      expect(res.result).assertEqual('Hello');
      expect(res.header['x-type']).assertEqual('text/foo');

      const res1: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9991/about", opt);
      expect(res1.responseCode).assertEqual(200);
      expect(res1.result).assertEqual('About');

      const res2: http.HttpResponse =
        await httpRequest.request("http://0.0.0.0:9991/subgroup", {
          method: http.RequestMethod.POST,
          extraData: 'data to send',
        });
      expect(res2.responseCode).assertEqual(200);
      expect(res2.result).assertEqual('POST /subgroup');

      const res3: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9991/subgroup/foo", opt);
      expect(res3.responseCode).assertEqual(200);
      expect(res3.result).assertEqual('GET /subgroup/foo');

      app.server?.stop();
      done();
    })

    it('polka::usage::middleware (async)', 0, async (done: Function) => {
      let app = polka<SelfRequest>().use((req: SelfRequest, res: ServerResponse, next: NextFunction) => {
        new Promise<number>((resolve, reject) => {
          resolve(10);
        })
          .then(_ => { req.foo=123 }).then(next);
      }).use((req: SelfRequest, res: ServerResponse, next: NextFunction) => {
        new Promise<number>((resolve, reject) => {
          resolve(1);
        })
          .then(_ => { req.bar=456 }).then(next);
      }).get('/', (req: SelfRequest, res: ServerResponse) => {
        expect(req.foo).assertEqual(123);
        expect(req.bar).assertEqual(456);
        res.setHeader('x-type', 'text/foo');
        res.end('Hello');
      }).listen(9992, (e) => {
        console.log('testrunn: ' + e)
      });

      let httpRequest = http.createHttp();
      let opt: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
      }
      // 发送http请求
      const res: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9992/", opt);
      expect(res.responseCode).assertEqual(200);
      expect(res.result).assertEqual('Hello');
      expect(res.header['x-type']).assertEqual('text/foo');

      app.server?.stop();
      done();
    })

    it('polka::usage::middleware (basenames)', 0, async (done: Function) => {
      let chk = false;
      let aaa = (req: SelfRequest, res: ServerResponse, next: NextFunction) => { req.aaa='aaa';next(); };
      let bbb = (req: SelfRequest, res: ServerResponse, next: NextFunction) => { req.bbb='bbb';next(); };
      let bar = (req: SelfRequest, res: ServerResponse, next: NextFunction) => { req.bar='bar';next(); };
      let ccc = (req: SelfRequest, res: ServerResponse, next: NextFunction) => {
        if (chk) { // runs 2x
          expect(req.url.includes('/foo')).assertTrue();
          expect(req.path.includes('/foo')).assertTrue();
          chk = false;
        }
        next();
      }

      let app = polka<SelfRequest>()
        .use(aaa, bbb, ccc) // globals
        .use('foo', (req: SelfRequest, res: ServerResponse) => {
          // all runs 2 times
          expect(req.aaa).assertEqual('aaa');
          expect(req.bbb).assertEqual('bbb');
          expect(req.url.includes('foo')).assertFalse();
          expect(req.path.includes('foo')).assertFalse();
          expect(req.originalUrl.includes('foo')).assertTrue();
          res.end('hello from foo');
        })
        .use('bar', bar, (req: SelfRequest, res: ServerResponse) => {
          expect(req.aaa).assertEqual('aaa');
          expect(req.bbb).assertEqual('bbb');
          expect(req.bar).assertEqual('bar');
          expect(req.url.includes('bar')).assertFalse();
          expect(req.path.includes('bar')).assertFalse();
          expect(req.originalUrl.includes('bar')).assertTrue();
          expect(req.path).assertEqual('/hello');
          res.end('hello from bar');
        })
        .get('/', (req: SelfRequest, res: ServerResponse) => {
          expect(req.aaa).assertEqual('aaa');
          expect(req.bbb).assertEqual('bbb');
          res.end('hello from main');
        }).listen(9993, (e) => {
          console.log('testrunn: ' + e)
        });

      let httpRequest = http.createHttp();
      let opt: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
      }
      // 发送http请求
      const res: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9993/", opt);
      expect(res.responseCode).assertEqual(200);
      expect(res.result).assertEqual('hello from main');

      // Test (GET /foo)
      chk = true;
      const res1: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9993/foo", opt);
      expect(res1.responseCode).assertEqual(200);
      expect(res1.result).assertEqual('hello from foo');

      // Test (POST /foo/items?this=123)
      chk = true;
      const res2: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9993/foo/items?this=123", {
        method: http.RequestMethod.POST,
        extraData: 'data to send',
      });
      expect(res2.responseCode).assertEqual(200);
      expect(res2.result).assertEqual('hello from foo');

      // Test (GET /bar/hello)
      const res3: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9993/bar/hello", opt);
      expect(res3.responseCode).assertEqual(200);
      expect(res3.result).assertEqual('hello from bar');

      // Test (GET 404)
      const res4: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9993/foobar", opt);
      expect(res4.responseCode).assertEqual(404);
      expect(res4.result).assertEqual('Not Found');

      app.server?.stop();
      done();
    })

    it('polka::usage::middleware (wildcard)', 0, async (done: Function) => {
      let exp: string;
      let foo = (req: SelfRequest, res: ServerResponse, next: NextFunction) => { req.foo='foo'; next() };

      let app = polka<SelfRequest>()
        .use(foo) // global
        .use('bar', (req: SelfRequest, res: ServerResponse) => {
          // runs 2x
          expect(req.foo).assertEqual('foo');
          expect(req.url.includes('bar')).assertFalse();
          expect(req.path.includes('bar')).assertFalse();
          expect(req.originalUrl.includes('bar')).assertTrue();
          res.end('hello from bar');
        })
        .get('*', (req: SelfRequest, res: ServerResponse) => {
          // runs 3x
          expect(req.foo).assertEqual('foo');
          expect(req.url).assertEqual(exp);
          res.end('hello from wildcard');
        }).listen(9994, (e) => {
          console.log('testrunn: ' + e)
        });

      let httpRequest = http.createHttp();
      let opt: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
      }

      exp = '/';
      // 发送http请求
      const res: http.HttpResponse = await httpRequest.request(`http://0.0.0.0:9994${exp}`, opt);
      expect(res.responseCode).assertEqual(200);
      expect(res.result).assertEqual('hello from wildcard');

      exp = '/hello';
      const res1: http.HttpResponse = await httpRequest.request(`http://0.0.0.0:9994${exp}`, opt);
      expect(res1.responseCode).assertEqual(200);
      expect(res1.result).assertEqual('hello from wildcard');

      exp = '/a/b/c';
      const res2: http.HttpResponse = await httpRequest.request(`http://0.0.0.0:9994${exp}`, opt);
      expect(res2.responseCode).assertEqual(200);
      expect(res2.result).assertEqual('hello from wildcard');

      const res3: http.HttpResponse = await httpRequest.request(`http://0.0.0.0:9994/bar`, opt);
      expect(res3.responseCode).assertEqual(200);
      expect(res3.result).assertEqual('hello from bar');

      const res4: http.HttpResponse = await httpRequest.request(`http://0.0.0.0:9994/bar/extra`, opt);
      expect(res4.responseCode).assertEqual(200);
      expect(res4.result).assertEqual('hello from bar');

      app.server?.stop();
      done();
    })
  })
};
