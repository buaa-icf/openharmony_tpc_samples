# ohos/js-nacl



## 简介

> ohos/js-nacl是适用于OpenHarmony系统的NaCl加密库，提供了基于现代加密算法的高级API接口，包括哈希计算、数字签名、公钥加密、私钥加密等功能。

ohos/js-nacl库基于js-nacl开发，针对OpenHarmony系统进行了适配，提供了以下功能：
- 哈希计算（SHA-512、SHA-256）
- 公钥加密认证（crypto_box）
- 私钥加密认证（crypto_secretbox）
- 数字签名（crypto_sign）
- 流加密（crypto_stream）
- 消息认证（crypto_auth、crypto_onetimeauth）
- 密钥派生功能


## 下载安装

```shell

ohpm install @ohos/js-nacl

```

OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) .



## 使用说明

1. 引入文件及代码依赖

 ```

 import nacl_factory from '@ohos/js-nacl'

 

 nacl_factory.instantiate(function (nacl) {

   // 使用nacl API

   console.log(nacl.to_hex(nacl.random_bytes(16)));

 });

 ```

或者使用Promise方式：

 ```

 import nacl_factory from '@ohos/js-nacl'

 

 nacl_factory.instantiate().then(function (nacl) {

   // 使用nacl API

   console.log(nacl.to_hex(nacl.random_bytes(16)));

 });

 ```



## 接口说明

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
 * crypto_box - 使用公钥加密消息
 * crypto_box_open - 解密公钥加密的消息
 * crypto_box_precompute - 预计算共享密钥
 * crypto_box_precomputed - 使用预计算密钥加密消息
 * crypto_box_open_precomputed - 使用预计算密钥解密消息
 * crypto_box_seed_keypair - 从种子生成确定性密钥对
 * crypto_box_keypair_from_raw_sk - 从原始私钥生成密钥对

### 私钥加密认证 (crypto_secretbox)
 * crypto_secretbox_random_nonce - 生成随机nonce
 * crypto_secretbox - 使用私钥加密消息
 * crypto_secretbox_open - 解密私钥加密的消息

### 数字签名 (crypto_sign)
 * crypto_sign_keypair - 生成签名密钥对
 * crypto_sign - 对消息进行签名
 * crypto_sign_open - 验证签名并提取消息
 * crypto_sign_detached - 生成分离式签名
 * crypto_sign_verify_detached - 验证分离式签名
 * crypto_sign_seed_keypair - 从种子生成确定性签名密钥对

### 流加密 (crypto_stream)
 * crypto_stream_random_nonce - 生成随机nonce
 * crypto_stream - 生成密钥流
 * crypto_stream_xor - 使用密钥流进行XOR操作

### 消息认证
 * crypto_auth - 消息认证码生成
 * crypto_auth_verify - 验证消息认证码
 * crypto_onetimeauth - 一次性消息认证码生成
 * crypto_onetimeauth_verify - 验证一次性消息认证码

### 其他工具函数
 * random_bytes - 生成随机字节
 * constant_time_compare - 恒定时间比较（防止时序攻击）


## 常量说明

### Box相关常量
 * crypto_box_PUBLICKEYBYTES - 公钥长度（32字节）
 * crypto_box_SECRETKEYBYTES - 私钥长度（32字节）
 * crypto_box_BEFORENMBYTES - 派生密钥长度（32字节）
 * crypto_box_NONCEBYTES - Nonce长度（24字节）
 * crypto_box_ZEROBYTES - 零字节填充长度（32字节）
 * crypto_box_BOXZEROBYTES - 解密零字节长度（16字节）

### SecretBox相关常量
 * crypto_secretbox_KEYBYTES - 密钥长度（32字节）
 * crypto_secretbox_NONCEBYTES - Nonce长度（24字节）
 * crypto_secretbox_ZEROBYTES - 零字节填充长度（32字节）
 * crypto_secretbox_BOXZEROBYTES - 解密零字节长度（16字节）

### 签名相关常量
 * crypto_sign_PUBLICKEYBYTES - 公钥长度（32字节）
 * crypto_sign_SECRETKEYBYTES - 私钥长度（64字节）
 * crypto_sign_BYTES - 签名长度（64字节）

### 哈希相关常量
 * crypto_hash_BYTES - SHA-512哈希长度（64字节）
 * crypto_hash_sha256_BYTES - SHA-256哈希长度（32字节）

### 认证相关常量
 * crypto_auth_BYTES - 认证标签长度（32字节）
 * crypto_auth_KEYBYTES - 认证密钥长度（32字节）
 * crypto_onetimeauth_BYTES - 一次性认证标签长度（16字节）
 * crypto_onetimeauth_KEYBYTES - 一次性认证密钥长度（32字节）

### 流加密相关常量
 * crypto_stream_KEYBYTES - 流密钥长度（32字节）
 * crypto_stream_NONCEBYTES - 流Nonce长度（24字节）
 * crypto_scalarmult_BYTES - 标量乘法结果长度（32字节）


## 约束与限制

在下述版本验证通过：



- DevEco Studio 版本： 5.1  (5.1.1.830)


- OpenHarmony SDK:API12 (5.0.0.12)



## 目录结构

````

js-nacl

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
├── README.md                   # 项目英文文档和说明
├── oh-package.json5            # 项目配置文件
└── ...                         # 其他配置文件               

````
