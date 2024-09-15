# EventBus

## Introduction

This project is an OpenHarmony development example based on the [EventBus](https://github.com/krasimir/EventBus) library. It uses eventbusjs of version 0.2.0. eventbusjs is used to subscribe to and send messages and manage events in JavaScript, providing a simple yet efficient solution for communication between multiple components.

## How to Download

**Using CLI**

```
ohpm i eventbusjs
ohpm install @types/eventbusjs --save-dev // A syntax error is reported for the import eventbusjs instruction if the eventbusjs package does not contain the type declaration. You need to download the declaration file of the package using @types/eventbusjs to rectify the syntax error.

```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

Use the project in your code:

```
import EventBus from "eventbusjs"
```

```
function myFunction(event) {
  console.log("myFunction type=" + event.type);
}
EventBus.addEventListener("my_function_event", myFunction);
EventBus.dispatch("my_function_event");

```

### Range

```
var TestClass1 = function() {
  this.className = "TestClass1";
  this.callback = function(event) {
    console.log(this.className + " = type:" + event.type + " / dispatcher:" + event.target.className);
  }
};
var TestClass2 = function() {
  this.className = "TestClass2";
  this.dispatchOurEvent = function() {
    EventBus.dispatch("callback_event", this);
  }
};
var t1 = new TestClass1();
var t2 = new TestClass2();
EventBus.addEventListener("callback_event", t1.callback, t1);
t2.dispatchOurEvent();
```

### Passing In Additional Parameters

```
var TestClass1 = function() {
  this.className = "TestClass1";
  this.doSomething = function(event, param1, param2) {
    console.log(this.className + ".doSomething");
    console.log("type=" + event.type);
    console.log("params=" + param1 + param2);
    console.log("coming from=" + event.target.className);
  }
};
var TestClass2 = function() {
  this.className = "TestClass2";
  this.ready = function() {
    EventBus.dispatch("custom_event", this, "javascript events", " are really useful");
  }
};

var t1 = new TestClass1();
var t2 = new TestClass2();

EventBus.addEventListener("custom_event", t1.doSomething, t1);
t2.ready();

```

### Example of Using EventBus.removeEventListener

```
/* Wrong - callback functions are different instances */
EventBus.addEventListener('EXAMPLE_EVENT', function() {
    console.log('example callback');
});
EventBus.removeEventListener('EXAMPLE_EVENT', function() {
    console.log('example callback');
});

/* Correct - callback function is the same instance */
var handler = function() {
    console.log('example callback');
};
EventBus.addEventListener('EXAMPLE_EVENT', handler);
EventBus.removeEventListener('EXAMPLE_EVENT', handler);
```



## Available APIs

### `addEventListener`

Binds an event processing function to a specific event type. When this event is triggered, the bound event processing function is executed.

```
// @type - string
// @callback - function
// @scope - the scope where the @callback is defined
EventBus.addEventListener(type, callback, scope)
```

### `removeEventListener`

Removes the event listener added using the `addEventListener` method.

```
// @type - string
// @callback - function
// @scope - the scope where the @callback is defined
EventBus.removeEventListener(type, callback, scope)
```

### `hasEventListener`

Checks whether an event listener is registered with a specific event type.

```
// @type - string
// @callback - function
// @scope - the scope where the @callback is defined
EventBus.hasEventListener(type, callback, scope)
```

### `dispatch`

Triggers an event.

```
// @type - string
// @target - the caller
// @args - pass as many arguments as you want
EventBus.dispatch(type, target, args ...)
```

### `getEvents`

Prints the added listeners for debugging purposes.

```
EventBus.getEvents()
```

## Constraints
This project has been verified in the following versions:
- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## License

This project is incensed under [Apache License 2.0](https://gitee.com/lgrong2303/openharmony_tpc_samples/blob/EventBus/EventBus/LICENSE).

## How to Contribute

If you find any problem during the use, submit an issue or a PR.
