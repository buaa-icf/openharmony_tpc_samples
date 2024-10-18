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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { init, SetLogShowState } from '../utils/main'
import { UnitTest } from '../utils/unitTest'

//运行模式
enum EnumRunMode{
  eRunRelease,
  eRunUnitTest,
}

@Entry
@Component
struct Index {
  private runMode:EnumRunMode = EnumRunMode.eRunUnitTest;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  @State canvasHeight: number = 0;
  @State canvasWidth: number = 0;

  build() {
    Stack() {
      Row() {
        Canvas(this.context)
          .width(this.canvasWidth)
          .height(this.canvasHeight)
          .onReady(() => {
            //获取lua入口文件
            let content = getContext(this);

            if(this.runMode == EnumRunMode.eRunRelease)
            {
              let filePath = content.resourceDir + "/main.lua";
              hilog.info(0x0000, 'testTag', '1.获取lua入口文件沙箱地址,path=%{public}s', filePath);

              //调用har包初始化接口
              hilog.info(0x0000, 'testTag', '2.准备调用har包init初始化接口');
              SetLogShowState(false);
              init(this.context, this.canvasWidth, this.canvasHeight, filePath);

              hilog.info(0x0000, 'testTag', 'end.完成初始化');
            }else{
              //测试本地napi接口
              let filePath = content.resourceDir + "/unitTest.lua";
              hilog.info(0x0000, 'testTag', '1.获取lua入口文件沙箱地址,path=%{public}s', filePath);

              //调用har包初始化接口
              hilog.info(0x0000, 'testTag', '2.准备调用har包UnitTest初始化接口');
              SetLogShowState(false);
              UnitTest(this.context, this.canvasWidth, this.canvasHeight, filePath);

              hilog.info(0x0000, 'testTag', 'end.完成所有测试');
            }

          })
          .onTouch((event: TouchEvent) => {

          })
      }
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.canvasWidth = Number(newValue.width).valueOf()
        this.canvasHeight = Number(newValue.height).valueOf()
      })
      .width("100%")
      .height("100%")
    }
    .height('100%')
  }
}
