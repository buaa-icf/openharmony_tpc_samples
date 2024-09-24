# intl_unified_numberformat

## Introduction

> intl_unified_numberformat is an internationalization utility library for determining whether number formatting is supported.


## How to Install

```shell
ohpm install @f-fjs/intl-unified-numberformat@3.2.1
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

1. Import the dependency library.

   ```typescript
   import * as intl_unified_numberformat from '@ohos/intl_unified_numberformat'
   ```

2. Use related APIs as required.

   ```typescript
   Button('isUnitSupported test').fontSize(24).onClick(() => {
     let unit:intl_unified_numberformat.Unit = 'degree';
     let supportedResult = intl_unified_numberformat.isUnitSupported(unit);
     if (supportedResult) {
       setData('Test succeeded', this.dialogController)
     }
   })
   ```

## Available APIs

Checks whether a unit is supported.

```typescript
isUnitSupported(unit: Unit)
```

## Constraints

This project has been verified in the following version:

DevEco Studio 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure
````
|---- Intl_unified_numberformat  
|     |---- entry  # Sample code
|     |---- README.md  # Readme                   
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
## License
This project is licensed under [MIT LICENSE](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Intl_unified_numberformat/LICENSE).
