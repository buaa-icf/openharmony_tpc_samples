# soundex-code

## Introduction

This project provides the Soundex phonetic algorithm capability in OpenHarmony.

## How to Install

```typescript
ohpm install soundex-code
```

## How to Use

```typescript
import {soundex} from 'soundex-code'

soundex('phonetics') // => 'P532'
soundex('Ashcraft') // => 'A261'
soundex('Lissajous') // => 'L222'
soundex('Smith') === soundex('Schmit') // => true

soundex('Ashcraftersson', 6) // => 'A26136'
soundex('A', 6) // => 'A000'
```

## Constraints
This project has been verified in the following versions:

- DevEco Studio: 4.0 Canary1 (4.0.3.212), SDK: API 10 (4.0.8.3)
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)


## Directory Structure

```
/entry/src/
- main/ets/     
    - pages                        # List of test pages
       - index.ets                    	# soundex-code test code
```

## How to Contribute

If you find any problem when using IMAP, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/soundex-code/LICENSE).
