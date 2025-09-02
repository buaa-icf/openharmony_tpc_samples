# ohos_flate2

## Overview

ohos_flate2 is the ArkTS binding layer for the Rust flate2 library.

## How to Install

```
 ohpm install @ohos/flate2
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
```ts
  import { deflate, inflate, gzip, ungzip, deflateRaw, inflateRaw } from '@ohos/flate2';
  
  let inputData: Uint8Array = xxxx; // Uint8Array data
  
  // Compress uncompressed data using zlib format.
  const deflatedData = deflate(inputData);
  const output1 = inflate(deflatedData);
  
  // Compress uncompressed data using deflate format.
  const deflatedRawData = deflateRaw(inputData);
  const output2 = inflateRaw(deflatedRawData);
  
  // Compress uncompressed data using gzip format.
  const gzippedData = gzip(inputData);
  const output3 = ungzip(gzippedData);
```

## Available APIs

```ts


/**
  * Compression or decompression options. For details, see https://zlib.net/manual.html#Advanced.
  * Options supported by different functions. For details, see the description of each function.
  */
export interface Options {
  /** Compression level. 0 indicates the lowest level (no compression), and 9 indicates the highest level. The default value is 6. The valid value range is [0, 9]. If the value is out of the range, the default value is used. */
  level?: number
  /** Logarithm of the base 2 of the window size (size of the history buffer). The default value is 15. The valid value range is [9, 15]. If the value is out of the range, the default value is used. */
  windowBits?: number
  /** Initial compression/decompression dictionary. The default value is null. */
  dictionary?: Uint8Array
}

/**
  * @description Compresses data using zlib format.
  * @param buf - Input data to compress.
  * @param options - Compression options. Supported options: level, window_bits, and dictionary.
  * @returns Compressed data.
  */
export declare function deflate(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * @description Compresses data using deflate format.
  * @param buf - Input data to compress.
  * @param options - Compression options. Supported options: level.
  * @returns Compressed data.
  */
export declare function deflateRaw(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * @description Compresses data using gzip format.
  * @param buf - Data to compress.
  * @param options - Compression options. Supported options: level.
  * @returns Compressed data.
  */
export declare function gzip(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * @description Decompresses data using zlib.
  * @param buf - Data to decompress.
  * @param options - Decompression options. Supported options: window_bits and dictionary.
  * @returns Decompressed data.
  */
export declare function inflate(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * @description Decompresses data using deflate.
  * @param buf - Data to decompress.
  * @param options - Decompression options. The options are invalid.
  * @returns Decompressed data.
  */
export declare function inflateRaw(buf: Uint8Array, options?: Options | undefined | null): Uint8Array

/**
  * @description Decompresses data using gzip.
  * @param buf - Data to decompress.
  * @param options - Decompression options. The options are invalid.
  * @returns Decompressed data.
  */
export declare function ungzip(buf: Uint8Array, options?: Options | undefined | null): Uint8Array



```



## Directory Structure

````
/ohos_flate2        # Project root directory
├── entry      # Sample code
├── library    # flate2 library
│    └─ src/main/rust   # Binding code            
├── README.md     # Readme   
                   
````

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [Apache-2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_flate2/LICENSE-APACHE) or [MIT](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_flate2/LICENSE-MIT).


## Building libflate2.so

### 0. Prerequisites
- The Rust toolchain must be installed in the build environment, with the capability to download crate packages from **crates.io** (or an image).
   You can install Rust by visiting the [Rust native community](https://www.rust-lang.org/en-US/tools/install) or [Xuanwu community distribution](https://xuanwu.beta.atomgit.com/download/).
- The OHOS SDK must be installed in the build environment, with the `OHOS_NDK_HOME` environment variable correctly set (for example, `export OHOS_NDK_HOME=/path/to/ohos_sdk_home/`).
- OpenHarmony SDK API >= 12
- Rust version >= 1.80


### 1. Installing ohrs

Method 1 (recommended): Run **cargo install**.

```
cargo install ohrs --git https://github.com/ohos-rs/ohos-rs --rev 1b93eb14dc4b9c3aed5534d6814241b0aa429f98
```

Method 2: Clone the ohrs code locally and install manually.
```
git clone https://github.com/ohos-rs/ohos-rs 
git checkout 1b93eb14dc4b9c3aed5534d6814241b0aa429f98
cd ./ohos-rs/cli/cargo-ohrs
cargo install ohrs --path .
```


### 2. Installing OHOS Targets

```
rustup target add aarch64-unknown-linux-ohos
rustup target add x86_64-unknown-linux-ohos
```

### 3. Running Build Commands
#### 3.1 Linux Environment

```shell
cd ./library/src/main/rust/
./build-rust.sh
```
#### 3.2 Windows Environment

Go to `ohos_flate2/library/src/main/rust` and run the following command:
```
ohrs build --release --arch arm64 --arch x64 --dist ../../../libs
```

#### 4. Checking Build Result

The build is successful if the following folders and files appear in `ohos_flate2/library/libs`:

```
library/libs
├── arm64-v8a
│   └── libflate2.so
├── index.d.ts
└── x86_64
    └── libflate2.so

```
