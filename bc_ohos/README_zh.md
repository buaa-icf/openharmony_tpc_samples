# bc_ohos

## 简介

> bc-ohos 是一个针对 OpenHarmony 平台的轻量级加密库，实现了 Bouncy Castle 的 ISO9797 Algorithm 3 MAC 算法。该库完全兼容 Android Bouncy Castle 的 API 设计，提供了一套与 Android 端高度一致的接口，便于开发者进行跨平台开发。

ISO9797 Algorithm 3 是基于 DES 的 CBC 模式消息认证码算法，也称为 ANSI X9.19 Retail MAC。该算法广泛应用于金融、支付和安全通信领域。

## 下载安装

```
ohpm install @ohos/bc-ohos
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)。

## 使用说明

### 1. 基本用法

```typescript
import { ISO9797Alg3Mac, ISO7816d4Padding } from '@ohos/bc-ohos'

// 创建实例
const mac = new ISO9797Alg3Mac(new ISO7816d4Padding())

// 准备密钥
const keyBytes = new Uint8Array([/* 16字节密钥 */])
const keyParam = { key: keyBytes }

// 初始化
mac.init(keyParam)

// 更新数据
const data = new TextEncoder().encode("Hello World!")
mac.update(data, 0, data.length)

// 计算 MAC
const output = new Uint8Array(8)
const macLen = mac.doFinal(output, 0)

console.log("MAC:", bytesToHex(output))
```

### 2. 带 IV 使用

```typescript
import { ISO9797Alg3Mac, ParametersWithIV, ISO7816d4Padding } from '@ohos/bc-ohos'

const mac = new ISO9797Alg3Mac(new ISO7816d4Padding())

// 准备带 IV 的参数
const params: ParametersWithIV = {
  parameters: { key: keyBytes },
  iv: new Uint8Array([/* 8字节IV */])
}

mac.init(params)
mac.update(data, 0, data.length)
const output = new Uint8Array(8)
mac.doFinal(output, 0)
```

### 3. 切换填充方式

```typescript
// ISO7816-4 填充
const mac1 = new ISO9797Alg3Mac(new ISO7816d4Padding())

// PKCS7 填充
const mac2 = new ISO9797Alg3Mac(new PKCS7Padding())

// 零填充
const mac3 = new ISO9797Alg3Mac(new ZeroBytePadding())
// 或
const mac4 = new ISO9797Alg3Mac() // 默认零填充
```

### 4. 支持的填充方式

| 填充方式          | 标准                    | 用途             | 状态        |
| ----------------- | ----------------------- | ---------------- | ----------- |
| 默认零填充        | -                       | 默认填充方式     | ✅ 内置支持 |
| ZeroBytePadding   | -                       | 显式零填充       | ✅ 已实现   |
| ISO7816d4Padding  | ISO/IEC 7816-4          | 金融交易、智能卡 | ✅ 已实现   |
| PKCS7Padding      | PKCS#7/PKCS#5           | 通用加密场景     | ✅ 已实现   |
| ISO10126d2Padding | ISO/IEC 10126-2         | 高安全性场景     | ✅ 已实现   |
| X923Padding       | ANSI X9.23              | 金融 ANSI 标准   | ✅ 已实现   |
| TBCPadding        | Trailing Bit Complement | 特殊安全场景     | ✅ 已实现   |

### 5. 核心类和接口

#### 核心类

1. **ISO9797Alg3Mac** - 主 MAC 类
2. **KeyParameter** - 密钥参数接口
3. **ParametersWithIV** - 带 IV 参数接口
4. **BlockCipherPadding** - 填充接口

#### 构造函数

```typescript
// 默认构造（8字节MAC，零填充）
constructor()

// 指定填充方式
constructor(padding: BlockCipherPadding | null)

// 指定MAC大小
constructor(macSizeInBits: number)

// 完整参数
constructor(macSizeInBits: number, padding: BlockCipherPadding | null)
```

#### 核心方法

| 方法                                                                 | 入参                                                                                      | 出参                                                                                      | 说明                                                                                      |
| -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `getAlgorithmName(): string`                                       | 无                                                                                        | `string`                                                                                | 获取算法名称，返回字符串 "ISO9797Alg3"                                                    |
| `init(params: KeyParameter \| ParametersWithIV): void`             | `params:KeyParameter   \| ParametersWithIV`    |`void`                                                                                  | 初始化MAC，设置密钥和IV（如果有）                                                         |
| `getMacSize(): number`                                             | 无                                                                                        | `number`                                                                                | 获取MAC大小，返回以字节为单位的MAC长度                                                    |
| `updateByte(input: number): void`                                  | `input: number`                                                                         | `void`                                                                                  | 更新单字节，处理输入的字节值(0-255)                                                       |
| `update(input: Uint8Array, inOff: number, len: number): void`      | `input: Uint8Array, inOff: number, len: number`                                         | `void`                                                                                  | 更新字节数组，从指定偏移开始处理指定长度的数据                                            |
| `doFinal(out: Uint8Array, outOff: number): number`                 | `out: Uint8Array, outOff: number`                                                       | `number`                                                                                | 完成计算，将MAC结果写入输出缓冲区并返回MAC大小                                            |
| `reset(): void`                                                    | 无                                                                                        | `void`                                                                                  | 重置状态，清空内部缓冲区和状态                                                            |

#### 填充接口

| 接口/类名           | 方法签名                                       | 入参                                                                                      | 出参                                                                                      | 说明                                                                                      |
| ------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| BlockCipherPadding  | `getPaddingName(): string`                   | 无                                                                                        | `string`                                                                                | 获取填充名称                                                                              |
| BlockCipherPadding  | `addPadding(buf: Uint8Array, offset: number): number` | `buf: Uint8Array, offset: number`                                                       | `number`                                                                                | 添加填充字节，返回添加的字节数                                                            |
| ISO7816d4Padding    | `getPaddingName(): string`                   | 无                                                                                        | `string`                                                                                | 获取填充名称，返回 "ISO7816-4"                                                            |
| ISO7816d4Padding    | `addPadding(buf: Uint8Array, offset: number): number` | `buf: Uint8Array, offset: number`                                                       | `number`                                                                                | 添加ISO7816-4填充，第一个字节为0x80，其余为0x00                                           |
| ZeroBytePadding     | `getPaddingName(): string`                   | 无                                                                                        | `string`                                                                                | 获取填充名称，返回 "ZeroByte"                                                             |
| ZeroBytePadding     | `addPadding(buf: Uint8Array, offset: number): number` | `buf: Uint8Array, offset: number`                                                       | `number`                                                                                | 添加零字节填充，所有填充字节为0x00                                                        |
| PKCS7Padding        | `getPaddingName(): string`                   | 无                                                                                        | `string`                                                                                | 获取填充名称，返回 "PKCS7"                                                                |
| PKCS7Padding        | `addPadding(buf: Uint8Array, offset: number): number` | `buf: Uint8Array, offset: number`                                                       | `number`                                                                                | 添加PKCS7填充，所有填充字节值等于填充长度                                                 |
| ISO10126d2Padding   | `getPaddingName(): string`                   | 无                                                                                        | `string`                                                                                | 获取填充名称，返回 "ISO10126-2"                                                           |
| ISO10126d2Padding   | `addPadding(buf: Uint8Array, offset: number): number` | `buf: Uint8Array, offset: number`                                                       | `number`                                                                                | 添加ISO10126-2填充，随机字节填充，最后一个字节为填充长度                                  |
| X923Padding         | `getPaddingName(): string`                   | 无                                                                                        | `string`                                                                                | 获取填充名称，返回 "X9.23"                                                                |
| X923Padding         | `addPadding(buf: Uint8Array, offset: number): number` | `buf: Uint8Array, offset: number`                                                       | `number`                                                                                | 添加X9.23填充，零字节或随机字节填充，最后一个字节为填充长度                               |
| TBCPadding          | `getPaddingName(): string`                   | 无                                                                                        | `string`                                                                                | 获取填充名称，返回 "TBC"                                                                  |
| TBCPadding          | `addPadding(buf: Uint8Array, offset: number): number` | `buf: Uint8Array, offset: number`                                                       | `number`                                                                                | 添加TBC填充，根据最后一个字节的最低位决定填充值                                           |

#### 属性

| 类名           | 属性名     | 类型              | 说明                                                                                      |
| -------------- | ---------- | ----------------- | ----------------------------------------------------------------------------------------- |
| KeyParameter   | key        | Uint8Array        | 密钥数据，长度必须为16字节(双长度)或24字节(三长度)                                        |
| ParametersWithIV | parameters | KeyParameter      | 密钥参数对象                                                                              |
| ParametersWithIV | iv         | Uint8Array        | 初始化向量，长度为8字节                                                                   |


## 约束与限制

- DevEco Studio: 6.0.0 Release SDK: API20(6.0.0.47)
- DevEco Studio: 5.1.1 Release SDK: API19(5.1.1.208)
- DevEco Studio: 5.1.0 Release SDK: API17(5.1.0.150)
- DevEco Studio: 5.0.0 Release SDK: API12(5.0.0)

## 目录结构

```
|---- bc_ohos  
|     |---- entry  # 示例代码文件夹
|     |---- library  # bc_ohos库文件夹
|           |---- src 
|               |---- main
|                   |---- ets
|                       |---- ISO9797Alg3Mac.ets # 主要MAC算法实现
|                       |---- Padding.ets # 所有填充方式实现
|                       |---- Params.ets # 参数接口定义
|                       |---- utils # 工具类
|                           |---- LogUtil.ets # 日志工具
|           |---- index.ets # 对外接口
|     |---- README.md # 安装使用方法
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode/openharmony-tpc/openharmony_tpc_samples/bc_ohos/issues)，当然，也非常欢迎发 [PR](https://gitcode/openharmony-tpc/openharmony_tpc_samples/bc_ohos/pulls) 共建。

## 开源协议

本项目基于 [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/bc_ohos/blob/master/LICENSE.md)，请自由地享受和参与开源。
