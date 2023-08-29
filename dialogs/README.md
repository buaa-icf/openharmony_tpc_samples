# xpopup

#### 介绍
使用ets实现xpopup功能
本项目时OpenHarmony系统的一款dialog库，基于CustomDialog进行封装能力如下：
1.支持内容提示弹窗
2.支持input弹窗
3.支持列表list弹窗
4.支持自定义动画弹窗
5.支持loading动画弹窗
6.支持各种复杂交互弹窗

#### 软件架构
软件架构说明

|---- Xpopup 
    |----Dialog  #组件文件夹
        |----src #组件入口文件夹
            |----main
                |----ets
                    |----components #组件库
        |----resource
        |----index   #组件向外暴露组件
    |----entry  #页面入口文件夹
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


#### 安装教程
1.  xxxx
2.  xxxx
3.  xxxx

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
    
3.  xxxx

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


#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request


#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
