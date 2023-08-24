/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import ProtobufFormat from '@ohos/protobuf_format'
import hilog from '@ohos.hilog'
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct InputInfoPage {
  protoController: TextAreaController = new TextAreaController();
  pathController: TextAreaController = new TextAreaController();
  dataController: TextAreaController = new TextAreaController();
  @State protoInfo: string = '';
  @State protoPath: string = '';
  @State protoData: string = '';
  @State messageToJsonResult: string = "messageToJsonResult: ";
  @State jsonToMessageResult: string = "jsonToMessageResult: ";
  @State messageToXmlResult: string = "messageToXmlResult: ";
  @State xmlToMessageResult: string = "xmlToMessageResult: ";
  @State messageToHtmlResult: string = "messageToHtmlResult: ";
  private TAG: string = "protobuf-format"
  private defaultUserProto: string = 'syntax = "proto3"; package com.user;message UserLoginResponse{' +
  'string sessionId = 1;' +
  'uint32 userPrivilege = 2;' +
  'bool isTokenType = 3;' +
  'uint64 formatTimestamp = 4;' +
  'int32 field5 = 5;' +
  'int64 field6 = 6;' +
  'double field7 = 7;' +
  'float field8 = 8;' +
  '}';
  private defaultUserPath: string = "com.user.UserLoginResponse";
  private defaultUserData: Object = {
    sessionId: "testProtobufFormat",
    userPrivilege: 123456,
    isTokenType: false,
    formatTimestamp: 123456,
    field5: -500,
    field6: -600,
    field7: 703.1215926,
    field8: 803.1415926
  }

  build() {
    Row() {
      Column() {
        Scroll() {
          Column({ space: 10 }) {
            Text('messageToJsonResult: ')
              .fontColor(Color.Red)
            Text(this.messageToJsonResult)
              .width('100%')
            Text('jsonToMessageResult: ')
              .fontColor(Color.Red)
            Text(this.jsonToMessageResult)
              .width('100%')
            Text('messageToXmlResult: ')
              .fontColor(Color.Red)
            Text(this.messageToXmlResult)
              .width('100%')
            Text('xmlToMessageResult: ')
              .fontColor(Color.Red)
            Text(this.xmlToMessageResult)
              .width('100%')
            Text('messageToHtmlResult: ')
              .fontColor(Color.Red)
            Text(this.messageToHtmlResult)
              .width('100%')
          }.alignItems(HorizontalAlign.Start)
        }
        .align(Alignment.TopStart)
        .width('100%')
        .height('50%')

        Divider()
          .width('100%')
          .height('10px')
          .backgroundColor(Color.Red)

        Scroll() {
          Column() {
            Button('填充默认proto info')
              .onClick(() => {
                this.protoInfo = this.defaultUserProto;
              }).alignSelf(ItemAlign.Start)

            TextArea({
              text: this.protoInfo,
              placeholder: "please input your proto info...",
              controller: this.protoController
            })
              .onChange((value) => {
                this.protoInfo = value;
              })

            Button('填充默认proto path')
              .onClick(() => {
                this.protoPath = this.defaultUserPath;
              }).alignSelf(ItemAlign.Start)

            TextArea({
              text: this.protoPath,
              placeholder: "please input your proto path...",
              controller: this.pathController
            })
              .onChange((value) => {
                this.protoPath = value;
              })

            Button('填充默认proto data')
              .onClick(() => {
                this.protoData = JSON.stringify(this.defaultUserData);
              }).alignSelf(ItemAlign.Start)

            TextArea({
              text: this.protoData,
              placeholder: "please input your proto data...",
              controller: this.dataController
            })
              .onChange((value) => {
                this.protoData = value;
              })

            Button('protobuf format')
              .onClick(async () => {
                if (!this.protoInfo) {
                  promptAction.showToast({ message: "please input proto info" });
                  return;
                }
                if (!this.protoPath) {
                  promptAction.showToast({ message: "please input proto path" });
                  return;
                }
                if (!this.protoData) {
                  promptAction.showToast({ message: "please input proto data" });
                  return;
                }
                try {
                  let builder = await ProtobufFormat.Protobuf.loadProto(this.protoInfo, null, 'protoInfo.proto')
                  if (!builder) {
                    hilog.error(0x0000, this.TAG, '%{public}s', 'codec error: builder is null|undefined.');
                    return;
                  }
                  let Message = builder.build(this.protoPath);
                  let message = new Message(JSON.parse(this.protoData));
                  this.protobufFormat(builder, message, this.protoPath)
                } catch (error) {
                  hilog.error(0x0000, this.TAG, '%{public}s', 'protobufFormat catch error: ' + error);
                  this.messageToJsonResult = 'messageToJsonResult: ';
                  this.jsonToMessageResult = 'jsonToMessageResult: ';
                  this.messageToXmlResult = 'messageToXmlResult: ';
                  this.xmlToMessageResult = 'xmlToMessageResult: ';
                  this.messageToHtmlResult = 'messageToHtmlResult: ';
                }
              })
          }
          .alignItems(HorizontalAlign.Start)
        }
        .align(Alignment.TopStart)
        .width('100%')
        .height('48%')
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .height('100%')
    .alignItems(VerticalAlign.Top)
  }

  // @ts-ignore
  private protobufFormat(builder: ProtobufFormat.Protobuf.Builder, message: ProtoBufFormat.Protobuf.Builder.Message, path: string): void {
    let messageJson = ProtobufFormat.Format.messageToJson(message);
    hilog.info(0x0000, this.TAG, '%{public}s', 'messageJson: ' + messageJson);
    let jsonMessage = ProtobufFormat.Format.jsonToMessage(builder, path, messageJson);
    hilog.info(0x0000, this.TAG, '%{public}s', 'jsonMessage: ' + jsonMessage);
    let messageXml = ProtobufFormat.Format.messageToXml(message);
    hilog.info(0x0000, this.TAG, '%{public}s', 'messageXml: ' + messageXml);
    let xmlMessage = ProtobufFormat.Format.xmlToMessage(builder, path, messageXml);
    hilog.info(0x0000, this.TAG, '%{public}s', 'xmlMessage: ' + xmlMessage);
    let messageHtml = ProtobufFormat.Format.messageToHtml(message);
    hilog.info(0x0000, this.TAG, '%{public}s', 'messageHtml: ' + messageHtml);

    this.messageToJsonResult = messageJson;
    this.jsonToMessageResult = JSON.stringify(messageJson);
    this.messageToXmlResult = messageXml
    this.xmlToMessageResult = JSON.stringify(messageXml);
    this.messageToHtmlResult = messageHtml
  }
}