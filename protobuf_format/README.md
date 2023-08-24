# protobuf_format

## 介绍

基于@ohos/protobufjs 1.0.0版本的Message，提供格式转换能力，允许将Message输出重写为基本文本格式，如xml,json,html。

## 下载安装

1.安装

```
ohpm install @ohos/protobuf_format
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

2.在需要使用的页面导入protobuf,如Index.ets:

```
import ProtobufFormat from '@ohos/protobuf_format'
```

## 使用说明

**输入说明：**

本组件基于@ohos/protobufjs 1.0.0版本，以下简称Protobuf。实现Protobuf.Message转换为xml,json,html格式，需要先构建Protobuf.Message。

Protobuf支持加载解析proto字符串，proto json字符串，proto文件，proto json 文件；

可以通过以下接口构建Protobuf.Builder:

| 接口名称        | 参数                                                         |
| --------------- | ------------------------------------------------------------ |
| loadProto       | proto:string<br/>builder?:Protobuf.Builder&#124;string&#124;{root:string,file:string} <br/>fileName?:string&#124;{root:string,file:string} |
| protoFromString | proto:string<br/>builder?:Protobuf.Builder &#124;string&#124;{root:string,file:string} <br/>fileName?:string&#124;{root:string,file:string} |
| loadProtoFile   | fileName:string&#124;{root:string,file:string}<br/>callback?:(err:Error,builder:Protobut.Builder)=>{}<br/>builder?:Protobuf.Builder<br/>resManager:@ohos.resourceManager.ResourceManager |
| protoFromFile   | fileName:string&#124;{root:string,file:string}<br/>callback?:(err:Error,builder:Protobut.Builder)=>{}<br/>builder?:Protobuf.Builder<br/>resManager:@ohos.resourceManager.ResourceManager |
| loadJson        | json:string\|Object<br/>builder?:Protobuf.Builder<br/>fileName?:string&#124;{root:string,file:string} |
| loadJsonFile    | fileName:string&#124;{root:string,file:string}<br/>callback?:(err:Error,builder:Protobut.Builder)=>{}<br/>builder?:Protobuf.Builder<br/>resManager:@ohos.resourceManager.ResourceManager |

通过Protobuf.Builder.lookup()接口查找已构建的消息体：

| 接口名称 | 参数                                          | 返回值                                  |
| -------- | --------------------------------------------- | --------------------------------------- |
| lookup   | path?:string<br/>excludeNonNamespace?:boolean | Protobuf.Reflect.T<br/>//协议消息体泛型 |

通过Protobuf.Builder.build()接口构建消息体:

| 接口名称 | 参数                       | 返回值                                                |
| -------- | -------------------------- | ----------------------------------------------------- |
| build    | path?:string&#124;string[] | Protobuf.Builder.Message&#124;Object //协议消息体泛型 |

[更多Protobuf接口。](https://gitee.com/openharmony-tpc/protobuf/tree/1.x)

**构建Message示例**

1.在resource->rawfile文件夹下按照 .proto文件格式定义消息体结构，如：userproto.proto文件。

```
syntax = "proto3";

package com.user;
message UserLoginResponse{
   string sessionId = 1;
   string userPrivilege = 2;
   bool isTokenType = 3;
   string formatTimestamp = 4;
}
```

2.读取.proto 文件

```
let builder = await ProtobufFormat.Protobuf.loadProtoFile("userproto.proto", null, null, getContext(this).resourceManager)
```

3.构建消息体

```
// 构建消息体
var UserLoginResponse = builder.build("com.user.UserLoginResponse");
let userLoginData = {
    sessionId: "testAsynchronouslyLoadProtoFile",
    userPrivilege: "John123",
    isTokenType: false,
    formatTimestamp: "12342222"
  };

// 可对Message进行序列化与反序列化操作，也可进行格式转换
var message = new UserLoginResponse(userLoginData);
```

**主要接口示例：**

**Message转json**

构建消息体 ==》 转换为json字符串

```
const protoStr = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
// 解析proto文件，获取消息体构建工具类Builder
let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');

let UserLoginResponse = root.build("com.user.UserLoginResponse");
const userLogin = {
  sessionId: "message_to_json",
  userPrivilege: "John123",
  isTokenType: false,
  formatTimestamp: "12342222"
};
// 构建消息体
let msg = new UserLoginResponse(userLogin);
// Message转换为json字符串
let json = ProtoBufFormat.Format.messageToJson(msg);
```

**json转Message**

构建消息体构建工具类Builder， 组合消息体路径：包名+类名，定义json数据 ==》构建消息体

```
const protoStr = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
// 构建消息体构建工具类Builder
let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');

const userLogin = {
  sessionId: "json_to_message",
  userPrivilege: "John123",
  isTokenType: false,
  formatTimestamp: "12342222"
};

let json = ProtoBufFormat.Format.jsonToMessage(root,"com.user.UserLoginResponse",userLogin);
```

**Message转xml**

构建消息体 ==》 转换为xml字符串

```
const protoStr = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
// 解析proto文件，获取消息体构建工具类Builder
let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');

let UserLoginResponse = root.build("com.user.UserLoginResponse");
const userLogin = {
  sessionId: "message_to_json",
  userPrivilege: "John123",
  isTokenType: false,
  formatTimestamp: "12342222"
};
// 构建消息体
let msg = new UserLoginResponse(userLogin);
// Message转换为xml字符串
let xml = ProtoBufFormat.Format.messageToXml(msg);
```

**xml转Message**

构建消息体构建工具类Builder， 组合消息体路径：包名+类名，定义xml数据 ==》构建消息体

```
const protoStr = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
// 构建消息体构建工具类Builder
let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');

let xml = '<UserLoginResponse><sessionId>xml_to_message</sessionId><userPrivilege>John123</userPrivilege><isTokenType>false</isTokenType><formatTimestamp>12342222</formatTimestamp></UserLoginResponse>';
let msg = ProtoBufFormat.Format.xmlToMessage(root, 'com.user.UserLoginResponse', xml); 
```

**Message转html**

构建消息体 ==》 转换为html字符串

```
const protoStr = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
// 解析proto文件，获取消息体构建工具类Builder
let root = await ProtoBufFormat.Protobuf.loadProto(protoStr, null, 'user.proto');

let UserLoginResponse = root.build("com.user.UserLoginResponse");
const userLogin = {
  sessionId: "message_to_json",
  userPrivilege: "John123",
  isTokenType: false,
  formatTimestamp: "12342222"
};
// 构建消息体
let msg = new UserLoginResponse(userLogin);
// Message转换为html字符串
let xml = ProtoBufFormat.Format.messageToHtml(msg);
```

## 接口说明

**messageToJson**

static messageToJson(message: Protobuf.Builder.Message): string;

解析Message,将消息体及数据转换为json字符串。

参数：

| 参数名  | 类型                     | 必填 | 说明                               |
| ------- | ------------------------ | ---- | ---------------------------------- |
| message | Protobuf.Builder.Message | 是   | 构建成功的Proto文件对应的Message。 |

返回值：

| 类型   | 说明                         |
| ------ | ---------------------------- |
| string | 协议消息体对应的json字符串。 |

**jsonToMessage**

static jsonToMessage(builder: Protobuf.Builder, path: string, json: string | Object): Protobuf.Builder.Message;

将json字符串通过消息体构建器，结合数据，重新构建为Message消息体。

参数

| 参数名  | 类型                 | 必填 | 说明                                                  |
| ------- | -------------------- | ---- | ----------------------------------------------------- |
| builder | Protobuf.Builder     | 是   | 协议消息体构建器，其内部需要包含Message解析后的结构。 |
| path    | string               | 是   | 协议消息体的路径：包名+路径。                         |
| json    | string &#124; Object | 是   | 协议消息体对应的json字符串或json对象。                |

返回值：

| 类型                     | 说明         |
| ------------------------ | ------------ |
| Protobuf.Builder.Message | 协议消息体。 |

**messageToXml**

static messageToXml(message: Protobuf.Builder.Message): string;

解析Message,将消息体及数据转换为xml字符串。

| 参数名  | 类型                     | 必填 | 说明                               |
| ------- | ------------------------ | ---- | ---------------------------------- |
| message | Protobuf.Builder.Message | 是   | 构建成功的Proto文件对应的Message。 |

返回值：

| 类型   | 说明                                               |
| ------ | -------------------------------------------------- |
| string | 协议消息体对应的xml字符串,xml根节点为Message类名。 |

**xmlToMessage**

static xmlToMessage(builder: Protobuf.Builder, path: string, xml: string): Protobuf.Builder.Message;

将xml字符串通过消息体构建器，结合数据，重新构建为Message消息体。

| 参数名  | 类型             | 必填 | 说明                                                   |
| ------- | ---------------- | ---- | ------------------------------------------------------ |
| builder | Protobuf.Builder | 是   | 协议消息体构建器，其内部需要包含Message解析后的结构。  |
| path    | string           | 是   | 协议消息体的路径：包名+路径。                          |
| xml     | string           | 是   | 协议消息体对应的xml字符串，xml数据节点从类名节点开始。 |

返回值：

| 类型                     | 说明         |
| ------------------------ | ------------ |
| Protobuf.Builder.Message | 协议消息体。 |

**messageToHtml**

static messageToHtml(message: Protobuf.Builder.Message): string;

解析Message,将消息体及数据转换为html字符串。

参数：

| 参数名  | 类型                     | 必填 | 说明                               |
| ------- | ------------------------ | ---- | ---------------------------------- |
| message | Protobuf.Builder.Message | 是   | 构建成功的Proto文件对应的Message。 |

返回值：

| 类型   | 说明                         |
| ------ | ---------------------------- |
| string | 协议消息体对应的html字符串。 |

## 约束与限制
在下述版本验证通过：

DevEco Studio: 4.0 Canary2(4.0.1.300), SDK: API10 (4.0.8.6)

## 目录结构

```
|---- protobuf-format
|     |---- AppScrope  # 工程信息文件夹
|     |---- entry  # 示例代码文件夹
|     |---- protobufformat  # Message格式转换
|           |---- src/main  # 模块代码
|                |---- ets/   # 模块代码
|                     |---- ProtoBufFormat.ets     # 格式转换对外接口实现类
|                     |---- Util.ets     # 格式转换工具类
|            |---- index.ets          # 入口文件
|            |---- *.json5      # 配置文件
|     |---- README.md  # 安装使用方法
|     |---- README.OpenSource  # 开源说明
|     |---- CHANGELOG.md  # 更新日志
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [Apache-2.0 License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobuf_format/LICENSE) ，请自由地享受和参与开源。
