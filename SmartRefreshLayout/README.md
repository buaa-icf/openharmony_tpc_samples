# smartrefreshlayout

## Overview

SmartRefreshLayout is a library that integrates various cool, diversified, practical, and beautiful headers. It aims to build a powerful, stable, and mature pull-down refresh framework.  

SmartRefreshLayout contains the following information: BezierRadar, BezierCircle, FlyRefresh, Classics, Phoenix, Taurus, Taurus, HitBlock, and WaveSwipe.

#### Display Effects
![smartrefreshlayout](smartrefreshlayout.gif)

## How to Install

```shell
ohpm install @ohos/smartrefreshlayout
```
For details, see [Installing an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Generate a **smartrefreshlayout** instance.
```
import {SmartRefresh} from "@ohos/smartrefreshlayout"
import {Material} from "@ohos/smartrefreshlayout"

  @State model: SmartRefresh.Model = new SmartRefresh.Model()
  this.model.setBackgroundColor()
  this.model.setFixedContent()
  
  @Builder testHeader() {
    Material({ model: this.model})
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
      SmartRefresh({ model: this.model, header:() => {this.testHeader()}, main:() => {this.testMain()} })
    }.backgroundColor("#dddddd")
  }

```

## Available APIs
Initialization

`@State model: SmartRefresh.Model = new SmartRefresh.Model()`

Method List

1. Background color
   `model.setBackgroundShadowColor(color: Color): void`

   • Input: color - Color value

   • Output: None

2. Font color
   `model.setBackgroundColor(color: Color): void`

   • Input: color - Color value

   • Output: None

3. Default header height
   `model.setInitHeaderHeight(height: number): void`

   • Input: height – Height value

   • output: None
   
4. Whether the header is fixed
   `model.setFixedContent(fixedContent: boolean): void`

   • Input: fixedContent – Whether to fix the header (true/false)

   • output: None

5. Header refresh position
   `model.setRefreshPosition(position: RefreshPositionEnum): void`

   • Input: position – Position enum: TOP = 0, BOTTOM = 1, TOPANDBOTTOM = 2

   • output: None

6. Whether to display the refresh time.
   `model.setTimeShowState(isShow: boolean): void`

   • Input: isShow – Whether to show the refresh time (true/false)

   • output: None

## Compatibility
DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure
````

|---- SmartRefreshLayout
|     |---- entry  # Sample code
|     |---- smartRefreshLayout # Library folder
|         |----src
|            |----main
|               |----ets
|                  |----components
|                     |----topRefresh # Style library
|                        |----BattleCity.ets           # BattleCity refresh style
|                        |----BattleCityGameBody.ets   # BattleCity entity class
|                        |----BattleCityGameCover.ets  # BattleCity refresh style
|                        |----BezierCircleRefresh.ets  # BezierCircle refresh style
|                        |----BezierRadarRefresh.ets   # BezierRadar refresh style
|                        |----ClassicsRefresh.ets      # Classics refresh style
|                        |----Delivery.ets             # Delivery refresh style
|                        |----DropBox.ets              #DropBox refresh style
|                        |----FlyRefreshHeader.ets     # FlyRefresh refresh style
|                        |----HitBlock.ets             # HitBlock refresh style
|                        |----HitBlockGameBody.ets     # HitBlock entity class
|                        |----HitBlockGameCover.ets    # HitBlock interaction
|                        |----MaterialRefresh.ets      # Material refresh style
|                        |----Phoenix.ets              # Phoenix refresh style
|                        |----SmartRefresh.ets         # Embedded refresh style
|                        |----SmartRefreshEntry.ets    # SmartRefresh entity class
|                        |----StackSmartRefresh.ets    # StackSmart refresh style
|                        |----StoreHouseRefresh.ets    # StoreHouse refresh style
|                        |----Taurus.ets               # Taurus refresh style
|                        |----WaterSwipeRefresh.ets    # WaterSwipe refresh style
|                        |----WaveSwipeRefresh.ets     # WaveSwipe refresh style
|     |---- README.md  # Readme      
|     |---- README_zh.md  # Readme                
````

start build

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the SmartRefreshLayout library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：

```
-keep
./oh_modules/@ohos/smartrefreshlayout
```

## How to Contribute
If you find any problem when using SmartRefreshLayout, you can submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License
This project is licensed under [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/SmartRefreshLayout/LICENSE).
