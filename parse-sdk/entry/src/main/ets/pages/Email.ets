/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */

import { Parse } from '@ohos/parser-sdk';
import { JSON } from '@kit.ArkTS';

@Entry
@Component
struct Email {
  @State message: string = '';
  @State emailVerified: boolean | null = null; // 状态
  @State isSending: boolean = false; // 防止重复点击

  // 重新发送验证邮件
  async resendVerificationEmail() {
    if (this.isSending) return;

    this.isSending = true;
    this.message = '正在发送验证邮件...';

    try {
      const user = Parse.User.current();
      if (!user) {
        this.message = '错误：用户未登录';
        return;
      }

      // 通过修改字段触发重发
      user.set('resendVerify', Date.now());
      await user.save();

      this.message = '验证邮件已发送至您的邮箱';
    } catch (e) {
      this.message = `发送失败: ${e.message || JSON.stringify(e)}`;
    } finally {
      this.isSending = false;
    }
  }

  // 检查验证状态
  async checkEmailVerification() {
    try {
      const user = Parse.User.current();
      if (!user) {
        this.message = '错误：用户未登录';
        return;
      }

      this.message = '正在获取验证状态...';
      await user.fetch(); // 从服务器获取最新数据

      this.emailVerified = user.get('emailVerified');
      this.message = this.emailVerified ? '邮箱已验证' : '邮箱未验证（请检查收件箱）';
    } catch (e) {
      this.message = `检查失败: ${e.message || JSON.stringify(e)}`;
    }
  }

  build() {
    Scroll() {
    Column({ space: 12 }) {
      // 状态显示
      if (this.emailVerified !== null) {
        Text(`验证状态：${this.emailVerified ? '邮箱已验证' : '邮箱未验证'}`)
          .fontSize(18)
      }

      Button(this.isSending ? '发送中...' : '重新发送验证邮件')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .enabled(!this.isSending)
        .onClick(() => this.resendVerificationEmail())

      Button('检查验证状态')
        .borderRadius(4)
        .type(ButtonType.Normal)
        .width('100%')
        .onClick(() => this.checkEmailVerification())

    }
    .margin(10)
    }
    .width('100%')
    .height('100%')
  }
}