# signalr

## Introduction

> SignalR is a library for enabling low-latency, bidirectional, and event-based communication between clients and servers. It is built on top of the WebSocket protocol and provides additional guarantees, such as falling back to HTTP long polling or automatic reconnection.

### Notes:
- SignalR supports connections based on HTTP and HTTPS (TLS) protocols;
- Supports multiple transport methods: WebSockets, Server-Sent Events, Long Polling;

## Demonstration

![avatar](ScreenShots/演示.gif)

## Download and Installation

```shell
ohpm install @ohos/signalr
```
For more information on OpenHarmony ohpm environment configuration, please refer to [How to install OpenHarmony ohpm packages](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md).

## X86 Emulator Configuration

[Running Apps/Services on an Emulator](https://developer.huawei.com/consumer/cn/deveco-developer-suite/enabling/kit?currentPage=1&pageSize=100).

## Usage Instructions

### Prerequisite: Configure Network Permissions

Before using this library, you need to configure network permissions in the `entry/src/main/module.json5` file:

```json
"requestPermissions": [
  {
    "name": "ohos.permission.INTERNET",
    "reason": "$string:internet_permission_reason",
    "usedScene": {
      "abilities": ["EntryAbility"],
      "when": "inuse"
    }
  }
]
```

### Steps

1. Import the dependency library

```typescript
import { HubConnectionBuilder, HubConnection, HubConnectionState, LogLevel, HttpTransportType, IHttpConnectionOptions, ISubscription } from '@ohos/signalr';
```

2. Initialize the SignalR client

```typescript
hubConnection: HubConnection | null = null;
```

3. Set connection configuration and listen for events

```typescript
// Create connection configuration
const connectionOptions: IHttpConnectionOptions = {
  headers: {
    'User-Agent': 'HarmonyOS-SignalR-Client/1.0'
  },
  skipNegotiation: false,
  transport: HttpTransportType.WebSockets // or other transport methods
};

// Create the connection
this.hubConnection = new HubConnectionBuilder()
  .withUrl('http://yourserver.com/yourhub', connectionOptions)
  .configureLogging(LogLevel.Debug)
  .withKeepAliveInterval(15000) // Keep-alive interval of 15 seconds
  .withAutomaticReconnect([0, 2000, 10000, 30000]) // Reconnection intervals
  .build();
```

4. Connect to the server

```typescript
await this.hubConnection.start();
```

5. Set up listeners for user messages, joins, and leaves

```typescript
// Listen for received messages
this.hubConnection.on('ReceiveMessage', (user: string, message: string) => {
  console.log(`${user}: ${message}`);
});

// Listen for user joins
this.hubConnection.on('UserJoined', (userName: string) => {
  console.log(`${userName} joined the chat room`);
});

// Listen for user leaves
this.hubConnection.on('UserLeft', (userName: string) => {
  console.log(`${userName} left the chat room`);
});
```

6. Send a message to the server

```typescript
await this.hubConnection.invoke('SendMessage', userName, message);
```

7. Set up connection state listeners

```typescript
// Connection closed event
this.hubConnection.onclose((error?: Error) => {
  if (error) {
    console.error('Connection closed unexpectedly:', error);
  } else {
    console.log('Connection closed normally');
  }
});

// Reconnection event
this.hubConnection.onreconnecting((error?: Error) => {
  console.log('Reconnecting...');
});

this.hubConnection.onreconnected((connectionId?: string) => {
  console.log('Reconnection successful:', connectionId);
});
```

8. Close the server connection

```typescript
await this.hubConnection.stop();
```

9. Streaming Data Transfer

```typescript
// Receive stream data
const streamResult = this.hubConnection.stream<number>('StreamData', 10);

const subscription = streamResult.subscribe({
  next: (item: number) => {
    console.log('Received stream data:', item);
  },
  error: (err: Error) => {
    console.error('Stream transmission error:', err);
  },
  complete: () => {
    console.log('Stream transmission complete');
  }
});

// Stop the stream transmission
subscription.dispose();
```

10. Additional Notes

- The sample code provides a complete chat application demo. You can modify it according to your own needs.

## API Reference

- Initialize the client

```typescript
hubConnection: HubConnection = new HubConnectionBuilder()
  .withUrl(url, options)
  .build();
```

- Configure connection URL and options

```typescript
withUrl(url: string, options?: IHttpConnectionOptions): HubConnectionBuilder
```

- Configure logging level

```typescript
configureLogging(logLevel: LogLevel): HubConnectionBuilder
```

- Set server timeout

```typescript
withServerTimeout(milliseconds: number): HubConnectionBuilder
```

- Set keep-alive interval

```typescript
withKeepAliveInterval(milliseconds: number): HubConnectionBuilder
```

- Configure automatic reconnection

```typescript
withAutomaticReconnect(retryDelays?: number[]): HubConnectionBuilder
```

- Start the connection

```typescript
start(): Promise<void>
```

- Stop the connection

```typescript
stop(): Promise<void>
```

- Get connection state

```typescript
state: HubConnectionState
```

- Register an event listener

```typescript
on(methodName: string, newMethod: (...args: (string | number | boolean | object)[]) => void): void
```

- Call a server method

```typescript
invoke<T = object>(methodName: string, ...args: (string | number | boolean | object)[]): Promise<T>
```

- Send a message (without waiting for a response)

```typescript
send(methodName: string, ...args: (string | number | boolean | object)[]): Promise<void>
```

- Subscribe to a stream

```typescript
stream<T>(methodName: string, ...args: (string | number | boolean)[]): IStreamResult<T>
// Example: stream<number>('StreamData', 10)
```

- Stream subscription management

```typescript
interface ISubscription<T> {
  dispose(): void; // Unsubscribe from the stream
}
```

- Listen for connection close

```typescript
onclose(callback: (error?: Error) => void): void
```

- Listen for reconnection

```typescript
onreconnecting(callback: (error?: Error) => void): void
onreconnected(callback: (connectionId?: string) => void): void
```

- Transport type enum

```typescript
enum HttpTransportType {
  None = 0,
  WebSockets = 1,
  ServerSentEvents = 2,
  LongPolling = 4
}
```

- Connection state enum

```typescript
enum HubConnectionState {
  Disconnected = "Disconnected",
  Connecting = "Connecting", 
  Connected = "Connected",
  Disconnecting = "Disconnecting",
  Reconnecting = "Reconnecting"
}
```

- Log level enum

```typescript
enum LogLevel {
  Trace = 0,
  Debug = 1,
  Information = 2,
  Warning = 3,
  Error = 4,
  Critical = 5,
  None = 6
}
```

## About Obfuscation
- For code obfuscation, please refer to [Introduction to Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want to prevent the @ohos/signalr library from being obfuscated during the code obfuscation process, you need to add the corresponding exclusion rule in the obfuscation configuration file `obfuscation-rules.txt`:
```
-keep
./oh_modules/@ohos/signalr
```

## Constraints and Limitations

Verified on the following versions:

- IDE: DevEco Studio 5.1.0.849; SDK: API18 (5.1.0.125).
- IDE: DevEco Studio 5.1.1.823; SDK: API19 (5.1.1.823).

## Directory Structure
```
|---- signalr
|     |---- entry  # Sample code folder
|           |---- src # Demo source code directory
|                 |---- main # Main code
|                       |---- ets # ArkTS code
|                             |---- pages # Pages directory
|                                   |---- Index.ets # Main page (Chat Demo)
|     |---- library  # SignalR library
|           |---- src # Library source code directory
|                 |---- main # Main code
|                       |---- ets # ArkTS code
|                             |---- src # Core classes directory
|                                   |---- HubConnection.ts # Hub connection core class
|                                   |---- HubConnectionBuilder.ts # Connection builder
|                                   |---- index.ts # Exported interfaces
|                                   |---- HarmonyHttpClient.ts # HarmonyOS HTTP client
|                                   |---- HarmonyWebSocketTransport.ts # WebSocket transport
|     |---- README.md  # Installation and usage instructions
```

## Contributing

If you encounter any issues during use, you can submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues). We also welcome you to submit a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to contribute to the project.

## Open Source License

This project is based on the [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/tree/master/SignalR/LICENSE). Please feel free to enjoy and participate in open source.