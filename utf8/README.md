# utf8

## Introduction

This library provides the capability of encoding and decoding text in UTF-8 format. As a fully tested UTF-8 encoder/decoder written in JavaScript, it can represent any character in the Unicode standard.

## How to Install

```shell
ohpm install utf8
ohpm install @types/utf8@3.0.3 --save-dev // Install @types/utf8@3.0.3 to prevent import syntax errors due to missing type declarations in the utf8 package.
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use

### Encoding and Decoding in UTF-8

```typescript
import utf8 from "utf8";
import promptAction from '@ohos.promptAction';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Button ("Encode (encode)").onClick(() ==> {
          this.showMessage(utf8.encode('\xA9'));
          this.showMessage(utf8.encode('\uD800\uDC01'));
        })
        Button ("Decode (decoded)").onClick(() ==> {
          this.showMessage(utf8.decode('\xC2\xA9'));
          this.showMessage(utf8.decode('\xF0\x90\x80\x81'));
        })
      }
.width('100%')
}
.height('100%')
}

showMessage(message:string){
  promptAction.showToast({message})
}
}
```

## Available APIs
| API     | Type         | Description   |
|----------|------------|--------------|
| encode() | inputString: string | Encodes data  |
| decode() | byteString: string | Decodes data    |



## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.0 Canary2 (4.0.1.300); SDK: API10(4.0.9.6)


## Directory Structure

```

/entry/src/
- main/ets/     
    - pages                        # List of test pages
       - Index.ets                    	# Code for encoding/decoding text in UTF-8 format.
```

For details about unit test cases, see [TEST.md](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/utf8/TEST.md).

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

The project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/utf8/LICENSE-MIT).

