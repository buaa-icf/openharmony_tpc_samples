/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */
import { BasicDataSource } from '../common/BasicDataSource';

class MultiChatDetailData extends BasicDataSource<ESObject> {
  private msgList: Array<ESObject> = [];

  public totalCount(): number {
    return this.msgList.length;
  }

  public getData(index: number): ESObject {
    return this.msgList[index];
  }

  public addData(index: number, data: ESObject): void {
    this.msgList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: ESObject): void {
    this.msgList.push(data);
    this.notifyDataAdd(this.msgList.length - 1);
  }

  public clearData(): void {
    this.msgList = [];
    this.notifyDataReload();
  }

  public getMessageList(): Array<ESObject> {
    return this.msgList;
  }
}

// 为客户端A和B分别创建聊天数据管理实例
export const multiChatDetailDataA = new MultiChatDetailData()
export const multiChatDetailDataB = new MultiChatDetailData()