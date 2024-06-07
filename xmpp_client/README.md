# @ohos/xmpp_client

## 简介

>本软件是参照开源软件[@xmpp/client](https://github.com/xmppjs/xmpp.js) 是一个用于构建基于XMPP（可扩展通讯和即时消息传递协议）的客户端的 库。XMPP是一种开放标准的通信协议，通常用于实现即时通讯和在线实时交流。

## 已支持功能

- xmpp与服务端建立连接
- xmpp与服务端重连
- xmpp与服务器断连
- xmpp与服务端进行通讯
- xmpp监听登录状态回调
- xmpp监听错误回调
- xmpp监听当前状态回调

## 下载安装
1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：

```
 ohpm install @ohos/xmpp_client
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

```
import { client,Client, xml, Options } from '@ohos/xmpp_client';
import { Element } from '@ohos/xmpp_xml';

@Entry
@Component
struct WebSocketPage {
  @State status: string = "offline";
  @State message: string = 'Hello World';
  @State sendMessage: string = ""
  @State contact: string = ""
  private options: Options = {
    service: 'ws://xx.xx.xx.xx:xxxx/ws', //xx.xx.xx.xx(服务器地址) xxxx 服务端口
    domain: 'xx.xx.xx.xx',               //服务器名称(xx.xx.xx.xx)
    resource: 'xx.xx.xx.xx',             //主机名(默认为服务器地址)
    username: "xxx",					 //openfire注册用户的用户名
    password: "xxx"				         //openfire注册的用户密码
  }
  
  private xmpp = client(this.options); //创建xmpp实例

  private onError = (err: Error) => {
    console.info('xmpp-❌', JSON.stringify(err.message));
  }
  
  private onOffline = () => {
    console.info('xmpp--', 'offline');
  }
  
  private onStanza = (stanza: ESObject) => {
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
  }
  
  private onStatus = (status: string, value: string) => {
    this.status = status
    console.info("xmpp-response --" + "status--" + status + "---value---" + value)
  }
  
  private onLine = async (address: ESObject) => {
    console.log('🗸', 'online as', address);
    const presence:Element  = xml(
      'presence',
      {},
      xml('show', {}, 'chat'),
      xml('status', {}, 'presence!')
    );
    this.xmpp.send(presence);
  }

  aboutToAppear() {
    this.xmpp.on('error', this.onError);
    this.xmpp.on('offline',this.onOffline);
    this.xmpp.on('status', this.onStatus);
    this.xmpp.on('online', this.onLine);
    this.xmpp.on('stanza',this.onStanza);
  }
  
  async aboutToDisappear(){
    await this.xmpp.stop();
    this.xmpp.off('error',this.onError)
    this.xmpp.off('offline',this.onOffline)
    this.xmpp.off('status',this.onStatus)
    this.xmpp.off('online',this.onLine)
    this.xmpp.off('stanza',this.onStanza)
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
              console.info("stop ---- error -" + e.toString())
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
##### 下面options中service属性值中xmpp可替换为xmpps、xmpp、ws、wss
- xmpp对应tcpSocket连接,例如:xmpp://xxxx:xxxx
- xmpps对应tlsSocket连接,也就是加密连接,服务端需验证ca证书,例如:xmpps://xxxx:xxxx
- ws对应webSocket连接,例如:ws://xxxx:xxxx/ws/
- wss对应webSocket加密连接,服务端需验证ca证书,例如:wss://xxxx:xxxx/ws/
```
 private options: Options = {
    service: 'xmpp://xx.xx.xx.xx:xxxx/', //xx.xx.xx.xx(服务器地址) xxxx 服务端口
    domain: 'xx.xx.xx.xx',               //服务器名称(xx.xx.xx.xx)
    resource: 'xx.xx.xx.xx',             //主机名(默认为服务器地址)
    username: "xxx",					 //openfire注册用户的用户名
    password: "xxx"				         //openfire注册的用户密码
  }
  private xmpp = client(this.options); //创建xmpp实例
```

#### 监听错误回调

为方便起见，为所有支持的请求方法提供了别名。
异常监听
```
  private onError = (err: Error) => {
    console.info('xmpp-❌', JSON.stringify(err.message));
  }
  
  this.xmpp.on('error', this.onError);
```
状态监听
#### 监听状态回调

```
 private onStatus = (status: string, value: string) => {
    this.status = status
    console.info("xmpp-response --" + "status--" + status + "---value---" + value)
  }
  this.xmpp.on('status', this.onStatus);
```

- message（消息）

- presence（在线状态）

  ```
   
   private onStanza = (stanza: ESObject) => {
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
  }
  this.xmpp.on('stanza',this.onStanza)
  ```

#### 发送消息

xmpp.send(xml)

```
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


## 目录结构
````
|---- @ohos/xmpp_client
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # 功能库文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README.md  # 安装使用方法                    
````

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 5.0.3.200 OpenHarmony SDK:API12 (5.0.0.21-Canary2)


## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于ISC，请自由地享受和参与开源。