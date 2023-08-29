import { BaseMode } from './BaseModel'
export class PositionDialogModel extends BaseMode {

  textValue?: string = '标题'                     // 弹窗标题

  contentValue?: string = ''                     // 内容文字

  cancelBtnTitle?: string = '取消'                // 取消按钮标题

  cancelBtnFontColor?: string = '#317aff'        // 取消字体颜色

  cancelBtnBgColor?: string = '#317aff'          // 取消背景颜色

  confirmBtnTitle?: string = '确认'               // 确认按钮标题

  confirmBtnFontColor?: string = '#ffffff'       // 确认字体颜色

  confirmBtnBgColor?: string = '#317aff'         // 确认背景颜色

  isDisplayBtn?: Boolean = true                  // 是否显示按钮

  popupAnimation:TransitionEffect = undefined       // 弹窗动画
}
