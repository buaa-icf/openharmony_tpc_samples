## adler32Demo

### 介绍

adler32Demo是一个在Openharmony系统上验证adler-32（一个在js环境中实现ADLER-32的校验和算法的三方库）校验和算法的能力。

### 下载安装
1、安装
```
$ ohpm install adler-32
```
2、导入
```
import adler32 from 'adler-32'
```

### 接口说明
| 接口 | 功能描述 |
| :-----| :------|
|`buf(data:number[] or Unit8Array, seed?:number)`|`根据字节byte数组或buffer数据，获取校验和值`|
|`bstr(data:string,seed?:number)` | `根据二进制字符串（ucs-2编码字符）获取校验和值`|
|`str(data:string, seed?:number)`|`根据标准的js字符串获取校验和值`|
|`version:string`|`获取adler-32的版本号`|

单元测试用例详情见[TEST.md](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Adler32Demo/TEST.md)

### 样例说明
参照该Demo工程[Index](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Adler32Demo/entry/src/main/ets/pages/Index.ets)页面

如：
```
  Text(this.strBtn)
    .width('90%')
    .height(50)
    .backgroundColor(0xEEEEEE)
    .borderRadius(15)
    .fontSize(13)
    .textAlign(TextAlign.Center)
    .margin({ top: 10 })
    .onClick(() => {
      let par = "foo bar baz٪☃🍣";
      let result = adler32.str(par);
      this.message = result + "";
    })
```
```
Text(this.btrBtn)
  .width('90%')
  .height(50)
  .backgroundColor(0xEEEEEE)
  .borderRadius(15)
  .fontSize(13)
  .textAlign(TextAlign.Center)
  .margin({ top: 10 })
  .onClick(() => {
    let pam = [1, 2, 4, 5, 6, 7, 8, 9, 10];
    for(let i=0; i < 43;i++){
      pam = pam.concat([1, 2, 4, 5, 6, 7, 8, 9, 10])
    }
    pam = pam.concat([1, 2, 4, 5, 6, 7, 0, 0])    
    let result = adler32.buf(pam)
    this.message = result + "";
  })
```
```
Text(this.utrBtn)
  .width('90%')
  .height(50)
  .backgroundColor(0xEEEEEE)
  .borderRadius(15)
  .fontSize(13)
  .textAlign(TextAlign.Center)
  .margin({ top: 10 })
  .onClick(() => {
    let pam = "SheetJS";
    let result = adler32.bstr(pam)

    let s = adler32.buf([83, 104]);// 17825980  "Sh"
    s = adler32.str("eet", s);  // 95486458  "Sheet"
    result=adler32.bstr("JS", s );

    this.message = result + "";
  })
```
```
Text(this.vtrBtn)
  .width('90%')
  .height(50)
  .backgroundColor(0xEEEEEE)
  .borderRadius(15)
  .fontSize(13)
  .textAlign(TextAlign.Center)
  .margin({ top: 10 })
  .onClick(() => {
    this.message =adler32.version;
  })
```
### 软件架构
```
|-ets
|   |-entryability
|           |-EntryAbility.ts
|   |-pages
|           |-Index.ets             #主页demo
```

### 约束与限制
在下述版本验证通过：

DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)

DevEco Studio: 3.1 Beta2(3.1.0.400), SDK: API9 Release(3.2.11.9)

### 贡献代码

使用过程中发现任何问题，都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎给我们发[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)

### 开源协议

本项目基于[Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Adler32Demo/LICENSE),请自由的享受和参与开源

