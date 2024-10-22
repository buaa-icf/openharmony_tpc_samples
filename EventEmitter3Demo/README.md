# EventEmitter3 

## Introduction

**EventEmitter3** is a high-performance EventEmitter. It provides APIs for adding a listener for an event, adding a one-time listener for an event, emitting an event, removing listeners, and obtaining the names and the number of listeners for an event.

## How to Install

```
ohpm install @types/eventemitter3 
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage_en.md).

## How to Use

After the **EventEmitter3** library is installed, import **EventEmitter** from **eventemitter3** and initialize **EventEmitter**.

```typescript
import EventEmitter from 'eventemitter3';

let emitter: EventEmitter<string, Object> = new EventEmitter<string, Object>();
```

### Adding a Listener for an Event

#### Using **on()**

  ```typescript
// Call on() to add a listener for an event named 'event'. When 'event' is emitted, a callback is invoked. In this case, the callback receives no data.
emitter.on('event', () => {
  ctx.state = ctx.state + "\r\n" + `Received the event callback.`
});  
// Call on() to add a listener for an event named 'event'. When 'event' is emitted, a callback is invoked. In this case, the callback receives 'data', which is of the string type.
emitter.on('event', (data: string) => {
  ctx.state = ctx.state + "\r\n" + `Received the event callback with data of ${data}.`
});

// Call on() to add a listener for an event named 'event'. When 'event' is emitted, a callback is invoked. In this case, the callback receives name and age.
emitter.on('event', (name: string,age: number) => {
  The ctx.state = ctx.state + "\r\n" + `Received the event callback, with name of ${data} and age of ${age}'.
});

  ```

You can **on()** to add a listener for an event. After the event is emitted, a callback will be invoked to receive the data passed by the event. The callback supports none or multiple parameters.

#### Using **addListener()**

```typescript
  emitter.addListener('addListener', () => {
      ctx.state = ctx.state + "\r\n" + `Received the addListener event callback.`
  });

 let callback = (data: string) => {
      ctx.state = ctx.state + "\r\n" + `Received the callback event callback with data of ${data}.`
 }
 emitter.addListener('callback', callback);
```

You can also use **addListener()** to add a listener for an event. After the event is emitted, a callback will be invoked to receive the data passed by the event. The callback supports none or multiple parameters.

#### Using **once()**

```typescript
emitter.once('single', (data: string) => {
      ctx.state = ctx.state + "\r\n" + `Received the single event callback with data of ${data}.`
    });
```

You can also use **once()** to add a listener for an event. The listener will be automatically removed once the callback is invoked.



You can use **on()**, **addListener()**, or **once()** to add a listener for an event. An event can be added with multiple listeners. Each time an event is emitted, the callback registered for the event can receive a notification. The order in which the callbacks receive notifications is as per the order in which the callbacks are registered.

### Emitting an Event

```typescript
emitter.emit("callback")
emitter.emit ('event', "This is original info.");
emitter.emit ('event', 'Tom', 18, "This is original info.");
```

You can use **emit()** to emit an event. This API can carry multiple parameters. The first parameter is the event name, and the other parameters are the data carried in the event.

If you use **on()** or **addListener()** to add a listener for an event, a callback will be invoked each time the event is emitted.

If you use **once()**, the callback can be invoked only once after the event is emitted.



**emit()** must be called after **on()**, **addListener()**, or **once()**. Otherwise, the callback registered for the event cannot receive the event notification.

### Removing a Listener from an Event

#### Using **off()**

```typescript
 let listener1 = () => {
 }
 emitter.on('listenNum', listener1);
 emitter.off('listenNum', listener1)
```

#### Using **removeListener()**

For the same event that is added with multiple listeners, all the listeners for the event will be removed if the callback is not specified when **removeListener()** is used. In the following example, callbacks **obj1**, **obj2**, **obj3**, and **obj4** are registered for the same event **newListener**. The **emitter.removeListener('newListener');** API will remove all the listeners for **newListener**.

```typescript
let obj1 = () => {}
let obj2 = () => {}
let obj3 = () => {}
let obj4 = () => {}
emitter.on('newListener',obj1 );
emitter.on('newListener', obj2);
emitter.on('newListener', obj3);
emitter.on('newListener', obj4);
emitter.removeListener('newListener');
```

In the following example, **emitter.removeListener('newListener',obj3);** will remove only the listener added by **emitter.on('newListener', obj3);**.

```typescript
let obj1 = () => {}
let obj2 = () => {}
let obj3 = () => {}
let obj4 = () => {}
emitter.on('newListener',obj1 );
emitter.on('newListener', obj2);
emitter.on('newListener', obj3);
emitter.on('newListener', obj4);
emitter.removeListener('newListener',obj3);
```

That is the same for **off()**. If you do not specify the callback in **off()**, all the listeners added for the same event will be removed.

#### Using **removeAllListeners**

Use **removeAllListeners** to remove all listeners.

```typescript
emitter.removeAllListeners();
```

### Example

```typescript
const emitter: EventEmitter<string, Object> = new EventEmitter<string, Object>(); // Initialize EventEmitter.

emitter.on('event', (name: string, age: number) ==> { // Add a listener for an event named 'event'. 
  console.log(`${name} is ${age} years old`);
});
let callback = (data: string) => {   
  console.log(`data is ${data} `);
}
emitter.addListener('callback', callback);// Add a listener for an event named 'callback'.
emitter.emit('event', 'Tom', 18); // Emit the 'event' event.
emitter.listeners('event') // Return all the listeners for the 'event' event.
emitter.listenerCount('event') // Return the number of listeners for the 'event' event.
emitter.eventNames(); // Return the names of all the events observed.
emitter.off('event') // Remove the listeners for the 'event' event.
emitter.removeListener('callback',callback) // Remove the listener for the 'callback' event.
emitter.removeAllListeners() // Remove all event listeners.
```

### Cross-Page Invocation

EntryAbility.ts

```typescript
import EventEmitter from 'eventemitter3'
import { GlobalContext } from '../pages/GlobalContext'
export default class EntryAbility extends UIAbility {
    
    onWindowStageCreate(windowStage: window.WindowStage) {
      GlobalContext.getContext().setObject(GlobalContext.KEY_CONTEXT, this.context);
      GlobalContext.getContext().setObject(GlobalContext.KEY_CACHE_DIR, this.context.cacheDir);
      GlobalContext.getContext().setObject(GlobalContext.KEY_FILES_DIR, this.context.filesDir);
      const emitter: EventEmitter<string, Object> = new EventEmitter<string, Object>();
      GlobalContext.getContext().setObject(GlobalContext.KEY_EMITTER, emitter);
      windowStage.loadContent('pages/Index', (err, data) => {
    });
  }
}

```

Index.ets

```typescript
import { GlobalContext } from './GlobalContext'
        
        Button ('Communication between pages')
        .width('100%')
        .backgroundColor(Color.Blue)
        .fontColor(Color.White)
        .padding(10)
        .margin(20)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/JumpOne'
          }).then(() => {
              // The event must be emitted after the redirection is initiated. Otherwise, the event listener of the next page has not been added and cannot receive the event emitted.
            let emitterInstance: EventEmitter<string, Object> | undefined = GlobalContext.getContext()
              .getObject(GlobalContext.KEY_EMITTER) as EventEmitter<string, Object>;
            if (emitterInstance) {
              emitterInstance.emit ('pageOne','This is the information sent from the home page to page 1.');
            }
          })

        })
```

JumpOne.ets

```typescript
import { GlobalContext } from './GlobalContext'
        
  aboutToAppear() {
    const ctx = this
    // When adding a listener during page initialization, use the global EventEmitter object and add the listener before the event is emitted.
    let emitter: EventEmitter<string, Object> | undefined = GlobalContext.getContext()
      .getObject(GlobalContext.KEY_EMITTER) as EventEmitter<string, Object>;
    if (emitter) {
        emitter.on('pageOne', (data: string) => {
          console.log(`componentB Data: ${data}`);
          ctx.message = data
        });
    }
  }
```

### Sequencing Events

```typescript
import EventEmitter from 'eventemitter3'

@Entry
@Component
struct EventSequencing {
  @State message: string = ''
  @State emitter: EventEmitter<string, Object> | undefined = undefined;

  aboutToAppear() {
    this.emitter = new EventEmitter<string, Object>();
    this.emitter.on('event', (name: string, age: number, message: string) => {}); // Add the same event name in page initialization.
  }

  onPageShow() {
    this.emitter.on('event', (name: string, age: number, message: string) => {}); // Add the same event name when the page is displayed.
  }

  build() {
    Row() {
      Column() {
        Button ('Emit Event')
          .width('100%')
          .height(50)
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
          .margin(20)
          .onClick(() => {
            this.startSendEvent()
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  startSendEvent() {
    const ctx = this
    // Add an event with the same name for the first time after the button is clicked.
    ctx.emitter.on('event', (name: string, age: number, message: string) => {});
    // Add an event with the same name after the button is clicked the second time.
    ctx.emitter.on('event', (name: string, age: number, message: string) => { });
    ctx.emitter.emit('event', 'Tom', 18, "This is original info.");
  }
}
  
```

After the event is emitted, the callbacks are invoked in the sequence in which they are added. In some scenarios, you need to sequence the events. For example, to process events in a queue, you need to add the events to **EventEmitter3** in sequence.

## Available APIs

### EventEmitter3

| API            | Parameter                                                        | Return Value                                          | Description                        |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------ | ---------------------------- |
| eventNames         | None                                                        | Array<EventEmitter.EventNames<EventTypes>>       | Returns the names of all the events observed.|
| listeners          | event: T                                                     | Array<EventEmitter.EventListener<EventTypes, T>> | Returns all the listeners of an event.  |
| listenerCount      | event: EventEmitter.EventNames<EventTypes>                   | number                                           | Returns the number of listeners for an event.  |
| emit               | event: T, ...args: EventEmitter.EventArgs<EventTypes, T>     | boolean                                          | Emits an event.                |
| on                 | event: T,<br>fn: EventEmitter.EventListener<EventTypes, T>, <br>context?: Context | EventEmitter                                     | Listens for an event.                    |
| addListener        | event: T,<br>fn: EventEmitter.EventListener<EventTypes, T>, <br>context?: Context | EventEmitter                                     | Adds a listener for an event.                    |
| once               | event: T,<br>fn: EventEmitter.EventListener<EventTypes, T>, <br>context?: Context | EventEmitter                                     | Adds a one-time listener for an event.              |
| removeListener     | event: T,<br>fn?: EventEmitter.EventListener<EventTypes, T>, <br>context?: Context,<br>once?: boolean | EventEmitter                                     | Removes a listener from an event.                    |
| off                | event: T,<br>fn?: EventEmitter.EventListener<EventTypes, T>, <br>context?: Context,<br>once?: boolean | EventEmitter                                     | Removes a listener from an event.                    |
| removeAllListeners | event?: EventEmitter.EventNames<EventTypes>                  | EventEmitter                                     | Removes all listeners.          |

For more information, see [EventEmitter3](https://github.com/primus/eventemitter3/blob/master/README.md) and [Unit Test Cases](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/EventEmitter3Demo/TEST.md).

## Constraints

This project has been verified in the following version:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK:API12 Release(5.0.0.66)
- DevEco Studio: 4.0 Release(4.0.3.513), SDK: API10 Release(4.0.10.10)

## Directory Structure

```typescript
|---- EventEmitter3Demo  
|     |---- entry  # Sample code
			|---- pages  # Application pages, which may vary depending on the test scenario
			   |---- ApiTest.ets          # Full API test cases
                |---- EventSequencing.ets  # Event sequencing example
                |---- FileRead.ets         # Example of file read listening
                |---- GlobalContext.ts     # Global context for singleton mode
                |---- Index.ets            # Homepage
                |---- JumpOne.ets          # Example of jumping to page 1
                |---- JumpTwo.ets          # Example of jumping to page 2
|     |---- README.MD  # Readme                  
```

## How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitee.com/zdy09/openharmony_tpc_samples/blob/master/EventEmitter3Demo/LICENSE).
