# ohso_dialogs

#### 介绍
使用ets实现通用的弹窗组件封装和拓展
本项目时OpenHarmony系统的一款dialog库，基于CustomDialog进行封装能力如下：
1.支持内容提示弹窗
2.支持input弹窗
3.支持列表list弹窗
4.支持自定义动画弹窗
5.支持loading动画弹窗
6.支持各种复杂交互弹窗

#### 软件架构
软件架构说明
```

|---- Xpopup 
|    |----Dialog  #组件文件夹
        |----src #组件入口文件夹
            |----main
                |----ets
                    |----components #组件库
                        |----confirmDialog #显示confirm弹窗
                        |----InputDialog  #显示带输入框的弹窗
                        |----listSelectDialog  #显示列表弹窗
                        |----loadingDialog  #显示loading弹窗
                        |----bottonDialog 
                            |----BottomListDialog #显示bottom类型的列表弹窗
                            |----BottomScrollDialog #显示bottom类型的自定义弹窗 #复杂交互的bottom弹窗
                        |----popupBottom  #显示气泡类弹窗
                        |----fullScreenDialog  #显示自定义全屏弹窗
                        |----messageDialog  #显示消息类弹窗
                        |----topDialog   #显示顶部打开弹窗
                        |----realtimeInputPopup  #显示联想类弹窗
                        |----sliderdialog   #显示抽屉类弹窗  #大图浏览类弹窗
                        |----positionDialog   #显示自定义动画弹窗
        |----resource
        |----index   #组件向外暴露组件
|    |----entry  #页面入口文件夹
        |----src #组件入口文件夹
            |----main
                |----ets
                    |----components #页面公用组件文件夹
                    |----entryability #组件页面配置
                    |----pages  #页面入口文件夹
                    |----utils #页面公用方法文件夹
                |----resource #项目资源配置
                    |----base
                        |----profile 
                            |----main_pages.json #页面路由配置文件

```

#### 使用说明
1.  提供了多种弹窗和自定义动画弹窗 'SideBarContainerExample','Confirm','InputContent','ListSelect','Loading','PositionContent','FullScreen',
    'RealtimeInput','Message', 'PopupButtonExample','TopContent','BottomScrollDialogExample', 'BottomTextDialogExample',
    'BottomListDialogExample','ImageBrowser','RepeatContent','AnimateInputContent','Attach'

2.  以Confirm为例
   ```typescript
import { ConfirmDialog } from '@ohos/dialogs'
import { BaseCenterMode } from '@ohos/dialogs'  //自定义属性
import { TestType } from '@ohos/hypium'

@Entry
@Component
struct ConfirmExample {
  @State textValue: string = '我是标题'
  @State contentValue: string = '床前明月光，疑是地上霜，举头望明月，低头思故乡。床前明月光，疑是地上霜，举头望明月，低头思故乡。'
  @State inputValue: string = 'click me'
  @State positionDialog: string = 'center'
  @State animitionMove:string = 'center'
  @State model:BaseCenterMode = new BaseCenterMode()

  aboutToAppear(){
    this.model.title = '我是标题',
    this.model.contentValue = '床前明月光，疑是地上霜，举头望明月，低头思故乡。床前明月光，疑是地上霜，举头望明月，低头思故乡。'
    // this.model.contentMargin = 20
    this.model.titleMargin = { top: 30,bottom: 10 }
    this.model.btnWidth = '100%'
    this.model.btnHeight = '100%'
    this.model.confirmBtnFontColor = '#87C5BF'
    this.model.confirmBtnBgColor = '#fff'
    this.model.confirm = this.onAccept
    this.model.btnContentHeight = 60
    this.model.btnContentMargin = { top: 20 }
    this.model.btnContentBorder = {
      width: { top: 1 },
      color:{ top:'#F0F0F0' },
      style:{ top:BorderStyle.Solid },
    }
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: ConfirmDialog({
      slotContent: () => {
        this.componentBuilder()
      },
      model:this.model
    }),
    cancel: this.existApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    gridCount: 4,
    customStyle: true
  })

  // 在自定义组件即将析构销毁时将dialogControlle删除和置空
  aboutToDisappear() {
    delete this.dialogController, // 删除dialogController
    this.dialogController = undefined // 将dialogController置空
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

  existApp() {
    console.info('Click the callback in the blank area')
  }

  //自定义内容
  @Builder componentBuilder() {
    Text('床前明月光，疑是地上霜，举头望明月，低头思故乡。床前明月光，疑是地上霜，举头望明月，低头思故乡。')
      .fontSize(this.model.contentFontSize)
      .margin(20)
      .textAlign(this.model.contentTextAlign)
  }

  build() {
    Column() {
      Button('显示confirm弹窗').onClick(() => {
        this.dialogController.open()
      })
    }
  }
}
```

### 全局属性说明
| 属性名                 | 属性类型             | 属性描述                           |
|---------------------|------------------|--------------------------------|
| onBackClose         | boolean          | 是否允许点击返回键关闭弹窗                  |
| autoClose           | function         | 是否允许操作后关闭弹窗，用于确认，选择按钮场景        |
| popupAnimation      | TransitionEffect | 弹窗动画器，支持自定义能力                  |
| positionDialog      | string           | 弹窗弹出后的位置 Left-Right-Top-Bottom |
| isSupportGesture    | boolean          | 是否支持手势拖拽                       |
| isDeleteOnDisappear | boolean          | 是否在弹框退出时，删除对象，释放资源                       |
| customCallback      | CustomCallback   | 设置弹窗build前和build后的回调                       |



