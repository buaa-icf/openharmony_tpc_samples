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
import { Image } from '@ohos/adaptivecards/src/main/ets/card-elements';
import * as Enums from '@ohos/adaptivecards/src/main/ets/enums';
import { typeNode } from '@ohos.arkui.node';
import { UIContext } from '@ohos.arkui.UIContext';
import { LogUtils } from '@ohos/adaptivecards/src/main/ets/LogUtils';
import * as Utils from '@ohos/adaptivecards/src/main/ets/utils';

/**
 * 自定义Image
 */
export class CustomImage extends Image{

  getJsonTypeName(): string {
    return "Image";
  }

  private w : number | undefined = 0;

  private h : number | undefined = 0;

  private setSize(element: FrameNode) {
    if (this.pixelWidth || this.pixelHeight) {
      if (this.pixelWidth) {
        element.commonAttribute.width(this.pixelWidth)
      }
      if (this.pixelHeight) {
        element.commonAttribute.height(this.pixelHeight)
      }
    } else {
      if (this.maxHeight) {
        // If the image is constrained in height, we set its height property and
        // auto and stretch are ignored (default to medium). THis is necessary for
        // ImageSet which uses a maximum image height as opposed to the cards width
        // as a constraining dimension
        element.commonAttribute.height(this.hostConfig.getEffectiveImageSize(this.size))
        element.commonAttribute.constraintSize({maxHeight:this.maxHeight});
      } else {
        switch (this.size) {
          case Enums.Size.Stretch:
            // element.style.width = "100%";
            element.commonAttribute.width('100%')
            break;
          case Enums.Size.Auto:
            if(element.getNodeType() == "Image") {
              element.commonAttribute.width(this.w);
              element.commonAttribute.height(this.h);
            }
            break
          default:
            element.commonAttribute.width(this.hostConfig.getEffectiveImageSize(this.size))
            break;
        }
        element.commonAttribute.constraintSize({maxHeight:'100%'});
      }
    }
  }

  protected internalRender(context:UIContext): FrameNode | undefined {
    let element: typeNode.Flex | undefined = undefined;
    if (this.url) {
      element = typeNode.createNode(context,"Flex");
      if(this.pixelWidth) {
        element.attribute.width(this.pixelWidth);
      } else {
        element.attribute.width('auto');
      }
      if(this.pixelHeight) {
        element.attribute.height(this.pixelHeight);
      } else {
        element.attribute.height('auto');
      }
      // Cache hostConfig to avoid walking the parent hierarchy multiple times
      const hostConfig = this.hostConfig;

      switch (this.getEffectiveHorizontalAlignment()) {
        case Enums.HorizontalAlignment.Center:
          element.initialize({alignItems:ItemAlign.Start, justifyContent:FlexAlign.Center});
          break;
        case Enums.HorizontalAlignment.Right:
          element.initialize({alignItems:ItemAlign.Start, justifyContent:FlexAlign.End});
          break;
        default:
          element.initialize({alignItems:ItemAlign.Start, justifyContent:FlexAlign.Start});
          break;
      }
      const imageElement = typeNode.createNode(context,"Image");
      this.renderedImageElement = imageElement;
      imageElement.attribute.objectFit(ImageFit.Contain);
      let initializeUrl = imageElement.initialize(this.url);
      initializeUrl.onComplete((e)=>{
        this.w = e?.width;
        this.h = e?.height;
        this.setSize(imageElement);
        LogUtils.getInstance().info("image onComplete w "+e?.width+" h "+e?.height)
      })

      imageElement.commonAttribute.constraintSize({minWidth:0});

      if (this.selectAction && hostConfig.supportsInteractivity) {

        imageElement.commonEvent.setOnKeyEvent((e)=>{
          if (
            this.selectAction &&
            this.selectAction.isEffectivelyEnabled() &&
              (e.keyText === "Enter" || e.keyText === "Space")
          ) {
            this.selectAction.execute(context);
          }
        })
        imageElement.commonEvent.setOnClick((e)=>{
          if (this.selectAction && this.selectAction.isEffectivelyEnabled()) {
            this.selectAction.execute(context);
          }
        })
        this.selectAction.setupElementForAccessibility(imageElement);
      }
      if (this.style === Enums.ImageStyle.Person) {
        if(this.pixelWidth > 0) {
          imageElement.attribute.borderRadius(this.pixelWidth/2);
        } else {
          if(this.w! > 0) {
            imageElement.attribute.borderRadius((this.w!)/2);
          }
        }
        imageElement.attribute.backgroundImagePosition(Alignment.Center);
        imageElement.attribute.objectRepeat(ImageRepeat.NoRepeat);
      }

      const backgroundColor = Utils.stringToCssColor(this.backgroundColor);
      if (backgroundColor) {
        imageElement.attribute.backgroundColor(backgroundColor);
      }
      element.appendChild(imageElement);
    }

    return element;
  }


}