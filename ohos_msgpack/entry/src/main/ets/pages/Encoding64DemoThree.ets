/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission to use, copy, modify, and/or distribute this software for any purpose
 * with or without fee is hereby granted, provided that the above copyright notice
 * and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS' AND THE AUTHOR DISCLAIMS ALL
 * WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL
 * THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING
 * FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
 * CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
import { encode, decode, ExtensionCodec } from '@ohos/msgpack';

@Entry
@Component
struct Encoding64DemoThree {
  @State message: string = '编码后的数据展示';
  @State encodedMessage: string = '解码后的数据展示';
  @State decodeMessage: string = '解码后的数据展示';
  encodedUint8?: Uint8Array = undefined;

  build() {
    Row() {
      Column() {
        Button('点击对象编码').onClick(() => {
          const extensionCodec = new ExtensionCodec<undefined>();
          extensionCodec.register({
            type: 0,
            encode: (input: Object) => {
              if (typeof input === 'bigint') {
                if (input <= Number.MAX_SAFE_INTEGER && input >= Number.MIN_SAFE_INTEGER) {
                  return encode<undefined>(Number.parseInt(input.toString(), 10));
                } else {
                  return encode<undefined>(input.toString());
                }
              } else {
                return null;
              }
            },
            decode: (data: Uint8Array) => {
              const value = decode<undefined>(data) as string;
              if (!(typeof value === 'string' || typeof value === 'number')) {
              }
              return BigInt(value);
            },
          });

          this.encodedUint8 = encode<undefined>(data(), { useBigInt64: true,
            extensionCodec
          });
          this.message = '编码后的数据=' + this.encodedUint8;
        })
        Text(this.message)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
        Button('点击解码').onClick(() => {
          if (this.encodedUint8) {
            this.encodedMessage = '解码后的数据=' + JSON.stringify(decode<string[]>(this.encodedUint8));
          } else {
            this.decodeMessage = '解码数据为undefined, 请先点击编码';
          }
        })
        Text(this.encodedMessage)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}

function data() {
  return BigInt(0);
}