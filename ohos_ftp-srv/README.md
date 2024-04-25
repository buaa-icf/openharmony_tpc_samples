# ohos_ftp-srv

## 简介

> ftp-srv是一个用于OpenHarmony的Ftp服务器库。通过ftp-srv，开发者可以轻松地创建和管理Ftp服务器，实现文件的上传、下载、目录查看、目录创建、目录删除等操作。

 ![jpeg](./preview/preview.gif)


## 下载安装
```shell
ohpm install @ohos/ftp-srv
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 需要权限
```shell
ohos.permission.INTERNET
ohos.permission.GET_NETWORK_INFO
```

## 使用说明

 在pages页面中使用

```js
//引入
import { FtpSrv } from '@ohos/ftp-srv';

const ftpSever = new FtpSrv({
    url: "ftp://localhost:8889",
    anonymous: true,
    pasvUrl: "localhost",
    pasvMin: 8881
});
ftpSever.on('login', (user: Option, resolve: Function, reject: Function) => {
    if (user.username === 'demo' && user.password === '123456' || user.username === 'anonymous') {
        resolve({ root: getContext(this).filesDir });
    } else {
        reject('Bad username or password');
    }
});
ftpSever.listen().then(() => {
    console.log('Ftp server is starting...')
});


interface Option {
    username: string,
    password: string
}
```

## 接口说明
一、`new FtpSrv({options})` option对应的字段参数功能

1. url
   `URL字符串，指定服务端连接的协议、主机名和端口`
2. pasvUrl
   `当在被动模式下连接握手过程中收到命令时，向客户端提供IP地址。`
3. pasvMin
   `被动模式连接的起始端口`
4. pasvMax
   `被动模式连接的结束端口`
5. tls
   `用于显式连接的TLS安全上下文对象`
6. anonymous
   `如果为 true，将允许客户端使用用户名进行身份验证anonymous，而不需要用户提供密码。`
7. blacklist
   `设置不允许执行的命令数组。`
8. whitelist
   `设置只允许执行的命令数组。`

二、`new FtpSrv` FtpSrv对象所提供的方法

1. `listen()` 启动服务端连接监听，开启ftp服务

2. `quit()` 断开服务端连接监听

3. `on(eventName, callback)` 提供监听事件，有如下：

   `on('login', ({connection, username, password}, resolve, reject) => { ... });`

   客户端尝试登录时触发，在这里可以通过用户名和密码判断是否为目标用户。

   `on('client-error', ({connection, context, error}) => { ... });`

   当客户端连接出现错误时触发。

   `on('disconnect', ({connection, id, newConnectionCount}) => { ... });`

   当客户端断开连接时触发。

   `on('closed', ({}) => { ... });`

   当FTP服务器关闭时触发。

   `on('server-error', ({error}) => { ... });`

   当FTP服务器出现错误时触发。
   

# 约束与限制

在下述版本验证通过：

- DevEco Studio: (5.0.3.122), SDK: API12 (5.0.0.17)

## 目录结构
````
|---- ohos_ftp-srv  
|     |---- entry  # 示例代码文件夹
|     |---- library  # ftp-srv库文件夹
|           |---- index.ts  # 对外接口
|           └─src/main/ets/commands
|                          ├─registration # ftp命令实现目录，包含各种命令的处理文件
|                          ├─index.ts # 命令类
|                          └─registry.ts # 注册的命令的处理文件
|           └─src/main/ets/connector
|                          ├─active.ts # 主动模式处理逻辑
|                          ├─base.ts # 模式处理基础类
|                          └─passive.ts # 被动模式处理逻辑
|           └─src/main/ets/helpers
|                          ├─escape-path.ts # 路径处理
|                          ├─event-emitter.ts # 事件监听处理类
|                          ├─file-stat.ts # 服务端交互客户端信息文件条目格式化处理
|                          ├─find-port.ts # 查询空闲端口
|                          ├─logger.ts # 日志打印处理
|                          ├─path-util.ts # 文件路径处理
|                          └─promise-util.ts # promise异步功能工具类
|                     |---- connection.ts  # FTP 连接处理逻辑
|                     |---- errors.ts  # 异常类
|                     |---- fs.ts  # 文件系统接口实现
|                     |---- index.ts  # ftp服务器启动监听等处理逻辑
|                     |---- messages.ts  # ftp状态码信息
|---- README.md  # 安装使用方法                    
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议
本项目基于 [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/ohos_ftp-srv/LICENSE) ，请自由地享受和参与开源。
