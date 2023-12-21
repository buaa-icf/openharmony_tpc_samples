/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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

export class VideoCacheConstant {
  public static PING_EVENT_ID: number = 1; // 发出事件---ping代理服务器成功传递响应结果
  public static COUNT_TOTAL_SIZE_ID: number = 2; // 发出事件---子线程解析出文件夹里面的所有文件之后发给LruDiskUsage
  public static COUNT_TOTAL_SIZE_START_ID: number = 3; // 发出事件---文件夹数据发送完毕之前，发出信号调用先清空之前缓存到列表的文件名
  public static COUNT_TOTAL_SIZE_END_ID: number = 4; // 发出事件---文件夹数据发送完毕之后，发出信号调用LruDiskUsage的方法countTotalSize
  public static SEND_TOTAL_SIZE_ID: number = 5; // 发出事件---用于接受主线程处理好的TotalSize
  public static GET_ACCEPT_ID: number = 6; // 发出事件---向主线程询问该缓存文件是否需要删除
  public static SEND_ACCEPT_ID: number = 7; // 发出事件---向子线程返回缓存文件是否需要删除的结论
  public static SHUT_DOWN_TASKPOOL: number = 8; // 发出事件---关闭子线程
  public static START_READ_ID: number = 9; // 发出事件---已经成功向缓存文件写入数据了 可以开始读取缓存文件的数据了
  public static PING_RESPONSE: string = "ping ok" // 本地构造的用于本地代理服务器返回给播放器发起的ping请求的响应结果
  public static PING_REQUEST: string = "ping" // 发出事件---用于构造播放器发起的ping请求

  constructor() {
  }
}