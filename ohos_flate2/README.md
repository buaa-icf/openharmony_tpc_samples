# ohos_flate2

## 简介

ArkTS binding for rust flate2

## 下载安裝

```
 ohpm install @ohos/flate2
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)



## 接口说明

```ts


/**
  * 压缩或解压缩所支持的选项，更详细定义参考：https://zlib.net/manual.html#Advanced
  * 不同函数支持的选项不同，详见各函数自身说明
  */
export interface Options {
  /** 压缩等级，0为最低（没有压缩），9为最高，默认值为6，数据有效值范围[0..9]，超出范围取默认值 */
  level?: number
  /** 窗口大小（历史缓冲区的大小）的底数2的对数，默认值为15，数据有效值范围[9..15]，超出范围取默认值 */
  windowBits?: number
  /** 初始压缩/解压缩字典，默认为空 */
  dictionary?: Uint8Array
}

/**
  * @description 使用zlib格式压缩数据
  * @param buf - 输入的压缩数据
  * @param options - 压缩选项，有效选项为level，window_bits,dictionary
  * @returns 输出压缩后的数据
  */
export declare function deflate(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * @description 使用deflate格式压缩数据
  * @param buf - 输入的待压缩数据
  * @param options - 压缩选项，有效选项为level
  * @returns 输出压缩后的数据
  */
export declare function deflateRaw(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * @description 使用gzip格式压缩数据
  * @param buf - 待压缩数据
  * @param options - 压缩选项，支持选项为level
  * @returns 输入压缩后的数据
  */
export declare function gzip(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * @description 使用zlib算法解压缩数据
  * @param buf - 待解压数据
  * @param options - 解压缩选项，支持选项为window_bits,dictionary
  * @returns 输入解压后的数据
  */
export declare function inflate(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * @description 使用deflate算法解压缩数据
  * @param buf - 待解压数据
  * @param options - 解压缩选项，当前选项无效
  * @returns 输入解压后的数据
  */
export declare function inflateRaw(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * @description 使用gzip算法解压缩数据
  * @param buf - 待解压数据
  * @param options - 解压缩选项，当前选项无效
  * @returns 输入解压后的数据
  */
export declare function ungzip(buf: Uint8Array, options?: Options | undefined | null): Uint8Array



```



## 目录结构

````
/ohos_flate2        # 项目根目录
├── entry      # 示例代码文件夹
├── library    # flate2库文件夹
│    └─ src/main/rust   # binding代码             
├── README.md     # 安装使用方法    
                   
````

## 贡献代码

使用过程中发现任何问题都可以提交 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)，当然，也非常欢迎提交 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目遵循 [Apache-2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_flate2/LICENSE-APACHE) 或 [MIT](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_flate2/LICENSE-MIT) 协议。


## libflate2.so构建方法

### 0.预备条件
- 构建环境已安装Rust工具链，并可以从crates.io（或镜像）下载crate包。
   安装工具可使用[Rust原生社区](https://www.rust-lang.org/zh-CN/tools/install)安装工具或 [旋武社区发行版](https://xuanwu.beta.atomgit.com/download/)
- 构建环境已安装OHOS SDK, 并正确设置`OHOS_NDK_HOME` 环境变量，如 `export OHOS_NDK_HOME=/path/to/ohos_sdk_home/`.
- OpenHarmony SDK API >= 12
- Rust 版本>= 1.80


### 1. 安装ohrs工具

方法1（推荐）：直接使用cargo install安装

```
cargo install ohrs --git https://github.com/ohos-rs/ohos-rs --rev 1b93eb14dc4b9c3aed5534d6814241b0aa429f98
```

方法2：将ohrs代码clone到本地后手动安装
```
git clone https://github.com/ohos-rs/ohos-rs 
git checkout 1b93eb14dc4b9c3aed5534d6814241b0aa429f98
cd ./ohos-rs/cli/cargo-ohrs
cargo install ohrs --path .
```


### 2. 安装ohos target

```
rustup target add aarch64-unknown-linux-ohos
rustup target add x86_64-unknown-linux-ohos
```

### 3. 执行构建命令
#### 3.1 linux环境

```shell
cd ./library/src/main/rust/
./build-rust.sh
```
#### 3.2 windows环境

进入`ohos_flate2/library/src/main/rust`文件夹,在命令行中输入如下命令
```
ohrs build --release --arch arm64 --arch x64 --dist ../../../libs
```

#### 4.确认构建成功

`ohos_flate2/library/libs`中出现如下目录和文件，则代表构建成功

```
library/libs
├── arm64-v8a
│   └── libflate2.so
├── index.d.ts
└── x86_64
    └── libflate2.so

```