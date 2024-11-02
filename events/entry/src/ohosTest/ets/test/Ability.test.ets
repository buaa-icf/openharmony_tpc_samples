/*
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import * as event from 'events'
import {EventEmitter} from 'events'

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    let emitter: ESObject = new event.EventEmitter();
    emitter.on('foo', () => {
    });
    emitter.on('foo', () => {
    });
    emitter.on('baz', () => {
    });
    // Allow any type
    emitter.on(123, () => {
    });

    it('test1', 0, () => {
      expect(EventEmitter.listenerCount(emitter, 'foo')).assertEqual(2)
    })
    it('test2', 0, () => {
      expect(emitter.listenerCount('foo')).assertEqual(2)
    })
    it('test3', 0, () => {
      expect(emitter.listenerCount('bar')).assertEqual(0)
    })
    it('test4', 0, () => {
      expect(emitter.listenerCount('baz')).assertEqual(1)
    })
    it('test5', 0, () => {
      expect(emitter.listenerCount('123')).assertEqual(1)
    })

    let e1: ESObject = new event.EventEmitter();
    let fl: ESObject;
    e1.on('foo', () => {
    });

    fl = e1.listeners('foo');
    it('test6', 0, () => {
      expect(fl.length).assertEqual(1)
    })

    let listener = () => {
    }
    let listener2 = () => {
    }
    let listener3 = () => {
      return 0;
    }
    let listener4 = () => {
      return 1;
    }
    it('test7', 0, () => {
      let ee: ESObject = new event.EventEmitter();
      ee.on('foo', listener);
      let fooListeners: ESObject = ee.listeners('foo');

      let listeners: ESObject = ee.listeners('foo');
      expect(typeof listeners).assertEqual('object')
      expect(listeners.length).assertEqual(1)
      expect(listeners[0]).assertEqual(listener)
      ee.removeAllListeners('foo');
      listeners = ee.listeners('foo');
      expect(typeof listeners).assertEqual('object')
      expect(listeners.length).assertEqual(0)

      expect(typeof fooListeners).assertEqual('object')
      expect(fooListeners.length).assertEqual(1)
      expect(fooListeners[0]).assertEqual(listener)
    })

    it('test8', 0, () => {
      let ee: ESObject = new event.EventEmitter();
      ee.on('foo', listener);
      let eeListenersCopy: ESObject = ee.listeners('foo');

      let listeners: ESObject = ee.listeners('foo');
      expect(typeof listeners).assertEqual('object')
      expect(listeners.length).assertEqual(1)
      expect(listeners[0]).assertEqual(listener)
      eeListenersCopy.push(listener2);
      listeners = ee.listeners('foo');
      expect(typeof listeners).assertEqual('object')
      expect(listeners.length).assertEqual(1)

      expect(typeof eeListenersCopy).assertEqual('object')
      expect(eeListenersCopy.length).assertEqual(2)
      expect(eeListenersCopy[0]).assertEqual(listener)
    })


    it('test9', 0, () => {
      let ee: ESObject = new event.EventEmitter();
      ee.on('foo', listener);
      let eeListenersCopy: ESObject = ee.listeners('foo');
      ee.on('foo', listener2);


      let listeners: ESObject = ee.listeners('foo');
      expect(typeof listeners).assertEqual('object')
      expect(listeners.length).assertEqual(2)
      expect(listeners[0]).assertEqual(listener)
      expect(listeners[1]).assertEqual(listener2)

      expect(typeof eeListenersCopy).assertEqual('object')
      expect(eeListenersCopy.length).assertEqual(1)
      expect(eeListenersCopy[0]).assertEqual(listener)
    })

    it('test10', 0, () => {
      let ee: ESObject = new event.EventEmitter();
      ee.once('foo', listener);
      let listeners: ESObject = ee.listeners('foo');
      expect(typeof listeners).assertEqual('object')
      expect(listeners.length).assertEqual(1)
      expect(listeners[0]).assertEqual(listener)

    })

    it('test11', 0, () => {
      let ee: ESObject = new event.EventEmitter();
      ee.on('foo', listener);

      ee.once('foo', listener2);
      let listeners: ESObject = ee.listeners('foo');
      expect(typeof listeners).assertEqual('object')
      expect(listeners.length).assertEqual(2)
      expect(listeners[0]).assertEqual(listener)
      expect(listeners[1]).assertEqual(listener2)
    })

    it('test12', 0, () => {
      let ee: ESObject = new event.EventEmitter();
      ee._events = undefined;
      let listeners: ESObject = ee.listeners('foo');
      expect(typeof listeners).assertEqual('object')
      expect(listeners.length).assertEqual(0)
    })

    it('test13', 0, () => {
      let ee: ESObject = new event.EventEmitter();
      ee.on('foo', listener);
      let wrappedListener: ESObject = ee.rawListeners('foo');
      expect(wrappedListener.length).assertEqual(1)
      expect(wrappedListener[0]).assertEqual(listener)
      ee.once('foo', listener);
      let wrappedListeners: ESObject = ee.rawListeners('foo');
      expect(wrappedListeners.length).assertEqual(2)
      expect(wrappedListeners[0]).assertEqual(listener)
      expect(wrappedListeners[1].listener).assertEqual(listener)
      ee.emit('foo');
      expect(wrappedListeners.length).assertEqual(2)
      expect(wrappedListeners[1].listener).assertEqual(listener)
    })

    it('test14', 0, () => {
      let ee: ESObject = new event.EventEmitter();
      ee.once('foo', listener3);
      ee.on('foo', listener4);

      let rawListeners: ESObject = ee.rawListeners('foo');
      expect(rawListeners.length).assertEqual(2)
      expect(rawListeners[0]()).assertEqual(0)
      let rawListener: ESObject = ee.rawListeners('foo');
      expect(rawListener.length).assertEqual(1)
      expect(rawListener[0]()).assertEqual(1)
    })


    it('test15', 0, () => {
      let callbacks_called: ESObject[] = [];
      let e: ESObject = new event.EventEmitter();

      let callback1 = () => {
        callbacks_called.push('callback1');
        e.on('foo', callback2);
        e.on('foo', callback3);
        e.removeListener('foo', callback1);
      }

      let callback2 = () => {
        callbacks_called.push('callback2');
        e.removeListener('foo', callback2);
      }

      let callback3 = () => {
        callbacks_called.push('callback3');
        e.removeListener('foo', callback3);
      }

      e.on('foo', callback1);
      expect(e.listeners('foo').length).assertEqual(1)


      e.emit('foo');
      expect(e.listeners('foo').length).assertEqual(2)
      expect(typeof callbacks_called).assertEqual('object')
      expect(callbacks_called.length).assertEqual(1)
      expect(callbacks_called[0]).assertEqual('callback1')

      e.emit('foo');
      expect(e.listeners('foo').length).assertEqual(0)
      expect(typeof callbacks_called).assertEqual('object')
      expect(callbacks_called.length).assertEqual(3)
      expect(callbacks_called[0]).assertEqual('callback1')
      expect(callbacks_called[1]).assertEqual('callback2')
      expect(callbacks_called[2]).assertEqual('callback3')


      e.emit('foo');
      expect(e.listeners('foo').length).assertEqual(0)
      expect(typeof callbacks_called).assertEqual('object')
      expect(callbacks_called.length).assertEqual(3)
      expect(callbacks_called[0]).assertEqual('callback1')
      expect(callbacks_called[1]).assertEqual('callback2')
      expect(callbacks_called[2]).assertEqual('callback3')

      e.on('foo', callback1);
      e.on('foo', callback2);
      expect(e.listeners('foo').length).assertEqual(2)
      e.removeAllListeners('foo');
      expect(e.listeners('foo').length).assertEqual(0)

      // Verify that removing callbacks while in emit allows emits to propagate to
      // all listeners
      callbacks_called = [];

      e.on('foo', callback2);
      e.on('foo', callback3);
      expect(e.listeners('foo').length).assertEqual(2)
      e.emit('foo');
      expect(typeof callbacks_called).assertEqual('object')
      expect(callbacks_called.length).assertEqual(2)
      expect(callbacks_called[0]).assertEqual('callback2')
      expect(callbacks_called[1]).assertEqual('callback3')
      expect(e.listeners('foo').length).assertEqual(0)


    })

    it('test16', 0, () => {
      let e: ESObject = new event.EventEmitter();
      let num_args_emitted: ESObject[] = [];

      e.on('numArgs', () => {
        let numArgs = arguments.length;
        num_args_emitted.push(numArgs);
      });

      e.on('foo', () => {
        num_args_emitted.push(arguments.length);
      });

      e.on('foo', () => {
        num_args_emitted.push(arguments.length);
      });

      e.emit('numArgs');
      e.emit('numArgs', null);
      e.emit('numArgs', null, null);
      e.emit('numArgs', null, null, null);
      e.emit('numArgs', null, null, null, null);
      e.emit('numArgs', null, null, null, null, null);

      e.emit('foo', null, null, null, null);

      expect(typeof num_args_emitted).assertEqual('object')
      expect(num_args_emitted.length).assertEqual(8)
      expect(num_args_emitted[0]).assertEqual(0)
      expect(num_args_emitted[1]).assertEqual(0)
      expect(num_args_emitted[2]).assertEqual(0)
      expect(num_args_emitted[3]).assertEqual(0)
      expect(num_args_emitted[4]).assertEqual(0)
      expect(num_args_emitted[5]).assertEqual(0)
      expect(num_args_emitted[6]).assertEqual(0)
    })

    it('test17', 0, () => {
      let ee: ESObject = new event.EventEmitter();
      let handler = () => {
      };
      expect(ee.eventNames().length).assertEqual(0)
      expect(ee._events.hasOwnProperty).assertEqual(undefined)
      expect(ee._events.toString).assertEqual(undefined)

      ee.on('__defineGetter__', handler);
      ee.on('toString', handler);
      ee.on('__proto__', handler);
      expect(ee.eventNames()[0]).assertEqual('__defineGetter__')
      expect(ee.eventNames()[1]).assertEqual('toString')
      expect(ee.listeners('__defineGetter__').length).assertEqual(1)
      expect(ee.listeners('__defineGetter__')[0]).assertEqual(handler)
      expect(ee.listeners('toString').length).assertEqual(1)
      expect(ee.listeners('toString')[0]).assertEqual(handler)
    })

  })
}