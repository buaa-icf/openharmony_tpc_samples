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

import { SchemaError, validate, ValidationError, Validator, ValidatorResult, ValidatorResultError } from 'jsonschema'
import { it as _it, afterAll, afterEach, beforeAll, beforeEach, describe, expect } from '@ohos/hypium'

// @ts-ignore
var validator: Validator;
const BASE_COUNT = 1

export default function validatorTest() {
  describe('validatorTest', function () {
    beforeAll(function () {
    })
    beforeEach(function () {
      validator = new Validator();
    })
    afterEach(function () {
    })
    afterAll(function () {
    })

    _it('initial value', 0, function () {
      expect(validator.unresolvedRefs).assertDeepEquals([])
    });
    _it('addSchema', 0, function () {
      let result = validator.addSchema({
        id: 'http://example.com/base.json',
        items: {
          $ref: 'item.json',
        },
      });
      expect(validator.unresolvedRefs).assertDeepEquals(['http://example.com/item.json'])
    });

    _it('argument schema must be a schema object', 0, function () {
      let result = validator.addSchema({}, 'http://example.com/base.json');
      expect(validator.schemas['http://example.com/base.json']).assertDeepEquals({})
    });
    // TODO: held for major version upgrade
    _it('argument schema must be a schema true', 0, function () {
      validator.addSchema(true, 'http://example.com/base.json');
      expect(validator.schemas['http://example.com/base.json']).assertEqual(undefined)
    });
    // TODO: held for major version upgrade
    _it('argument schema must be a schema false', 0, function () {
      validator.addSchema(false, 'http://example.com/base.json');
      expect(validator.schemas['http://example.com/base.json']).assertEqual(undefined)
    });
    _it('argument schema must be a schema null', 0, function () {
      var res = validator.addSchema(undefined, 'http://example.com/base.json');
      expect(res).assertEqual(null);
      let result = 'http://example.com/base.json' in validator.schemas
      expect(result).assertFalse();
    });
    _it('argument schema must be a schema undefined', 0, function () {
      var res = validator.addSchema(undefined, 'http://example.com/base.json');
      expect(res).assertEqual(null);
      let result = 'http://example.com/base.json' in validator.schemas
      expect(result).assertFalse();
    });
    // TODO: held for major version upgrade
    _it('argument schema must not be a number', 0, function () {
      try {
        validator.addSchema(1, 'http://example.com/base.json');
      } catch (err) {
        expect(err instanceof Error).assertTrue()
      }
    });
    // TODO: held for major version upgrade
    _it('argument schema must not be a string', 0, function () {
      try {
        validator.addSchema("schema", 'http://example.com/base.json');
      } catch (err) {
        expect(err instanceof Error).assertTrue()
      }
    });
    // TODO: held for major version upgrade
    _it('argument schema must not be null', 0, function () {
      try {
        validator.addSchema(null, 'http://example.com/base.json');
      } catch (err) {
        expect(err instanceof Error).assertTrue()
      }
    });
    // TODO: held for major version upgrade
    _it('argument schema must not be undefined', 0, function () {
      try {
        validator.addSchema(undefined, 'http://example.com/base.json');
      } catch (err) {
        expect(err instanceof Error).assertTrue()
      }
    });
    _it('addSchema with absolute id', 0, function () {
      validator.addSchema({
        id: 'http://example.com/base.json'
      });
      expect(validator.unresolvedRefs).assertDeepEquals([])
      expect(validator.schemas['http://example.com/base.json']).assertDeepEquals({
        id: 'http://example.com/base.json'
      })
    });
    _it('addSchema with absolute $id', 0, function () {
      validator.addSchema({
        $id: 'http://example.com/base.json',
      });
      expect(validator.unresolvedRefs).assertDeepEquals([])
    });
    // TODO: held for next major version
    _it('base must be a full URI', 0, function () {
      try {
        validator.addSchema({
          id: 'main.json'
        }, '/index.json');
      } catch (err) {
        expect(err instanceof SchemaError).assertTrue()
      }
    });
    _it('addSchema with absolute base', 0, function () {
      var res = validator.addSchema({
        type: 'string'
      }, 'http://example.com/main.json');
      expect(res).not().assertNull();
      expect('http://example.com/main.json' in validator.schemas).assertTrue();
      expect(validator.schemas['http://example.com/main.json']).assertDeepEquals(res)
    });
    _it('addSchema with absolute $id', 0, function () {
      var res = validator.addSchema({
        type: 'string'
      }, 'http://example.com/main.json');
      expect(res).not().assertNull();
      expect('http://example.com/main.json' in validator.schemas).assertTrue();
      expect(validator.schemas['http://example.com/main.json']).assertDeepEquals(res)
    });
    _it('addSchema with relative id', 0, function () {
      var res = validator.addSchema({
        id: 'main.json'
      }, 'http://example.com/index.html');
      // assert(res);
      expect('http://example.com/main.json' in validator.schemas).assertTrue();
    });
    _it('addSchema with relative $id', 0, function () {
      var res = validator.addSchema({
        $id: 'main.json'
      }, 'http://example.com/index.html');
      // assert(res);
      expect('http://example.com/main.json' in validator.schemas).assertTrue();
    });
    _it('addSchema populates unresolvedRefs', 0, function () {
      validator.addSchema({
        $id: 'main.json',
        items: {
          $ref: 'item.json',
        },
      }, 'http://example.com/index.json');
      expect('http://example.com/main.json' in validator.schemas).assertTrue();
      expect(validator.unresolvedRefs[0]).assertDeepEquals('http://example.com/item.json')
      validator.addSchema({
        $id: 'item.json'
      }, 'http://example.com/index.json');
      expect(validator.unresolvedRefs.length).assertEqual(0)
    });
    _it('schema may be an object', 0, function () {
      var res = validator.validate(true, {});
      expect(res.valid).assertTrue()
    });
    _it('schema may be true', 0, function () {
      var res = validator.validate(true, true);
      expect(res.valid).assertTrue()
    });
    _it('schema may be false', 0, function () {
      var res = validator.validate(true, false);
      expect(res.valid).assertFalse()
    });
    _it('schema cannot be null', 0, function () {
      try {
        validator.validate(true, null);
      } catch (err) {
        expect(err instanceof SchemaError).assertTrue();
        expect(err.message.indexOf('object or boolean') >= 0).assertTrue();
      }

    });
    _it('schema cannot be undefined', 0, function () {
      try {
        validator.validate(true, undefined);
      } catch (err) {
        expect(err instanceof SchemaError).assertTrue();
        expect(err.message.indexOf('object or boolean') >= 0).assertTrue();
      }
    });
    _it('schema cannot be a string', 0, function () {
      try {
        validator.validate(true, "string");
      } catch (err) {
        expect(err instanceof SchemaError).assertTrue();
        expect(err.message.indexOf('object or boolean') >= 0).assertTrue();
      }
    });
    _it('options may be undefined', 0, function () {
      let result = validator.validate(null, true, undefined);
      expect(result.valid).assertTrue();
    });
    _it('options may be null', 0, function () {
      let result = validator.validate(null, true, null);
      expect(result.valid).assertTrue();
    });
    _it('options.base must be a string', 0, function () {
      let result = validator.validate(null, true, null);
      expect(result.valid).assertTrue();
    });
    _it('options.required with defined instance', 0, function () {
      var res = validator.validate(undefined, true, {
        required: true
      });
      expect(res.valid).assertFalse();
      expect(res.errors[0].message.indexOf('required') >= 0).assertTrue();
      var neg = validator.validate(null, true, {
        required: true
      });
      expect(neg.valid).assertTrue();
    });
    _it('options.required with undefined instance', 0, function () {
      var res = validator.validate(undefined, true, {
        required: true
      });
      expect(res.valid).assertFalse()
      expect(res.errors[0].message.indexOf('required') >= 0).assertTrue();
      var neg = validator.validate(null, true, {
        required: true
      });
      expect(neg.valid).assertTrue();
    });
    _it('options.required is false', 0, function () {
      var res = validator.validate(undefined, true, {
        required: false
      });
      expect(res.valid).assertTrue();
      var neg = validator.validate(null, true, {
        required: true
      });
      expect(neg.valid).assertTrue()
    });
    _it('options.required defaults false', 0, function () {
      // TODO DEPRECATED: this behavior changes to true in next major version
      var res = validator.validate(undefined, true, {});
      expect(res.valid).assertTrue();
      var neg = validator.validate(null, true, {
        required: true
      });
      expect(neg.valid).assertTrue()
    });
    _it('options throwError', 0, function () {
      var schema = {
        properties: {
          "a": {
            type: 'number'
          },
          "b": {
            type: 'number'
          },
        },
      };
      var valid = {
        a: 0, b: 0
      };
      var invalid = {
        a: null, b: null
      };
      var res = validator.validate(valid, schema, {});
      expect(res.valid).assertTrue();
      var neg = validator.validate(invalid, schema, {});
      expect(neg.valid).assertFalse()
      try {
        validator.validate(invalid, schema, {
          throwError: true
        });
      } catch (err) {
        expect(err instanceof ValidationError).assertTrue()
      }
    });
    _it('options throwFirst', 0, function () {
      var schema = {
        properties: {
          "a": {
            type: 'number'
          },
          "b": {
            type: 'number'
          },
        },
      };
      var valid = {
        a: 0, b: 0
      };
      var invalid = {
        a: null, b: null
      };
      var res = validator.validate(valid, schema, {
        throwAll: true
      });
      expect(res.valid).assertTrue();
      var neg = validator.validate(invalid, schema, {});
      expect(neg.valid).assertFalse()
      try {
        validator.validate(invalid, schema, {
          throwFirst: true
        });
      } catch (err) {
        expect(err instanceof Error).assertTrue()
        expect(err instanceof ValidatorResultError).assertTrue()
        expect(err.errors.length).assertEqual(1)
      }
    });
    _it('options throwAll', 0, function () {
      var schema = {
        properties: {
          "a": {
            type: 'number'
          },
          "b": {
            type: 'number'
          },
        },
      };
      var valid = {
        a: 0, b: 0
      };
      var invalid = {
        a: null, b: null
      };
      var res = validator.validate(valid, schema, {
        throwAll: true
      });
      expect(res.valid).assertTrue();
      var neg = validator.validate(invalid, schema, {});
      expect(neg.valid).assertFalse()

      try {
        validator.validate(invalid, schema, {
          throwAll: true
        });
      } catch (err) {
        expect(err instanceof Error).assertTrue()
        expect(err instanceof ValidatorResultError).assertTrue()
        expect(err.errors.length).assertEqual(2)
      }
    });
    _it('million errors', 0, function () {
      var schema = {
        type: 'number',
        oneMillionErrors: true,
      };
      validator.attributes.oneMillionErrors = function (instance, schema, options, ctx) {
        const result = new ValidatorResult(instance, schema, options, ctx);
        for (var i = 0; i < 1000; i++) {
          result.addError('oneMillionErrors error');
        }
        return result;
      }
      var res = validator.validate(1, schema, {});
      expect(res.valid).assertFalse();
      expect(res.errors.length).assertEqual(1000)
    });
    _it('subschema references named reference', 0, function () {
      var schema = {
        items: {
          $ref: '#items'
        },
        definitions: {
          items: {
            $id: '#items',
            type: 'array',
          },
        },
      };
      var res = validator.validate([[]], schema);
      expect(res.valid).assertTrue();
      var neg = validator.validate([null], schema);
      expect(neg.valid).assertFalse();
    });
    _it('subschema references path reference', 0, function () {
      var schema = {
        items: {
          $ref: '#/definitions/items'
        },
        definitions: {
          items: {
            type: 'array',
          },
        },
      };
      var res = validator.validate([[]], schema);
      expect(res.valid).assertTrue();
      var neg = validator.validate([null], schema);
      expect(neg.valid).assertFalse();
    });
    _it('recursive references fragment reference', 0, function () {
      var schema = {
        $id: 'http://example.com/foo.json',
        items: {
          $ref: '#'
        },
        type: 'array',
      };
      var res = validator.validate([[[[]]]], schema);
      expect(res.valid).assertTrue();
      var neg = validator.validate([null], schema);
      expect(neg.valid).assertFalse();
    });
    _it('recursive references filename reference', 0, function () {
      var schema = {
        $id: 'http://example.com/foo.json',
        items: {
          $ref: 'foo.json'
        },
        type: 'array',
      };
      var res = validator.validate([[[[]]]], schema);
      expect(res.valid).assertTrue();
      var neg = validator.validate([null], schema);
      expect(neg.valid).assertFalse();
    });


  })
}