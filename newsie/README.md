# newsie

## Introduction

newsie is a library that implements the Network News Transfer Protocol (NNTP) client for use with OpenHarmony.

## How to Download

1. Install the library.

```
    ohpm install @ohos/newsie
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

2. Import the **Client**.

```
    import Client from '@ohos/newsie'
```

## Demo Code Sample

connect

Connects to the server. To run the demo and XTS properly, search for **xxx** in the project globally and replace it with the correct server IP address.

```js
this.client = new Client({
  host: "xxx.xxx.xxx.xxx",
  port: 8084,
});
await this.client.connect();
```

list

Obtains the newsgroup list.

```js
await this.client.list();
```

group

Obtains the information about a specified newsgroup and selects the newsgroup.

```js
await this.client.group(this.select_group);
```

newgroups

Obtains newsgroups after a specified time.
```js
await this.client.newgroups(new Date());
```

date

Obtains the server date.

```js
await this.client.date();
```

For more sample code, see the [Index](./entry/src/main/ets/pages/Index.ets) page in the demo project.

### Directory Structure

```
|-entry
    |-ets
    |   |-entryability
    |           |-EntryAbility.ts
    |   |-pages
    |           |-Index.ets             # Homepage demo
|-library # newsie library
```

## Available APIs

| Name         | Description                         | Remarks           |
| --------------- |-----------------------------| --------------- |
| connect         | Connects to the server.                      |
| list            | Obtains all newsgroups.                    |
| group           | Obtains and selects a newsgroup.                    |
| newgroups       | Obtains newsgroups after a specified time.                | The time is in the UTC format.|
| newnews         | Obtains articles in a newsgroup after a specified time.          |
| listActive      | Obtains the article list.                       |
| listNewsgroups  | Obtains newsgroups.                      |
| listOverviewFmt | Obtains partial information of a newsgroup.                 |
| hdr             | Sends an HDR command.                  |
| listGroup       | Obtains all article IDs.                    |
| article         | Obtains article details.                       |
| head            | Obtains the header information of an article.                      |
| body            | Obtains the body information of an article.                     |
| stat            | Checks whether an article exists.                   |
| over            | Obtains all information of an article.                    |
| help            | Obtains the help information.                     |
| capabilities    | Returns the server capability list.                  |
| date            | Returns the server date.                    |
| modeReader      | Switches the mode.                       |
| quit            | Ends a session.                       |
| listHeaders     | Sends the **LISTHEADERS** command.          |
| last            | Obtains the last article.                      |
| next            | Obtains the next article.                      |
| listDistribPats | Sends the **LISTDISTRIBPATS** command.      |
| listActiveTimes | Sends the **LISTACTIVETIMES** command.      |
| ihave           | Notifies the server that there is such an article. If the server requires the article, it returns 335.|
| check           | Checks.                         |
| modeStream      | Sends the **MODESTREAM** command.           |
| slave           | Sends the **SLAVE** command.                |
| compressDeflate | Compresses.                         |
| post            | Posts.                         |

For more details, see [Official Documentation](https://gitlab.com/timrs2998/newsie/-/blob/master/README.md) and [Unit Test Cases](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/newsie/TEST.md).
## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/newsie
```
### Constraints

This project has been verified in the following versions:

DevEco Studio: 4.1 Canary2 (4.1.3.313), SDK: API 11 (4.1.3.1)
DevEco Studio: 4.0.1.400, SDK: API 10 (4.0.0.24)

### License

This project is licensed under [GNU AFFERO GENERAL](./LICENSE).
 

### How to Contribute

If you find any problem when using the project, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or
a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).
