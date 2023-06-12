/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { SchemaError, validate, ValidationError, Validator, ValidatorResult } from '@ohos/jsonschema'

const BASE_COUNT = 1
Validator.prototype.customFormats.myFormat = function (input) {
  return input === 'myFormat';
};

export default function jsonSChemaTest() {
  describe('JsonSChemaValidateTest', function () {
    beforeAll(function () {
    })
    beforeEach(function () {
    })
    afterEach(function () {
    })
    afterAll(function () {
    })
    it('SimpleValidate', 0, function () {
      let startTime1 = new Date().getTime();
      var v = new Validator();
      var instance = 4;
      var schema = {
        "type": "number"
      };
      let result = v.validate(instance, schema);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : SimpleValidate averageTime : " + averageTime1 + "us")
      expect(result.valid).assertTrue();
    })
    it('VerySimpleValidate', 0, function () {
      let startTime1 = new Date().getTime();
      var v = new Validator();
      let result = v.validate(4, {
        "type": "number"
      });
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : SimpleValidate averageTime : " + averageTime1 + "us")
      expect(result.valid).assertTrue();
    })
    it('ComplicatedValidate', 0, function () {
      let startTime1 = new Date().getTime();
      var v = new Validator();
      var addressSchema = {
        "id": "/SimpleAddress",
        "type": "object",
        "properties": {
          "lines": {
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          "zip": {
            "type": "string"
          },
          "city": {
            "type": "string"
          },
          "country": {
            "type": "string"
          }
        },
        "required": ["country"]
      };
      // Person
      var schema = {
        "id": "/SimplePerson",
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "address": {
            "$ref": "/SimpleAddress"
          },
          "votes": {
            "type": "integer", "minimum": 1
          }
        }
      };
      var p = {
        "name": "Barack Obama",
        "address": {
          "lines": ["1600 Pennsylvania Avenue Northwest"],
          "zip": "DC 20500",
          "city": "Washington",
          "country": "USA"
        },
        "votes": "lots"
      };
      v.addSchema(addressSchema, '/SimpleAddress');
      let result = v.validate(p, schema);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : ComplicatedValidate averageTime : " + averageTime1 + "us")
      expect(result.valid).assertFalse();
    })

    it('AllValidate', 0, function () {
      let startTime1 = new Date().getTime();
      var schema = {
        "id": "/All",
        "type": "object",
        "properties": {
          "validateType1": {
            "type": "string"
          },
          "validateType2": {
            "type": ["boolean", "string"]
          },
          "validateType3": {
            "not": "string",
          },
          "validateType4": {
            "disallow": ["boolean", "string"]
          },
          "validateProperties": {
            "type": "object",
            "properties": {
              "a": {
                "type": "array"
              },
              "b": {
                "type": "integer"
              }
            }
          },
          "validatePatternProperties": {
            "type": "object",
            "patternProperties": {
              "^x1\\d*$": {
                "type": "array"
              },
              "^[a-z]+$": {
                "type": "integer"
              }
            }
          },
          "validateAdditionalProperties1": {
            "type": "object",
            "properties": {
              "a": {
                "type": "array"
              }
            },
            "patternProperties": {
              "[b-z]+": {
                "type": "integer"
              }
            },
            "additionalProperties": {
              "type": "boolean"
            }
          },
          "validateAdditionalProperties2": {
            "type": "object",
            "properties": {
              "a": {
                "type": "array"
              }
            },
            "patternProperties": {
              "[b-z]+": {
                "type": "integer"
              }
            },
            "additionalProperties": false
          },
          "validateNumberOfProperties": {
            "type": "object",
            "patternProperties": {
              "[a-z]+": {
                "type": "string"
              }
            },
            "minProperties": 1,
            "maxProperties": 2
          },
          "validateRequired": {
            "type": "any",
            "required": true
          },
          "validateRequiredProperties1": {
            "type": "object",
            "required": [
              "propA",
              "propB"
            ]
          },
          "validateRequiredProperties2": {
            "type": "object",
            "properties": {
              "propA": {
                "required": true
              },
              "propB": {
                "required": true
              }
            }
          },
          "validateItems": {
            "type": "array",
            "items": {
              "type": "string"
            }
          },
          "validateNumberOfItems": {
            "type": "array",
            "minItems": 1,
            "maxItems": 2
          },
          "validateUniqueItems": {
            "type": "array",
            "uniqueItems": true
          },
          "validateNumber": {
            "type": ["number"],
            "minimum": 0,
            "maximum": 10,
            "divisibleBy": 2.4,
            "multipleOf": 4.8
          },
          "validateInteger": {
            "type": ["integer"],
            "divisibleBy": 2,
            "multipleOf": 4
          },
          "validatePattern1": {
            "type": "string",
            "pattern": "str"
          },
          "validatePattern2": {
            "type": "string",
            "pattern": /str/
          },
          "validateFormat": {
            "type": "string",
            "format": "color"
          },
          "validateLength": {
            "type": "string",
            "minLength": 1,
            "maxLength": 2
          },
          "validateEnum": {
            "enum": [
              "value",
              {
                "x": 11
              }
            ]
          },
          "validateDependencies1": {
            "type": "object",
            "properties": {
              "a": {
                "type": "string",
              },
              "b": {
                "type": "boolean"
              }
            },
            "dependencies": {
              "a": "b"
            }
          },
          "validateDependencies2": {
            "type": "object",
            "properties": {
              "a": {
                "type": "string",
              },
              "b": {
                "type": "boolean"
              },
              "c": {
                "type": "number"
              }
            },
            "dependencies": {
              "a": ["b", "c"]
            }
          },
          "validateAnyOf": {
            "anyOf": [
              {
                "type": "boolean"
              },
              {
                "type": "string"
              }
            ]
          },
          "validateAllOf": {
            "allOf": [
              {
                "type": "boolean"
              },
              {
                "enum": [true]
              }
            ]
          },
          "validateOneOf": {
            "oneOf": [
              {
                "type": "boolean"
              },
              {
                "type": "integer"
              }
            ]
          },

          "validateReference": {
            "$ref": "/ReferencedSchema"
          }
        }
      };
      var referencedSchema = {
        "id": "/ReferencedSchema",
        "type": "string"
      };
      var all = {
        "validateType1": "a string",
        "validateType2": true,
        "validateType3": 6,
        "validateType4": 6,
        "validateProperties": {
          "a": [],
          "b": 6
        },
        "validatePatternProperties": {
          "x11": [],
          "abc": 5
        },
        "validateAdditionalProperties1": {
          "a": [],
          "bcd": 4,
          "11": true
        },
        "validateAdditionalProperties2": {
          "a": [],
          "bcd": 4
        },
        "validateNumberOfProperties": {
          "abc": "a string"
        },
        "validateRequired": 6,
        "validateRequiredProperties1": {
          "propA": 6,
          "propB": "a string"
        },
        "validateRequiredProperties2": {
          "propA": 6,
          "propB": "a string"
        },
        "validateItems": [
          "str-a",
          "str-b"
        ],
        "validateNumberOfItems": [
          "str-a"
        ],
        "validateUniqueItems": [
          "str-a",
          "str-b"
        ],
        "validateNumber": 9.6,
        "validateInteger": 8,
        "validatePattern1": "a string",
        "validatePattern2": "a string",
        "validateFormat": "blue",
        "validateLength": "a",
        "validateEnum": {
          "x": 11
        },
        "validateDependencies1": {
          "a": "a string",
          "b": true
        },
        "validateDependencies2": {
          "a": "a string",
          "b": true,
          "c": 8
        },
        "validateAnyOf": "a string",
        "validateAllOf": true,
        "validateOneOf": 6,
        "validateReference": "a string"
      };
      var v = new Validator();
      v.addSchema(referencedSchema, '/ReferencedSchema');
      // @ts-ignore
      let result = v.validate(all, schema);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : AllValidate averageTime : " + averageTime1 + "us")

      expect(result.valid).assertTrue();
    })

    it('UnDefinedValidate', 0, function () {
      let startTime1 = new Date().getTime();
      var v0 = new Validator();
      let result1 = v0.validate(undefined, {
        type: 'string'
      });
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : UnDefinedValidate averageTime : " + averageTime1 + "us")
      expect(result1.valid).assertTrue();
      let startTime2 = new Date().getTime();
      var v1 = new Validator();
      let result = v1.validate(undefined, {
        type: 'string'
      }, {
        required: true
      });
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("jsconschema : UnDefinedValidate averageTime : " + averageTime2 + "us")

      expect(result.valid).assertFalse();
    })
    it('FormatValidate', 0, function () {
      let startTime1 = new Date().getTime();
      var v1 = new Validator();
      let result1 = v1.validate('myFormat', {
        type: 'string', format: 'myFormat'
      });
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : FormatValidate averageTime : " + averageTime1 + "us")
      let startTime2 = new Date().getTime();
      var v2 = new Validator();
      let result2 = v2.validate('foo', {
        type: 'string', format: 'myFormat'
      });
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("jsconschema : FormatValidate averageTime : " + averageTime2 + "us")
      expect(result1.valid).assertTrue();
      expect(result2.valid).assertFalse();
    })
    it('NestedErrorsValidate', 0, function () {
      let startTime1 = new Date().getTime();
      var v = new Validator();
      var schema = {
        oneOf: [
          {
            type: 'string', minLength: 32, maxLength: 32
          },
          {
            type: 'string', maxLength: 16
          },
          {
            type: 'number'
          },
        ]
      };
      let result = v.validate('This string is 28 chars long', schema, {
        nestedErrors: true
      });
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : NestedErrorsValidate averageTime : " + averageTime1 + "us")
      expect(result.toString()).assertEqual(`0: instance does not meet minimum length of 32
1: instance does not meet maximum length of 16
2: instance is not of a type(s) number
3: instance is not exactly one from [subschema 0],[subschema 1],[subschema 2]
`);
    })

    it('LocalErrorMessage', 0, function () {
      let startTime1 = new Date().getTime();
      var v = new Validator();
      var schema = {
        oneOf: [
          {
            type: 'string', minLength: 32, maxLength: 32
          },
          {
            type: 'string', maxLength: 16
          },
          {
            type: 'number'
          },
        ]
      };
      let result = v.validate('This string is 28 chars long', schema, {
        nestedErrors: true
      });
      var localized = result.errors.map(function (err) {
        return err.name;
      });
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : LocalErrorMessage averageTime : " + averageTime1 + "us")
      expect(localized.toString()).assertEqual(`minLength,maxLength,type,oneOf`);
    })

    it('DiyKeyWordValidate', 0, function () {
      let startTime1 = new Date().getTime();
      var v = new Validator();
      v.attributes.contains = function validateContains(instance, schema, options, ctx) {
        if (typeof instance !== 'string') return;
        // @ts-ignore
        if (typeof schema.contains !== 'string') {
          throw new SchemaError('"contains" expects a string', schema);
        }
        // @ts-ignore
        if (instance.indexOf(schema.contains) < 0) {
          // @ts-ignore
          return 'does not contain the string ' + JSON.stringify(schema.contains);
        }
        // @ts-ignore
        if (schema.contains.length < 2) {
          return '"contains" length must more than 2 ';
        }
      }
      let result = v.validate("I am an instance", {
        // @ts-ignore
        type: "string", contains: "I am"
      });
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : DiyKeyWordValidate averageTime : " + averageTime1 + "us")
      expect(result.valid).assertTrue();
    })
    it('DiyAnotherValidate', 0, function () {
      let startTime1 = new Date().getTime();
      var v = new Validator();
      v.attributes.contains = function validateContains(instance, schema, options, ctx) {
        var result = new ValidatorResult(instance, schema, options, ctx);

        if (typeof instance !== 'string') {
          // @ts-ignore
          result.addError('fails some validation test')
        }


        if (typeof schema.contains !== 'string') {
          // @ts-ignore
          result.addError('fails some validation test')
        }


        if (instance.indexOf(schema.contains) > 0) {
          // @ts-ignore
          result.addError('fails some validation test')
        }


        if (schema.contains.length > 0) {
          // @ts-ignore
          result.addError('fails some validation test')
        }
        return result;
      }

      let resultValidate = v.validate("I am an instance", {
        // @ts-ignore
        type: "string", contains: "I am"
      });
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : DiyAnotherValidate averageTime : " + averageTime1 + "us")
      expect(resultValidate.valid).assertFalse();
    })

    it('DereferencingSchema', 0, function () {
      let startTime1 = new Date().getTime();
      var initSchema = {
        "id": "/SimplePerson",
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "address": {
            "$ref": "/SimpleAddress"
          },
          "votes": {
            "type": "integer", "minimum": 1
          }
        }
      }
      var v = new Validator();
      v.addSchema(initSchema)
      var schemaArr: object[] = [
        {
          "type": "number"
        },
        {
          "id": "/simplePerson",
          "type": "object",
          "properties": {
            "name": {
              "type": "string"
            },
            "address": {
              "$ref": "/SimpleAddress"
            },
            "votes": {
              "type": "integer", "minimum": 1
            }
          }
        },
        {
          "type": "array",
          "items": {
            "properties": {
              "name": {
                "type": "string"
              },
              "lastname": {
                "type": "string"
              }
            },
            "required": ["name", "lastname"]
          }
        },
      ]
      var cacheSchemaNum: number = 0;

      // @ts-ignore
      function importNextSchema(v: Validator) {
        var nextSchema = v.unresolvedRefs.shift();
        if (cacheSchemaNum >= schemaArr.length) {
          return
        }
        if (!nextSchema) {
          return;
        }
        console.log(`jsonschema ------> 被移除的规则：${JSON.stringify(nextSchema)}`)
        v.addSchema(schemaArr[cacheSchemaNum]);
        cacheSchemaNum++;
        importNextSchema(v);
      }

      importNextSchema(v)
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : DereferencingSchema averageTime : " + averageTime1 + "us")
      expect(cacheSchemaNum).assertLarger(0);
    })

    it('DefaultBaseUri', 0, function () {
      let startTime1 = new Date().getTime();
      var v = new Validator();
      let result = v.validate(["Name"], {
        id: "/schema.json",
        type: "array",
        items: {
          $ref: "http://example.com/schema.json#/definitions/item"
        },
        definitions: {
          item: {
            type: "string"
          },
        },
      }, {
        base: 'http://example.com/'
      });
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : DefaultBaseUri averageTime : " + averageTime1 + "us")
      expect(result.valid).assertTrue();
    })
    it('ReWrite', 0, function () {
      let startTime1 = new Date().getTime();

      function unmarshall(instance, schema) {
        if (schema.id === 'http://example.com/date') {
          return new Date(instance);
        }
        return instance;
      }

      const schema = {
        properties: {
          date: {
            id: 'http://example.com/date', type: 'string'
          },
        },
      };

      const value = {
        date: '2020-09-30T23:39:27.060Z',
      };

      var v1 = new Validator();
      let result = v1.validate(value, schema, {
        rewrite: unmarshall
      });
      let resultDate = result.instance.date instanceof Date;
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : ReWrite averageTime : " + averageTime1 + "us")
      expect(result.valid).assertTrue();
      expect(resultDate).assertTrue();
    })

    it('PrePropertyValidate', 0, function () {
      let startTime1 = new Date().getTime();
      const v0 = new Validator();

      function preValidate(object, key, schema, options, ctx) {
        var value = object[key];
        if (typeof value === 'undefined') return;

        // Test if the schema declares a type, but the type keyword fails validation
        if (schema.type && v0.attributes.type.call(v0, value, schema, options, ctx.makeChild(schema, key))) {
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
      const schema = {
        'properties': {
          'name': {
            'type': 'string'
          },
          'quantity': {
            'type': 'number'
          }
        }
      };
      const instance = {
        name: 123,
        quantity: '2'
      }
      let result = v0.validate(instance, schema, {
        preValidateProperty: preValidate
      });
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : PrePropertyValidate averageTime : " + averageTime1 + "us")
      expect(result.valid).assertTrue();
    })

    it('AllowUnknownValidate', 0, function () {
      let startTime1 = new Date().getTime();
      var v0 = new Validator();
      var schema = {
        type: "string",
        format: "email",
        example: "foo",
      };
      let result = v0.validate("Name", schema, {
        allowUnknownAttributes: true
      });
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : AllowUnknownValidate averageTime : " + averageTime1 + "us")
      expect(result.valid).assertFalse();

    })

    it('SkipAttributes', 0, function () {
      let startTime1 = new Date().getTime();
      var schema = {
        "id": "/SimplePerson",
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "sex": {
            "type": "number", "minimum": 50
          },
          "votes": {
            "type": "integer", "minimum": 1
          }
        }
      };

      var p = {
        "name": "张三",
        "sex": 45,
        "votes": 22
      };


      var v0 = new Validator();
      let result = v0.validate(p, schema, {
        skipAttributes: ["minimum"]
      })
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : SkipAttributes averageTime : " + averageTime1 + "us")
      expect(result.valid).assertTrue();

    })
  })
}