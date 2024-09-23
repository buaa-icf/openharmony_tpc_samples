# String.prototype.repeat

## Introduction
This library allows creation of a new string containing the specified number of copies of the string concatenated together.

## How to Install
```shell
ohpm install string.prototype.repeat
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
Import dependencies and create a string that has "abc" repeated twice.

 ```
import repeat from 'string.prototype.repeat'

let repeatValue= 'abc'.repeat(2) //abcabc
 ```

## Available APIs
| API        | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| `repeat()` | Creates a new string containing the specified number of copies of the given string concatenated together. |



## Directory Structure
````
|---- string.prototype.repeat
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
This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/string.prototype.repeat/LICENSE).
