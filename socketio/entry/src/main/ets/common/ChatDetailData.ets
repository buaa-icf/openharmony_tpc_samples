/**
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

import { BasicDataSource } from '../common/BasicDataSource';
// 最大聊天消息数（防止内存溢出）
const MAX_CHAT_MESSAGES = 50;

class ChatDetailData extends BasicDataSource {
  private msgList: Array<ESObject> = [];

  public totalCount(): number {
    return this.msgList.length;
  }

  public getData(index: number): number {
    return this.msgList[index];
  }

  public addData(index: number, data: ESObject): void {
    this.msgList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: ESObject): void {
    this.msgList.push(data);
    this.notifyDataAdd(this.msgList.length - 1);
    // 控制最大数量，防止内存溢出
    if (this.msgList.length > MAX_CHAT_MESSAGES) {
      this.msgList.splice(0, this.msgList.length - MAX_CHAT_MESSAGES);
    }
  }

  public delData(): void {
    this.msgList=[];
  }
}

export const chatDetailData = new ChatDetailData()