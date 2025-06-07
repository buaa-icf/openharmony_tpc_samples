# percentage-regex
## Introduction
This demo uses the third-party JavaScript library percentage-regex in OpenHarmony for percentage validation.

## How to Install

```ts
ohpm install percentage-regex
ohpm install @types/percentage-regex@3.0.0  // Install @types/percentage-regex to prevent import syntax errors due to missing type declarations in the percentage-regex package.
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```ts
import percentageRegex from 'percentage-regex';

let result:boolean = percentageRegex({exact: true}).test("19%")
['10%'].toString() = 'foo 10% bar'.match(percentageRegex({exact: false})).toString()
```

## Available APIs
| API                    | Description                                                        |
| ------------------------ | ------------------------------------------------------------ |
| percentageRegex(options) | Returns a regular expression that matches percentage values.                              |
| options.exact            | Whether to enable exact matching. The value is of the Boolean type and defaults to **false** (means to match any percentage within a string). This API is especially useful when used with **RegExp#test** for verifying whether a string is a percentage.|


For details about unit test cases, see [TEST.md](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/percentage-regex/TEST.md).

## Constraints
This project has been verified in the following versions:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)
- DevEco Studio: 4.0 Canary1 (4.0.0.112), SDK: API 10 (4.0.7.2)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)

## How to Contribute

If you find any problem when using this project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/percentage-regex/LICENSE).
