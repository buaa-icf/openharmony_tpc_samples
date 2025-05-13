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

import { FrameNode, NodeController } from '@ohos.arkui.node';
import buffer from '@ohos.buffer';
import * as AdaptiveCards from '@ohos/adaptivecards';
import router from '@ohos.router';
import { RouterParam } from './RouterParam';
import prompt from '@ohos.prompt';
import { ExecuteAction, SubmitAction } from '@ohos/adaptivecards/src/main/ets/card-elements';

class DynamicsNodeController extends NodeController {
  public rootNode: FrameNode | null = null;

  makeNode(uiContext: UIContext): FrameNode | null {
    if (!this.rootNode) {
      this.rootNode = new FrameNode(uiContext);
      this.rootNode.commonAttribute
        .width("100%")
        .backgroundColor(Color.Orange)
    }
    return this.rootNode;
  }
}


@Entry
@Component
struct RenderNode {
  jsonPath: string = "test.json";
  title: string = "";
  controller: DynamicsNodeController = new DynamicsNodeController();

  build() {
    Column() {
      Column() {
        Row() {
          Text(this.title)
        }.height(50)
        .backgroundColor(Color.White)
        .width('100%')
        .justifyContent(FlexAlign.Center)

        Scroll() {
          Column() {
            NodeContainer(this.controller)
          }.width('100%')
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarColor(Color.Gray)

      }.height("80%")

      Button($r('app.string.generate_cards'))
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .margin({ top: 50 })
        .onClick(async () => {
          let node = await this.renderHello();
          this.controller.rootNode?.appendChild(node)
        })
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Gray)

  }

  async renderHello(): Promise<FrameNode | undefined> {
    let adaptiveCard = new AdaptiveCards.AdaptiveCard();
    adaptiveCard.onExecuteAction = (action) => {
      if (this.jsonPath === "Action.Execute.json") {
        let res = action as ExecuteAction;
        prompt.showToast({
          message: JSON.stringify(res.data)
        });
      } else if (this.jsonPath === "Action.Submit.json") {
        let res = action as SubmitAction;
        prompt.showToast({
          message: JSON.stringify(res.data)
        });
      } else {
        prompt.showToast({
          message: action.getHref() ? action.getHref() : "hello"
        });
      }
    }

    // 自定义按钮
    // GlobalRegistry.defaultActions.register(SubmitAction.JsonTypeName, CustomSubmitAction);
    // 自定义Image
    // GlobalRegistry.defaultElements.register("Image", CustomImage);
    let card = await getContext(this).resourceManager.getRawFileContent(this.jsonPath)
    const json = buffer.from(card).toString();
    AdaptiveCards.LogUtils.getInstance().info("json:" + json);
    adaptiveCard.parse(JSON.parse(json));
    return adaptiveCard.render(this.getUIContext());
  }

  aboutToAppear(): void {
    let routerParam = (router.getParams() as RouterParam);
    this.jsonPath = routerParam.jsonPath;
    this.title = routerParam.title;
    AdaptiveCards.LogUtils.getInstance().setLogOpen(true);
  }
}