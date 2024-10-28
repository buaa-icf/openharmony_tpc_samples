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

import { buffer } from '@kit.ArkTS';
import polka, { IncomingMessage, ServerResponse, statik, createFile, Request } from 'polka';
import wantAgent from '@ohos.app.ability.wantAgent';
import backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager';
import { BusinessError } from '@ohos.base';

interface SelfRequest extends Request {
  hello: string;
  foo: string;
}

function one(req, res, next) {

  req.hello = 'world';
  next();
}

function two(req, res, next) {
  req.foo = '...needs better demo 😔';
  next();
}

const app = polka();

/**
 * startBackgroundRunning的默认回调函数，用于打印错误信息
 * */
function callback(error): void {
  if (error) {
    console.error(`Operation startBackgroundRunning failed. info is ${error.code} ${error.message}`);
  } else {
    console.info('Operation startBackgroundRunning succeeded');
  }
}

export async function start(context): Promise<String> {
  // 申请后台任务
  let wantAgentInfo = {
    wants: [{
      bundleName: 'com.rnoh.tester1',
      abilityName: 'EntryAbility',
    }],
    actionType: wantAgent.OperationType.START_ABILITY,
    requestCode: 0,
    wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG],
  };
  try {
    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj) => {
      try {
        backgroundTaskManager.startBackgroundRunning(context,
          backgroundTaskManager.BackgroundMode.TASK_KEEPING, wantAgentObj, callback);
      } catch (error) {
        console.error(`Operation startBackgroundRunning failed. info is ${error.code} ${error.message}`);
      }
    });
  } catch (error) {
    console.error(`Operation getWantAgent failed. code is ${error.code} message is ${error.message}`);
  }

  const file = new statik.Server(context, '/');
  const dir = new statik.Server(context, '/', {
    gzip: true
  });

  return new Promise(function (resolve, reject) {
    app
      .use(one, two)
      .use((req, res, next) => {
        console.log(`~> Hello, ${req.method}`);
        dir.serve(req, res, function (e) {
          if (e && (e.status === 404)) {
            next();
          }
        });
      })
      .get('/index', (req: SelfRequest, res: ServerResponse) => {
        console.log(`~> Hello1, ${req.parameters}`);
        res.writeHead(200, {
          'Content-Type': statik.mime.getType('.html'),
        });
        let name = '';
        req.parameters.forEach((name1, value) => {
          name = name + (value + ":" + name1)
        });
        res.end('hello' + name);
      })
      .get('/get-cookie', (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(200, {
          'Content-Type': statik.mime.getType('.html'),
        });
        const cookieString: string = req.headers["cookie"];

        const tokens: string[] = cookieString.split(";")
        let cookieRes: string = '';
        for (const item of tokens) {
          const data: string[] = item.trim().split('=');
          if (data.length === 2) {
            const [key] = data;
            cookieRes += `cookie key is ${key}, value is ${req.cookies.read(key)} \r\n`;
          }
        }
        res.addCookieHeader("jsId:aaaaaaa")
        res.end(cookieRes);
      })
      .get('/image', (req: IncomingMessage, res: ServerResponse) => {
        console.log(`~> Hello, ${req.method}`);
        let content = context.resourceManager.getRawFileContentSync("app_icon.png");
        console.log("content === " + content)
        let buf = buffer.from(content);
        // res.setHeader('Content-Type', "image/png");
        res.setHeader('Content-Type', statik.mime.getType('.png'));
        console.log('content-type === ' + statik.mime.getType('.png'));
        res.end(buf.buffer);
      })
      .post('/upload', (req: IncomingMessage, res: ServerResponse) => {
        let keys = Array.from(req.files.keys());
        const time1: number = Number(req.parameters.get('time')[0]);
        let bufLength = req.files.get(keys[0]).buffer.byteLength;
        let writeLength =
          createFile(context.filesDir, req.parameters.get(keys[0])[0], req.files.get(keys[0]).buffer);
        if (bufLength === writeLength) {
          const time2 = new Date().getTime();
          const time = time2 - time1
          res.writeHead(200, {
            'Content-Type': 'text/plain',
          });
          res.end('upload success，用时为' + time + 'ms');
        } else {
          res.writeHead(200, {
            'Content-Type': 'text/plain',
          });
          res.end('upload failure!');
        }
      })
      .get('/file', (req: IncomingMessage, res: ServerResponse) => {
        console.log(`~> Hello, ${req.method}`);
        file.serveFile(
          '/file.txt', 200, {}, req, res
        );
      })
      .get('/upload', (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(200, {
          'Content-Type': statik.mime.getType('.html')
        });
        res.end(fileUploadHtml);
      })
      .post('/post-params', (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(200, {
          'Content-Type': statik.mime.getType('.html'),
        });
        res.end('post 请求参数为：' + Array.from(req.parameters));
      })
      .get('/get-params', (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(200, {
          'Content-Type': statik.mime.getType('.html'),
        });
        res.end('get 请求参数为：' + Array.from(req.parameters));
      })
      .head('/head-test', (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(200, {
          'Content-Type': statik.mime.getType('.html'),
        });
        res.end('请求方式为：head');
      })
      .put('/put-test', (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(200, {
          'Content-Type': statik.mime.getType('.html'),
        });
        res.end('请求方式为：put');
      })
      .delete('/delete-test', (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(200, {
          'Content-Type': statik.mime.getType('.html'),
        });
        res.end('请求方式为：delete');
      })
      .options('/options-test', (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(200, {
          'Content-Type': statik.mime.getType('.html'),
        });
        res.end('请求方式为：options');
      })
      .trace('/trace-test', (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(200, {
          'Content-Type': statik.mime.getType('.html'),
        });
        res.end('请求方式为：trace');
      })
      .connect('/connect-test', (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(200, {
          'Content-Type': statik.mime.getType('.html'),
        });
        res.end('请求方式为：CONNECT');
      })
      .post('/test-redirect', (req: IncomingMessage, res: ServerResponse) => {
        res.writeHead(302, {
          'Content-Type': statik.mime.getType('.html'),
          'Location':'wwww.baidu.com'
        });
        res.end('请求方式为：CONNECT');
      })
      .listen(9990, '0.0.0.0', (message) => {
        resolve(message);
      });
  });
}

export async function stop(context): Promise<String> {
  function callback(err: BusinessError, data: void) {
    if (err) {
      console.error("Operation stopBackgroundRunning failed Cause: " + err);
    } else {
      console.info("Operation stopBackgroundRunning succeeded");
    }
  }
  backgroundTaskManager.stopBackgroundRunning(context, callback);

  return new Promise(function (resolve, reject) {
    try {
      app.server?.stop();
      resolve("close success!")
    } catch (e) {
      reject("close failed!")
    }
  });
}


export const httpGetString: string = `GET /s?wd=http&rsv_spt=1&rsv_iqid=0xfda717d5002f02ad&issp=1&f=8&rsv_bp=1&rsv_idx=2&ie=utf-8&tn=baiduhome_pg&rsv_dl=tb&rsv_enter=1&rsv_sug3=5&rsv_sug2=0&rsv_btype=i&inputT=1296&rsv_sug4=4472 HTTP/1.1
    Host: www.baidu.com
    Connection: keep-alive
    Cache-Control: max-age=0
    sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"
    sec-ch-ua-mobile: ?0
    sec-ch-ua-platform: "macOS"
    Upgrade-Insecure-Requests: 1
    User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
    Sec-Fetch-Site: none
    Sec-Fetch-Mode: navigate
    Sec-Fetch-User: ?1
    Sec-Fetch-Dest: document+
    Accept-Encoding: gzip, deflate, br
    Accept-Language: zh-CN,zh;q=0.9,en;q=0.8
    Cookie: BIDUPSID=8B0207CE0B6364E5934651E84F17999B; PSTM=1619707475; `

export const httpPostString: string = `POST /hello/index.jsp HTTP/1.1
    Host: localhost
    User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20100101 Firefox/5.0
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
    Accept-Language: zh-cn,zh;q=0.5
    Accept-Encoding: gzip, deflate
    Accept-Charset: GB2312,utf-8;q=0.7,*;q=0.7
    Connection: keep-alive
    Referer: http://localhost/hello/index.jsp
    Cookie: JSESSIONID=369766FDF6220F7803433C0B2DE36D98
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 14

username=hello`

export const httpMultiString: string = `POST /t2/upload.do HTTP/1.1
User-Agent: SOHUWapRebot
Accept-Language: zh-cn,zh;q=0.5
Accept-Charset: GBK,utf-8;q=0.7,*;q=0.7
Connection: keep-alive
Content-Length: 60408
Content-Type:multipart/form-data; boundary=ZnGpDtePMx0KrHh_G0X99Yef9r8JZsRJSXC
Host: w.sohu.com

--ZnGpDtePMx0KrHh_G0X99Yef9r8JZsRJSXC
Content-Disposition: form-data; name="city"

Santa colo
--ZnGpDtePMx0KrHh_G0X99Yef9r8JZsRJSXC
Content-Disposition: form-data;name="desc"
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

...
--ZnGpDtePMx0KrHh_G0X99Yef9r8JZsRJSXC
Content-Disposition: form-data;name="pic"; filename="photo.jpg"
Content-Type: application/octet-stream
Content-Transfer-Encoding: binary

... binary data of the jpg ...
--ZnGpDtePMx0KrHh_G0X99Yef9r8JZsRJSXC--`

const realGetData = `GET / HTTP/1.1\r\nHost: 127.0.0.1:9990\r\nConnection: keep-alive\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7\r\nAccept-Language: zh-CN,zh;q=0.9\r\nSec-Fetch-Site: none\r\nSec-Fetch-Mode: navigate\r\nSec-Fetch-User: ?1\r\nSec-Fetch-Dest: document\r\nAccept-Encoding: gzip, deflate, br\r\n\r\n"`

export const jsonResponse = `
{"status":200,"data":[],"message":null}
`

export const fileUploadHtml = `
<html>
 <body>
  <p>This is a file upload test for NanoHTTPD.</p>
   <form action="/upload" enctype="multipart/form-data" method="post" id="test_form">
    <label for="file">File:</label>
       <input type="file" id="datafile1" name="file" size="40"><br>
       <input type="hidden" name="time" id='time' value=''><br>
       <button type="button" onclick='doSubmitForm()'>提交</button>
   </form>
   <br>
   <button onclick="test()">test</button>
   <script>

   function doSubmitForm(){
      var form = document.getElementById('test_form');
      var time = document.getElementById('time');
      time.value = new Date().getTime();
      form.submit();
  }
   // setInterval(function(){
   // alert('testouter');
   function test() {
      const time1 = new Date().getTime();
      alert('testinner');
      // 请求的网址
      var url = 'http://172.20.10.10:9990/post-params';
      // 发起请求
      var _fetch = fetch(url, {method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: 'id=1&name=zhangsan&age=23}'}).then(function (response) {
      // var _fetch = fetch(url, {method: 'POST', headers: {'Content-Type': 'application/json'}, body: '{"username": "hello"}'}).then(function (response) {
      // var _fetch = fetch(url, {method: 'GET', headers: {'range': 'bytes=0-'}}).then(function (response) {
          // response.status表示响应的http状态码
          alert('response.status === ' + response.status);
          const time2 = new Date().getTime();
          const time = time2 - time1;
          alert(time + 'ms');
          if (response.status === 200) {
            // json是返回的response提供的一个方法,
            // 会把返回的json字符串反序列化成对象,也被包装成一个Promise了
            return response.text();
            // return response.arrayBuffer();
          } else {
            // return {};
          }
      });
      _fetch.then(function(e){
        // const decoder = new TextDecoder('utf-8');
        // const str = decoder.decode(e);
        // alert(str);
        alert(e);
      })
    }
    // },2000);
   </script>
 </body>
</html>`