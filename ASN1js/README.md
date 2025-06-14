# ASN1js

## Introduction

> Syntax Notation One (ASN.1) is a standard and symbol that describes the rules and structures for data representation, encoding, transmission, and decoding on telecommunications and computer networks.
> [ASN1js](https://github.com/PeculiarVentures/ASN1.js) is a pure JavaScript library that implements this standard. ASN.1 is the basis for all X.509-related data structures and many other protocols used on the network.

## How to Install

```shell
ohpm  install @fortanix/asn1js@1.52.0
```

For details, see [Installing an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


```
//region How to create new ASN. structures 
    var sequence = new asn1js.Sequence();
    sequence.valueBlock.value.push(new asn1js.Integer({ value: 1 }));

    var sequence_buffer = sequence.toBER(false); // Encode current sequence to BER (in ArrayBuffer)
    var current_size = sequence_buffer.byteLength;

    var integer_data = new ArrayBuffer(8);
    var integer_view = new Uint8Array(integer_data);
    integer_view[0] = 0x01;
    integer_view[1] = 0x01;
    integer_view[2] = 0x01;
    integer_view[3] = 0x01;
    integer_view[4] = 0x01;
    integer_view[5] = 0x01;
    integer_view[6] = 0x01;
    integer_view[7] = 0x01;

    sequence.valueBlock.value.push(new asn1js.Integer({
        isHexOnly: true,
        valueHex: integer_data
    })); // Put too long for decoding Integer value

    sequence_buffer = sequence.toBER(false);
    current_size = sequence_buffer.byteLength;
    //endregion 
```

```
    //region How to create new ASN.1 structures by calling constuctors with parameters 
    var sequence2 = new asn1js.Sequence({
        value: [
            new asn1js.Integer({ value: 1 }),
            new asn1js.Integer({
                isHexOnly: true,
                valueHex: integer_data
            }),
        ]
    });
    //endregion 
```

```
    //region How to validate ASN.1 against pre-defined schema 
    var asn1_schema = new asn1js.Sequence({
        name: "block1",
        value: [
            new asn1js.Null({
                name: "block2"
            }),
            new asn1js.Integer({
                name: "block3",
                optional: true // This block is absent inside data, but it's "optional". Hence verification against the schema will be passed.
            })
        ]
    });
    //endregion

    var variant1 = org.pkijs.verifySchema(encoded_sequence, asn1_schema); // Verify schema together with decoding of raw data
    var variant1_verified = variant1.verified;
    var variant1_result = variant1.result; // Verified decoded data with all block names inside
```

```
    //region How to use "internal schemas" for primitevely encoded data types 
    var primitive_octetstring = new asn1js.OctetString({ valueHex: encoded_sequence }); // Create a primitively encoded OctetString where internal data is an encoded Sequence

    var asn1_schema_internal = new asn1js.OctetString({
        name: "outer_block",
        primitiveSchema: new asn1js.Sequence({
            name: "block1",
            value: [
                    new asn1js.Null({
                        name: "block2"
                    })
            ]
        })
    });

    var variant6 = org.pkijs.compareSchema(primitive_octetstring, primitive_octetstring, asn1_schema_internal);
    var variant6_verified = variant4.verified;
    var variant6_block1_tag_num = variant6.result.block1.idBlock.tagNumber;
    var variant6_block2_tag_num = variant6.result.block2.idBlock.tagNumber;
    //endregion 

```

## Available APIs

| API|                                  Parameter                                  |
|:---:|:---------------------------------------------------------------------:|
|  BaseBlock   | parameters: object, primitiveSchema:object, name:string, optional:boolean|
|  OctetString   |                           parameters:object                           |
|  toJSON   |                                   N/A                                  |
|  toBER   |                           sizeOnly:boolean                            |
|  Integer   |                           parameters:object                           |
|  GeneralizedTime   |            parameters:object ,value:string,valueDate:Data             |
|  ObjectIdentifier   |                parameters:object,valueHex:ArrayBuffer                 |

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure

````
|---- ASN1js
|     |---- entry  # Sample code
              ├── src  
                 ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README_EN.md  # Readme                   
````

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under [BSD-3-Clause License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ASN1js/LICENSE).
Welcome to enjoy and participate in the open source.
    
