# EventBus

## 简介

本库是OpenHarmony系统下基于[EventBus](https://github.com/krasimir/EventBus)库使用的开发示例，此处使用的版本是eventbusjs@0.2.0，eventbusjs主要功能是消息订阅发送，用于在JavaScript中管理事件，为多组件之间的通信提供了一个简单而高效的解决方案，受到广大开发者的喜爱。

## 下载

命令行下载：

```
ohpm i eventbusjs
ohpm install @types/eventbusjs --save-dev //import eventbusjs 的时候语法报错。其原因是eventbusjs包内不含类型声明，需要 @types/eventbusjs 下载这个包的声明文件，从而解决语法的报错。

```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

使用组件在您的代码中:

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

### 保持范围

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

### 传递附加参数

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

### EventBus.removeEventListener用法示例

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



## 接口说明

### `addEventListener`

用于将一个事件处理函数绑定到特定的事件类型上。当这个特定的事件被触发时，绑定的事件处理函数就会被执行。

```
// @type - string
// @callback - function
// @scope - the scope where the @callback is defined
EventBus.addEventListener(type, callback, scope)
```

### `removeEventListener`

用于移除之前通过addEventListener方法添加的事件监听器。

```
// @type - string
// @callback - function
// @scope - the scope where the @callback is defined
EventBus.removeEventListener(type, callback, scope)
```

### `hasEventListener`

用来检查是否有事件监听器注册在特定的事件类型上。

```
// @type - string
// @callback - function
// @scope - the scope where the @callback is defined
EventBus.hasEventListener(type, callback, scope)
```

### `dispatch`

用于触发一个事件。

```
// @type - string
// @target - the caller
// @args - pass as many arguments as you want
EventBus.dispatch(type, target, args ...)
```

### `getEvents`

出于调试目的，会打印出添加的侦听器。

```
EventBus.getEvents()
```

## 约束与限制
在下述版本验证通过：
- DevEco Studio 版本: 4.0(4.0.3.512),SDK: API10（4.0.10.9）
- DevEco Studio 版本：3.1 Beta2(3.1.0.400)，SDK:API9 Release(3.2.11.9)

## 开源协议

本项目基于 [Apache License 2.0](https://gitee.com/lgrong2303/openharmony_tpc_samples/blob/EventBus/EventBus/LICENSE) ，请自由地享受和参与开源。

## 贡献代码

使用过程中发现任何问题都可以提 [Issue] 给我们，当然，我们也非常欢迎你给我们发 [PR] 。