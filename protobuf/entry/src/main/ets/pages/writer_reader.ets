/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import ByteBuffer from 'bytebuffer'

@Entry
@Component
struct Writer_reader {
  @State logStr: string = "";

   aboutToAppear() {
    console.log("1");
    var byteBufferInt64 = new ByteBuffer()
      .writeInt64(188888888,1)
      .flip();

    var byteBufferUint64 = new ByteBuffer()
      .writeUint64(366,2)
      .flip();

    var byteBufferDouble = new ByteBuffer()
      .writeDouble(1.344,6)
      .flip();

    var byteBufferStr = new ByteBuffer()
      .writeIString("hello world")
      .flip();


    console.log("2");
    let Int64 = byteBufferInt64.readInt64(1);
    let Uint64 = byteBufferUint64.readUint64(2);
    let Double = byteBufferDouble.readDouble(6);
    let IString = byteBufferStr.readIString();

    let logStr = " Int64:"+Int64+" Uint64:"+Uint64+" Double:"+Double+" IString:"+IString;

    this.logStr = logStr;

    console.log(logStr);

  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text("writeBuffer："+"188888888--"+"--366"+"--1.344"+"--hello world")
        .fontSize(30)
        .fontWeight(FontWeight.Bold);
      Text("readBuffer：" + this.logStr)
        .fontSize(30)
        .fontWeight(FontWeight.Bold);
    }
    .width('100%')
    .height('100%')
  }
}