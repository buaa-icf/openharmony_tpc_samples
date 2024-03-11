/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import APngManager from "./manager";
import bufferUtil from '@ohos.buffer';
import { APNG, Frame } from "./structs";

function typedArrayConcat(buffer1: ArrayBuffer | Uint8Array, buffer2: ArrayBuffer | Uint8Array): ArrayBuffer {
  const u1 = new Uint8Array(buffer1);
  const u2 = new Uint8Array(buffer2);
  const length = u1.byteLength + u2.byteLength;
  const buffer = new ArrayBuffer(length);
  const uintBuffer = new Uint8Array(buffer);
  uintBuffer.set(u1, 0);
  uintBuffer.set(u2, buffer1.byteLength);
  return uintBuffer.buffer;
}

const defaultSpeed = 1;

@Component
export struct apng {
  @Prop src: Resource;
  @Prop speedRate: number = defaultSpeed;
  @State @Watch('imageArrWatchHandle') imageArr: Array<string> = [];
  @State currentImage: string = '';
  @State styleInfo: Array<Object> = [];
  @State _numPlays: number = 0;
  scroller: Scroller = new Scroller();
  @State count: number = 0;
  @State frameTime: number = 100 / this.speedRate;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private prevFrameData: ImageData | null = null;
  private prevFrame: Frame = new Frame();

  aboutToAppear() {
    this.init();
  }

  getAllImage: (allImages: Array<string>) => void = () => {
  };

  loop(c: number, max: number) {
    let frameInfo = this.styleInfo[this.count] as Frame;
    this.frameTime = frameInfo.delay == 0 ? 100 : frameInfo.delay / this.speedRate;
    let count = this.count;

    setInterval(() => {
        count >= (max - 1) ? count = 0 : count++;
      this.count = count;
      this.currentImage = this.imageArr[count];
      let img: ImageBitmap = new ImageBitmap(this.currentImage);
      let frameStyle = this.styleInfo[count] as Frame;

      if (count === 0) {
        this.context.clearRect(0, 0, px2vp(frameStyle.width), px2vp(frameStyle.height));
        this.prevFrameData = null;
        if (frameStyle.disposeOp === 2) frameStyle.disposeOp = 1;
      }

      if (this.prevFrame && this.prevFrame.disposeOp == 1) {
        this.context.clearRect(px2vp(this.prevFrame.left), px2vp(this.prevFrame.top), px2vp(this.prevFrame.width), px2vp(this.prevFrame.height));
      } else if (this.prevFrame && this.prevFrame.disposeOp == 2) {
        this.context.putImageData(this.prevFrameData, px2vp(this.prevFrame.left), px2vp(this.prevFrame.top));
      }

      let frame = frameStyle;
      this.prevFrame = frame;
      this.prevFrameData = null;
      if (frame.disposeOp == 2) {
        this.prevFrameData = this.context.getImageData(px2vp(frame.left), px2vp(frame.top), px2vp(frame.width), px2vp(frame.height));
      }
      if (frame.blendOp == 0) {
        this.context.clearRect(px2vp(frame.left), px2vp(frame.top), px2vp(frame.width), px2vp(frame.height));
      }
      this.context.imageSmoothingEnabled = false;
      this.context.drawImage(img, px2vp(frame.left), px2vp(frame.top), px2vp(frame.width), px2vp(frame.height));
    }, this.frameTime)
  }

  imageArrWatchHandle() {
    const imageArr = this.imageArr;
    this.getAllImage(imageArr);
    if (!imageArr.length) {
      return;
    }
    if (imageArr.length == 1) {
      this.currentImage = imageArr[0];
      return;
    }
    this.loop(this.count, imageArr.length);
  }

  async init() {
    const apngManager = new APngManager();

    if (this.src) {
      const buffer = await apngManager.getResource(this.src);
      const apng = apngManager.getAPNGInstance(buffer) as APNG;
      if (apng.frames.length) {
        let imagePixelArr: Array<string> = [];
        this.styleInfo = apng.frames;
        apng.frames.forEach((item) => {
          const bufferArr = item.imageBuffer;
          const buffer = bufferArr.reduce((rst, item) => {
            return typedArrayConcat(rst, item)
          }, new ArrayBuffer(0))
          const b = bufferUtil.from(buffer);
          const pbase64 = `data:image/png;base64,${b.toString('base64')}`;
          imagePixelArr.push(pbase64);

          if (imagePixelArr.length === apng.frames.length) {
            this.imageArr = imagePixelArr;
          }
        })
      }
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Canvas(this.context)
        .width('100%')
        .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}
