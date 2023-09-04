## SMTP

### 介绍

SMTP是一个基于OpenHarmony系统适配开发的，提供一个向任何 SMTP 服务器发送 HTML 电子邮件和附件的能力。

### 下载

```
    $ ohpm install @ohos/emailjs
```

OpenHarmony ohpm
环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

### 导入

```
    import { XXXXXXXX } from '@ohos/emailjs'
```

### 使用说明

参考该[Demo](./entry/src/main/ets/pages/LoginPage.ets)工程

### 接口说明

|                      方法名                      |                入参                 |       接口描述       |
|:---------------------------------------------:|:---------------------------------:|:----------------:|
|           new SMTPClient({options})           | options(参照如下 new SMTPClient 参数说明) |    创建SMTP客户端     |
| login(callBack: (err: Error, result: boolean) |   (err: Error, result: boolean)   |        登录        |
|      SMTPClient#send(message, callback)       |         message, callback         | 发送信息及其回调callback |
|             new Message(headers)              |  headers(参照如下 new Message 参数说明)   |       构建信息       |
|            Message#attach(options)            |     options(参照如下 attach 参数说明)     |      添加附件信息      |
|            Message#checkValidity()            |                 无                 |    验证消息格式是否正确    |
|        new SMTPConnection(options={})         | options(参照如下 SMTPConnection 参数说明) |    构建SMTPC链接     |

#### new SMTPClient 参数说明

```
  // options is an object with the following recognized schema:
const options = {
	user, // username for logging into smtp
	password, // password for logging into smtp
	host, // smtp host (defaults to 'localhost')
	port, // smtp port (defaults to 25 for unencrypted, 465 for `ssl`, and 587 for `tls`)
	ssl, // boolean or object (if true or object, ssl connection will be made)
	tls, // boolean or object (if true or object, starttls will be initiated)
	timeout, // max number of milliseconds to wait for smtp responses (defaults to 5000)
	domain, // domain to greet smtp with (defaults to os.hostname)
	authentication, // array of preferred authentication methods ('PLAIN', 'LOGIN', 'CRAM-MD5', 'XOAUTH2')
	logger, // override the built-in logger (useful for e.g. Azure Function Apps, where console.log doesn't work)
};
```

#### new Message 参数说明

```
const headers = {
	from, // sender of the format (address or name <address> or "name" <address>)
	to, // recipients (same format as above), multiple recipients are separated by a comma
	cc, // carbon copied recipients (same format as above)
	bcc, // blind carbon copied recipients (same format as above)
	text, // text of the email
	subject, // string subject of the email
	attachment, // one attachment or array of attachments
};
```

#### attach 参数说明

```
const options = {
	// one of these fields is required
	path, // string to where the file is located
	data, // string of the data you want to attach
	stream, // binary stream that will provide attachment data (make sure it is in the paused state)
	// better performance for binary streams is achieved if buffer.length % (76*6) == 0
	// current max size of buffer must be no larger than Message.BUFFERSIZE

	// optionally these fields are also accepted
	type, // string of the file mime type
	name, // name to give the file as perceived by the recipient
	charset, // charset to encode attatchment in
	method, // method to send attachment as (used by calendar invites)
	alternative, // if true, will be attached inline as an alternative (also defaults type='text/html')
	inline, // if true, will be attached inline
	encoded, // set this to true if the data is already base64 encoded, (avoid this if possible)
	headers, // object containing header=>value pairs for inclusion in this attachment's header
	related, // an array of attachments that you want to be related to the parent attachment
};
```

#### SMTPConnection 参数说明

```
const options = {
	user, // username for logging into smtp
	password, // password for logging into smtp
	host, // smtp host (defaults to 'localhost')
	port, // smtp port (defaults to 25 for unencrypted, 465 for `ssl`, and 587 for `tls`)
	ssl, // boolean or object (if true or object, ssl connection will be made)
	tls, // boolean or object (if true or object, starttls will be initiated)
	timeout, // max number of milliseconds to wait for smtp responses (defaults to 5000)
	domain, // domain to greet smtp with (defaults to os.hostname)
	authentication, // array of preferred authentication methods ('PLAIN', 'LOGIN', 'CRAM-MD5', 'XOAUTH2')
	logger, // override the built-in logger (useful for e.g. Azure Function Apps, where console.log doesn't work)
};
```

### 软件架构

```
|-entry 
    |-ets
    |   |-entryability
    |           |-EntryAbility.ts
    |   |-pages
    |           |-LoginPage.ets             #主页demo
    |           |-SendMailPage.ets
|-SMTP
    |-ets  #
    |-js   #
            
```

### 单元测试用例详情[TEST.md](./TEST.md)

### 约束与限制

在下述版本验证通过：

DevEco Studio: 4.0 Canary2(4.0.3.312), SDK: API10 (4.0.9.2)

### 开源协议

本项目基于 [MIT license](./LICENSE)
，请自由地享受和参与开源。

### 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。