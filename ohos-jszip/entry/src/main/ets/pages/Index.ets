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
  @State uiContext: UIContext = this.getUIContext();
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
        Button($r('app.string.Delete')).onClick(() => {
          this.removeDirOrFile(item.name);
        })
      }
    } else {
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Text(item.name).fontSize(20).padding(4).width("100%").fontColor(Color.Grey)
        Button($r('app.string.Delete')).onClick(() => {
          this.removeDirOrFile(item.name);
        })
      }
    }
  }

  getStringByNameSync(resPath: string): string{
    try {
      return this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync(resPath) || "";
    }catch (e) {
      console.info("getStringByNameSync error, message: " + JSON.stringify(e));
      return "";
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
    try{
      this.instance.remove(path);
      this.refresh();
      this.uiContext.getPromptAction().showToast({ message: this.getStringByNameSync('Delete_success')  });
    }catch(e){
      console.error(`removeDirOrFile error, message:` + JSON.stringify(e));
    }
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
        this.uiContext.getPromptAction().showToast({
          message: this.getStringByNameSync('No_Permission')  + `${this.filePath}`
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
        this.uiContext.getPromptAction().showToast({
          message: this.getStringByNameSync('Extract_suce')  + `${JSON.stringify(data)}`
        })
        this.refresh();
        this.closeLoading();
        this.closeDialog();
      }).catch((err: Error) => {
        this.closeLoading();
        this.closeDialog();
        try {
          this.uiContext.getPromptAction().showToast({
            message: this.getStringByNameSync('Extract_fail') + `${err.message}`
          })
        }catch(e){
          console.error(`unGzipFile showToast error, message:` + JSON.stringify(e));
        }
      })
    } catch (err) {
      try {
        this.uiContext.getPromptAction().showToast({
          message: this.getStringByNameSync('Extract_fail') + `${err.message}`
        })
      }catch(e){
        console.error(`unGzipFile showToast error, message:` + JSON.stringify(e));
      }
      this.closeLoading();
      this.closeDialog();
    }
  }

  unGzipRawFile() {
    try {
      this.closeLoading();
      this.closeDialog();
      this.openLoading();
      loadAsyncFromRawFile(this.rawFileName, this.uiContext).then((res: Uint8Array | void) => {
        if (!res) {
          this.uiContext.getPromptAction().showToast({
            message:  this.getStringByNameSync('No_Find')
          })
          this.closeLoading()
          return
        }
        this.instance.loadAsync(res, {
          password: this.password
        }).then((data: JSZip) => {
          this.uiContext.getPromptAction().showToast({
            message: this.getStringByNameSync('Extract_suce')  + `${JSON.stringify(data)}`
          })
          this.refresh();
          this.closeLoading();
          this.closeDialog();
        }).catch((err: Error) => {
          this.closeLoading();
          this.closeDialog();
          try {
            this.uiContext.getPromptAction().showToast({
              message: this.getStringByNameSync('Extract_fail') + `${err.message}`
            })
          }catch(e){
            console.error(`unGzipRawFile showToast error, message:` + JSON.stringify(e));
          }
        })
      })
    } catch (err) {
      try {
        this.uiContext.getPromptAction().showToast({
          message: this.getStringByNameSync('Extract_fail') + `${err.message}`
        })
      }catch(e){
        console.error(`unGzipRawFile showToast error, message:` + JSON.stringify(e));
      }
      this.closeLoading();
      this.closeDialog();
    }
  }

  onConfirm(data: ReturnValue) {
    try {
      const type = data.create_type;
      if (type === 'DIR') {
        if (!data.folderName) {
          this.uiContext.getPromptAction().showToast({ message: this.getStringByNameSync('Create_fail') });
          return
        }
        const folderName = this.currentFolder + data.folderName;
        folderName && this.instance.folder(folderName);
        this.uiContext.getPromptAction().showToast({ message: this.getStringByNameSync('Create_suce') });
        this.refresh();
        this.dialogController?.close();
      } else if (type === "FILE") {
        if (!data.fileName || !data.contentText) {
          this.uiContext.getPromptAction().showToast({ message: this.getStringByNameSync('Create_fail') });
          return
        }
        const fileName = this.currentFolder + data.fileName;
        const content = data.contentText;
        fileName && content && this.instance.file(fileName, content);
        this.uiContext.getPromptAction().showToast({ message: this.getStringByNameSync('Create_suce') });
        this.refresh();
        this.dialogController?.close();
      } else if (type === "ZIP") {
        const zipName = data.zipName;
        if (!zipName) {
          this.uiContext.getPromptAction().showToast({ message: this.getStringByNameSync('No_Null') });
          return;
        }
        loadAsyncFromRawFile(zipName, this.uiContext).then(res => {
          if (!res) {
            this.uiContext.getPromptAction().showToast({ message: this.getStringByNameSync('No_Find') });

            // this.closeLoading();
            return;
          }
          this.closeDialog();

          this.openLoading();

          this.instance.loadAsync(res).then(() => {
            this.refresh();
            this.uiContext.getPromptAction().showToast({ message: this.getStringByNameSync('Extract_suce') });
            this.closeLoading();


          }).catch((err: Error) => {
            this.uiContext.getPromptAction()
              .showToast({ message: this.getStringByNameSync('Create_fail') + err.message })
            log(err.message)
            this.closeLoading();
            this.closeDialog();


          });
        });
      }
    }catch(e){
      console.error(`onConfirm showToast error, message:` + JSON.stringify(e));
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
      ctx.filePath = writeCacheDirFile(`prod-${Date.now()}.zip`, res, this.uiContext);
      this.closeLoading();
    })
      .catch((err: object) => {
        this.closeLoading();
        this.uiContext.getPromptAction().showToast({ message: this.getStringByNameSync('Create_zip_fail')  });

        log(this.getStringByNameSync('Create_zip_fail')  +  `${err}`)
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
            this.BuildButton(this.getStringByNameSync('New_Folder') , (): void => this.createDir())
            this.BuildButton(this.getStringByNameSync('New_File') , (): void => this.createFile(), {
              bgColor: Color.White,
              color: Color.Black,
              borderOptions: { width: 2, color: Color.Black }
            })
          }.margin({ bottom: 8 })

          this.BuildButton(this.getStringByNameSync('Load_zip') , (): void => this.loadAsyncFile(), { bgColor: Color.Green })
          this.BuildButton(this.getStringByNameSync('Create_zip') , (): void => this.generateZIP(), { bgColor: Color.Orange })
          // this.BuildButton("查看文件信息",this.debugger,{bgColor:Color.Gray});
          this.BuildButton(this.getStringByNameSync('Ergodic_all') , (): void => this.forEachZIP())
          this.BuildButton(this.getStringByNameSync('Filter_file') , (): void => this.filterZIP())
        }

        Row() {
          Text($r('app.string.Set_Password'))
          TextInput({ placeholder: this.getStringByNameSync('Input_Password') , text: this.password || "" })
            .height(40)
            .width('50%')
            .onChange((value: string) => {
              this.password = value
            })
            .margin({ bottom: 12 })
        }

        Row() {
          Button($r('app.string.Extract_Demo'))
            .height(40)
            .width('50%')
            .onClick(() => {
              if (!this.filePath || this.filePath.length < 1) {
                this.uiContext.getPromptAction().showToast({
                  message: this.getStringByNameSync('No_file_used')
                })
                return;
              }
              if (!this.password || this.password.length < 1) {
                this.uiContext.getPromptAction().showToast({
                  message:  this.getStringByNameSync('Input_zip_Password')
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
          Text(this.getStringByNameSync('Input_Path') )
          TextInput({
            placeholder: this.getStringByNameSync('Input_Path')  + '...',
            text: this.filePath || "data/storage/el2/base/haps/entry/cache/test.zip"
          })
            .height(40)
            .width('70%')
            .onChange((value: string) => {
              this.filePath = value
            })
            .margin({ bottom: 12 })
          Button($r('app.string.Extract_zip'))
            .height(40)
            .width('50%')
            .onClick(() => {
              if (!this.filePath || this.filePath.length < 1) {
                this.uiContext.getPromptAction().showToast({
                  message: this.getStringByNameSync('No_zip_use')
                })
                return;
              }
              if (!this.password || this.password.length < 1) {
                this.uiContext.getPromptAction().showToast({
                  message: this.getStringByNameSync('Input_zip_Password')
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
          Text(this.getStringByNameSync('Input_Filename') )
          TextInput({
            placeholder: this.getStringByNameSync('Input_Filename')  + '...',
            text: this.rawFileName || "test.zip"
          })
            .height(40)
            .width('70%')
            .onChange((value: string) => {
              this.filePath = value
            })
            .margin({ bottom: 12 })
          Button($r('app.string.Extract_raw'))
            .height(40)
            .width('50%')
            .onClick(() => {
              if (!this.rawFileName || this.rawFileName.length < 1) {
                this.uiContext.getPromptAction().showToast({
                  message: this.getStringByNameSync('No_raw_use')
                })
                return;
              }
              if (!this.password || this.password.length < 1) {
                this.uiContext.getPromptAction().showToast({
                  message: this.getStringByNameSync('Input_zip_Password')
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
          Text(this.getStringByNameSync('Choose_Folder')  + `${this.currentFolder || this.getStringByNameSync('Root_path') }`)
            .fontSize(20)
            .fontColor(Color.Red)
            .width("60%")
            .textAlign(TextAlign.Start)
            .margin({ right: 2 });

          this.BuildButton(this.getStringByNameSync('Choose_Root_Path') , () => this.currentFolder = "");
        }.justifyContent(FlexAlign.Start).padding({ left: 8, right: 8, top: 8, bottom: 24 }).width("100%")

        List() {
          ForEach(this.directory, (item: JSZipObject) => {
            ListItem() {
              this.BuildDirOrFile(item);
            }
          })

        }.height("100%").width("100%").layoutWeight(1)

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