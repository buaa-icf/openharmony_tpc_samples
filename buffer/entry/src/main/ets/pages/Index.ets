/**
 *  MIT License
 *
 *  Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import {Buffer} from 'buffer/'

@Entry
@Component
struct Index {
  @State message: string = '';
  @State copyString: string = '';
  @State asciiString: string = '';
  @State utf8String: string = '';
  @State ucs2String: string = '';
  @State base64String: string = '';
  @State latin1String: string = '';
  @State hexString: string = '';

  getResourceString(res:Resource){
    return getContext().resourceManager.getStringSync(res.id)
  }

  build() {
    Row() {
      Column() {
        Button($r('app.string.Create_buffer')).onClick(()=> {
          // 从一个数组创建一个长度为5的buffer
          let buffer1 = Buffer.from([1,2,3,4,5]);
          console.log('从一个数组创建一个长度为5的buffer',JSON.stringify(buffer1));
          // 从位置1写入内容：15
          buffer1.writeInt8(15, 1);
          this.message = JSON.stringify(buffer1)
          console.log('向buffer1的buffer中写入数字15，类型为int8，(int8 只占用两位)，从第1个位置写入', buffer1)
        }).margin(15);
        Text(this.getResourceString($r('app.string.Result')) + '：' + this.message).fontSize(15).margin(15);

        Text(this.getResourceString($r('app.string.Character_and_JavaScript_Conversion')) + '：').fontSize(15);
        Button($r('app.string.Character_and_JavaScript_Conversion')).onClick(()=> {
          let buf = Buffer.from('openHarmony Buffer', 'ascii');
          this.asciiString = buf.toString('ascii');
          // openHarmony Buffer
          console.log('转ascii：', this.asciiString)

          this.hexString = buf.toString('hex');
          // 输出 6f70656e4861726d6f6e7920427566666572
          console.log('转hex：', this.hexString);

          this.base64String = buf.toString('base64');
          // 输出 b3Blbkhhcm1vbnkgQnVmZmVy
          console.log('转base64: ', this.base64String);

          this.utf8String = buf.toString('utf8');
          // 输出 openHarmony Buffer
          console.log('转utf8: ', this.utf8String);

          this.ucs2String = buf.toString('ucs2');
          // 输出 灯湥慈浲湯⁹畂晦牥
          console.log('转ucs2: ', this.ucs2String);

          this.latin1String = buf.toString('latin1');
          // 输出 openHarmony Buffer
          console.log('转latin1: ', this.latin1String);
        }).margin(10)
        Text('ascii：'+ this.asciiString);
        Text('hex：' + this.hexString);
        Text('base64：'+ this.base64String);
        Text('utf8：'+ this.utf8String);
        Text('ucs2：'+ this.ucs2String);
        Text('latin1：'+ this.latin1String);

        Button('将buffer1插入到另一个buffer指定位置上').onClick(()=> {
          let buf1 = Buffer.from('hi buffer');
          let buf2 = Buffer.from('openHarmony');
          //将 buf2 插入到 buf1 指定位置上
          buf2.copy(buf1, 2);
          this.copyString = buf1.toString();
          console.log('将 buf2 插入到 buf1 指定位置上后的结果：',this.copyString);
        }).margin(15);
        Text('buffer1：'+ Buffer.from('hi  buffer'))
        Text('buffer2：'+ Buffer.from('openHarmony'))
        Text(this.getResourceString($r('app.string.Result')) + '：'+ this.copyString)
      }
      .width('100%')
    }
    .height('100%')
  }
}