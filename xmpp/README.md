# @xmpp/client

## 简介

[@xmpp/client](https://github.com/xmppjs/xmpp.js) 是一个用于构建基于XMPP（可扩展通讯和即时消息传递协议）的客户端的 库。XMPP是一种开放标准的通信协议，通常用于实现即时通讯和在线实时交流。本库基于[xmpp.js](https://github.com/xmppjs/xmpp.js)原库0.13.1版本进行适配，使其可以运行在 OpenHarmony，并沿用其部分现有用法和特性。

## 已支持功能

- xmpp与服务端建立连接
- xmpp与服务端重连
- xmpp与服务器断连
- xmpp与服务端进行通讯
- xmpp监听登录状态回调
- xmpp监听错误回调
- xmpp监听当前状态回调

## 下载安装

```
 ohpm install @xmpp/client
```

## 需要权限

```
ohos.permission.INTERNET
ohos.permission.GET_NETWORK_INFO
```

## 接口和属性列表

接口列表

| **接口**                                | 参数                | 功能                       |
| --------------------------------------- | ------------------- | -------------------------- |
| let xmpp=client(options:Options)        | Options：连接配置项 | 配置连接参数               |
| xmpp.on('error',(err)=>{})              | 'error':string      | 监听错误信息回调           |
| xmpp.on('online',async(address)=>{})    | 'online':string     | 监听在线信息回调           |
| xmpp.on('status',（status，value）=>{}) | 'status':string     | 监听状态，回调给出当前状态 |
| xmpp.on('stanza',(stanza)=>{})          | 'stanza':string     | 监听消息以及其他操作       |
| xmpp.start()                            | 无                  | 开始连接                   |
| xmpp.send(xml({}))                      | xml:xml实例         | 以xml格式的方式发送消息    |
| xmpp.stop()                             | 无                  | 断开连接                   |



## 使用示例

因为xmpp是基于XMPP协议的通信库，所以应连接基于XMPP协议的服务器，本地测试选用的是openfire作为xmpp测试服务端，需要测试通讯功需要用到Spark(Spark 是一个开源的、跨平台的即时通讯客户端，基于 XMPP 协议，提供了丰富的即时通讯功能和易用的用户界面)。

### 配置openfire

（1）访问Openfire官网：https://www.igniterealtime.org/projects/openfire/，选择合适的操作系统进行下载。

（2）选择服务器设置（选默认.注意数据库如果没有配置外部数据库，则选嵌入式数据库）。

（6）登录到：[Openfire 管理界面。](http://localhost:9090/login.jsp)

（7）用amdin账户登录，选择服务器设置，可以查看此服务器的名称、主机名。

（8）选择用户/用户群->新建用户->输入用户信息。

### 使用spark

（1）下载地址：[Ignite Realtime: Spark IM Client](https://www.igniterealtime.org/projects/spark/) 下载合适操作系统软件。

（2）使用刚在openfire中的新建的用户进行登录

```javascript

import {client, xml, Options } from '@xmpp/client';

@Entry
@Component
struct Index {
  @State status: string = "offline";
  @State message: string = 'Hello World';
  @State sendMessage: string = ""
  @State contact: string = ""
  private options: Options = {
    service: 'xmpp://10.50.80.51:5222/', 替换自己的服务器地址
    domain: '10.50.80.51',              //服务器名称
    resource: 'minint-5b5r6sm',        //主机名
    username: "cq",					  //openfire注册用户的用户名
    password: "123456"				//openfire注册的用户密码
  }
  private xmpp = client(this.options); //创建xmpp实例

  aboutToAppear(): void {
    this.xmpp.on('error', (err) => {//监听错误信息
      console.info('xmpp-❌', JSON.stringify(err.message));
    });
    this.xmpp.on('offline', () => {//离线状态
      console.info('xmpp--', 'offline');
    });
    this.xmpp.on('status', (status, value) => {//监听当前状态
      this.status = status
    });
    this.xmpp.on('online', async (address: ESObject) => {//在线
      console.log('🗸', 'online as', address);
      const presence = xml(
        'presence',
        {},
        xml('show', {}, 'chat'),
        xml('status', {}, 'presence!')
      );
      this.xmpp.send(presence);
    });
    this.xmpp.on('stanza', (stanza) => {
      this.contact = stanza.attrs.from
      if (stanza.is('presence') && stanza.attrs.type === 'subscribe') {
        this.contact = stanza.attrs.from
        this.xmpp.send(xml('presence', { to: stanza.attrs.from, type: 'subscribed' }));
      }
      if (stanza.is('message') && stanza.attrs.from !== this.xmpp.jid) {
        stanza.children.forEach((child: ESObject) => {
          if (child.name === 'body') {
            console.log("xmpp---message" + child.text())
            this.message = child.text()
          }
        });
      }
    });
  }

  build() {
    Row() {
      Column() {
        Text("当前状态：" + this.status)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
        Text("收到消息：" + this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30 })
        Button("连接").fontSize(30)
          .width("60%")
          .onClick(() => {
            this.xmpp.start();
          }).margin({ top: 30 })
        TextInput({ placeholder: "请输入消息" })
          .margin({ top: 30 })
          .fontSize(30)
          .width("60%")
          .height(100)
          .onChange((value: string) => {
            this.sendMessage = value;
          })


        Button("发送").fontSize(30)
          .width("60%")
          .onClick(() => {
            const message = xml("message", { type: "chat", to: this.contact }, xml("body", {}, this.sendMessage));
            this.xmpp.send(message)


          }).margin({ top: 30 })

        Button("断开").fontSize(30)
          .width("60%")
          .onClick(() => {
            try {
              this.xmpp.stop();
            } catch (e) {
              console.info("xmpp ---- error -" + e.toString())
            }
          }).margin({ top: 30 })
      }
      .width('100%')
    }
    .height('100%')
  }
}

```

## 使用说明

### xmppAPI

#### 通过配置client参数创建xmpp实例

##### xmpp=client(options)

```javascript

 private options: Options = {
    service: 'xmpp://10.50.80.51:5222/', 替换自己的服务器地址
    domain: '10.50.80.51',              //服务器名称
    resource: 'minint-5b5r6sm',        //主机名
    username: "cq",					  //openfire注册用户的用户名
    password: "123456"				//openfire注册的用户密码
  }
  private xmpp = client(this.options); //创建xmpp实例
```

#### 监听错误回调

为方便起见，为所有支持的请求方法提供了别名。

- xmpp.on('error', (err) => {//监听错误信息});

```javascript
 this.xmpp.on('error', (err) => {//监听错误信息
      console.info('xmpp-❌', JSON.stringify(err.message));
    });
```

#### 监听状态回调

xmpp.on('status', (status) => {});

```javascript
xmpp.on('status', (status, value) => {//监听当前状态});
```

- message（消息）

- presence（在线状态）

  ```javascript
  xmpp.on('stanza', (stanza) => {
        if (stanza.is('presence') && stanza.attrs.type === 'subscribe') {//监听在线
          this.xmpp.send(xml('presence', { to: stanza.attrs.from, type: 'subscribed' }));
        }
        if (stanza.is('message') && stanza.attrs.from !== this.xmpp.jid) {//监听收到信息
          stanza.children.forEach((child: ESObject) => {
            if (child.name === 'body') {
              this.message = child.text()
            }
          });
        }
      });
  ```

#### 发送消息

xmpp.send(xml)

```javascript
const message = xml("message", { type: "chat", to: "JID" }, xml("body", {}, this.sendMessage));
//此示例为 message：这条xml发送一条消息，类型chat是聊天，to后跟的参数为JID，"body"后为要发送的信息
```



#### 错误码

- 错误常量

| 名称                   | 参数类型 | 可读 | 可写 | 说明           |
| ---------------------- | -------- | ---- | ---- | -------------- |
| Address already in use | number   | 是   | 否   | 地址已经被使用 |
| Connection timed out   | number   | 是   | 否   | 连接超时       |
| Parameter error        | number   | 是   | 否   | 参数错误       |
| Permission denied      | number   | 是   | 否   | 没有权限       |

在下述版本验证通过：
DevEco Studio:4.1.3.500, 5.0.0.22-Canary2, SDK: API12

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。