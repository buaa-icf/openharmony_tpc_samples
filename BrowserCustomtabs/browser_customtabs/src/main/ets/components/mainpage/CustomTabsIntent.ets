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

import Ability from '@ohos.app.ability.Ability';
import { CustomTabColorSchemeParams } from './CustomTabColorSchemeParams';
import rpc from '@ohos.rpc'

export class CustomTabsIntent {
  private static readonly EXTRA_ENABLE_URLRAR_HIDING = "ohos.customtabs.extra.EXTRA_ENABLE_URLRAR_HIDING";
  private static readonly EXTRA_CLOSE_BUTTON_ICON = "ohos.customtabs.extra.EXTRA_CLOSE_BUTTON_ICON";
  private static readonly EXTRA_TITLE_VISIBILITY_STATE = "ohos.customtabs.extra.EXTRA_TITLE_VISIBILITY_STATE";
  private static readonly KEY_MENU_ITEM_TITLE = "ohos.customtabs.extra.KEY_MENU_ITEM_TITLE";
  private static readonly KEY_PENDING_INTENT = "ohos.customtabs.extra.KEY_PENDING_INTENT";
  private static readonly EXTRA_DEFAULT_SHARE_MENU_ITEM = "ohos.customtabs.extra.EXTRA_DEFAULT_SHARE_MENU_ITEM";
  private static readonly EXTRA_ACTION_BUTTON_BUNDLE = "ohos.customtabs.extra.EXTRA_ACTION_BUTTON_BUNDLE";
  private static readonly KEY_ID = "ohos.customtabs.extra.KEY_ID";
  private static readonly KEY_ICON = "ohos.customtabs.extra.KEY_ICON";
  private static readonly KEY_DESCRIPTION = "ohos.customtabs.extra.KEY_DESCRIPTION";
  private static readonly EXTRA_TINT_ACTION_BUTTON = "ohos.customtabs.extra.EXTRA_TINT_ACTION_BUTTON";
  private static readonly EXTRA_MENU_ITEMS = "ohos.customtabs.extra.EXTRA_MENU_ITEMS";
  private static readonly EXTRA_TOOLBAR_ITEMS = "ohos.customtabs.extra.EXTRA_TOOLBAR_ITEMS";
  private static readonly EXTRA_SHARE_STATE = "ohos.customtabs.extra.EXTRA_SHARE_STATE";
  private static readonly NO_TITLE = 0;
  private static readonly SHOW_PAGE_TITLE = 1;
  private static readonly TOOLBAR_ACTION_BUTTON_ID = 0;
  private static readonly MAX_TOOLBAR_ITEMS = 5;
  private parameters = {};
  private want = {};

  constructor(parameters) {
    this.parameters = parameters;
  }

  public launchUrl(ability: Ability, url: string) {
    this.want = {
      "deviceId": "", //deviceId为空表示本设备
      "bundleName": "ohos.samples.browser",
      "abilityName": "MainAbility",
      "moduleName": "entry", //moduleName非必选
      "parameters": this.parameters,
      "uri": url
    }

    //测试
    console.log('browser---' + JSON.stringify(this.want));
  }

  public getWant(): string {
    return JSON.stringify(this.want);
  }

  public static getMaxToolbarItems(): number {
    return CustomTabsIntent.MAX_TOOLBAR_ITEMS;
  }

  static Builder = class {
    mParameters = {};
    mMenuItems = [];
    mShareState = 0;
    mActionButtons = [];

    public setDefaultColorSchemeParams(params: CustomTabColorSchemeParams) {
      Object.assign(this.mParameters, params.toWangParameters());
      return this;
    }

    public enableUrlBarHiding() {
      this.mParameters[CustomTabsIntent.EXTRA_ENABLE_URLRAR_HIDING] = {
        "type": "boolean", "value": true
      };
      return this;
    }

    public setUrlBarHidingEnabled(enabled: boolean) {
      this.mParameters[CustomTabsIntent.EXTRA_ENABLE_URLRAR_HIDING] = {
        "type": "boolean", "value": enabled
      };
      return this;
    }

    public setCloseButtonIcon(icon: Uint8Array) {
      this.mParameters[CustomTabsIntent.EXTRA_CLOSE_BUTTON_ICON] = {
        "type": "boolean", "value": icon
      };
      return this;
    }

    public setShowTitle(showTitle: boolean) {
      this.mParameters[CustomTabsIntent.EXTRA_TITLE_VISIBILITY_STATE] = {
        "type": "boolean", "value": showTitle ? CustomTabsIntent.SHOW_PAGE_TITLE : CustomTabsIntent.NO_TITLE
      };
      return this;
    }

    public addMenuItem(label: string, remoteObject: rpc.RemoteObject) {
      this.mMenuItems.push({
        [CustomTabsIntent.KEY_MENU_ITEM_TITLE]: {
          "type": "boolean", "value": label
        },
        [CustomTabsIntent.KEY_PENDING_INTENT]: {
          "type": "RemoteObject", "value": remoteObject
        }
      })
      return this;
    }

    public setShareState(enabled: boolean) {
      this.mParameters[CustomTabsIntent.EXTRA_DEFAULT_SHARE_MENU_ITEM] = {
        "type": "boolean", "value": enabled
      };
      this.mShareState = enabled == true ? 1 : 2
      return this;
    }

    public setActionButton(icon: Uint8Array, description: string, remoteObject: rpc.RemoteObject, shouldTint?: boolean) {
      this.mParameters[CustomTabsIntent.EXTRA_ACTION_BUTTON_BUNDLE] = {
        [CustomTabsIntent.KEY_ID]: {
          "type": "boolean", "value": CustomTabsIntent.TOOLBAR_ACTION_BUTTON_ID
        },
        [CustomTabsIntent.KEY_ICON]: {
          "type": "Uint8Array", "value": icon
        },
        [CustomTabsIntent.KEY_DESCRIPTION]: {
          "type": "string", "value": description
        },
        [CustomTabsIntent.KEY_PENDING_INTENT]: {
          "type": "RemoteObject", "value": remoteObject
        },
      }
      this.mParameters[CustomTabsIntent.EXTRA_TINT_ACTION_BUTTON] = {
        "type": "boolean", "value": shouldTint ? shouldTint : false
      };
      return this;
    }

    public addToobarItem(id: number, icon: Uint8Array, description: string, remoteObject: rpc.RemoteObject) {
      if (this.mActionButtons.length >= CustomTabsIntent.MAX_TOOLBAR_ITEMS) {
        throw new Error("Exceeded maximum toolbar item count of " + CustomTabsIntent.MAX_TOOLBAR_ITEMS);
      }
      this.mActionButtons.push({
        [CustomTabsIntent.KEY_ID]: {
          "type": "boolean", "value": id
        },
        [CustomTabsIntent.KEY_ICON]: {
          "type": "Uint8Array", "value": icon
        },
        [CustomTabsIntent.KEY_DESCRIPTION]: {
          "type": "string", "value": description
        },
        [CustomTabsIntent.KEY_PENDING_INTENT]: {
          "type": "RemoteObject", "value": remoteObject
        },
      })
      return this;
    }

    public building(): CustomTabsIntent {
      if (this.mMenuItems.length > 0) {
        this.mParameters[CustomTabsIntent.EXTRA_MENU_ITEMS] = {
          "type": "array", "value": this.mMenuItems
        };
      }
      if (this.mActionButtons.length > 0) {
        this.mParameters[CustomTabsIntent.EXTRA_TOOLBAR_ITEMS] = {
          "type": "array", "value": this.mActionButtons
        };
      }
      this.mParameters[CustomTabsIntent.EXTRA_SHARE_STATE] = {
        "type": "number", "value": this.mShareState
      }
      return new CustomTabsIntent(this.mParameters);
    }
  }
}