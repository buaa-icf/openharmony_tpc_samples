# httpclient

## 简介

HTTP是现代应用程序通过网络交换数据和媒体的的主要方式。httpclient是OpenHarmony 里一个高效执行的HTTP客户端，使用它可使您的内容加载更快，并节省您的流量。httpclient以人们耳熟能详的OKHTTP为基础，整合android-async-http，AutobahnAndroid，OkGo等库的功能特性，致力于在OpenHarmony 打造一款高效易用，功能齐全的网络请求库。当前版本的httpclient依托系统提供的网络请求能力和上传下载能力，在此基础上进行拓展开发，已经实现的功能特性如下所示：

1.支持全局配置调试开关，超时时间，公共请求头和请求参数等，支持链式调用。

2.自定义任务调度器维护任务队列处理同步/异步请求。

3.支持tag取消请求。

4.支持设置自定义拦截器。

5.支持重定向。

6.支持客户端解压缩。

7.支持文件上传下载。

8.支持cookie管理。

9.支持对请求内容加解密。

## 下载安装

```javascript
npm install @ohos/httpclient --save
```

OpenHarmony npm环境配置等更多内容，请参考[如何安装OpenHarmony npm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_npm_usage.md)

## 使用说明
```
import httpclient from '@ohos/httpclient';
```

获取HttpClient对象并配置超时时间

```javascript
this.client =new httpclient.HttpClient.Builder()
    .setConnectTimeout(10000)
    .setReadTimeout(10000)
    .setWriteTimeout(10000)
    .build();

var status :string= '' // 响应码
var content:string= '' // 响应内容
```

### GET请求方法示例

  ```javascript
  // 配置请求参数
let request = new httpclient.Request.Builder()
              .get("https://postman-echo.com/get?foo1=bar1&foo2=bar2")
              .addHeader(httpclient.ContentTypeConst.CONTENT_TYPE, httpclient.ContentTypeConst.JSON)
              .params("testKey1", "testValue1")
              .params("testKey2", "testValue2")
              .build();
  // 发起请求
  this.client.newCall(request).enqueue((result) => {
              if (result.response) {
                this.status = ""+result.response.responseCode;
              }
              if (result.response.result) {
                this.content = result.response.result;
              } else {
                this.content = JSON.stringify(result.response);
              }
              Log.showInfo("onComplete -> Status : " + this.status);
              Log.showInfo("onComplete -> Content : " + JSON.stringify(this.content));
            }, (error)=> {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
          }) 
  ```

### POST请求方法示例 

```javascript
 let request = new httpclient.Request.Builder()
              .url("https://postman-echo.com/post")
              .post(httpclient.RequestBody.create("test123"))
              .addHeader(httpclient.ContentTypeConst.CONTENT_TYPE, httpclient.ContentTypeConst.JSON)
              .build();

 this.client.newCall(request).execute().then((result) => {
              if (result.response) {
                this.status = ""+result.response.responseCode;
              }
              if (result.response.result) {
                this.content = result.response.result;
              } else {
                this.content = JSON.stringify(result.response);
              }
              Log.showInfo("onComplete -> Status : " + this.status);
              Log.showInfo("onComplete -> Content : " + JSON.stringify(this.content));
            }).catch((error)=> {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
        })
```

### POST请求方法带两个参数示例

  ```javascript
  let request = new httpclient.Request.Builder()
              .url("https://postman-echo.com/post")
              .post(httpclient.RequestBody.create({
                a: 'a1', b: 'b1'
              }, new httpclient.Mime.Builder()
              .contentType(httpclient.ContentTypeConst.JSON, 'charset', 'utf8').build().getMime()))
              .build();
// 发起同步请求
  this.client.newCall(request).execute().then((result) => {
              if (result.response) {
                this.status = ""+result.response.responseCode;
              }
              if (result.response.result) {
                this.content = result.response.result;
              } else {
                this.content = JSON.stringify(result.response);
              }
              Log.showInfo("onComplete -> Status : " + this.status);
              Log.showInfo("onComplete -> Content : " + JSON.stringify(this.content));
            }).catch((error)=> {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
  ```

### POST请求方法使用FormEncoder示例

  ```javascript
  let formEncoder = new httpclient.FormEncoder.Builder()
              .add('key1', 'value1')
              .add('key2', 'value2')
              .build();
            let feBody = formEncoder.createRequestBody();
            var request = new httpclient.Request.Builder()
              .url("https://postman-echo.com/post")
              .post(feBody)
              .build();

  this.client.newCall(request).execute().then((result) => {
              if (result.response) {
                this.status = ""+result.response.responseCode;
              }
              if (result.response.result) {
                this.content = result.response.result;
              } else {
                this.content = JSON.stringify(result.response);
              }
              Log.showInfo("onComplete -> Status : " + this.status);
              Log.showInfo("onComplete -> Content : " + JSON.stringify(this.content));
            }).catch((error)=> {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
  ```

### PUT请求示例

  ```javascript
let request = new httpclient.Request.Builder()
              .url("https://postman-echo.com/put")
              .put(httpclient.RequestBody.create({
                a: 'a1', b: 'b1'
              }, new httpclient.Mime.Builder()
              .contentType(httpclient.ContentTypeConst.JSON, 'charset', 'utf8').build()))
              .build();

 this.client.newCall(request).execute().then((result) => {
              if (result.response) {
                this.status = ""+result.response.responseCode;
              }
              if (result.response.result) {
                this.content = result.response.result;
              } else {
                this.content = JSON.stringify(result.response);
              }
              Log.showInfo("onComplete -> Status : " + this.status);
              Log.showInfo("onComplete -> Content : " + JSON.stringify(this.content));
            }).catch((error) => {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            });
  ```

### DELETE请求示例

  ```javascript
let request = new httpclient.Request.Builder()
              .url("https://reqres.in/api/users/2")
              .delete()
              .build();

 this.client.newCall(request).execute().then((result) => {
      if (result.response) {
          this.status = ""+result.response.responseCode;
      }
      if (result.response.result) {
           this.content = result.response.result;
      } else {
           this.content = JSON.stringify(result.response);
      }
         Log.showInfo("onComplete -> Status : " + this.status);
         Log.showInfo("onComplete -> Content : " + JSON.stringify(this.content));
      }).catch((error) => {
         this.status = "";
         this.content = error.data;
         Log.showInfo("onError -> Error : " + this.content);
      });
  ```

### tag取消请求示例

```javascript
 var request = new httpclient.Request.Builder()
                  .get()
                  .url(this.echoServer)
                  .tag("tag123") // 给请求设置tag
                  .addHeader(httpclient.ContentTypeConst.CONTENT_TYPE, httpclient.ContentTypeConst.JSON)
                  .build();

 this.client.newCall(request).enqueue((result) => {
      if (result.response) {
         this.status = result.response.responseCode + " ";
      }
      if (result.response.result)
         this.content = result.response.result;
       else
         this.content = JSON.stringify(result.response);
        }, (error) => {
         this.content = JSON.stringify(error);
    });

  this.client.cancelRequestByTag("tag123"); // 通过tag取消请求
```



### 文件上传示例

需要在AbilityStage或者Ability 里面获取全局使用的context对象

```javascript
export default class MainAbility extends Ability {
    onCreate(want, launchParam) {
        console.log("[Demo] MainAbility onCreate")
        globalThis.abilityWant = want;
    }
    onWindowStageCreate(windowStage) {
        // Main window is created, set main page for this ability
        console.log("[Demo] MainAbility onWindowStageCreate")
        //  定义全局使用的Context
        globalThis.abilityContext = this.context; 
        //  定义全局使用的缓存路径 /data/storage/el2/base/haps/entry/cache
        globalThis.cacheDir = this.context.cacheDir
        //  定义全局使用的缓存路径 /data/storage/el2/base/haps/entry/files
        globalThis.filesDir = this.context.filesDir 
        windowStage.setUIContent(this.context, "pages/index", null)
    }

  
};
```

 获取上传文件的路径 并生成上传文件(此步骤可以省略 上传文件也可通过命令导入设备) ，同时处理上传文件路径

  ```javascript
	 const ctx = this
     Log.showInfo(" cacheDir   " + globalThis.cacheDir)
     let filePath = globalThis.cacheDir + this.fileName;
     Log.showInfo("   filePath   " + filePath)
     let fd = fileio.openSync(filePath, 0o102, 0o666)
     fileio.ftruncateSync(fd)
     fileio.writeSync(fd, "test httpclient")
     fileio.fsyncSync(fd)
     fileio.closeSync(fd)

    Log.showInfo(" writeSync    ");
    Log.showInfo( "create file success   ")
	
	// 由于文件上传目前仅支持“dataability”和“internal”两种协议类型，
	// 但“internal”仅支持临时目录，示例 internal://cache/path/to/file.txt	          	  
	// 所以需要将拿到的文件路径转化为internal格式的路径
    filePath = filePath.replace(globalThis.cacheDir, "internal://cache");

  ```

开始上传

```javascript
    //生成文件上传对象并包装参数
    let fileUploadBuilder = new httpclient.FileUpload.Builder()
      .addFile(filePath,'profileIcon') // filePath指的是文件路径，如internal://cache/test.jpg    'profileIcon'对应Web开发file组件的name属性，用于标识不同的file，与后端API对应。若不设置则默认截取文件路径使用获取到的文件名，如test.
      .addData("name2", "value2")
      .build();
    let fileObject = fileUploadBuilder.getFile();
    let dataObject = fileUploadBuilder.getData();
    
    Log.showInfo( "fileObject:   "+JSON.stringify(fileObject));
    Log.showInfo( "dataObject:   "+JSON.stringify(dataObject));
    Log.showInfo('cacheDir  = ' + globalThis.abilityContext.cacheDir);
    Log.showInfo('filesDir  = ' + globalThis.abilityContext.filesDir);
    Log.showInfo("type of :"+ typeof globalThis.abilityContext)

	// 生成上传参数
    let request = new httpclient.Request.Builder()
      .url(this.fileServer)
      .addFileParams(fileObject, dataObject)
      .setAbilityContext(globalThis.abilityContext)
      .build();

    this.client.newCall(request).execute().then((data) => {
        // 上传进度回调监听
      data.on('progress', (uploadedSize, totalSize) => {
        Log.showInfo('progress--->uploadedSize: ' + uploadedSize 
                     + ' ,totalSize--->' + totalSize);
        if (uploadedSize == totalSize){
			 Log.showInfo("upload success")
        }
      })
        // 上传完毕回调监听
      data.on('headerReceive', (headers) => {
        Log.showInfo( 'progress--->uploadSize: ' + JSON.stringify(headers));
      })
    }).catch((error)=> {
      this.status = "";
      this.content = error.data;
      Log.showInfo("onError -> Error : " + this.content);
    });
```

### 文件下载请求示例

下载模块有部分断点下载功能，下载任务开启后会在后台执行，即使下载页面关闭或者APP被杀死，并且短暂断网重连之后也会自动重试下载。

  ```typescript
 var request = new httpclient.Request.Builder()
                .url("http://j5391e6947.zicp.vip/download/blue.jpg")
                .setFileName('test.rar') // 用于设置下载文件重命名，可不设置此项        
                .download()
                .setAbilityContext(globalThis.abilityContext)
                .build();

  this.client.newCall(request).execute().then((downloadTask) => {
       downloadTask.on('progress', (receivedSize, totalSize) => {
          Log.showInfo('progress--->receivedSize: ' + receivedSize + ' ,totalSize--->' + totalSize);

                })
        downloadTask.on('complete', () => {
            Log.showInfo("download complete file:"+globalThis.abilityContext.filesDir+"/box2-home.png");
            this.content = "Download Task Completed";
                })
        }).catch((error)=> {
            this.status = "";
            this.content = error.data;
            Log.showInfo("onError -> Error : " + this.content);
       });
  ```

### 拦截器使用示例

```javascript
// 通过addInterceptor添加拦截器，可以添加单个或者两个，允许为空。req是请求拦截器，res是响应拦截器
// addInterceptor允许调用多次，添加多个拦截器，拦截器的调用顺序根据添加顺序来决定
let request = new httpclient.Request.Builder()
           		.url('https://postman-echo.com/post')
            	.post()
         		.body(httpclient.RequestBody.create('test123'))
         		.setDefaultConfig(defaultConfigJSON)
         		.addInterceptor((req) => {
                  var route = new httpclient.Route(this.info);
                  // Now we have got the interceptor, now we can connect to
                  // IPAddress one after the other if previous one fails
                  Log.showInfo("onDNSRequest and route" + route);
                  return req;
                }, (res) => {
                  return res;
                })
           		.build();
           		
   this.client.newCall(request).execute().then((result) => {
              if (result.response) {
                this.status = ""+result.response.responseCode;
              }
              if (result.response.result) {
                this.content = result.response.result;
              } else {
                this.content = JSON.stringify(result.response);
              }
              Log.showInfo("onComplete -> Status : " + this.status);
              Log.showInfo("onComplete -> Content : " + JSON.stringify(this.content));
            }).catch((error) => {
              this.status = "";
              this.content = error.data;
              Log.showInfo("onError -> Error : " + this.content);
            }); 
```

### gzip解压缩示例

客户端压缩

```javascript
// 压缩字符串 
const test = "hello, world，adjasjdakjdakjdkjakjdakjskjasdkjaskjdajksdkjasdkjaksjdka";
var compressed = httpclient.gZipUtil.gZipString(test); 
// 压缩文件
  let fpath = getContext(this).cacheDir + "/hello.txt";
  let dest = getContext(this).cacheDir + "/test.txt.gz";
  httpclient.gZipUtil.gZipFile(fpath, dest);
```

客户端解压缩

```javascript
// 解压缩字符串
const test = "hello,world!adjasjdakjdakjdkjakjdakjskjasdkjaskjdajksdkjasdkjaksjdkja";
var compressed = httpclient.gZipUtil.gZipString(test); // 压缩字符串
var restored = httpclient.gZipUtil.ungZipString(compressed); // 解压缩

// 解压缩文件
  let fpath = getContext(this).cacheDir + "/hello.txt.gz";
  let dest = getContext(this).cacheDir + "/test.txt";
  httpclient.gZipUtil.ungZipFile(fpath, dest);

```

http支持自动解压缩

```javascript
  var request = new httpclient.Request.Builder()
            .get("http://www.yourserverfortest.com")
            .addHeader(httpclient.ContentTypeConst.CONTENT_TYPE, httpclient.ContentTypeConst.JSON)
            .addHeader("Accept-Encoding", "gzip")
            .build();
            
  this.client.newCall(request).enqueue((result)=>{
     if (result.response) {
            this.status = '' + result.response.responseCode;
        }
        if (result.response.result)
        this.content = result.response.result;
        else
        this.content = result.response.toString();
  }, (err)=>{
    console.log("test auto ungzip err  "+err)
  });
```



### cookie管理示例

初始化

```javascript
export default {
    data: {
        status: "",
        content: "",
        client: new httpclient.HttpClient
            .Builder()
            .setConnectTimeout(10000)
            .setReadTimeout(10000)
            .build(),
        cookiejar : new httpclient.CookieJar(), // cookie对象操作类 
        cookiemanager : new httpclient.CookieManager(), // cookie存储策略管理对象
        store : new httpclient.CookieStore() // cookie存取实现类
    },
  }
```

给httpclient设置cookie管理的参数

```javascript
  Log.showInfo("http cookiejarRequest request sending ");
  var self  = this;
 
  this.cookiemanager.setCookiePolicy(httpclient.CookiePolicy.ACCEPT_ALL);// 设置缓存策略
  this.cookiejar.setCookieStore(this.store); // 设置cookie存取处理对象

  //first request to get the cookie
  let request1 = new httpclient.Request.Builder()
        .get(this.commonServer) //Modify URL
        .tag("tag_cookie1")
        .cookieJar(this.cookiejar) // 给httpclient设置缓存处理对象
        .cookieManager(this.cookiemanager) // 给httpclient设置缓存策略管理对象
        .addHeader(httpclient.ContentTypeConst.CONTENT_TYPE, httpclient.ContentTypeConst.JSON)
        .build();

   self.client.newCall(request1).enqueue(this.onComplete, this.onError);
```

//  设置httpclient请求回调

```javascript
    onComplete: function (result) {
        if (result.response) {
            this.status = result.response.responseCode;
        }
        if (result.response.result)
            this.content = result.response.result;
        else
            this.content = JSON.stringify(result.response);

        Log.showInfo("onComplete -> Content : " + JSON.stringify(this.content));
    },
    onError: function (error) {
        Log.showInfo("onError -> Error : " + error);
        this.content = JSON.stringify(error);
        Log.showInfo("onError -> Content : " + JSON.stringify(this.content));
    },
```



### 请求内容加解密示例

导入加密库crypto-js

```json
	"dependencies": {
		"@ohos/crypto-js": "^1.0.2"
	}
```

引入加密模块

```typescript
import { CryptoJS } from '@ohos/crypto-js'

const secretKey: string = 'abcd1234' 
```

使用AES加密请求内容，解密响应结果

```typescript
 var request = new httpclient.Request.Builder()
     .post()
     .body(httpclient.RequestBody.create("test123"))
     .url(this.echoServer)
     .addInterceptor((req) => {  // 请求拦截器
          Log.showInfo("inside AES interceptor request" + JSON.stringify(req.body.content))
       // 对请求体的内容进行aes加密
          var encrypted = CryptoJS.AES.encrypt(req.body.content,
                                               CryptoJS.enc.Utf8.parse(secretKey), {
                iv: CryptoJS.enc.Utf8.parse('0000000000'),
                mode: CryptoJS.mode.CBC,
                padding: CryptoJS.pad.Pkcs7,
                format: CryptoJS.format.Hex
              }).toString()
              req.body.content = encrypted;// 加密完成后对请求体重新赋值
           return req;
        }, (res) => { // 响应拦截器
        Log.showInfo("inside AES interceptor response")
       // 对响应信息进行AES解码
        var decrypted = CryptoJS.AES.decrypt(res.result, CryptoJS.enc.Utf8.parse(secretKey), {
                iv: CryptoJS.enc.Utf8.parse('0000000000'),
                mode: CryptoJS.mode.CBC,
                padding: CryptoJS.pad.Pkcs7,
                format: CryptoJS.format.Hex
              }).toString()
              console.log("AES decrypt = " + decrypted);
              res.result = decrypted; // 解密完成后重新设置响应体里面的相应信息
            return res; // 返回解码之后的响应结果
            })
        .build();
		// 发起请求
        this.client.newCall(request).execute().then((result) => {
            if (result.response) {
              this.status = result.response.responseCode + "";
            }
            if (result.response.result)
            this.content = result.response.result;
            else
            this.content = JSON.stringify(result.response);
        }).catch((error) => {
            this.content = JSON.stringify(error);
        });
```



## 接口说明

### Request.Builder

| 接口名                      | 参数                         | 返回值             | 说明                                       |
| ------------------------ | -------------------------- | --------------- | ---------------------------------------- |
| setAbilityContext        | abilityContext             | Request.Builder | 设置上下文，用于上传下载的参数                          |
| convertor                | convertorType              | Request.Builder | 设置转换器类型，用于将响应结果解析转换为需要的类型                |
| setCookieJar             | cookieJar                  | Request.Builder | 设置cookieJar，用于自动获取缓存的cookie，并自动设置给请求头    |
| setCookieManager         | cookieManager              | Request.Builder | 设置cookie管理器，用于设置cookie策略                 |
| retryOnConnectionFailure | isRetryOnConnectionFailure | Request.Builder | 设置当前请求失败是否重试                             |
| retryMaxLimit            | maxValue                   | Request.Builder | 设置当前请求可以重试的最大次数                          |
| retryConnectionCount     | count                      | Request.Builder | 设置当前请求当前已经重试次数                           |
| followRedirects          | aFollowRedirects           | Request.Builder | 设置当前请求是否是允许重定向                           |
| redirectMaxLimit         | maxValue                   | Request.Builder | 设置当前请求可以重定向的最大次数                         |
| redirectionCount         | count                      | Request.Builder | 设置当前请求当前已经重定向次数                          |
| addInterceptor           | req, resp                  | Request.Builder | 添加拦截器，req参数是请求拦截器，resp是响应拦截器。本方法允许多次调用添加多个拦截器。参数允许为空。 |
| headers                  | value                      | Request.Builder | 当前请求设置请求头                                |
| addHeader                | key, value                 | Request.Builder | 当前请求的请求头添加参数                             |
| setDefaultUserAgent      | value                      | Request.Builder | 当前请求设置默认的用户代理，它是一个特殊字符串头，使得服务器能够识别客户使用的操作系统及版本、CPU 类型、浏览器及版本、浏览器渲染引擎、浏览器语言、浏览器插件等。 |
| setDefaultContentType    | value                      | Request.Builder | 当前请求设置默认的媒体类型信息。                         |
| body                     | value                      | Request.Builder | 当前请求设置请求体                                |
| url                      | value                      | Request.Builder | 当前请求设置请求地址                               |
| tag                      | value                      | Request.Builder | 当前请求设置标签，用于取消请求                          |
| method                   | value                      | Request.Builder | 当前请求设置请求请求方式                             |
| params                   | key, value                 | Request.Builder | 当前请求设置请求参数，用于拼接在请求路径url后面                |
| addFileParams            | files, data                | Request.Builder | 当前请求添加文件上传参数                             |
| setFileName              | name                       | Request.Builder | 当前请求设置文件名，用于下载请求                         |
| get                      | url                        | Request.Builder | 当前请求的请求方式设置为GET，如果参数url不为空则还需为request设置请求路径url |
| put                      | body                       | Request.Builder | 当前请求的请求方式设置为PUT，如果参数body不为空则还需为request设置请求体body |
| delete                   | 暂无                         | Request.Builder | 当前请求的请求方式设置为DELETE                       |
| head                     | 暂无                         | Request.Builder | 当前请求的请求方式设置为HEAD                         |
| options                  | 暂无                         | Request.Builder | 当前请求的请求方式设置为OPTIONS                      |
| post                     | body                       | Request.Builder | 当前请求的请求方式设置为POST，如果参数body不为空则还需为request设置请求体body |
| upload                   | files, data                | Request.Builder | 当前请求的请求方式设置为UPLOAD，同时设置文件列表参数files和额外参数data |
| download                 | url,filename               | Request.Builder | 当前请求的请求方式设置为DOWNLOAD，如果参数filename不为空则还需为request设置文件名filename |
| trace                    | 暂无                         | Request.Builder | 当前请求的请求方式设置为TRACE                        |
| connect                  | 暂无                         | Request.Builder | 当前请求的请求方式设置为CONNECT                      |
| setDefaultConfig         | defaultConfig              | Request.Builder | 当前请求添加默认配置，主要包括设置默认的content_type和user_agent，可以通过传入一个json文件的方式来全局配置 |
| build                    | 暂无                         | Request.Builder | 当前请求根据设置的各种参数构建一个request请求对象             |

### HttpClient.Builder

| 接口名               | 参数                             | 返回值                | 说明                                       |
| ----------------- | ------------------------------ | ------------------ | ---------------------------------------- |
| addInterceptor    | aInterceptor                   | HttpClient.Builder | 为HTTP请求客户端添加拦截器，用于在发起请求之前或者获取到相应数据之后进行某些特殊操作 |
| authenticator     | aAuthenticator                 | HttpClient.Builder | 为HTTP请求客户端添加身份认证，可以在请求头中添加账号密码等信息。       |
| setConnectTimeout | timeout, unit                  | HttpClient.Builder | 为HTTP请求客户端设置连接超时时间                       |
| setReadTimeout    | timeout, unit                  | HttpClient.Builder | 为HTTP请求客户端设置读取超时时间                       |
| setWriteTimeout   | timeout, unit                  | HttpClient.Builder | 为HTTP请求客户端设置写入超时时间                       |
| _setTimeOut       | timeout, timeUnit, timeoutType | HttpClient.Builder | 为HTTP请求客户端设置超时时间，根据timeoutType来区分是连接超时时间还是读取超时时间或者是写入超时时间。 |
| build             | 暂无                             | HttpClient.Builder | 构建HTTP请求客户端对象                            |

### HttpCall

| 接口名                | 参数   | 返回值        | 说明                |
| ------------------ | ---- | ---------- | ----------------- |
| getRequest         | 暂无   | Request    | 获取当前请求任务的请求对象     |
| getClient          | 暂无   | HttpClient | 获取当前请求任务的请求客户端    |
| execute            | 暂无   | Promise    | 当前请求任务发起同步请求      |
| enqueue            | 暂无   | 暂无         | 当前请求任务发起异步请求      |
| getSuccessCallback | 暂无   | Callback   | 获取当前请求任务的请求成功回调接口 |
| getFailureCallback | 暂无   | Callback   | 获取当前请求任务的请求失败回调接口 |
| cancel             | 暂无   | 暂无         | 取消当前请求任务          |
| isCancelled        | 暂无   | Boolean    | 获取当前请求任务是否成功取消了   |

### WebSocket

| 接口名                 | 参数                      | 返回值       | 说明                          |
| ------------------- | ----------------------- | --------- | --------------------------- |
| socketObject        | 暂无                      | WebSocket | 获取可使用的WebSocket             |
| url                 | value                   | WebSocket | 设置WebSocket的请求路径            |
| connect             | success, error          | 暂无        | WebSocket连接服务器，并监听连接状态      |
| sendMessage         | message, success, error | 暂无        | WebSocket向服务器发送消息，并监听消息发送结果 |
| webSocketDisconnect | success, error          | 暂无        | WebSocket断开连接，并监听断开连接结果     |



### RequestBody

| 接口名    | 参数                                       | 返回值         | 说明              |
| ------ | ---------------------------------------- | ----------- | --------------- |
| create | content : String/JSON Object of Key:Value pair | RequestBody | 创建RequestBody对象 |

### RequestBuilder

| 接口名             | 参数                       | 返回值            | 说明                  |
| --------------- | ------------------------ | -------------- | ------------------- |
| buildAndExecute | 无                        | void           | 构建并执行RequestBuilder |
| newCall         | 无                        | void           | 执行请求                |
| header          | name:String,value:String | RequestBuilder | 传入key、value构建请求头    |
| connectTimeout  | timeout:Long             | RequestBuilder | 设置连接超时时间            |
| url             | value:String             | RequestBuilder | 设置请求url             |
| GET             | 无                        | RequestBuilder | 构建GET请求方法           |
| PUT             | body:RequestBody         | RequestBuilder | 构建PUT请求方法           |
| DELETE          | 无                        | RequestBuilder | 构建DELETE请求方法        |
| POST            | 无                        | RequestBuilder | 构建POST请求方法          |
| UPLOAD          | files:Array, data:Array  | RequestBuilder | 构建UPLOAD请求方法        |
| CONNECT         | 无                        | RequestBuilder | 构建CONNECT请求方法       |

### MimeBuilder

| 接口名         | 参数           | 返回值  | 说明                         |
| ----------- | ------------ | ---- | -------------------------- |
| contentType | value:String | void | 添加MimeBuilder contentType。 |

### FormEncodingBuilder

| 接口名   | 参数                       | 返回值  | 说明              |
| ----- | ------------------------ | ---- | --------------- |
| add   | name:String,value:String | void | 以键值对形式添加参数      |
| build | 无                        | void | 获取RequestBody对象 |

### FileUploadBuilder

| 接口名       | 参数                       | 返回值  | 说明              |
| --------- | ------------------------ | ---- | --------------- |
| addFile   | furi : String            | void | 添加文件URI到参数里用于上传 |
| addData   | name:String,value:String | void | 以键值对形式添加请求数据    |
| buildFile | 无                        | void | 生成用于上传的文件对象     |
| buildData | 无                        | void | 构建用于上传的数据       |

## 兼容性

支持OpenHarmony API version 9 的stage model，适配DevEco 3.1.0.100。

版本号：1.0.4

## 目录结构

```javascript
|---- httpclient  
|     |---- entry  # 示例代码文件夹
|     |---- httpclient  # httpclient 库文件夹
			|---- builders  # 请求体构建者模块 主要用于构建不同类型的请求体，例如文件上传，multipart
			|---- callback  # 响应回调模块，用于将相应结果解析之后转换为常见的几种类型回调给调用者，例如string,JSON对象，bytestring
            |---- cookies  # cookie管理模块，主要处理将响应结果解析并根据设置的缓存策略缓存响应头里面的cookie，取出cookie，更新cookie
            |---- core  # 核心模块，主要是从封装的request里面解析请求参数和相应结果，调用拦截器，处理错误重试和重定向，dns解析，调用系统的@ohos.net.http模块发起请求
			|---- dispatcher  # 任务管理器模块，用于处理同步和异步任务队列
			|---- utils  # 工具类，提供dns解析，gzip解压缩，文件名校验，打印日志等功能
            |---- HttpCall.js  # 一个请求任务，分为同步请求和异步请求，封装了请求参数，请求客户端，请求成功和失败的回调，请求是否取消的标志。
            |---- HttpClient.js  # 请求客户端，用于生成请求任务用于发起请求，设置请求参数，处理gzip解压缩，取消请求。
			|---- Request.js  # 请求对象，用于封装请求信息，包含请求头和请求体。 
            |---- RequestBody.js  # 请求体，用于封装请求体信息。 
            |---- WebSocket.js  # websocket模块，用于提供websocket支持。 
            |---- index.ets  # httpclient对外接口
|     |---- crypto  # 加密库 库文件夹
			|---- ets  # TS语言的加密库主要逻辑，主要来自于crypto-ts库和crypto-js库，适配于Openharmony
 			|---- js  # JS语言 提供Base64,十六进制的编解码，MD5加密功能。
|     |---- README.MD  # 安装使用方法                   
```

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/httpclient/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/httpclient/pulls)。

## 开源协议

本项目基于 [Apache License 2.0](https://gitee.com/openharmony-tpc/httpclient/blob/master/LICENSE)，请自由地享受和参与开源。