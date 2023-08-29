export interface CustomCallback {

  beforeAppear?: () => void // 控件调aboutToAppear时回调

  beforeDisappear?: () => void  // 控件调aboutToDisappear时回调
}

export class BaseMode {

  // 是否允许点击返回键关闭弹窗
  onBackClose?: boolean = true

  // 是否允许操作后关闭弹窗，用于确认，选择按钮场景
  autoClose?: () => {}

  // 弹窗动画器，支持自定义能力
  popupAnimation?:TransitionEffect

  // 弹窗弹出后的位置 Left|Right|Top|Bottom
  positionDialog?: string

  // 是否支持手势拖拽
  isSupportGesture: boolean = true

  // 是否在弹框退出时，删除对象，释放资源
  isDeleteOnDisappear: boolean = false

  // 设置弹窗build前和build后的回调
  customCallback?: CustomCallback
}

