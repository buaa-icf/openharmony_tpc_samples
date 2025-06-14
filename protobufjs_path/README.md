# @protobufjs/path

## Introduction

> @protobufjs/path is a minimal path module to resolve Unix, Windows, and URL paths.

## How to Install

```shell
ohpm install @protobufjs/path
```

OpenHarmony
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Importing and Using the Library

```
import path from "@protobufjs/path"
  // Test whether a specified path is an absolute path.
  path.isAbsolute("X:\\some\\path\\file.js")
  // Normalize a specified path.
  path.normalize("X:\\some\\..\\.\\path\\\\file.js")
  // Resolve a specified include path based on the specified original path.
  path.resolve("/path/origin.js", "/some/.././path//file.js")
```

## Available APIs

1. Tests whether a specified path is an absolute path.
   `isAbsolute(path: string): boolean`
2. Normalizes a specified path.
   `normalize(path: string): string`
3. Resolves a specified include path based on the specified origin path.
   `resolve(originPath: string, includePath: string, alreadyNormalized?: boolean): string`

## Constraints

This project has been verified in the following versions:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure

````
|---- protobuf_path
|     |---- entry  # Sample code
|           |---- src
|                 |---- main
|                        |---- ets
|                              |---- pages
|                                    |---- Index # sample
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # Unit test

|     |---- README.md  # Readme
|     |---- README.OpenSource  # Open source description
|     |---- CHANGELOG.md  # Changelog               
````

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [BSD License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/protobuf_path/LICENSE).
