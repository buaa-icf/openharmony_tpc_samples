# caverphone

## Introduction

>A JavaScript implementation of the Caverphone phonetic matching algorithm, which can convert keywords to lowercase letters, remove characters that are not a–z, replace specified characters according to rules (for example, at the beginning or end of strings or when the text contains **cq**), place six 1s at the end, and return the first ten characters. For details, refer to Caverphone algorithm rules.

## How to Install
```shell
ohpm install caverphone 
ohpm install @types/caverphone@1.0.0  // Install @types/caverphone to prevent import syntax errors due to missing type declarations in the caverphone package.
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### caverPhone

   ```
    let result = caverPhone('Cailean');
   ```
## Available APIs

   ```
   // Obtain the result of the Caverphone algorithm.
   public caverPhone(src: string)
   ```
## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.0 Canary1 (4.0.0.112), SDK: API 10 (4.0.7.2)

## Directory Structure

````
|---- CaverPhone
|   |---- entry # Sample code               
|   |---- README.md  # Readme
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-sig/subsampling-scale-image-view/pulls).

## License
This project is licensed under [ISC License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/CaverPhone/LICENSE).

  
