

# @ohos/xmpp_tls

## 简介

>本软件是参照开源软件 [@xmpp/tls](https://github.com/xmppjs/xmpp.js/tree/main/packages/tls)源码并用 TypeScript 语言实现了相关功能，在OpenHarmony上提供了一个用于与xmpp（Extensible Messaging and Presence Protocol）服务器建立加密TLS连接的library

## 已支持功能
- 数据加密：可以对XMPP协议中传输的数据进行加密，确保消息传输过程中的数据安全和隐私。
- 身份验证：可以对服务器和客户端的身份进行验证，确保连接到的是真正的服务器和客户端。
- 自动证书生成和管理：XMPP协议支持使用STARTTLS命令来明确启动TLS会话，并支持使用SSL/TLS证书的自动生成和管理。
- 安全通信：TLS加密可以确保XMPP协议中的消息传输和通信的安全性，避免消息被窃听或篡改。
## 下载安装

1. 参考安装教程 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

2. 安装命令如下：
```
 ohpm install @ohos/xmpp_tls
```

## 接口和属性列表
接口列表

| **接口**         | 参数                                                         | 功能                   |
| ---------------- | ------------------------------------------------------------ | ---------------------- |
| connect(service) | `service` 是一个字符串，格式为`xmpp://<username>@<host>:<port>`。 | 连接到指定服务器和端口 |
| write(data, fn)  | `data` 是一个Buffer或字符串，`fn` 是一个回调函数，连接写入完成后调用。 | 向套接字写入数据       |
| end()            | 无                                                           | 关闭套接字连接         |

## 使用示例
```
import { client, xml, Options } from '@ohos/xmpp_client';
@Entry
@Component
struct TcpSocketPage {
  @State status: string = "offline";
  @State message: string = 'Hello World';
  @State sendMessage: string = ""
  @State contact: string = ""
  @State TAG: string = 'NETSTACK'
  private options: Options = {
    service: 'xxxx://xxxxx:xxxx', //测试网站地址
    domain: 'xxxxxx',
    resource: 'xxxxxxxx',
    username: "xxxxxxxx",
    password: "xxxxxxxx",
  }
  private xmpp = client(this.options); //连接服务
  private onError = (err: Error) => {
    console.info('xmpp-❌', JSON.stringify(err.message));
    console.info('xmpp-❌', JSON.stringify(err.stack));
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
    const presence = xml(
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
  aboutToDisappear(){
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

## 使用说明
#### 在XMPP连接的流（stream）上注册一个中间件（middleware）处理函数
```
 //创建一个xmpp的服务
 private options: Options = {
    service: 'xxxx://xxxx:xxxx', //测试网站地址
    domain: 'xxxxx',
    resource: 'xxxxxxxx',
    username: "xxxxxxxx",
    password: "xxxxxxxx",
  }
  private xmpp = client(this.options); //连接服务
  //服务器地址以xmpps开头就是要创建TLS连接，此外网服务器的加密端口为5223
    this.xmpp.start();//连接
    this.xmpp.send(message)//发送消息
    this.xmpp.stop();//关闭
```

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望xmpp_tls库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/xmpp_tls
```

## 约束与限制
在下述版本验证通过：
- DevEco Studio 版本： 5.0.3.200,OpenHarmony SDK:API12 (5.0.0.21-Canary2)。
## 目录结构
````
|---- @ohos/xmpp_tls
|     |---- entry  # 示例代码文件夹
|           |---- src  
|                   |---- main  #sample示例代码
|                   |---- ohosTest  #xts示例代码
|     |---- library  # @ohos/xmpp_tls 库文件夹
|           |---- ets
|                 |---- lib  # 主要依赖
|                 |---- types  # 对外接口文件夹
|           |---- index.js  # 主入口文件
|           |---- index.d.ts  # 主对外接口声明文件
|     |---- README.md  # 安装使用方法    
|     |---- README_zh.md  # 安装使用方法                
````
## 贡献代码
使用过程中发现任何问题都可以提[Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)，当然，也非常欢迎提[PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。
## 开源协议
本项目基于[ISC license](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/xmpp_tls/LICENSE)，请自由地享受和参与开源。