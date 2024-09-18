# domelementtype

## Introduction
> domelementtype is a utility library that defines all types of DOM nodes in the htmlparser2 library.

## How to Install
```shell
ohpm install domelementtype 
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
1. Import files and code dependencies.

    ```
     import { ElementType, isTag } from 'domelementtype'
    ```

2. Define enum classes.

    ```
       ElementType.Text
       ElementType.Comment
       ElementType.Directive
       ElementType.CDATA
       ...
       isTag({ type:ElementType.Text})
    ```

## Available APIs

Checks whether a node is a tag.

`isTag(elem: { type: ElementType; }): boolean`

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure
````
|---- domelementtype
|     |---- entry  # Sample code
|           |---- src
|                 |---- ohosTest
|                       |---- ets
|                             |---- test
|                                   |---- Ability.test.ets  # Unit test
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme
|     |---- README.OpenSource  # Open source description
|     |---- CHANGELOG.md  # Changelog                 
````

## How to Contribute
If you find any problem when using domelementtype, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [BSD License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/domelementtype/LICENSE).
