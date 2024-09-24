# fraction_js

## Introduction

> A rational number library

## How to Install

```shell
ohpm  install fraction.js@4.2.0
```

For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


```js
import Fraction from 'fraction.js';

let x = Fraction(1.23);
x.mul(98)
x.div(98)
x.add(3)
x.sub(33)
x.pow(2)
x.ceil()
x.floor()
x.round()
x.neg()
x.abs()
x.mod(1)
x.clone()
x.toString()
x.gcd('2')
x.lcm('2')
x.simplify()
x.divisible(2)
x.valueOf()
x.toContinued()

```
For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/fraction_js/TEST.md).

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure

````
|---- fraction_js
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

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/fraction_js/LICENSE).
    
