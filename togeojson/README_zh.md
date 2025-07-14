# togeojson

togeojson支持将 GPX、KML、TCX 格式的地理数据文件转换为 GeoJSON 格式。
本项目将原本运行在 Node.js 和浏览器环境的 togeojson 库完整移植到鸿蒙操作系统中，使鸿蒙应用能够直接处理各种地理数据格式的转换。项目包含了完整的库文件、测试界面和单元测试。

## 功能特性

- **GPX 转换**: 支持 GPS 轨迹文件转换为 GeoJSON
- **KML 转换**: 支持 Google Earth KML 文件转换为 GeoJSON  
- **TCX 转换**: 支持 Garmin Training Center TCX 文件转换为 GeoJSON
- **完整测试**: 包含单元测试覆盖各种场景

## 效果展示
![avatar](screenshot/解析结果demo展示.png)

## 下载安装
```shell
ohpm install @ohos/togeojson 
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## X86模拟器配置

[使用模拟器运行应用/服务](https://developer.huawei.com/consumer/cn/deveco-developer-suite/enabling/kit?currentPage=1&pageSize=100)

## 使用示例

### 在鸿蒙应用中使用
- **使用流程**
- 引入模块，读取文件，解析 XML，调用转换接口

1. 导入依赖库
```typescript
import * as tj from '@ohos/togeojson';
import type { F } from '@ohos/togeojson';
import { DOMParser } from '@xmldom/xmldom';
```
2.读取文件
```typescript
const xmlContent = await this.resourceManager.getRawFileContent('track.gpx');
const xmlString = new util.TextDecoder('utf-8').decodeWithStream(xmlContent);
```
3.解析XML
```typescript
const doc = new DOMParser().parseFromString(xmlString, "text/xml");
```

4.调用转换接口
```typescript
const result = tj.gpx(doc);
let generator: Generator<F, void, void> | null = null;//用于接受生成器函数返回值
generator = tj.tcxGen(doc as XDocument);
const features: F[] = Array.from(generator);//从生成器结果一次性取出存放在feature中
```

5.日志输出转换结果
```typescript
console.log(JSON.stringify(result, null, 2));//普通转换函数结果
console.log(JSON.stringify(features, null, 2));//普通转换函数结果
```


## 输出格式

所有转换函数最终都可以返回如下类似标准的 GeoJSON FeatureCollection 格式：

```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "name": "轨迹名称",
        "time": "2023-01-01T12:00:00Z",
        "_gpxType": "trk",
        "coordinateProperties": {
          "times": ["2023-01-01T12:00:00Z", "2023-01-01T12:01:00Z"],
          "heartRates": [120, 125]
        }
      },
      "geometry": {
        "type": "LineString",
        "coordinates": [[116.404, 39.915, 50], [116.405, 39.916, 52]]
      }
    }
  ]
}
```


## 安装依赖

项目依赖以下库：
- @xmldom/xmldom: 用于解析 XML 文档
- @types/geojson: 为 GeoJSON 数据结构提供严格的类型声明

## API 接口与方法说明

### GPX 相关

- **gpx(doc: Document): FeatureCollection**
  - 将 GPX（GPS eXchange Format）XML 文档整体转换为标准 GeoJSON FeatureCollection。
  - 参数：`doc` 为 XML DOM 对象（通常由 `@xmldom/xmldom` 的 `DOMParser` 解析得到）。
  - 返回：GeoJSON FeatureCollection，包含轨迹、路线、航点等要素。

- **gpxGen(doc: Document): Generator<Feature>**
  - 以生成器方式逐个输出 GPX 文件中的每个地理要素（Feature），适合处理大文件或流式处理。
  - 参数：同上。
  - 返回：Feature 生成器，可用于遍历每个地理要素。

### KML 相关

- **kml(doc: Document, options?: KMLOptions): FeatureCollection**
  - 将 KML（Keyhole Markup Language）XML 文档整体转换为标准 GeoJSON FeatureCollection。
  - 参数：
    - `doc`：XML DOM 对象。
    - `options`（可选）：`{ skipNullGeometry?: boolean }`，为 true 时跳过没有几何体的要素。
  - 返回：GeoJSON FeatureCollection，包含点、线、面、Overlay 等要素。

- **kmlGen(doc: Document, options?: KMLOptions): Generator<Feature>**
  - 以生成器方式逐个输出 KML 文件中的每个地理要素（Feature）。
  - 参数：同上。
  - 返回：Feature 生成器。

- **kmlWithFolders(doc: Document, options?: KMLOptions): Root**
  - 保留 KML 文件夹（Folder）层级结构，返回树状结构（Root），children 为 Folder 或 Feature。
  - 参数：同上。
  - 返回：Root 对象，包含文件夹和要素的树。


### TCX 相关

- **tcx(doc: Document): FeatureCollection**
  - 将 TCX（Garmin Training Center XML）文档整体转换为标准 GeoJSON FeatureCollection。
  - 参数：`doc` 为 XML DOM 对象。
  - 返回：GeoJSON FeatureCollection，包含运动轨迹、课程等要素。

- **tcxGen(doc: Document): Generator<Feature>**
  - 以生成器方式逐个输出 TCX 文件中的每个地理要素（Feature）。
  - 参数：同上。
  - 返回：Feature 生成器。

### 其他工具

- **F**
  - GeoJSON Feature 类型别名，便于类型推断和类型声明。

---

#### 返回值类型说明

- **FeatureCollection**：GeoJSON 标准的要素集合，`{ type: "FeatureCollection", features: Feature[] }`
- **Feature**：GeoJSON 单个要素，`{ type: "Feature", geometry, properties }`
- **Root/Folder**：KML 层级结构的树状对象

## 源码下载
1. 本项目可直接通过git命令克隆本地，找到对应的目录，编译运行
  ```
 git clone https://gitcode.com/openharmony-tpc/openharmony_tpc_samples.git
  ```

## 约束与限制
在下述版本验证通过：
- IDE：DevEco Studio 5.1.0 Release(5.1.0.828); SDK: API18 (5.1.0.110)。

## 目录结构

````
togeojson/
├── library/                    # togeojson 核心库
│   └── src/main/ets/            # 主要源码
│       ├── index.ts             # 主入口文件
│       ├── gpx.ts               # GPX 转换功能
│       ├── kml.ts               # KML 转换功能
│       ├── tcx.ts               # TCX 转换功能
│       └── shared.ts            # 共享工具函数
├── entry/                       # 测试应用入口
│   └── src/main/ets/pages/      # 测试界面
│   └── src/ohostest/ets/        # 单元测试
│       ├──index.test.ts         # 原库中的index.test.ts的第一个describe
|       ├──index.test2.ts        # 原库中的index.test.ts的第二个describe
|   
└── README.md                    # 项目说明

````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然也非常欢迎给
发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 共建。

## 开源协议

本项目基于 [BSD LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/togeojson/LICENSE) ，请自由地享受和参与开源。


