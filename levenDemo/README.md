# levenDemo

## Introduction
This project is an OpenHarmony development example based on the [leven](https://github.com/sindresorhus/leven) library. It measures the difference between two strings using the Levenshtein distance algorithm.

## How to Install
```
ohpm install leven
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use

```javascript
import leven from 'leven';

let data1:string = "ABCDEF";
let data2:string = "ABCDGH";
let s:number = leven(data1,data2);
```

## Available APIs

| API                | Parameter                                                    | Description                                                 |
| :----------------- | :----------------------------------------------------------- | ----------------------------------------------------------- |
| leven(data1,data2) | **data1**: content of the first string<br>**data2**: content of the second string | Compares the number of differences between the two strings. |


## Constraints
This project has been verified in the following versions:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66) 
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/tree/master/levenDemo/LICENSE).

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
