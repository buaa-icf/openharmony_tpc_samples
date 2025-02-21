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
/**
 * 定义消息类型
 */
export enum MessageType {
  SYSTEM = 0,  // 系统消息
  OTHER = 1,   // 其他用户消息
  SELF = 2     // 自己的消息
}

/**
 * 基础消息接口
 */
export interface Message {
  id: MessageType;     // 消息类型
  username?: string;   // 发送者用户名
  message: string;     // 消息内容
  numUsers?: number;   // 用户数量(仅系统消息)
}

class ChatDetailData extends BasicDataSource <Message> {
  private msgList: Array<Message> = [];

  public totalCount(): number {
    return this.msgList.length;
  }

  public getData(index: number): Message {
    return this.msgList[index];
  }

  public addData(index: number, data: Message): void {
    this.msgList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Message): void {
    this.msgList.push(data);
    this.notifyDataAdd(this.msgList.length - 1);
  }
}
export const chatDetailData = new ChatDetailData()