# jsDiff

## Introduction

This project is an OpenHarmony development example based on the [jsdiff](https://github.com/kpdecker/jsdiff) library, a JavaScript text differencing implementation.

## How to Install

```
ohpm install diff
ohpm install @types/diff --save-dev // Install @types/diff to prevent import syntax errors due to missing type declarations in the diff package.

```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```
  import { diffChars} from 'diff'


  const one = 'beep boop   It's a technology';
  const other = 'beepboob See how it works';
  const diff = diffChars(one, other);

  diff.forEach((part) => {
      if (part.added) {
        //do something
      } else if (part.removed) {
      //do something
      } else {
     //do something
      }
      let str = part.value; // Character or string to compare
  });
    
    // For details, see the index.ets file.
    
```

## part Object Properties
**value**: text content
**added**: **true** if the value was inserted into the new string.
**removed**: **true** if the value was removed from the old string.

## Available APIs

| Module                                                                                                                                     |                                                                                                                                                                                                                                                                                                                                                             | Description                                                                                                                                        | Remarks                                                                                                                                                           |
|--------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| diffChars(oldStr: string, newStr:  string[,  [options])                                                                                    | oldStr: Original string,<br/> newStr: New substring                                                                                                                                                                                                                                                                                                         | Distinguish between two text blocks Compare character by character                                                                                 | ignoreCase:true Ignore case differences. The default is false                                                                                                     |
| diffWords(oldStr: string, newStr:  string[,  [options])                                                                                    | oldStr: Original string,<br/> newStr: New substring                                                                                                                                                                                                                                                                                                         | Distinguish between two text blocks and compare them character by character Ignore Spaces                                                          | ignoreCase: The same as diffChars                                                                                                                                 |
| diffWordsWithSpace(oldStr: string, newStr:  string[,  [options])                                                                           | oldStr: Original string,<br/> newStr: new substring                                                                                                                                                                                                                                                                                                         | Distinguish the two text blocks and compare them word by word. Consider Spaces important                                                           | ignoreWhitespace:true ignore leading and trailing Spaces. This is related to diffTrimmedLines; newlineIsToken:true treats the newline character as a separate tag |
| diffLines(oldStr: string, newStr:  string[,  [options])                                                                                    | oldStr: Original string,<br/> newStr: New substring                                                                                                                                                                                                                                                                                                         | Distinguish between two text blocks Compare line by line                                                                                           |                                                                                                                                                                   |
| diffTrimmedLines(oldStr: string, newStr:  string[,  [options])                                                                             | oldStr: Original string,<br/> newStr: new substring                                                                                                                                                                                                                                                                                                         | Distinguish the two text blocks and compare them line by line. Ignore the leading and trailing Spaces                                              |
| diffSentences(oldStr: string, newStr:  string[,  [options])                                                                                | oldStr: Original string,<br/> newStr: new substring                                                                                                                                                                                                                                                                                                         | Distinguish between two text blocks Compare sentence by sentence                                                                                   |
| diffCss(oldStr: string, newStr:  string[,  [options])                                                                                      | oldStr: Original string,<br/> newStr: New substring                                                                                                                                                                                                                                                                                                         | Distinguish between two text blocks Compare the CSS tag                                                                                            |
| diffJson(oldObj: object, newObj:  object[,  [options])                                                                                     | oldObj: Original object,<br/> newObj: New Object                                                                                                                                                                                                                                                                                                            | Compare two JSON objects Compare the field                                                                                                         | defined on each object                                                                                                                                            
| diffArrays(oldArr: array, newArr:  array[,  [options])                                                                                     | oldStr: Original array,<br/> newArr: New Array                                                                                                                                                                                                                                                                                                              | Distinguish between two arrays Compare whether each item is strictly equal (===)                                                                   |
| createPatch(fileName: string,oldStr: string,newStr: string,oldHeader? : string,newHeader? : string,options? (PatchOptions): string         | fileName: The string will be output in the file name section <br/>oldStr: The original string value <br/>newStr: The new string value <br/>oldHeader: Additional information, including in the old file header. <br/>newHeader: Additional information, including in the new file header.                                                                   | The file and content information used to generate patches, configuration items can include context (the number of lines of context), etc           
| createTwoFilesPatch(fileName: string,oldStr: string,newStr: string,oldHeader? : string,newHeader? : string,options? (PatchOptions): string | fileName: The string will be output in the file name section <br/>oldStr: The original string value <br/>newStr: The new string value <br/>oldHeader: Additional information, including in the old file header. <br/>newHeader: Additional information, including in the new file header.                                                                   | The file and content information used to generate patches, configuration items can include context (the number of lines of context), etc           
| structuredPatch(fileName: string,oldStr: string,newStr: string,oldHeader? : string,newHeader? : string,options? (PatchOptions): string     | fileName: The string will be output in the file name section <br/>oldStr: The original string value <br/>newStr: The new string value <br/>oldHeader: Additional information, including in the old file header. <br/>newHeader: Additional information, including in the new file header.                                                                   | The file and content information used to generate patches, configuration items can include context (the number of lines of context), etc           
| parsePatch(diffStr: string, options? : { strict? : boolean undefined }):  ParsedDiff[];                                                    | diffStr: Differential string <br/>strict: whether strict Parse the patch into structured data.                                                                                                                                                                                                                                                              | Return the JSON object representation of the patch, which is suitable for use with the 'applyPatch()' method.                                      |
| convertChangesToXML(changes: Change[]):  string;                                                                                           | changes: Change the list                                                                                                                                                                                                                                                                                                                                    | Convert the change list to serialized XML format.                                                                                                  |
| canonicalize(obj: any, stack: any[], replacementStack: any[]):  any                                                                        | obj: The original object that needs to be normalized <br/> stack: Used to track the objects that have been accessed during the recursive process Prevent stack overflow caused by circular references <br/>replacementStack: Corresponding to stack, it stores normalized objects and is used to replace the original objects in circular references. <br/> | Used for deeply complex objects                                                                                                                    |
| merge(mine: string, theirs: string, base: string):  ParsedDiff;                                                                            | mine: Your version <br/> theirs: The other version <br/> base: Common base version That is, a final result                                                                                                                                                                                                                                                  | is automatically combined based on two different versions of the modification (mine and theirs) and their common base version (base)               
| applyPatch(source: string,patch: string ParsedDiff [ParsedDiff],options? : ApplyPatchOptions):  string  false                              | source: Original text content <br/> uniDiff: Patch text in the Unified Diff format, usually generated by the createPatch method. <br/>options: Optional Configuration Object                                                                                                                                                                                | The applyPatch method in the jsdiff library is used to apply patches in the Unified Diff format to the original text to generate the updated text. |
| applyPatches(patch: string ParsedDiff[], options: ApplyPatchesOptions):  void                                                              | patch: An array consisting of a single patch string or multiple patch strings. <br/> options: Apply Patch Options                                                                                                                                                                                                                                           | Apply one or more patches                                                                                                                          |

For more details, see [Official Documentation](https://github.com/kpdecker/jsdiff/blob/master/README.md) and [Unit Test Cases](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/jsDiffDemo/TEST.md).

## Constraints
This project has been verified in the following version:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio: 4.0 Release (4.0.3.600), SDK: API 10 (4.0.10.11)
- DevEco Studio: 4.0 Beta2 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## How to Contribute

If you find any problem during the use, submit an issue or a PR to us.

## License

This project is licensed under [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/jsDiffDemo/LICENSE).
