# jsDiff

## 简介

本demo是基于openHarmony系统下使用三方js库[jsdiff](https://github.com/kpdecker/jsdiff)，jsdiff是一个用于比较两个文件或字符串差异的JavaScript库。

## 下载安装

```
ohpm install diff
ohpm install @types/diff --save-dev //import diff 的时候语法报错.其原因是diff包内不含类型声明,需要 @types/diff 下载这个包的声明文件,从而解决语法的报错.

```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

```
  import { diffChars} from 'diff'


  const one = 'beep boop   afff阿三是技术';
  const other = 'beepboob 啊发撒烦烦烦 e ';
  const diff = diffChars(one, other);

  diff.forEach((part) => {
      if (part.added) {
        //do something
      } else if (part.removed) {
      //do something
      } else {
     //do something
      }
      let str = part.value; //比较的字符或字符串
  });
    
    // 更多的用法參考index.ets 文件
    
```

## part对象属性说明
##### value: 文字内容
##### added：如果值被插入到新字符串中，则为真
##### removed：如果值已从旧字符串中删除，则为真

## 接口

| 模块名                                                                                                                                      | 入参                                                                                                                      | 功能                                    | 备注                                                                               |
|------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|---------------------------------------|----------------------------------------------------------------------------------|
| diffChars(oldStr: string, newStr: string[, options])                                                                                     | oldStr:原字串,<br/> newStr:新子串                                                                                             | 区分两个文本块，逐个字符进行比较                      | ignoreCase:true忽略大小写差异。默认为false                                                  |
| diffWords(oldStr: string, newStr: string[, options])                                                                                     | oldStr:原字串,<br/> newStr:新子串                                                                                             | 区分两个文本块，逐字比较，忽略空格                     | ignoreCase: 同中diffChars                                                          |
| diffWordsWithSpace(oldStr: string, newStr: string[, options])                                                                            | oldStr:原字串,<br/> newStr:新子串                                                                                             | 区分两个文本块，逐字比较，将空格视为重要                  | ignoreWhitespace:true忽略前导和尾随空格。这与diffTrimmedLines；newlineIsToken:true将换行符视为单独的标记 |
| diffLines(oldStr: string, newStr: string[, options])                                                                                     | oldStr:原字串,<br/> newStr:新子串                                                                                             | 区分两个文本块，逐行比较                          |                                                                                  |
| diffTrimmedLines(oldStr: string, newStr: string[, options])                                                                              | oldStr:原字串,<br/> newStr:新子串                                                                                             | 区分两个文本块，逐行比较，忽略前导和尾随空格                |
| diffSentences(oldStr: string, newStr: string[, options])                                                                                 | oldStr:原字串,<br/> newStr:新子串                                                                                             | 区分两个文本块，逐句比较                          |
| diffCss(oldStr: string, newStr: string[, options])                                                                                       | oldStr:原字串,<br/> newStr:新子串                                                                                             | 区分两个文本块，比较 CSS 标记                     |
| diffJson(oldObj: object, newObj: object[, options])                                                                                      | oldObj:原对象,<br/> newObj:新对象                                                                                             | 比较两个 JSON 对象，比较每个对象上定义的字段             |
| diffArrays(oldArr: array, newArr: array[, options])                                                                                      | oldStr:原数组,<br/> newArr:新数组                                                                                             | 区分两个数组，比较每个项目是否严格相等 (===)             |
| createPatch(fileName: string,oldStr: string,newStr: string,oldHeader?: string,newHeader?: string,options?: PatchOptions): string         | fileName:字符串将在文件名部分输出<br/>oldStr:原始字符串值<br/>newStr:新字符串值<br/>oldHeader:附加信息，包括在旧的文件头。<br/>newHeader:附加信息，包括在新的文件头。      | 用于生成补丁的文件和内容信息，配置项可包含 context（上下文行数）等 |
| createTwoFilesPatch(fileName: string,oldStr: string,newStr: string,oldHeader?: string,newHeader?: string,options?: PatchOptions): string | fileName:字符串将在文件名部分输出<br/>oldStr:原始字符串值<br/>newStr:新字符串值<br/>oldHeader:附加信息，包括在旧的文件头。<br/>newHeader:附加信息，包括在新的文件头。      | 用于生成补丁的文件和内容信息，配置项可包含 context（上下文行数）等 |
| structuredPatch(fileName: string,oldStr: string,newStr: string,oldHeader?: string,newHeader?: string,options?: PatchOptions): string     | fileName:字符串将在文件名部分输出<br/>oldStr:原始字符串值<br/>newStr:新字符串值<br/>oldHeader:附加信息，包括在旧的文件头。<br/>newHeader:附加信息，包括在新的文件头。      | 用于生成补丁的文件和内容信息，配置项可包含 context（上下文行数）等 |
| parsePatch(diffStr: string, options?: { strict?: boolean undefined }): ParsedDiff[];                                                                                             | diffStr:差异字串<br/>strict:是否严格                                                                                            | 将补丁解析为结构化数据。返回补丁的JSON对象表示形式，适合与‘ applyPatch() ’方法一起使用。                           |
| convertChangesToXML(changes: Change[]): string;                                                                                          | changes:更改列表                                                                                                            | 将更改列表转换为序列化的XML格式。                    |
| canonicalize(obj: any, stack: any[], replacementStack: any[]): any                                                                       | obj:需要规范化的原始对象<br/> stack:用于跟踪递归过程中已访问的对象，防止循环引用导致的栈溢出 <br/>replacementStack: 与 stack 对应，存储规范化后的对象，用于替换循环引用中的原始对象。<br/> | 用于深度比较复杂对象                   |
| merge(mine: string, theirs: string, base: string): ParsedDiff;                                                                           | mine:你的版本<br/> theirs:对方的版本<br/> base:共同的基础版本                                                                                  | 即根据两个不同版本的修改（mine 和 theirs）以及它们的共同基础版本（base），自动合并出一个最终结果                   |
| applyPatch(source: string,patch: string ParsedDiff [ParsedDiff],options?: ApplyPatchOptions): string  false                                                                                        | source:原始文本内容<br/> uniDiff:Unified Diff 格式的补丁文本，通常由 createPatch 方法生成。 <br/>options: 可选配置对象 | jsdiff 库中的 applyPatch 方法用于将 Unified Diff 格式的补丁应用到原始文本上，生成更新后的文本。                   |
| applyPatches(patch: string ParsedDiff[], options: ApplyPatchesOptions): void                                                                       | patch:单个补丁字符串或多个补丁字符串组成的数组。<br/> options:应用补丁选项| 应用一个或多个补丁                   |



更多模块的使用可参考[官方文档](https://github.com/kpdecker/jsdiff/blob/master/README.md)，单元测试用例详情见[TEST.md](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/jsDiffDemo/TEST.md)

## 约束与限制
在下述版本验证通过：
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio: 4.0 Release(4.0.3.600), SDK: API10 (4.0.10.11)
- DevEco Studio: 4.0 Beta2(4.0.3.512), SDK: API10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2(3.1.0.400), SDK: API9 Release(3.2.11.9)

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 

## 开源协议

该项目基于 [ Apache License 2.0 ](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/jsDiffDemo/LICENSE) ，请自由地享受和参与开源
