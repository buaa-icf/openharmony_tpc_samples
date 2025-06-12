# pvutils


## Introduction
This project demonstrates the use of pvutils in OpenHarmony. pvutils provides a set of common utility functions used in a variety of Peculiar Ventures JavaScript-based projects.


## How to Install

```shell
ohpm install pvutils
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
```
    // Import pvutils.
    import { toBase64 } from 'pvutils'
    Button("Encode a string into the Base64 format.")
    .onClick((event: ClickEvent) => {
    // aGVsbG8gQkFTRTY0
        this.message = toBase64('hello BASE64');
        console.log("Encode a string into the Base64 format' hello BASE64': "+ this.message)
    }).margin(5)
```
For details about how to use more APIs, see **Index.ets**.

## Available APIs

| API             | Parameter                                                   | Description                               |
| --------------------- | ------------------------------------------------------- | --------------------------------------- |
| getUTCDate()          | date                                                    | Converts the local time to the UTC.|
| getParametersValue()  | parameters, name, defaultValue                          | Obtains the values of specified properties.                         |
| bufferToHexCodes()    | inputBuffer, inputOffset?, inputLength?, insertSpace?   | Convert an ArrayBuffer into a hexadecimal string.              |
| checkBufferParams()   | baseBlock, inputBuffer, inputOffset, inputLength        | Checks the validity of buffer parameters.                   |
| utilFromBase()        | inputBuffer, inputBase                                  | Converts a number from 2^base to 2^10.                     |
| utilToBase()          | value, base, reserved?                                  | Converts a number from 2^10 to 2^base.                     |
| utilConcatBuf()       | ...buffers                                              | Concatenates two ArrayBuffers.                       |
| utilConcatView()      | ...views                                                | Concatenates two Uint8Arrays.                        |
| utilDecodeTC()        | N/A                                                     | Decodes a two's complement.                               |
| utilEncodeTC()        | value                                                   | Converts an integer to a two's complement.                           |
| isEqualBuffer()       | inputBuffer1, inputBuffer2                              | Checks whether two ArrayBuffers are equal.                    |
| padNumber()           | inputNumber, fullLength                                 | Adds leading zeros before a number.                     |
| toBase64()            | input, useUrlTemplate?, skipPadding?, skipLeadingZeros? | Converts a string to the Base64 format.                    |
| fromBase64()          | input, useUrlTemplate?, cutTailZeros?                   | Decodes a Base64 string into a common string.         |
| arrayBufferToString() | buffer                                                  | Converts an ArrayBuffer to a string.                 |
| stringToArrayBuffer() | str                                                     | Converts a string to an ArrayBuffer.                 |
| nearestPowerOf2()     | length                                                  | Calculates the nearest power of 2.                    |
| clearProps()          | object, propsArray                                      | Deletes properties with specified names.                     |


## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/pvutils/LICENSE).
