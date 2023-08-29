import { ImageBrowserDialog } from '@ohos/dialogs';

@Entry
@Component
struct Index {
  @State imageList: Resource[] = [$r('app.media.card'), $r('app.media.sanmartino'), $r('app.media.swissroad')];
  @State index: number = 0
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: ImageBrowserDialog({
      imageList: this.imageList,
      index: this.index
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default,
    customStyle: true
  })

  build() {
    Grid() {
      ForEach(this.imageList, (image: Resource, index: number) => {
        GridItem() {
          Image(image)
            .width(150)
            .height(150)
            .onClick(() => {
              this.index = index
              this.dialogController.open()
            })
        }
        .width(150)
        .height(150)
      })
    }
    .rowsTemplate('1fr 1fr')
    .columnsTemplate('1fr 1fr')
    .width('100%')
    .height(350)
  }
}