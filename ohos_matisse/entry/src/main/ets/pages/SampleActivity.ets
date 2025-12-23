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

import { router } from '@kit.ArkUI';
import { MatissePage, MimeType } from '@ohos/matisse';
import { ImageSelectionManager } from '../utils/ImageSelectionManager';

/**
 * Sample activity for demonstrating Matisse media selection functionality
 * Supports different configuration scenarios: Zhihu, Dracula, and OnlyGif
 */
@Entry
@Component
struct SampleActivity {
  @State private mActionId: string = '';
  @State private mShowMatissePage: boolean = false;
  @State private mMatisseKey: number = 0;
  @State private mMatisseMimeType: string = '';
  @State private mMatisseMaxSelectable: number = 1;
  @State private mMatisseMaxImageSelectable: number = 0;
  @State private mMatisseMaxVideoSelectable: number = 0;
  @State private mMatisseRestrictOrientation: number = 0;
  @State private mMatisseOriginalEnable: boolean = true;
  @State private mMatisseMaxOriginalSize: number = Number.MAX_SAFE_INTEGER;
  @State private mMatisseCapture: boolean = false;
  @State private mMatisseMediaTypeExclusive: boolean = false;
  @State private mMatisseAutoHideToobar: boolean = false;
  @State private mMatisseCountable: boolean = true;

  /**
   * Component initialization
   * Configures Matisse parameters based on action ID from router params
   */
  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>;
    this.mActionId = params['message'];
    this.configureMatisseParams();
  }

  /**
   * Configures Matisse parameters based on action ID
   */
  private configureMatisseParams(): void {
    if (this.mActionId === 'zhihu') {
      this.configureZhihuMode();
    } else if (this.mActionId === 'dracula') {
      this.configureDraculaMode();
    } else if (this.mActionId === 'only_gif') {
      this.configureOnlyGifMode();
    }
  }

  /**
   * Configures Matisse for Zhihu mode
   * Reference Android: choose(MimeType.ofImage(), false), countable(true), capture(true),
   * maxSelectable(9), restrictOrientation(PORTRAIT),
   * originalEnable(true), maxOriginalSize(10), autoHideToolbarOnSingleTap(true)
   */
  private configureZhihuMode(): void {
    this.mMatisseMimeType = MimeType.ofImage();
    this.mMatisseMediaTypeExclusive = false;
    this.mMatisseCountable = true;
    this.mMatisseCapture = true;
    this.mMatisseMaxSelectable = 9;
    this.mMatisseMaxImageSelectable = 0;
    this.mMatisseMaxVideoSelectable = 0;
    this.mMatisseRestrictOrientation = 1;
    this.mMatisseOriginalEnable = true;
    this.mMatisseMaxOriginalSize = 10;
    this.mMatisseAutoHideToobar = true;
  }

  /**
   * Configures Matisse for Dracula mode
   * Reference Android: choose(MimeType.ofImage()), countable(false), maxSelectable(9),
   * originalEnable(true), maxOriginalSize(10)
   */
  private configureDraculaMode(): void {
    this.mMatisseMimeType = MimeType.ofImage();
    this.mMatisseCountable = true;
    this.mMatisseMaxSelectable = 9;
    this.mMatisseMaxImageSelectable = 0;
    this.mMatisseMaxVideoSelectable = 0;
    this.mMatisseRestrictOrientation = 0;
    this.mMatisseOriginalEnable = false;
    this.mMatisseMaxOriginalSize = 10;
    this.mMatisseCapture = false;
    this.mMatisseAutoHideToobar = false;
  }

  /**
   * Configures Matisse for OnlyGif mode
   * Reference Android: choose(MimeType.of(MimeType.GIF), false), countable(true),
   * maxSelectable(9), restrictOrientation(PORTRAIT),
   * originalEnable(true), maxOriginalSize(10), autoHideToolbarOnSingleTap(true)
   */
  private configureOnlyGifMode(): void {
    this.mMatisseMimeType = MimeType.ofGif();
    this.mMatisseMediaTypeExclusive = false;
    this.mMatisseCountable = true;
    this.mMatisseMaxSelectable = 9;
    this.mMatisseMaxImageSelectable = 0;
    this.mMatisseMaxVideoSelectable = 0;
    this.mMatisseRestrictOrientation = 1;
    this.mMatisseOriginalEnable = true;
    this.mMatisseMaxOriginalSize = 10;
    this.mMatisseCapture = false;
    this.mMatisseAutoHideToobar = true;
  }

  /**
   * Handles selection result callback
   * @param uris - Selected media URIs
   * @param paths - Selected media paths
   * @param originalChecked - Whether original image is selected
   */
  private onSelectionResult(uris: string[], paths: string[], originalChecked: boolean): void {
    const imageManager = ImageSelectionManager.getInstance();
    imageManager.saveImageUrls(uris);
    imageManager.saveImagePaths(paths);
    imageManager.saveObtainOriginalState(originalChecked);
  }

  /**
   * Handles selected items changed callback
   * @param uriList - Selected URI list
   * @param pathList - Selected path list
   */
  private onSelectedItemsChanged(uriList: Array<string>, pathList: Array<string>): void {
    console.info('SampleActivity: Selected items changed, uris:', JSON.stringify(uriList));
    console.info('SampleActivity: Selected items changed, paths:', JSON.stringify(pathList));
  }

  /**
   * Handles original image checked state changed callback
   * @param isChecked - Whether original image is checked
   */
  private onOriginalCheckedChanged(isChecked: boolean): void {
    console.info(`SampleActivity: Original image checked state changed: ${isChecked}`);
  }

  build() {
    Column() {
      Column() {
        Text($r('app.string.app_name'))
          .fontSize(20);
      }
      .width('100%')
      .height(60);
      MatissePage({
        mimeType: this.mMatisseMimeType,
        mediaTypeExclusive: this.mMatisseMediaTypeExclusive,
        countable: this.mMatisseCountable,
        maxSelectable: this.mMatisseMaxSelectable,
        maxImageSelectable: this.mMatisseMaxImageSelectable,
        maxVideoSelectable: this.mMatisseMaxVideoSelectable,
        orientation: this.mMatisseRestrictOrientation,
        originalable: this.mMatisseOriginalEnable,
        originalMaxSize: this.mMatisseMaxOriginalSize,
        autoHideToobar: this.mMatisseAutoHideToobar,
        capture: this.mMatisseCapture,
        forResult: (uris: string[], paths: string[], originalChecked: boolean) => {
          this.onSelectionResult(uris, paths, originalChecked);
        },
        setOnSelectedListener: (uriList: Array<string>, pathList: Array<string>) => {
          this.onSelectedItemsChanged(uriList, pathList);
        },
        setOnCheckedListener: (isChecked: boolean) => {
          this.onOriginalCheckedChanged(isChecked);
        }
      })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
