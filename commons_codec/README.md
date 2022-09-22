# commons-codec

## 简介
- commons-codec是一个OpenHarmony系统下使用各种编解码的示例，包含各种格式的简单编码器和解码器， 例如 Base64  Base32 等除了这些广泛使用的编码器和解码器之外，编解码器包还维护了一组语音编码实用程序。
- 目前项目可支持的功能有如下

| 二进制编码器  | 摘要编码器  | 语言编码器 | url编码 |
| :------------ |:---------------:| -----:|-----:|
| Base64   编解码  | SHA256 | CaverPhone |urlencode |
| Base32  编解码   | SHA224 | Soundex |
| 二进制           | SHA1   | Metaphone |
| 十六进制          |MD5    |
|                 |MD2     |

## 下载安装

| 编码功能名称  | URL地址  |   npm安装   |
| :------------ |:---------------:| -----:|
| caverphone     | https://github.com/tcort/caverphone | npm install --save caverphone |
| base32      | https://github.com/emn178/hi-base32      |  npm install hi-base32 |
| base64  |https://github.com/dankogai/js-base64#readme       |    npm install --save js-base64 |
| MD2 | https://github.com/emn178/js-md2        |   npm install js-md2 |
| MD5 | https://github.com/emn178/js-md5        |  npm install js-md5 |
| SHA1 | https://github.com/emn178/js-sha1        |   npm install js-sha1 |
| SHA256 | https://github.com/emn178/js-sha256        |   npm install js-sha256 |
| metaphone | https://github.com/words/metaphone       |    npm install metaphone |
| soundex | https://github.com/words/soundex-code      |   npm install soundex-code |

## 使用说明

### 导入Base64
```javascript
import jsBase64 from 'js-base64'
```
```javascript
jsBase64.encode('God is Perspective');
jsBase64.decode('UWkgTGkgWGlhbmc=')
```
### 导入Base32
```javascript
import jsBase32 from 'hi-base32'
```
```javascript
jsBase32.encode('God is Perspective')
jsBase32.decode('KFUSATDJEBMGSYLOM4======')
```
### 二进制编码
```javascript
export function strToArr(str) {
    var rs = [];
    ([].slice.call(str)).forEach(function (char) {
        rs.push(char.charCodeAt(0).toString(2));
    });

    return rs;
}
```
```javascript
strToArr('God is Perspective')
```
### 十六进制编码
```javascript
export function strToHexCharCode(str) {
    if (str === "")
    return "";
    var hexCharCode = [];
    hexCharCode.push("0x");
    for (var i = 0; i < str.length; i++) {
        hexCharCode.push((str.charCodeAt(i)).toString(16));
    }
    return hexCharCode.join("");
}
```
```javascript
strToHexCharCode('God is Perspective')  
```
### SHA256编码
```javascript
import jsSha256 from 'js-sha256'
```
```javascript
 sha256('God is Perspective')
 
 sha256.hex('God is Perspective')
```
```javascript
 sha224('God is Perspective')
 
 sha224.hex('God is Perspective')
```
### SHA1编码
```javascript
import jsSha1 from 'js-sha1'
```
```javascript

 jsSha1('God is Perspective')
 
 jsSha1.hex('God is Perspective') 
```
### SHA1编码
```javascript
import jsMd5 from 'js-md5'
```
### MD5编码
```javascript
 jsMd5('God is Perspective') 
```
### MD2编码
```javascript
import jsMd2 from 'js-md2'
```
```javascript
jsMd2('God is Perspective') 
```
### 语言编码
```javascript
import jsCaverPhone from 'caverphone'
import {soundex} from 'soundex-code'
import {metaphone} from 'metaphone'
```

```javascript
jsCaverPhone('word') 
soundex('phonetics') 
metaphone('michael')
```
### Url编码
```javascript
export function urlEncode(str) {

    return encodeURIComponent(str);
}
```

 ```javascript
 export function urlDecode(str) {

    return decodeURIComponent(str);
}
```

```javascript
urlEncode('word is word')

urlDecode('word%20is%20word')
```


## 兼容性
支持 OpenHarmony API version 8 及以上版本。

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/commons-codec/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/commons-codec/pulls) 。

## 开源协议
本项目基于 [Apache License 2.0](https://gitee.com/openharmony-tpc/commons-codec/blob/master/LICENSE) ，请自由地享受和参与开源。
