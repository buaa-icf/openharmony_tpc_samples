# jmespathDemo

## Introduction
This demo uses the third-party JavaScript library [jmespath.js](https://github.com/jmespath/jmespath.js) in OpenHarmony. jmespath is the query language for JSON. JSON data can be queried or operated using basic expression, slice, list and slice projection, object projection, flat projection, filter projection, pipe expression, multi-choice, functions, and more.

## How to Install
```
ohpm install jmespath
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use
After jmespath is installed, import jmespath to the page to be used and call the search API.
```
import  JmesPath from 'jmespath'
let result: number | string = JmesPath.search({foo: {bar: {baz: [0, 1, 2, 3, 4]}}}, "foo.bar.baz[2]") 
if (result) {
    this.resultText = JSON.stringify(result) // The result is 2.
} else {
    this.resultText = 'No result is found.'
}
```

## Available APIs

|              API             |             Parameter            |    Description   |
|:-----------------------------:|:--------------------------:|:----------:|
|      search(case, expression)      | **case**: test data; **expression**: query expression|   Returns query results.  |


For details about how to use more APIs, see [Official Document] (https://github.com/jmespath/jmespath.js).
## Constraints
This project has been verified in the following version:
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

# Directory Structure
    |---- jmespathDemo  
    |     |---- entry  # Sample code
    |          |---- src
    |               |---- main
    |                    |---- ets
    |                         |---- pages
    |                              |---- Index.ets  # On the home page of the application, examples are provided to test various capabilities of jmespath.                  
    |     |---- README.md  # Readme

## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/tree/master/jmespathDemo/LICENSE).

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.
