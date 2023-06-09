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

import { SchemaError, validate, ValidationError, Validator, ValidatorResult } from '@ohos/jsonschema'

@Entry
@Component
struct AllValidatePage {
  @State message0: string = `var referencedSchema = {
  "id": "/ReferencedSchema",
  "type": "string"
};
var all ={
...
}
var v = new Validator();
v.addSchema(referencedSchema, '/ReferencedSchema');
v.validate(all, schema);
`;
  @State message1: string = `验证对象：--`
  @State message2: string = `期待结果：暂无`
  @State message3: string = `实际结果：--`

  build() {
    Row() {
      Column() {
        Text(this.message0)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#22E1E1E1')
          .maxLines(10)
          .fontColor(Color.Black)

        Text(this.message1)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#66E1E1E1')
          .maxLines(10)
          .fontColor(Color.Black)
          .margin({
            top: 20
          })

        Text(this.message2)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#66E1E1E1')
          .maxLines(10)
          .fontColor(Color.Black)
          .margin({
            top: 20
          })

        Text(this.message3)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#66E1E1E1')
          .maxLines(10)
          .fontColor(Color.Black)
          .margin({
            top: 20
          })

        Button('验证')
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .width("80%")
          .height(100)
          .margin({
            top: 20
          })
          .onClick((event) => {
            this.validate();
          })

      }
      .width('100%')
    }
    .height('100%')
  }

  validate() {
    const ctx = this;
    ctx.message2 = `期待结果：${true}`
    try {
      var v = new Validator();
      // This schema includes all of the possible validation tests.
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
          "validateAnyOf": { "anyOf": [
            {
              "type": "boolean"
            },
            {
              "type": "string"
            }
          ] },
          "validateAllOf": { "allOf": [
            {
              "type": "boolean"
            },
            {
              "enum": [true]
            }
          ] },
          "validateOneOf": { "oneOf": [
            {
              "type": "boolean"
            },
            {
              "type": "integer"
            }
          ] },

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
      let str = JSON.stringify(result);
      console.log(`jsonschema ------> 测试结果是：${str}`);
      ctx.message1 = `验证对象： ${str}`;
      ctx.message3 = `实际结果：${result.valid}`
    } catch (err) {
      let str = JSON.stringify(err);
      console.log(`jsonschema ------> 验证出错：${str}`);
      ctx.message3 = `验证出错：${str}`
    }
  }
}