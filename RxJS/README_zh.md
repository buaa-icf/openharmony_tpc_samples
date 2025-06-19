# RxJS

## 简介

本项目是OpenHarmony rxjsDemo项目。
[rxjs](https://github.com/reactivex/rxjs)是一个通过使用可观察序列来合成异步和基于事件的程序的JavaScript库。它通过使用 observable 序列编写基于异步和事件的程序。核心类型是： Observable , 附属类型：Observer， Schedules, Subjects 和一些操作符 map，filter等。这些操作符可以把异步事件当作集合处理。

| 功能名称                                       | 功能描述                                                     |
| ---------------------------------------------- | :----------------------------------------------------------- |
| 创建一个可观察对象发射数据流                   | 创建可观察对象Observale，发送数据流，或则一条数据，一个通知  |
| 通过操作符Operator加工处理数据流               | 创建操作符、 组合操作符、 过滤操作符、条件操作符、转换操作符、工具集 |
| Scheduler调度者                                | 通过线程调度器Scheduler指定操作数据流所在的线程。            |
| 创建一个观察者Observer接收响应数据流，或者通知 | 1.onNext接收数据<br/> 2.onError接收异常通知<br/> 3.onComplete接收完成通知 |

## 下载安装

```shell
ohpm install rxjs
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)



## 使用说明

### RxJS 观察者模式

什么是观察员？观察者是观察者传递的价值的消费者。观察者只是一组回调，一个用于由所述可观测的递送通知每种类型：next，error，和 complete。
以下是典型的 Observer 对象的示例：

```javascript
const observer = {
  next: x => console.log('Observer got a next value: ' + x),
  error: err => console.error('Observer got an error: ' + err),
  complete: () => console.log('Observer got a complete notification'),
};
```

要使用 Observer，请将其提供给 subscribeObservable 的：

```javascript
const subscription =observable.subscribe(observer);
```

取消订阅
订阅实际上仅具有 unsubscribe()释放资源或取消可观察执行的功能。

```javascript
subscription.unsubscribe();
```

### 操作符

操作符就是功能。操作符有两种：
一、管道运算符是可以使用语法通过管道传递给 Observables 的类型 observableInstance.pipe(operator())。 这些包括filter(...)和 mergeMap(...)。调用时，它们不会更改现有的 Observable 实例。相反，它们返回一个新的 Observable，其订阅逻辑基于第一个 Observable。
管道运算符是一个将 Observable 作为其输入并返回另一个 Observable 的函数。这是一个纯粹的操作：以前的 Observable 保持不变。
二、创建运算符是另一种运算符，可以称为独立函数来创建新的 Observable。例如：of(1, 2, 3)创建一个可观察物体，该物体将依次发射 1、2 和 3。

以下是其中一些操作符的例子：
create：使用给定的订阅函数来创建 observable

```javascript
import { Observable } from 'rxjs';
//创建在订阅函数中发出 'Hello' 和 'World' 的 observable 。
    const hello = Observable.create(function (observer) {
      observer.next('Hello');
      observer.next('World');
    });
    // 输出: 'Hello'...'World'
    const subscribe = hello.subscribe(val => console.log(val));
```

concat：concat 2个基础的 observables

```javascript
import { concat } from 'rxjs/operators';
import { of } from 'rxjs';

// 发出 1,2,3
const sourceOne = of(1, 2, 3);
// 发出 4,5,6
const sourceTwo = of(4, 5, 6);
// 先发出 sourceOne 的值，当完成时订阅 sourceTwo
const example = sourceOne.pipe(concat(sourceTwo));
// 输出: 1,2,3,4,5,6
const subscribe = example.subscribe(val =>
  console.log('Example: Basic concat:', val)
);
```

debounce：根据一个选择器函数，舍弃掉在两次输出之间小于指定时间的发出值

```javascript
import { of, timer } from 'rxjs';
import { debounce } from 'rxjs/operators';

// 发出四个字符串
const example = of('WAIT', 'ONE', 'SECOND', 'Last will display');
/*
  只有在最后一次发送后再经过一秒钟，才会发出值，并抛弃在此之前的所有其他值
*/
const debouncedExample = example.pipe(debounce(() => timer(1000)));
/*
    在这个示例中，所有的值都将被忽略，除了最后一个
    输出: 'Last will display'
*/
const subscribe = debouncedExample.subscribe(val => console.log(val));
```

关于更多的操作符的使用方式，可以参考这个文档[学习RxJs](https://rxjs-cn.github.io/learn-rxjs-operators/)

### Schedulers (调度器)

#### 调度程序类型

下列中的每一个都可以通过使用Scheduler对象的静态属性来创建和返回。

| 调度器         | 目的                                                         |
| :------------- | :----------------------------------------------------------- |
| null           | 通过不传递任何调度程序，通知以同步和递归的方式传递。将此用于恒定时间操作或尾递归操作。 |
| queueScheduler | 当前事件框架中的队列上调度（蹦床调度程序）。将此用于迭代操作。 |
| asapScheduler  | 微任务队列上的调度，与用于承诺的队列相同。基本上在当前工作之后，但在下一个工作之前。将此用于异步转换。 |
| asyncScheduler | 使用 setInterval 的调度。用于基于时间的操作符。              |

#### 使用调度器

对于返回带有有限和少量消息的observable的操作符，RxJS不使用调度程序，即null或undefined。对于返回潜在大量或无限数量消息的操作符，使用queue调度程序。对于使用计时器的操作员，使用async。

* 静态创建操作符通常将调度程序作为参数。例如，from(array, scheduler)让您指定在传递从array. 它通常是运算符的最后一个参数。以下静态创建操作符采用Scheduler参数：
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

* 使用subscribeOn预定计划在什么情况下会在subscribe()呼叫发生。默认情况下，subscribe()对 Observable的调用将同步且立即发生。但是，您可以使用实例 operator 延迟或安排实际订阅发生在给定的调度程序上subscribeOn(scheduler)。

* 使用observeOn预定计划在什么情况下会通知交付。实例操作符observeOn(scheduler)在源 Observable 和目标观察者之间引入了一个中介观察者，其中中介使用给定的scheduler。实例运算符可以将调度程序作为参数。

* 时间相关的操作符如bufferTime，debounceTime，delay，auditTime，sampleTime，throttleTime，timeInterval，timeout，timeoutWith，windowTime都将一个调度程序作为最后一个参数，否则默认情况下的操作asyncScheduler。

关于RxJs的更多介绍，可以参考[官方文档](https://rxjs.dev/)

## 接口说明

|                                                方法名                                                 |                                                                                             参数                                                                                              |                                                                       接口描述                                                                        |
|:--------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------------------------:|
|                              Observable.create(...args: any[]) => any                              |                                                                               args:订阅要传递给Observable构造函数的订阅函数                                                                                |                                                  通过调用Observable的构造函数创建一个新的Observable,一个新的可观察对象。                                                   |
|                                  empty(scheduler?: SchedulerLike)                                  |                                                                             scheduler:用于调度完整通知的发送的SchedulerLike                                                                             |                                                                     发出完整的通知。                                                                      |
|                                        from(array?: Array)                                         |                                                                                         array:输入数组                                                                                          |                                              从Array、类数组对象、Promise、可迭代对象或类Observable对象创建一个Observable。                                              |
|                        interval(period?: number, scheduler?: SchedulerLike)                        |                                                  period:间隔大小，以毫秒（默认）或时间单位确定调度器的时钟。<br/>scheduler {@link SchedulerLike}用于调度值的释放，并提供“时间”的概念。                                                  |                                                  在指定的SchedulerLike上创建一个可观察对象，该对象在指定的时间间隔上发出序列号。                                                   |
|                                   of(...args: (SchedulerLike)[])                                   |                                                                                     args:要发出的参数的逗号分隔列表                                                                                      |                                                                   将参数转换为可观察序列。                                                                    |
|                                range(start: number, count?: number)                                |                                                                                    start: 开始, count?: 数量                                                                                    |                                                             创建一个可观察对象，在指定范围内发出一系列数字。                                                              |
|                        timer(due: number  Date, scheduler?: SchedulerLike)                         |                                    due: 如果是‘ number ’，则在发射之前等待的时间（以毫秒为单位）。如果是‘ Date ’，则表示发射的确切时间。<br/> scheduler: 用于调度延迟的调度程序。默认为{@link asyncScheduler}。                                    | 如果提供的‘ scheduler ’返回的时间戳不是来自‘ now() ’的epoch，并且‘ Date ’对象被传递给‘ dueTime ’参数，<br/>则第一次发射应该发生的时间计算将是不正确的。在这种情况下，<br/>最好提前进行自己的计算，并将“数字”作为“dueTime”传入。 |
|                                   combineLatest(...args: any[])                                    |                                                  args: 任意数量的observableinput以数组或对象的形式提供，以便彼此组合。如果最后一个参数是函数，它将被用来将最新组合的值投影到输出Observable上的新值。                                                  |                                          组合多个Observable来创建一个Observable，它的值是从它的每个输入Observable的最新值中计算出来的。                                           |
|                                       concat(...input：any[])                                       |                                                                                     input：Observable 对象                                                                                     |                                               创建一个输出Observable，它会从第一个给定的Observable中发出所有的值，然后移动到下一个。                                               |
|                                            concatAll()                                             |                                                                                              -                                                                                              |                                                       通过将内部可观察对象按顺序连接起来，将高阶可观察对象转换为一阶可观察对象。                                                       |
|                                      forkJoin(...args: any[])                                      |                                                                      args：作为数组、对象或直接传递给操作符的参数提供的任意数量的ObservableInputs。                                                                      |         接受一个ObservableInput的Array或一个ObservableInput的dictionary Object，并返回一个Observable，该Observable发出一个与传递的数组顺序完全相同的值数组，或者一个与传递的字典形状相同的值字典。         |
|                                     merge(...args: unknown[])                                      |                                      args:observableinput合并在一起。如果最后一个参数是number类型，merge将使用它来限制并发订阅observableinput的数量。如果最后一个参数是SchedulerLike，它将用于调度值的发射。                                      |                                                         创建一个输出观察对象，并发地从每个给定的输入观察对象发出所有值。                                                          |
|                                    mergeAll(concurrent: number)                                    |                                                                                concurrent: 并发订阅的内部可观察对象的最大数量                                                                                |                                                  将高阶可观察对象转换为一阶可观察对象，该一阶可观察对象并发地传递内部可观察对象发出的所有值。                                                   |
|                                             pairwise()                                             |                                                                                              -                                                                                              |                                                           将连续的排放量组合在一起，并将它们作为两个值的数组发出。                                                            |
|                                       race(...inputs: any[])                                       |                                                                                    inputs: Observable 对象                                                                                    |                                                         返回一个可观察对象，该可观察对象镜像第一个发出项的源可观察对象。                                                          |
|                                    startWith(...values: any[])                                     |                                                                                 values:修改后的Observable首先发出的项                                                                                 |                                             返回一个可观察对象，该可观察对象在订阅时将同步发射提供给此操作符的所有值，然后订阅源并将其所有发射镜像给订阅者。                                              |
|                                  withLatestFrom(...inputs: any[])                                  |                                                                                    inputs: Observable 对象                                                                                    |                                将源Observable和其他Observable组合在一起，创建一个Observable，它的值是根据每个Observable的最新值计算出来的，只在源发出的时候。                                |
|                                      zip(...args: unknown[])                                       |                                                                        args:任意数量的observableinput以数组或对象的形式提供，以便彼此组合。                                                                         |                                          组合多个Observable来创建一个Observable，它的值是根据它的每个输入Observable的值依次计算出来的。                                           |
|                                debounce(durationSelector: function)                                |                                                         durationSelector:一个从源Observable接收值的函数，用于计算每个作为Observable或Promise返回的源值的超时时间。                                                         |                                                  只有在另一个可观察对象确定的特定时间跨度过去而没有其他源发射之后，才会从源可观察对象发出通知。                                                  |
|              debounceTime(dueTime: number, scheduler: SchedulerLike = asyncScheduler)              |                             dueTime: 以毫秒为单位的超时时间（或由可选调度器内部确定的时间单位），用于在发出最近的源值之前等待发射静默所需的时间窗口。<br/> scheduler: 默认是asyncScheduler。SchedulerLike用于管理处理每个值的超时的计时器。                              |                                                      只有在一个特定的时间跨度过去而没有其他源发射之后，才会从源可观察对象发出通知。                                                      |
|                            distinctUntilChanged(comparator?: function)                             |                                                                                       comparator:比较大小                                                                                       |                                           返回一个结果可观察对象，如果源可观察对象推送的所有值与结果可观察对象发出的最后一个值不同，则该结果可观察对象会发出这些值。                                           |
|                             filter(predicate: function, thisArg?: any)                             |                 predicate:一个对源Observable发出的每个值求值的函数。如果它返回true，则该值被发出，如果返回false，则该值不会传递给输出Observable。index参数是自订阅以来发生的第i个源发射的数字i，从数字0开始。<br/>thisArg:一个可选参数，用于确定谓词函数中this的值。                  |                                                         通过只发出满足指定谓词的项来过滤源Observable发出的项。                                                          |
|                          first(predicate?: function, defaultValue?: any)                           |                                                         predicate: 对每个项目调用一个可选函数，以测试条件是否匹配。<br/> defaultValue: 如果在源上找不到有效值，则发出默认值。                                                          |                                                       只发出源Observable发出的第一个值（或满足某些条件的第一个值）。                                                        |
|                                          ignoreElements()                                          |                                                                                              -                                                                                              |                                                     忽略源Observable发出的所有项，只传递complete或error的调用。                                                     |
|                           last(predicate?: function, defaultValue?: any)                           |                                                         predicate: 任何源发出的项都必须满足的条件<br/> defaultValue: 果未满足最后一个谓词或未发出值，则提供一个可选的默认值。                                                          |           返回一个只发出源Observable发出的最后一项的Observable。它可选地接受一个谓词函数作为参数，在这种情况下，生成的Observable将发出源Observable中满足谓词的最后一个项，而不是发出源Observable中的最后一个项。            |
|                                 sample(notifier: ObservableInput)                                  |                                                                          notifier:用于采样源Observable的ObservableInput。                                                                          |                                                      每当另一个可观察对象（即通知器）发出时，都会从源可观察对象发出最近发出的值。                                                       |
|                                              single()                                              |                                                                                              -                                                                                              |                                          返回一个可观察对象，该对象断言与谓词匹配的可观察对象只会发出一个值。如果没有提供谓词，那么它将断言该可观察对象只发出一个值。                                           |
|                                        skip(count: number)                                         |                                                                               count:源Observable发出的项应该被跳过的次数。                                                                                |                                                           返回一个可观察对象，跳过源可观察对象发出的第一个计数项。                                                            |
|                                skipUntil(notifier: ObservableInput)                                |                                                          notifier:一个ObservableInput，它必须在源Observable元素开始被结果Observable镜像之前发出一个item。                                                           |                                                       返回一个可观察对象，跳过源可观察对象发出的项，直到第二个可观察对象发出项。                                                       |
|                                   skipWhile(predicate:function)                                    |                                                                             predicate:测试从源Observable中发出的每个项的函数。                                                                             |                                          返回一个可观察对象，只要指定的条件为真，它就会跳过源可观察对象发出的所有项目，但一旦条件为假，它就会发出所有进一步的源项目。                                           |
|                                        take(count: number)                                         |                                                                                    count:要发出的下一个值的最大数目。                                                                                     |                                                             只发出源Observable发出的第一个计数值。                                                              |
|                                takeUntil(notifier: ObservableInput)                                |                                                        notifier:ObservableInput，它的第一个发出值会导致takeUntil的输出Observable停止从源Observable发出值。                                                         |                                                      会发出源Observable发出的值，直到通知Observable发出一个值。                                                      |
|                     takeWhile(predicate: function, inclusive: boolean = false)                     |                                          predicate: 一个对源Observable发出的值求值并返回一个布尔值的函数。还将（从零开始的）索引作为第二个参数 <br/>inclusive:当设置为true时，导致谓词返回false的值也将被触发                                          |                                                   只要每个值满足给定的谓词，就发出源Observable发出的值，然后在不满足该谓词时结束。                                                   |
|                   throttle(durationSelector: function, config?: ThrottleConfig)                    |                       durationSelector:一个从源Observable接收值的函数，用于计算每个源值的沉默持续时间，作为Observable input返回。<br/>config: 一个配置对象，用于定义前导和尾随行为。默认为{leading: true， trailing: false}。                       |                                                 从源可观察对象发出一个值，然后在另一个可观察对象确定的持续时间内忽略后续的源值，然后重复这个过程。                                                 |
| throttleTime(duration: number, scheduler: SchedulerLike = asyncScheduler, config?: ThrottleConfig) | duration: 在发出最后一个值之后发出另一个值之前等待的时间，以毫秒或由可选调度器内部确定的时间单位计算。<br/> scheduler: 用于管理处理节流的计时器的SchedulerLike。默认为asyncScheduler。<br/> config: 一个配置对象，用于定义前导和尾随行为。默认为{leading: true， trailing: false}。 |                                                  从源Observable中发出一个值，然后在持续时间毫秒内忽略后续的源值，然后重复这个过程。                                                   |
|                                 defaultIfEmpty(defaultValue: any)                                  |                                                                             defaultValue:当源Observable为空时使用的默认值。                                                                             |                                                     如果源可观察对象完成后没有发出下一个值，则发出一个给定值，否则镜像源可观察对象。                                                      |
|    every(predicate: (value: T, index: number, source: Observable<T>) => boolean, thisArg?: any)    |                                                                         predicate:确定某项是否满足指定条件的函数。<br/>thisArg:回调函数                                                                         |                                                          返回一个可观察对象，该对象会发出源的每个项是否满足指定的条件。                                                          |
|                              buffer(closingNotifier: ObservableInput)                              |                                                                closingNotifier:一个ObservableInput，用于指示要在输出Observable上发出的缓冲区。                                                                 |                                                        缓冲源Observable的值，直到closenotifier发出。                                                         |
|                  bufferCount(bufferSize: number, startBufferEvery: number = null)                  |                              bufferSize: 发出的缓冲区的最大大小.<br/> startBufferEvery: 启动新缓冲区的间隔时间。例如，如果startBufferEvery为2，则将根据源中的每个其他值启动一个新的缓冲区。默认情况下，在源的开始处启动一个新的缓冲区。                               |                                                      缓冲源Observable的值，直到大小达到给定的最大bufferSize。                                                       |
|                      bufferTime(bufferTimeSpan: number, ...otherArgs: any[])                       |                        bufferTimeSpan：填充每个缓冲区数组所需的时间。<br/>otherArgs：其他配置参数，如：bufferCreationInterval-启动新缓冲区的间隔；maxBufferSize -最大缓冲区大小；scheduler-调度程序，在其上调度确定缓冲区边界的间隔。                        |                                                             在一段特定的时间内缓冲源Observable的值。                                                             |
|                 bufferToggle(openings: ObservableInput, closingSelector: function)                 |                                 openings:一个可订阅的或承诺的通知，以启动新的缓冲区。<br/>closingSelector：一个函数，它接受由打开的可观察对象发出的值，并返回一个Subscribable或Promise，当它发出时，表示应该发出并清除相关的缓冲区。                                  |                                                       缓冲源Observable的值，从开口发射开始，到关闭选择器发射输出结束。                                                       |
|                               bufferWhen(closingSelector: function)                                |                                                                       closingSelector:一个不接受任何参数并返回一个可观察对象来表示缓冲区关闭的函数。                                                                       |                                               缓冲源Observable的值，使用关闭Observable的工厂函数来决定何时关闭、发出和重置缓冲区。                                                |

## 约束与限制
在下述版本验证通过：

DevEco Studio: NEXT Release(5.0.3.900), SDK: API12 (5.0.0.71)

DevEco Studio:DevEco Studio 4.1 Canary2(4.1.3.400), SDK: API11 (4.1.0.36(SP6))

## 目录

```
 ├── entry
 │ └── src
 │ │ └── main
 │ │ │ ├── ets
 │ │ │ │  ├── pages
 │ │ │ │  │ ├── index.ets        # 入口文件
 │ │ │ │  │ ├── create.ets       # 创建操作符相关demo
 │ │ │ │  │ ├── filter.ets       # 过滤操作符相关demo
 │ │ │ │  │ ├── multicast.ets    # 多播操作符相关demo
 │ │ │ │  │ ├── combine.ets      # 组合操作符相关demo
 │ │ │ │  │ ├── error.ets        # 错误处理操作符相关demo
 │ │ │ │  │ ├── condition.ets    # 条件操作符相关demo
 │ │ │ │  │ ├── convert.ets      # 转换操作符相关demo
 │ │ │ │  │ ├── tool.ets         # 工具集相关demo
 │ │ │ │  │ ├── scheduler.ets    # 调度器相关demo
 │ │ │ │  │ └── ArkTools.ts      # 适配ark语法相关工具函数
 │ │ │ │  └── log.js             # 日志打印工具类
 │ │ │ ├── resources              # hap资源存放目录
 │ │ │ └── module.json5            # hap配置文件
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/RxJS/LICENSE) 协议，请自由地享受和参与开源。
