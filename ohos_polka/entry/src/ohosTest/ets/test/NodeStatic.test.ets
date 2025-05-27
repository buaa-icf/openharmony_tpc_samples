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

import { describe, it, expect, beforeAll } from '@ohos/hypium'
import http from '@ohos.net.http';
import common from '@ohos.app.ability.common';
import polka, { IncomingMessage, ServerResponse, statik, createFile } from '@ohos/polka';
import fs from '@ohos.file.fs';
import { context } from '../testability/TestAbility';
import pako from '../../../../oh_modules/pako';

interface optionsType {
  gzip: boolean,
  level: number
}

export async function gzipFile(src: string, dest: string): Promise<boolean> {
  try {
    let stat = fs.statSync(src);
    const buf = new ArrayBuffer(stat.size);
    const reader = fs.openSync(src, fs.OpenMode.READ_ONLY);
    fs.readSync(reader.fd, buf);
    const writer = fs.openSync(dest, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    const options: optionsType = { gzip: true, level: 9 };
    fs.writeSync(writer.fd, pako.gzip(new Uint8Array(buf), options)?.buffer);
    fs.closeSync(reader);
    fs.closeSync(writer);
    return true;
  } catch (error) {
    return false;
  }
}

function initFile(): void {
    let dirPath = context.filesDir;
    try {
      createFile(dirPath, 'index.html', `<!doctype html><html lang=""><head><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="/favicon.ico"><title>vue-project</title><script defer="defer" src="/js/chunk-vendors.8099839b.js"></script><script defer="defer" src="/js/app.ef57ad63.js"></script><link href="/css/app.b2d625b8.css" rel="stylesheet"></head><body><noscript><strong>We're sorry but vue-project doesn't work properly without JavaScript enabled. Please enable it to continue.</strong></noscript><div id="app">test html from public</div></body></html>`)
      createFile(dirPath, `file.txt`, "Try to write str");
      fs.mkdirSync(dirPath + '/test');
      createFile(dirPath + '/test', 'index.html', `<!doctype html><html lang=""><head><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="/favicon.ico"><title>vue-project</title><script defer="defer" src="/js/chunk-vendors.8099839b.js"></script><script defer="defer" src="/js/app.ef57ad63.js"></script><link href="/css/app.b2d625b8.css" rel="stylesheet"></head><body><noscript><strong>We're sorry but vue-project doesn't work properly without JavaScript enabled. Please enable it to continue.</strong></noscript><div id="app">test html from public/test</div></body></html>`)
      createFile(dirPath + '/test', `file.txt`, "Try to write str");
      fs.mkdirSync(dirPath + '/test1');
      createFile(dirPath + '/test1', `file.txt`, "Try to write str");
    } catch (e) {
      console.log('e === ' + e);
    }

}

function generateTextFile(): void {
  try {
    let data = context.filesDir
    const writer = fs.openSync(data + '/hello.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(writer.fd,
    "hello, world! adjasjdakjdakjdkjakjdakjskjasdkjaskjdajksdkjasdkjaksjdkja\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs\n"
    + "adasajsdkjadjkakjdakjsdkjadkjakjdakjsdkjasdkjaskjdakjsdkjaskjdakjsdkjaskjakjdakjs"
    );
    fs.closeSync(writer);
  } catch (error) {
    console.error('File to obtain the file directory. Cause: ' + error.message);
  }
}

function gzipFileTest(): void {
  try {
    let data = context.filesDir
    console.info('directory obtained. Data:' + data);
    gzipFile(data + '/hello.txt', data + '/hello.txt.gz').then((isSuccess) => {});
} catch (error) {
  console.error('File to obtain the file directory. Cause: ' + error.message);
  }
}

export default function nodeStaticTest() {
  describe('nodeStatic', async () => {

    beforeAll(() => {
      initFile()
    })
    it('NodeStatic::statik::Server', 0, async (done: Function) => {
      const file = new statik.Server(context, '/');
      const dir = new statik.Server(context, '/', { gzip: true });
      polka()
        .use((req: IncomingMessage, res: ServerResponse, next: Function) => {
          dir.serve(req, res, (e) => {
            if (e && (e.status === 404)) {
              next();
            }
          });
        })
        .get('/file', (req: IncomingMessage, res: ServerResponse) => {
          file.serveFile(
            '/file.txt', 200, {}, req, res
          );
        })
        .listen(9001, '0.0.0.0', () => {});

      let httpRequest = http.createHttp();
      let opt1: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
      }

      // 测试获取文件内容
      const res1: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9001/file", opt1);
      expect(res1.responseCode).assertEqual(200);
      expect(res1.result).assertEqual(`Try to write str`);

      // 支持etag
      expect(JSON.stringify(res1.header).includes('etag')).assertEqual(true);
      expect(JSON.stringify(res1.header).includes('content-encoding')).assertEqual(false);
      done();
    });

    it('NodeStatic::statik::Server::serveFile("/file.txt")', 0, async (done: Function) => {
      const file = new statik.Server(context, '/');
      const dir = new statik.Server(context, '/', { gzip: true });
      polka()
        .use((req: IncomingMessage, res: ServerResponse, next: Function) => {
          dir.serve(req, res, (e) => {
            if (e && (e.status === 404)) {
              next();
            }
          });
        })
        .get('/file', (req: IncomingMessage, res: ServerResponse) => {
          file.serveFile(
            '/file.txt', 200, {}, req, res
          );
        })
        .listen(9002, '0.0.0.0', () => {});

      let httpRequest = http.createHttp();
      let opt2: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
        header: {
          'Accept-Encoding': 'gzip, deflate, br, zstd',
        }
      }

      // 支持文件压缩
      generateTextFile();
      gzipFileTest();
      const res4: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9002/hello.txt", opt2);
      expect(res4.responseCode).assertEqual(200);
      expect(JSON.stringify(res4.header).includes('content-encoding')).assertEqual(true);
      done();
    });

    it('NodeStatic::statik.Server("/", { gzip: true })', 0, async (done: Function) => {
      const file = new statik.Server(context, '/');
      const dir = new statik.Server(context, '/', { gzip: true });
      polka()
        .use((req: IncomingMessage, res: ServerResponse, next: Function) => {
          dir.serve(req, res, (e) => {
            if (e && (e.status === 404)) {
              next();
            }
          });
        })
        .get('/file', (req: IncomingMessage, res: ServerResponse) => {
          file.serveFile(
            '/file.txt', 200, {}, req, res
          );
        })
        .listen(9003, '0.0.0.0', () => {});

      let httpRequest = http.createHttp();
      let opt2: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
        header: {
          'Accept-Encoding': 'gzip, deflate, br, zstd',
        }
      }

      // 支持文件压缩
      generateTextFile();
      gzipFileTest();
      const res4: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9003/hello.txt", opt2);
      expect(res4.responseCode).assertEqual(200);
      expect(JSON.stringify(res4.header).includes('content-encoding')).assertEqual(true);
      done();
    });

    it('NodeStatic::statik.Server("/", { gzip: true })（客户端发送时提供head：{Range: ”bytes=0-2"}）', 0, async (done: Function) => {
      const file = new statik.Server(context, '/');
      const dir = new statik.Server(context, '/', { gzip: true });
      polka()
        .use((req: IncomingMessage, res: ServerResponse, next: Function) => {
          dir.serve(req, res, (e) => {
            if (e && (e.status === 404)) {
              next();
            }
          });
        })
        .get('/file', (req: IncomingMessage, res: ServerResponse) => {
          file.serveFile(
            '/file.txt', 200, {}, req, res
          );
        })
        .listen(9004, '0.0.0.0', () => {});

      let httpRequest = http.createHttp();
      let opt3: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
        header: {
          'Range': 'bytes=0-2'
        }
      }

      // 支持断点续传
      const res5: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9004/file", opt3);
      expect(res5.responseCode).assertEqual(206);
      expect(res5.result).assertEqual(`Try`);

      done();
    });

    it('NodeStatic::statik.Server("/test", {})', 0, async (done: Function) => {
      const file = new statik.Server(context, '/');
      const dir = new statik.Server(context, '/', { gzip: true });
      polka()
        .use((req: IncomingMessage, res: ServerResponse, next: Function) => {
          dir.serve(req, res, (e) => {
            if (e && (e.status === 404)) {
              next();
            }
          });
        })
        .get('/file', (req: IncomingMessage, res: ServerResponse) => {
          file.serveFile(
            '/file.txt', 200, {}, req, res
          );
        })
        .listen(9005, '0.0.0.0', () => {});

      let httpRequest = http.createHttp();
      let opt1: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
      }

      // 测试查看目录，目录下有index.html文件，则返回index.html文件内容
      const res2: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9005/test/", opt1);
      expect(res2.responseCode).assertEqual(200);
      expect(res2.result).assertEqual(`<!doctype html><html lang=""><head><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="/favicon.ico"><title>vue-project</title><script defer="defer" src="/js/chunk-vendors.8099839b.js"></script><script defer="defer" src="/js/app.ef57ad63.js"></script><link href="/css/app.b2d625b8.css" rel="stylesheet"></head><body><noscript><strong>We're sorry but vue-project doesn't work properly without JavaScript enabled. Please enable it to continue.</strong></noscript><div id="app">test html from public/test</div></body></html>`);

      // 测试查看目录，目录下没有有index.html文件，则返回目录内容
      const res3: http.HttpResponse = await httpRequest.request("http://0.0.0.0:9005/test1/", opt1);
      expect(res3.responseCode).assertEqual(200);
      expect(res3.result).assertContain(`Directory test1`);
      done();
    });
  })
}
