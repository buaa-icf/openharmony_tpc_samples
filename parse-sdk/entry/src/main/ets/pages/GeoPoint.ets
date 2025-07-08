/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */
import { Parse, Coordinate } from '@ohos/parser-sdk'

@Entry
@Component
struct GeoPoint {

  @State message: string = '结果：'

  aboutToAppear(): void {
    Parse.initialize('wahaha', '123123'); // 使用你的 JavaScript Key
    Parse.serverURL = 'http://192.168.0.2:1337/parse';
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {

        Text(this.message)
          .fontSize(16)

        Button('解析位置信息')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(() => {
            const point = new Parse.GeoPoint({latitude: 40.0, longitude: -30.0});
            let placeObject = new Parse.Object("PlaceObject");
            placeObject.set("location", point);
            this.message = "解析位置信息 "+JSON.stringify(placeObject);
          })

        Button('查询')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            const points = [[0,0], [0,1], [1,1], [1,0]];
            const inside = new Parse.GeoPoint(0.5, 0.5);
            const outside = new Parse.GeoPoint(10, 10);
            const polygon = new Parse.Polygon(points as Coordinate[]);
            // Returns True
            polygon.containsPoint(inside);
            // Returns False
            polygon.containsPoint(outside);
            this.message = '查询结果 '+JSON.stringify(polygon);
          })
      }
      .margin(10)
    }
    .width('100%')
    .height('100%')
  }
}