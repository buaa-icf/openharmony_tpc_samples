# js-md5Demo

## 简介
本demo是基于openHarmony系统下使用三方js库[js-md5](https://github.com/emn178/js-md5)，JavaScript的简单MD5哈希函数支持UTF-8编码

## 下载安装
```
ohpm install js-md5
ohpm install @types/js-md5 --save-dev //import js-md5 的时候语法报错。其原因是js-md5包内不含类型声明，需要 @types/js-md5 下载这个包的声明文件，从而解决语法的报错。
```
OpenHarmony ohpm 环境配置等更多内容，请参考 [如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)
## 使用说明

```javascript
import { md5 } from 'js-md5';

let content:string = 'ABCDEFGHI';
let mess = md5(content);
let mess2 = md5.hex(content);
let mess3 = md5.base64(content);
// HMAC
md5.hmac('key', 'Message to hash');
```

## 接口说明

| API                                | Parameter                | Description |
|:-----------------------------------|:-------------------------|:------------|
| md5(data)                          | data:内容                  | 算法          |
| md5.hex(data)                      | data:内容                  | 算法          |
| md5.base64(data)                   | data:内容                  | 算法          |
| md5.digest(data)                   | data:内容                  | 算法          |
| md5.array(data)                    | data:内容                  | 算法          |
| md5.hmac(secretKey,message)        | secretKey:密钥, message:内容 | HMAC-MD5 算法 |
| md5.hmac.hex(secretKey,message)    | secretKey:密钥, message:内容 | HMAC-MD5 算法 |
| md5.hmac.base64(secretKey,message) | secretKey:密钥, message:内容 | HMAC-MD5 算法 |
| md5.hmac.digest(secretKey,message) | secretKey:密钥, message:内容 | HMAC-MD5 算法 |
| md5.hmac.array(secretKey,message)  | secretKey:密钥, message:内容 | HMAC-MD5 算法 |

## 约束与限制
在下述版本验证通过：

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)

- DevEco Studio: 4.0 Beta2(4.0.3.512), SDK: API10 (4.0.10.9)

- DevEco Studio: 3.1 Beta2(3.1.0.400), SDK: API9 Release(3.2.11.9)。

## 开源协议

本项目基于 [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/js-md5Demo/LICENSE) ，请自由地享受和参与开源。

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。