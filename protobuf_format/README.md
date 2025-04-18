# protobuf_format

## Introduction

protobuf_format can convert formats and rewrite the message output of @ohos/protobufjs 1.0.2 to basic text formats, such as XML, JSON, and HTML.

## How to Install

1. Install the project.

```
ohpm install @ohos/protobuf_format
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Import the protobuf_format library on the target page, for example, **Index.ets**.

```
import  { Format, Protobuf } from '@ohos/protobuf_format'
```

## How to Use

**Input:**

The project is based on @ohos/protobufjs 1.0.2. To convert Protobuf.Message to the XML, JSON, or HTML format, you need to build Protobuf.Message first.

Protobuf can load and parse proto strings, proto JSON strings, .proto files, and proto.json files.

You can build Protobuf.Builder using the following APIs:

| API       | Parameter                                                        |
| --------------- | ------------------------------------------------------------ |
| loadProto       | proto:string<br>builder?:Protobuf.Builder&#124;string&#124;{root:string,file:string} <br>fileName?:string&#124;{root:string,file:string} |
| protoFromString | proto:string<br>builder?:Protobuf.Builder &#124;string&#124;{root:string,file:string} <br>fileName?:string&#124;{root:string,file:string} |
| loadProtoFile   | fileName:string&#124;{root:string,file:string}<br>callback?:(err:Error,builder:Protobut.Builder)=>{}<br>builder?:Protobuf.Builder<br>resManager:@ohos.resourceManager.ResourceManager |
| protoFromFile   | fileName:string&#124;{root:string,file:string}<br>callback?:(err:Error,builder:Protobut.Builder)=>{}<br>builder?:Protobuf.Builder<br>resManager:@ohos.resourceManager.ResourceManager |
| loadJson        | json:string\|Object<br>builder?:Protobuf.Builder<br>fileName?:string&#124;{root:string,file:string} |
| loadJsonFile    | fileName:string&#124;{root:string,file:string}<br>callback?:(err:Error,builder:Protobut.Builder)=>{}<br>builder?:Protobuf.Builder<br>resManager:@ohos.resourceManager.ResourceManager |

Use the **Protobuf.Builder.lookup()** API to search for a constructed message body.

| API| Parameter                                         | Return Value                                 |
| -------- | --------------------------------------------- | --------------------------------------- |
| lookup   | path?:string<br>excludeNonNamespace?:boolean | Protobuf.Reflect.T<br>// Generic protocol message body|

Use the **Protobuf.Builder.build()** API to construct a message body.

| API| Parameter                      | Return Value                                               |
| -------- | -------------------------- | ----------------------------------------------------- |
| build    | path?:string&#124;string[] | Protobuf.Builder.Message&#124;Object // Generic protocol message body|

[More Protobuf APIs](https://gitcode.com/openharmony-tpc/protobuf/tree/1.x)

**Example of Building a Message**

1. Choose **resource** > **rawfile**, and define the message body structure based on the format of a .proto file, for example, **userproto.proto** file.

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

2. Read the .proto file.

```
let builder:ESObject = await Protobuf.loadProtoFile("userproto.proto", null, null, getContext(this).resourceManager)
```

3. Construct a message body.

```
// Construct a message body.
let UserLoginResponse:ESObject = builder.build("com.user.UserLoginResponse");
class UserInfo {
  sessionId: string = '';
  userPrivilege: string = '';
  isTokenType: boolean = false;
  formatTimestamp: string = '';
}
let userLoginData:UserInfo = {
    sessionId: "testAsynchronouslyLoadProtoFile",
    userPrivilege: "John123",
    isTokenType: false,
    formatTimestamp: "12342222"
  };

// Serialize and deserialize the message, and convert the format.
let message:ESObject = new UserLoginResponse(userLoginData);
```

**API Examples**

**Converting a Message to a JSON String**

Construct a message body. ==> Convert the message body to a JSON string.

```
const protoStr:string = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
// Parse the .proto file to obtain the message body builder.
let root: ESObject = await Protobuf.loadProto(protoStr, null, 'user.proto');

let UserLoginResponse: ESObject  = root.build("com.user.UserLoginResponse");
class UserInfo {
  sessionId: string = '';
  userPrivilege: string = '';
  isTokenType: boolean = false;
  formatTimestamp: string = '';
}
const userLogin: UserInfo = {
  sessionId: "message_to_json",
  userPrivilege: "John123",
  isTokenType: false,
  formatTimestamp: "12342222"
};
// Construct a message body.
let msg: ESObject  = new UserLoginResponse(userLogin);
// Convert the message into a JSON string.
let json: string = Format.messageToJson(msg);
```

**Converting a JSON String to a Message**

Construct the message body builder, combine the message body path as bundle name + class name, and define JSON data. ==> Construct the message body.

```
const protoStr:string = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
// Construct the message body builder.
let root: ESObject = await Protobuf.loadProto(protoStr, null, 'user.proto');
class UserInfo {
  sessionId: string = '';
  userPrivilege: string = '';
  isTokenType: boolean = false;
  formatTimestamp: string = '';
}
const userLogin:UserInfo = {
  sessionId: "json_to_message",
  userPrivilege: "John123",
  isTokenType: false,
  formatTimestamp: "12342222"
};

let message: ESObject = Format.jsonToMessage(root,"com.user.UserLoginResponse",userLogin);
```

**Converting a Message to an XML String**

Construct a message body. ==> Convert the message body to an XML string.

```
const protoStr:string = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
// Parse the .proto file to obtain the message body builder.
let root: ESObject = await Protobuf.loadProto(protoStr, null, 'user.proto');

let UserLoginResponse: ESObject = root.build("com.user.UserLoginResponse");
class UserInfo {
  sessionId: string = '';
  userPrivilege: string = '';
  isTokenType: boolean = false;
  formatTimestamp: string = '';
}
const userLogin:UserInfo = {
  sessionId: "message_to_json",
  userPrivilege: "John123",
  isTokenType: false,
  formatTimestamp: "12342222"
};
// Construct a message body.
let msg: ESObject = new UserLoginResponse(userLogin);
// Convert the message into an XML string.
let xml:string = Format.messageToXml(msg);
```

**Converting an XML String to a Message**

Construct the message body builder, combine the message body path as bundle name + class name, and define XML data. ==> Construct the message body.

```
const protoStr:string = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
// Construct the message body builder.
let root: ESObject = await Protobuf.loadProto(protoStr, null, 'user.proto');

let xml = '<UserLoginResponse><sessionId>xml_to_message</sessionId><userPrivilege>John123</userPrivilege><isTokenType>false</isTokenType><formatTimestamp>12342222</formatTimestamp></UserLoginResponse>';
let msg: ESObject = Format.xmlToMessage(root, 'com.user.UserLoginResponse', xml); 
```

**Converting a Message to an HTML String**

Construct a message body. ==> Convert the message body to an HTML string.

```
const protoStr:string = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
// Parse the .proto file to obtain the message body builder.
let root:ESObject = await Protobuf.loadProto(protoStr, null, 'user.proto');

let UserLoginResponse:ESObject = root.build("com.user.UserLoginResponse");
class UserInfo {
  sessionId: string = '';
  userPrivilege: string = '';
  isTokenType: boolean = false;
  formatTimestamp: string = '';
}
const userLogin:UserInfo = {
  sessionId: "message_to_json",
  userPrivilege: "John123",
  isTokenType: false,
  formatTimestamp: "12342222"
};
// Construct a message body.
let msg:ESObject = new UserLoginResponse(userLogin);
// Convert the message into an HTML string.
let xml:string = Format.messageToHtml(msg);
```

## Available APIs

**messageToJson**

static messageToJson(message: Protobuf.Builder.Message): string;

Parses a message and converts the message body and data into a JSON string.

Parameter:

| Name | Type                    | Mandatory| Description                              |
| ------- | ------------------------ | ---- | ---------------------------------- |
| message | Protobuf.Builder.Message | Yes  | Message to parse.|

Return value:

| Type  | Description                        |
| ------ | ---------------------------- |
| string | JSON string corresponding to the message body.|

**jsonToMessage**

static jsonToMessage(builder: Protobuf.Builder, path: string, json: string | Object): Protobuf.Builder.Message;

Uses the message body builder to rebuild a JSON string into a message body based on the data.

Parameters:

| Name | Type                | Mandatory| Description                                                 |
| ------- | -------------------- | ---- | ----------------------------------------------------- |
| builder | Protobuf.Builder     | Yes  | Message body builder, which must contain the structure of the parsed message.|
| path    | string               | Yes  | Path of the message body: bundle name + path.                        |
| json    | string &#124; Object | Yes  | JSON string or JSON object corresponding to the message body.               |

Return value:

| Type                    | Description        |
| ------------------------ | ------------ |
| Protobuf.Builder.Message | Message body.|

**messageToXml**

static messageToXml(message: Protobuf.Builder.Message): string;

Parses a message and converts the message body and data into an XML string.

| Name | Type                    | Mandatory| Description                              |
| ------- | ------------------------ | ---- | ---------------------------------- |
| message | Protobuf.Builder.Message | Yes  | Message to parse.|

Return value:

| Type  | Description                                              |
| ------ | -------------------------------------------------- |
| string | XML string corresponding to the message body. The XML root node is the message class name.|

**xmlToMessage**

static xmlToMessage(builder: Protobuf.Builder, path: string, xml: string): Protobuf.Builder.Message;

Uses the message body builder to rebuild an XML string into a message body based on the data.

| Name | Type            | Mandatory| Description                                                  |
| ------- | ---------------- | ---- | ------------------------------------------------------ |
| builder | Protobuf.Builder | Yes  | Message body builder, which must contain the structure of the parsed message. |
| path    | string           | Yes  | Path of the message body: bundle name + path.                         |
| xml     | string           | Yes  | XML string corresponding to the message body. The XML data node starts from the class name node.|

Return value:

| Type                    | Description        |
| ------------------------ | ------------ |
| Protobuf.Builder.Message | Message body.|

**messageToHtml**

static messageToHtml(message: Protobuf.Builder.Message): string;

Parses a message and converts the message body and data into an HTML string.

Parameter:

| Name | Type                    | Mandatory| Description                              |
| ------- | ------------------------ | ---- | ---------------------------------- |
| message | Protobuf.Builder.Message | Yes  | Message to parse.|

Return value:

| Type  | Description                        |
| ------ | ---------------------------- |
| string | HTML string corresponding to the message body.|
## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/protobuf_format
```
## Constraints
This project has been verified in the following versions:

DevEco Studio: 4.1 Canary2 (4.1.3.400), SDK: API 11 (4.1.0.36)

DevEco Studio: 4.0 Release (4.0.3.413), SDK: API 10 (4.0.10.3)

## Directory Structure

```
|---- protobuf-format
|     |---- AppScrope  # Project information
|     |---- entry  # Sample code
|     |---- protobufformat  # Message format conversion
|           |---- src/main  # Module code
|                |---- ets/   # Module code
|                     |---- ProtoBufFormat.ts     # Implementation class of external APIs for format conversion
|                     |---- Util.ts     # Util class for format conversion
|            |---- index.ts          # Entry file
|            |---- *.json5      # Configuration file
|     |---- sax  # XML parsing tool
|     |---- xml-js  # Conversion class of XML and JS
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme
|     |---- README.OpenSource  # Open Source Description
|     |---- CHANGELOG.md  # Changelog
```

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [Apache-2.0 License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobuf_format/LICENSE).
