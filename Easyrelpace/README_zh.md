# Compare Text

## 简介
> 使用Levenshtein 距离算法测量两个字符串之间的差异。
>  Compare Text替换字符串，


![img1.png](./screenshot/img1.png)

## 下载安装
```shell
ohpm install leven;
ohpm install easy-replace;
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

### leven字符差异
```
      import leven from "leven";
      @State TextString: string = "Text entry"
      @State messaged: string= "cer"
 
      TextInput({ placeholder: "输入字符比较", text: this.messaged })
        .width("70%")
        .onChange((value) => {
          this.messaged = value
        })
      Button("比较字符串")
        .onClick(() => {
          this.messagevl = `字符串相差${leven(this.TextString, this.messaged)}个`
          setData(this.messagevl, this)
        })
       结果 =>8
```
### easy-replace字符串对比
```
  import {er} from 'easy-replace'  

  @State TextString: string = "Text entry"//输入文本字符串
  @State ReplaceString: string= "t"//替换字符
  @State StringResults: string = "💖"//要替换的字符
  Button("简单替换")
        .margin({ top: 10, bottom: 10 })
        .onClick(() => {
          this.Text = er(
            this.TextString,
            {
              leftOutsideNot: "",
              leftOutside: "",
              leftMaybe: "",
              searchFor: this.ReplaceString,
              rightMaybe: "",
              rightOutside: "",
              rightOutsideNot: "",
              i: {
                leftOutsideNot: false,
                leftOutside: false,
                leftMaybe: false,
                searchFor: true,
                rightMaybe: false,
                rightOutside: false,
                rightOutsideNot: false,
              },
            },
            this.StringResults
          );
          setData(this.Text, this)
        })
    }
```

## 约束与限制

在下述版本验证通过：
- DevEco Studio: NEXT Developer Beta1(5.0.3.122), SDK: API12(5.0.0.18)
- DevEco Studio: 4.1(4.1.3.413),SDK: API11（4.1.0.53）
- DevEco Studio: 4.0(4.0.3.512),SDK: API10（4.0.10.9）
- DevEco Studio: IDE Canary1(4.0.3.212) SDK API10(4.0.8.3)

## 目录结构
````
|---- Compare Text  
|     |---- entry  # 示例代码文件夹
|           |---- index.ets  # 对外接口
|     |---- README.MD  # 安装使用方法                    
|     |---- README_zh.MD  # 安装使用方法                    
````

## 接口说明

| **接口**                                           | 参数                                                     | 功能                                                           |
|--------------------------------------------------|--------------------------------------------------------|--------------------------------------------------------------|
| leven(str1:string, str2:string)                  | str1：字串一。<br/>    str2：字串二。<br/>                       | 示将一个字符串转换成另一个字符串所需的最少编辑操作次数                                  |
| er(source:string,opts:Plain Object,replacement:String) | source:原始字符串<br/>  opts:必填选项对象<br/> replacement:用此字符串替换所有结果。若未指定，则库将以删除模式运行。<br/> | 执行复杂的字符串替换操作。它允许您通过配置对象来定义替换规则，包括搜索模式、替换内容以及大小写敏感性等。[更多说明](https://codsen.com/os/easy-replace/) |

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎给组件发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Easyrelpace/LICENSE) ，请自由地享受和参与开源。