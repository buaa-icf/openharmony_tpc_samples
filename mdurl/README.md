# mdurl

## Introduction
**mdurl** is a utility library used for handling URLs in the markdown-it parser.

## How to Install
```shell
ohpm install mdurl
ohpm install @types/mdurl --save-dev // Install @types/mdurl to prevent import syntax errors due to missing type declarations in the mdurl package.

```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
1. Import dependencies.
 ```
 import { encode,decode } from 'mdurl'
 ```

## Available APIs
* encode
```
 encode('Hello World') // Hello%20World
```
* decode
```
 decode('Hello%20World') // Hello World
```
* parse
```
 parse('http://example.com:?a=b')
 // {
 //  'protocol': 'http:',
 //   'slashes': true,
 //   'hostname': 'example.com',
 //   'search': '?a=b',
 //   'pathname': ':'
 // }
```
* format
```
 let parse = parse('http://example.com:/a/b.html')
 format(parse) //http://example.com:/a/b.html
```

## Directory Structure
````
|---- mdurl
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README.md  # Readme                   
|     |---- README_zh.md  # Readme                   
````

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/mdurl/LICENSE).
