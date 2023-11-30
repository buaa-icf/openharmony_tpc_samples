/*
  Copyright (C) 2022 Huawei Device Co., Ltd.

  This software is distributed under a license. The full license
  agreement can be found in the file LICENSE in this distribution.
  This software may not be copied, modified, sold or distributed
  other than expressed in the named license agreement.
  This software is distributed without any warranty.
*/

import Ability from '@ohos.application.Ability'
import { Smack } from '@ohos/smack'

export default class MainAbility extends Ability {
    onCreate(want, launchParam) {
        console.log("[Demo] MainAbility onCreate")
        globalThis.abilityWant = want;

        globalThis.Smack = Smack;
    }

    onDestroy() {
        console.log("[Demo] MainAbility onDestroy")
    }

    onWindowStageCreate(windowStage) {
        console.log("[Demo] MainAbility onWindowStageCreate")
//      windowStage.setUIContent(this.context, "pages/page", null)
        windowStage.setUIContent(this.context, "pages/index", null)
    }

    onWindowStageDestroy() {
        console.log("[Demo] MainAbility onWindowStageDestroy")
    }

    onForeground() {
        console.log("[Demo] MainAbility onForeground")
    }

    onBackground() {
        console.log("[Demo] MainAbility onBackground")
    }
};
