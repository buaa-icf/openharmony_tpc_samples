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
let rule = new postcss.AtRule({ name: 'encoding', params: '"utf-8"' })
let comment = new postcss.Comment({ text: 'hi' })
let decl = new postcss.Declaration({ prop: 'color', value: 'black' })
let result = postcss.fromJSON({ type: 'not-a-node-type' })
```
## Available APIs
postcss.AtRule()
postcss.Comment()
postcss.Declaration()
postcss.fromJSON()
postcss.parse()
postcss.Root()

## Constraints
This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure

```
/postcss       # Root directory of the project
      ├── entry                  # Sample code 
           ├── src 
               ├── main
                   ├── ets
                      ├── pages 
                         ├── index.ets   Sample code
      ├── library                  
          ├── main                   
                 ├── components                 
                    ├── lib                 # Source library file     
```

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT](https://github.com/postcss/postcss/blob/main/LICENSE).
