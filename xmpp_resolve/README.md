# @ohos/xmpp_resolve

## Introduction

>Based on the open source software [@xmpp/client-resolve](https://github.com/xmppjs/xmpp.js/tree/main/packages/client-resolve), this project uses TypeScript to implement similar capabilities. It provides OpenHarmony a library for resolving DNS and HTTP paths.

## Supported Features

- HTTP path resolution

## How to Install
1. Configure the OpenHarmony ohpm environment. For details, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Run the following installation command:

   ```
    ohpm install @ohos/xmpp_resolve
   ```

## Available APIs

Supported APIs

| API        | Parameter          | Description                           |
| ---------------- | -------------- | ------------------------------- |
| resolve(...args) | **args**: server address information| Resolves service information to obtain the HTTP path resolution result.|

## Example

```
improt {resolve} from "@ohos/xmpp_resolve";
resolve("example.com", "xmpp-client").then(records => {
  console.log(records);
});

```

## How to Use

#### Resolving DNS SRV and HTTP

```
The resolve API takes one or more parameters, including the server domain name and service type.
It returns a promise, which uses an array to contain the DNS SRV record and HTTP path resolution result.
If DNS resolution is supported, you can use dns.resolve independently.
```

## Constraints

This project has been verified in the following version:

- DevEco Studio: 5.0.3.200, OpenHarmony SDK: API 12 (5.0.0.21-Canary2)

## Directory Structure
````
|---- @ohos/xmpp_resolve
|     |---- entry  # Sample code
|           |---- src  
|                   |---- main  # Sample code
|                   |---- ohosTest  # xts code
|     |---- library  # @ohos/xmpp_resolve library
|           |---- ets
|                 |---- lib  # Main dependencies
|                 |---- types  # External APIs
|           |---- index.js  # Main entry file
|           |---- index.d.ts  # Main declaration file of the external APIs
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme                    
````
## How to Contribute

If you find any problem when using @ohos/xmpp_resolve, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under ISC License.
