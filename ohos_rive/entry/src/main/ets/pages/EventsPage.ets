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

import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { RiveAnimationView, RiveEvent, RiveEventListener, RiveGeneralEvent, RiveOpenURLEvent } from '@ohos/rive';

class StarRatingListener implements RiveEventListener {
  private onRatingChange: (rating: string) => void;
  constructor(onRatingChange: (rating: string) => void) {
    this.onRatingChange = onRatingChange;
  }
  notifyEvent(event: RiveEvent): void {
    if (event instanceof RiveGeneralEvent) {
      console.info('RiveEvent',
        `General event received, name: ${event.name}, properties: ${JSON.stringify(event.properties)}`);
      // This event contains a number value with the name "rating"
      // to indicate the star rating selected
      if (event.properties['rating'] !== undefined) {
        this.onRatingChange(`Star rating: ${event.properties['rating']}`);
      }
    }
  }
}

class UrlButtonListener implements RiveEventListener {
  private context: common.UIAbilityContext;
  constructor(context: common.UIAbilityContext) {
    this.context = context;
  }
  notifyEvent(event: RiveEvent): void {
    if (event instanceof RiveOpenURLEvent) {
      console.info('RiveEvent', `Open URL Rive event: ${event.url}`);
      try {
        let want: Want = {
          bundleName: 'com.huawei.hmos.browser',
          action: 'ohos.want.action.viewData',
          entities: ['entity.system.browsable'],
          uri: event.url
        };
        this.context.startAbility(want)
          .then(() => {
            console.log('Browser started successfully');
          })
          .catch((err: BusinessError) => {
            console.error(`Failed to start browser, error code: ${err.code}, message: ${err.message}`);
          });
      } catch (e) {
        console.error('RiveEvent', `Not a valid URL ${event.url}`);
      }
    }
  }
}

// Define a class implementing RiveEventListener for log button
class LogButtonListener implements RiveEventListener {
  notifyEvent(event: RiveEvent): void {
    if (event instanceof RiveGeneralEvent) {
      console.info('RiveEvent',
        `General event received, name: ${event.name}, properties: ${JSON.stringify(event.properties)}`);
    } else if (event instanceof RiveOpenURLEvent) {
      console.info('RiveEvent', `Open URL Rive event: ${event.url}`);
    }
  }
}

@Entry
@Component
struct EventsPage {
  @State starRating: string = 'Star rating: none selected';
  private starRatingAnimationView: RiveAnimationView | null = null;
  private starRatingListener: StarRatingListener | null = null;
  private urlButtonAnimationView: RiveAnimationView | null = null;
  private urlButtonListener: UrlButtonListener | null = null;
  private logButtonAnimationView: RiveAnimationView | null = null;
  private logButtonListener: LogButtonListener | null = null;
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  setStarRating() {
    if (!this.starRatingAnimationView) {
      return;
    }
    // Create the event listener
    this.starRatingListener = new StarRatingListener((rating: string) => {
      this.starRating = rating;
    });
    // Add the event listener to the RiveAnimationView
    this.starRatingAnimationView.addEventListener(this.starRatingListener);
  }

  setUrlButton() {
    if (!this.urlButtonAnimationView) {
      return;
    }
    // Create the event listener
    this.urlButtonListener = new UrlButtonListener(this.context);
    // Add the event listener to the RiveAnimationView
    this.urlButtonAnimationView.addEventListener(this.urlButtonListener);
  }

  setLogButton() {
    if (!this.logButtonAnimationView) {
      return;
    }
    // Create the event listener
    this.logButtonListener = new LogButtonListener();
    // Add the event listener to the RiveAnimationView
    this.logButtonAnimationView.addEventListener(this.logButtonListener);
  }

  aboutToDisappear(): void {
    if (this.starRatingAnimationView && this.starRatingListener) {
      this.starRatingAnimationView.removeEventListener(this.starRatingListener);
    }
    if (this.urlButtonAnimationView && this.urlButtonListener) {
      this.urlButtonAnimationView.removeEventListener(this.urlButtonListener);
    }
    if (this.logButtonAnimationView && this.logButtonListener) {
      this.logButtonAnimationView.removeEventListener(this.logButtonListener);
    }
  }

  build() {
    Scroll() {
      Column() {
        RiveAnimationView({
          riveResource: '@rawfile/rating.riv',
          riveFit: 'cover',
          riveStateMachine: 'State Machine 1',
          onReady: (view) => {
            this.starRatingAnimationView = view
            this.setStarRating();
          }
        })
          .width('100%')
          .height('50%')
          .margin({ top: 16, bottom: 16 })

        Text(this.starRating)
          .fontSize(28)
          .margin({ left: 16 })
          .textAlign(TextAlign.Start)
        Divider()
          .height(22)
          .color('#182431')
          .opacity(0.6)
          .margin({ left: 8, right: 8 })
        Text('Button (URL Event): Open `https://rive.app`')
          .fontSize(15)
          .margin({ left: 16 })
          .textAlign(TextAlign.Start)

        RiveAnimationView({
          riveResource: '@rawfile/url_event_button.riv',
          riveFit: 'cover',
          riveStateMachine: 'button',
          onReady: (view) => {
            this.urlButtonAnimationView = view;
            this.setUrlButton();
          }
        })
          .width('100%')
          .height(100)
          .margin({ top: 16, bottom: 16 })

        Divider()
          .width('100%')
          .height(2)
          .margin({ top: 16, bottom: 16, left: 16, right: 16 })
          .backgroundColor('#808080')

        Text('Button (General Event): Console Log')
          .fontSize(15)
          .margin({ left: 16 })
          .textAlign(TextAlign.Start)

        RiveAnimationView({
          riveResource: '@rawfile/log_event_button.riv',
          riveFit: 'cover',
          riveStateMachine: 'button',
          onReady: (view) => {
            this.logButtonAnimationView = view;
            this.setLogButton();
          }
        })
          .width('100%')
          .height(100)
          .margin({ top: 16, bottom: 16 })
      }
    }
  }
}