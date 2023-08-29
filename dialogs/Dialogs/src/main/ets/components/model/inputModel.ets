import { BaseCenterMode } from './BaseCenterModel'
export class inputModel extends BaseCenterMode {
  /* ---------------------------输入框设置--------------------------- */

  inputFontSize?: number = 20                    // 输入框文字尺寸

  inputFontColor?: string = '#000000'            // 输入框文字颜色

  inputBgColor?: string = '#ffffff'              // 输入框背景颜色

  placeholder?: string = '请输入'                 // 输入框提示文字

  placeholderColor?: string = '#000000'          // 输入框placeholder提示文字颜色

  inputBorderRadius?: number = 10                // 输入框borderRadius大小

  inputMargin?: Margin|number                    // 输入框外边距

  inputPadding?: Padding|number                  // 输入框内边距

  inputBorder?:{                                    // 输入框边框设置
    width?: Length | EdgeWidths,
    color?:  ResourceColor | EdgeColors,
    radius?:  Length | BorderRadiuses,
    style?: BorderStyle | EdgeStyles
  }
}