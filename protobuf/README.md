# protobuf

### 介绍

ProtoBuf(protocol buffers) 是一种语言无关、平台无关、可扩展的序列化结构数据的方法，它可用于（数据）通信协议、数据存储等。,是一种灵活，高效，自动化机制的结构数据序列化方法比XML更小,更快,更为简单。

本项目主要是OpenHarmony系统下以[protobufjs](https://github.com/protobufjs/protobuf.js)为主要依赖开发，主要接口针对OpenHarmony系统进行合理的适配研发。

### 下载安装

1.安装

```
npm install protobufjs@5.0.3
```

2.在需要使用的页面导入protobufjs

```
import  protobuf  from 'protobufjs'
```

### 使用说明

##### 简单使用接口方式
1. 先定一个proto的格式协议字符串或.proto文件

```
const protoStr = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
```

或 在resources->base->media下按照proto格式定义xxx.proto文件

```
syntax = "proto3";  
package User;
message UserLoginResponse{
   string sessionId = 1;
   string userPrivilege = 2;
   bool isTokenType = 3;
   string formatTimestamp = 4;
}
```

2.使用接口解析
```
var builder = protobuf.newBuilder();
    ProtoBuf.loadProto(proto,builder,"bench.proto");
```
或
```
var builder = protobuf.newBuilder();
    var root = protobuf.loadJson(json, builder, fileName);
```

3. 通过builder找到协议名后会产生Message，并创建一个相同协议结构的数据对象，放入已实例的Message

```
 var UserLoginResponse = root.build("com.user.UserLoginResponse");

    const userLogin = {
      sessionId: "xd3sdfsd22",
      userPrivilege: "John123",
      isTokenType: false,
      formatTimestamp: "12342222"
    };

    var msg = new UserLoginResponse(userLogin);
```

4. 将Message序列化,可进行通信传递或存储

```
var arrayBuffer = msg.toArrayBuffer();
```

5. 对方拿到传递或存储的数据再按照1，2，3步骤拿到UserLoginResponse对象后再进行反序列化即可得到数据

```
var decodeMsg = UserLoginResponse.decode(arrayBuffer);
```

##### 使用解析File文件方式

1. 在使用以下2个接口前需要注意几点： loadProtoFile接口和loadJsonFile接口
   引用以下几段代码以适配nodejs，
   loadProtoFile接口和loadJsonFile接口都需要配置下面这段代码做适配，否则无法使用这两个接口

```
import { MyFs } from './MyFs'
protobuf.Util.fetch = function (path, callback) {
  if (callback && typeof callback != 'function')
  callback = null;
  if (callback) {
    MyFs.readFile(path, function (err, data) {
      if (err)
      callback(null);
      else
      callback("" + data);
    });
  } else
  try {
    return MyFs.readFileSync(path);
  } catch (e) {
    return null;
  }
}
```
2.提前获取内存路径和将.proto文件写入到内存中

```
 //创建一个proto文件内存路径,globalThis.context是通过在MainAbility->MainAbility.ts的onCreate中定义的一个属性{globalThis.context = this.context;}
 let protoPath = globalThis.context.filesDir + "/userproto.proto";
 //将proto数据写入内存
 FileUtils.getInstance().writeData(protoPath, protoStr);
 
```
3.使用接口解析

```
 var root = protobuf.loadProtoFile(path);
    //读取完文件的数据后清理掉，避免二次进入页面数据重复存储导致错误
    FileUtils.getInstance().clearFile(path);
```


4. 通过builder找到协议名后会产生Message，并创建一个相同协议结构的数据对象，放入已实例的Message

```
 var UserLoginResponse = root.build("com.user.UserLoginResponse");

    const userLogin = {
      sessionId: "xd3sdfsd22",
      userPrivilege: "John123",
      isTokenType: false,
      formatTimestamp: "12342222"
    };

    var msg = new UserLoginResponse(userLogin);
```

5. 将Message序列化,可进行通信传递或存储

```
var arrayBuffer = msg.toArrayBuffer();
```

6. 对方拿到传递或存储的数据再按照1，2，3步骤拿到UserLoginResponse对象后再进行反序列化即可得到数据

```
var decodeMsg = UserLoginResponse.decode(arrayBuffer);
```

### 接口说明

1， public static newBuilder(): any 

Constructs a new empty Builder.

2， .loadProtoFile(path);

同步解析proto文件的方式

3，.loadProtoFile(path, (err, root) => {}

异步解析proto文件的方式

4，.loadProto(proto, builder, fileName);

解析proto字符串方式

5，.loadJson(json, builder, fileName);

解析json字符串方式

6，.loadJsonFile(path);
同步解析json文件的方式

7，loadJsonFile(path, (err, root) => {}
异步解析json文件的方式

8，.toArrayBuffer(); 将Message序列化

9，.decode(buffer); 将buffer数据反序列化

### 兼容性

- [DevEco Studio](https://developer.harmonyos.com/cn/develop/deveco-studio#download) 版本：DevEco Studio 3.1 Beta1及以上版本。
- OpenHarmony SDK版本：API version 9 及以上版本。

### 软件架构

```
|-ets
|   |- pages
|        |-index.ets             #主页
|        |-FileUtils.ets         #File文件工具类
|        |-MyFs.ets              #fs适配封装
|        |-rpc.ets               #rpc例子
|        |-serialized.ets        #序列化例子
|        |-websocket.ets         #websocket结合使用例子
|        |-writer_reader.ets     #writer_reader用例子

```

### 版本

当前版本：

```
1.2.0
```

