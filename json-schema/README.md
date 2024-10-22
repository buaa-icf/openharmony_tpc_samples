# jsonschema

## Introduction
jsonschema is a lightweight and easy-to-use JSON schema validator that fully supports JSON Schema versions through draft-07.

## How to Install
```shell
ohpm install @ohos/jsonschema 
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
After jsonschema is installed, import jsonschema on the target page and initialize it.

 ```typescript
import { Validator, ValidatorResult, ValidationError, SchemaError, validate } from '@ohos/jsonschema'
let v = new Validator();
 ```

### Performing Simple Object Validation

```typescript
  let instance = 4;
  let schema = { "type": "number" }; // Define the schema.
  let result = v.validate(instance, schema).valid; // Start validation and obtain the result.
```

This function converts the provided path into a regular expression and returns a **RegExp** object that contains information related to the regular expression for validation or path concatenation and conversion.

### Performing Complex Validation with Custom Rules and Schema References

```typescript
      // Address, to be embedded on Person
 let addressSchema = {
        "id": "/SimpleAddress",
        "type": "object",
        "properties": {
          "lines": {
            "type": "array",
            "items": {"type": "string"}
          },
          "zip": {"type": "string"},
          "city": {"type": "string"},
          "country": {"type": "string"}
        },
        "required": ["country"]
  };

  // Person
  let schema = {
        "id": "/SimplePerson",
        "type": "object",
        "properties": {
          "name": {"type": "string"},
          "address": {"$ref": "/SimpleAddress"},
          "votes": {"type": "integer", "minimum": 1}
        }
   };

  let p = {
        "name": "Barack Obama",
        "address": {
          "lines": [ "1600 Pennsylvania Avenue Northwest" ],
          "zip": "DC 20500",
          "city": "Washington",
          "country": "USA"
        },
        "votes": "lots"
   };

  v.addSchema(addressSchema, '/SimpleAddress');

  let result = v.validate(p, schema).valid;
```

### Setting Custom Formats

```typescript
// Add a custom format.
Validator.prototype.customFormats.myFormat = function (input) {
  return input === 'myFormat';
};

let v1 = new Validator();

// Validate format name myFormat. The result is true.
let result1 = v1.validate('myFormat', { type: 'string', format: 'myFormat' }).valid;
// Validate format name foo. The result is false.
let result2 = v1.validate('foo', { type: 'string', format: 'myFormat' }).valid;
```

The **Validator.prototype.customFormats** settings only affect the specific validator instance to which they are applied, so you can create multiple validator instances to handle various formats in different schemas throughout your application.

### Using Nested Errors

```typescript
   let schema = {
     oneOf: [
       { type: 'string', minLength: 32, maxLength: 32 },
       { type: 'string', maxLength: 16 },
       { type: 'number' },
     ]
   };
 let result = v.validate('This string is 28 chars long', schema, { nestedErrors: true });
// The value of result.toString() is as follows:
// 0: instance does not meet minimum length of 32
// 1: instance does not meet maximum length of 16
// 2: instance is not of a type(s) number
// 3: instance is not exactly one from [subschema 0],[subschema 1],[subschema 2]
```

When multiple validation items are set and **nestedErrors** is set to **true**, the result contains detailed error information for each validation item that fails. The validation process does not terminate after the first failed check, allowing it to capture and report on all validation errors.

### Setting Custom Keywords

```typescript
v.attributes.contains = function validateContains(instance, schema, options, ctx) {
  if(typeof instance !== 'string') return;
  // @ts-ignore Check the type of the custom keyword.
  if(typeof schema.contains !== 'string'){
     throw new SchemaError('"contains" expects a string', schema);
  }
  // @ts-ignore Check whether the instance contains the custom keyword.
  if(instance.indexOf(schema.contains)<0){
     // @ts-ignore
     return 'does not contain the string ' + JSON.stringify(schema.contains);
   }
   // @ts-ignore Check the length of the custom keyword.
   if (schema.contains.length < 2) {
     return '"contains" length must more than 2 ' ;
   }
}

// @ts-ignore
let result = v.validate("I am an instance", { type:"string", contains: "I am" }).valid;
```

You can set a custom keyword (for example, **I am**) using **contains** in the configuration and define validation rules (or example, **function validateContains()**) for that keyword.

### Removing Validation Rules

Initialize data.

```typescript
  schemaArr: object[] = [
    {
      "type": "number"
    },
    {
      "id": "/simplePerson",
      "type": "object",
      "properties": {
        "name": { "type": "string" },
        "address": { "$ref": "/SimpleAddress" },
        "votes": { "type": "integer", "minimum": 1 }
      }
    },
    {
      "type": "array",
      "items": {
        "properties": {
          "name": { "type": "string" },
          "lastname": { "type": "string" }
        },
        "required": ["name", "lastname"]
      }
    },
  ]
  @State cacheSchemaNum: number = 0;
  @State isFinish: boolean = false;
```

Start to add or remove rules.

```typescript
  let initSchema = {
        "id": "/SimplePerson",
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "address": { "$ref": "/SimpleAddress" },
          "votes": { "type": "integer", "minimum": 1 }
        }
      }
  v.addSchema(initSchema); // Add an initialization schema.
  this.importNextSchema(v); // Initiate the recursive method to start removing or adding validation rules.
  let result = this.cacheSchemaNum > = 0; // Detect whether the removal and addition process is executed by monitoring the change in cacheSchemaNum.
```

```typescript
  importNextSchema(v: Validator) {
    let nextSchema = v.unresolvedRefs.shift(); // Remove the validation rule.
    if (this.cacheSchemaNum >= this.schemaArr.length) {
      this.isFinish = true;
      return
    }
    if (!nextSchema) {
      this.isFinish = true;
      return;
    }
    console.log ('nextSchema: ${JSON.stringify(nextSchema) }') // Print the removed validation rule.
    v.addSchema(this.schemaArr[this.cacheSchemaNum]); // Continue to add the next validation rule.
    this.cacheSchemaNum++;
    this.importNextSchema(v); // Recursively call this method to keep removing and adding validation rules.
  }
```

By using **Validator.unresolvedRefs.shift()**, you can remove certain rules set for the validator, and then add different rules. In this way, you can create a diverse set of validation rules with a single validator for complex validation scenarios.

### Preprocessing Attributes

Preprocess the attribute values to be validated before the actual validation, including null checks and type conversions.

```typescript
preValidate(object, key, schema, options, ctx) {
  let value = object[key];
  if (typeof value === 'undefined') return;
    // Test if the schema declares a type, but the type keyword fails validation
  if (schema.type
    && v1.attributes.type.call(v1, value, schema, options, ctx.makeChild(schema, key))) {
      // If the type is "number" but the instance is not a number, cast it
      if (schema.type === 'number' && typeof value !== 'number') {
        object[key] = parseFloat(value);
        return;
      }
      // If the type is "string" but the instance is not a string, cast it
      if (schema.type === 'string' && typeof value !== 'string') {
        object[key] = String(value).toString();
        return;
      }
   }
};
```

Set validation rules and start the validation process.

```typescript
 const schema = { 
     'properties': {
        'name': { 'type': 'string' },
        'quantity': { 'type': 'number' }
      } 
 };
 const instance = {
   name: 123,
   quantity: '2'
 }
 let v0 = new Validator();
 let v1 = new Validator();
// No attribute preprocessing
 let result0 = v0.validate(instance, schema).valid;
// Attribute preprocessing
 let result1 = v1.validate(instance, schema, { preValidateProperty: this.preValidate }).valid;
```

Preprocessing certain attributes can simplify the validation rules and improve the validation success rate.

### Skipping Keyword Validation

```typescript
let schema = {
   "id": "/SimplePerson",
   "type": "object",
   "properties": {
     "name": { "type": "string" },
     "sex": { "type": "number", "minimum": 50 },
     "votes": { "type": "integer", "minimum": 1 }
   }
};

 let p = {
   "name": "Zhang San",
   "sex": 45,
   "votes": 22
 };
 let v0 = new Validator();
 let result0 = v0.validate(p, schema, { skipAttributes: ["minimum"] }).valid;
```

Using the **skipAttributes** option to skip the validation for certain keywords can prevent validation failures caused by unnecessary rules in imported template validation schemas. For example, if the template specifies a minimum age of 50, but your project does not impose such a limit, you can skip the minimum value validation for the **age** attribute.

### Allowing Failures for Unknown Keywords

```typescript
let v0 = new Validator();
let schema = {
  type: "string",
  format: "email",
  example: "foo",
};
let result0 = v0.validate("Name", schema, { allowUnknownAttributes: true }).valid;
let v1 = new Validator();
let result1 = v1.validate("Name", schema, { allowUnknownAttributes: false });
// result0  false
// result1  throw err
```

By default, jsonschema ignores unknown schema keywords, and validation failures return a **false** result without throwing an error. To handle validation failures as exceptions, set **allowUnknownAttributes** to **false** to interrupt the validation process and respond to the error messages accordingly.

## Available APIs

| API                    | Parameter                                                        | Return Value                 | Description                               |
| -------------------------- | ------------------------------------------------------------ | ----------------------- | ----------------------------------- |
| new Validator()            | N/A                                                        | Validator               | Creates a validator object.                     |
| Validator.validate()       | instance: any,<br>schema: Schema,<br>options?: Options,<br>ctx?: SchemaContext | ValidatorResult         | Validates a schema.                         |
| Validator.addSchema()      | schema?: Schema,<br>uri?: string                            | Schema\|void            | Adds a schema to the validator.                 |
| validate()                 | instance: any,<br> schema: any,<br>options?: Options       | ValidatorResult         | Validates a schema.                         |
| rewrite()                  | instance: any,<br> schema: Schema, <br>options: Options,<br> ctx: SchemaContext | any                     | Alters the instance value after successful validation.       |
| preValidateProperty()      | instance: any, <br>key: string, <br>schema: Schema, <br>options: Options, <br>ctx: SchemaContext | any                     | Processes this property before validation.   |
| customFormats()            | input: any                                                   | boolean                 | Adds custom formats.           |
| attributes()               | instance: any, schema: Schema, options: Options, ctx: SchemaContext | string\|ValidatorResult | Specifies validation keywords.                         |
| ValidatorResult.addError() | detail: string\|ErrorDetail                                  | ValidationError         | Adds error information to this **ValidatorResult** object.|
| ValidatorResult.toString() | N/A                                                        | string                  | Converts this **ValidatorResult** object to a string.    |
| ValidationError.toString() | N/A                                                        | string                  | Converts this **ValidationError** object to a string.    |
| shift()                    | N/A                                                        | T \| undefined          | Removes and returns the added validation rule.           |

For more information, see [jsonschema](https://github.com/tdegrunt/jsonschema/blob/master/README.md) and [Unit Test Cases](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/json-schema/TEST.md).

## Constraints
This project has been verified in the following versions:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API 12 Release (5.0.0.66)
- DevEco Studio: 4.0 (4.0.3.513), SDK: API 10 (4.0.10.10)


## Directory Structure
````
|---- json-schema  
|     |---- entry                  # Sample code
|     	|---- pages                # Application pages, divided based on the features of json-schema
|       |---- AllFuntionString.ts  # Strings for display on the UI
|       |---- JumpPathConfig.ts    # Page redirection configuration, which is used to display list data on the homepage and obtain redirection parameters
|          
|     |---- README.md              # Readme                   
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License
This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/json-schema/LICENSE).
