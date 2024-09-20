# querystringify

## Overview

querystringify is a library that implements a lightweight but powerful query string parser.

## How to Install

```shell
ohpm install querystringify
ohpm install @types/querystringify  // A syntax error is reported if the querystringify package does not contain the type declaration. You need to download the declaration file of the package from @types/querystringify to rectify the syntax error.
```

OpenHarmony
For details about the ohpm environment configuration, see [Installing the OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

1. Importing files and code dependency.

 ```
 import qs from 'querystringify'
 
 qs.parse('?foo=bar')  //{foo:'bar'}
 
 qs.stringify({ foo: 'bar' }, '#')  //#foo=bar
 
 ```

## Available APIs

* Converts the given query string to an object.
  - `parse()`
* Converts a given object to a query string.
  - `stringify()`

## Directory Structure
````
|---- querystringify
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README_EN.md  # Readme                   
````

## Constraints

querystringify has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## How to Contribute

If you find any problem when using querystringify, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or
a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License
This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/querystringify/LICENSE).
