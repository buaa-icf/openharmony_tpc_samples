/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the MIT License (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://opensource.org/licenses/MIT
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import JSZip, { JSZipObject } from '@ohos/jszip';
import { BuildButtonOptions, Files, ReturnValue } from '../types/type';
import promptAction from '@ohos.promptAction';
import { loadAsyncFromRawFile, writeCacheDirFile } from '../utils/FileSaver';
import { log } from '../utils/log';
import { CreateDirOrFile } from '../components/CreateDirOrFile';
import fs from '@ohos.file.fs';

@Entry
@Component
struct Index {
  @State instance: JSZip = new JSZip();
  @State directory: Array<JSZipObject> = [];
  @State currentInstance: JSZip | null = null;
  @State index: number = 0;
  @State create_type: "DIR" | "FILE" | "ZIP" = "DIR";
  @State currentFolder: string = "";
  @State password: string | null = null;
  @State isLoading: boolean = false;
  @State filePath: string = "";
  @State rawFileName: string = "";
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CreateDirOrFile({
      create_type: this.create_type,
      confirm: (data): void => this.onConfirm(data),
      cancel: (): void => this.onCancel()
    }),
    autoCancel: true,
  })

  @Builder
  BuildButton(text: string, callback?: () => void, options: BuildButtonOptions = {
    bgColor: Color.Blue,
    color: Color.White,
    borderOptions: {}
  }) {
    Button(text)
      .fontSize(14)
      .fontColor(options.color)
      .backgroundColor(options.bgColor)
      .border(options.borderOptions)
      .onClick(callback)
      .margin({ bottom: 8 })
  }

  @Builder
  BuildDirOrFile(item: JSZipObject) {
    if (this.isDir(item)) {

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Text(item.name)
          .fontSize(22)
          .padding(8)
          .width("100%")
          .border({ width: { bottom: 1 }, color: "#ff6700" })
          .onClick(() => {
            this.currentFolder = item.name;
          })
        Button("删除").onClick(() => {
          this.removeDirOrFile(item.name);
        })
      }
    } else {
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Text(item.name).fontSize(20).padding(4).width("100%").fontColor(Color.Grey)
        Button("删除").onClick(() => {
          this.removeDirOrFile(item.name);
        })
      }
    }
  }

  createDir() {
    this.create_type = "DIR";
    this.openDialog();
  }

  createFile() {
    this.create_type = "FILE";
    this.openDialog();
  }

  removeDirOrFile(path: string) {
    this.instance.remove(path);
    this.refresh();
    promptAction.showToast({ message: `删除成功` });

  }

  openDialog() {
    this.dialogController.open()
  }

  closeDialog() {
    this.dialogController?.close();
  }

  openLoading() {
    this.isLoading = true;
  }

  closeLoading() {
    this.isLoading = false;
  }

  unGzipFile() {
    try {
      this.closeLoading()
      this.closeDialog()
      let isAccess: boolean = fs.accessSync(this.filePath)
      if (!isAccess) {
        promptAction.showToast({
          message: `暂无权限处理文件 ${this.filePath}`
        })
        return
      }
      this.openLoading();
      let totalSize = fs.statSync(this.filePath).size;
      let fileId = fs.openSync(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
      let cacheData: Uint8Array = new Uint8Array(totalSize);
      let readLength = 0;
      let buff = new ArrayBuffer(8 * 1024)
      let readSize = 0;
      while (readLength < totalSize) {
        if (readLength + buff.byteLength < totalSize) {
          readSize = fs.readSync(fileId.fd, buff, {
            offset: readLength,
            length: buff.byteLength
          })
          cacheData.set(new Uint8Array(buff), readLength)
        } else {
          let trueLength = totalSize - readLength
          readSize = fs.readSync(fileId.fd, buff, {
            offset: readLength,
            length: trueLength
          })
          let trueBuff = buff.slice(0, trueLength)
          cacheData.set(new Uint8Array(trueBuff), readLength)
        }
        readLength += readSize;
      }
      JSZip.loadAsync(cacheData, {
        password: this.password
      }).then((data: JSZip) => {
        promptAction.showToast({
          message: `解压缩解密文件成功  ${JSON.stringify(data)}`
        })
        this.refresh();
        this.closeLoading();
        this.closeDialog();
      }).catch((err: Error) => {
        this.closeLoading();
        this.closeDialog();
        promptAction.showToast({
          message: `解压缩加密文件失败！ 错误原因： ${err.message}`
        })
      })
    } catch (err) {
      promptAction.showToast({
        message: `解压缩加密文件出错！ 错误原因： ${err.message}`
      })
      this.closeLoading();
      this.closeDialog();
    }
  }

  unGzipRawFile() {
    try {
      this.closeLoading();
      this.closeDialog();
      this.openLoading();
      loadAsyncFromRawFile(this.rawFileName).then((res: Uint8Array | void) => {
        if (!res) {
          promptAction.showToast({
            message: `没有找到此压缩文件！`
          })
          this.closeLoading()
          return
        }
        this.instance.loadAsync(res, {
          password: this.password
        }).then((data: JSZip) => {
          promptAction.showToast({
            message: `解压缩加密文件成功  ￥${JSON.stringify(data)}`
          })
          this.refresh();
          this.closeLoading();
          this.closeDialog();
        }).catch((err: Error) => {
          this.closeLoading();
          this.closeDialog();
          promptAction.showToast({
            message: `解压缩加密文件失败！ 错误原因： ${err.message}`
          })
        })
      })
    } catch (err) {
      promptAction.showToast({
        message: `解压缩加密文件出错！ 错误原因： ${err.message}`
      })
      this.closeLoading();
      this.closeDialog();
    }
  }

  onConfirm(data: ReturnValue) {
    const type = data.create_type;
    if (type === 'DIR') {
      if (!data.folderName) {
        promptAction.showToast({ message: `创建失败,请输入正确的文件夹名称!` });
        return
      }
      const folderName = this.currentFolder + data.folderName;
      folderName && this.instance.folder(folderName);
      promptAction.showToast({ message: `文件夹创建成功!` });
      this.refresh();
      this.dialogController?.close();
    } else if (type === "FILE") {
      if (!data.fileName || !data.contentText) {
        promptAction.showToast({ message: `创建失败,请输入正确的文件名称以及内容!` });
        return
      }
      const fileName = this.currentFolder + data.fileName;
      const content = data.contentText;
      fileName && content && this.instance.file(fileName, content);
      promptAction.showToast({ message: `文件创建成功!` });
      this.refresh();
      this.dialogController?.close();
    } else if (type === "ZIP") {
      const zipName = data.zipName;
      if (!zipName) {
        promptAction.showToast({ message: `文件名称不能为空` });
        return;
      }
      loadAsyncFromRawFile(zipName).then(res => {
        if (!res) {
          promptAction.showToast({ message: `没有找到此压缩文件!` });

          // this.closeLoading();
          return;
        }
        this.closeDialog();

        this.openLoading();

        this.instance.loadAsync(res).then(() => {
          this.refresh();
          promptAction.showToast({ message: "解压缩文件成功!" });
          this.closeLoading();


        }).catch((err: Error) => {
          promptAction.showToast({ message: "解压缩文件失败!  错误原因：" + err.message })
          log(err.message)
          this.closeLoading();
          this.closeDialog();


        });
      });
    }


  }

  onCancel() {
    this.dialogController?.close();
  }

  forEachZIP() {
    this.instance.forEach((_, file) => {
      log(file)
    })
  }

  filterZIP() {
    const zips = this.instance.filter((_, file) => (file.dir === false));
    log(zips);
  }

  generateZIP() {
    let ctx = this;
    this.openLoading();
    this.instance.generateAsync({ type: "arraybuffer", password: this.password, encryptStrength: 3 }).then(res => {
      ctx.filePath = writeCacheDirFile(`prod-${Date.now()}.zip`, res);
      this.closeLoading();
    })
      .catch((err: object) => {
        this.closeLoading();
        promptAction.showToast({ message: `生成压缩文件失败!` });

        log(`生成压缩文件失败 ${err}`)
      })
  }

  loadAsyncFile() {
    this.create_type = "ZIP";
    this.openDialog();
  }

  refresh() {
    this.directory = this.format(this.instance.files);
  }

  isDir(item: JSZipObject): boolean {
    return item.dir;
  }

  format(files: Files): Array<JSZipObject> {
    return Object.keys(files).map(v => (files[v]))
  }

  /**
   * 调试日志
   */
  debugger = () => {
    log(this.instance.files);
    log(this.directory)
  }

  build() {
    Scroll() {
      Column() {

        Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap }) {
          Row({ space: 8 }) {
            this.BuildButton("+新建文件夹", (): void => this.createDir())
            this.BuildButton("+新建文件", (): void => this.createFile(), {
              bgColor: Color.White,
              color: Color.Black,
              borderOptions: { width: 2, color: Color.Black }
            })
          }.margin({ bottom: 8 })

          this.BuildButton("加载压缩文件", (): void => this.loadAsyncFile(), { bgColor: Color.Green })
          this.BuildButton("生成压缩文件", (): void => this.generateZIP(), { bgColor: Color.Orange })
          // this.BuildButton("查看文件信息",this.debugger,{bgColor:Color.Gray});
          this.BuildButton("遍历(目录及文件)", (): void => this.forEachZIP())
          this.BuildButton("过滤(过滤文件)", (): void => this.filterZIP())
        }

        Row() {
          Text("设置密码：")
          TextInput({ placeholder: '请输入密码...', text: this.password || "" })
            .height(40)
            .width('50%')
            .onChange((value: string) => {
              this.password = value
            })
            .margin({ bottom: 12 })
        }

        Row() {
          Button("解压缩本Demo中加密之后的压缩文件")
            .height(40)
            .width('50%')
            .onClick(() => {
              if (!this.filePath || this.filePath.length < 1) {
                promptAction.showToast({
                  message: `暂无可用文件，请先加密压缩文件`
                })
                return;
              }
              if (!this.password || this.password.length < 1) {
                promptAction.showToast({
                  message: `请先输入解压缩密码`
                })
                return;
              }
              this.unGzipFile()
            })

        }.border({
          width: 2,
          color: Color.Red,
          radius: 10,
          style: BorderStyle.Solid
        }).margin({ bottom: 12 }).padding(10)

        Column() {
          Text("填写应用沙箱内的加密文件路径：")
          TextInput({
            placeholder: '填写应用沙箱内的加密文件路径...',
            text: this.filePath || "data/storage/el2/base/haps/entry/cache/test.zip"
          })
            .height(40)
            .width('70%')
            .onChange((value: string) => {
              this.filePath = value
            })
            .margin({ bottom: 12 })
          Button("解压缩应用沙箱内的加密压缩文件")
            .height(40)
            .width('50%')
            .onClick(() => {
              if (!this.filePath || this.filePath.length < 1) {
                promptAction.showToast({
                  message: `暂无可用文件，请先在应用沙箱内放入加密压缩文件`
                })
                return;
              }
              if (!this.password || this.password.length < 1) {
                promptAction.showToast({
                  message: `请先输入解压缩密码`
                })
                return;
              }
              this.unGzipFile()
            })
        }.border({
          width: 2,
          color: Color.Red,
          radius: 10,
          style: BorderStyle.Solid
        }).margin({ bottom: 12 }).padding(10)

        Column() {
          Text("填写rawfile的加密压缩文件名")
          TextInput({
            placeholder: '请填写rawfile的加密压缩文件名...',
            text: this.rawFileName || "test.zip"
          })
            .height(40)
            .width('70%')
            .onChange((value: string) => {
              this.filePath = value
            })
            .margin({ bottom: 12 })
          Button("解压缩rawfile内的加密压缩文件")
            .height(40)
            .width('50%')
            .onClick(() => {
              if (!this.rawFileName || this.rawFileName.length < 1) {
                promptAction.showToast({
                  message: `暂无可用文件，请先在项目rawfile文件夹内放入加密压缩文件`
                })
                return;
              }
              if (!this.password || this.password.length < 1) {
                promptAction.showToast({
                  message: `请先输入解压缩密码`
                })
                return;
              }
              this.unGzipRawFile()
            })
        }.border({
          width: 2,
          color: Color.Red,
          radius: 10,
          style: BorderStyle.Solid
        }).margin({ bottom: 12 }).padding(10)
        Row() {
          Text(`当前选中文件夹：${this.currentFolder || '根目录'}`)
            .fontSize(20)
            .fontColor(Color.Red)
            .textAlign(TextAlign.Start)
            .margin({ right: 10 });
          this.BuildButton("选择根目录", () => this.currentFolder = "");
        }.justifyContent(FlexAlign.Start).padding({ left: 8, right: 8, top: 24, bottom: 24 }).width("100%")

        List() {
          ForEach(this.directory, (item: JSZipObject) => {
            ListItem() {
              this.BuildDirOrFile(item);
            }
          })

        }.width("100%").layoutWeight(1)

        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          LoadingProgress()
            .color(Color.White)
            .width(100)
            .height(100)
        }
        .position({ x: 0, y: 0 })
        .opacity(0.3)
        .backgroundColor(Color.Black)
        .width("100%")
        .height("100%")
        .visibility(this.isLoading ? Visibility.Visible : Visibility.None)

      }
      .width('100%')
      .height("100%")
      .justifyContent(FlexAlign.Start)
      .padding({ left: 4, right: 4, top: 4 })
    }
    .width("100%")
    .height("100%")

  }
}