# boolbase

## Overview
Provides two basic functions, one that always returns true (trueFunc) and one that always returns false (falseFunc).

## How to Install
```shell
ohpm install boolbase
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```js
import { falseFunc, trueFunc } from 'boolbase';

@Entry
@Component
struct Index {
    build() {
        RelativeContainer() {
            Column() {
                Text("trueFunc: " + JSON.stringify(trueFunc()))
                .fontSize(20)
                Text("falseFunc: " + JSON.stringify(falseFunc()))
                .fontSize(20)
            }
        }
        .height('100%')
        .width('100%')
    }
}
```
## Available APIs

- always returns true

```typescript
    trueFunc()
```
- always returns false

```typescript
    falseFunc()
```


## Constraints

boolbase has been verified in the following version:

- DevEco Studio Version: 5.0.1 Release (5.0.5.310), OpenHarmony SDK: 13 (5.0.0(13))

## Directory Structure
```
|----boolbase
|     |---- entry  # Sample code
|          |----src
|              |----main
|                  |----ets
|                      |----pages
|                          |---- Index.ets
|     |---- README.md  # Readme 
|     |---- README_zh.md  # Readme 
```

## How to Contribute
If you find any problem when using boolbase, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/boolbase/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/boolbase/pulls).

## License
This project is licensed under [ISC](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/boolbase/blob/master/LICENSE).
