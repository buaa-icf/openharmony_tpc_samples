# js-sha256Demo

## Introduction
This project is an OpenHarmony development example based on the [js-sha256](https://github.com/emn178/js-sha256) library, which is a simple SHA-256/SHA-224 hash function for JavaScript that supports UTF-8 encoding.

## How to Install
```
ohpm install js-sha256
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use

```javascript
sha256('Message to hash');
sha224('Message to hash');

var hash = sha256.create();
hash.update('Message to hash');
hash.hex();

var hash2 = sha256.update('Message to hash');
hash2.update('Message2 to hash');
hash2.array();

// HMAC
sha256.hmac('key', 'Message to hash');
sha224.hmac('key', 'Message to hash');

var hash = sha256.hmac.create('key');
hash.update('Message to hash');
hash.hex();

var hash2 = sha256.hmac.update('key', 'Message to hash');
hash2.update('Message2 to hash');
hash2.array();
```

## Available APIs

| API                             | Parameter                               | Description                                                      |
|:--------------------------------|:----------------------------------------|:-----------------------------------------------------------------|
| sha256(data)                    | **data**: content                       | Computes the SHA-256 hash of the content.                        |
| sha224(data)                    | **data**: content                       | Computes the SHA-224 hash of the content.                        |
| sha256.hmac(secretKey, message) | **secretKey**: key **message**: content | HMAC interface                                                   |
| sha256.hex(data)                | **data**: content                       | Returns the SHA-256 hash of the content as a hexadecimal string. |
| sha256.digest(data)             | **data**: content                       | Returns the SHA-256 hash of the content as a digest.             |
| sha256.array(data)              | **data**: content                       | Returns the SHA-256 hash of the content as an array.             |
| sha256.arrayBuffer(data)        | **data**: content                       | Returns the SHA-256 hash of the content as an arrayBuffer.       |

## Constraints
This project has been verified in the following versions:
DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)
DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/tree/master/js-sha256Demo/LICENSE).

## How to Contribute

If you find any problem during the use, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
