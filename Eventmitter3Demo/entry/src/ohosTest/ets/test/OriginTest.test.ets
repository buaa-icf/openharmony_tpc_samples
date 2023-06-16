/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { it as _it, afterAll, afterEach, beforeAll, beforeEach, describe, expect } from '@ohos/hypium'
import EventEmitter from 'eventemitter3'
import Beast from '../Beast'

export default function originTest() {
  /**
   *
   * @param {*} obj1
   * @param {*} obj2
   *
   * 判断对象是否相等
   *
   */
  function diff(obj1, obj2) {
    var o1 = obj1 instanceof Object;
    var o2 = obj2 instanceof Object;
    // 判断是不是对象
    if (!o1 || !o2) {
      return obj1 === obj2;
    }
    //Object.keys() 返回一个由对象的自身可枚举属性(key值)组成的数组,
    //例如：数组返回下表：let arr = ["a", "b", "c"];console.log(Object.keys(arr))->0,1,2;
    if (Object.keys(obj1).length !== Object.keys(obj2).length) {
      return false;
    }
    for (var o in obj1) {
      var t1 = obj1[o] instanceof Object;
      var t2 = obj2[o] instanceof Object;
      if (t1 && t2) {
        if (!diff(obj1[o], obj2[o])) {
          return false
        }
      } else if (obj1[o] !== obj2[o]) {
        return false;
      }
    }
    return true;
  }

  /**
   *
   * 返回对相应的数据类型
   */
  function getType(data) {
    return Object.prototype.toString.call(data)
      .substring(8)
      .split(/]/)[0]
  }

  /**
   *
   * @param {*} sourceObj
   * @param {*} compareObj
   *
   * 比较对象深度是否相等
   *
   */
  function comparisonObject(sourceObj, compareObj) {
    if (arguments.length < 2) throw "Incorrect number of parameters";
    let sourceType = getType(sourceObj);
    if (sourceType !== getType(compareObj)) return false;
    // Not objects and arrays
    if (sourceType !== "Array" && sourceType !== "Object" && sourceType !== "Set" && sourceType !== "Map") {
      if (sourceType === "Number" && sourceObj.toString() === "NaN") {
        return compareObj.toString() === "NaN"
      }
      if (sourceType === "Date" || sourceType === "RegExp") {
        return sourceObj.toString() === compareObj.toString()
      }
      return sourceObj === compareObj
    } else if (sourceType === "Array") {
      if (sourceObj.length !== compareObj.length) return false;
      if (sourceObj.length === 0) return true;
      for (let i = 0; i < sourceObj.length; i++) {
        if (!comparisonObject(sourceObj[i], compareObj[i])) return false;
      }
    } else if (sourceType === "Object") {
      let sourceKeyList = Reflect.ownKeys(sourceObj);
      let compareKeyList = Reflect.ownKeys(compareObj);
      let key;
      if (sourceKeyList.length !== compareKeyList.length) return false;
      for (let i = 0; i < sourceKeyList.length; i++) {
        key = sourceKeyList[i];
        if (key !== compareKeyList[i]) return false;
        if (!comparisonObject(sourceObj[key], compareObj[key])) return false;
      }
    } else if (sourceType === "Set" || sourceType === "Map") {
      // 把 Set Map 转为 Array
      if (!comparisonObject(Array.from(sourceObj), Array.from(compareObj))) return false;
    }
    return true;
  }

  describe('originTest', function () {
    _it('exposes a `prefixed` property', 0, function () {
      var arr = [false, '~']
      expect(EventEmitter.prefixed === arr[0] || EventEmitter.prefixed === arr[1]).assertTrue()
    });

    _it('exposes a module namespace object', 0, function () {
      expect(EventEmitter.EventEmitter).assertEqual(EventEmitter)
    });

    _it('inherits when used with `require("util").inherits`', 0, function () {

      // function Beast() {
      //   EventEmitter.call(this);
      // }
      //
      // require('util').inherits(Beast, EventEmitter);

      var moop = new Beast()
        , meap = new Beast();

      expect(moop instanceof Beast).assertTrue();
      expect(moop instanceof EventEmitter).assertTrue();

      // @ts-ignore
      moop.listeners();
      // @ts-ignore
      meap.listeners();

      moop.on('data', function () {
        throw new Error('I should not emit');
      });

      meap.emit('data', 'rawr');
      meap.removeListener('foo');
      meap.removeAllListeners();
    });

    if ('undefined' !== typeof Symbol) {
      _it('works with ES6 symbols', 0, function () {
        var e = new EventEmitter()
          , event = Symbol('cows')
          , unknown = Symbol('moo');

        e.on(event, function foo(arg) {
          expect(e.listenerCount(unknown)).assertEqual(0)
          expect(e.listeners(unknown)).assertDeepEquals([])
          expect(arg).assertEqual('bar')

          function bar(onced) {
            expect(e.listenerCount(unknown)).assertEqual(0)
            expect(e.listeners(unknown)).assertDeepEquals([])
            expect(onced).assertEqual('foo')
          }

          e.once(unknown, bar);

          expect(e.listenerCount(event)).assertEqual(1)
          expect(e.listeners(event)).assertDeepEquals([foo])
          expect(e.listenerCount(unknown)).assertEqual(1)
          expect(e.listeners(unknown)).assertDeepEquals([bar])

          e.removeListener(event);

          expect(e.listenerCount(event)).assertEqual(0)
          expect(e.listeners(event)).assertDeepEquals([])
          expect(e.emit(unknown, 'foo')).assertTrue()
        });
        expect(e.emit(unknown, 'bar')).assertFalse()
        expect(e.emit(event, 'bar')).assertTrue()
      });
    }

    _it('should return false when there are not events to emit', 0, function () {
      var e = new EventEmitter();
      expect(e.emit('foo')).assertFalse()
      expect(e.emit('bar')).assertFalse()
    });

    _it('emits with context', 0, function (done) {
      var context = {
        bar: 'baz'
      }, e = new EventEmitter();

      e.on('foo', function (bar) {
        expect(bar).assertEqual('bar')
        expect(this).assertEqual(context)
        done();
      }, context).emit('foo', 'bar');
    });

    _it('emits with context, multiple arguments (force apply)', 0, function (done) {
      var context = {
        bar: 'baz'
      }, e = new EventEmitter();

      e.on('foo', function (bar) {
        expect(bar).assertEqual('bar')
        expect(this).assertEqual(context)
        done();
      }, context).emit('foo', 'bar', 1, 2, 3, 4, 5, 6, 7, 8, 9, 0);
    });

    _it('can emit the function with multiple arguments', 0, function () {
      var e = new EventEmitter();

      for (var i = 0; i < 100; i++) {
        (function (j) {
          for (var i = 0, args = []; i < j; i++) {
            args.push(j);
          }

          e.once('args', function () {
            expect(arguments.length).assertEqual(args.length)
          });

          e.emit.apply(e, ['args'].concat(args));
        })(i);
      }
    });

    _it('can emit the function with multiple arguments, multiple listeners', 0, function () {
      var e = new EventEmitter();

      for (var i = 0; i < 100; i++) {
        (function (j) {
          for (var i = 0, args = []; i < j; i++) {
            args.push(j);
          }

          e.once('args', function () {
            expect(arguments.length).assertEqual(args.length)
          });

          e.once('args', function () {
            expect(arguments.length).assertEqual(args.length)
          });

          e.once('args', function () {
            expect(arguments.length).assertEqual(args.length)
          });

          e.once('args', function () {
            expect(arguments.length).assertEqual(args.length)
          });

          e.emit.apply(e, ['args'].concat(args));
        })(i);
      }
    });

    _it('emits with context, multiple listeners (force loop)', 0, function () {
      var e = new EventEmitter();

      e.on('foo', function (bar) {
        let result = comparisonObject(this, {
          foo: 'bar'
        })
        expect(result).assertTrue()
        expect(bar).assertEqual('bar')
      }, {
        foo: 'bar'
      });

      e.on('foo', function (bar) {
        let result = comparisonObject(this, {
          bar: 'baz'
        })
        expect(result).assertTrue()
        expect(bar).assertEqual('bar')
      }, {
        bar: 'baz'
      });

      e.emit('foo', 'bar');
    });

    _it('emits with different contexts', 0, function () {
      var e = new EventEmitter()
        , pattern = '';

      function writer() {
        pattern += this;
      }

      e.on('write', writer, 'foo');
      e.on('write', writer, 'baz');
      e.once('write', writer, 'bar');
      e.once('write', writer, 'banana');

      e.emit('write');
      expect(pattern).assertEqual('foobazbarbanana')
    });

    _it('should return true when there are events to emit', 0, function () {
      var e = new EventEmitter()
        , called = 0;

      e.on('foo', function () {
        called++;
      });
      expect(e.emit('foo')).assertTrue()
      expect(e.emit('foob')).assertFalse()
      expect(called).assertEqual(1)
    });

    _it('receives the emitted events', 0, function (done) {
      var e = new EventEmitter();

      e.on('data', function (a, b, c, d, undef) {
        expect(a).assertEqual('foo')
        expect(b).assertEqual(e)
        expect(c instanceof Date).assertTrue()
        expect(undef).assertEqual(undefined)
        expect(arguments.length).assertEqual(3)

        done();
      });

      e.emit('data', 'foo', e, new Date());
    });

    _it('emits to all event listeners', 0, function () {
      var e = new EventEmitter()
        , pattern = [];

      e.on('foo', function () {
        pattern.push('foo1');
      });

      e.on('foo', function () {
        pattern.push('foo2');
      });

      e.emit('foo');
      expect(pattern.join(';')).assertEqual('foo1;foo2')
    });

    (function each(keys) {
      var key = keys.shift();

      if (!key) return;

      _it('can store event which is a known property: ' + key, 0, function (next) {
        var e = new EventEmitter();

        e.on(key, function (k) {
          expect(k).assertEqual(key)
          next();
        }).emit(key, key);
      });

      each(keys);
    })([
      'hasOwnProperty',
      'constructor',
      '__proto__',
      'toString',
      'toValue',
      'unwatch',
      'watch'
    ]);
    _it('returns an empty array if no listeners are specified', 0, function () {
      var e = new EventEmitter();
      expect(e.listeners('foo') instanceof Array).assertTrue()
      expect(e.listeners('foo').length).assertEqual(0)
    });

    _it('returns an array of function', 0, function () {
      var e = new EventEmitter();

      function foo() {
      }

      e.on('foo', foo);
      expect(e.listeners('foo') instanceof Array).assertTrue()
      expect(e.listeners('foo').length).assertEqual(1)
      expect(e.listeners('foo')).assertDeepEquals([foo])
    });

    _it('is not vulnerable to modifications', 0, function () {
      var e = new EventEmitter();

      function foo() {
      }

      e.on('foo', foo);
      expect(e.listeners('foo')).assertDeepEquals([foo])

      e.listeners('foo').length = 0;
      expect(e.listeners('foo')).assertDeepEquals([foo])
    });
    _it('returns the number of listeners for a given event', 0, function () {
      var e = new EventEmitter();
      // @ts-ignore
      expect(e.listenerCount()).assertEqual(0)
      expect(e.listenerCount('foo')).assertEqual(0)

      e.on('foo', function () {
      });
      expect(e.listenerCount('foo')).assertEqual(1)
      e.on('foo', function () {
      });
      expect(e.listenerCount('foo')).assertEqual(2)
    });
    _it('throws an error if the listener is not a function', 0, function () {
      var e = new EventEmitter();

      try {
        // @ts-ignore
        e.on('foo', 'bar');
      } catch (ex) {
        expect(ex instanceof TypeError).assertTrue()
        expect(ex.message).assertEqual('The listener must be a function')
        return;
      }

      throw new Error('oops');
    });
    _it('only emits it once', 0, function () {
      var e = new EventEmitter()
        , calls = 0;

      e.once('foo', function () {
        calls++;
      });

      e.emit('foo');
      e.emit('foo');
      e.emit('foo');
      e.emit('foo');
      e.emit('foo');
      expect(e.listeners('foo').length).assertEqual(0)
      expect(calls).assertEqual(1)
    });

    _it('only emits once if emits are nested inside the listener', 0, function () {
      var e = new EventEmitter()
        , calls = 0;

      e.once('foo', function () {
        calls++;
        e.emit('foo');
      });

      e.emit('foo');
      expect(e.listeners('foo').length).assertEqual(0)
      expect(calls).assertEqual(1)
    });

    _it('only emits once for multiple events', 0, function () {
      var e = new EventEmitter()
        , multi = 0
        , foo = 0
        , bar = 0;

      e.once('foo', function () {
        foo++;
      });

      e.once('foo', function () {
        bar++;
      });

      e.on('foo', function () {
        multi++;
      });

      e.emit('foo');
      e.emit('foo');
      e.emit('foo');
      e.emit('foo');
      e.emit('foo');
      expect(e.listeners('foo').length).assertEqual(1)
      expect(multi).assertEqual(5)
      expect(foo).assertEqual(1)
      expect(bar).assertEqual(1)
    });

    _it('only emits once with context', 0, function (done) {
      var context = {
        foo: 'bar'
      }
        , e = new EventEmitter();

      e.once('foo', function (bar) {
        expect(this).assertEqual(context)
        expect(bar).assertEqual('bar')

        done();
      }, context).emit('foo', 'bar');
    });
    _it('removes all listeners when the listener is not specified', 0, function () {
      var e = new EventEmitter();

      e.on('foo', function () {
      });
      e.on('foo', function () {
      });
      expect(e.removeListener('foo')).assertEqual(e)
      let result = comparisonObject(e.listeners('foo'), [])
      expect(result).assertTrue();
    });

    _it('removes only the listeners matching the specified listener', 0, function () {
      var e = new EventEmitter();

      function foo() {
      }

      function bar() {
      }

      function baz() {
      }

      e.on('foo', foo);
      e.on('bar', bar);
      e.on('bar', baz);
      expect(e.removeListener('foo', bar)).assertEqual(e)
      let result0 = comparisonObject(e.listeners('bar'), [bar, baz])
      expect(result0).assertTrue();

      let result1 = comparisonObject(e.listeners('foo'), [foo])
      expect(result1).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(2)

      expect(e.removeListener('foo', foo)).assertEqual(e)
      let result2 = comparisonObject(e.listeners('bar'), [bar, baz])
      expect(result2).assertTrue();

      let result3 = comparisonObject(e.listeners('foo'), [])
      expect(result3).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)

      expect(e.removeListener('bar', bar)).assertEqual(e)
      let result4 = comparisonObject(e.listeners('bar'), [baz])
      expect(result4).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)

      expect(e.removeListener('bar', baz)).assertEqual(e)
      let result5 = comparisonObject(e.listeners('bar'), [])
      expect(result5).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(0)

      e.on('foo', foo);
      e.on('foo', foo);
      e.on('bar', bar);

      expect(e.removeListener('foo', foo)).assertEqual(e)
      let result6 = comparisonObject(e.listeners('bar'), [bar])
      expect(result6).assertTrue();

      let result7 = comparisonObject(e.listeners('foo'), [])
      expect(result7).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)
    });

    _it('removes only the once listeners when using the once flag', 0, function () {
      var e = new EventEmitter();

      function foo() {
      }

      e.on('foo', foo);
      expect(e.removeListener('foo', function () {
      }, undefined, true)).assertEqual(e)
      let result0 = comparisonObject(e.listeners('foo'), [foo])
      expect(result0).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)

      expect(e.removeListener('foo', foo, undefined, true)).assertEqual(e)
      let result1 = comparisonObject(e.listeners('foo'), [foo])
      expect(result1).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)

      expect(e.removeListener('foo', foo)).assertEqual(e)
      let result2 = comparisonObject(e.listeners('foo'), [])
      expect(result2).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(0)

      e.once('foo', foo);
      e.on('foo', foo);

      expect(e.removeListener('foo', function () {
      }, undefined, true)).assertEqual(e)
      let result3 = comparisonObject(e.listeners('foo'), [foo, foo])
      expect(result3).assertTrue();

      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)

      expect(e.removeListener('foo', foo, undefined, true)).assertEqual(e)
      let result4 = comparisonObject(e.listeners('foo'), [foo])
      expect(result4).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)

      e.once('foo', foo);

      expect(e.removeListener('foo', foo)).assertEqual(e)
      let result5 = comparisonObject(e.listeners('foo'), [])
      expect(result5).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(0)
    });

    _it('removes only the listeners matching the correct context', 0, function () {
      var context = {
        foo: 'bar'
      }
        , e = new EventEmitter();

      function foo() {
      }

      function bar() {
      }

      e.on('foo', foo, context);
      expect(e.removeListener('foo', function () {
      }, context)).assertEqual(e)
      let result0 = comparisonObject(e.listeners('foo'), [foo])
      expect(result0).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)

      expect(e.removeListener('foo', foo, {
        baz: 'quux'
      })).assertEqual(e)
      let result1 = comparisonObject(e.listeners('foo'), [foo])
      expect(result1).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)

      expect(e.removeListener('foo', foo, context)).assertEqual(e)
      let result2 = comparisonObject(e.listeners('foo'), [])
      expect(result2).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(0)

      e.on('foo', foo, context);
      e.on('foo', bar);

      expect(e.removeListener('foo', foo, {
        baz: 'quux'
      })).assertEqual(e)
      let result3 = comparisonObject(e.listeners('foo'), [foo, bar])
      expect(result3).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)

      expect(e.removeListener('foo', foo, context)).assertEqual(e)
      let result4 = comparisonObject(e.listeners('foo'), [bar])
      expect(result4).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)

      e.on('foo', bar, context);

      expect(e.removeListener('foo', bar)).assertEqual(e)
      let result5 = comparisonObject(e.listeners('foo'), [])
      expect(result5).assertTrue();
      // @ts-ignore
      expect(e._eventsCount).assertEqual(0)
    });

    _it('removes all events for the specified events', 0, function () {
      var e = new EventEmitter();

      e.on('foo', function () {
        throw new Error('oops');
      });
      e.on('foo', function () {
        throw new Error('oops');
      });
      e.on('bar', function () {
        throw new Error('oops');
      });
      e.on('aaa', function () {
        throw new Error('oops');
      });
      expect(e.removeAllListeners('foo')).assertEqual(e)
      expect(e.listeners('foo').length).assertEqual(0)
      expect(e.listeners('bar').length).assertEqual(1)
      expect(e.listeners('aaa').length).assertEqual(1)
      // @ts-ignore
      expect(e._eventsCount).assertEqual(2)

      expect(e.removeAllListeners('bar')).assertEqual(e)
      // @ts-ignore
      expect(e._eventsCount).assertEqual(1)
      expect(e.removeAllListeners('aaa')).assertEqual(e)
      // @ts-ignore
      expect(e._eventsCount).assertEqual(0)

      expect(e.emit('foo')).assertFalse()
      expect(e.emit('bar')).assertFalse()
      expect(e.emit('aaa')).assertFalse()
    });

    _it('just nukes the fuck out of everything', 0, function () {
      var e = new EventEmitter();

      e.on('foo', function () {
        throw new Error('oops');
      });
      e.on('foo', function () {
        throw new Error('oops');
      });
      e.on('bar', function () {
        throw new Error('oops');
      });
      e.on('aaa', function () {
        throw new Error('oops');
      });
      expect(e.removeAllListeners()).assertEqual(e)
      expect(e.listeners('foo').length).assertEqual(0)
      expect(e.listeners('bar').length).assertEqual(0)
      expect(e.listeners('aaa').length).assertEqual(0)
      // @ts-ignore
      expect(e._eventsCount).assertEqual(0)

      expect(e.emit('foo')).assertFalse()
      expect(e.emit('bar')).assertFalse()
      expect(e.emit('aaa')).assertFalse()
    });
    _it('returns an empty array when there are no events', 0, function () {
      var e = new EventEmitter();
      let resutl0 = comparisonObject(e.eventNames(), [])
      expect(resutl0).assertTrue()

      e.on('foo', function () {
      });
      e.removeAllListeners('foo');

      let resutl1 = comparisonObject(e.eventNames(), [])
      expect(resutl1).assertTrue()
    });

    _it('returns an array listing the events that have listeners', 0, function () {
      var e = new EventEmitter()
        , original;

      function bar() {
      }

      if (Object.getOwnPropertySymbols) {
        //
        // Monkey patch `Object.getOwnPropertySymbols()` to increase coverage
        // on Node.js > 0.10.
        //
        original = Object.getOwnPropertySymbols;
        Object.getOwnPropertySymbols = undefined;
      }

      e.on('foo', function () {
      });
      e.on('bar', bar);

      try {
        let resutl0 = comparisonObject(e.eventNames(), ['foo', 'bar'])
        expect(resutl0).assertTrue()
        e.removeListener('bar', bar);
        let resutl1 = comparisonObject(e.eventNames(), ['foo'])
        expect(resutl1).assertTrue()
      } catch (ex) {
        throw ex;
      } finally {
        if (original) Object.getOwnPropertySymbols = original;
      }
    });

    _it('does not return inherited property identifiers', 0, function () {
      var e = new EventEmitter();

      function Collection() {
      }

      Collection.prototype.foo = function () {
        return 'foo';
      };

      // @ts-ignore
      e._events = new Collection();
      // @ts-ignore
      expect(e._events.foo()).assertEqual('foo')
      let resutl0 = comparisonObject(e.eventNames(), [])
      expect(resutl0).assertTrue()
    });

    if ('undefined' !== typeof Symbol) {
      _it('includes ES6 symbols', 0, function () {
        var e = new EventEmitter()
          , s = Symbol('s');

        function foo() {
        }

        e.on('foo', foo);
        e.on(s, function () {
        });
        let resutl0 = comparisonObject(e.eventNames(), ['foo', s])
        expect(resutl0).assertTrue()

        e.removeListener('foo', foo);
        let resutl1 = comparisonObject(e.eventNames(), [s])
        expect(resutl1).assertTrue()
      });
    }


  })
}