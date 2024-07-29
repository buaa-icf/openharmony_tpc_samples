# ohos_minizip

## 介绍
基于minizip_ng的解压缩库

## 下载安装

```shell
ohpm install @ohos/minizip
```
- OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

### 编译运行

本项目依赖minizip_ng库，编译产物.a文件和头文件通过`git submodule`引入，下载代码时需加上`--recursive`参数。
  ```
  git clone --recursive https://gitee.com/openharmony-tpc/openharmony_tpc_samples.git
  ```

如果想要在本地编译minizip_ng，参考[minizip_ng集成到应用hap](https://gitee.com/openharmony-sig/tpc_c_cplusplus/tree/master/thirdparty/minizip-ng)

在cpp目录下新增third_party目录，并将编译生成的库拷贝到该目录下，如下图所示

![img.png](image%2Fimg.png)

## 使用说明

### 解压zip包获取文件内容

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

1. 使用三方库解压zip文件内容到内存，返回至JS。
2. GetEntryNames()获取zip文件所有的文件夹路径以及文件路径
3. ExtractFileToJS(entryname, password),解压指定的文件并将内容返回至JS侧，若文件没有密码参考如下

ExtractFileToJS(entryname, “”)；

### 解压zip包到磁盘
```typescript
import { unzipToDirectory } from '@ohos/minizip'

unzipToDirectory(this.selectFilePath, this.targetPath, this.password).then(() => {
  
}).catch(() => {
 
});
```


## 接口说明

| 接口               | 参数                                                        | 参数说明                                                    | 返回值                                                            |
|------------------|-----------------------------------------------------------|---------------------------------------------------------|----------------------------------------------------------------|
| MinizipNative    | path:string                                               | zip压缩包路径                                                | MinizipNative实例                                                |
| Open             | 无                                                         | 无                                                       | 当返回值为0时，打开文件成功                                                 |
| SetCharEncoding  | charEncoding:number                                       | charEncoding: 字符编码类型，可设置为 437(CP437 主要用于英文和一些西欧语言环境) 932(CP932 主要用于日语环境) 936(CP936 主要用于简体中文环境) 950(CP950 主要用于繁体中文环境) 65001(UTF8)            | 无返回值。设置压缩包的字符编码类型                                                                |
| GetEntryNames    | 无                                                         | 无                                                       | Array< string > 获取文件列表，如果调用过SetCharEncoding设置字符编码，则返回的文件名字符串为utf8编码                                         |
| ExtractFileToJS  | entryName : string, password : string                     | entryName：文件名， password：密码                              | ArrayBuffer或者undefined 解压文件内容，密码错误或entryName为文件夹名时，返回undefined |
| unzipToDirectory | selectPath: string, targetPath: string, password?: string | selectPath: 待解压文件路径, targetPath: 解压到此路径下, password?: 密码 | Promise< string > 是否解压成功                                       |

## 注意事项
- 创建minizipNative对象需要传入完整的文件路径:**文件路径**+**文件名**

- **创建对象**之后**一定要调用Open函数**，并且每一次new minizipNative**只能调用一次Open**，若Open函数返回值非0则是打开文件失败


## 约束与限制
在下述版本验证通过：

DevEco Studio: NEXT Developer Beta1-5.0.3.320, SDK: API12(5.0.0.23)

## 目录结构
````
|----ohos_minizip  
|     |---- entry  # 示例代码文件夹
|     |---- library  
|                |---- cpp # c/c++和napi代码
|                      |---- minizipAdapter # minizip的napi逻辑代码
|                      |---- CMakeLists.txt  # 构建脚本
|                      |---- thirdparty # 三方依赖
|                      |---- types # 接口声明
|           |---- index.ets  # 对外接口
|     |---- README.md  # 安装使用方法
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [Apache License License - v 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_minizip/LICENSE) ，请自由地享受和参与开源。 
    



