export type DividerAttribute = {
  strokeWidth: Length;
  color?: ResourceColor;
  startMargin?: Length;
  endMargin?: Length;
}

export class BottomAttributeModel {
  minHeight: Length ='20%'
  maxHeight: Length ='70%'
  barState?: BarState = BarState.Off
  divider?: DividerAttribute
  dialogHeight?: number = 250
  backgroundColor: ResourceColor = Color.White
  hasTitle?: boolean = false
  titleFontSize?: number | string | Resource = 25
  titleFontColor?: ResourceColor = Color.Black
  titleBg?: ResourceColor = Color.White
}