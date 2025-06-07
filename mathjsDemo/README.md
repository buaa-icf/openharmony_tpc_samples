# mathjs

## Introduction
- The mathjs demo shows the use of mathematical operations encompassing numbers, big numbers, trigonometric functions, strings, matrix manipulations, and additional functionalities in OpenHarmony.
- Currently, the functions listed in the table below are supported.

|                           Math Library                          |                             Description                            |
| :--------------------------------------------------------: | :----------------------------------------------------------: |
| [mathjs](https://mathjs.org/docs/reference/functions.html) | Algebraic functions, arithmetic functions, bitwise functions, logical functions, matrix functions, trigonometric functions, judgment functions, comparison functions, and big number arithmetic functions.|
|         [long](https://github.com/dcodeIO/long.js)         | Converting strings to long type, converting numbers to long type, long arithmetic functions, long bitwise functions, long logical functions, and converting long types to 32-bit integers.|
|   [bignumber.js](https://mikemcl.github.io/bignumber.js)   |                        Radix conversion functions.                       |
|          [matrix](https://mljs.github.io/matrix)           |                      Matrix operation and computation functions.                     |

## How to Install

|     Library    |                 URL                |         Installing ohpm         |
| :----------: | :-------------------------------------: | :-----------------------: |
|    mathjs    |   https://github.com/josdejong/mathjs   |    ohpm install mathjs    |
|     long     |   https://github.com/dcodeIO/long.js    |     ohpm install long     |
| bignumber.js | https://github.com/MikeMcl/bignumber.js | ohpm install bignumber.js |
|    matrix    |     https://github.com/mljs/matrix      |  ohpm install ml-matrix   |

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Using mathjs
```javascript
	import * as math from 'mathjs';
	or import {abs,add,bignumber,...} from 'mathjs';

	let mathabs = math.abs(math.bignumber('-123456789123456789123456789'))
	console.log(mathabs);//123456789123456789123456789
          
   	let mathabs = abs(bignumber('-123456789123456789123456789'))
	console.log(mathabs);//123456789123456789123456789
          
    let mathabs = math.add(math.bignumber('123456789123456789123456789'),math.bignumber('123456789123456789123456789'))
	console.log(mathabs);//123456789123456789123456789
          
   	let mathabs = add(bignumber('123456789123456789123456789'),bignumber('123456789123456789123456789'))
	console.log(mathabs);//246913578246913578246913578
	
```
For details, see https://mathjs.org/docs/reference/functions.html.

### Using bignumber.js

``` javascript
	import BigNumber from "bignumber.js";

	let x = BigNumber("123456789",16);
	console.log(x);//4886718345

    let x = new BigNumber(123.4567);
    let y = BigNumber('123456.7e-3');
    let z = new BigNumber(x);
    x.isEqualTo(y) && y.isEqualTo(z) && x.isEqualTo(z);
    

```

For details, see https://mikemcl.github.io/bignumber.js.

### Using long

``` javascript
	import long  from "long";

	let longvalue = long.fromString('1234567891234567891').toString()
    console.log(longvalue);//1234567891234567891

	let intvalue = long.fromString('1234567891234567891').toInt().toString()
    console.log(intvalue);//-1071401261

```

For details, see https://github.com/dcodeIO/long.js.

### Using matrix

``` javascript
	import { Matrix } from 'ml-matrix'

	let A = new Matrix([[1, 1],[2, 2]]);

	let B = new Matrix([[3, 3],[1, 1]]);

	const addition = Matrix.add(A, B);//[[4, 4], [3, 3], rows: 2, columns: 2]

```

For details, see https://mljs.github.io/matrix.

## Directory Structure

```
/mathjsDemo # Demo code
|—— entry
├── src     
│   └── main
│   	└── ets
│   	    └── entryability
│   	    └── crcalc
│   	        └── crcalc.ets         # Big number calculation page of mathjs
│   	    └── ejml
│   	        └── ejml.ets           # Matrix page of matrix
│   	        └── ejmlMathjs.ets     # Matrix page of mathjs
│   	    └── jafama
│   	        └── jafama.ets         # Trigonometric function page of mathjs
│   	    └── mathjs
│   	        └── mathjs.ets         # Bitwise operation and value judgment page of mathjs
│   	    └── pages
│       	    └── Index.ets          # Home page of the mathjs demo
```
### APIS

| Function         | Type              | Description |
|------------------|-------------------|-------- |
| math.abs         | x:number          |Calculate the absolute value of a number.|
| math.add         | x:number          |	Add two or more values, x + y.|
| math.cbrt        | x:number          |	Calculate the cubic root of a value.|
| math.ceil        | x:number          |	Round a value towards plus infinity If x is complex, both real and imaginary part are rounded towards plus infinity.|
| math.cube	    | x:number          |Compute the cube of a value, x * x * x.|
| math.divide      | x:number,y:number          |	Divide two values, x / y.|
| math.dotDivide   | x:number,y:number          |	Divide two matrices element wise.|
| math.dotMultiply | x:number,y:number |	Multiply two matrices element wise.|
| math.dotPow      | x:number,y:number |	Calculates the power of x to y element wise.|
| math.exp         | x:number          |	Calculate the exponential of a value.|
| math.expm1       | x:number          |	Calculate the value of subtracting 1 from the exponential value.|
| math.fix         | x:number          |Round a value towards zero. |

The above only lists a few scene interfaces: 
- For more commonly used methods, please refer to: https://mathjs.org/docs/reference/functions.html 
- For more BigNumber calculation methods, please refer to: https://mikemcl.github.io/bignumber.js 
- For more Long calculation methods, please refer to: https://github.com/dcodeIO/long.js
- For more matrix calculation methods, please refer to: https://mljs.github.io/matrix

## Constraints
This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317)

- OpenHarmony SDK: API 11 (4.1.0.36)

## How to Contribute
If you find any problem when using the mathjs demo, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/mathjsDemo/LICENSE).
