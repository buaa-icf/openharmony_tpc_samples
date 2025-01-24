# postcss

## 简介
PostCSS是一个用JS插件转换样式的工具。这些插件可以检测的CSS，支持变量和混合，编译未来的CSS语法，内联图像等等。

PostCSS被包括维基百科、Twitter、阿里巴巴和JetBrains在内的行业领头者使用。Autoprefixer和Stylelint PostCSS插件是最流行的CSS工具之一。

## 下载安装

```
ohpm install @ohos/postcss
```
OpenHarmony
ohpm 环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

```js
import postcss from '@ohos/postcss'
let cssStyle: string = `
      .box {
        z-index: 10;
      }
    `;
let rule = new postcss.AtRule({ name: 'encoding', params: '"utf-8"' })
let comment = new postcss.Comment({ text: 'hi' })
let decl = new postcss.Declaration({ prop: 'color', value: 'black' })
let result = postcss.fromJSON({ type: 'not-a-node-type' })
let context = getContext(this) as common.UIAbilityContext;
let cssStr = context.resourceManager.getRawFileContentSync(path);
let retStr = CSSParser.readFile(cssStr);
let result = postcss().process(this.cssStyle);
CSSParser.getValueByProperty(result.root, 'width');
CSSParser.getSelectorList(result.root);
CSSParser.getMediaList(result.root);
let decl = 'width: 10px;';
let declarationList = CSSParser.getStyleDeclaration(decl);
```
## 接口说明
| 接口                            | 参数                                                 | 参数说明                            | 返回值                                                                  | 接口说明                  |
|-------------------------------|----------------------------------------------------|---------------------------------|----------------------------------------------------------------------|-----------------------|
| postcss.AtRule                | { name: string, params: string }                   | AtRule的名字，AtRule的参数             | AtRule                                                               | 创建@类型的规则              |
| postcss.Comment               | { text: string }                                   | comment的内容                      | Comment                                                              | 创建一条新的注释              |
| postcss.Declaration           | { prop: string, value: string }                    | Declaration的属性名,Declaration的属性值 | Declaration                                                          | 创建声明           |
| postcss.fromJSON              | { jsonAst：{} }     | 一个对象，表示要转换回PostCSS AST的JSON AST                         | AtRule \| Comment \| Declaration\| Rule \| Root                   | 将JSON格式的数据转换回PostCSS的抽象语法树（AST）节点
| postcss.Parse                 | { css: string, opt?: {} }                          | css字符串，opt：一个对象，用于配置解析过程        | Parse.root                                                                 | 解析CSS字符串并生成抽象语法树（AST） |
| postcss.Root                  | 无                                                  | 无                               | Root                                                                 | 返回抽象语法树（AST）的根节点 |
| CSSParser.readFile            | cssStr: Uint8Array                                 | 与指定资源路径相对应的原始文件资源               | string                                                               | 读取css文件内容             |
| CSSParser.getValueByProperty  | root：postcss.Document \| postcss.Root, prop：string | 待解析的节点，属性名                      | Array:string[]                                                       | 根据属性名获取属性值            |
| CSSParser.getSelectorList     | root: postcss.Document \| postcss.Root             | 待解析的节点                          | Array:string[]                                                       | 获取样式中的选择器             |
| CSSParser.getMediaList        | root: postcss.Document \| postcss.Root             | 待解析的节点                          | Array:string[]                                                       | 获取样式中的媒体查询列表          |
| CSSParser.getStyleDeclaration | declaration: string                                | 样式声明                            | postcss.Declaration                                                  | 获取样式声明                |
| postcss().process             | css:string                                         | css字符串                          | postcss.LazyResult<postcss.Document \| postcss.Root> \| NoWorkResult | 解析传入的字符串为AST          |


## 约束与限制
在下述版本验证通过：

- DevEco Studio 版本： DevEco Studio 5.0.1 Release;OpenHarmony SDK:API13 (5.0.1.115)。

## 目录

```
/postcss       # 工程根目录
      ├── entry                  # 示例代码文件夹  
           ├── src 
               ├── main
                   ├── ets
                      ├── pages 
                         ├── index.ets   # sample代码
      ├── library
          ├── src                
               ├── main   
                   ├── ets           
                      ├── components                 
                         ├── lib # 源库文件      
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls)共建

## 开源协议

本项目基于 [MIT](https://github.com/postcss/postcss/blob/main/LICENSE) 协议，请自由地享受和参与开源。
