# Jackrabbit

## Introduction

Jackrabbit uses TypeScript to implement functions similar to [jackrabbit](https://github.com/pagerinc/jackrabbit) on OpenHarmony. It supports the Advanced Message Queuing Protocol (AMQP) and can transmit asynchronous messages across processes.

Jackrabbit depends on the **amqplib** library and implements multiple message transfer modes on RabbitMQ.

## How to Install

1. [Install an OpenHarmony HAR.](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the installation command:

   ```
   ohpm install @ohos/jackrabbit
   ```
## Main Functions
1. Message publishing: Send messages of the JSON and string types, and set the configuration information for publishing messages.
2. Message consumption: Set the callback for receiving messages and configure consumption information.
3. Switch configuration: Set the switch type (direct, fanout, or topic), switch name, persistence status, and timeout status.
4. Queue configuration: Set the queue name, persistence status, and maximum length.
5. Easy-to-use amqp communication API: Compared with the APIs provided by amqplib, jackrabbit provides simple and easy-to-use APIs for switch and queue operations. The class abstraction of **Exchange** and **Queue** is added to the client. Compared with amqplib, amqplib needs to specify the switch or queue to be operated on the server through string parameters each time. Jackrabbit can obtain an Exchange/Queue object immediately after creating a switch or queue, and you only need to call the APIs of this object later.
6. Reconnection mechanism: Provide the reconnection mechanism that is not available in amqplib.

## How to Use
### Geting Started
1. You first need to set up the RabbitMQ environment.

2. There is a version mapping between RabbitMQ and Erlang. Unexpected problems may arise if the two versions do not match. For details, see [Erlang Version Requirements](https://www.rabbitmq.com/which-erlang.html).

3. Version mapping:

   1. RabbitMQ version **rabbitmq-server-3.10.7.exe**: https://github.com/rabbitmq/rabbitmq-server/releases/tag/v3.10.7
   2. Erlang version **otp_win64_25.0.exe**: https://www.erlang.org/patches/otp-25.0

4. By default, the guest of RabbitMQ can only be connected from localhost. The official solution is to modify the RabbitMQ configuration in the configuration file. The procedure is as follows:

   1. Find the RabbitMQ installation directory, for example, **rabbitmq-server-3.10.7**.

   2. In the **README.txt** file in **\rabbitmq_server-3.10.7\etc**, find the real RabbitMQ.

   3. Create the configuration file **rabbitmq.config** in **C:\Users\ %USERNAME %\AppData\Roaming\RabbitMQ** and write the following information into the file:

      ```
      [{rabbit, [{loopback_users, []}]}].
      ```

   4. Save and exit.

   5. Restart the RabbitMQ service.

      1. Press Win+R and enter cmd to open the CLI.

      2. Launch the Services Manager.

         ```
         SERVICES.MSC
         ```

      3. Find RabbitMQ and click Restart to restart the service.

5. Connect test PC to the network. Make sure that its IP address is the same as that of the server.

6. The library implementation depends on node modules such as buffer, stream, and events. The compilation can be performed only after polyfill is configured. For details about how to configure polyfill, see [openharmony-polyfill](https://gitcode.com/openharmony-sig/ohos_polyfill).

7. Compile and install the HAP on the test PC to perform the test cases.

8. For details about how to use the demo, see the implementation of the sample page.

### 1. Default switch

```
  receive(console: Console.Model) {
    if (this.rabbit) {
      return;
    }
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    let exchange = rabbit.default();
    let hello = exchange.queue({ name: 'hello_jackrabbit', prefetch: 0 });
    let onMessage=(data:ESObject)=> {
      console.log('received:%s', data);
    }
    hello.consume(onMessage, { noAck: true });
    this.rabbit = rabbit;
    console.info('start receiver');
  }
```

```
  send(console: Console.Model) {
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    let exchange = rabbit.default();
    let hello = exchange.queue({ name: 'hello_jackrabbit' });

    exchange.publish('Hello World!', { key: 'hello_jackrabbit' });
    exchange.on('drain', () => {
      console.info('Message sent: Hello World!')
      setTimeout(() => {
        rabbit.close();
      }, 100);
    });
  }
```

### 2. Direct-connection switch

```
  receiveEnglish(console: Console.Model) {
    if (this.rabbitEnglish) {
      return;
    }
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    let exchange = rabbit.default();
    let hello = exchange.queue({ name: 'task_queue', durable: true });

    hello.consume(onGreet);

    let onGreet=(data:ESObject, ack:ESObject)=> {
      console.log('Hello, ' + data.name + '!');
      ack();
    }

    this.rabbitEnglish = rabbit;
    console.info('start English receiver');
  }
```

```
  publish(console: Console.Model) {
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    let exchange = rabbit.default();
    let hello = exchange.queue({ name: 'task_queue', durable: true });

    exchange.publish({ name: 'Hunter' }, { key: 'task_queue' });
    exchange.on('drain', () => {
      console.info('Message sent: Hunter');
      setTimeout(() => {
        rabbit.close();
      }, 100);
    });
  }
```

### 3. Fanout switch

```
  receive(console: Console.Model) {
    if (this.rabbit) {
      return;
    }
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    let exchange = rabbit.fanout();
    let logs = exchange.queue({ exclusive: true });

    logs.consume(onLog, { noAck: true });
    // logs.consume(false); // stops consuming

    let onLog=(data:ESObject)=> {
      console.log('Received log:' + data);
    }

    this.rabbit = rabbit;
    console.info('start receiver');
  }
```

```
  send(console: Console.Model) {
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    let exchange = rabbit.fanout();

    exchange.publish('this is a log');
    exchange.on('drain', () => {
      console.info('Message sent: this is a log');
      setTimeout(() => {
        rabbit.close();
      }, 100);
    });
  }
```

### 4. Multi-queue matching

```
  receive(console: Console.Model) {
    if (this.rabbit) {
      return;
    }
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    let exchange = rabbit.direct('direct_logs_jackrabbit');
    let errors = exchange.queue({ exclusive: true, key: 'error' });
    let logs = exchange.queue({ exclusive: true, keys: ['info', 'warning'] });
    let toDisk = (data:ESObject, ack:ESObject)=> {
      console.log('Writing to disk:' + data.text);
      ack();
    }

    let toConsole=(data:ESObject, ack:ESObject)=> {
      console.log('Writing to console:' + data.text);
      ack();
    }

    errors.consume(toDisk);
    logs.consume(toConsole);


    this.rabbit = rabbit;
    console.info('start receiver');
  }
```

```
  send(console: Console.Model) {
    var rabbit = jackrabbit('amqp://' + this.serverIp);
    var exchange = rabbit.direct('direct_logs_jackrabbit');

    exchange.publish({ text: 'this is a harmless log' }, { key: 'info' });
    exchange.publish({ text: 'this one is more important' }, { key: 'warning' });
    exchange.publish({ text: 'pay attention to me!' }, { key: 'error' });
    exchange.on('drain', () => {
      console.info('Message sent.');
      setTimeout(() => {
        rabbit.close();
      }, 100);
    });
  }
```

### 5. Topic switch

```
  receive(console: Console.Model) {
    if (this.rabbit) {
      return;
    }
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    let exchange = rabbit.topic('topic_animals');
    let first=(data:ESObject, ack:ESObject)=> {
      console.log('First:' + data.text);
      ack();
    }

    let second=(data:ESObject, ack:ESObject)=> {
      console.log('Second:' + data.text);
      ack();
    }

    exchange
      .queue({ exclusive: true, key: '*.orange.*' })
      .consume(first);

    exchange
      .queue({ exclusive: true, keys: ['*.*.rabbit', 'lazy.#'] })
      .consume(second);


    this.rabbit = rabbit;
    console.info('start receiver');
  }
```

```
  send(console: Console.Model) {
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    let exchange = rabbit.topic('topic_animals');

    exchange
      .publish({ text: 'both queues 1' }, { key: 'quick.orange.rabbit' })
      .publish({ text: 'both queues 2' }, { key: 'lazy.orange.elephant' })
      .publish({ text: 'first queue 1' }, { key: 'quick.orange.fox' })
      .publish({ text: 'second queue 1' }, { key: 'lazy.brown.fox' })
      .publish({ text: 'second queue 2' }, { key: 'lazy.pink.rabbit' })
      .publish({ text: 'discarded' }, { key: 'quick.brown.fox' })
      .publish({ text: 'discarded' }, { key: 'orange' })
      .publish({ text: 'second queue 3' }, { key: 'lazy.orange.male.rabbit' })
      .on('drain', () => {
        console.info('Message sent.');
        setTimeout(() => {
          rabbit.close();
        }, 100);
      });
  }
```

### 6. One-to-one connection

```
  startServer(console: Console.Model) {
    if (this.rabbitServer) {
      return;
    }
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    const exchange = rabbit.default();
    const rpc = exchange.queue({ name: 'rpc_queue_jackrabbit', prefetch: 1, durable: false });

    const fib = (n) => {
      if (n === 0) {
        return 0;
      }

      if (n === 1) {
        return 1;
      }
      return fib(n - 1) + fib(n - 2);
    };

    const onRequest = (data:ESObject, reply:ESObject) => {
      console.log('got request for n:' + data.n);
      if (data.n > 30) {
        console.warn(`fib(${data.n}) may costs too mush time on device, replace to fib(30)`)
        data.n = 30;
      }
      reply({ result: fib(data.n) });
    };

    rpc.consume(onRequest);

    this.rabbitServer = rabbit;
    console.info('start rpc server');
  }
```

```
  startClient(console: Console.Model) {
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    const exchange = rabbit.default();
    const rpc = exchange.queue({ name: 'rpc_queue_jackrabbit', prefetch: 1, durable: false });

    const onReply = (data:ESObject) => {
      console.log('result:' + data.result);
      rabbit.close();
    };
    rpc.on('ready', () => {
      exchange.publish({ n: 30 }, {
        key: 'rpc_queue_jackrabbit',
        reply: onReply // auto sends necessary info so the reply can come to the exclusive reply-to queue for this rabbit instance
      });
    });
    console.info('Request fib(30), wait for reply.');
  }
```

### 7. Timeout check

```
  startClientTimeout(console: Console.Model) {
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    const exchange = rabbit.default();

    exchange.rpcClient('rpc_queue_jackrabbit_timeout', { n: 30 }, { timeout: 1000 }, (result) => {
      if (result && result instanceof Error) {
        console.error(result.toString());
      } else {
        console.info(result);
      }
    });
    console.info('Request fib(30), wait for reply(with 1s timeout).');
  }
```

```
  startClient(console: Console.Model) {
    let rabbit = jackrabbit('amqp://' + this.serverIp);
    const exchange = rabbit.default();

    // ensure queue is ready before sending out request
    const rpc = exchange.queue({ name: 'rpc_queue_jackrabbit_timeout', prefetch: 1, durable: false, autoDelete: true });
    rpc.on('ready', () => {

      exchange.rpcClient('rpc_queue_jackrabbit_timeout', { n: 30 }, null, (result) => {
        if (result && result instanceof Error) {
          console.error(result.toString());
        } else {
          console.info(result);
        }
      });
    });
    console.info('Request fib(30), wait for reply.');
  }
```

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the jackrabbit library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/jackrabbit
```

## Constraints

Jackrabbit has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)
- IDE: DevEco Studio Next, Developer Beta1 (5.0.3.121), SDK: API12 (5.0.0.16)

## Directory Structure

```
|---- Jackrabbit
|     |---- amqplib  # amqplib library
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|                 |---- callback_api.js  # Callback scripts
|                 |---- channel_api.js  # Promise scripts
|     |---- entry  # Sample code
|     |---- library  # Jackrabbit library
|           |----ets    
|                 |---- compat  # Compatibility utility
|                 |---- node_modules  # amqplib library
|                 |---- types  # External APIs
|                 |---- exchange.js  # Switch scripts
|                 |---- jackrabbit.js  # Jackrabbit scripts
|                 |---- queue.js  # Queue scripts
|     |---- screenshot  # Screenshots
|     |---- README_EN.md  # Readme
```

## How to Contribute

If you find any problem when using Jackrabbit, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/jackrabbit/LICENSE).
