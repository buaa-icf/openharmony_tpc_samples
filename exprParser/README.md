# expr-parser

##  Overview

A handy js expression parser.

## How to Install
```shell
ohpm install expr-parser
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

   ```typescript 
   import Expression from "expr-parser";
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

- DevEco Studio Version: 5.0.1 Release, OpenHarmony SDK: API Version 13 Release (5.0.1.115)

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
|    |---- README.md  # Readme
|    |---- README_zh.md  # Readme
```

## How to Contribute
If you find any problem when using expr-parser, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/exprParser/LICENSE).