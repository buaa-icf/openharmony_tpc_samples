
import { listSelectModel } from '../model/listSelectModel'
class obj  {
  name: string
  id: number
  isSelect: boolean
}
@CustomDialog
export struct ListSelectDialog {
  controller: CustomDialogController
  @State model: listSelectModel = new listSelectModel()
  /**
   * 列表数据
   *
   */
  arrList: obj[] = []
  /**
   * 选中数据
   *
   */
  @State changeData:object[]=[]
  /**
   * 弹窗关闭
   *
   */
  cancel: () => void
  /**
   * 弹窗确认
   * @param data
   * @return
   */
  confirm: (data) => void
  scroller: Scroller = new Scroller()

  aboutToAppear(){
    if(this.arrList) {
      this.arrList.forEach(item => {
        if(item.isSelect ){
          this.changeData.push(item)
        }
      })
    }
  }

  build() {
    Column(){
      Text(this.model.title)
        .fontSize(this.model.titleFontSize)
        .margin(this.model.titleMargin)
        .width(this.model.titleWight)
        .height(this.model.titleHeight)
        .fontColor(this.model.titleFontColor)
        .border(this.model.titleBorder)
        .textAlign(this.model.titleTextAlign)
      List({ initialIndex:0 }){
        ForEach(this.arrList,(item,index) => {
          ListItem() {
            Flex({justifyContent: FlexAlign.SpaceBetween,alignItems:ItemAlign.Center}){
              Text(item.name)
                .width('100%')
                .fontColor(this.model.listTextFontColor)
                .textAlign(this.model.selectMode == 'normal' ? this.model.listTextAlign : this.model.listSelectTextAlign)
                .fontSize(this.model.listTextFontSize)
              if(this.model.selectMode == 'radio') {
                Radio({ value: item.name, group: 'radioGroup' }).checked(item.isSelect)
                  .height(this.model.selectBoxSize)
                  .width(this.model.selectBoxSize)
                  .onChange((isChecked: boolean) => {
                    this.changeData = [item]
                    this.controller.close()
                    this.confirm(this.changeData)
                  })
              }
              if(this.model.selectMode == 'checkbox'){
                Checkbox({ name: item.name, group: 'checkboxGroup'})
                  .select(item.isSelect)
                  .selectedColor(this.model.boxSelectedColor)
                  .width(this.model.selectBoxSize)
                  .height(this.model.selectBoxSize)
                  .onChange((value: boolean) => {
                    if(value) {
                      item.isSelect = true
                      this.changeData.push(item)
                    }else{
                      item.isSelect = false
                      this.changeData.push(item)
                    }
                  })
              }

            }

          }
          .height(this.model.listItemHeight)
          .padding(this.model.listItemPadding)
          .border(this.model.listItemBorder)
        })
      }
      .height(this.model.listHeight)
      .listDirection(this.model.listDirection) // 排列方向
      .scrollBar(this.model.listScrollBar)
      .edgeEffect(this.model.listEdgeEffect) // 滑动到边缘无效果
      .padding(this.model.listPadding)
      if(this.model.isDisplayBtn) {
        Column(){
          //alignItems: ItemAlign.Auto
          Flex({direction: FlexDirection.Row}) {
            Button(this.model.cancelBtnTitle,{ type: this.model.btnType })
              .fontColor(this.model.cancelBtnFontColor)
              .fontSize(this.model.btnFontSize)
              .backgroundColor(this.model.cancelBtnBgColor)
              // .width(this.model.btnWidth)
              .width(this.model.btnWidth)
              .height(this.model.btnHeight)
              .border(this.model.btnBorder)
              .onClick(() =>{
                this.controller.close()
                this.cancel()
              })
              .borderRadius(this.model.cancelBtnBorderRadius)
            Button(this.model.confirmBtnTitle,{ type: this.model.btnType })
              .fontColor(this.model.contentFontColor)
              .fontSize(this.model.btnFontSize)
              .backgroundColor(this.model.confirmBtnBgColor)
              .width(this.model.btnWidth)
              .height(this.model.btnHeight)
              .onClick(() =>{
                this.controller.close()
                this.confirm(this.changeData)
              })
              .borderRadius(this.model.confirmBtnBorderRadius)
          }
        }.width(this.model.btnContentWidth)
        .margin(this.model.btnContentMargin)
        .border(this.model.btnContentBorder)
      }
    }
    .width(this.model.dialogWidth)
    .backgroundColor(this.model.dialogBgColor)
    .borderRadius(this.model.dialogBorderRadius)
  }
}