/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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
import {
  ISO9797Alg3Mac,
  ParametersWithIV,
  ISO7816d4Padding,
  KeyParameter,
} from '@ohos/bc';
import promptAction from '@ohos.promptAction';

export const TAG: string = 'ISO9797Alg3Mac';

@Entry
@Component
struct Index {
  @State message: string = 'ISO9797 MAC Demo';

  // 示例1数据（十六进制字符串）
  @State hex1Input: string = '84E400800F4F05474D504B49';
  @State hex1Key: string = '319CD05D11BB06729BE23DA19B80E6A3';
  @State hex1IV: string = 'A097994108D06F1B';
  @State hex1Result: string = '';
  @State hex1Expected: string = 'F0E6EF6139D23733';

  // 示例2数据（字节数组）
  @State bytes2Input: string = '[-124,-28,0,-128,15,79,5,71,77,80,75,73]';
  @State bytes2Key: string = '[49,-100,-48,93,17,-69,6,114,-101,-30,61,-95,-101,-128,-26,-93]';
  @State bytes2IV: string = '[-96,-105,-103,65,8,-48,111,27]';
  @State bytes2Result: string = '';
  @State bytes2Expected: string = '[-16,-26,-17,97,57,-46,55,51]';

  build() {
    Column() {
      // 标题区域
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10, bottom: 10 })
        .width('100%')
        .textAlign(TextAlign.Center)

      // Tabs 区域，使用 layoutWeight 自适应高度
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          this.hexExampleView()
        }.tabBar('十六进制示例')

        TabContent() {
          this.bytesExampleView()
        }.tabBar('字节数组示例')
      }
      .width('100%')
      .layoutWeight(1)
      .barMode(BarMode.Fixed)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.container_modal_background'))
  }

  @Builder
  hexExampleView() {
    Scroll() {
      Column({ space: 12 }) {
        Text('示例1：十六进制字符串格式')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10 })

        Text('所有数据均为十六进制字符串格式')
          .fontSize(13)
          .fontColor('#666')

        Column({ space: 8 }) {
          Text('输入数据 (IN):')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          TextInput({ text: this.hex1Input })
            .onChange((value: string) => {
              this.hex1Input = value;
            })
        }.alignItems(HorizontalAlign.Start).width('100%')

        Column({ space: 8 }) {
          Text('密钥 (KEY):')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          TextInput({ text: this.hex1Key })
            .onChange((value: string) => {
              this.hex1Key = value;
            })
        }.alignItems(HorizontalAlign.Start).width('100%')

        Column({ space: 8 }) {
          Text('初始化向量 (IV):')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          TextInput({ text: this.hex1IV })
            .onChange((value: string) => {
              this.hex1IV = value;
            })
        }.alignItems(HorizontalAlign.Start).width('100%')

        Button('计算 MAC')
          .width('100%')
          .height(45)
          .onClick(() => this.runHexExample())

        if (this.hex1Result) {
          Column({ space: 8 }) {
            Text('实际输出:')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            Text(this.hex1Result)
              .fontSize(14)
              .fontColor('#00C853')
              .padding(10)
              .backgroundColor('#E8F5E9')
              .borderRadius(8)
              .width('100%')
              .copyOption(CopyOptions.InApp)
          }.alignItems(HorizontalAlign.Start).width('100%')

        }

        Text('说明：')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 10 })
        Text('• 输入数据: 十六进制字符串\n• 密钥长度: 16字节或者24字节 \n• IV长度: 8字节 (16位十六进制)\n• 输出: 8字节 (16位十六进制)')
          .fontSize(12)
          .fontColor('#666')
          .lineHeight(20)
      }
      .width('90%')
      .padding({ left: 15, right: 15, top: 10, bottom: 10 })
    }
    .width('100%')
    .scrollBar(BarState.Auto)  // 显示滚动条
    .edgeEffect(EdgeEffect.Spring)  // 边缘弹簧效果
  }

  @Builder
  bytesExampleView() {
    Scroll() {
      Column({ space: 12 }) {
        Text('示例2：字节数组格式')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10 })

        Text('所有数据均为字节数组格式（-128到127）')
          .fontSize(13)
          .fontColor('#666')

        Column({ space: 8 }) {
          Text('输入数据 (IN):')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          TextInput({ text: this.bytes2Input })
            .onChange((value: string) => {
              this.bytes2Input = value;
            })
        }.alignItems(HorizontalAlign.Start).width('100%')

        Column({ space: 8 }) {
          Text('密钥 (KEY):')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          TextInput({ text: this.bytes2Key })
            .onChange((value: string) => {
              this.bytes2Key = value;
            })
        }.alignItems(HorizontalAlign.Start).width('100%')

        Column({ space: 8 }) {
          Text('初始化向量 (IV):')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          TextInput({ text: this.bytes2IV })
            .onChange((value: string) => {
              this.bytes2IV = value;
            })
        }.alignItems(HorizontalAlign.Start).width('100%')

        Button('计算 MAC')
          .width('100%')
          .height(45)
          .onClick(() => this.runBytesExample())

        if (this.bytes2Result) {
          Column({ space: 8 }) {
            Text('实际输出:')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            Text(this.bytes2Result)
              .fontSize(14)
              .fontColor('#00C853')
              .padding(10)
              .backgroundColor('#E8F5E9')
              .borderRadius(8)
              .width('100%')
              .copyOption(CopyOptions.InApp)
          }.alignItems(HorizontalAlign.Start).width('100%')

        }

        Text('说明：')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 10 })
        Text('• 输入数据: 十六进制字符串\n• 密钥长度: 16字节或者24字节 \n• IV长度: 8字节 (16位十六进制)\n• 输出: 8字节 (16位十六进制)')
          .fontSize(12)
          .fontColor('#666')
          .lineHeight(20)
      }
      .width('90%')
      .padding({ left: 15, right: 15, top: 10, bottom: 10 })
    }
    .width('100%')
    .scrollBar(BarState.Auto)  // 显示滚动条
    .edgeEffect(EdgeEffect.Spring)  // 边缘弹簧效果
  }

  private runHexExample(): void {
    try {
      const mac = new ISO9797Alg3Mac(new ISO7816d4Padding());

      const inputBytes = this.hexStringToBytes(this.hex1Input);
      const keyBytes = this.hexStringToBytes(this.hex1Key);

      // 密钥长度检查
      if (keyBytes.length !== 16 && keyBytes.length !== 24) {
        throw new Error("密钥长度必须是 16 字节（双长度）或 24 字节（三长度），当前: " + keyBytes.length + " 字节");
      }

      // 检查是否提供了IV
      let ivBytes: Uint8Array | null = null;
      // 根据是否提供了IV来构造参数
      let params: ParametersWithIV | KeyParameter;

      if (this.hex1IV && this.hex1IV.trim().length > 0) {
        ivBytes = this.hexStringToBytes(this.hex1IV);
        // IV长度检查
        if (ivBytes.length !== 8) {
          throw new Error("IV 长度必须是 8 字节，当前: " + ivBytes.length + " 字节");
        }
        params = {
          parameters: { key: keyBytes },
          iv: ivBytes
        } as ParametersWithIV;
      } else {
        params = {
          key: keyBytes
        } as KeyParameter;
      }

      mac.init(params);
      mac.update(inputBytes, 0, inputBytes.length);
      const output = new Uint8Array(8);
      mac.doFinal(output, 0);

      this.hex1Result = this.bytesToHex(output);
    } catch (e) {
      this.hex1Result = '错误: ' + (e as Error).message;
      promptAction.showToast({
        message: '计算失败: ' + (e as Error).message,
        duration: 3000
      })
    }
  }

  private runBytesExample(): void {
    try {
      const mac = new ISO9797Alg3Mac(new ISO7816d4Padding());

      const inputBytes = this.parseByteArray(this.bytes2Input);
      const keyBytes = this.parseByteArray(this.bytes2Key);

      // 密钥长度检查
      if (keyBytes.length !== 16 && keyBytes.length !== 24) {
        throw new Error("密钥长度必须是 16 字节（双长度）或 24 字节（三长度），当前: " + keyBytes.length + " 字节");
      }

      // 检查是否提供了IV
      let ivBytes: Uint8Array | null = null;
      // 根据是否提供了IV来构造参数
      let params: ParametersWithIV | KeyParameter;

      if (this.bytes2IV && this.bytes2IV.trim().length > 0) {
        ivBytes = this.parseByteArray(this.bytes2IV);
        // IV长度检查
        if (ivBytes.length !== 8) {
          throw new Error("IV 长度必须是 8 字节，当前: " + ivBytes.length + " 字节");
        }
        params = {
          parameters: { key: keyBytes },
          iv: ivBytes
        } as ParametersWithIV;
      } else {
        params = {
          key: keyBytes
        } as KeyParameter;
      }

      mac.init(params);
      mac.update(inputBytes, 0, inputBytes.length);
      const output = new Uint8Array(8);
      mac.doFinal(output, 0);

      this.bytes2Result = this.bytesToArrayString(output);

    } catch (e) {
      this.bytes2Result = '错误: ' + (e as Error).message;
      promptAction.showToast({
        message: '计算失败: ' + (e as Error).message,
        duration: 3000
      })
    }
  }

  private bytesToArrayString(bytes: Uint8Array): string {
    const signedBytes = Array.from(bytes).map(b => {
      return b > 127 ? b - 256 : b;
    })
    return '[' + signedBytes.join(',') + ']';
  }

  /**
   * 十六进制字符串转字节数组
   *
   * 示例:
   * "7CA1" -> [0x7C, 0xA1]
   *
   * @param hex 十六进制字符串（不区分大小写，可包含空格）
   * @returns 字节数组
   */
  private hexStringToBytes(hex: string): Uint8Array {
    // 检查输入是否包含中文或特殊字符
    this.validateInputString(hex, "十六进制字符串");

    // 检查是否包含无效字符
    this.validateInvalidCharacters(hex, /^[0-9A-Fa-f\s]*$/, "十六进制字符串");

    // 移除所有空格
    hex = hex.replace(/\s+/g, '');

    // 确保长度为偶数
    if (hex.length % 2 !== 0) {
      throw new Error("十六进制字符串长度必须是偶数");
    }

    const len = hex.length;
    const data = new Uint8Array(len / 2);

    for (let i = 0; i < len; i += 2) {
      // 每两个十六进制字符转换为一个字节
      const high = parseInt(hex.charAt(i), 16);
      const low = parseInt(hex.charAt(i + 1), 16);

      if (isNaN(high) || isNaN(low)) {
        throw new Error("无效的十六进制字符: " + hex.substring(i, i + 2));
      }

      data[i / 2] = (high << 4) | low;
    }

    return data;
  }

  /**
   * 验证输入字符串是否包含中文或为空
   *
   * @param str 待验证的字符串
   * @param type 字符串类型（用于错误消息）
   */
  private validateInputString(str: string, type: string): void {
    // 检查输入是否为空
    if (!str || str.trim().length === 0) {
      throw new Error(type + "不能为空");
    }

    // 检查是否包含中文字符
    const chineseCharPattern = /[\u4e00-\u9fa5]/;
    const chineseMatch = str.match(chineseCharPattern);
    if (chineseMatch) {
      throw new Error(type + "不能包含中文字符，发现中文字符: " + chineseMatch[0]);
    }
  }

  /**
   * 验证输入字符串是否包含无效字符
   *
   * @param str 待验证的字符串
   * @param validPattern 有效字符的正则表达式
   * @param type 字符串类型（用于错误消息）
   */
  private validateInvalidCharacters(str: string, validPattern: RegExp, type: string): void {
    // 找到第一个无效字符
    for (let i = 0; i < str.length; i++) {
      const char = str.charAt(i);
      if (!validPattern.test(char)) {
        throw new Error(type + "包含无效字符，发现无效字符: '" + char + "' (位置: " + i + ")");
      }
    }
  }

  /**
   * 解析字节数组字符串或十六进制字符串
   *
   * 示例:
   * "[1,2,3]" -> [1, 2, 3]
   * "[-128, 64, 0]" -> [128, 64, 0]
   * "7CA1" -> [0x7C, 0xA1]
   *
   * @param str 字节数组字符串或十六进制字符串
   * @returns 字节数组
   */
  private parseByteArray(str: string): Uint8Array {
    // 检查输入是否包含中文或特殊字符
    this.validateInputString(str, "字节数组");

    // 检查是否包含特殊字符
    this.validateInvalidCharacters(str, /^[\d,\[\]\s\-\.A-Fa-f]*$/, "字节数组");

    const cleaned = str.replace(/[\[\]\s]/g, '');
    if (cleaned.length === 0) {
      throw new Error("字节数组不能为空");
    }

    // 如果字符串包含十六进制字符（A-F, a-f），则按十六进制处理
    if (/[A-Fa-f]/.test(cleaned)) {
      return this.hexStringToBytes(cleaned);
    }

    const parts = cleaned.split(',');
    const numbers: number[] = [];

    for (let i = 0; i < parts.length; i++) {
      const part = parts[i].trim();
      if (part === '') {
        throw new Error("字节数组格式错误：存在空值");
      }

      const num = parseInt(part, 10);
      if (isNaN(num)) {
        throw new Error("无法解析字节值: " + part);
      }

      if (num < -128 || num > 255) {
        throw new Error("字节值超出范围: " + num + " (必须在 -128 到 255 之间)");
      }

      // 转换为无符号字节
      numbers.push(num < 0 ? num + 256 : num);
    }

    return new Uint8Array(numbers);
  }

  private bytesToHex(bytes: Uint8Array): string {
    if (!bytes) {
      return '';
    }

    return Array.from(bytes)
      .map(b => b.toString(16).padStart(2, '0'))
      .join('')
      .toUpperCase()
  }
}
