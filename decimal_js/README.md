# decimal_js

## Introduction

> An arbitrary-precision Decimal type for JavaScript.

## How to Install

```shell
ohpm  install decimal.js@10.4.0
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


```js
import decimal from "decimal.js"

let x = new Decimal(123.4567);
x.add(33)
x.sub(33)
x.mul(2)
x.div(3)
x.pow(2)
x.abs()
x.floor()
x.ceil()
x.round()
x.toBinary()
x.toExponential(5)
x.toFixed(5)
x.toPrecision(5)
x.toFraction()
x.isZero()

```
For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/decimal_js/TEST.md).

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure

````
|---- decimal_js
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

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/decimal_js/LICENSE).
    
