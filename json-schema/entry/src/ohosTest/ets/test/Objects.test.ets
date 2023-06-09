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
import { it as _it, afterAll, afterEach, beforeAll, beforeEach, describe, expect } from '@ohos/hypium'

// @ts-ignore
var validator: Validator;
const BASE_COUNT = 1
var initSchema = {
  required: ['constructor'],
  properties: {
    constructor: { type: 'string' },
  },
};

export default function objectsTest() {
  describe('objectsTest', function () {
    beforeAll(function () {
    })
    beforeEach(function () {
      validator = new Validator();
    })
    afterEach(function () {
    })
    afterAll(function () {
    })
    _it('should validate a valid object', 0, function () {
      let result = validator.validate({}, {
        'type': 'object'
      }).valid;
      expect(result).assertTrue();
    });

    _it('should validate an undefined object', 0, function () {
      let result = validator.validate(undefined, {
        'type': 'object'
      }).valid;
      expect(result).assertTrue();
    });

    _it('should not validate a number', 0, function () {
      let result = validator.validate(0, {
        'type': 'object'
      }).valid;
      expect(result).assertFalse();
    });

    _it('should not validate an array', 0, function () {
      let result = validator.validate([0], {
        'type': 'object'
      }).valid;
      expect(result).assertFalse();
    });
    _it('should validate a valid object', 0, function () {
      let result = validator.validate(
        {
          'name': 'test'
        },
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
          },
        }
      ).valid;
      expect(result).assertTrue();
    });

    _it('should not validate an invalid object', 0, function () {
      let result = validator.validate(0, {
        'type': 'object'
      }).valid;
      expect(result).assertFalse();
    });

    _it('should validate a valid property', 0, function () {
      var res = validator.validate(Object.create({
        constructor: 'string'
      }), initSchema);
      expect(res.valid).assertDeepEquals(true)
    });
    _it('should not validate an invalid property', 0, function () {
      var res = validator.validate(Object.create({
        constructor: true
      }), initSchema);
      expect(res.valid).assertDeepEquals(false)
      expect(res.errors[0].name).assertEqual('type')
    });
    _it('should not validate a missing property', 0, function () {
      var res = validator.validate(Object.create({}), initSchema);
      expect(res.valid).assertDeepEquals(false)
      expect(res.errors[0].name).assertEqual('required')
    });
    _it('should validate a valid object with multiple properties', 0, function () {
      let result = validator.validate(
        {
          'name': 'test', 'address': 'someplace'
        },
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
            'address': {
              'type': 'string'
            },
          },
        }
      ).valid;
      expect(result).assertTrue();
    });

    _it('should validate a valid object with undefined property', 0, function () {
      let result = validator.validate(
        {
          'name': 'test'
        },
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
            'address': {
              'type': 'string'
            },
          },
        }
      ).valid;
      expect(result).assertTrue();
    });

    _it('should not throw when checking properties on a non-object', 0, function () {
      let result = validator.validate(
        null,
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
          },
        }
      ).valid;
      expect(result).assertFalse();
    });
    _it('should NOT validate a valid object', 0, function () {
      let result = validator.validate(
        {
          'name': 'test', 'nested': 'test2'
        },
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
            'nested': {
              'type': 'object'
            },
          },
        }
      ).valid;
      expect(result).assertFalse();
    });

    _it('should validate a valid object', 0, function () {
      let result = validator.validate(
        {
          'name': 'test', 'nested': 'test2'
        },
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
            'nested': {
              'type': 'string'
            },
          },
        }
      ).valid;
      expect(result).assertTrue();
    });
    _it('should NOT validate an undefined object', 0, function () {
      var ret = validator.validate(
        {
          'foo': {
            'baz': 1
          }
        },
        {
          'type': 'object',
          'required': true,
          'properties': {
            'foo': {
              'type': 'object',
              'required': true,
              'properties': {
                'bar': {
                  'type': 'object', 'required': true
                },
                'baz': {
                  'type': 'number', 'required': true
                },
              },
            },
          },
        }
      ).valid;
      expect(ret).assertFalse();
    });

    _it('should validate if there are no additionalProperties', 0, function () {
      let result = validator.validate(
        {
          'name': 'test', 'nested': 'test2'
        },
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
            'nested': {
              'type': 'string'
            },
          },
          'additionalProperties': false,
        }
      ).valid;
      expect(result).assertTrue();
    });

    _it('should not validate if there are additionalProperties', 0, function () {
      let result = validator.validate(
        {
          'name': 'test', 'nested': 'test2', 'extraProp': 1
        },
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
            'nested': {
              'type': 'string'
            },
          },
          'additionalProperties': false,
        }
      ).valid;
      expect(result).assertFalse();
    });

    _it('should validate if the additionalProperties are compliant with additionalProperties', 0, function () {
      let result = validator.validate(
        {
          'name': 'test', 'nested': 'test2', 'extraProp': 1
        },
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
            'nested': {
              'type': 'string'
            },
          },
          'additionalProperties': {
            'type': 'number'
          },
        }
      ).valid;
      expect(result).assertTrue();
    });

    _it('should not validate if the additionalProperties are not compliant with additionalProperties', 0, function () {
      let result = validator.validate(
        {
          'name': 'test', 'nested': 'test2', 'extraProp': '1'
        },
        {
          'type': 'object',
          'properties': {
            'name': {
              'type': 'string'
            },
            'nested': {
              'type': 'string'
            },
          },
          'additionalProperties': {
            'type': 'number'
          },
        }
      ).valid;
      expect(result).assertFalse();
    });
    _it('should treat undefined property schema as not existing', 0, function () {
      var schema = {
        'type': 'object',
        'properties': {
          'name': {
            'type': 'string'
          },
          'nested': undefined,
        },
        'additionalProperties': {
          'type': 'number'
        },
      };
      let result1 = validator.validate(
        {
          'name': 'test', 'nested': 2
        },
        schema
      ).valid;
      expect(result1).assertTrue();
      let result2 = validator.validate(
        {
          'name': 'test', 'nested': 'test2'
        },
        schema
      ).valid;
      expect(result2).assertFalse();
    });

    _it('should not permit null as a schema', 0, function () {
      var schema = {
        'type': 'object',
        'properties': {
          'name': {
            'type': 'string'
          },
          'nested': null,
        },
        'additionalProperties': {
          'type': 'number'
        },
      };
      try {
        validator.validate(
          {
            'name': 'test', 'nested': 2
          },
          schema
        );
      } catch (err) {
        let types = (err instanceof SchemaError)
        expect(types).assertTrue();
        expect(err.message).assertDeepEquals('Unexpected null, expected schema in "properties"');
      }
    });


    _it('should treat undefined property schema as not existing', 0, function () {
      var schema = {
        'type': 'object',
        'patternProperties': {
          'name': {
            'type': 'string'
          },
          'nested': undefined,
        },
        'additionalProperties': {
          'type': 'number'
        },
      };
      let result1 = validator.validate(
        {
          'name': 'test', 'nested': 2
        },
        schema
      ).valid;
      expect(result1).assertTrue()

      let result2 = validator.validate(
        {
          'name': 'test', 'nested': 'test2'
        },
        schema
      ).valid;
      expect(result2).assertFalse()
    });

    _it('should not permit null as a schema', 0, function () {
      var schema = {
        'type': 'object',
        'patternProperties': {
          'name': {
            'type': 'string'
          },
          'nested': null,
        },
        'additionalProperties': {
          'type': 'number'
        },
      };
      try {
        validator.validate(
          {
            'name': 'test', 'nested': 2
          },
          schema
        );
      } catch (err) {
        let types = (err instanceof SchemaError)
        expect(types).assertTrue();
        expect(err.message).assertDeepEquals('Unexpected null, expected schema in "patternProperties"');
      }
    });
  });
}