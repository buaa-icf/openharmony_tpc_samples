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

import { Metadata, ImageMetadataReader, XmpDirectory } from '@ohos/metadata-extractor';
import { XMPMetaFactory, XMPMeta, IteratorOptions, XMPPropertyInfo } from 'xmptool';
import fileIo from '@ohos.file.fs';

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

@Entry
@Component
struct XmpSample {
  @State isVisibility: Visibility = Visibility.Hidden
  @State xmpData: Array<string> = []
  @State xmpProperties: Array<string> = []
  @State errorMessage: string = ''
  @State testMode: string = ''
  @State testResults: Array<string> = []

  private async getXmpMetaData() {
    this.xmpData.splice(0, this.xmpData.length)
    this.xmpProperties.splice(0, this.xmpProperties.length)
    this.errorMessage = ''
    this.testMode = 'image'

    // Load sample image from raw resources
    const imageData = getContext().resourceManager.getRawFileContentSync('xmp_test_image.jpg')
    const targetDir = getContext().filesDir + '/xmpDemo/'
    if (!fileIo.accessSync(targetDir)) {
      fileIo.mkdirSync(targetDir)
    }
    const filePath = targetDir + 'xmp_test_image.jpg'
    const fd = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
    fileIo.writeSync(fd.fd, imageData!.buffer)
    fileIo.closeSync(fd)

    try {
      // Read metadata from image
      let metadata: Metadata = ImageMetadataReader.readMetadata(filePath);

      // Find XmpDirectory
      let xmpDirectory: XmpDirectory | null = null;
      for (let directory of metadata.getDirectories()) {
        if (directory instanceof XmpDirectory) {
          xmpDirectory = directory;
          break;
        }
      }

      if (xmpDirectory != null) {
        // Get all tags from XmpDirectory
        let directoryName: string = xmpDirectory.getName();
        xmpDirectory.getTags().forEach((tag: ESObject) => {
          let tagName: string = tag.getTagName();
          let description: string = tag.getDescription();
          this.xmpData.push('[' + directoryName + ']' + tagName + '=' + description);
        });

        // Get XMP properties
        let properties: Map<string, string> = xmpDirectory.getXmpProperties();
        properties.forEach((value: string, key: string) => {
          this.xmpProperties.push(key + '=' + value);
        });

        if (this.xmpData.length === 0 && this.xmpProperties.length === 0) {
          this.xmpData.push('No XMP metadata found in this image');
        }
      } else {
        this.xmpData.push('No XMP directory found in this image');
        this.xmpData.push('');
        this.xmpData.push('Tip: Try \'Test XMP String\' button to verify XMP parsing works!');
      }
    } catch (err) {
      console.error('XMP metadata extraction error: ' + JSON.stringify(err));
      this.errorMessage = 'Error: ' + JSON.stringify(err);
    }
  }

  private testXmpStringParsing() {
    this.xmpData.splice(0, this.xmpData.length)
    this.xmpProperties.splice(0, this.xmpProperties.length)
    this.errorMessage = ''
    this.testMode = 'string'

    try {
      // Parse XMP from string using xmptool
      let xmpMeta: XMPMeta = XMPMetaFactory.parseFromString(SAMPLE_XMP_STRING);

      this.xmpData.push('✓ XMP String parsed successfully!');
      this.xmpData.push('');
      this.xmpData.push('Object Name:' + xmpMeta.getObjectName());
      this.xmpData.push('');

      // Iterate through all properties (omit qualifiers like xml:lang)
      let options: IteratorOptions = new IteratorOptions()
        .setJustLeafnodes(true)
        .setOmitQualifiers(true);
      let iterator = xmpMeta.iterator(options);

      this.xmpData.push('--- XMP Properties ---');
      while (iterator.hasNext()) {
        let prop: XMPPropertyInfo = iterator.next();
        let path: string = prop.getPath();
        let value: string = prop.getValue();
        if (path != null && value != null && path.length > 0) {
          this.xmpProperties.push(path + '=' + value);
        }
      }

      if (this.xmpProperties.length === 0) {
        this.xmpProperties.push('(No leaf properties found)');
      }

    } catch (err) {
      console.error('XMP string parsing error: ' + JSON.stringify(err));
      this.errorMessage = 'Error parsing XMP string: ' + JSON.stringify(err);
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Column() {
        // Title
        Text('XMP Metadata Reader')
          .fontSize(25)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .padding(15)
          .width('100%')
          .textAlign(TextAlign.Center)

        // Mode indicator
        if (this.testMode.length > 0) {
          Text(this.testMode === 'image' ? 'Mode: Image Extraction' :
            this.testMode === 'string' ? 'Mode: String Parsing Test' : 'Mode: Run Tests')
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding({ bottom: 10 })
        }

        // XMP Tags Section
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
                return index!.toString()
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

        // XMP Properties Section
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
                return index!.toString()
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

        // Error message
        if (this.errorMessage.length > 0) {
          Text(this.errorMessage)
            .fontSize(13)
            .fontColor(Color.Red)
            .width('100%')
            .padding(10)
        }

        // Test Results Section (only show when in test mode)
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
                ForEach(this.testResults, (item: string) => {
                  Text(item)
                    .fontSize(13)
                    .width('100%')
                    .padding(3)
                    .textAlign(TextAlign.Start)
                }, (item: string, index?: number) => {
                  return index!.toString()
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

        // Buttons
        Column() {
          Row() {
            Button('Extract Image', { type: ButtonType.Normal, stateEffect: true })
              .borderRadius(8)
              .width('45%')
              .height(40)
              .backgroundColor('#1a73e8')
              .fontSize(13)
              .onClick(() => {
                this.testResults.splice(0, this.testResults.length)
                this.getXmpMetaData()
                this.isVisibility = Visibility.Visible
              })

            Button('Parse String', { type: ButtonType.Normal, stateEffect: true })
              .borderRadius(8)
              .width('45%')
              .height(40)
              .backgroundColor('#34a853')
              .fontSize(13)
              .onClick(() => {
                this.testResults.splice(0, this.testResults.length)
                this.testXmpStringParsing()
                this.isVisibility = Visibility.Visible
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
