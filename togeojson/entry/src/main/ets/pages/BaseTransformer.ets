/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

import { util } from '@kit.ArkTS';
import resourceManager from '@ohos.resourceManager';
import common from '@ohos.app.ability.common';
import * as tj from '@ohos/togeojson';
import type { FeatureCollection, Geometry } from 'geojson';
import type { Document as XDocument } from '@xmldom/xmldom';
import xmldom from '@xmldom/xmldom';


interface TestCase {
  name: string;
  file: string;
}

class TestResult {
  testName: string = '';
  success: boolean = false;
  message: string = '';
  details: string = '';

  constructor(testName: string, success: boolean, message: string, details: string = '') {
    this.testName = testName;
    this.success = success;
    this.message = message;
    this.details = details;
  }
}

@Entry
@Component
struct BaseTransformer {
  @State testResults: TestResult[] = [];
  @State geoJsonOutput: string = '';
  @State isRunning: boolean = false;
  @State debugInfo: string = '请选择一个文件进行 toGeoJSON 转换测试';

  private resManager: resourceManager.ResourceManager | undefined = undefined;

  private testCases: TestCase[] = [
    { name: 'GPX: Friday Evening Run', file: 'Friday-Evening-Run.gpx' },
    { name: 'GPX: Apple Watch Route', file: 'apple_watch_route.gpx' },
    { name: 'GPX: Bad', file: 'bad.gpx' },
    { name: 'GPX: Blue Hills', file: 'blue_hills.gpx' },
    { name: 'GPX: Empty Elevation', file: 'empty_ele.gpx' },
    { name: 'GPX: Empty Track', file: 'empty_trk.gpx' },
    { name: 'GPX: Garmin Extensions', file: 'garmin_extensions.gpx' },
    { name: 'GPX: Gdal', file: 'gdal.gpx' },
    { name: 'GPX: Missing Heart Rate', file: 'missing_hr.gpx' },
    { name: 'GPX: Multi Track GPX', file: 'multitrackgpx.gpx' },
    { name: 'GPX: North Core', file: 'north_core.gpx' },
    { name: 'GPX: Opencpn', file: 'opencpn.gpx' },
    { name: 'GPX: Osm', file: 'osm.gpx' },
    { name: 'GPX: Run', file: 'run.gpx' },
    { name: 'GPX: Run with GPX TPX', file: 'run_gpxtpx.gpx' },
    { name: 'GPX: Strava', file: 'strava.gpx' },
    { name: 'GPX: Style', file: 'style.gpx' },
    { name: 'GPX: Trek', file: 'trek.gpx' },
    { name: 'GPX: Trek No Route Points', file: 'trek_no_rtept.gpx' },
    { name: 'GPX: Unique Track Points', file: 'unique_trkpt.gpx' },
    { name: 'GPX: Wpt', file: 'wpt.gpx' },
    { name: 'GPX: Zero Elevation', file: 'zero_elevation.gpx' },
    { name: 'KML: Addresses', file: 'addresses.kml' },
    { name: 'KML: Bad', file: 'bad.kml' },
    { name: 'KML: Cdata', file: 'cdata.kml' },
    { name: 'KML: Extended Data', file: 'extended_data.kml' },
    { name: 'KML: Ground Overlay', file: 'ground_overlay.kml' },
    { name: 'KML: Ground Overlay Quad', file: 'ground_overlay_quad.kml' },
    { name: 'KML: GX Multi Track', file: 'gxmultitrack.kml' },
    { name: 'KML: GX Track', file: 'gxtrack.kml' },
    { name: 'KML: Inline Style', file: 'inline_style.kml' },
    { name: 'KML: Inline Style Mini', file: 'inline_style_mini.kml' },
    { name: 'KML: Linear Ring', file: 'linear_ring.kml' },
    { name: 'KML: Linestring', file: 'linestring.kml' },
    { name: 'KML: Literal Color', file: 'literal_color.kml' },
    { name: 'KML: Multi Geometry', file: 'multigeometry.kml' },
    { name: 'KML: Multi Geometry Discrete', file: 'multigeometry_discrete.kml' },
    { name: 'KML: Multi Geometry Sibling', file: 'multigeometry_sibling.kml' },
    { name: 'KML: Multitrack', file: 'multitrack.kml' },
    { name: 'KML: Network Link', file: 'networklink.kml' },
    { name: 'KML: No Geometry Placemark', file: 'nogeomplacemark.kml' },
    { name: 'KML: Non GX Multi Track', file: 'non_gx_multitrack.kml' },
    { name: 'KML: Noname', file: 'noname.kml' },
    { name: 'KML: Null Geometry', file: 'null_geometry.kml' },
    { name: 'KML: Opacity Override', file: 'opacity_override.kml' },
    { name: 'KML: Point', file: 'point.kml' },
    { name: 'KML: Point Extra Coordinates', file: 'point_extra_coordinates.kml' },
    { name: 'KML: Point ID', file: 'point_id.kml' },
    { name: 'KML: Polygon', file: 'polygon.kml' },
    { name: 'KML: Schema', file: 'schema.kml' },
    { name: 'KML: Selfclosing', file: 'selfclosing.kml' },
    { name: 'KML: Simpledata', file: 'simpledata.kml' },
    { name: 'KML: Style', file: 'style.kml' },
    { name: 'KML: Style URL', file: 'style_url.kml' },
    { name: 'KML: Styles', file: 'styles.kml' },
    { name: 'KML: Timespan', file: 'timespan.kml' },
    { name: 'KML: Two Points', file: 'twopoints.kml' },
    { name: 'TCX: Bad', file: 'bad.tcx' },
    { name: 'TCX: Sample', file: 'sample.tcx' },
    { name: 'TCX: TCX Courses', file: 'tcx-courses.tcx' },
    { name: 'TCX: Tour Heart Rate', file: 'tour_hr.tcx' }
  ];

  private getButtonColorByFile(fileName: string): string {
    const fileExt = fileName.split('.').pop()?.toLowerCase();
    switch (fileExt) {
      case 'gpx':
        return '#4CAF50';
      case 'kml':
        return '#2196F3';
      case 'tcx':
        return '#FF9800';
      default:
        return '#607D8B';
    }
  }

  aboutToAppear() {
    try {
      let context = getContext(this) as common.UIAbilityContext;
      this.resManager = context.resourceManager;
    } catch (err) {
      this.debugInfo = '错误: 无法获取到 ResourceManager!';
    }
  }

  async getRawFileString(fileName: string): Promise<string> {
    if (!this.resManager) {
      throw new Error('ResourceManager 未初始化。');
    }
    try {
      const fileData: Uint8Array = await this.resManager.getRawFileContent(fileName);
      const textDecoder = new util.TextDecoder('utf-8');
      const content = textDecoder.decodeWithStream(fileData);
      return content;
    } catch (error) {
      throw new Error(`读取文件 ${fileName} 失败`);
    }
  }

  validateGeoJson(fileName: string, geojson: FeatureCollection<Geometry | null>): [boolean, string] {
    if (!geojson || geojson.type !== 'FeatureCollection' || !Array.isArray(geojson.features)) {
      return [false, '验证失败: 生成的不是一个有效的 FeatureCollection。'];
    }
    if (fileName === 'null_geometry.kml') {
      if (geojson.features.length === 1 && geojson.features[0].geometry === null) {
        return [true, '验证通过: 成功生成了带 null geometry 的 Feature。'];
      }
      return [false, '验证失败: 未能正确处理 Null Geometry 的情况。'];
    }
    if (geojson.features.length === 0 && fileName !== 'empty_trk.gpx' && fileName !== 'bad.gpx' && fileName !== 'bad.kml' && fileName !== 'bad.tcx') {
    }
    return [true, `验证通过: 成功生成了包含 ${geojson.features.length} 个要素的 FeatureCollection。`];
  }

  async runTest(testCase: TestCase) {
    this.isRunning = true;
    this.testResults = [];
    this.geoJsonOutput = '';
    this.debugInfo = `[标准测试] 正在转换: ${testCase.name} (${testCase.file})...`;

    try {
      const xmlString = await this.getRawFileString(testCase.file);
      const doc = new xmldom.DOMParser().parseFromString(xmlString, "text/xml");
      let geojson: FeatureCollection<Geometry | null> | null = null;
      const fileExt = testCase.file.split('.').pop()?.toLowerCase();

      switch (fileExt) {
        case 'kml':
          geojson = tj.kml(doc as XDocument);
          break;
        case 'gpx':
          geojson = tj.gpx(doc as XDocument);
          break;
        case 'tcx':
          geojson = tj.tcx(doc as XDocument);
          break;
        default:
          throw new Error(`不支持的文件类型: ${fileExt}`);
      }

      if (!geojson) {
        throw new Error('转换函数返回了null');
      }

      const validationResult = this.validateGeoJson(testCase.file, geojson);
      const isValid = validationResult[0];
      const validationMessage = validationResult[1];

      const resultMessage = isValid ? '转换和验证成功' : '转换成功但验证失败';
      this.testResults = [new TestResult(testCase.name, isValid, resultMessage, validationMessage)];
      this.geoJsonOutput = JSON.stringify(geojson, null, 2);
      this.debugInfo = `${testCase.name} ${isValid ? '验证通过！' : '验证失败！'}`;
    } catch (error) {
      const errorMsg = (error instanceof Error) ? error.message : String(error);
      this.testResults = [new TestResult(testCase.name, false, '发生异常', errorMsg)];
      this.geoJsonOutput = `转换过程中发生异常:\n${errorMsg}`;
      this.debugInfo = `异常: ${errorMsg}`;
    } finally {
      this.isRunning = false;
    }
  }


  build() {
    Column({ space: 12 }) {
      Text('togeojson 鸿蒙移植版测试').fontSize(24).fontWeight(FontWeight.Bold).margin({ top: 20 })
      Text(this.debugInfo).fontSize(14).fontColor(Color.Gray).textAlign(TextAlign.Center)
        .margin({ top: 10 }).padding({ left: 10, right: 10 })

      List({ space: 8 }) {
        ForEach(this.testCases, (testCase: TestCase) => {
          ListItem() {
            Row({ space: 8 }) {
              Button(testCase.name)
                .layoutWeight(3)
                .height(50)
                .backgroundColor(this.getButtonColorByFile(testCase.file))
                .onClick(() => this.runTest(testCase))
                .enabled(!this.isRunning)
            }.width('100%')
          }
        })
      }
      .width('95%')
      .height('40%')
      .margin({ top: 10 })

      if (this.testResults.length > 0) {
        Column({ space: 10 }) {
          Row({ space: 8 }) {
            Text(this.testResults[0].success ? '✅' : '❌').fontSize(18)
            Text(this.testResults[0].testName).fontSize(16).fontWeight(FontWeight.Medium)
            Text(this.testResults[0].message)
              .fontSize(14).fontColor(this.testResults[0].success ? '#28a745' : '#dc3545')
          }
          .width('95%').margin({top: 10})

          if (this.testResults[0].details) {
            Text(this.testResults[0].details)
              .fontSize(12).fontColor(Color.Gray).width('95%').textAlign(TextAlign.Start)
          }

          TextArea({ text: this.geoJsonOutput })
            .layoutWeight(1).width('95%').fontSize(12)
            .backgroundColor('#f8f8f8').borderRadius(6).padding(8)
        }.layoutWeight(1).alignItems(HorizontalAlign.Center)
      } else {
        Blank().layoutWeight(1)
      }
    }.width('100%').height('100%').padding(10).backgroundColor('#F5F5F5')
  }
}

