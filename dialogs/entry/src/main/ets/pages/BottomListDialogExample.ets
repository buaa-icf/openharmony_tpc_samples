import { BottomListDialog } from '@ohos/dialogs';

@Entry
@Component
struct BottomListDialogExample {
  @State message: string = '显示Bottom类型的List弹窗(带选择效果)'
  @State showDialog: boolean = false;
  @State isOpenDialog: boolean = false;
  @State selectIndex: number = 2;
  @State message1: string = '显示Bottom类型的List弹窗'
  @State showDialog1: boolean = false;
  @State isOpenDialog1: boolean = false;
  @State selectIndex1: number = 2;

  build() {
    Row() {
      Column() {
        Button(this.message)
          .fontSize(25)
          .labelStyle({overflow: TextOverflow.Ellipsis,maxLines:2})
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.showDialog = true;
            this.isOpenDialog = !this.isOpenDialog;
          })
        BottomListDialog({
          openDialog: $isOpenDialog,
          mListData: ['aa','bb','cc','dd','ee','ff'],
          mDialogItemHeight: 40,
          dialogTitle: "标题可以没有",
          dialogTitleSize: 25,
          dialogTitleColor: Color.White,
          mDialogMaskColor: 0x33000000,
          mDialogTitleHeight: 60,
          dialogCancel: "取消",
          dialogCancelSize: 20,
          dialogCancelColor: Color.White,
          mDialogItemTextColor: '#ffffff',
          mDialogBackgroundColor: '#000000',
          mDialogItemDividerBackgroundColor: Color.Gray,
          mDialogItemDividerStrokeWidth: 1,
          mDialogCancelDividerBackgroundColor: Color.Gray,
          mDialogCancelDividerStrokeWidth: 10,
          mDialogSelectIcon: $r('app.media.ic_public_ok'),
          isShowSelect: true,
          mDialogItemSelectIndex: this.selectIndex,
          mDialogItemSelectTextColor: Color.Orange,
          cancel: () => {
            console.log("dialog cancel")
          },
          onItemClick: (data, index) => {
            console.log("dialog onItem data:" + data + ";index:" + index)
            this.selectIndex = index;
          }
        })
          .visibility(this.showDialog ? Visibility.Visible : Visibility.None)
      }
      .width('50%')

      Column() {
        Button(this.message1)
          .labelStyle({overflow: TextOverflow.Ellipsis,maxLines:2})
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.showDialog1 = true;
            this.isOpenDialog1 = !this.isOpenDialog1;
          })
        BottomListDialog({
          openDialog: $isOpenDialog1,
          mListData: ['aa','bb','cc','dd','ee','ff'],
          mDialogItemHeight: 40,
          dialogTitle: "标题可以没有",
          dialogTitleSize: 25,
          dialogTitleColor: Color.White,
          mDialogMaskColor: 0x33000000,
          mDialogTitleHeight: 60,
          dialogCancel: "取消",
          dialogCancelSize: 20,
          dialogCancelColor: Color.White,
          mDialogItemTextColor: '#ffffff',
          mDialogBackgroundColor: '#000000',
          mDialogItemDividerBackgroundColor: Color.Gray,
          mDialogItemDividerStrokeWidth: 1,
          mDialogCancelDividerBackgroundColor: Color.Gray,
          mDialogCancelDividerStrokeWidth: 10,
          mDialogSelectIcon: $r('app.media.ic_public_ok'),
          isShowSelect: false,
          mDialogItemSelectIndex: this.selectIndex1,
          mDialogItemSelectTextColor: Color.Orange,
          cancel: () => {
            console.log("dialog cancel")
          },
          onItemClick: (data, index) => {
            console.log("dialog onItem data:" + data + ";index:" + index)
            this.selectIndex1 = index;
          }
        })
          .visibility(this.showDialog1 ? Visibility.Visible : Visibility.None)
      }
      .width('50%')
    }
    .height('100%')
  }
}