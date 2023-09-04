## newsie

### 介绍

newsie 是一款实现了 NNTP 客户端协议的三方库，适用于openharmony。

### 下载

1 丶安装

```
    ohpm install @ohos/newsie
```

2 丶导入

```
    import Client from '@ohos/newsie'
```

### Demo 样例

connect

```js
this.client = new Client({
  host: "124.221.182.182",
  port: 8084,
});
await this.client.connect();
```

list

```js
await this.client.list();
```

group

```js
await this.client.group(this.select_group);
```

newgroups

```js
await this.client.newgroups(new Date());
```

date

```js
await this.client.date();
```

更多样例参照该 Demo 工程中[Index](./entry/src/main/ets/pages/Index.ets)页面

### 软件架构

```
|-entry
    |-ets
    |   |-entryability
    |           |-EntryAbility.ts
    |   |-pages
    |           |-Index.ets             #主页demo
|-newsie   # newsie
```

## 接口

| 模块名          | 功能                          | 备注            |
| --------------- |-----------------------------| --------------- |
| connect         | 连接服务器                       |
| list            | 获取全部新闻组                     |
| group           | 获取并选中文章                     |
| newgroups       | 获取某个时间后的新闻组                 | 时间为 UTC 时间 |
| newnews         | 获取某个新闻组下，某个时间后的文章           |
| listActive      | 文章列表                        |
| listNewsgroups  | 获取新闻组                       |
| listOverviewFmt | 获取新闻组的部分信息                  |
| hdr             | 发送 HDR 指令                   |
| listGroup       | 获取全部文章号                     |
| article         | 文章详情                        |
| head            | 文章头信息                       |
| body            | 文章主体信息                      |
| stat            | 判断文章是否存在                    |
| over            | 文章的全部信息                     |
| help            | 获取帮助指令                      |
| capabilities    | 返回服务端能力列表                   |
| date            | 返回服务端日期                     |
| modeReader      | 模式切换                        |
| quit            | 结束会话                        |
| listHeaders     | 发送 LISTHEADERS 指令           |
| last            | 上一篇文章                       |
| next            | 下一篇文章                       |
| listDistribPats | 发送 LISTDISTRIBPATS 指令       |
| listActiveTimes | 发送 LISTACTIVETIMES 指令       |
| ihave           | 知会服务端有这样一篇文章，如果服务端需要就返回 335 |
| check           | 检查                          |
| modeStream      | 发送 MODESTREAM 指令            |
| slave           | 发送 SLAVE 指令                 |
| compressDeflate | 压缩                          |
| post            | 提交                          |

更多模块的使用可参考[官方文档](https://gitlab.com/timrs2998/newsie/-/blob/master/README.md)，单元测试用例详情见[TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/newsie/TEST.md)

### 约束与限制

在下述版本验证通过：

DevEco Studio: 4.0.1.400, SDK: API10 (4.0.0.24)

### 开源协议

本项目基于 [GNU AFFERO GENERAL](./LICENSE)
，请自由地享受和参与开源。

### 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。
