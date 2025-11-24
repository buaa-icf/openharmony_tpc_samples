# ohos/ohos-nacl

## 简介

> ohos/ohos-nacl是适用于OpenHarmony系统的NaCl加密库，提供了基于现代加密算法的高级API接口，包括哈希计算、数字签名、公钥加密、私钥加密等功能。

ohos/ohos-nacl库基于js-nacl开发，针对OpenHarmony系统进行了适配，提供了以下功能：
- 哈希计算（SHA-512、SHA-256）
- 数字签名（crypto_sign）


## 下载安装

```shell

ohpm install @ohos/ohos-nacl

```

OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) .



## 使用说明

1. 引入文件及代码依赖

 ```

 import nacl_factory from '@ohos/ohos-nacl'

 

 nacl_factory.instantiate(function (nacl) {

   // 使用nacl API

   console.log(nacl.to_hex(nacl.random_bytes(16)));

 });

 ```

或者使用Promise方式：

 ```

 import nacl_factory from '@ohos/ohos-nacl'

 

 nacl_factory.instantiate().then(function (nacl) {

   // 使用nacl API

   console.log(nacl.to_hex(nacl.random_bytes(16)));

 });

 ```



## 接口说明
### 初始化NaCl加密库
* instantiate - 异步加载和初始化NaCl加密库

### 字符串与二进制数据转换
* to_hex - 将二进制数据转换为小写十六进制字符串
* from_hex - 将十六进制字符串转换为二进制数据
* encode_utf8 - 使用UTF-8编码将字符串转换为二进制数据
* encode_latin1 - 使用Latin1编码将字符串转换为二进制数据
* decode_utf8 - 使用UTF-8解码将二进制数据转换为字符串
* decode_latin1 - 使用Latin1解码将二进制数据转换为字符串

### 哈希函数
* crypto_hash - 计算SHA-512哈希值
* crypto_hash_sha256 - 计算SHA-256哈希值

### 公钥加密认证 (crypto_box)
* crypto_box_keypair - 生成随机密钥对
* crypto_box_random_nonce - 生成随机nonce
* crypto_box_seed_keypair - 从种子生成确定性密钥对
* crypto_box_keypair_from_raw_sk - 从原始私钥生成密钥对

### 私钥加密认证 (crypto_secretbox)
* crypto_secretbox_random_nonce - 生成随机nonce

### 数字签名 (crypto_sign)
* crypto_sign_keypair - 生成签名密钥对
* crypto_sign - 对消息进行签名
* crypto_sign_open - 验证签名并提取消息
* crypto_sign_detached - 生成分离式签名
* crypto_sign_verify_detached - 验证分离式签名
* crypto_sign_seed_keypair - 从种子生成确定性签名密钥对

### 其他工具函数
* random_bytes - 生成随机字节

## 目录结构

````

ohos-nacl

├── AppScope/                   # 应用全局资源
├── entry/                      # 主模块
│   ├── src/
│   │   ├── main/               # 主代码目录
│   │   ├── ohosTest/           # OpenHarmony测试目录
│   │   └── test/               # 单元测试目录
│   ├── oh-package.json5        # 模块包配置
│   └── ...                     # 其他配置文件
├── library/                    # 公共库模块
│   ├── src/
│   │   └── main/
│   │       └── lib/
│   │           ├── naclType.ts      # 类型定义文件
│   │           ├── nacl_factory.ets # 核心功能
│   │           └── utils.ts         # 核心功能实现
│   ├── oh-package.json5        # 包的元数据和依赖信息
│   ├── index.ets               # 库的入口文件
│   ├──  index.d.ts             # 库的类型定义文件
│   └── ...                     # 其他文件
├── README_zh.md                # 项目中文文档和说明
├── oh-package.json5            # 项目配置文件
└── ...                         # 其他配置文件               

````
## 约束与限制
在下述版本验证通过：

-  DevEco Studio: 5.1.1.850, SDK: API12 (5.0.0)