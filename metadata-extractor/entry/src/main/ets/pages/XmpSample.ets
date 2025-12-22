/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { Metadata, ImageMetadataReader, XmpDirectory, Directory } from '@ohos/metadata-extractor';
import { XMPMetaFactory, XMPMeta, IteratorOptions, XMPPropertyInfo } from '@ohos/xmptool';
import fileIo from '@ohos.file.fs';
import taskpool from '@ohos.taskpool';

// Sample XMP string for testing
const SAMPLE_XMP_STRING: string = `<?xpacket begin="" id="W5M0MpCehiHzreSzNTczkc9d"?>
<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="XMP Core 5.1.0">
  <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <rdf:Description rdf:about=""
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:xmp="http://ns.adobe.com/xap/1.0/"
        xmlns:photoshop="http://ns.adobe.com/photoshop/1.0/">
      <dc:title>
        <rdf:Alt>
          <rdf:li xml:lang="x-default">Sample Image Title</rdf:li>
        </rdf:Alt>
      </dc:title>
      <dc:creator>
        <rdf:Seq>
          <rdf:li>John Doe</rdf:li>
        </rdf:Seq>
      </dc:creator>
      <dc:description>
        <rdf:Alt>
          <rdf:li xml:lang="x-default">This is a sample XMP description for testing.</rdf:li>
        </rdf:Alt>
      </dc:description>
      <xmp:CreatorTool>OpenHarmony XMP Test</xmp:CreatorTool>
      <xmp:CreateDate>2024-01-15T10:30:00+08:00</xmp:CreateDate>
      <photoshop:City>Beijing</photoshop:City>
      <photoshop:Country>China</photoshop:Country>
    </rdf:Description>
  </rdf:RDF>
</x:xmpmeta>
<?xpacket end="w"?>`;

interface MetadataResult {
  xmpData: string[];
  xmpProperties: string[];
}

interface ErrorResult {
  error: string;
}

type TaskResult = MetadataResult | ErrorResult;

// 处理图像元数据提取
@Concurrent
function extractImageMetadata(filePath: string): TaskResult {
  try {
    const metadata: Metadata = ImageMetadataReader.readMetadata(filePath);
    const xmpData: string[] = [];
    const xmpProperties: string[] = [];

    let xmpDirectory: XmpDirectory | null = null;
    const directories: Set<Directory> = metadata.getDirectories();

    for (const directory of directories) {
      if (directory instanceof XmpDirectory) {
        xmpDirectory = directory;
        break;
      }
    }

    if (xmpDirectory !== null) {
      const directoryName: string = xmpDirectory.getName();

      // 获取标签信息
      try {
        const tags = xmpDirectory.getTags();

        if (tags && tags.size > 0) {
          for (const tag of tags) {
            try {
              const tagName = tag.getTagName ? tag.getTagName() : '';
              const description = tag.getDescription ? tag.getDescription() : '';
              if (tagName && description) {
                xmpData.push('[' + directoryName + ']' + tagName + '=' + description);
              }
            } catch (e) {
              console.warn('Unprocessable tag ' + tag.toString());
              continue;
            }
          }
        }
      } catch (e) {
        const error = e as Error;
        console.error('Error getting tags: ' + error.message);
      }

      // 获取XMP属性
      try {
        const properties: Map<string, string> = xmpDirectory.getXmpProperties();
        properties.forEach((value: string, key: string) => {
          xmpProperties.push(key + '=' + value);
        });
      } catch (e) {
        const error = e as Error;
        console.error('Error getting properties: ' + error.message);
      }

      if (xmpData.length === 0 && xmpProperties.length === 0) {
        xmpData.push('No XMP metadata found in this image');
      }
    } else {
      xmpData.push('No XMP directory found in this image');
      console.error('No XMP directory found in this image');
    }
    return { xmpData, xmpProperties };
  } catch (err) {
    const errorObj = err as Error;
    console.error('XMP process error: ' + errorObj.message);
    return { error: errorObj.message || JSON.stringify(err) };
  }
}

// 处理XMP字符串解析
@Concurrent
function parseXmpString(xmpString: string): TaskResult {
  try {
    const xmpMeta: XMPMeta = XMPMetaFactory.parseFromString(xmpString);
    const xmpData: string[] = [];
    const xmpProperties: string[] = [];

    xmpData.push('✓ XMP String parsed successfully!');
    xmpData.push('');
    xmpData.push('Object Name:' + xmpMeta.getObjectName());
    xmpData.push('');

    const options: IteratorOptions = new IteratorOptions()
      .setJustLeafnodes(true)
      .setOmitQualifiers(true);
    const iterator = xmpMeta.iterator(options);

    xmpData.push('--- XMP Properties ---');
    while (iterator.hasNext()) {
      const prop: XMPPropertyInfo = iterator.next();
      const path: string = prop.getPath();
      const value: string = prop.getValue();
      if (path && value && path.length > 0) {
        xmpProperties.push(path + '=' + value);
      }
    }

    if (xmpProperties.length === 0) {
      xmpProperties.push('(No leaf properties found)');
    }

    return { xmpData, xmpProperties };
  } catch (err) {
    const errorObj = err as Error;
    return { error: errorObj.message || JSON.stringify(err) };
  }
}

@Entry
@Component
struct XmpSample {
  @State isVisibility: Visibility = Visibility.Hidden
  @State xmpData: Array<string> = []
  @State xmpProperties: Array<string> = []
  @State errorMessage: string = ''
  @State testMode: string = ''
  @State testResults: Array<string> = []
  @State isLoading: boolean = false

  private async getXmpMetaData(): Promise<void> {
    this.clearData();
    this.testMode = 'image';
    this.isLoading = true;

    try {
      const imageData = getContext().resourceManager.getRawFileContentSync('xmp_test_image.jpg');
      const targetDir = getContext().filesDir + '/xmpDemo/';

      if (!fileIo.accessSync(targetDir)) {
        fileIo.mkdirSync(targetDir);
      }

      const filePath = targetDir + 'xmp_test_image.jpg';
      const fd = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);
      fileIo.writeSync(fd.fd, imageData!.buffer);
      fileIo.closeSync(fd);

      await this.readMetadataInBackground(filePath);

    } catch (err) {
      console.error('Error in getXmpMetaData: ' + JSON.stringify(err));
      this.errorMessage = 'Error: ' + JSON.stringify(err);
      this.isLoading = false;
    }
  }

  private async readMetadataInBackground(filePath: string): Promise<void> {
    try {
      const task = new taskpool.Task(extractImageMetadata, filePath);
      const result: TaskResult = await taskpool.execute(task) as TaskResult;

      // 检查是否为错误结果
      const errorResult = result as ErrorResult;
      if (errorResult.error !== undefined) {
        this.errorMessage = 'Error: ' + errorResult.error;
      } else {
        const metadataResult = result as MetadataResult;
        this.xmpData = metadataResult.xmpData;
        this.xmpProperties = metadataResult.xmpProperties;
        this.isVisibility = Visibility.Visible;
      }
    } catch (err) {
      console.error('Task execution error: ' + JSON.stringify(err));
      this.errorMessage = 'Task execution error: ' + JSON.stringify(err);
    } finally {
      this.isLoading = false;
    }
  }

  private async testXmpStringParsing(): Promise<void> {
    this.clearData();
    this.testMode = 'string';
    this.isLoading = true;

    try {
      const task = new taskpool.Task(parseXmpString, SAMPLE_XMP_STRING);
      const result: TaskResult = await taskpool.execute(task) as TaskResult;

      // 检查是否为错误结果
      const errorResult = result as ErrorResult;
      if (errorResult.error !== undefined) {
        this.errorMessage = 'Error parsing XMP string: ' + errorResult.error;
      } else {
        const metadataResult = result as MetadataResult;
        this.xmpData = metadataResult.xmpData;
        this.xmpProperties = metadataResult.xmpProperties;
        this.isVisibility = Visibility.Visible;
      }
    } catch (err) {
      console.error('XMP string parsing error: ' + JSON.stringify(err));
      this.errorMessage = 'Error parsing XMP string: ' + JSON.stringify(err);
    } finally {
      this.isLoading = false;
    }
  }

  private clearData(): void {
    this.xmpData = [];
    this.xmpProperties = [];
    this.errorMessage = '';
    this.testResults = [];
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Column() {
        Text('XMP Metadata Reader')
          .fontSize(25)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .padding(15)
          .width('100%')
          .textAlign(TextAlign.Center)

        if (this.testMode.length > 0) {
          Text(this.testMode === 'image' ? 'Mode: Image Extraction' :
            this.testMode === 'string' ? 'Mode: String Parsing Test' : 'Mode: Run Tests')
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding({ bottom: 10 })
        }

        if (this.isLoading) {
          LoadingProgress()
            .color('#1a73e8')
            .height(50)
            .width(50)
            .margin({ top: 20, bottom: 20 })

          Text('Processing...')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ bottom: 20 })
        }

        Column() {
          Text('XMP Results:')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Start)
            .fontColor('#1a73e8')

          Scroll() {
            Column() {
              ForEach(this.xmpData, (item: string, index?: number) => {
                Text(item)
                  .fontSize(13)
                  .width('100%')
                  .padding(3)
                  .textAlign(TextAlign.Start)
              }, (item: string, index?: number) => {
                return index ? index.toString() : '0';
              })
            }
          }
          .height('20%')
          .width('100%')
          .scrollBar(BarState.Auto)
          .visibility(this.isVisibility)
          .backgroundColor('#f5f5f5')
          .borderRadius(8)
          .padding(8)
        }
        .padding(10)

        Column() {
          Text('XMP Properties:')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Start)
            .fontColor('#1a73e8')

          Scroll() {
            Column() {
              ForEach(this.xmpProperties, (item: string, index?: number) => {
                Text(item)
                  .fontSize(12)
                  .width('100%')
                  .padding(3)
                  .textAlign(TextAlign.Start)
                  .fontColor('#444444')
              }, (item: string, index?: number) => {
                return index ? index.toString() : '0';
              })
            }
          }
          .height('25%')
          .width('100%')
          .scrollBar(BarState.Auto)
          .visibility(this.isVisibility)
          .backgroundColor('#f5f5f5')
          .borderRadius(8)
          .padding(8)
        }
        .padding(10)

        if (this.errorMessage.length > 0) {
          Text(this.errorMessage)
            .fontSize(13)
            .fontColor(Color.Red)
            .width('100%')
            .padding(10)
        }

        if (this.testMode === 'test' && this.testResults.length > 0) {
          Column() {
            Text('Test Results:')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .textAlign(TextAlign.Start)
              .fontColor('#ff5722')

            Scroll() {
              Column() {
                ForEach(this.testResults, (item: string, index?: number) => {
                  Text(item)
                    .fontSize(13)
                    .width('100%')
                    .padding(3)
                    .textAlign(TextAlign.Start)
                }, (item: string, index?: number) => {
                  return index ? index.toString() : '0';
                })
              }
            }
            .height('30%')
            .width('100%')
            .scrollBar(BarState.Auto)
            .backgroundColor('#fff3e0')
            .borderRadius(8)
            .padding(8)
          }
          .padding(10)
        }

        Column() {
          Row() {
            Button('Extract Image', { type: ButtonType.Normal, stateEffect: true })
              .borderRadius(8)
              .width('45%')
              .height(40)
              .backgroundColor(this.isLoading ? '#cccccc' : '#1a73e8')
              .fontSize(13)
              .enabled(!this.isLoading)
              .onClick(() => {
                this.getXmpMetaData()
              })

            Button('Parse String', { type: ButtonType.Normal, stateEffect: true })
              .borderRadius(8)
              .width('45%')
              .height(40)
              .backgroundColor(this.isLoading ? '#cccccc' : '#34a853')
              .fontSize(13)
              .enabled(!this.isLoading)
              .onClick(() => {
                this.testXmpStringParsing()
              })
          }
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: 10 })

        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

      }
      .height('100%')
      .width('100%')
    }
    .padding(12)
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
  }
}