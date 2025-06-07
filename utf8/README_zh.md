# utf8

## 简介

> 在OpenHarmony环境下,提供了UTF-8的编码能力和解码能力。此库是一个经过充分测试的用 JavaScript 编写的 UTF-8 编码器/解码器。与许多其他 JavaScript 解决方案不同，它被设计为一个合适的 UTF-8 编码器/解码器：它可以按照编码标准对任何标量 Unicode 码位值进行编码/解码。

## 下载安装

```shell
ohpm install utf8
ohpm install @types/utf8@3.0.3 --save-dev //import utf8 的时候语法报错。其原因是utf8包内不含类型声明，需要 @types/utf8 下载这个包的声明文件，从而解决语法的报错。
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)
## 使用说明

### UTF8编解码使用

```typescript
import utf8 from "utf8";
import promptAction from '@ohos.promptAction';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Button("编码(encode)").onClick(() => {
          this.showMessage(utf8.encode('\xA9'));
          this.showMessage(utf8.encode('\uD800\uDC01'));
        })
        Button("解码(decoded)").onClick(() => {
          this.showMessage(utf8.decode('\xC2\xA9'));
          this.showMessage(utf8.decode('\xF0\x90\x80\x81'));
        })
      }
.width('100%')
}
.height('100%')
}

showMessage(message:string){
  promptAction.showToast({message})
}
}
```

## 接口说明
encode：编码

decode：解码

## 约束与限制

在下述版本验证通过：

DevEco Studio版本: 4.0Canary2(4.0.1.300), SDK: API10(4.0.9.6)

## 目录结构

```

/entry/src/
- main/ets/     
    - pages                        # 测试page页面列表
       - Index.ets                    	# 测试UTF8编解码能力
```

单元测试用例详情见[TEST.md](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/utf8/TEST.md)

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/utf8/LICENSE-MIT) ，请自由地享受和参与开源。



