# ohos_flate2

## 简介


## 下载安裝

```
 ohpm install @ohos/flate2
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)



## 接口说明

```ts
/**
  * 压缩或解压支持的选项，更详细内容请参考https://zlib.net/manual.html#Advanced
  * 不同函数支持的选项不同，详情见各函数说明
  */
export interface Options {
  /** 压缩等级，0为最低压缩等级（没有压缩），9为最高压缩等级, 必须在0..=9之间，否则会使用默认值6 */
  level?: number
  /** 窗口大小（历史缓冲区的大小）的底数2的对数，必须在9..=15之间，否则会使用默认值15 */
  windowBits?: number
  /** 初始压缩/解压缩字典, 默认为空 */
  dictionary?: Uint8Array
}

/**
  * 使用deflate算法压缩数据.
  * @param buf - 输入的待压缩数据
  * @param options - 压缩选项，有效选项为level
  * @returns 输出压缩后的数据，若压缩发生错误，则返回数据大小为0
  */
export declare function deflate(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * 使用gzip算法压缩数据.
  * @param buf - 输入的待压缩数据
  * @param options - 压缩选项，有效选项为level
  * @returns 输出压缩后的数据，若压缩发生错误，则返回数据大小为0
  */
export declare function gzip(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * 使用deflate算法解压数据.
  * @param buf - 输入的待解压数据
  * @param options - 解压选项，全部选项无效
  * @returns 输出解压后的数据，若解压发生错误，则返回数据大小为0
  */
export declare function inflate(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * 使用gzip算法解压数据.
  * @param buf - 输入的待解压数据
  * @param options - 解压选项，全部选项无效
  * @returns 输出解压后的数据，若解压发生错误，则返回数据大小为0
  */
export declare function ungzip(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * 使用zlib算法解压数据.
  * @param buf - 输入的待解压数据
  * @param options - 解压选项，有效选项为windowBits, dictionary
  * @returns 输出解压后的数据，若解压发生错误，则返回数据大小为0
  */
export declare function unzlib(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * 使用zlib算法压缩数据.
  * @param buf - 输入的待压缩数据
  * @param options - 压缩选项，有效选项为level，windowBits，dictionary
  * @returns 输出压缩后的数据，若压缩发生错误，则返回数据大小为0
  */
export declare function zlib(buf: Uint8Array, options?: Options | undefined | null): Uint8Array
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
- 构建环境已安装Rust工具链，并可以从crates.io（或镜像）下载crate包
- 构建环境已安装OHOS SDK, 并正确设置`OHOS_NDK_HOME` 环境变量，如 `export OHOS_NDK_HOME=/path/to/ohos_sdk_home/`.
- OpenHarmony SDK API >= 12
- Rust 版本>= 1.80


### 1. 安装ohrs工具

```
cargo install ohrs --git https://github.com/ohos-rs/ohos-rs --rev 1b93eb14dc4b9c3aed5534d6814241b0aa429f98
```

### 2. 安装ohos target

```
rustup target add aarch64-unknown-linux-ohos
rustup target add x86_64-unknown-linux-ohos
```

### 3. 执行构建命令
```sh
./library/src/main/rust/build-rust.sh
```

