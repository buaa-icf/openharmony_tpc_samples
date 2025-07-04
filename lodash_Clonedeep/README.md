# lodash.clonedeep

## Overview

lodash.clonedeep is a library used for deep cloning a given object. Deep cloning means that not only the attributes of an object are copied, but also all its child objects are copied recursively to ensure that the generated copy is completely independent of the original object.

## How to Install

```bash
ohpm install lodash.clonedeep@4.5.0
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```bash
import cloneDeep from @ohos/lodash.clonedeep
this.message = 'const objb = { b: null };\r\n const obja = { a: objb }; \r\nobjb.b = obja;\r\n Copy result: \r\n'
    try {
      const objb = { b: null };
      const obja = { a: objb };
      objb.b = obja;
      let origin = JSON.stringify(objb)
      console.log('ZDY---No cloning used--->' + origin)
      this.message = this.message + "No cloning used. Cyclic reference result directly printed"+ origin"
    } catch (err) {
      console.log('ZDY---No cloning used--->' + err);
      this.message = this.message + "\r\n No cloning used. Cyclic reference error: " + err
    }
    try {
      const objb = {
        b: null
      };
      const obja = {
        a: objb
      };
      objb.b = cloneDeep(obja);
      let cloneObj = JSON.stringify(objb)
      console.log('ZDY---Cloning used--->' + cloneObj);
      this.message = this.message + "\r\n Deep cloning used. Cyclic reference result: " + cloneObj
    } catch (err) {
      console.log('ZDY---Cloning used--->' + err);
      this.message = this.message + "\r\n Deep cloning used. Cyclic reference error: " + err
    }
```
## Available APIs


| Name                                                     | Description            |
| ------------------------------------------------------------ | ---------------- |
| cloneDeep(value: ESObject): ESObject | Deep clones an object. |



## Constraints

lodash.clonedeep has been verified in the following version: DevEco Studio 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)
## Directory Structure
````
|---- lodash_Clonedeep  
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme                    
````

## How to Contribute
If you find any problem when using lodash_clonedeep, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).
## License
This project is licensed under [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/lodash_Clonedeep/LICENSE).
