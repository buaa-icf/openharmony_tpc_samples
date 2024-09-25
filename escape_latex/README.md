# escape_latex

## Introduction

> JavaScript is used to escape LaTeX special characters.

## How to Install

```shell
ohpm  install escape-latex@1.2.0
ohpm  install @types/escape-latex  // If a syntax error is reported, the escape-latex package does not contain the type declaration. You need to download the declaration file of the package from @types/escape-latex to rectify the syntax error.
```

For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


```js
import lescape from "escape-latex"

lescape("String to be escaped here #yolo") // output String to be escaped here \\#yolo
lescape("Hello   World", { preserveFormatting: true }) // output Hello~~~World
```
For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/escape_latex/TEST.md).

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Available APIs

| *API       | Parameter           | Description       |
|---------------|---------------|-----------|
| lescape(data) | data: data to be converted|   Escapes LaTeX special characters.   |

## Directory Structure

````
|---- escape_latex
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README.md  # Readme         
|     |---- README_zh.md  # Readme       
````

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/escape_latex/LICENSE).
    
