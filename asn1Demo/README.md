## asn1Demo

## 简介 
本demo是基于OpenHarmony系统下，验证js三方库[asn1](https://github.com/ComplyCloud/asn1) ,[base64](https://github.com/davidchambers/Base64.js)
,[hex-encode-decode](https://github.com/tiaanduplessis/hex-endcode-decode) ,[asn1-der](https://github.com/ComplyCloud/asn1-der) ,[asn1js](
https://github.com/PeculiarVentures/asn1.js)

#### 其功能简介
| 库名 | 功能介绍 | 安装 |
|----|----|----|
| asn1 | 用于构建 ASN.1对象模型以及JSON 序列化/反序列化 | npm install @complycloud/asn1 |
| asn1-der | 用于抽象语法符号一的 DER 序列化/反序列化 （ASN.1）| npm install @complycloud/asn1-der |
| asn1js | 提供ASN.1 BER 解码器和编码器 | npm install @fortanix/asn1js |
| base64 | 提供base64的编码与解码 | npm install Base64 |
| hex-encode-decode | 提供Hex十六进制的编码与解码 | npm install hex-encode-decode |


## 配置PolyFill插件
参照[Polyfill](https://gitee.com/openharmony-sig/openharmony-polyfill) 的配置规则，进行插件的配置

## example 说明
#### asn1 example

```
import { JSONDeserializer, JSONSerializer, Universal } from '@complycloud/asn1';
const { Bool, Integer, Null, PrintableString, Sequence } = Universal;
const sequence = new Sequence([
  new Integer(-Number.MAX_SAFE_INTEGER),
  new Integer(Number.MAX_SAFE_INTEGER),
  new Integer('424242424242424242424242424242424242'), // big integer
  new Null(),
  new Bool(true),
  new PrintableString('nice marmot'),
  new PrintableString('@#$%!&*()!_=&'),
]);
....

const serialize = new JSONSerializer();
const json = serialize(sequence);
....

const deserialize = new JSONDeserializer();
const asn1ObjectModel = deserialize(sequence);
   
```

#### asn1-der example

```

import { DERSerializer, DERDeserializer } from '@complycloud/asn1-der';

const serialize = new DERSerializer();
const asn1Sequence = new Universal.Sequence(
    new Universal.Integer(123),
    new Universal.PrintableString('Hello World'),
);

this.deserializeJsonTextDer = "DER 原抽象数据:" + JSON.stringify(asn1Sequence);
const bufferContainingDEREncodedASN1 = serialize(asn1Sequence);
this.deserializeJsonTextDerS = "DER 序列化数据：" + JSON.stringify(bufferContainingDEREncodedASN1);

const deserialize = new DERDeserializer();
const des = deserialize(bufferContainingDEREncodedASN1);
this.deserializeJsonTextDerD = "DER 反序列化数据:" + JSON.stringify(des);

```

#### asn1js example 
```
const testString = "My test Utf8String";
const asn = new asn1js.Utf8String({
  [value: testString,]([]())
});

const ber = asn.toBER();
const asnParsed = asn1js.fromBER(ber);

```
#### base64 example
```
import { btoa, atob } from 'Base64'
const data = btoa("ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz1234567890+/AA==!@#$%^&*()_-/][{}?:");
data= atob(data);

```

#### hex-encode-decode example
```
import { encode, decode } from 'hex-encode-decode'
const deserializeJsonTextHex = encode("ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz1234567890+/AA==!@#$%^&*()_-/][{}?:");
const decodeData = decode(deserializeJsonTextHex);

```

## 兼容性

- [DevEco Studio](https://developer.harmonyos.com/cn/develop/deveco-studio#download) 版本：DevEco Studio 3.1 Beta1及以上版本。
- OpenHarmony SDK版本：API version 9 及以上版本。

## 贡献代码

使用过程中发现任何问题都可以提 Issue 给我们，当然，我们也非常欢迎你给我们发PR。

## 开源协议
该项目基于[License](https://github.com/kpdecker/jsdiff/blob/master/LICENSE)