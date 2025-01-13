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

export enum ConnState {
  NOTCONNECTED = 0,   // 未连接
  DISCONNECTED = 1,   // 断开连接
  CONNECTING = 2,     // 正在连接
  CONNECTED = 3,      // 已连接
}