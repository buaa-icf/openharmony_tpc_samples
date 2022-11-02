/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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


// @ts-nocheck
import { JSONDeserializer, JSONSerializer, Universal } from '@complycloud/asn1';
import { DERSerializer, DERDeserializer } from '@complycloud/asn1-der';
import { btoa, atob } from 'Base64'
import { encode, decode } from 'hex-encode-decode'
import { AbilityHandle } from '../util/AbilityHandle'

const { Bool, Integer, Null, PrintableString, Sequence } = Universal;
const sequence = new Sequence([
  new Integer(-Number.MAX_SAFE_INTEGER),
  new Integer(Number.MAX_SAFE_INTEGER),
  new Integer('424242424242424242424242424242424242'), // big integer
  new Null(),
  new Bool(true),
  new PrintableString('nice marmot'),
  new PrintableString('@#$%!&*()!_=&'),
]);

@Entry
@Component
struct Index {
  @State message: string = 'asn1 组装原数据：' + JSON.stringify(sequence);
  @State strText: string= "";
  @State serializeJsonText: string = "";
  @State deserializeJsonText: string = "";
  @State deserializeJsonTextBase64: string= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz1234567890+/AA==!@#$%^&*()_-/][{}?:";
  @State deserializeJsonTextHex: string= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz1234567890+/AA==!@#$%^&*()_-/][{}?:";
  @State deserializeJsonTextDer: string = "";
  @State deserializeJsonTextDerS: string = "";
  @State deserializeJsonTextDerD: string = "";
  private json: any;
  private btnDerClicked: Boolean = null;
  private btnBase64Clicked: boolean = false;
  private btnHexClicked: boolean = false;
  private resultArrayBuffer;
  private scroller: Scroller = new Scroller();
  @State btn64Text: string = "base64 编码";
  @State btnHexText: string = "Hex 编码";
  @State btnDerText: string = "DER"

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(16)

        Button("asn1 序列化数据")
          .fontSize(16)
          .margin({ top: "20px" })
          .onClick((event) => {
            const serialize = new JSONSerializer();
            this.json = serialize(sequence);
            this.serializeJsonText = JSON.stringify(this.json);
          })

        Text(this.serializeJsonText)
          .margin({ top: "20px" })
          .fontSize(16)

        Button("asn1 反序列化数据")
          .fontSize(16)
          .margin({ top: "20px" })
          .onClick((event) => {
            const deserialize = new JSONDeserializer();
            const asn1ObjectModel = deserialize(this.json);
            this.deserializeJsonText = JSON.stringify(asn1ObjectModel);
          })

        Text(this.deserializeJsonText)
          .margin({ top: "20px" })
          .fontSize(16)

        Text(this.deserializeJsonTextBase64)
          .margin({ top: "20px" })
          .fontSize(16)


        Button(this.btn64Text)
          .fontSize(16)
          .margin({ top: "20px" })
          .onClick((event) => {
            if (!this.btnBase64Clicked) {
              this.deserializeJsonTextBase64 = btoa("ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz1234567890+/AA==!@#$%^&*()_-/][{}?:");
              this.btnBase64Clicked = true;
            } else {
              this.deserializeJsonTextBase64 = atob(this.deserializeJsonTextBase64);
              this.btnBase64Clicked = false;
            }
            this.btn64Text = this.btnBase64Clicked ? "base64 解码" : "base64 编码";
          })

        Text(this.deserializeJsonTextHex)
          .margin({ top: "20px" })
          .fontSize(16)

        Button(this.btnHexText)
          .fontSize(16)
          .margin({ top: "20px" })
          .onClick((event) => {
            if (!this.btnHexClicked) {
              this.deserializeJsonTextHex = encode("ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz1234567890+/AA==!@#$%^&*()_-/][{}?:");
              this.btnHexClicked = true;
            } else {
              this.deserializeJsonTextHex = decode(this.deserializeJsonTextHex);
              this.btnHexClicked = false;
            }

            this.btnHexText = this.btnHexClicked ? "Hex 解码" : "Hex 编码";
          })

        Text(this.deserializeJsonTextDer)
          .margin({ top: "20px" })
          .fontSize(16)

        Text(this.deserializeJsonTextDerS)
          .margin({ top: "20px" })
          .fontSize(16)

        Text(this.deserializeJsonTextDerD)
          .margin({ top: "20px" })
          .fontSize(16)

        Button(this.btnDerText)
          .fontSize(16)
          .margin({ top: "20px" })
          .onClick((event) => {
            const serialize = new DERSerializer();
            const asn1Sequence = new Universal.Sequence([
              new Universal.Integer(123),
              new Universal.PrintableString('Hello World'),
            ]);

            this.deserializeJsonTextDer = "DER 原抽象数据:" + JSON.stringify(asn1Sequence);
            const bufferContainingDEREncodedASN1 = serialize(asn1Sequence);
            this.deserializeJsonTextDerS = "DER 序列化数据：" + JSON.stringify(bufferContainingDEREncodedASN1);

            const deserialize = new DERDeserializer();
            const des = deserialize(bufferContainingDEREncodedASN1);
            this.deserializeJsonTextDerD = "DER 反序列化数据:" + JSON.stringify(des);
          })

        Button("测试BER")
          .fontSize(16)
          .margin({ top: "20px" })
          .onClick((event) => {

            AbilityHandle.jump("BerTestAbility")
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear(){
    console.log("asnd1 aboutToAppear");
  }
}