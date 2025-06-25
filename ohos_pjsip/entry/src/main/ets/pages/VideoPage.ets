import { emitter } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { CustomXComponentController } from './CustomXComponentController';

@Entry
@Component
struct VideoPage {
  @State message: string = 'Hello World';
  xComponentController: XComponentController = new CustomXComponentController()

  build() {
    RelativeContainer() {
      Column() {
        XComponent({
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        }).width("900px").height("880px")
        Button("接通").width(240).margin({ top: 20 }).onClick(() => {
          emitter.emit("acceptCall")
        })
        Button("挂断").width(240).margin({ top: 20 }).onClick(() => {
          emitter.emit("handUpCall");
          // router.back();
        })
      }
      .width('100%').margin({ top: 50 })
    }
    .height('100%')
    .width('100%')
  }

  aboutToAppear(): void {
    emitter.on("closeVideo", (e) => {
      if (Number.parseInt(this.getUIContext().getRouter().getLength())>1) {
        let status = this.getUIContext().getRouter().getStateByUrl("pages/Index");
        if (status.length >= 1 && status[0].index !== 0 && status[0].name === "Index") {
          this.getUIContext().getRouter().back();
        }
      }
    })
  }

  aboutToDisappear(): void {
  }
}