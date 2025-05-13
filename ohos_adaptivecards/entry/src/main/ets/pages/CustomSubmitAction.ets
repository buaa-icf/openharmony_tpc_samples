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
import { Action, SubmitAction } from '@ohos/adaptivecards/src/main/ets/card-elements';
import { typeNode } from '@ohos.arkui.node';

/**
 * 自定义按钮
 */
export class CustomSubmitAction extends Action{

  static readonly JsonTypeName: "Action.Submit" = "Action.Submit";

  getJsonTypeName(): string {
    return SubmitAction.JsonTypeName;
  }

  render(context:UIContext) {
    super.render(context);
    const buttonElement = typeNode.createNode(context, "Button");
    buttonElement.attribute.width('100%');
    buttonElement.attribute.height(50);
    buttonElement.attribute.fontColor('red')
    buttonElement.attribute.backgroundColor('#FCFFFE');
    buttonElement.attribute.border({width:1,color:'green'})
    buttonElement.attribute.align(Alignment.Center);
    buttonElement.attribute.fontWeight(FontWeight.Bolder);
    buttonElement.initialize(this.title)
    buttonElement.commonEvent.setOnClick((e)=>{
      if (this.isEffectivelyEnabled()) {
        this.execute(context);
      }
    })

    this._renderedElement = buttonElement;
  }


}