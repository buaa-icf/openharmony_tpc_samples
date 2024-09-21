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
import { Confirm, Cancel, ReturnValue } from "../types/type"

@CustomDialog
export struct CreateDirOrFile {
  create_type: "DIR" | "FILE" | "ZIP"  = "DIR";
  controller?: CustomDialogController;
  folderName: string = "";
  fileName: string = "";
  contentText: string = "";
  zipName:string = "";
  textController: TextInputController = new TextInputController()
  confirm: Confirm = () => {
  }
  cancel: Cancel = () => {
  }


  isShowDir(){
    return this.create_type === "DIR"
  }

  isShowFile(){
    return this.create_type === "FILE"
  }

  isShowZip(){
    return this.create_type === "ZIP"
  }


  build() {
      Column() {
        Text(this.create_type === "DIR" ? $r('app.string.Create_Folder') : this.create_type === "FILE"?$r('app.string.Create_File'):$r('app.string.Load_zip_file')).fontSize(20).margin({ top: 10, bottom: 10 })
        TextInput({ placeholder: $r('app.string.Input_Foldername') +'...', text: this.folderName,controller:this.textController })
          .height(80)
          .width('90%')
          .onChange((value: string) => {
            this.folderName = value
          })
          .margin({ bottom: 12 })
          .visibility(this.isShowDir()?Visibility.Visible:Visibility.None)


        TextInput({ placeholder: $r('app.string.Input_file_name') + '...', text: this.fileName })
          .height(80)
          .width('90%')
          .onChange((value: string) => {
            this.fileName = value
          })
          .margin({ bottom: 12 })
          .visibility(this.isShowFile()?Visibility.Visible:Visibility.None)



        TextInput({ placeholder: $r('app.string.Input_file_content') + '...' , text: this.contentText })
          .height(80)
          .width('90%')
          .onChange((value: string) => {
            this.contentText = value
          })
          .margin({ bottom: 12 })
          .visibility(this.isShowFile()?Visibility.Visible:Visibility.None)

        TextInput({ placeholder:$r('app.string.Input_zipname')+'...', text: this.zipName })
          .height(80)
          .width('90%')
          .onChange((value: string) => {
            this.zipName = value
          })
          .margin({ bottom: 12 })
          .visibility(this.isShowZip()?Visibility.Visible:Visibility.None)


        Column() {
          Button($r('app.string.sure')).onClick(() => {
            const result = new ReturnValue();
            result.create_type = this.create_type;
            result.folderName = this.folderName;
            result.fileName = this.fileName;
            result.contentText = this.contentText;
            result.zipName = this.zipName;
            this.confirm(result);
          }).width("100%").margin({bottom:8}).height(50)
          Button($r('app.string.cancel')).onClick(this.cancel).width("100%").height(50)
        }.margin(20)
      }


  }
}