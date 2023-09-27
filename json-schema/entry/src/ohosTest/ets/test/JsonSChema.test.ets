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
import { SchemaError, validate, ValidationError, Validator, ValidatorResult ,Schema} from '@ohos/jsonschema'
import {
  allowAttributes,
  alltext,
  basetsat,
  containste,
  defaul,
  initSchemajson,
  instancejson,
  nestedErrorstext,
  pjson,
  pre,
  referenced,
  requiredtext,
  rewi,
  schemaArr, schemadata,
  schemajsonpro,
  schemajsons,
  schemastartTime1,
  schemavalue,
  skipAttribute,
  typeFn, typelines, typep,
  typeresult,
  typeschema,
  value
} from './IntertfaceData'


const BASE_COUNT = 1

export default function jsonSChemaTest() {
  describe('JsonSChemaValidateTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('SimpleValidate', 0, () => {
      let startTime1 = new Date().getTime();
      let instance = 4;
      let schema = typeFn('number');
      // let result= v.validate(instance, schema);
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : SimpleValidate averageTime : " + averageTime1 + "us")
      expect(new Validator().validate(instance, schema).valid).assertTrue();
    })
    it('VerySimpleValidate', 0, () => {
      let startTime1 = new Date().getTime();
      // let result= v.validate(4, typeFn('number'));
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : SimpleValidate averageTime : " + averageTime1 + "us")
      expect(new Validator().validate(4, typeFn('number')).valid).assertTrue();
    })
    it('ComplicatedValidate', 0, () => {
      let startTime1 = new Date().getTime();
      let addressSchema = typelines("/SimpleAddress", "object", "array", "string", "string", "string", "string", ["country"]);
      // Person
      let schema = typeschema("/SimplePerson", "object", "string", "/SimpleAddress", "integer", 1)
      let p = typep("Barack Obama", ["1600 Pennsylvania Avenue Northwest"], "DC 20500", "Washington", "USA", "lots")
      new Validator().addSchema(addressSchema, '/SimpleAddress');
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : ComplicatedValidate averageTime : " + averageTime1 + "us")
      expect(new Validator().validate(p, schema).valid).assertFalse();
    })

    it('AllValidate', 0, () => {
      let startTime1 = new Date().getTime();

      let referencedSchema = referenced("/ReferencedSchema","string")

      let all =alltext("a string", true,6, 6,[],6,[], 5,[], 4, true,[], 4,"a string",6,6,"a string",6,"a string",[ "str-a", "str-b"], [ "str-a"],[ "str-a", "str-b"],9.6, 8,"a string", "a string","blue","a",11,"a string",true,"a string",true,8,"a string",true,6,"a string")
      new Validator().addSchema(referencedSchema, '/ReferencedSchema');
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : AllValidate averageTime : " + averageTime1 + "us")
      expect(new Validator().validate(all, schemadata).valid).assertTrue();
    })

    it('UnDefinedValidate', 0, () => {
      let startTime1 = new Date().getTime();
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : UnDefinedValidate averageTime : " + averageTime1 + "us")
      expect(new Validator().validate(undefined, typeFn("string")).valid).assertTrue();
      let startTime2 = new Date().getTime();
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("jsconschema : UnDefinedValidate averageTime : " + averageTime2 + "us")

      expect(new Validator().validate(undefined, typeFn("string"), requiredtext(true)).valid).assertFalse();
    })
    it('FormatValidate', 0, () => {
      let startTime1 = new Date().getTime();
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : FormatValidate averageTime : " + averageTime1 + "us")
      let startTime2 = new Date().getTime();
      let endTime2 = new Date().getTime();
      let averageTime2 = ((endTime2 - startTime2) * 1000) / BASE_COUNT;
      console.log("jsconschema : FormatValidate averageTime : " + averageTime2 + "us")
      expect(new Validator().validate('myFormat', typeresult('string','myFormat')).valid).assertTrue();
      expect(new Validator().validate('foo', typeresult('string','myFormat')).valid).assertFalse();
    })
    it('NestedErrorsValidate', 0, () => {
      let startTime1 = new Date().getTime();
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : NestedErrorsValidate averageTime : " + averageTime1 + "us")
      expect(new Validator().validate('This string is 28 chars long', schemajsons, nestedErrorstext(true)).toString()).assertEqual(`0: instance does not meet minimum length of 32
1: instance does not meet maximum length of 16
2: instance is not of a type(s) number
3: instance is not exactly one from [subschema 0],[subschema 1],[subschema 2]
`);
    })

    it('LocalErrorMessage', 0, () => {
      let startTime1 = new Date().getTime();
      let localized:string= new Validator().validate('This string is 28 chars long', schemajsons, nestedErrorstext(true)).errors.map((err:Error)=> {return err.name;});
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : LocalErrorMessage averageTime : " + averageTime1 + "us")
      expect(localized.toString()).assertEqual(`minLength,maxLength,type,oneOf`);
    })

    it('DiyKeyWordValidate', 0, () => {
      let startTime1 = new Date().getTime();
      new Validator().attributes.contains = Validator.validateContains = (instance:string, schema:Schema, options:string, ctx:string):ESObject=> {
        if (typeof instance !== 'string') return;
        if (typeof schema.contains !== 'string') {
          new SchemaError('"contains" expects a string', schema);
        }

        if (instance.indexOf(schema.contains) < 0) {

          return 'does not contain the string ' + JSON.stringify(schema.contains);
        }

        if (schema.contains.length < 2) {
          return '"contains" length must more than 2 ';
        }
      }
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : DiyKeyWordValidate averageTime : " + averageTime1 + "us")
      expect(new Validator().validate("I am an instance", containste("string","I am")).valid).assertTrue();
    })
    it('DiyAnotherValidate', 0, () => {
      let startTime1 = new Date().getTime();
      new Validator().attributes.contains = validate.validateContains=(instance:string, schema:Schema, options:string, ctx:string):string =>{

        if (typeof instance !== 'string') {

          new ValidatorResult(instance, schema, options, ctx).addError('fails some validation test')
        }


        if (typeof schema.contains !== 'string') {

          new ValidatorResult(instance, schema, options, ctx).addError('fails some validation test')
        }


        if (instance.indexOf(schema.contains) > 0) {

          new ValidatorResult(instance, schema, options, ctx).addError('fails some validation test')
        }


        if (schema.contains.length > 0) {

          new ValidatorResult(instance, schema, options, ctx).addError('fails some validation test')
        }
        return new ValidatorResult(instance, schema, options, ctx);
      }

      // let resultValidate = v.validate("I am an instance", containste("string","I am"));
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : DiyAnotherValidate averageTime : " + averageTime1 + "us")
      expect(new Validator().validate("I am an instance", containste("string","I am")).valid).assertFalse();
    })

    it('DereferencingSchema', 0, () => {
      let startTime1 = new Date().getTime();
      new Validator().addSchema(initSchemajson)

      let cacheSchemaNum: number = 0;


      let importNextSchema=(v:ESObject)=> {

        if (cacheSchemaNum >= schemaArr.length) {
          return
        }
        if (!v.unresolvedRefs.shift()) {
          return;
        }
        console.log(`jsonschema ------> 被移除的规则：${JSON.stringify(v.unresolvedRefs.shift())}`)
        v.addSchema(schemaArr[cacheSchemaNum]);
        cacheSchemaNum++;
        importNextSchema(v);
      }

      importNextSchema( new Validator())
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : DereferencingSchema averageTime : " + averageTime1 + "us")
      expect(cacheSchemaNum).assertLarger(0);
    })

    it('DefaultBaseUri', 0, () => {
      let startTime1 = new Date().getTime();
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : DefaultBaseUri averageTime : " + averageTime1 + "us")
      expect(new Validator().validate(["Name"], defaul, basetsat('http://example.com/')).valid).assertTrue();
    })
    it('ReWrite', 0, () => {
      let startTime1 = new Date().getTime();

      const unmarshall=(instance:string, schema:Schema)=> {
        if (schema.id === 'http://example.com/date') {
          return new Date(instance);
        }
        return instance;
      }

      let resultDate = new Validator().validate(value, schemavalue, rewi).instance.date instanceof Date;
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : ReWrite averageTime : " + averageTime1 + "us")
      expect(new Validator().validate(value, schemavalue, rewi).valid).assertTrue();
      expect(resultDate).assertTrue();
    })

    it('PrePropertyValidate', 0, () => {
      let startTime1 = new Date().getTime();


      let  preValidate=(object:string, key:string, schema:Schema, options:string, ctx:Schema)=> {
        if (typeof value === 'undefined') return;

        // Test if the schema declares a type, but the type keyword fails validation
        if (schema.type as Number&& new Validator().attributes.type.call(new Validator(), value, schema, options, ctx.makeChild(schema, key))) {
          // If the type is "number" but the instance is not a number, cast it
          if (schema.type === 'number' && typeof value !== 'number') {
            object[key] = Number.parseFloat(object[key]);
            return;
          }
          // If the type is "string" but the instance is not a string, cast it
          if (schema.type === 'string' && typeof value !== 'string') {
            object[key] = String(value).toString();
            return;
          }
        }
      };

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : PrePropertyValidate averageTime : " + averageTime1 + "us")
      expect(new Validator().validate(instancejson, schemajsonpro, pre).valid).assertTrue();
    })

    it('AllowUnknownValidate', 0, () => {
      let startTime1 = new Date().getTime();

      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : AllowUnknownValidate averageTime : " + averageTime1 + "us")
      expect(new Validator().validate("Name", schemastartTime1, allowAttributes).valid).assertFalse();

    })

    it('SkipAttributes', 0, () => {
      let startTime1 = new Date().getTime();
      let endTime1 = new Date().getTime();
      let averageTime1 = ((endTime1 - startTime1) * 1000) / BASE_COUNT;
      console.log("jsconschema : SkipAttributes averageTime : " + averageTime1 + "us")
      expect(new Validator().validate(pjson, schemajsons, skipAttribute).valid).assertTrue();

    })
  })
}