# json-bigint
# Introduction
json-bigint allows parsing and stringifying JSON with BigInts, based on JSON.js and bignumber.js.
# How to Install
    ohpm install json-bigint
    ohpm install @types/json-bigint --save-dev // A syntax error is reported for the import json-bigint instruction if the json-bigint package does not contain the type declaration. You need to download the declaration file of the package using @types/json-bigint to rectify the syntax error.
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
# How to Use
After json-bigint is installed, import json-bigint on the target page and call it.

    import  jsonBigint from 'json-bigint'
    let bigint = jsonBigint()
## Simple Usage
    @State input:string = '{"bigValue":9223372036854775807,"SmallValue":123}'; // No data to be tested.
    let parseValue:Record<string, string > = bigint.parse(this.input)
    console.log(`JSON.parse : ${ typeof parseValue.bigValue }`)// JSON.parse :9223372036854775807
    let stringifyValue:string = bigint.stringify(parseValue)
    console.log(`JSONbig.stringify(JSONbig.parse(input)):${stringifyValue}`)// JSONbig.stringify(JSONbig.parse(input)):{"big":9223372036854775807,"small":123}
## Enabling Strict Mode

    @State strictInput:string = '{ "dupkey": "value 1", "dupkey": "value 2"}'; // Data to be tested in strict mode.
    let bigint = jsonBigint({strict:true})
    try {
            this.failsInput= bigint.parse(this.strictInput);
            console.log('ERROR!! Should never get here');
        } catch (e) {
            console.log('Succesfully catched expected exception on duplicate keys: %j',JSON.stringify(e))// Succesfully catched expected exception on duplicate keys: {"name":"SyntaxError","message":"Duplicate key \"dupkey\"","at":33,"text":"{ \"dupkey\": \"value 1\", \"dupkey\": \"value 2\"}"}
        }
Use `strict: true` in the call of json_bigint to specify the strict mode, in which errors are reported for duplicate keys.
## Converting a BigInt to a String

     @State storeAsStringInput:string = '{ "key": 1234567890123456789 }' // Data to be tested during the conversion from a BigInt to a string.
    let bigint = jsonBigint({ storeAsString: true })
    let  withString:Record<string, string > = bigint.parse(this.storeAsStringInput);
            console.log(`${withString.key}`)//1234567890123456789
            console.log(`Default type: %s, With option type: %s, ${typeof withString.key}`);// Default type: object, With option type: string
            })
Use `storeAsString: true` in the call of json_bigint to specify whether a BigInt should be stored in an object as a string instead of the default big number. Note that this action is risky because it results in the failure of reverting the conversion without altering the data type, (because this action converts all BigInts to the preceding and succeeding string representations).
## Enabling Native BigInts
    @State useNativeBigIntInput:string = '{ "key": 993143214321423154315154321 }' // Data to be tested when the local BigInts are used.
    let bigint = jsonBigint({ useNativeBigInt: true } )
    let  JSONbigNative:Record<string, string > = bigint.parse(this.useNativeBigIntInput);
            console.log(`${JSONbigNative.key}`)
            console.log(
                `Default type: %s, With option type: %s, ${typeof JSONbigNative.key}`);// Default type: %s, With option type: %s, bigint
            })
Use `useNativeBigInt: true` in the call of json_bigint to specify whether the parser uses native BigInts instead of bignumber.js.

## Storing All Numbers as Big Numbers

    @State alwaysParseAsBigInput:string = '{ "key": 12312312312 }'// Store all numbers as big numbers.
    let bigint = jsonBigint({ alwaysParseAsBig: true } )
    let  JSONbigAlways:Record<string, string > = bigint.parse(this.alwaysParseAsBigInput);
            console.log(`${JSONbigAlways.key}`)
            console.log(
                `Default type: %s, With option type: %s, ${typeof JSONbigAlways.key}`);// Default type: %s, With option type: %s, object
            })
Use `alwaysParseAsBig: true` in the call of json_bigint to specify whether all numbers should be stored as big numbers.

# Available APIs
| API      | Parameter                                      | Return Value     | Description                                              |
| ------------ | ------------------------------------------ | ----------- | -------------------------------------------------- |
| jsonBigint() | `options`: optional                              | optionsType | Generates an object for conversion.                                      |
| parse()      | `value:string`: string to parse           | object      | Converts a JSON string into an object (that supports the BigInt data type).|
| stringify()  | `value:object`: JSON object to serialize| string      | Converts a JavaScript value into a JSON string (that supports the BigInt data type).        |
For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/json-bigintDemo/TEST.md).
### Parameter Description of `options`
| Parameter                  | Description                                                        |
| ---------------------- | ------------------------------------------------------------ |
| strict: true          | Specifies the strict mode for parsing. In this mode, errors are reported for duplicate keys.|
| storeAsString: true   | Specifies whether a BigInt should be stored as a string in an object instead of the default big number. Note that this action is risky because it results in the failure of reverting the conversion without altering the data type, (because this action converts all BigInts to the preceding and succeeding string representations).|
| useNaiveBigint:true    | Specifies whether the parser uses native BigInts instead of bignumber.js.            |
| alwaysParseAsBig: true | Specifies whether to store all numbers as big numbers.                           |

# Constraints
- DevEco Studio: NEXT Release(5.0.3.900), SDK: API12 (5.0.0.71)
- DevEco Studio: NEXT Developer Beta3(5.0.3.524), SDK: API12 (5.0.0.25)
- DevEco Studio: 4.0 (4.1.3.313), SDK: API 10 (4.0.10.10)

# Directory Structure
    |---- json-bigint  
    |     |---- entry  # Sample code
    |     	|---- pages # Application pages, divided based on the features of json-bigint
    |           |---- index.ets  # Used to test the features of json-bigint                  
    |     |---- README.md  # Readme
    |     |---- README_zh.md  # Readme 

# How to Contribute
If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

# License
This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/json-bigint/LICENSE).
