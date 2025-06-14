# parse-srcset

## Overview

parse-srcset is a JavaScript parser for HTML5 srcset attributes. It is based on the WHATWG reference algorithm. parse-srcset has an extensive test suite based on the W3C srcset conformance checker. It complies with the jQuery JSCS syntax rules. For compatibility, use **internet -geezer** to compile test cases.

## How to Install

```shell
ohpm  install parse-srcset@1.0.2
```

For details, see [Installing an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```js
import * as parseSrcset from 'parse-srcset'
let result:ESObject = JSON.stringify(parseSrcset('&#x9;&#x9;data:,a&#x9;&#x9;1x&#x9;&#x9'));
```
## Available APIs
parseSrcset: Parses the HTML5 srcset attributes.

## Constraints

parse-srcset has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure

````
|---- parse_srcset
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README_EN.md  # Readme                   
````

## How to Contribute

If you find any problem when using parse-srcset, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or
a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/parse-srcset/LICENSE).
