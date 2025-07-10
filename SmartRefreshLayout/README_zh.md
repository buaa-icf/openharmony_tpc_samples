# smartrefreshlayout

## 简介
> smartrefreshlayout以打造一个强大，稳定，成熟的下拉刷新框架为目标，并集成各种的炫酷、多样、实用、美观的Header。 集成了各种炫酷的 Header。
> smartrefreshlayout可包含的信息有：BezierRadar样式、BezierCircle样式、FlyRefresh样式、Classics样式，Phoenix样式，Taurus样式，Taurus样式，HitBlock样式，WaveSwipe等众多样式。

#### 效果展示：
![gif](preview.gif)

## 下载安装

```shell
ohpm install @ohos/smartrefreshlayout
```
OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

### 生成smartrefreshlayout头部刷新
```
import {SmartRefresh} from "@ohos/smartrefreshlayout"
import {Material} from "@ohos/smartrefreshlayout"

  @Local model: SmartRefresh.Model = new SmartRefresh.Model()
  this.model.setBackgroundColor()
  this.model.setFixedContent()
  
  @Builder testHeader() {
    Material({ model: this.model!!})
  }
  
  @Builder testMain() {
    Column() {
      ForEach(this.arr, (item:string) => {
        this.card(item)
      }, item => item)
    }.width("100%").padding("20lpx")
  }
  
  build() {
    Column() {
      SmartRefresh({ model: this.model!!, header:() => {this.testHeader()}, main:() => {this.testMain()} })
    }.backgroundColor("#dddddd")
  }

```

## 接口说明
初始化

`@Local model: SmartRefresh.Model = new SmartRefresh.Model()`

方法列表

1. 设置背景阴影颜色
   `model.setBackgroundShadowColor(color: Color): void`

   • 输入: color - 颜色值

   • 输出: 无

2. 设置背景颜色
   `model.setBackgroundColor(color: Color): void`

   • 输入: color - 颜色值

   • 输出: 无

3. 设置头部默认高度
   `model.setInitHeaderHeight(height: number): void`

   • 输入: height - 高度值

   • 输出: 无

4. 设置头部是否固定
   `model.setFixedContent(fixedContent: boolean): void`

   • 输入: fixedContent - 是否固定(true/false)

   • 输出: 无

5. 设置头部刷新位置
   `model.setRefreshPosition(position: RefreshPositionEnum): void`

   • 输入: position - 位置值  TOP = 0, BOTTOM = 1, TOPANDBOTTOM = 2

   • 输出: 无

6. 设置刷新时间是否显示
   `model.setTimeShowState(isShow: boolean): void`

   • 输入: isShow - 是否显示(true/false)

   • 输出: 无

## 约束与限制
DevEco Studio: NEXT Developer Beta3-5.0.3.530, SDK: API12 (5.0.0.35)

## 目录结构
````

|---- SmartRefreshLayout
|     |---- entry  # 示例代码文件夹
|     |---- smartRefreshLayout #库文件夹
|         |----src
|            |----main
|               |----ets
|                  |----components
|                     |----topRefresh #刷新样式库
|                        |----BattleCity.ets           #BattleCity刷新样式
|                        |----BattleCityGameBody.ets   #BattleCity实体类
|                        |----BattleCityGameCover.ets  #BattleCity刷新样式
|                        |----BezierCircleRefresh.ets  #BezierCircle刷新|样式
|                        |----BezierRadarRefresh.ets   #BezierRadar刷新样式
|                        |----ClassicsRefresh.ets      #Classics刷新样式
|                        |----Delivery.ets             #Delivery刷新样式
|                        |----DropBox.ets              #DropBox刷新样式
|                        |----FlyRefreshHeader.ets     #FlyRefresh刷新样式
|                        |----HitBlock.ets             #HitBlock刷新样式
|                        |----HitBlockGameBody.ets     #HitBlock实体类
|                        |----HitBlockGameCover.ets    #HitBlock互动
|                        |----MaterialRefresh.ets      #Material刷新样式
|                        |----Phoenix.ets              #Phoenix刷新样式
|                        |----SmartRefresh.ets         #嵌入刷新样式
|                        |----SmartRefreshEntry.ets    #SmartRefresh实体类
|                        |----StackSmartRefresh.ets    #StackSmart刷新样式
|                        |----StoreHouseRefresh.ets    #StoreHouse刷新样式
|                        |----Taurus.ets               #Taurus刷新样式
|                        |----WaterSwipeRefresh.ets    #WaterSwipe刷新样式
|                        |----WaveSwipeRefresh.ets     #WaveSwipe样式刷新
|     |---- README.md  # 安装使用方法    
|     |---- README_zh.md  # 安装使用方法                     
````

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望SmartRefreshLayout库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：

```
-keep
./oh_modules/@ohos/smartrefreshlayout
```

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎给发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls)共建 。

## 开源协议
本项目基于 [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/SmartRefreshLayout/LICENSE) ，请自由地享受和参与开源。