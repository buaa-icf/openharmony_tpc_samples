# amf-convert

## Introduction
**amf-convert** provides APIs for serializing and deserializing data in AMF format in JavaScript.


## How to Install
```shell
ohpm install amf-convert
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Serialization and Deserialization
```javascript
import AMF,{ Spec,ByteArray } from "amf-convert";
let data = {
    any: 'data',
    you: 'like!'
};
// Implement serialization.
let encodedData = AMF.stringify(data);
let encodedData2 = AMF.serialize(data, true, Spec.AMF3_OBJECT)
// Implement deserialization.
let decodeData = AMF.parse(encodedData);
let decodeData2 = AMF.deserialize(data, Spec.AMF3_OBJECT)
```

## API

| API                                                          | Description                                                                                                          |
|--------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| `AMF.stringify(data: object)`                                | Encoding an object to AMF                                                                                            |
| `AMF.parse(encodedData: object)`                             | Decoding to object.                                                                                                        |
| `AMF.registerClassAlias(string, object)`                     | register a "class alias" using AMF.registerClassAlias to associate the _classMapping value to its related class type |


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

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/amf/LICENSE).
