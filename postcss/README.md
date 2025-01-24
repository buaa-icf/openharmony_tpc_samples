# postcss

## Introduction
PostCSS is a tool for transforming styles using JavaScript plug-ins. These plugins can detect your CSS, support variables and mixins, compile future CSS syntax, inline images, and more.

PostCSS is used by industry leaders including Wikipedia, Twitter, Alibaba, and JetBrains. The Autoprefixer and Stylelint PostCSS plug-ins are one of the most popular CSS tools.

## How to Install

```
ohpm install @ohos/postcss
```
For details about the ohpm environment configuration, see [Installing the OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

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
## Available APIs
| Interface       | Parameter                                           | Parameter Description                                                    | Return Value                                                         | Interface Description                                     |
|-----------------|-----------------------------------------------------|--------------------------------------------------------------------------|----------------------------------------------------------------------|-----------------------------------------------------------|
| postcss.AtRule  | { name: string, params: string }                    | The name of AtRule, The parameters of AtRule                             | AtRule                                                               | Create rules for @ type                                   |
| postcss.Comment | { text: string }                                    | The content of the comment                                               | Comment                                                              | Create a new comment                                      |
| postcss.Declaration | { prop: string, value: string }                     | Declaration property name, Declaration property value                    | Declaration                                                          | Create Declaration                                        |
| postcss.fromJSON | { jsonAst：{} }                                      | An object representing the JSON AST to be converted back to PostCSS AST  | AtRule \| Comment \| Declaration\| Rule \| Root                      | Convert JSON formatted data back to PostCSS Abstract Syntax Tree (AST) nodes                        |
| postcss.parse   | { css: string, opt?: {} }                           | CSS string, opt： An object used to configure the parsing process                                                                         | Parse.root                                                           | Parse CSS strings and generate Abstract Syntax Tree (AST) |
| postcss.Root    | void                                               | void                                                                     | Root                                                                 |         Return the root node of the Abstract Syntax Tree (AST)                                                  |
| CSSParser.readFile | cssStr: Uint8Array                                  | The original file resources corresponding to the specified resource path | string                                                               | Read CSS file content                                     |
| CSSParser.getValueByProperty | root：postcss.Document \|  postcss.Root, prop：string | Node to be parsedd,Attribute Name                                        | Array:string[]                                                       | Retrieve attribute values based on attribute names        |
| CSSParser.getSelectorList | root: postcss.Document \| postcss.Root              | Node to be parsed                                                        | Array:string[]                                                       | Retrieve selectors from styles                            |
| CSSParser.getMediaList | root: postcss.Document \| postcss.Root              | Node to be parsed                                                        | Array:string[]                                                       | Retrieve the media query list from the style              |
| CSSParser.getStyleDeclaration | declaration: string                                 | style declaration                                                        | postcss.Declaration                                                  | Get style declaration                                     |
| postcss().process | css:string                                          | css string                                                               | postcss.LazyResult<postcss.Document \| postcss.Root> \| NoWorkResult | Parse the incoming string as AST                          |

## Constraints
This project has been verified in the following version:

- DevEco Studio version： DevEco Studio 5.0.1 Release;OpenHarmony SDK:API13 (5.0.1.115)。

## Directory Structure

```
/postcss       # Engineering root directory
      ├── entry                  # Sample Code Folder  
           ├── src 
               ├── main
                   ├── ets
                      ├── pages 
                         ├── index.ets   # sample code
      ├── library
          ├── src                
               ├── main   
                   ├── ets           
                      ├── components                 
                         ├── lib # Source Library Files    
```

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT](https://github.com/postcss/postcss/blob/main/LICENSE).
