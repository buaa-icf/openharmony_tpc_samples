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

import { SchemaError, validate, ValidationError, Validator, ValidatorResult } from 'jsonschema'
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'

// @ts-ignore
var validator: Validator;
const BASE_COUNT = 1
var testSchema = {
  "type": "string",
};

var numSchema = {
  "type": "number",
};

var objectIdSchema = {
  "type": "object",
  "id": "MongoDb#ObjectId",
  "description": "MongoDB ObjectID",
  "properties": {
    "id": { "type": "string" },
    "_bsontype": { "type": "string" },
  },
};
var schema = {
  type: 'object',
  required: true,
  properties: {
    frames: {
      type: 'array',
      required: true,
      items: {
        type: 'object',
        properties: {
          filename: { type: 'string', required: true },
          lineno: { type: ['integer', 'null'] },
          method: { type: ['string', 'null'] },
        },
      },
    },
    exception: {
      type: 'object',
      required: true,
      properties: {
        class: { type: 'string', required: true },
        message: { type: 'string' },
      },
    },
  },
};

export default function unionTest() {
  describe('unionTest', function () {
    beforeAll(function () {
    })
    beforeEach(function () {
      validator = new Validator();
      validator.addSchema(testSchema, '/Test#Simple');
      validator.addSchema(numSchema, '/Test#Num');
      validator.addSchema(objectIdSchema, '/MongoDb#ObjectId');
    })
    afterEach(function () {
    })
    afterAll(function () {
    })
    var exc = {
      class: 'testing...', message: 'this is only a test'
    };

    it('ShouldValidateForNumber', 0, function () {
      let result = validator.validate(1, {
        'type': ['number', 'string']
      }).valid
      expect(result).assertTrue();
    });
    it('ShouldValidateForString', 0, function () {
      let result = validator.validate('1', {
        'type': ['number', 'string']
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfNoStringOrNumber', 0, function () {
      let result = validator.validate(true, {
        'type': ['number', 'string']
      }).valid;
      expect(result).assertFalse();
    });

    it('shouldValidateForNull', 0, function () {
      let result = validator.validate(null, {
        'type': ['null', 'string']
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateForString', 0, function () {
      let result = validator.validate('1', {
        'type': ['null', 'string']
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfNoStringOrNumber', 0, function () {
      let result = validator.validate(true, {
        'type': ['null', 'string']
      }).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateForNull', 0, function () {
      let result = validator.validate(null, {
        'type': ['null', 'string']
      }).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateForString', 0, function () {
      let result = validator.validate('1', {
        'type': ['null', 'string']
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfNoStringOrNumber', 0, function () {
      let result = validator.validate(true, {
        'type': ['null', 'string']
      }).valid;
      expect(result).assertFalse();
    });
    it('ShouldValidateForNull', 0, function () {
      let result = validator.validate(null, {
        'type': ['null', {
          '$ref': 'Test#Simple'
        }]
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateForString', 0, function () {
      let result = validator.validate('test', {
        'type': ['null', {
          '$ref': 'Test#Simple'
        }]
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateIfNoStringOrNumber', 0, function () {
      let result = validator.validate(true, {
        'type': ['null', {
          '$ref': 'Test#Simple'
        }]
      }).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateFor', 0, function () {
      let result = validator.validate('*', {
        'type': [{
          type: 'string', pattern: '^\\*$'
        }, {
          '$ref': 'Test#Num'
        }]
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateFor1', 0, function () {
      let result = validator.validate(1, {
        'type': [{
          type: 'string', pattern: '^\\*$'
        }, {
          '$ref': 'Test#Num'
        }]
      }).valid;
      expect(result).assertTrue();
    });

    it('ShouldNotValidateFor', 0, function () {
      var result = validator.validate('-', {
        'type': [{
          type: 'string', pattern: '^\\*$'
        }, {
          '$ref': 'Test#Num'
        }]
      }).valid;
      expect(result).assertFalse();
    });

    it('ShouldValidateForArrayOr', 0, function () {
      var schema = {
        "type": "object",
        "properties": {
          "wildcards": {
            "type": "array",
            "items": {
              "type": [{
                "$ref": "MongoDb#ObjectId"
              }, {
                "type": "string", "pattern": "^\\*$"
              }]
            },
          },
        },
      };
      var result = validator.validate({
        'wildcards': ['*']
      }, schema).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateFoEmptyArray', 0, function () {
      var schema = {
        "type": "object",
        "properties": {
          "wildcards": {
            "type": "array",
            "items": {
              "type": [{
                "$ref": "MongoDb#ObjectId"
              }, {
                "type": "string", "pattern": "^\\*$"
              }]
            },
          },
        },
      };
      var result = validator.validate({
        'wildcards': []
      }, schema).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateForObjectId', 0, function () {
      var schema = {
        "type": "object",
        "properties": {
          "wildcards": {
            "type": "array",
            "items": {
              "type": [{
                "$ref": "MongoDb#ObjectId"
              }, {
                "type": "string", "pattern": "^\\*$"
              }]
            },
          },
        },
      };
      var result = validator.validate({
        'wildcards': [{
          "id": "1234", "_bsontype": "test"
        }, '*']
      }, schema).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateForObjectidAndIgnoreTitleAndDescription', 0, function () {
      var schema = {
        "type": "object",
        "properties": {
          "wildcards": {
            "type": "array",
            "items": {
              "type": [{
                "$ref": "MongoDb#ObjectId", "title": "test", "description": "test"
              }, {
                "type": "string", "pattern": "^\\*$"
              }]
            },
          },
        },
      };
      var result = validator.validate({
        'wildcards': [{
          "id": "1234", "_bsontype": "test"
        }, '*']
      }, schema).valid;
      expect(result).assertTrue();
    });

    it('ShouldValidateForNulls', 0, function () {
      var instance = {
        frames: [{
          filename: 'somefile.js', lineno: null
        }], exception: exc
      };
      var result = validator.validate(instance, schema).valid;
      expect(result).assertTrue();
    });
    it('ShouldValidateForNullAndString', 0, function () {
      var instance = {
        frames: [{
          filename: 'somefile.js', lineno: null
        }], exception: exc
      };
      var result = validator.validate(instance, schema).valid;
      expect(result).assertTrue();
    });
    it('ShouldNotValidateForStringAndString', 0, function () {
      var instance = {
        frames: [{
          filename: 'somefile.js', lineno: {
            hello: 'world'
          }
        }], exception: exc
      };
      var result = validator.validate(instance, schema).valid;
      expect(result).assertFalse();
    });
  })
}