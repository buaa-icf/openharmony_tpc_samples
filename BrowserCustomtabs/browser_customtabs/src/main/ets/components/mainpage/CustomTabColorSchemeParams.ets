/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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

export class CustomTabColorSchemeParams {
  private static readonly EXTRA_TOOLBAR_COLOR = 'ohos.customtabs.extra.TOOLBAR_COLOR';
  private static readonly EXTRA_SECONDARY_TOOLBAR_COLOR = 'ohos.customtabs.extra.SECONDARY_TOOLBAR_COLOR';
  private static readonly EXTRA_NAVIGATION_BAR_COLOR = 'ohos.browser.customtabs.extra.NAVIGATION_BAR_COLOR';
  private static readonly EXTRA_NAVIGATION_BAR_DIVIDER_COLOR = 'ohos.customtabs.extra.NAVIGATION_BAR_DIVIDER_COLOR';
  private toolbarColor: number;
  private secondaryToolbarColor: number;
  private navigationBarColor: number;
  private navigationBarDividerColor: number;

  constructor(toolbarColor: number, secondaryToolbarColor: number, navigationBarColor: number, navigationBarDividerColor: number) {
    this.toolbarColor = toolbarColor;
    this.secondaryToolbarColor = secondaryToolbarColor;
    this.navigationBarColor = navigationBarColor;
    this.navigationBarDividerColor = navigationBarDividerColor;
  }

  public toWangParameters(): any {
    return {
      [CustomTabColorSchemeParams.EXTRA_TOOLBAR_COLOR]: {
        "type": "number", "value": this.toolbarColor
      },
      [CustomTabColorSchemeParams.EXTRA_SECONDARY_TOOLBAR_COLOR]: {
        "type": "number", "value": this.secondaryToolbarColor
      },
      [CustomTabColorSchemeParams.EXTRA_NAVIGATION_BAR_COLOR]: {
        "type": "number", "value": this.navigationBarColor
      },
      [CustomTabColorSchemeParams.EXTRA_NAVIGATION_BAR_DIVIDER_COLOR]: {
        "type": "number", "value": this.navigationBarDividerColor
      },
    }
  }

  public withDefaults(defaults: CustomTabColorSchemeParams): CustomTabColorSchemeParams {
    return new CustomTabColorSchemeParams(this.toolbarColor == null ? defaults.toolbarColor : this.toolbarColor,
        this.secondaryToolbarColor == null ? defaults.secondaryToolbarColor : this.secondaryToolbarColor, this.navigationBarColor == null ? defaults.navigationBarColor : this.navigationBarColor,
        this.navigationBarDividerColor == null ? defaults.navigationBarDividerColor : this.navigationBarDividerColor);
  }

  static Builder = class {
    mToolbarColor: number;
    mSecondaryToolbarColor: number;
    mNavigationBarColor: number;
    mNavigationBarDividerColor: number;

    public setToobarColor(color: number) {
      this.mToolbarColor = color | 0xff0000000;
      return this;
    }

    public setSecondaryToolbarColor(color: number) {
      this.mSecondaryToolbarColor = color;
    }

    public setNavigationBarColor(color: number) {
      this.mNavigationBarColor = color | 0xff000000;
      return this;
    }

    public setNavigationBarDividerColor(color: number) {
      this.mNavigationBarDividerColor = color;
      return this;
    }

    public building(): CustomTabColorSchemeParams {
      return new CustomTabColorSchemeParams(this.mToolbarColor, this.mSecondaryToolbarColor, this.mNavigationBarColor, this.mNavigationBarDividerColor);
    }
  }
}