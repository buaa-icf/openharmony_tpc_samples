## emailjs

### Overview

emailjs is a component developed on OpenHarmony to send HTML emails and attachments to an SMTP server.

### How to Download

```
$ ohpm install @ohos/emailjs
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

### How to Import

```
import { AUTH_METHODS, SMTPClient } from '@ohos/emailjs'
```

### How to Use

See the [demo](./entry/src/main/ets/pages/LoginPage.ets) project.

Note: Globally search *xxx* in the project and replace them with the actual email address and account password. To test an email carrying an attachment, generate `test.docx` and `test.xlsx` and store them in the `src/main/resources/rawfile` folder in the `entry` directory.

### Available APIs

|                    API                    |                   Parameter                   |         Description        |
| :-------------------------------------------: | :---------------------------------------: | :----------------------: |
|           new SMTPClient({options})           | options (For details, see the parameter description of `new SMTPClient`.)|      Creates an SMTP client.     |
| login(callBack: (err: Error, result: boolean) |       (err: Error, result: boolean)       |           Logs in.          |
|      SMTPClient#send(message, callback)       |             message, callback             | Sends a message and callback.|
|             new Message(headers)              |  headers (For details, see the parameter description of `new Message`.)  |         Creates a message.        |
|            Message#attach(options)            |     options (For details, see the parameter description of `attach`.)    |       Adds an attachment.      |
|            Message#checkValidity()            |                    N/A                    |   Checks whether the message format is correct.  |
|        new SMTPConnection(options={})         | options (For details, see the parameter description of `SMTPConnection`.)|      Creates an SMTPC connection.      |

#### Parameter Description of `new SMTPClient`

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

#### Parameter Description of `new Message`

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

#### Parameter Description of `attach`

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

#### Parameter Description of `SMTPConnection`

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

For more details, see [Official Documentation](https://github.com/eleith/emailjs/blob/main/README.md) and [Unit Test Cases](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/emailjs/TEST.md).

### Constraints

This project has been verified in the following version:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)

- DevEco Studio:4.0 Release(4.0.3.600),SDK API10(4.0.10.11)

The following mailbox types are supported: QQ, 163, 126, Sina, and Sohu mailboxes.

### Directory Structure

```
|-entry 
    |-ets
    |   |-entryability
    |           |-EntryAbility.ts
    |   |-pages
    |           |-LoginPage.ets             # Homepage demo
    |           |-SendMailPage.ets
|-SMTP
    |-ets # Processes HTML emails and attachments sent to any SMTP server.
    |-js   # Adapts to the polyfill solution of the node.
```

### How to Contribute

If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

### License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/emailjs/LICENSE).
