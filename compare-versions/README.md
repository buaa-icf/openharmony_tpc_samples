# compare_versions

## Introduction

compare-versions is a library for comparing version numbers, offering a simple and reliable method to determine the order of two versions. This library supports various version formats, including numeric, semantic, and other common notations. With compare-versions, you can easily ascertain whether one version number is greater than, equal to, or less than another, facilitating version management and control.

## How to Install

```
ohpm install compare_versions
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```
import { compareVersions, compare, satisfies, validate, validateStrict } from "compare-versions";

compareVersions('11.1.1', '10.0.0'); //  1
compareVersions('10.0.0', '10.0.0'); //  0
compareVersions('10.0.0', '11.1.1'); // -1

compare('10.1.8', '10.0.4', '>');  // true
compare('10.0.1', '10.0.1', '=');  // true
compare('10.1.1', '10.2.2', '<');  // true
compare('10.1.1', '10.2.2', '<='); // true
compare('10.1.1', '10.2.2', '>='); // false

satisfies('10.0.1', '~10.0.0');  // true
satisfies('10.1.0', '~10.0.0');  // false
satisfies('10.1.2', '^10.0.0');  // true
satisfies('11.0.0', '^10.0.0');  // false
satisfies('10.1.8', '>10.0.4');  // true
satisfies('10.0.1', '=10.0.1');  // true
satisfies('10.1.1', '<10.2.2');  // true
satisfies('10.1.1', '<=10.2.2'); // true
satisfies('10.1.1', '>=10.2.2'); // false
satisfies('1.4.6', '1.2.7 || >=1.2.9 <2.0.0'); // true
satisfies('1.2.8', '1.2.7 || >=1.2.9 <2.0.0'); // false
satisfies('1.5.1', '1.2.3 - 2.3.4'); // true
satisfies('2.3.5', '1.2.3 - 2.3.4'); // false

validate('1.0.0-rc.1'); // true
validate('1.0-rc.1');   // false
validate('foo');        // false

validateStrict('11.0.0') // true
```

## Available APIs

| API                                                        | Parameter                                                                                                                      | Description                                                                                                                                                                                                |
|:-----------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| compareVersions(versionA:string, versionB:string)          | versionA: The first version number (string)</br>versionB: The second version number (string)                                   | Compare the sizes of two version numbers.                                                                                                                                                                  |
| compare(versionA:string, versionB:string, operator:string) | versionA: The first version number (string)</br>versionB: The second version number (string)</br>operator: Comparison operator | Compare the size relationship of two version numbers.                                                                                                                                                      |
| satisfies(version:string, range:string)                    | version: The version to be checked (string)</br>  range: Version range (string, such as ^1.0.0 or >=1.0.0 <2.0.0)              | Check if the version number meets the specified range                                                                                                                                                      |
| validate(version:string)                                   | version: The version to be checked                                                                                             | Validate if the version number conforms to the SemVer specification                                                                                                                                        |
| validateStrict(version:string)                             | version: The version to be checked                                                                                             | Strictly validate if the version number conforms to the SemVer specification, including the major version number, minor version number, patch version, and optional pre-release labels and build metadata. | |

## Constraints

This project has been verified in the following versions:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)
- DevEco Studio: 4.1 Canary (4.1.3.213), SDK: API 11 4.1.2.3

## Directory Structure

```
|---- compare-versions
|     |---- entry      # Sample code
|     |---- README.md  # Readme
```

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/compare-versions/LICENSE).
