# complex_js

## Introduction

> Complex.js is a well tested JavaScript library to work with complex number arithmetic in JavaScript. 

## How to Install

```shell
ohpm  install complex.js@2.4.2
```

For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


```js
import { Complex } from "complex.js"

let c = new Complex("99.3+8i");
c.mul({re: 3, im: 9})
c.div(4.9)
c.sub(3, 2)
c.add(3, 2)
c.pow(1, 2)
c.sqrt()
c.abs()
c.floor(0)
c.ceil(1)
c.round(1)
c.clone()
c.isZero()
c.cot()
c.acos()


```
For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/complex_js/TEST.md).

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure

````
|---- complex_js
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

This project is licensed under [MIT License]([TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/complex_js/TEST.md)).
    
