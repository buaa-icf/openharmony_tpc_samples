# RxJS

## Overview

[rxjs](https://github.com/reactivex/rxjs) is a JavaScript library that synthesizes asynchronous and event-based programs by using observable sequences. It provides one core key, the **Observable**, three satellite types, **Observer**, **Schedules**, and **Subjects**, and some operators such as **map** and **filter**. These operators allow us to process asynchronous events as collections.

| Function                                      | Description                                                    |
| ---------------------------------------------- | :----------------------------------------------------------- |
| Using an **Observable** object to send data streams                  | Create an **Observable** object, and send data streams, a piece of data, or a notification. |
| Using operators to process data streams              | Create operators, combination operators, filtering operators, conditional operators, transformation operators, and utility operators. |
| Using Scheduler                               | Use the thread scheduler to specify the thread for processing data streams.           |
| Using an observer to receive response streams or notifications | 1. onNext: data received<br> 2. onError: error detected<br> 3. onComplete: data receiving completed |

## Download and Installation

```shell
ohpm install rxjs
```

For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).



## Usage

### RxJS Observer Mode

What is an observer? An **Observer** is a consumer of values delivered by an **Observable**. Observers are simply a set of callbacks, one for each type of notification delivered by the **Observable**: **next**, **error**, and complete.
The following is an example of a typical **Observer** object:

```javascript
const observer = {
  next: x => console.log('Observer got a next value: ' + x),
  error: err => console.error('Observer got an error: ' + err),
  complete: () => console.log('Observer got a complete notification'),
};
```

To use the **Observer**, provide it to the **subscribe** method of an **Observable**:

```javascript
const subscription =observable.subscribe(observer);
```

Unsubscription
You can use **unsubscribe()** to release resources or cancel an observable execution.

```javascript
subscription.unsubscribe();
```

### Operator

Operators are functions. There are two types of operators:
1. Pipeable operators are types that can be passed to **Observables** by using the syntax **observableInstance.pipe(operator())**.  Typical operators are **filter(...)** and **mergeMap(...)**. When being called, they do not change existing **Observable** instances. Instead, they return a new **Observable** whose subscription logic is based on the first **Observable**.
The pipeable operators are methods that take an **Observable** as input and return another **Observable**. This is a pure operation: the previous **Observable** remains unchanged.
2. Creation operators are another type of operators that can be called as standalone functions to create new **Observables**. For example, **of(1, 2, 3)** creates an **Observable** that emits 1, 2, and 3 in sequence.

Here are some examples of these operators:
**create**: Create an **Observable** using the given **subscribe** function

```javascript
import { Observable } from 'rxjs';
// Create an observable that emits 'Hello' and 'World' in the subscribe function.
    const hello = Observable.create(function (observer) {
      observer.next('Hello');
      observer.next('World');
    });
    // Output: 'Hello'...'World'
    const subscribe = hello.subscribe(val => console.log(val));
```

**concat**: Concatenate two basic Observables.

```javascript
import { concat } from 'rxjs/operators';
import { of } from 'rxjs';

// Emit 1,2,3.
const sourceOne = of(1, 2, 3);
// Emit 4,5,6.
const sourceTwo = of(4, 5, 6);
// Emit the values of sourceOne, and subscribe to sourceTwo when completed.
const example = sourceOne.pipe(concat(sourceTwo));
// Output: 1,2,3,4,5,6
const subscribe = example.subscribe(val =>
  console.log('Example: Basic concat:', val)
);
```

**debounce**: Discard emitted values between two outputs that are less than the specified time according to a selector function.

```javascript
import { of, timer } from 'rxjs';
import { debounce } from 'rxjs/operators';

// Emit four strings.
const example = of('WAIT', 'ONE', 'SECOND', 'Last will display');
/*
  The value is sent only one second after the last emission, and all other values emitted before are discarded.
*/
const debouncedExample = example.pipe(debounce(() => timer(1000)));
/*
    In this example, all values except the last one will be ignored.
    Output: 'Last will display'
*/
const subscribe = debouncedExample.subscribe(val => console.log(val));
```

For more details about how to use operators, see [Learning RxJs](https://rxjs-cn.github.io/learn-rxjs-operators/).

### Schedulers

#### Scheduler Type

Each of the following can be created and returned using the static properties of the **Scheduler** object.

| Scheduler        | Purpose                                                        |
| :------------- | :----------------------------------------------------------- |
| null           | Notifications are delivered synchronously and recursively without passing any scheduler. Use this for constant time operations or tail recursive operations. |
| queueScheduler | Scheduling on the current event frame's queue (trampoline scheduler). Use this for iteration operations. |
| asapScheduler  | Scheduling on the micro task queue. It is the same as the queue used for commitment. It usually occurs after the current job but before the next job. Use this for asynchronous conversions. |
| asyncScheduler | Scheduling with **setInterval**. Use this for time-based operations.             |

#### Using Schedulers

For operators that return observables with a finite and small number of messages, RxJS does not use a scheduler, i.e., **null** or **undefined**. For operators that return potentially large or infinite numbers of messages, the **queue** scheduler is used. For operators that use timers, **async** scheduler is used.

* Static creation operators often take a scheduler as an argument. For example, **from(array, scheduler)** lets you specify the scheduler to use when delivering each notification converted from the specified array. It is usually the last argument of an operator. The following static creation operators use a **Scheduler** argument:
  bindCallback
  bindNodeCallback
  combineLatest
  concat
  empty
  from
  fromPromise
  interval
  merge
  of
  range
  throw
  timer

* Use **subscribeOn** to schedule in what context will a **subscribe()** call occur. By default, a **subscribe()** call on an **Observable** occurs synchronously and immediately. However, you may delay or schedule the actual subscription to occur on a given scheduler using the instance operator **subscribeOn(scheduler)**.

* Use **observeOn** to schedule in what context will notifications be delivered. The instance operator **observeOn(scheduler)** introduces a mediator **Observer** between the source **Observable** and the destination **Observer**, where the mediator schedules calls using the given **Scheduler**. The instance operator can take the scheduler as an argument.

* Time-related operators, such as **bufferTime**, **debounceTime**, **delay**, **auditTime**, **sampleTime**, **throttleTime**, **timeInterval**, **timeout**, **timeoutWith**, and **windowTime**, all take a **Scheduler** as the last argument. Otherwise, **asyncScheduler** is used by default.

For more information about RxJs, see the [official documentation](https://rxjs.dev/).

## Available APIs

List of RxJS operators

| Operator Type | Operator Name                                                |
| ---------- | :----------------------------------------------------------- |
| Creation      | create, empty, from, interval, of / just, range, throw, and timer |
| Combination      | combineAll, combineLatest, concat, concatAll, forkJoin, merge, mergeAll, pairwise, race, startWith, withLatestFrom, and zip |
| Filtering      | debounce, debounceTime, distinctUntilChanged, filter, first, ignoreElements, last, sample, single, skip, skipUntil, skipWhile, take, takeUntil, takeWhile, throttle, and throttleTime |
| Conditional      | defaultIfEmpty and every                                       |
| Transformation      | buffer, bufferCount, bufferTime, bufferToggle, bufferWhen, concatMap, concatMapTo, exhaustMap, expand, groupBy, map, mapTo, mergeMap, partition, pluck, reduce, scan, switchMap, window, windowCount, windowTime, windowToggle, and windowWhen |
| Utility    | do / tap, delay, delayWhen, dematerialize, and timeout          |
| Error handling  | catch/catchError, retry, and retryWhen                    |
| Multicasting      | publish, multicast, share, and shareReplay                     |

## Constraints
RxJS has been verified in the following versions:

DevEco Studio: DevEco Studio 4.1 Canary2 (4.1.3.400), SDK: API11 (4.1.0.36(SP6))

## Directory Structure

```
 ├── entry
 │ └── src
 │ │ └── main
 │ │ │ ├── ets
 │ │ │ │  ├── pages
 │ │ │ │  │ ├── index.ets        # Entry file
 │ │ │ │  │ ├── create.ets       # Demo for creation operators
 │ │ │ │  │ ├── filter.ets       # Demo for filtering operators
 │ │ │ │  │ ├── multicast.ets    # Demo for multicasting operators
 │ │ │ │  │ ├── combine.ets      # Demo for combination operators
 │ │ │ │  │ ├── error.ets        # Demo for error handling operators
 │ │ │ │  │ ├── condition.ets    # Demo for conditional operators
 │ │ │ │  │ ├── convert.ets      # Demo for transformation operators
 │ │ │ │  │ ├── tool.ets         # Demo for utility operators
 │ │ │ │  │ ├── scheduler.ets    # Demo for schedulers
 │ │ │ │  │ └── ArkTools.ts      # Utility functions for ArkUI syntax adaptation
 │ │ │ │  └── log.js             # Log printing utility class
 │ │ │ ├── resources              # HAP resources
 │ │ │ └── module.json5            # HAP configuration file
```

## How to Contribute

If you find any problem when using RxJS, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under the terms of the [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/RxJS/LICENSE).
