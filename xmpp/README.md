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
 在entry的oh-package.json5的dependencies添加 "@xmpp/client": "file:../library_client"
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

在使用之前，因为xmpp是基于XMPP协议的通信库，所以应连接基于XMPP协议的服务器，本地测试选用的是openfire作为xmpp测试服务端，需要测试通讯功需要用到Spark(Spark 是一个开源的、跨平台的即时通讯客户端，基于 XMPP 协议，提供了丰富的即时通讯功能和易用的用户界面)

### 配置openfire

（1）访问Openfire官网：https://www.igniterealtime.org/projects/openfire/，选择合适的操作系统进行下载

（2)选择中文![img](file:///C:\Users\Administrator\AppData\Roaming\WeLink\appdata\IM\chenqiang_410@da913df0ba\ReceiveFiles\originalImgfiles\d8775695-2eff-4fab-820f-4a591800dea1.png)

（3）选择服务器设置（选默认）

![img](file:///C:\Users\Administrator\AppData\Roaming\WeLink\appdata\IM\chenqiang_410@da913df0ba\ReceiveFiles\originalImgfiles\e7980f20-8e75-4bc9-bb20-0a244bc56610.png)

（4）数据库选择（选择嵌入式数据库）

![img](file:///C:\Users\Administrator\AppData\Roaming\WeLink\appdata\IM\chenqiang_410@da913df0ba\ReceiveFiles\originalImgfiles\b8b9f1e1-190d-4206-bdcc-9248ffca0961.png)

（5）其余按照默认设置

（6）登录到：[Openfire 管理界面](http://localhost:9090/login.jsp)

（7）用amdin账户登录，选择服务器设置，可以查看此服务器的名称、主机名

![img](file:///C:\Users\Administrator\AppData\Roaming\WeLink\appdata\IM\chenqiang_410@da913df0ba\ReceiveFiles\originalImgfiles\e28010ad-07db-4b55-8832-2dc4130d55b5.png)

（8）新建用户

![img](file:///C:\Users\Administrator\AppData\Roaming\WeLink\appdata\IM\chenqiang_410@da913df0ba\ReceiveFiles\originalImgfiles\8033a69e-dd35-4358-8438-dfff5931768d.png)

### 配置spark

（1）使用在openfire中的新建的用户进行登录

![img](file:///C:\Users\Administrator\AppData\Roaming\WeLink\appdata\IM\chenqiang_410@da913df0ba\ReceiveFiles\ScreenShot\6f53dd95-8fdc-415d-8b67-64e6d4546f87.png)



```javascript
//查看到上图的主机名、和服务器名 
import {client, xml, Options } from '@xmpp/client';

@Entry
@Component
struct Index {
  @State status: string = "offline";
  @State message: string = 'Hello World';
  @State sendMessage: string = ""
  @State contact: string = ""
  private options: Options = {
    service: 'xmpp://10.50.80.51:5222/',//本机的服务器地址，一般是自己的ip4地址；端口为5222
    // service: 'wss://minint-5b5r6sm:7443/ws/',
    domain: '10.50.80.51',//替换自己的服务器名
    resource: 'minint-5b5r6sm'//替换自己的主机名,
    username: "admin",//这里可以使用自己的建立的账户
    password: "admin"
  }
  private xmpp = client(this.options); //连接服务

  aboutToAppear(): void {
    this.xmpp.on('error', (err) => {
      console.info('NB-❌', JSON.stringify(err.message));
    });
    this.xmpp.on('offline', () => {
      console.info('NB--', 'offline');
    });
    this.xmpp.on('status', (status, value) => {
      this.status = status
    });
    this.xmpp.on('online', async (address: ESObject) => {
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
      if (stanza.is('message')&& stanza.attrs.from !== this.xmpp.jid){
        stanza.children.forEach((child: ESObject) => {
          if (child.name === 'body') {
            console.log("NB---message" + child.text())
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
        Button("TCP连接").fontSize(30)
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

        Button("TCP断开").fontSize(30)
          .width("60%")
          .onClick(() => {
            try {
              this.xmpp.stop();
            } catch (e) {
              console.info("cq ---- error -" + e.toString())
            }
          }).margin({ top: 30 })
      }
      .width('100%')
    }
    .height('100%')
  }
}

```

以上是我以admin这个账户登陆的，在spark中进行以下操作：

![image-20240424171156274](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240424171156274.png)