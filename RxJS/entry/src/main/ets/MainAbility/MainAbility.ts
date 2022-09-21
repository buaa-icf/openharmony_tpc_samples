import Ability from '@ohos.application.Ability'

export default class MainAbility extends Ability {
    onCreate(want, launchParam) {
        globalThis.abilityWant = want;
    }

    onDestroy() {

    }

    onWindowStageCreate(windowStage) {
        // Main window is created, set main page for this ability
        windowStage.setUIContent(this.context, "pages/index", null)
    }

    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
    }

    onForeground() {
        // Ability has brought to foreground
    }

    onBackground() {
        // Ability has back to background
    }
};
