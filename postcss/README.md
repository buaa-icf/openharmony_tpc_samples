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
## Available APIs
| Interface       | Parameter                                                                            | Parameter Description                                                                      | Return Value                                                         | Interface Description                                                                          |
|-----------------|--------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|----------------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| postcss.AtRule  | defaults：AtRuleProps                                                                 | Properties for the new node                                                                | AtRule_                                                              | Creates a new AtRule node                                                                      |
| postcss.Comment | defaults：CommentProps                                                                | Properties for the new node                                                                | Comment_                                                             | Creates a new Comment node                                                                     |
| postcss.Declaration | defaults：DeclarationProps                                                            | Properties for the new node                                                                | Declaration_                                                         | Creates a new Declaration node                                                                 |
| postcss.fromJSON | data: object \| object[]                                                             | An object or an object array representing the JSON AST to be converted back to PostCSS AST | Node                                                                 | Rehydrate a JSON AST(from Node#toJSON) back into the AST classes                               |
| postcss.parse   | css: string \| Object, opt?: Pick<ProcessOptions<Docement) \| Root>,"map" \| "from"> | CSS string \| Object, opt： An object used to configure the parsing process                 | Root                                                                 | Parses source css and returns a new Root or Document node, which contains the source CSS nodes |
| postcss.Root    | defaults：RootProps                                                                   | Properties for the new node                                                                | Root                                                                 | Creates a new Root node                                                                        |
| CSSParser.readFile | cssStr: Uint8Array                                                                   | The original file resources corresponding to the specified resource path                   | string                                                               | Read CSS file content                                                                          |
| CSSParser.getValueByProperty | root：postcss.Document \|  postcss.Root, prop：string                                  | Node to be parsedd,Attribute Name                                                          | Array:string[]                                                       | Retrieve attribute values based on attribute names                                             |
| CSSParser.getSelectorList | root: postcss.Document \| postcss.Root                                               | Node to be parsed                                                                          | Array:string[]                                                       | Retrieve selectors from styles                                                                 |
| CSSParser.getMediaList | root: postcss.Document \| postcss.Root                                               | Node to be parsed                                                                          | Array:string[]                                                       | Retrieve the media query list from the style                                                   |
| CSSParser.getStyleDeclaration | declaration: string                                                                  | style declaration                                                                          | postcss.Declaration                                                  | Get style declaration                                                                          |
| postcss().process | css:string                                                                           | css string                                                                                 | postcss.LazyResult<postcss.Document \| postcss.Root> \| NoWorkResult | Parse the incoming string as AST                                                               |
| CSSParser.setParentStyleSheet | css: string                                                                          | css string                                                                                 | None                                                                 | Set parent style sheet                                                                         |
| CSSParser.getParentStyleSheet | None                                                                                 | None                                                                                       | css: string                                                          | Get parent style sheet                                                                         |

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
