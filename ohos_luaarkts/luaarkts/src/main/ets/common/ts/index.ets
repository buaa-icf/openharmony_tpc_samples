/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import harNAPI from 'libluaarkts.so';

export interface textFillProperty {
  font?: string,
  fillStyle?: string,
  fillText: fillText
}

export interface fillText {
  text: string,
  x: number,
  y: number,
  maxWidth?: number
}

export interface ImageProperty {
  image: ImageBitmap | PixelMap,
  dx: number,
  dy: number,
  dw: number,
  dh: number
}

export function C2tCallBack(a:number, s:string, b:number, callbackFuncLua: string): number {
  let tmpFunc =():Promise<string>=>{return new Promise((resolve) => {
    let c = a + b
    harNAPI.T2lCallFunction(callbackFuncLua);
  });
  }

  tmpFunc();

  return 1;
}

export function C2tCallBack2(a:number, s:string, b:number, callbackFuncLua: string): Promise<string> {
  return new Promise((resolve) => {
    let c = a + b
    harNAPI.T2lCallFunction(callbackFuncLua, c);
    resolve("testTag -- Promis返回");
  });
}

export function testNumberAdd(number:number){
  return number+1
}


export function factoryGameControl(): gameControl {
  return gameControl.Instance;
}

export function drawImage(): void {
  const gameControl: gameControl = factoryGameControl();
  gameControl.initBackgroundImage("/common/assets/bg_3.jpg")
  gameControl.addDrawText({
    font: "56px HarmonyOS Sans",
    fillStyle: "#FFff0000",
    fillText: {
      text: 'test',
      x: 10,
      y: 30,
      maxWidth: 200
    }
  })
  gameControl.addDrawImage(new ImageBitmap('/common/assets/plane_1.png'), 200, 300, 120,
    80)
}

export class gameControl {
  static Instance: gameControl;
  // canvas 对象
  private context: CanvasRenderingContext2D;
  // textFill集合
  private textArray: Array<textFillProperty> = [];
  // 图形集合
  private imageArray: Array<ImageProperty> = [];
  // canvas 宽
  private canvasWidth: number;
  // canvas高
  private canvasHeight: number;
  // 背景图片
  private bgImages: string;
  public testVal: number = 1;
  public propertyName: string = "12345";

  constructor(context: CanvasRenderingContext2D, canvasWidth: number, canvasHeight: number, bgImage?: string) {
    this.context = context;
    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;
    this.bgImages = bgImage || "/common/assets/bg_3.jpg"
    this.initBackgroundImage(this.bgImages);
  }


  // 创建背景图片
  initBackgroundImage(img: string): void {
    this.context.drawImage(new ImageBitmap(img), 0, 0, this.canvasWidth, this.canvasHeight)
  }

  // 清除画布
  clearImage(): void {
    this.context.clearRect(0, 0, this.canvasWidth, this.canvasHeight);
    this.initBackgroundImage(this.bgImages);
    this.drawText();
    this.drawImage();
  }

  // 新增fillText
  addDrawText(textDetails: textFillProperty): void {
    this.textArray.push(textDetails);
    this.drawText();
  }

  // 绘制filltext
  drawText(): void {
    if (!this.textArray.length) {
      return
    }
    // 绘制文字
    this.textArray.forEach(item => {
      this.context.font = item.font || "56px HarmonyOS Sans";
      this.context.fillStyle = item.fillStyle || "#FFff0000";
      this.context.fillText(item.fillText.text, item.fillText.x, item.fillText.y, item.fillText.maxWidth);
    })
  }

  // 绘制filltext
  public static drawOnceText(): void {
    gameControl.Instance.context.font = "56px HarmonyOS Sans";
    gameControl.Instance.context.fillStyle = "#FFff0000";
    gameControl.Instance.context.fillText('test hello world', 10, 20, 200);
  }

  // 删除filltext
  delDrawText(textDetails: textFillProperty): void {
    this.textArray = this.textArray.filter(item => {
      return JSON.stringify(item) !== JSON.stringify(textDetails)
    })
    this.clearImage();
  }

  // 绘制image
  drawImage(): void {
    // 绘制图片
    this.imageArray.forEach(image => {
      this.context.drawImage(image.image, image.dx, image.dy, image.dw, image.dh)
    })
  }

  // 新增Image
  addDrawImage(image: ImageBitmap | PixelMap, dx: number, dy: number, dw: number, dh: number): void {
    if (!image || !dx || !dy || !dw || !dh) {
      throw new Error('请输入需要绘制的图片信息！')
    }
    this.imageArray.push({
      image,
      dx,
      dy,
      dw,
      dh
    });
    this.drawImage();
  }

  // 删除DrawImage
  delDrawImage(image: ImageBitmap | PixelMap, dx: number, dy: number, dw: number, dh: number): void {
    const imageDetails: ImageProperty = {
      image,
      dx,
      dy,
      dw,
      dh
    }
    this.imageArray = this.imageArray.filter(item => {
      return JSON.stringify(item) !== JSON.stringify(imageDetails)
    })
    this.clearImage();
  }
}