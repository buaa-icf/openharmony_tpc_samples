## asn1Demo

## Overview 

This project is modified based on the open-source libraries asn1 and asn1-der to adapt to OpenHarmony. It helps you to build ASN.1 object models and implement JSON serialization/deserialization and DER serialization/deserialization. 

#### How to Install
| Library | Description | Installation                            |
|----|----|--------------------------------|
| asn1 | Builds ASN.1 object models and implements JSON serialization/deserialization. | ohpm install @ohos/asn1        |
| asn1-der | Implements DER serialization/deserialization (ASN.1) for ASN.1.| ohpm install @ohos/asn1-der    |
| asn1js | Implements ASN.1 BER encoding and decoding. | ohpm install @fortanix/asn1js  |
| base64 | Implements Base64 encoding and decoding. | ohpm install Base64            |
| hex-encode-decode | Implements Hex encoding and decoding. | ohpm install hex-encode-decode |

For details, see [Installing an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

#### asn1

```
import { JSONDeserializer, JSONSerializer, Universal } from '@ohos/asn1';
const { Bool, Integer, Null, PrintableString, Sequence } = Universal;
const sequence = new Sequence([
  new Integer(-Number.MAX_SAFE_INTEGER),
  new Integer(Number.MAX_SAFE_INTEGER),
  new Integer('424242424242424242424242424242424242'), // big integer
  new Null(),
  new Bool(true),
  new PrintableString('nice marmot'),
  new PrintableString('@#$%!&*()!_=&'),
]);
....

const serialize = new JSONSerializer();
const json = serialize(sequence);
....

const deserialize = new JSONDeserializer();
const asn1ObjectModel = deserialize(sequence);
   
```

#### asn1-der

```

import { DERSerializer, DERDeserializer } from '@ohos/asn1-der';

const serialize = new DERSerializer();
const asn1Sequence = new Universal.Sequence(
    new Universal.Integer(123),
    new Universal.PrintableString('Hello World'),
);

this.deserializeJsonTextDer = "Original abstract data for DER: "+ JSON.stringify (asn1Sequence);
const bufferContainingDEREncodedASN1 = serialize(asn1Sequence);
this.deserializeJsonTextDerS = "Serialized data for DER: "+ JSON.stringify (bufferContainingDEREncodedASN1);

const deserialize = new DERDeserializer();
const des = deserialize(bufferContainingDEREncodedASN1);
this.deserializeJsonTextDerD = "Deserialized data for DER: "+ JSON.stringify (des);

```

#### asn1js 
```
const testString = "My test Utf8String";
const asn = new asn1js.Utf8String({
  [value: testString,]([]())
});

const ber = asn.toBER();
const asnParsed = asn1js.fromBER(ber);

```
#### base64
```
import { btoa, atob } from 'Base64'
const data = btoa("ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz1234567890+/AA==!@#$%^&*()_-/][{}?:");
data= atob(data);

```

#### hex-encode-decode
```
import { encode, decode } from 'hex-encode-decode'
const deserializeJsonTextHex = encode("ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz1234567890+/AA==!@#$%^&*()_-/][{}?:");
const decodeData = decode(deserializeJsonTextHex);

```

## Available APIs
1. Serializes ASN.1 data.
```
 JSONSerializer
```
2. Deserializes data.
```
 JSONDeserializer
```
3. Constructs ASN.1 array data.
```
 Universal.Sequence
```
4. Constructs ASN.1 numeral data
```
 Universal.Integer
```
5. Constructs an empty ASN.1 object.
```
 Universal.Null
```
6. Constructs ASN.1 boolean data
```
 Universal.Bool
```
7. Deserializes ASN.1 string data.
```
 Universal.PrintableString
```
8. Deserializes ASN.1 boolean data.
```
 DERSerializer
```
9. Deserializes ASN.1 string data. 
```
 DERDeserializer
```

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the asn1 library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/asn1
./oh_modules/@ohos/asn1-der
```

## Constraints

asn1Demo has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## How to Contribute

If you find any problem when using asn1Demo, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/asn1Demo/LICENSE).
