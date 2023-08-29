import { BaseCenterMode } from './BaseCenterModel'

export class listSelectModel extends BaseCenterMode {

  /* ---------------------------弹窗列表设置--------------------------- */

  selectMode:string    // 列表选中模式  normal-正常,radio-单选,checkbox-多选

  listPadding: Padding | number   // 列表内边距

  listTextWidth?: number|string = '100%'    // 列表文本宽度

  listTextFontSize?: number = 16   // 列表字体大小

  listTextFontColor?: Color | string  = '#000000'    // 列表字体大小

  listTextAlign?: TextAlign = TextAlign.Center  // 列表文本对齐方式

  listSelectTextAlign?: TextAlign = TextAlign.Start  // 列表选择框文本对齐方式

  selectBoxSize?: number = 20    // 列表选择框尺寸

  listItemHeight?: number|string = 60    // 列表item高度

  listItemPadding?: Padding | number    // 列表item内边距

  listItemBorder?:{                                    // 列表item边框
    width?: Length | EdgeWidths,
    color?:  ResourceColor | EdgeColors,
    radius?:  Length | BorderRadiuses,
    style?: BorderStyle | EdgeStyles
  }

  listHeight?: string|number = 200    // 列表高度

  listDirection?: Axis  = Axis.Vertical          // 列表排列方向

  listScrollBar?: BarState = BarState.Auto       // 列表滑动

  listEdgeEffect?: EdgeEffect = EdgeEffect.Spring // 列表滑动边缘效果，默认无效果

  boxSelectedColor?: Color|string = '#007DFF'     // 选中后选择框颜色
}
