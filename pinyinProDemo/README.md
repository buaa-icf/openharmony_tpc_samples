# pinyin-pro

## Introduction

This is an OpenHarmony pinyin-pro demo project.
pinyin-pro is a professional JavaScript library for converting Chinese to pinyin. It features accurate multi-tone recognition, lightweight size, excellent performance, and rich functions.

## How to Install

```shell
$ ohpm install pinyin-pro
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

This library supports multiple environments and modular specifications.

###  Import

```javascript
import { pinyin } from 'pinyin-pro';

pinyin ('Chinese pinyin'); // 'hàn yǔ pīn yīn'
```

## Example
Obtaining pinyin


```javascript
import { pinyin } from 'pinyin-pro';

// Obtain the pinyin of the string format.
pinyin ('Chinese pinyin'); // 'hàn yǔ pīn yīn'

// Obtain the pinyin of the array format.
pinyin ('Chinese pinyin', { type: 'array' }); // ["hàn", "yǔ", "pīn", "yīn"]

// Obtain the pinyin in the non-tone array format.
pinyin ('Chinese pinyin', { toneType: 'none' }); // "han yu pin yin"

// Obtain the pinyin in the non-tone array format.
pinyin ('Chinese pinyin', { toneType: 'none', type: 'array' }); // ["han", "yu", "pin", "yin"]

// The tone is displayed as an array.
pinyin ('Chinese pinyin', { toneType: 'num' }); // "han4 yu3 pin1 yin1"

// Automatically identify multi-tone characters.
pinyin ('asleep'); // "shuì zháo le"
```

Text and pinyin matching

```javascript
import { match } from 'pinyin-pro';

// The first letter matching is supported.
match ('Chinese pinyin', 'zwp'); // [0, 1, 2]

// Full spelling matching is supported.
match ('Chinese pinyin', 'zhongwenpin'); // [0, 1, 2]

// Mixed matching is supported.
match ('Chinese pinyin', 'zhongwp'); // [0, 1, 2]
```

Pinyin format conversion

```javascript
import { convert } from 'pinyin-pro';

// Convert an array to a symbol.
convert('pin1 yin1'); // 'pīn yīn'

// Convert a symbol to a number.
convert('pīn yīn', { format: 'symbolToNum' }); // 'pin1 yin1'

// Eliminate symbols.
convert('pīn yīn', { format: 'toneNone' }); // 'pin yin'
```

Obtaining an HTML string containing Chinese pinyin

```javascript
import { html } from 'pinyin-pro';

// HTML string with Chinese pinyin
html ('Chinese pinyin');
/*
<span class="py-result-item">
<ruby>
    <span class="py-chinese-item">Han</span>;
    <rp>(</rp>
    <rt class="py-pinyin-item">hàn</rt>
    <rp>)</rp>
</ruby>
</span>
<span class="py-result-item">
<ruby>
    <span class="py-chinese-item">Yu</span>;
    <rp>(</rp>
    <rt class="py-pinyin-item">yǔ</rt>
    <rp>)</rp>
</ruby>
</span>
*/
```

For details about how to use pinyin-pro, see the official document [pinyin-pro](https://pinyin-pro.cn/guide/compare.html).

## Available APIs

| API                                                         | Description                         |
|-------------------------------------------------------------|-----------------------------|
| **pinyin(text: string, options?: OptionsReturnString)**     | Returns the converted information.            |
| **match(text: string, pinyin: string, options?: MatchOptions)**             | If the matching is successful, returns the subscript array corresponding to the matched Chinese character. If the matching fails, returns null.|
| **convert(pinyin: string, options?: ConvertOptions)**  | Converts the pinyin format and returns the pinyin after conversion.       |
| **customPinyin(map: object)**                               | You can customize the pinyin of words and sentences. When the user-defined pinyin is matched in the text, the user-defined pinyin is preferentially used.|
| **html(text: string, options?: OptionsReturnString)**       | Obtains the HTML string in the <ruby></ruby> format.     |
| **polyphonic(text: string, options?: OptionsReturnString)** | Obtains all pronunciation of a multi-tone character.|
 

## Constraints
This project has been verified in the following version:

DevEco Studio: DevEco Studio 4.0 Release(4.0.0.600), SDK: API10 (4.0.10.13)

## Directory Structure

```
 ├── entry
 │ └── src
 │ │ └── main
 │ │ │ ├── ets
 │ │ │ │  └── pages
 │ │ │ │  │ ├── index.ets        # Entry file
 │ │ │ ├── resources              # HAP resources
 │ │ │ └── module.json5            # HAP configuration file
```

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under the terms of the [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/pinyinProDemo/LICENSE).
