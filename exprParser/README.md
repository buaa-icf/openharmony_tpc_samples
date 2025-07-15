# expr-parser

##  Overview

A handy js expression parser.

## How to Install
```shell
ohpm install @ohos/expr-parser
```
For details, see [Installing an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

### Tips

This library is built on top of expr-parser 1.0.0. To use the original library directly, you can install it via `ohpm install expr-parser`.

```javascript
import Expression from "expr-parser"; //The package import differs slightly, while the usage remains consistent.
```

## How to Use

   ```typescript 
   import Expression from "@ohos/expr-parser";
   import hilog from '@ohos.hilog';

   const exprCalc = new Expression('a.value + 12 - (2 * 14 / 4)').parse(); // Incoming expression.
   let res = exprCalc({ a: { value: 3 } }); // Pass in the data and store the result in the res variable.
   hilog.info(0x0001, "expr-parser TEST:", "result: %{public}d", res); // Print calculation results 8.
   ```

## Available APIs

- Generating formula calculator

```typescript
const exprCalc = new Expression('a.value + 12 - (2 * 14 / 4)').parse();
```

## Constraints

expr-parser has been verified in the following version:

- DevEco Studio Version: 5.0.1 Release, OpenHarmony SDK: API Version 13 Release (5.0.1.115).
- DevEco Studio Version：DevEco Studio 5.1.0 Canary1(5.1.0.229)，OpenHarmony SDK:5.1.0.229 API16(5.1.0.46).

## Directory Structure
```
|----exprParser
|    |---- entry
|         |---- src
|              |---- main
|                   |---- ets
|                        |---- pages
|                             |---- Index.ets  # sample code
|              |---- ohosTest  # xts code
|    |---- library  # Core implementation of the expr-parser
|    |---- README.md  # Readme
|    |---- README_zh.md  # Chinese Readme
```

## How to Contribute
If you find any problem when using expr-parser, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/exprParser/LICENSE).