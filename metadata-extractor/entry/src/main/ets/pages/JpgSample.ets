/*
Copyright (c) 2022 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import { Metadata, XmpDirectory } from '@ohos/metadata-extractor';
import { ImageMetadataReader } from '@ohos/metadata-extractor'
import fileIo from '@ohos.file.fs';
import taskpool from '@ohos.taskpool';

let fileDir: string;

@Concurrent
async function processImageMetadata(filePath: string): Promise<string[]> {
  const results: string[] = [];
  try {
    let metadata: Metadata = ImageMetadataReader.readMetadata(filePath);
    let tagCount: number = 0;

    metadata.getDirectories().forEach((value: ESObject) => {
      let directoryName: string = value.getName();
      value.getTags().forEach((tag: ESObject) => {
        let tagName: string = tag.getTagName();
        let description: string = tag.getDescription();
        tagCount += 1;
        results.push('[' + directoryName + '] ' + tagName + ' = ' + description);
      });
      if (value instanceof XmpDirectory) {
        let xmpDir: XmpDirectory = value as XmpDirectory;
        let xmpProperties = xmpDir.getXmpProperties();
        if (xmpProperties && xmpProperties.size > 0) {
          xmpProperties.forEach((propValue: string, path: string) => {
            if (!path.includes('/@') && !path.endsWith('/@xml:lang')) {
              results.push('XMP' + path + '=' + propValue);
            }
          });
        }
      }
    });

    console.info('The Worker thread has completed processing and found a total of tags:', tagCount);
    return results;
  } catch (err) {
    console.error('The Worker thread handled an error:', err);
    return ['Handle errors: ' + (err?.message || err?.toString())];
  }
}


@Entry
@Component
struct JpgSample {
  @State isVisibility: Visibility = Visibility.Hidden
  @State data: string[] = []
  @State isProcessing: boolean = false
  @State errorMessage: string = ''

  private async getMetaData(): Promise<void> {
    if (this.isProcessing) {
      return;
    }
    this.isProcessing = true;
    this.errorMessage = '';
    let progressMessage: string = 'In the preparation documents, please wait...';
    this.data.splice(0, this.data.length)

    try {
      const imageData = getContext().resourceManager.getRawFileContentSync('rotate_rotate90.jpg');
      const targetDir = getContext().filesDir + 'webResources/';

      if (!fileIo.accessSync(targetDir)) {
        fileIo.mkdirSync(targetDir);
      }

      const filePath = targetDir + 'rotate_rotate90.jpg';
      const fd = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);
      fileIo.writeSync(fd.fd, imageData!.buffer);
      fileIo.closeSync(fd);
      progressMessage = 'Metadata is being parsed...';
      this.data.push('Metadata is being parsed...');
      const task = new taskpool.Task(processImageMetadata, filePath);
      const result = await taskpool.execute(task) as string[];

      this.data = result;
      progressMessage = `Processing completed, found together ${this.data.length} strip metadata`;

    } catch (err) {
      console.error('Main thread error:', err);
      this.errorMessage = 'Failed processing: ' + (err?.message || err?.toString());
      progressMessage = '';
    } finally {
      this.isProcessing = false;
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Column() {

        Text($r('app.string.Extract_jpg_metadata'))
          .fontSize(25)
          .fontColor(Color.Gray)
          .padding(20)
          .height('10%')
          .textAlign(TextAlign.Center)

        Text($r('app.string.Resource_path8')).fontSize(22).width('100%')
          .textAlign(TextAlign.Start)

        Scroll() {
          Column() {
            Text($r('app.string.Metadata')).fontSize(20).width('100%')
              .textAlign(TextAlign.Start)
            Text("" + JSON.stringify(this.data)).fontSize(20).width('100%')
              .textAlign(TextAlign.Start)
              .visibility(this.isVisibility)
          }
        }.height('80%').padding({ bottom: 10 })

        Button($r('app.string.Display_metadata5'), { type: ButtonType.Normal, stateEffect: true })
          .borderRadius(8).width('70%').height('8%')
          .onClick(() => {
            this.getMetaData()
            this.isVisibility = Visibility.Visible
          })

      }.height('100%')
    }.padding(16)
    .width('100%')
    .height('100%')
  }
}
