/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import gcoord from 'gcoord'

@Entry
@Component
struct GcoordPage {
  private point: number[] = [116.403988,39.914266];
  @State BD092GCJ02: number[] = [];
  @State GCJ022BD09: number[] = [];
  @State GCJ022WGS84: number[] = [];
  @State WGS842GCJ02: number[] = [];
  @State BD092WGS84: number[] = [];
  @State WGS842BD09: number[] = [];

  build() {
    Column() {

      Column() {
        Text('原始坐标: ' + this.point)
        Button('全部转换')
          .fontSize(18)
          .onClick(() => {
            this.BD092GCJ02 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.BD09, // 当前坐标系
            gcoord.GCJ02 // 目标坐标系
            );

            this.GCJ022BD09 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.GCJ02, // 当前坐标系
            gcoord.BD09 // 目标坐标系
            );
            this.GCJ022WGS84 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.GCJ02, // 当前坐标系
            gcoord.WGS84 // 目标坐标系
            );
            this.WGS842GCJ02 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.WGS84, // 当前坐标系
            gcoord.GCJ02 // 目标坐标系
            );
            this.BD092WGS84 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.BD09, // 当前坐标系
            gcoord.WGS84 // 目标坐标系
            );
            this.WGS842BD09 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.WGS84, // 当前坐标系
            gcoord.BD09 // 目标坐标系
            );
          })
      }

      Divider().strokeWidth(1).color('#F1F3F5').margin({ top: 8, bottom: 8 })

      Column() {
        Button('BD09 坐标转 GCJ02 坐标')
          .fontSize(18)
          .onClick(() => {
            this.BD092GCJ02 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.BD09, // 当前坐标系
            gcoord.GCJ02 // 目标坐标系
            );
            console.log('BD09 坐标转 GCJ02 坐标:' + this.BD092GCJ02); // [116.41661560068297, 39.92196580126834]
          })
        Text('' + this.BD092GCJ02)
      }

      Divider().strokeWidth(1).color('#F1F3F5').margin({ top: 8, bottom: 8 })

      Column() {
        Button('GCJ02 坐标转 BD09 坐标')
          .fontSize(18)
          .onClick(() => {
            this.GCJ022BD09 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.GCJ02, // 当前坐标系
            gcoord.BD09 // 目标坐标系
            );
            console.log('GCJ02 坐标转 BD09 坐标:' + this.GCJ022BD09); // [116.41661560068297, 39.92196580126834]
          })
        Text('' + this.GCJ022BD09)
      }

      Divider().strokeWidth(1).color('#F1F3F5').margin({ top: 8, bottom: 8 })

      Column() {
        Button('GCJ02  坐标转 WGS84  坐标')
          .fontSize(18)
          .onClick(() => {
            this.GCJ022WGS84 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.GCJ02, // 当前坐标系
            gcoord.WGS84 // 目标坐标系
            );
            console.log('GCJ02 坐标转 WGS84 坐标:' + this.GCJ022WGS84); // [116.41661560068297, 39.92196580126834]
          })
        Text('' + this.GCJ022WGS84)
      }

      Divider().strokeWidth(1).color('#F1F3F5').margin({ top: 8, bottom: 8 })

      Column() {
        Button('WGS84  坐标转 GCJ02  坐标')
          .fontSize(18)
          .onClick(() => {
            this.WGS842GCJ02 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.WGS84, // 当前坐标系
            gcoord.GCJ02 // 目标坐标系
            );
            console.log('GCJ02 坐标转 WGS84 坐标:' + this.WGS842GCJ02); // [116.41661560068297, 39.92196580126834]
          })
        Text('' + this.WGS842GCJ02)
      }

      Divider().strokeWidth(1).color('#F1F3F5').margin({ top: 8, bottom: 8 })

      Column() {
        Button('BD09  坐标转 WGS84  坐标')
          .fontSize(18)
          .onClick(() => {
            this.BD092WGS84 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.BD09, // 当前坐标系
            gcoord.WGS84 // 目标坐标系
            );
            console.log('GCJ02 坐标转 WGS84 坐标:' + this.BD092WGS84); // [116.41661560068297, 39.92196580126834]
          })
        Text('' + this.BD092WGS84)
      }

      Divider().strokeWidth(1).color('#F1F3F5').margin({ top: 8, bottom: 8 })

      Column() {
        Button('WGS84  坐标转 BD09  坐标')
          .fontSize(18)
          .onClick(() => {
            this.WGS842BD09 = gcoord.transform(
              [116.403988, 39.914266], // 经纬度坐标
            gcoord.WGS84, // 当前坐标系
            gcoord.BD09 // 目标坐标系
            );
            console.log('WGS84 坐标转 BD09 坐标:' + this.WGS842BD09); // [116.41661560068297, 39.92196580126834]
          })
        Text('' + this.WGS842BD09)
      }


    }
    .padding({ top: 18, bottom: 18 })

  }
}