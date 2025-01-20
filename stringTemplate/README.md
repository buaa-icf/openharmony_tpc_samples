# ohos/stringtemplate

## Introduction
stringtemplate is a template engine for text generation that allows you to merge text templates with data to generate the final text output.

## How to Install

```shell
ohpm install @ohos/stringtemplate
```
- For more information on OpenHarmony ohpm environment configuration, please refer to [How to Install OpenHarmony ohpm Package](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md).

## How to Use

### Compile st files or folders

```typescript
import { Stc } from '@ohos/stringtemplate';
  
let path = '/dir/test.st'; // path is the absolute path of the file to be compiled or the absolute path of the folder to be compiled
let stc = new Stc();
// Supported start and end separators: #$%^&*<> 
// The default start and end separators are $
// stc.statDelimiters = '<'; // Set the start delimiter for compiling files
// stc.endDelimiters = '>';  // Set the end delimiter for compiling files
stc.compile(path);
// After compilation, a file (template name _stg.js) will be generated in the same path as the incoming file.
```

1. Import Stc from "@ ohos/stringtemplate".
2. Initialize a new Stc object stc.
3. Call the stc. compile (path) function and pass in the absolute path of the file or folder to be compiled.

### Text template and data merging
```typescript
// Using the processTemplate interface
import { Stc, ProcessTemplate } from '@ohos/stringtemplate';
import getInstance from '../xxx/introduce_stg'; // Import the xxxstg.js file compiled from the previous step.

let p = new ProcessTemplate();
let data = new Object({ name: "LiHua", like: "Orange" });
let templateName = 'introduce'; // The template name is consistent with the template name in the. st file.
let res: string = p.processTemplate(getInstance, data, templateName); // res is the final text that combines templates and data.
```

```typescript
// Using the loadGroup interface
import { st } from '@ohos/stringtemplate';
import getInstance from '../xxx/introduce_stg'; // Import the xxxstg.js file compiled from the previous step.
  
let p = new ProcessTemplate();
let data = new Object({ name: "LiHua", like: "Orange" });
let templateName = 'introduce'; // The template name is consistent with the template name in the. st file.
let res: string = st.loadGroup(getInstance).render(templateName, data); // res is the final text that combines templates and data.
```

## Available APIs

| API               | Parameter                                                | Parameter Description                                                                               | Return Value                        | API Description                                               |
|------------------|----------------------------------------------------------|-----------------------------------------------------------------------------------------------------|-------------------------------------|---------------------------------------------------------------|
| Stc.compile      | path:string                                              | The absolute path of the file or folder that needs to be compiled.                                  | N/A                                 | Compile template files or folders.                            |
| ProcessTemplate.processTemplate  | getInstance:Function, data: object, templateName: string | getInstance: Compiled template functions, data: Fill in template data, templateName: Template Name. | String combining template and data. | Combine the last shift and data to generate the final string. |
| st.loadGroup                  | getInstance:Function  | getInstance：Compiled template functions. |  String combining template and data. | Combine the last shift and data to generate the final string. |

## Precautions
- The compilation file requires passing in the file completion path: * * file path * *+* * file name**

## Constraints
This project has been verified in the following version:

DevEco Studio: 5.0.1 Release, SDK: API Version 13 Release (5.0.1.115)

## Directory Structure
````
|----ohos_minizip  
|     |---- entry  # Sample Code Folder
|     |---- library  
|                |---- stringTemplate # stringTemplate-js code
|                      |---- bin
|                            |---- stcFile # The entrance logic code for compiling files
|                            |---- ststFile # The entrance logic code that combines templates and data
|                      |---- compile  # Compile the logical code of the file
|                      |---- lib # Logical code combining templates and data
|           |---- index.ets  # external interface
|     |---- README.md  # Installation and usage instructions
|     |---- README_zh.md  # Installation and usage instructions
````

## How to Contribute
Any problems found during use can be raised [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) Give us, of course, we also welcome you to send us [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [BSD-3-Clause License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/source_map_js/LICENSE).
    



