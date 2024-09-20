# requires-port

## Overview

requires-port is a Node.js module used to check whether a port number needs to be specified for a given protocol.

## How to Install
```shell
ohpm install requires-port@1.0.0
ohpm install @types/requires-port@1.0.0  // If a syntax error is reported, the requires-port package does not contain the type declaration. You need to download the declaration file of the package from @types/requires-port to rectify the syntax error.
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
1. Importing files and code dependency.
 ```
 import required from 'requires-port'
 
 required('8080','http')
 required(8080,'ws')
 required(8080,'ftp')
 required(8080,'gopher')
 ```

## Available APIs
* Checks the port.
 `required()`


## Constraints

requires-port has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure
````
|---- requires-port
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README_EN.md  # Readme               
````
## How to Contribute
If you find any problem when using requires-port, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/requires-port/LICENSE).
