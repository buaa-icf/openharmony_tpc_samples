# metaphone

## Introduction

>Metaphone can convert a specific string (usually an English word) into a code and compare it with other codes (or other words) to check whether they are (possibly) pronounced the same.

## How to Install
```shell
ohpm install metaphone 
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### metaphone

   ```
    let result = metaphone('Agrippa');
   ```
## Available APIs
   ```
   // Obtain the pronunciation code of a word.
   public metaphone(src: string)
   ```
## Constraints

This project has been verified in the following versions:

- DevEco Studio: 4.0 Canary1 (4.0.0.112), SDK: API 10 (4.0.7.2)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
## Directory Structure

````
|---- MetaPhone
|   |---- entry # Sample code               
|   |---- README.md  # Readme
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-sig/subsampling-scale-image-view/pulls).

## License
This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/MetaPhone/LICENSE).

  
