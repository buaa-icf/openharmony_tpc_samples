# minimist

## Introduction

**minimist** is a lightweight library for parsing command-line parameters in Node.js. It is used to parse command-line parameters into an object for further use.

## How to Install

```shell
ohpm install minimist
ohpm install @types/minimist@1.2.2  // Install @types/minimist@1.2.2 to prevent import syntax errors due to missing type declarations in the minimist package.
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

Import dependencies.

 ```
 import minimist from 'minimist'
 
 let parse = minimist(['-f', '11', '--zoom', '55'], { alias: { z: ['zm', 'zoom']}})
 // {"_":[],"f":11,"zoom":55,"z":55,"zm":55} 
 ```

## Available APIs

| API                       | Description                            |
| ------------------------- | -------------------------------------- |
| `minimist(args, opts={})` | Parses command-line parameters into a JavaScript object.|



## Directory Structure
````
|---- minimist
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README.md  # Readme                   
|     |---- README_zh.md  # Readme                   
````
## Constraints

This project has been verified in the following version:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/minimist/LICENSE).
