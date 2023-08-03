/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import AMF,{Spec,ByteArray} from 'amf-convert'

import Deserializer from 'amf-convert/dist/lib/amf/deserializer'

import DeserializationException from 'amf-convert/dist/lib/exception/deserialization'
import Serialization from 'amf-convert/dist/lib/exception/serialization'
import NotSupportedException from 'amf-convert/dist/lib/exception/not-supported'

export default function AMFTest() {
  describe('AMFTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })


    let test = (name, func)=>{
      it(name, 1 ,func)
    };

    let t = {
      same:  (src,dst)=>{
        if(typeof src == 'object' && typeof dst =='object'){
          expect(src).assertDeepEquals(dst);
        }else{
          expect(src).assertEqual(dst)
        }
      },
      plan:(info)=>{
        console.log(info)
      }
    };



    test('undefined', function() {
      t.plan(1);
      // @ts-ignore
      t.same(AMF.deserialize(AMF.serialize()), undefined);
    });

    test('null', function() {
      t.plan(1);

      t.same(AMF.deserialize(AMF.serialize(null)), null);
    });

    test('false', function() {
      t.plan(1);
      // @ts-ignore
      t.same(AMF.deserialize(AMF.serialize(false)), false);
    });

    test('true', function() {
      t.plan(1);
      // @ts-ignore
      t.same(AMF.deserialize(AMF.serialize(true)), true);
    });

    test('int', function() {

      var samples = [5, 100, -100, 100878, -199, Spec.MIN_INT, Spec.MAX_INT, -109876983];
      t.plan(samples.length + 1);

      for(var i in samples) {
        var sample = samples[i];

        // @ts-ignore
        var data = AMF.serialize(sample, true, Spec.AMF3_INT);
        t.same(AMF.deserialize(data), sample);
      }

      try{
        // @ts-ignore
        AMF.serialize(Spec.MAX_INT + 1, true, Spec.AMF3_INT);
      }catch (e){
        expect(e.name).assertContain('SerializationException')
      }

    });

    test('double', function() {

      var samples = [-10, 0.3767574, Spec.MIN_INT, Spec.MAX_INT, Math.PI, Number.MAX_VALUE, Number.MIN_VALUE, 102.145];
      t.plan(samples.length);

      for(var i in samples) {
        var sample = samples[i];
        // @ts-ignore
        t.same(AMF.deserialize(AMF.serialize(sample, true, Spec.AMF3_DOUBLE), Spec.AMF3_DOUBLE), sample);
      }
    });

    test('string', function() {

      var bigString = '';
      for(var i = 0; i < (Math.random() * 9999999) + 100000; i++) {
        bigString += String.fromCharCode(Math.round(Math.random() * 91) + 65);
      }

      var samples = ['hello!', '', '.', 'i ❤ π', bigString];
      t.plan(samples.length);

      for(var s in samples) {
        var sample = samples[s];
        // @ts-ignore
        t.same(AMF.deserialize(AMF.serialize(sample, true, Spec.AMF3_STRIG)), sample);
      }
    });

    test('date', function() {

      var samples = [new Date(), new Date(2011, 3, 9), new Date(1843, 1, 9), new Date(254, 1, 9), new Date(2040, 5, 12)];
      t.plan(samples.length);

      for(var i in samples) {
        var sample = samples[i];
        var data = AMF.deserialize(AMF.serialize(sample, true, Spec.AMF3_DATE));
        t.same(data, sample);
      }
    });

    test('array', function() {
      var sparse = [1, 2];
      sparse[5] = 9;

      var samples = [
        [1, 2, 3],
        [12.345, "hello", false, ['hi', 1234]],
        [true, false, null, "<h1>Hi</h1>"],
        sparse
      ];

      t.plan(samples.length);

      for(var i in samples) {
        var sample = samples[i];
        t.same(AMF.deserialize(AMF.serialize(sample, true, Spec.AMF3_ARRAY), Spec.AMF3_ARRAY), sample);
      }
    });

    test('object', function() {
      var ref = [1, 2, 3];

      var samples = [
        {"hello": "Bob!"},
        {
          "array": [99, 100, 101,
            {"nesting": "of objects", "yeah?": true, ref: ref}
          ],
          "reference": ref
        }
      ];

      t.plan(samples.length);

      for(var i in samples) {
        var sample = samples[i];
        var data = AMF.serialize(sample, true, Spec.AMF3_OBJECT);
        t.same(AMF.deserialize(data, Spec.AMF3_OBJECT), sample);
      }
    });

    test('class mapping', function() {

      var Something = function() {};

      Something.prototype = {
        _classMapping: 'SomethingClass',
        doSomething: function() {
          console.log('Something was done!');
        }
      };
      // @ts-ignore
      AMF.registerClassAlias('SomethingClass', Something);
      var test = new Something();

      t.plan(1);

      expect(AMF.parse(AMF.stringify(test, AMF.CLASS_MAPPING)) instanceof Something).assertEqual(true)
    });

    test('class mapping + serializable', function() {

      var Serializable = function() {};

      Serializable.prototype = {
        _classMapping: 'SerializableClass',
        property: 'value',
        exportData: function() {
          return {property: this.property}
        },
        importData: function(data) {
          for(var key in data) {
            this[key] = data[key];
          }
        }
      };
      // @ts-ignore
      AMF.registerClassAlias('SerializableClass', Serializable);
      var test = new Serializable();

      t.plan(2);

      var tested = AMF.parse(AMF.stringify(test, AMF.CLASS_MAPPING));
      expect(tested instanceof Serializable).assertEqual(true)
      t.same({property: 'value'}, tested);
    });

    test('bytearray', function() {

      t.plan(2);
      // @ts-ignore
      var simple = new ByteArray.default('656566');
      var data = AMF.deserialize(AMF.serialize(simple, true, Spec.AMF3_BYTE_ARRAY));
      t.same(data, simple);

      // create a bytearray with serialize AMF data, serialize the bytearray, deserialize the bytearray and then deserialize the AMF data
      // #meta

      var obj = {it: "works!"};
      // @ts-ignore
      var amf = new ByteArray.default(AMF.serialize(obj, true, Spec.AMF3_OBJECT));
      var serialized = AMF.serialize(amf, true, Spec.AMF3_BYTE_ARRAY);
      var deserialized = AMF.deserialize(serialized, Spec.AMF3_BYTE_ARRAY);
      t.same(AMF.deserialize(deserialized, Spec.AMF3_OBJECT), obj);

    });

    test('NotSupportedException', function() {
      t.plan(1);

      try
      {
        AMF.stringify(function(){});
      }
      catch (e) {
          expect(e.name).assertContain('NotSupportedException')
      }
    });

    test('DeserializationException', function() {
      t.plan(1);
      // @ts-ignore
      var deserializer = new Deserializer();
      // @ts-ignore
      deserializer.stream = {
        // @ts-ignore
        readByte: function() {
          return 999;
        }
      };

      try
      {
        deserializer.deserialize();
      }
      catch (e) {
          expect(e.name).assertContain('DeserializationException')
      }
    });

  })



}