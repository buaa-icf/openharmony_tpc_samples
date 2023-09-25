/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { after, ary, before, bind, bindKey, curry, curryRight, debounce, defer, delay,
  filter,
  flip,
  identity,
  initial,
  last,
  map,
  memoize,
  negate,
  once,
  overArgs,
  partial,
  partialRight,
  rearg,
  rest,
  size,
  slice,
  spread,
  throttle,
  toArray,
  unary,
  wrap,
  escape
} from 'lodash';

export default function functionTest() {
  describe('FunctionTest', function () {
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
    it('afterTest01',0, function () {
      let saves = ['profile', 'settings'];
      let done = after(saves.length, function() {
        console.log('done saving!');
      });
      expect(done()).assertUndefined()
    })

    it('afterTest02',0, function () {
      let done = after(0, function() {
      });
      expect(done()).assertUndefined()
    })

    it('aryTest01',0, function () {
      let aryArray = map(['6', '8', '10'], ary(parseInt, 1));
      expect(JSON.stringify(aryArray)).assertEqual('[6,8,10]');
    })

    it('aryTest02',0, function () {
      let aryArray = map(['7', '0', '34'], ary(parseInt, 1));
      expect(JSON.stringify(aryArray)).assertEqual('[7,0,34]');
    })

    it('beforeTest01',0, function () {
      let befores = before(1, function () {
        console.log('Saved');
      });
      expect(befores()).assertUndefined();
    })

    it('beforeTest02',0, function () {
      let befores = before(3, function () {
      });
      expect(befores()).assertUndefined();
    })

    it('bindTest01',0, function () {
      let greet = function(greeting, punctuation) {
        return greeting + ' ' + this.user + punctuation;
      };
      let object = { 'user': 'fred' };
      let bound = bind(greet, object, 'hi');
      expect(JSON.stringify(bound('!'))).assertEqual('"hi fred!"');
    })

    it('bindTest02',0, function () {
      let greet = function(greeting, punctuation) {
        return greeting + ' ' + this.user + punctuation;
      };
      let object = { 'user': 'fred' };
      let bound = bind(greet, object, '!');
      expect(JSON.stringify(bound('hi'))).assertEqual('"! fredhi"');
    })

    it('bindKeyTest01',0, function () {
      let object = {
        'user': 'fred',
        'greet': function(greeting, punctuation) {
          return greeting + ' ' + this.user + punctuation;
        }
      };
      let bound = bindKey(object, 'greet', 'hi');
      bound('!');
      expect(bound('!')).assertEqual('hi fred!');
    })

    it('bindKeyTest02',0, function () {
      let object = {
        'user': 'fred',
        'greet': function(greeting, punctuation) {
          return greeting + ' ' + this.user + punctuation;
        }
      };
      let bound = bindKey(object, 'greet', 'hi');
      object.greet = function(greeting, punctuation) {
        return greeting + 'ya ' + this.user + punctuation;
      };
      expect(bound('!')).assertEqual('hiya fred!');
    })

    it('curryTest01',0, function () {
      let abc = function(a, b, c) {
        return [a, b, c];
      };
      let curried = curry(abc);
      expect(JSON.stringify(curried(1)(2)(3))).assertEqual('[1,2,3]');
    })

    it('curryTest02',0, function () {
      let abc = function(a, b, c) {
        return [a, b, c];
      };
      let curried = curry(abc);
      expect(JSON.stringify(curried(1, 2)(3))).assertEqual('[1,2,3]');
    })

    it('curryRightTest01',0, function () {
      let abc = function(a, b, c) {
        return [a, b, c];
      };
      let curried = curryRight(abc);
      expect(JSON.stringify(curried(1)(2)(3))).assertEqual('[3,2,1]');
    })

    it('curryRightTest02',0, function () {
      let abc = function(a, b, c) {
        return [a, b, c];
      };
      let curried = curryRight(abc);
      expect(JSON.stringify(curried(1, 2, 3))).assertEqual('[1,2,3]');
    })

    it('debounceTest01',0, function () {
      let debounced = debounce(function () {
        console.log('Function debounced after 1000ms!');
      }, 1000);
      expect(JSON.stringify(debounced)).assertUndefined();
    })

    it('debounceTest02',0, function () {
      let debounced = debounce(function () {
        console.log('Function debounced after 1000ms!');
      }, 0);
      expect(JSON.stringify(debounced)).assertUndefined();
    })

    it('deferTest01',0, function () {
      let deferString = defer(function(text) {
        console.log(text);
      }, 'deferred');
      expect(deferString).assertEqual(52);
    })

    it('deferTest02',0, function () {
      let deferString = defer(function(content) {
        console.log(content);
      }, 'GeeksforGeeks!');
      expect(deferString).assertEqual(56);
    })

    it('delayTest',0, function () {
      delay(function(text) {
        expect(text).assertEqual('later');
        console.log(text);
      }, 1000, 'later');
    })

    it('flipTest01',0, function () {
      let flipped = flip(function() {
        return toArray(arguments);
      });
      expect(JSON.stringify(flipped('a', 'b', 'c', 'd'))).assertEqual('["d","c","b","a"]');
    })

    it('flipTest02',0, function () {
      let flipped = flip(function() {
        return toArray(arguments);
      });
      expect(JSON.stringify(flipped('hello', 'world'))).assertEqual('["world","hello"]');
    })

    it('memoizeTest01',0, function () {
      let sum = memoize(function (n) {
        return n < 1 ? n:n + sum(n - 1);
      })
      expect(sum(6)).assertEqual(21);
    })

    it('memoizeTest02',0, function () {
      let sum = memoize(function (n) {
        return n < 1 ? n:n + sum(n - 1);
      })
      expect(sum(1)).assertEqual(1);
    })

    it('negateTest01',0, function () {
      function isEven(n) {
        return n % 2 == 0;
      }
      let filterArray = filter([1, 2, 3, 4, 5, 6], negate(isEven));
      expect(JSON.stringify(filterArray)).assertEqual('[1,3,5]');
    })

    it('negateTest02',0, function () {
      function isEven(n) {
        return n % 2 == 1;
      }
      let filterArray = filter([9,31,23,3,3,2,12,24,4,46,9,13], negate(isEven));
      expect(JSON.stringify(filterArray)).assertEqual('[2,12,24,4,46]');
    })

    it('onceTest01',0, function () {
      let count = 0;
      let onces = once(function() {
        onces();
        return ++count;
      });
      expect(onces()).assertEqual(1);
    })

    it('onceTest02',0, function () {
      let count = 0;
      let onces = once(function() {
        onces();
        return ++count;
      });
      expect(count).assertEqual(0);
    })

    it('overArgsTest01',0, function () {
      function doubled(n) {
        return n * 2;
      }
      function square(n) {
        return n * n;
      }
      let func = overArgs(function(x, y) {
        return [x, y];
      }, [square, doubled]);
      expect(JSON.stringify(func(9, 3))).assertEqual('[81,6]');
    })

    it('overArgsTest02',0, function () {
      function doubled(n) {
        return n * 2;
      }
      function square(n) {
        return n * n;
      }
      let func = overArgs(function(x, y) {
        return [x, y];
      }, [square, doubled]);
      expect(JSON.stringify(func(10, 5))).assertEqual('[100,10]');
    })

    it('partialTest01',0, function () {
      let greet = function(greeting, name) {
        return greeting + ' ' + name;
      };
      let sayHelloTo = partial(greet, 'hello');
      expect(sayHelloTo('fred')).assertEqual('hello fred');
    })

    it('partialTest02',0, function () {
      let greet = function(greeting, name) {
        return greeting + ' ' + name;
      };
      let greetFred = partial(greet, 'GeeksforGeeks');
      expect(greetFred('is a computer science portal for geeks')).assertEqual('GeeksforGeeks is a computer science portal for geeks');
    })

    it('partialRightTest01',0, function () {
      let greet = function(greeting, name) {
        return greeting + ' ' + name;
      };
      let greetFred = partialRight(greet, 'fred');
      expect(greetFred('hi')).assertEqual('hi fred');
    })

    it('partialRightTest02',0, function () {
      let greet = function(greeting, name) {
        return greeting + ' ' + name;
      };
      let greetFred = partialRight(greet, 'GeeksforGeeks');
      expect(greetFred('is a computer science portal for geeks')).assertEqual('is a computer science portal for geeks GeeksforGeeks');
    })

    it('reargTest01',0, function () {
      let rearged = rearg(function(a, b, c) {
        return [a, b, c];
      }, [2, 0, 1]);
      expect(JSON.stringify(rearged('b', 'c', 'a'))).assertEqual('["a","b","c"]');
    })

    it('reargTest02',0, function () {
      let rearged = rearg(function(a, b, c) {
        return [a, b, c];
      }, [2, 5, 8]);
      expect(JSON.stringify(rearged('hello', 'world', '!'))).assertEqual('["!",null,null]');
    })

    it('restTest01',0, function () {
      let say = rest(function(what, names) {
        return what + ' ' + initial(names).join(', ') +
          (size(names) > 1 ? ', & ' : '') + last(names);
      });
      expect(say('hello', 'fred', 'barney', 'pebbles')).assertEqual('hello fred, barney, & pebbles');
    })

    it('restTest02',0, function () {
      let say = rest(function(what, names) {
        return what + ' ' + initial(names).join(', ') +
          (size(names) > 1 ? ', & ' : '') + last(names);
      });
      expect(say('hello', '!', 'world', '&', 'pebbles')).assertEqual('hello !, world, &, & pebbles');
    })

    it('spreadTest01',0, function () {
      let say = spread(function(who, what) {
        return who + ' says ' + what;
      });
      expect(say(['fred', 'hello'])).assertEqual('fred says hello');
    })

    it('spreadTest02',0, function () {
      let numbers = Promise.all([
      Promise.resolve(40),
      Promise.resolve(36)
      ]);
      let spreadString = numbers.then(spread(function(x, y) {
        return x + y;
      }));
      expect(JSON.stringify(spreadString)).assertEqual('{}');
    })

    it('throttleTest01',0, function () {
      let throttled = throttle(identity, 32),
        results = [throttled('a'), throttled('b')];
        expect(JSON.stringify(results)).assertEqual('["a","a"]');
    })

    it('throttleTest02',0, function (done) {
      let callCount = 0,
        throttled = throttle(function() { callCount++; }, 32, {});
        throttled();
        throttled();
        expect(callCount).assertEqual(1);
        setTimeout(function() {
          expect(callCount).assertEqual(2);
          done();
        }, 128);
    })

    it('unaryTest01',0, function () {
      let unaryArray = map(['6', '8', '10'], unary(parseInt));
      expect(JSON.stringify(unaryArray)).assertEqual('[6,8,10]');
    })

    it('unaryTest02',0, function () {
      let unaryArray = map(['231', '1', '99'], unary(parseInt));
      expect(JSON.stringify(unaryArray)).assertEqual('[231,1,99]');
    })

    it('wrapTest01',0, function () {
      let args;
      let wrapped = wrap(function() {}, function() {
        args || (args = slice.call(arguments));
      });

      wrapped(1, 2, 3);
      expect(JSON.stringify(args)).assertEqual('[]');
    })

    it('wrapTest02',0, function () {
      var p = wrap(escape, function(func, text) {
        return '<p>' + func(text) + '</p>';
      });
      expect(p('fred, barney, & pebbles')).assertEqual('<p>fred, barney, &amp; pebbles</p>');
    })
  })
}