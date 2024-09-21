# ahocorasick 

## Introduction

This project is an OpenHarmony development example based on the [ahocorasick](https://github.com/BrunoRB/ahocorasick) library, an implementation of the Aho-Corasick string searching algorithm, for efficient string matching.

## How to Install

```
ohpm install ahocorasick
```

## How to Use

> **NOTE**
>
> When constructing the Aho-Corasick searching algorithm, passing empty values is not allowed. You must perform null checks on both the keywords and the original text content before constructing the algorithm.

```
// @ts-ignore
import AhoCorasick from 'ahocorasick'
var ac = new AhoCorasick(['keyword1', 'keyword2', 'etc']);
var results = ac.search('should find keyword1 at position 19 and keyword2 at position 47.');
```

```
Output: [ [ 19, [ 'keyword1' ] ], [ 47, [ 'keyword2' ] ] ]
```

## Available APIs

```
  let aho:AhoCorasick = new AhoCorasick([keyWords]);
```
| API                  | Parameter        | Description                                          |
|--------------------------|------------| ---------------------------------------------- |
| aho.search(text: string) | **text**: value to match | Searches for multiple keywords within a text. It returns a list containing the ending index and the keyword itself for each keyword found in the text. If no matches are found, it returns an empty list.                              |



## Constraints
This project has been verified in the following versions:
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## Directory Structure
```
|---- ahocorasick  
|     |---- entry  # Sample code
|           |---- index.ets  # External APIs
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme                   
```

## How to Contribute
If you find any problem during the use, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ahocorasick/LICENSE).
