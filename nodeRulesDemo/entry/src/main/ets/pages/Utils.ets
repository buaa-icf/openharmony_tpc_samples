import hilog from "@ohos.hilog";
import promptAction from "@ohos.promptAction";

export const showToast = (uiContext: UIContext, options: promptAction.ShowToastOptions) => {
  try {
    uiContext.getPromptAction().showToast(options);
  } catch (e) {
    hilog.error(0x0001, "[nodeRulesDemo]", "showToast error, message %{private}d", JSON.stringify(e));
  }
}

export const getStringByNameSync = (context: Context | undefined, resName: string) => {
  try {
    return context?.resourceManager.getStringByNameSync(resName) || "";
  } catch (e) {
    hilog.error(0x0001, "[nodeRulesDemo]", "getStringByNameSync error, message %{private}d", JSON.stringify(e));
    return "";
  }
}