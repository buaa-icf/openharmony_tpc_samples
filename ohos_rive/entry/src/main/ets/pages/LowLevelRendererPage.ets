/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import {
  Artboard,
  Alignment,
  File,
  Fit,
  RectF,
  Renderer,
  RendererType,
  RiveAnimationView,
  StateMachineInstance
} from '@ohos/rive';
import { TitleBar } from '../common/TitleBar';

const RIVE_FILE_NAME = 'layout_test.riv';

@Entry
@ComponentV2
struct LowLevelRendererPage {
  public file: File | null = null
  public artboard: Artboard | null = null
  public stateMachine: StateMachineInstance | null = null
  public render: CustomRenderer | null = null

  @Event
  creatRenderer: () => Promise<Renderer | null> = async (): Promise<Renderer | null> => {
    const setUpFile = async () => {
      try {
        const riv: Uint8Array | undefined =
          await this.getUIContext().getHostContext()?.resourceManager.getRawFileContent(RIVE_FILE_NAME)
        if (riv) {
          const arrayBuffer = riv.buffer.slice(
            riv.byteOffset,
            riv.byteOffset + riv.byteLength
          );
          this.file = new File(arrayBuffer);
          this.artboard = this.file.firstArtboard
          this.stateMachine = this.artboard.firstStateMachine
        }
      } catch (err) {
        console.error(`LowLevelRenderPage: Error processing loaded file: ${err}`);
      }
    }

    try {
      await setUpFile()
      if (this.artboard && this.stateMachine) {
        this.render =
          new CustomRenderer(this.getUIContext(), this.artboard, this.stateMachine)
        console.info(`LowLevelRenderPage: creatRenderer render: ${this.render}`);
        return this.render
      }
    } catch (error) {
      console.error(`LowLevelRenderPage: creatRenderer error: ${JSON.stringify(Error)}`);
    }
    return null
  }

  build() {
    Column() {
      TitleBar()
      RiveAnimationView({
        creatRendererFun: this.creatRenderer
      })
    }
    .width('100%')
    .height(366)
    .backgroundColor('#F5F5F5')
    .padding(20)
  }
}


export class CustomRenderer extends Renderer {
  private scaleFactor: number = vp2px(1);
  private artboard: Artboard;
  private stateMachine: StateMachineInstance;

  constructor(context: UIContext, artboard: Artboard, stateMachine: StateMachineInstance,) {
    super(context, RendererType.Rive, false);
    this.artboard = artboard
    this.stateMachine = stateMachine
  }

  override draw(): void {
    if (!this.artboard || !this.hasCppObject) {
      console.warn('LowLevelRenderPage: Draw skipped. No active Artboard or C++ object is null.');
      return;
    }
    const density = this.scaleFactor;
    this.artboard.width = this.width / density
    this.artboard.height = this.height / density
    this.save();
    this.align(
      Fit.LAYOUT,
      Alignment.CENTER,
      new RectF(0.0, 0.0, this.width, this.height),
      this.artboard.bounds as RectF,
      density
    );
    this.artboard.draw(this.cppPointer);
    this.restore();
  }

  advance(elapsed: number): void {
    this.stateMachine.advance(elapsed)
    this.artboard.advance(elapsed)
  }

  start(): void {
    if (this.isAttached) {
      super.start();
    }
  }

  stop(): void {
    super.stop();
  }

  delete(): void {
    super.delete();
  }
}