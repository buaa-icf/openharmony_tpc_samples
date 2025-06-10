/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { libssh, SSH_KEYTYPES } from '@ohos/libssh';
import { fileIo } from '@kit.CoreFileKit';

@Entry
@Component
struct Index {
  ssh2Napi: libssh | undefined;
  privateKeyPath: string = getContext(this).cacheDir + "/privateKey" //沙箱路径私钥
  publicKeyPath: string = getContext(this).cacheDir + "/publicKey" //沙箱路径公钥
  sshServerIP: string = "47.122.65.73git " //sshserver地址
  sftpServerIP: string = "192.168.43.9" //sftpsever地址
  port: number = 9999 //端口
  username: string = "myuser" //账号
  password: string = "mypassword" //密码
  sftpDir: string = getContext(this).cacheDir //沙箱路径查询sftp指定的目录
  @State command: string = "ls" // 下发的指令

  build() {
    Row() {
      Column() {

        TextInput({ placeholder: "请输入指令", text: this.command }).onChange((command) => {
          this.command = command
        })

        Button("keygen")
          .margin({ top: 15 })
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.keyGen()
          })
        Button("setUser")
          .margin({ top: 15 })
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.setUser()
          })

        Button("setSFTPSha")
          .margin({ top: 15 })
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.setSFTPSha()
          })

        Button("startSFTPServer")
          .margin({ top: 15 })
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.startSFTPServer()
          })

        Button("sftpClient")
          .margin({ top: 15 })
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            //测试sftp服务
            this.sftpRequestRead()
          })

        Button("startSSHClient")
          .fontSize($r('app.float.page_text_font_size'))
          .margin({ top: 15 })
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.startSSHClient()
          })

        Button("sshclient creat shell")
          .fontSize($r('app.float.page_text_font_size'))
          .margin({ top: 15 })
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.ssh2Napi?.createShell()
          })

        Button("executeSSHCommand")
          .fontSize($r('app.float.page_text_font_size'))
          .margin({ top: 15 })
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.executeSSHCommand()
          })

        Button("stopSFTPServer")
          .fontSize($r('app.float.page_text_font_size'))
          .margin({ top: 15 })
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.stopSFTPServer()
          })

        Button("stopSSHClient")
          .fontSize($r('app.float.page_text_font_size'))
          .margin({ top: 15 })
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.stopSSHClient()
          })

        Button("getPublicKeyFingerprint")
          .fontSize($r('app.float.page_text_font_size'))
          .margin({ top: 15 })
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.getPublicKeyFingerprint()
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  keyGen() {
    if (!this.ssh2Napi) {
      this.ssh2Napi = new libssh();
    }
    //目前仅支持SSH_KEYTYPE_RSA、SSH_KEYTYPE_ECDSA、SSH_KEYTYPE_ED25519
    let result = this.ssh2Napi.keygen(this.privateKeyPath, this.publicKeyPath, SSH_KEYTYPES.SSH_KEYTYPE_ECDSA);
    console.log("keyGen result " + result)
  }

  setUser() {
    if (!this.ssh2Napi) {
      this.ssh2Napi = new libssh();
    }
    let result = this.ssh2Napi.setUser(this.username, this.password);
    console.log("setUser result " + result)
  }

  setSFTPSha() {
    if (!this.ssh2Napi) {
      this.ssh2Napi = new libssh();
    }
    let result = this.ssh2Napi.setSFTPKeyexChangeCer("curve25519-sha256")
    console.log("setSFTPKeyexChangeCer result " + result)
    result = this.ssh2Napi.setSFTPServerCer("aes256-ctr,aes128-ctr,aes192-ctr")
    console.log("setSFTPServerCer result " + result)
    result = this.ssh2Napi.setSFTPMessageCer("hmac-sha2-512,hmac-sha2-265")
    console.log("setSFTPMessageCer result " + result)
  }

  startSFTPServer() {
    if (!this.ssh2Napi) {
      this.ssh2Napi = new libssh();
    }
    let callback = (type: number) => {
      if (type === 2) {
        console.log("sftp启动成功")
      } else if (type === 3) {
        console.log("sftp启动失败")
      } else if (type === 4) {
        console.log("sftp客户端连接服务成功")
      } else if (type === 5) {
        console.log("停止sftp服务成功、断开连接")
      }
    }
    this.ssh2Napi.setUser(this.username, this.password);
    //若在sftp服务端设置多个用户请执行多次setUser
    // this.ssh2Napi.setUser("test", "test123");
    this.ssh2Napi.startSFTPServer(this.privateKeyPath, this.publicKeyPath, this.port, callback);
  }

  writeFile(path: string, value: ArrayBuffer): void {
    // 写入相关文件
    try {
      // 通过文件路径（沙箱） 打开文件：注意，如果是第一次创建文件，需要授予权限 fileIo.OpenMode.CREATE
      let file = fileIo.openSync(path, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.READ_ONLY);
      fileIo.truncateSync(path);
      fileIo.writeSync(file.fd, value);
      fileIo.fsyncSync(file.fd);
      fileIo.close(file.fd);
    } catch (e) {
    }
  }

  sftpRequestRead() {
    if (!this.ssh2Napi) {
      this.ssh2Napi = new libssh();
    }

    getContext().resourceManager.getMediaContent($r('app.media.publicKey').id, (error, value) => {
      if (error === null) {
        let arrayBuffer = value.buffer.slice(value.byteOffset, value.byteLength + value.byteOffset);
        this.writeFile(this.sftpDir + '/publicKey', arrayBuffer);
      }
    })

    getContext().resourceManager.getMediaContent($r('app.media.privateKey').id, (error, value) => {
      if (error === null) {
        let arrayBuffer = value.buffer.slice(value.byteOffset, value.byteLength + value.byteOffset);
        this.writeFile(this.sftpDir + '/privateKey', arrayBuffer);
      }
    })


    this.ssh2Napi.sftpRequestRead(this.sftpServerIP, this.port, this.privateKeyPath, this.sftpDir).then((result) => {
      console.log("sftpRequestRead result " + result)
    });
  }

  executeSSHCommand() {
    if (!this.ssh2Napi) {
      this.ssh2Napi = new libssh();
    }
    console.log("executeSSHComm command: " + this.command)
    this.ssh2Napi.executeSSHComm(this.command).then((result) => {
      console.log("executeSSHComm result: " + result)
    });
  }

  startSSHClient() {
    if (!this.ssh2Napi) {
      this.ssh2Napi = new libssh();
    }
    let callback = (type: number) => {
      if (type === 0) {
        console.log("sshClient启动成功")
      } else {
        console.log("sshClient启动失败，请先setUser或检查sshServer服务是否正常ping通")
      }
    }
    this.ssh2Napi.startSSHClient(this.sshServerIP, this.port, this.privateKeyPath, callback);
  }

  stopSFTPServer() {
    if (!this.ssh2Napi) {
      this.ssh2Napi = new libssh();
    }
    //注意停止sftp服务是异步的在startSFTPServer接口回调type=5即停止成功
    let result = this.ssh2Napi.stopSFTPServer();
    console.log("stopSFTPServer result " + result)

  }

  stopSSHClient() {
    if (!this.ssh2Napi) {
      this.ssh2Napi = new libssh();
    }
    let result = this.ssh2Napi.stopSSHClient();
    console.log("stopSSHClient result " + result)
  }

  async getPublicKeyFingerprint() {
    if (!this.ssh2Napi) {
      this.ssh2Napi = new libssh();
    }
    //获取公钥指纹
    let result = await this.ssh2Napi.getPublicKeyFingerprint(this.publicKeyPath);
    console.log("getPublicKeyFingerprint result " + result)
  }
}
