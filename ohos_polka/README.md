# ohos_polka
Polka是一个极其简洁、高性能的Express.js替代方案。在提供了原生的HTTP服务器功能之外，增加了对路由、中间件和子应用程序的支持。

## 简介
本项目为基于开源库 [Polka](https://github.com/lukeed/polka)  进行OpenHarmony的移植版本：

### 一、基础特性
- 提供HTTP 1.1支持。
- 没有固定的配置文件、日志记录、授权等。
- 对 cookies 的基本支持。
- 支持GET、POST方法的参数解析。
- 一些内置对 HEAD、POST 和 DELETE 等请求的支持。
- 支持文件上传。
- 不缓存任何东西。
- 默认情况下不限制带宽、请求时间或同时连接数。
- 所有标题名称均转换为小写，因此它们在浏览器/客户端之间不会发生变化。
- 持久连接（连接“保持活动”）支持通过单个套接字连接来处理多个请求。

### 二、静态文件服务器
- 支持动态内容和文件服务。
- 文件服务器支持目录列表，index.html以及index.htm。
- 文件服务器支持部分内容（流式传输和继续下载）。
- 文件服务器支持ETags。
- 文件服务器对没有的目录执行301重定向技巧/。
- 包含最常见的 MIME 类型的内置列表。

## 下载安装
```shell
ohpm install @ohos/polka
```
OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。


## 需要权限

```
ohos.permission.INTERNET
```

## 使用说明

- 在pages页面中使用
```
import polka, { IncomingMessage, ServerResponse, statik, Request, fileUploadHtml } from 'polka';

const app = new polka();

interface SelfRequest extends Request {
  hello: string;
  foo: string;
}

function one(req: IncomingMessage, res: ServerResponse, next) {
    req.hello = 'world';
    next();
}

function two(req: IncomingMessage, res: ServerResponse, next) {
    req.foo = '...needs better demo';
    next();
}

app
  .use(one, two)
  .get('/users', (req: SelfRequest, res: ServerResponse) => {
    res.end(`User: ${req.params.id}`);
  })
  .get('/get-params', (req: IncomingMessage, res: ServerResponse) => {
    res.end(`User: ${req.params.id}`);
  })
  .post('/post-params', (req: IncomingMessage, res: ServerResponse) => {
    res.end(`User: ${req.params.id}`);
  })
  // 通过get发送upload接口，获取上传文件的html结果，用户可通过该界面进行文件上传
  .get('/upload', (req: IncomingMessage, res: ServerResponse) => {
    res.writeHead(200, {
      'Content-Type': statik.mime.getType('.html'),
    });
    res.end(fileUploadHtml);
  })
  // 通过post发送upload接口，文件上传
  .post('/upload', (req: IncomingMessage, res: ServerResponse) => {
    let keys = Array.from(req.files.keys());
    // 获取上传文件内容长度
    let bufLength = req.files.get(keys[0]).buffer.byteLength;
    // writeLength 后台新建文件内容长度
    let writeLength =
      createFile(context.filesDir, req.parameters.get(keys[0])[0], req.files.get(keys[0]).buffer);
    if (bufLength === writeLength) {
      res.writeHead(200, {
        'Content-Type': 'text/plain',
      });
      res.end('upload success!');
    } else {
      res.writeHead(200, {
        'Content-Type': 'text/plain',
      });
      res.end('upload failure!');
    }
  })
  .listen(3000, () => {
    console.log(`> Running on localhost:3000`);
  });
  
// 当polka().listen()执行后，服务开启，server属性会被同步更新，server.stop()则用来关闭当前服务
app.server?.stop();
```
- 使用场景说明
    - get('/get-params', (req: IncomingMessage, res: ServerResponse) => {})
        - 使用get请求方式，获取接口'get-params'下的数据时，使用req.parameters直接获取请求体信息。
    - post('/post-params', (req: IncomingMessage, res: ServerResponse) => {})
        - 使用post请求方式，获取接口'post-params'下的数据时，在请求头中解析出来的contentType为'application/x-www-form-urlencoded'
      或者'application/json'时，使用req.parameters获取请求体信息。
        - 若解析出来的的contentType为'multipart/form-data'，使用req.parameters.get(keys[0])[0] 获取文件名，
      req.files.get(keys[0]).buffer 获取文件内容

## 接口说明

### 一、API

#### 1、`polka(options)`
- options对应的字段参数功能，返回polka实例
  - options.server： 调用`polka.listen()`时使用的服务器实例
  - options.onError： 一个捕获所有错误的处理程序；每当中间件抛出一个错误时执行
  - options.onNoMatch： 没有匹配的路由定义时的处理程序

#### 2、`use(base, ...fn)`
- 将中间件或子应用程序注册到服务器，它们将在路由处理器之前执行
  - base -- 类型: String，默认值: undefined，中间件或子应用程序应挂载的基本路径
  - fn -- 类型: Function或Array，一次可以传递一个或多个函数。每个函数都必须有标准化的（req,res,next）签名

#### 3、`parse(req)` 解析给定请求的'req.url'属性

- 返回：对象或undefined

#### 4、`listen()` 直接返回当前的Polka实例，允许链式操作

- 返回：Polka

#### 5、`handler(req, res, parsed)` 主要的Polka IncomingMessage处理程序。它接收所有请求，并尝试将传入的URL与已知路由进行匹配

- req 类型：IncomingMessage。
  - 内置属性
      - socket：储存网络服务器的socket信息
      - uri：请求URI
      - method：请求方法
      - headers：请求头信息
      - cookies：cookies信息
      - url：存储URL
      - path：存储路径
      - parameters：请求参数
      - queryParameterString：查询参数字符串
      - files：文件信息
  - 接口说明：

    |方法名            | 入参                                   | 接口描述          |
    |---------------|--------------------------------------| ------------------|
    |getParameters() |                                      |获取parameters中参数列表    |
    |getQueryParameterString() |                                      |获取查询参数字符串|
    |getRemoteIpAddress() |                                      |提供socket客户端返回Ip地址 |
    |getCookies()   |                                      |获取请求头中cookie信息|
    |getUri()       |                                      |获取header中包含的uri信息|
    |getHeaders()   |                                      |获取headers对象|
    |getParms()     |                                      |获取参数列表|
    |getMethod()    |                                      |获取请求类型的方法|
    |getInputStream() |                                      |获取socket字符串 |
    |execute()      |client 客户端的TCP连接<br/>bufferPool 缓冲池   |解析HTTP请求头 |
    |parseBody()    |files 用于存储文件的Map<br/>callback 解析完成后的回调函 |解析请求体，处理POST和PUT方法中的数据 |

- res 类型：ServerResponse。
  - 内置属性
    - statusCode：状态值
    - statusMessage：状态信息
    - writableEnded：是否调用了end()方法
    - writableFinished：是否调用了client.send()方法
    - headersSent：是否已在响应中发送标头信息
  - 接口说明

    | 方法名             | 入参                                  | 接口描述         |
    |-----------------|-------------------------------------| ------------------|
    |writeHead()      |                                     | 输出响应头     |
    |addCookieHeader() |                                     |添加Set-Cookie信息|
    |setHeader(name, value) | name字段的值为value                      |设置响应头 |
    |setHeaders(headersMap) | 参数可以为Map对象                          |设置响应头|
    |getHeader(name)  | name为头部key值                         |获取header中name字段的value|
    |hasHeader(name)  | name为头部key值                         |检查header中是否包含name字段|
    |getHeaderNames() |                                     |获取header中的所有name字段|
    |removeHeader(name) | name为头部key值                         |从header中删除name字段|
    |getHeaders()     |                                     |获取整个header信息 |
    |end()            | client 客户端的TCP连接<br/>bufferPool 缓冲池 |发送所有响应标头和正文 |

- parsed，类型：object。可选地提供一个解析的URL对象。如果您已经解析了传入路径，则很有用。否则，app.parse（又名parseurl）将默认运行

### 二、路由

用于定义应用程序如何响应不同的HTTP方法和URL。每个路由都由一个路径模式、一个HTTP方法和一个处理程序（即要执行的操作）组成。

```
app.METHOD(pattern, handler);
```

- app是polka的实列
- METHOD是任何有效的HTTP/1.1方法，需小写
- pattern是路由模式（字符串）
- handler是匹配模式时要执行的函数

```
import polka, { IncomingMessage, ServerResponse, statik, Request } from 'polka';

const app = polka();

app.get('/', (req, res) => { 
    res.end('Hello world!'); 
});

app.post('/users', (req, res) => {
    res.end('Create a new User!');
});
```

### 三、中间件

在接收请求和执行路由的处理程序响应之间运行的函数。中间件参数接收请求（req）、响应（res）和回调（next）

```
// Log every request
function logger(req, res, next) {
  console.log(`~> Received ${req.method} on ${req.url}`);
  next(); // move on
}

function authorize(req, res, next) {
  // mutate req; available later
  req.token = req.headers['authorization'];
  req.token ? next() : ((res.statusCode=401) && res.end('No token!'));
}

polka().use(logger, authorize).get('*', (req, res) => {
  console.log(`~> user token: ${req.token}`);
  res.end('Hello, valid user');
});
```

### 四、文件服务器（node-static）

```
// Create a node-static server instance to serve the './public' folder

import polka, { IncomingMessage, ServerResponse, statik, Request } from 'polka';

const app = polka();

const file = new statik.Server(context, '/');
const dir = new statik.Server(context, '/', { gzip: true });

app
.use((req, res, next) => {
  dir.serve(req, res, function (e) {
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
.get('/upload', (req: IncomingMessage, res: ServerResponse) => {
  res.writeHead(200, {
    'Content-Type': statik.mime.getType('.html')
  });
  res.end(fileUploadHtml);
})
.post('/upload', (req: IncomingMessage, res: ServerResponse) => {
  let keys = Array.from(req.files.keys());
  let bufLength = req.files.get(keys[0]).buffer.byteLength;
  let writeLength = createFile(context.filesDir, req.parameters.get(keys[0])[0], req.files.get(keys[0]).buffer);
  if (bufLength === writeLength) {
    res.writeHead(200, {
      'Content-Type': 'text/plain',
    });
    res.end('upload success!');
  } else {
    res.writeHead(200, {
      'Content-Type': 'text/plain',
    });
    res.end('upload failure!');
  }
})
.listen(9990, '0.0.0.0', () => {
  // ...
});
```

```
 // Client File Upload
 
 <form action="/upload" enctype="multipart/form-data" method="post">
  <label for="file">File:</label>
     <input type="file" id="datafile1" name="file" size="40"><br>
  <input type="submit">
 </form>
```

### 1、接口说明

- 创建文件服务器实例 new statik.Server()
- 在一个特定的目录中提供文件，把它作为第一个参数传递 new statik.Server('/public')
- 可以指定参数 new statik.Server('/public', { gzip: true });
- 服务特定文件 serveFile('/error.html', 500, {}, request, response)

### 2、new statik.Server('./public', options)，options参数说明

- options.gzip: 是否启用对发送压缩响应的支持
- options.indexFile: 提供目录时选择自定义索引文件

## 约束与限制

在下述版本验证通过：

- DevEco Studio: (5.0.3.400SP7), SDK: API12(5.0.0.71)

## 目录结构

```
|---- ohos_polka  
|     |---- entry  # 示例代码文件夹
|     |---- library  # polka库文件夹
|           |---- index.ts  # 对外接口
|           └─src/main/ets/common/util
|                          |---- event-emitter.ts # 事件触发和事件监听器类
|                          |---- fs.ts # 文件操作类
|                          |---- log.ts # 日志打印相关操作类
|                          |---- util.ts # 公共工具类
|           └─src/main/ets/http/core
|                          ├─content
|                               |---- ContentType.ts  # 基本的ContentType类
|                               |---- Cookie.ts  # 基本的cookie类
|                               |---- CookieHandler.ts  # 提供对Cookie的基本支持
|                          ├─request
|                               |---- BufferPool.ts  # BufferPool类，继承自EventEmitter，用于处理数据缓冲
|                               |---- IncomingMessage.ts  # 解析和处理HTTP请求类
|                          ├─response
|                               |---- ServerResponse.ts  # 基础的HTTP响应类
|                          |---- index.ts # 实现的简单的http
|                          |---- Server.ts # 继承NanoHTTPD的简单服务类
|           └─src/main/ets/node-static
|                          ├─mime
|                               ├─types
|                                   |---- other.ts  # 标准库之外的mimetype库
|                                   |---- standard.ts  # 标准的mimetype库
|                               |---- index.ts # 提供一个mimetype接口类
|                               |---- Mime.ts # 定义mimetype扩展映射
|                          ├─node-static
|                               |---- util.js  # 文件服务器的相关工具类
|                          |---- index.js # 提供一个简单的文件服务器
|           └─src/main/ets/polka
|                          ├─regexparam
|                               |---- index.js # 正则处理类
|                          ├─trouter
|                               |---- index.js # 路由处理类
|                          ├─url
|                               |---- index.js # 中解析url的工具类
|                          |---- index.js # polka类
|---- README.md  # 安装使用方法   
```
## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
,当然，也非常欢迎发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## 开源协议

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/ohos_polka/blob/master/LICENSE).

## 遗留问题
1. 目前不支持websocket
2. 当前不支持手动关闭服务器
3. 当前文件上传不支持超过20MB的文件(底座影响,后续rom版本会修复)