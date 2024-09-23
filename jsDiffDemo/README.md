# jsDiff

## Introduction

This project is an OpenHarmony development example based on the [jsdiff](https://github.com/kpdecker/jsdiff) library, a JavaScript text differencing implementation.

## How to Install

```
ohpm install diff
ohpm install @types/diff --save-dev // Install @types/diff to prevent import syntax errors due to missing type declarations in the diff package.

```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

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
| Module                                       | Description                                        | Remarks                                                        |
| --------------------------------------------- | -------------------------------------------- | ------------------------------------------------------------ |
| diffChars(oldStr, newStr[, options])          | Diffs two blocks of text, comparing character by character.            | **ignoreCase**: The value **true** means to ignore casing difference. The default value is **false**.                  |
| diffWords(oldStr, newStr[, options])          | Diffs two blocks of text, comparing word by word, ignoring whitespace.          | **ignoreCase**: same as in **diffChars**.                                   |
| diffWordsWithSpace(oldStr, newStr[, options]) | Diffs two blocks of text, comparing word by word, treating whitespace as significant.    | **ignoreWhitespace**: The value **true** means to ignore leading and trailing whitespace. This is the same as **diffTrimmedLines**.<br>**newlineIsToken**: The value **true** means to treat newline characters as separate tokens.|
| diffLines(oldStr, newStr[, options])          | Diffs two blocks of text, comparing line by line.                    |                                                              |
| diffTrimmedLines(oldStr, newStr[, options])   | Diffs two blocks of text, comparing line by line, ignoring leading and trailing whitespace.|                                                              |
| diffSentences(oldStr, newStr[, options])      | Diffs two blocks of text, comparing sentence by sentence.                    |                                                              |
| diffCss(oldStr, newStr[, options])            | Diffs two blocks of text, comparing CSS tokens.               |                                                              |
| diffJson(oldObj, newObj[, options])           | Diffs two JSON objects, comparing the fields defined on each.|                                                              |
| diffArrays(oldArr, newArr[, options])         | Diffs two arrays, comparing each item for strict equality (===).|                                                              |

For more details, see [Official Documentation](https://github.com/kpdecker/jsdiff/blob/master/README.md) and [Unit Test Cases](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/jsDiffDemo/TEST.md).

## Constraints
This project has been verified in the following version:

- DevEco Studio: 4.0 Release (4.0.3.600), SDK: API 10 (4.0.10.11)
- DevEco Studio: 4.0 Beta2 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## How to Contribute

If you find any problem during the use, submit an issue or a PR to us.

## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/jsDiffDemo/LICENSE).
