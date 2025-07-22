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
import { Parse } from '@ohos/parser-sdk';

@Entry
@Component
struct GeoPoint {
  @State message: string = '结果：'

  // 模拟创建测试数据
  async createTestData() {
    try {
      // 是否已存在数据
      const query = new Parse.Query("PlaceObject");
      const existingCount = await query.count();
      if (existingCount > 0) {
        this.message = `已有 ${existingCount} 条地点数据，跳过创建`;
        return;
      }

      // 定义测试数据
      const testPlaces: ESObject = [
        { name: "金茂大厦", location: new Parse.GeoPoint(31.2356, 121.5068) },
        { name: "东方明珠", location: new Parse.GeoPoint(31.2429, 121.4963) },
        { name: "上海中心", location: new Parse.GeoPoint(31.2394, 121.5103) },
        { name: "外滩", location: new Parse.GeoPoint(31.2412, 121.4928) },
        { name: "人民广场", location: new Parse.GeoPoint(31.2342, 121.4786) },
        { name: "静安寺", location: new Parse.GeoPoint(31.2293, 121.4542) },
        { name: "陆家嘴", location: new Parse.GeoPoint(31.2397, 121.4998) }
      ];

      // 批量创建
      const objects: ESObject = testPlaces.map((place: ESObject): ESObject => {
        const obj = new Parse.Object("PlaceObject");
        obj.set("name", place.name);
        obj.set("location", place.location);
        return obj;
      });

      await Parse.Object.saveAll(objects);
      this.message = "成功创建7个测试地点数据";
    } catch (e) {
      this.message = `数据操作失败: ${e.message}`;
    }
  }
  build() {
    Scroll() {
      Column({ space: 20 }) {
        Text(this.message).fontSize(16)

        Button('创建测试数据')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(() => this.createTestData())

        Button('解析位置信息')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(() => {
            const point = new Parse.GeoPoint(31.2356, 121.5068);
            let placeObject = new Parse.Object("PlaceObject");
            placeObject.set("location", point);
            this.message = `创建位置对象: ${JSON.stringify(point)}`;
          })

        // 多边形包含测试
        Button('多边形区域查询')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            try {
              const lujiazuiArea = [
                [121.495, 31.238], // 西南
                [121.495, 31.242], // 西北
                [121.505, 31.242], // 东北
                [121.505, 31.238], // 东南
                [121.495, 31.238]  // 闭合
              ];

              const query = new Parse.Query("PlaceObject");
              query.withinPolygon("location", lujiazuiArea);
              const results = await query.find();

              const places: ESObject = results.map((obj: ESObject): ESObject => obj.get("name"));
              this.message = `多边形区域找到 ${results.length} 个地点:\n${places.join("、")}`;
            } catch (e) {
              this.message = `查询失败: ${e.message}`;
            }
          })

        Button('附近500米地点')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            const peopleSquare = new Parse.GeoPoint(31.2342, 121.4786);
            const query = new Parse.Query("PlaceObject");
            query.near("location", peopleSquare);
            query.limit(3); // 最近3个
            const results = await query.find();

            const places = results.map(obj => `${obj.get("name")}(${obj.get("location").latitude.toFixed(4)},${obj.get("location").longitude.toFixed(4)})`);
            this.message = `附近500米地点:\n${places.join("\n")}`;
          })

        Button('公里范围查询')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            const bund = new Parse.GeoPoint(31.2412, 121.4928);
            const query = new Parse.Query("PlaceObject");
            query.withinKilometers("location", bund, 2);
            const results = await query.find();

            this.message = `2公里内有 ${results.length} 个地点:\n${results.map((obj: ESObject): ESObject => obj.get("name")).join("、")}`;
          })

        Button('矩形区域查询')
          .borderRadius(4)
          .type(ButtonType.Normal)
          .width('100%')
          .onClick(async () => {
            const southwest = new Parse.GeoPoint(31.230, 121.490);
            const northeast = new Parse.GeoPoint(31.245, 121.515);
            const query = new Parse.Query("PlaceObject");
            query.withinGeoBox("location", southwest, northeast);
            const results = await query.find();

            this.message = `矩形区域找到 ${results.length} 个地点:\n${results.map((obj: ESObject): ESObject => obj.get("name")).join("、")}`;
          })
      }
      .margin(10)
    }
    .width('100%')
    .height('100%')
  }
}