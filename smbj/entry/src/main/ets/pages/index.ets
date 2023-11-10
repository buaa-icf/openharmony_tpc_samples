/*
 * (The MIT License)

 * Copyright (c) 2021 Huawei Device Co., Ltd.

 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * 'Software'), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:

 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import { SMB2} from '@ohos/smbj'
import prompt from '@ohos.promptAction';


@Entry
@Component
struct Index {
  @State message: string = 'test'
  @State serverIP: string = '10.50.40.44'
  @State clientIP: string = '10.50.40.103'
  @State userName: string = 'Administrator'
  @State basePath :string = 'test_smbj'
  @State password: string = 'ck123321ck'
  @State foldName: string = ''
  @State newFoldName: string = ''
  @State content: string = ''
  @State fileName: string = ''
  @State log: string = 'log'
  @State readResult:string = ''
  @State handlePopup: boolean = false
  build() {
    Column() {
      TextInput({ placeholder: '服务器ip', text: this.serverIP })
        .placeholderColor(Color.Gray)
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .margin({ top: 20 })
        .onChange((value: string) => {
          this.serverIP = value
        })
      TextInput({ placeholder: '客户端ip', text: this.clientIP })
        .placeholderColor(Color.Gray)
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .margin({ top: 20 })
        .onChange((value: string) => {
          this.clientIP = value
        })
      TextInput({ placeholder: 'share', text: this.basePath })
        .placeholderColor(Color.Gray)
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .margin({ top: 20 })
        .onChange((value: string) => {
          this.basePath = value
        })
      TextInput({ placeholder: 'UserName', text: this.userName })
        .placeholderColor(Color.Gray)
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .margin({ top: 10 })
        .onChange((value: string) => {
          this.userName = value
        })

      TextInput({ placeholder: 'password', text: this.password })
        .placeholderColor(Color.Gray)
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .margin({ top: 10 })
        .onChange((value: string) => {
          this.password = value
        })

      TextInput({ placeholder: '文件夹名称', text: this.foldName })
        .placeholderColor(Color.Gray)
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .margin({ top: 10 })
        .onChange((value: string) => {
          this.foldName = value
        })
      TextInput({ placeholder: '新文件夹名称', text: this.newFoldName })
        .placeholderColor(Color.Gray)
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .margin({ top: 10 })
        .onChange((value: string) => {
          this.newFoldName = value
        })
      TextInput({ placeholder: '文件名', text: this.fileName })
        .placeholderColor(Color.Gray)
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .margin({ top: 10 })
        .onChange((value: string) => {
          this.fileName = value
        })
      TextInput({ placeholder: '文件内容', text: this.content })
        .placeholderColor(Color.Gray)
        .caretColor(Color.Blue)
        .height(50)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontFamily("sans-serif")
        .fontStyle(FontStyle.Normal)
        .fontColor(Color.Black)
        .margin({ top: 10 })
        .onChange((value: string) => {
          this.content = value
        })




      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceAround }) {
        Button('exit', {
          type: ButtonType.Capsule,
          stateEffect: true
        }).backgroundColor(0x317aff).width(90).onClick(() => {
          var smbClient=this.getClient();
          var check = this.foldName||this.fileName
          smbClient.exists(check, function (err, exit) {
            if (err) {
              console.log('smb erro:' + err.message)
              prompt.showToast({message:err.message,duration:5000})
              throw err;

            }
            prompt.showToast({message:"文件夹或文件是否存在:"+exit,duration:5000})
            console.log("smb exit:" + exit);
          })
        })

        Button('mkdir', {
          type: ButtonType.Capsule,
          stateEffect: true
        }).backgroundColor(0x317aff).width(90).onClick(() => {
          var smbClient=this.getClient();
           smbClient.mkdir(this.foldName, function (err) {
            if (err) {
              console.log('smb erro:' + err.message)
              prompt.showToast({message:err.message,duration:5000})
              throw err;

            }
             prompt.showToast({message:"make dir success",duration:5000})
          })

        })
        Button('readdir', {
          type: ButtonType.Capsule,
          stateEffect: true
        }).backgroundColor(0x317aff).width(90).onClick(() => {
          var smbClient=this.getClient();
          smbClient.readdir(this.foldName, function (err,fileNames) {
            if (err) {
              console.log('smb erro:' + err.message)
              prompt.showToast({message:err.message,duration:5000})
              throw err;

            }
            prompt.showToast({message:JSON.stringify(fileNames),duration:5000})
          })
        })
        Button('readFile', {
          type: ButtonType.Capsule,
          stateEffect: true
        }).backgroundColor(0x317aff).width(120).onClick(() => {
          var smbClient=this.getClient();
          smbClient.readFile(this.fileName , null, (err,result) => {
            if (err) {
              console.log('smb erro:' + err.message)
              prompt.showToast({message:err.message,duration:5000})
              throw err;

            }
            prompt.showToast({message:JSON.stringify(result),duration:5000})
          })

        })
      }.margin({ top: 10 }).height(80)
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceAround }) {
        Button('rename', {
          type: ButtonType.Capsule,
          stateEffect: true
        }).backgroundColor(0x317aff).width(90).onClick(() => {
          var smbClient=this.getClient();
          smbClient.rename(this.foldName,this.newFoldName, function (err) {
            if (err) {
              console.log('smb erro:' + err.message)
              prompt.showToast({message:err.message,duration:5000})
              throw err;

            }
            prompt.showToast({message:"rename success",duration:5000})
          })
        })

        Button('writeFile', {
          type: ButtonType.Capsule,
          stateEffect: true
        }).backgroundColor(0x317aff).width(120).onClick(() => {
          var smbClient=this.getClient();
          smbClient.writeFile(this.fileName,this.content,'UTF-8', function (err) {
            if (err) {
              console.log('smb erro:' + err.message)
              prompt.showToast({message:err.message,duration:5000})
              throw err;

            }
            prompt.showToast({message:"writeFile success",duration:5000})
          })

        })
        Button('rmdir', {
          type: ButtonType.Capsule,
          stateEffect: true
        }).backgroundColor(0x317aff).width(90).onClick(() => {
          var smbClient=this.getClient();
           smbClient.rmdir(this.foldName,(err,files)=> {
            if (err) {
              console.log('smb erro:' + err.message)
              prompt.showToast({message:err.message,duration:5000})
              throw err;

            }
             prompt.showToast({message:"rmdir success",duration:5000})
          })
        })
        Button('rmfile', {
          type: ButtonType.Capsule,
          stateEffect: true
        }).backgroundColor(0x317aff).width(90).onClick(() => {
          var smbClient=this.getClient();
         // test\\st.txt
          smbClient.unlink(this.fileName,(err,result) =>{
            if (err) {
              console.log('smb erro:' + err.message)
              prompt.showToast({message:err.message,duration:5000})
              throw err;

            }
            prompt.showToast({message:"rmfile success",duration:5000})
          })

        })

        Button('分享', {
          type: ButtonType.Capsule,
          stateEffect: true
        }).backgroundColor(0x317aff).width(90).onClick(() => {
          var context: Context = getContext(this) as Context
          let that = this; //可以的有 xlsx,png,zip,txt,
          var fileName = "epub-book.epub"
          context.resourceManager.getRawFileContent(fileName).then(value => {
            var smbClient = this.getClient();
            console.info("----" + fileName + "---size---" + value.length)

            smbClient.sendFile(fileName, value, (callResult) => {
              console.log("-------sendfile--err------" + callResult.err)
              if (callResult.err) {
                console.log('smb sendWrite erro:' + callResult.err.message)
                throw callResult.err.message;
              }
              console.log('smb sendWrite progress :' + callResult.progress + "%" + "---send file size " + (callResult.sendFileSize / 1024) + "KB")
            });


          }).catch(error => {
            console.log("getRawFile promise error is " + error);
          });


        })


      }.margin({ top: 10 }).height(80)
    }
    .height('100%')
  }

  public getClient(){
   if(!this.serverIP){
     prompt.showToast({message:'请输入服务器ip',duration:2000})
     return
   }
    if(!this.clientIP){
      prompt.showToast({message:'请输入客户端ip',duration:2000})
      return
    }
    if(!this.basePath){
      prompt.showToast({message:'请输入share',duration:2000})
      return
    }
    if(!this.userName){
      prompt.showToast({message:'请输入用户名',duration:2000})
      return
    }
    if(!this.password){
      prompt.showToast({message:'请输入密码',duration:2000})
      return
    }
    return new SMB2(
      {
        share: '\\\\'+this.serverIP+'\\'+this.basePath,
        domain:'DOMAIN',
        username: this.userName,
        password: this.password,
        clientIP:this.clientIP
      }
    );
  }
}
