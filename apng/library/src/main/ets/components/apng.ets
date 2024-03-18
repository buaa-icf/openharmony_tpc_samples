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
import { APNG, Frame, UrlModel } from "./structs";
import url from '@ohos.url';

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

// canvas组件绘制单位为vp,与px的转换过程中存在精度丢失，需要手动转换成px
export function floor(n: number) {
  return Math.floor(px2vp(n));
}

export function ceil(n: number) {
  return Math.ceil(px2vp(n));
}

const defaultSpeed = 1;

@Component
export struct apng {
  @Prop src: Resource | Uint8Array | UrlModel;
  @Prop speedRate: number = defaultSpeed;
  @State @Watch('imageArrWatchHandle') imageArr: Array<string> = [];
  @State currentImage: string = '';
  @State styleInfo: Array<Object> = [];
  @State _numPlays: number = 0;
  scroller: Scroller = new Scroller();
  @State count: number = 0;
  @State frameTime: number = 100 / this.speedRate;
  @State timeTaken: string = '加载中...';
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
    setTimeout(() => {
      let frameInfo = this.styleInfo[this.count] as Frame;
      if (this.speedRate < 0.1 || this.speedRate > 2) {
        this.speedRate = defaultSpeed;
      }
      this.frameTime = frameInfo.delay == 0 ? 100 : frameInfo.delay / this.speedRate;
    })
    let count = this.count;

    setInterval(() => {
      count >= (max - 1) ? count = 0 : count++;
      this.count = count;
      this.currentImage = this.imageArr[count];
      let img: ImageBitmap = new ImageBitmap(this.currentImage);
      let frameStyle = this.styleInfo[count] as Frame;

      if (count === 0) {
        this.context.clearRect(0, 0, ceil(frameStyle.width), ceil(frameStyle.height));
        this.prevFrameData = null;
        if (frameStyle.disposeOp === 2) frameStyle.disposeOp = 1;
      }

      if (this.prevFrame && this.prevFrame.disposeOp == 1) {
        this.context.clearRect(px2vp(this.prevFrame.left), px2vp(this.prevFrame.top), px2vp(this.prevFrame.width), px2vp(this.prevFrame.height));
      } else if (this.prevFrame && this.prevFrame.disposeOp == 2) {
        this.context.putImageData(this.prevFrameData, floor(this.prevFrame.left), floor(this.prevFrame.top));
      }

      let frame = frameStyle;
      this.prevFrame = frame;
      this.prevFrameData = null;
      if (frame.disposeOp == 2) {
        this.prevFrameData = this.context.getImageData(floor(frame.left), floor(frame.top), frame.width, frame.height);
      }
      if (frame.blendOp == 0) {
        this.context.clearRect(px2vp(frame.left), px2vp(frame.top), px2vp(frame.width), px2vp(frame.height));
      }
      this.context.imageSmoothingEnabled = false;
      this.context.drawImage(img, px2vp(frame.left), px2vp(frame.top), px2vp(frame.width), px2vp(frame.height));
      if (this.timeTaken) {
        console.log('Time when the picture is displayed:' + new Date().getTime())
      }
      this.timeTaken = '';
    }, this.frameTime)
  }

  imageArrWatchHandle() {
    const imageArr = this.imageArr;
    this.getAllImage(imageArr);
    if (!imageArr.length) {
      return;
    }
    if (imageArr.length === 1) {
      this.currentImage = imageArr[0];
      return;
    }
    this.loop(this.count, imageArr.length);
  }

  async init() {
    const apngManager = new APngManager();

    if (this.src) {
      let apng: APNG = new APNG();
      if (this.src instanceof Uint8Array) {
        apng = apngManager.getAPNGInstance(this.src as Uint8Array);
      } else if ((this.src as UrlModel).url) {
        APngManager.loadData((this.src as UrlModel).url, (data) => {
          console.log('arrayBuffer length: ' + data.byteLength);
          if (data) {
            apng = apngManager.getAPNGInstance(new Uint8Array(data)) as APNG;
          } else {
            console.log(">>> data is empty or http request failed");
          }
        }, (err) => {
          this.timeTaken = '网络错误';
          console.log(">>>> error message : " + err);
        })
      } else if ((this.src as Resource).id) {
        let buffer = await apngManager.getResource(this.src as Resource);
        apng = apngManager.getAPNGInstance(buffer) as APNG;
      }
      await this.getImageArr(apng);
    }
  }

  async getImageArr(apng: APNG) {
    if (apng.frames.length) {
      let imagePixelArr: Array<string> = [];
      this.styleInfo = apng.frames;
      apng.frames.forEach((item) => {
        const bufferArr = item.imageBuffer;
        const buffer = bufferArr.reduce((rst, item) => {
          return typedArrayConcat(rst, item)
        }, new ArrayBuffer(0))
        try {
          const b = bufferUtil.from(buffer);
          const pbase64 = `data:image/png;base64,${b.toString('base64')}`;
          imagePixelArr.push(pbase64);
        } catch (error) {
          console.log('FG error ' + JSON.stringify(error));
        }

        if (imagePixelArr.length === apng.frames.length) {
          this.imageArr = imagePixelArr;
        }
      })
    }
  }

  build() {
    if (!this.timeTaken) {
      Canvas(this.context)
        .width('100%')
        .height('100%')
    } else {
      Column() {
        Text(this.timeTaken)
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Start)
    }

  }
}
