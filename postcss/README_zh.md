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
    `;
let parentStyleSheet: string = `
    body{
        width: 100%;
    }`
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
CSSParser.setParentStyleSheet(parentStyleSheet);
let getParentStyleSheet = CSSParser.getParentStyleSheet();
```
## 接口说明
| 接口                            | 参数                                                                                  | 参数说明                                 | 返回值                                                                  | 接口说明              |
|-------------------------------|-------------------------------------------------------------------------------------|--------------------------------------|----------------------------------------------------------------------|-----------------------|
| postcss.AtRule                | defaults：AtRuleProps                                                                | 新节点的属性                               | AtRule_                                                              | 创建新的AtRule节点              |
| postcss.Comment               | defaults：CommentProps                                                               | 新节点的属性                               | Comment_                                                             | 创建新的Comment节点              |
| postcss.Declaration           | defaults：DeclarationProps                                                           | 新节点的属性                               | Declaration_                                                         | 创建新的Declaration节点           |
| postcss.fromJSON              | data: object \| object[]                                                            | 一个对象或对象数组，表示要转换回PostCSS AST的JSON AST | Node                                                                 | 将JSON格式的数据转换回PostCSS的抽象语法树（AST）节点
| postcss.Parse                 | css: string \| Object, opt?: Pick<ProcessOptions<Docement) \| Root>,"map" \| "from"> | css字符串，opt：一个对象，用于配置解析过程             | Root                                                                 | 解析源css并返回一个新的根或文档节点，其中包含源css节点 |
| postcss.Root                  | defaults：RootProps                                                                  | 新节点的属性                               | Root                                                                 | 创建新的Root节点  |
| CSSParser.readFile            | cssStr: Uint8Array                                                                  | 与指定资源路径相对应的原始文件资源                    | string                                                               | 读取css文件内容             |
| CSSParser.getValueByProperty  | root：postcss.Document \| postcss.Root, prop：string                                  | 待解析的节点，属性名                           | Array:string[]                                                       | 根据属性名获取属性值            |
| CSSParser.getSelectorList     | root: postcss.Document \| postcss.Root                                              | 待解析的节点                               | Array:string[]                                                       | 获取样式中的选择器             |
| CSSParser.getMediaList        | root: postcss.Document \| postcss.Root                                              | 待解析的节点                               | Array:string[]                                                       | 获取样式中的媒体查询列表          |
| CSSParser.getStyleDeclaration | declaration: string                                                                 | 样式声明                                 | postcss.Declaration                                                  | 获取样式声明                |
| postcss().process             | css: string                                                                         | css字符串                               | postcss.LazyResult<postcss.Document \| postcss.Root> \| NoWorkResult | 解析传入的字符串为AST          |
| CSSParser.setParentStyleSheet | css: string                                                                         | css字符串                               | 无                                                                    |设置父样式表|
| CSSParser.getParentStyleSheet | 无                                                                                   | 无                                    | css: string                                                          | 获取父样式表|

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
