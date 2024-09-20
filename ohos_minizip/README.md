# ohos_minizip

## Introduction
This project provides a decompression library based on minizip_ng.

## How to Install

```shell
ohpm install @ohos/minizip
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage_en.md).

### How to Build

This project depends on the minizip_ng library. The build products, .a file and header file, are imported through **git submodule**. The **--recursive** parameter must be carried in the command used to download the project code.
  ```
  git clone --recursive https://gitee.com/openharmony-tpc/openharmony_tpc_samples.git
  ```

For details about how to build minizip_ng locally, see [Integrating minizip_ng into Your HAP](https://gitee.com/openharmony-sig/tpc_c_cplusplus/tree/master/thirdparty/minizip-ng).

Add the **third_party** directory to the **cpp** directory, and copy the library generated after compilation to the **third_party** directory.

![img.png](image%2Fimg.png)

## How to Use

### Decompressing a ZIP File to Obtain Its Content

```typescript
import { MinizipNative } from '@ohos/minizip'

let minizipEntry = new MinizipNative(this.selectFilePath);
if (minizipEntry.Open() == 0) {
  let entryNames = minizipEntry.GetEntryNames();
  for (let i = 0; i < entryNames.length; i++) {
    console.log('Minizip names:' + entryNames[i]);
    if(!entryNames[i].endsWith("/")) {
      let arrBuffer = minizipEntry.ExtractFileToJS(entryNames[i], this.password);
      console.log("Minizip arrBuffer: " + arrBuffer?.byteLength)
    }
  }
}
```

1. Use a third-party library to decompress a ZIP file to the memory and return the file content to the JS side.
2. Call **GetEntryNames()** to obtain all folder paths and file paths of the ZIP file.
3. Use **ExtractFileToJS(entryname, password)** to decompress the specified file and return the file content to the JS side. If the file does not have a password, call the code below:

   ExtractFileToJS(entryname, "");

### Decompressing a ZIP File to a Disk
```typescript
import { unzipToDirectory } from '@ohos/minizip'

unzipToDirectory(this.selectFilePath, this.targetPath, this.password).then(() => {
  
}).catch(() => {
 
});
```


## Available APIs

| API            | Parameter                                                        | Parameter Description                                                    | Return Value                                                      | API Description             |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | --------------------- |
| MinizipNative    | path:string                                                  | Path of the ZIP file.                                               | **MinizipNative** instance.                                           | Creates a **MinizipNative** instance.|
| Open             | N/A                                                          | N/A                                                          | **0** if the file is opened successfully.                                 | Opens a file.             |
| SetCharEncoding  | charEncoding:number                                          | **charEncoding**: character encoding type. The value can be **437** (for English and some Western European languages), **932** (for Japanese), **936** (for Simplified Chinese), **950** (for Traditional Chinese), or **65001** (for UTF-8).| N/A                            | Sets the character encoding type.     |
| GetEntryNames    | N/A                                                          | N/A                                                          | **Array\<string>**: list of files obtained. If **SetCharEncoding** has been called to set the character encoding type, the file name string encoded in UTF-8 format is returned.| Obtains the file list.         |
| ExtractFileToJS  | entryName : string, password : string                        | **entryName**: file name.<br>**password**: password.                          | **ArrayBuffer** or **undefined**: decompressed file content. If the password is incorrect or **entryName** is a folder name, **undefined** is returned.| Decompresses a file.         |
| unzipToDirectory | selectPath: string, targetPath: string, password?: string, charEncoding?: number | **selectPath**: path of the file to decompress.<br>**targetPath**: path to which the file is decompressed.<br>**password?**: password.<br>**charEncoding?**: character encoding format. | **Promise\< string >**: whether the file is decompressed successfully.                              | Decompresses a file to a folder.   |

## Precautions
- To create a **minizipNative** object, you must pass in a complete file path, which consists of the file path and file name.

- You must call the **Open** function after creating an object. The **Open** function can be called only once each time the **new minizipNative** function is called. If the return value of the **Open** function is not **0**, the file fails to be opened.


## Constraints
This project has been verified in the following version:

DevEco Studio: NEXT Developer Beta1-5.0.3.320, SDK: API 12 (5.0.0.23)

## Directory Structure
````
|----ohos_minizip  
|     |---- entry  # Sample code
|     |---- library  
|                |---- cpp # C/C++ and NAPI code
|                      |---- minizipAdapter # NAPI logic code of minizip
|                      |---- CMakeLists.txt  # Build script
|                      |---- thirdparty # Third-party dependencies
|                      |---- types # API declaration
|           |---- index.ets  # External APIs
|     |---- README.md  # Readme
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [Apache License License - v 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_minizip/LICENSE).
    
