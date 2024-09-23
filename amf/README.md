# amf-convert

## Introduction
**amf-convert** provides APIs for serializing and deserializing data in AMF format in JavaScript.


## How to Install
```shell
ohpm install amf-convert
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Serialization and Deserialization
```javascript
import AMF,{ Spec,ByteArray } from "amf-convert";
var data = {
    any: 'data',
    you: 'like!'
};
// Implement serialization.
var encodedData = AMF.stringify(data);
var encodedData2 = AMF.serialize(data, true, Spec.AMF3_OBJECT)
// Implement deserialization.
var decodeData = AMF.parse(encodedData);
var decodeData2 = AMF.deserialize(data, Spec.AMF3_OBJECT)
```


## Directory Structure
````
|---- amf  
|     |---- entry            # Sample code
|           |---- Index.ets  # Demo
|     |---- README.MD        # Readme                   
|     |---- README_zh.MD        # Readme                   
````

## Constraints

This project has been verified in the following version:

DevEco Studio version: 4.0 Canary2 (4.0.1.300); SDK: API10 (4.0.9.6)

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/amf/LICENSE).
