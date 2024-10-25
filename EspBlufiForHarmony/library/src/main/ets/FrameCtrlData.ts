/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { BlufiParameter } from './params/BlufiParameter';

export class FrameCtrlData {
  private static readonly FRAME_CTRL_POSITION_ENCRYPTED: number = 0;
  private static readonly FRAME_CTRL_POSITION_CHECKSUM: number = 1;
  private static readonly FRAME_CTRL_POSITION_DATA_DIRECTION: number = 2;
  private static readonly FRAME_CTRL_POSITION_REQUIRE_ACK: number = 3;
  private static readonly FRAME_CTRL_POSITION_FRAG: number = 4;

  private readonly mValue: number;

  constructor(frameCtrlValue: number) {
    this.mValue = frameCtrlValue;
  }

  /**
   * 根据是否加密、尾帧校验、传入方向、ack、分页返回帧控制
   * @param encrypted
   * @param checksum
   * @param direction
   * @param requireAck
   * @param frag
   * @return number
   **/
  public static getFrameCTRLValue(
    encrypted: boolean,
    checksum: boolean,
    direction: number,
    requireAck: boolean,
    frag: boolean
  ): number {
    let frame: number = 0;
    if (encrypted) {
      frame = frame | (1 << FrameCtrlData.FRAME_CTRL_POSITION_ENCRYPTED);
    }
    if (checksum) {
      frame = frame | (1 << FrameCtrlData.FRAME_CTRL_POSITION_CHECKSUM);
    }
    if (direction === BlufiParameter.DIRECTION_INPUT) {
      frame = frame | (1 << FrameCtrlData.FRAME_CTRL_POSITION_DATA_DIRECTION);
    }
    if (requireAck) {
      frame = frame | (1 << FrameCtrlData.FRAME_CTRL_POSITION_REQUIRE_ACK);
    }
    if (frag) {
      frame = frame | (1 << FrameCtrlData.FRAME_CTRL_POSITION_FRAG);
    }

    return frame;
  }

  /**
   * 是否加密
   * @return boolean
   **/
  public isEncrypted(): boolean {
    return this.check(FrameCtrlData.FRAME_CTRL_POSITION_ENCRYPTED);
  }

  /**
   * 是否尾帧校验
   * @return boolean
   **/
  public isChecksum(): boolean {
    return this.check(FrameCtrlData.FRAME_CTRL_POSITION_CHECKSUM);
  }

  /**
   * 是否需要回执
   * @return boolean
   **/
  public isAckRequirement(): boolean {
    return this.check(FrameCtrlData.FRAME_CTRL_POSITION_REQUIRE_ACK);
  }

  /**
   * 是否有分页
   * @return boolean
   **/
  public hasFrag(): boolean {
    return this.check(FrameCtrlData.FRAME_CTRL_POSITION_FRAG);
  }

  private check(position: number): boolean {
    return ((this.mValue >> position) as number & 1 === 1) ? true : false;
  }
}
