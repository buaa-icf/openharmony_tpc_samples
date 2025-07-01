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
import { describe, it, expect } from '@ohos/hypium';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import xmldom, { Document } from '@xmldom/xmldom';
import * as tj from "@ohos/togeojson";
import util from '@ohos.util';


interface IJsonObject extends Record<string, JsonValue> {}
interface IJsonArray extends Array<JsonValue> {}
type JsonValue = string | number | boolean | null | IJsonObject | IJsonArray;


interface FolderObject {
  type: "folder";
  meta: IJsonObject;
  children: (GeoJSON.Feature | FolderObject)[];
}

interface RootObject {
  type: "root";
  children: (GeoJSON.Feature | FolderObject)[];
}


type ProcessableGeoObject = GeoJSON.GeoJSON | RootObject | FolderObject;

// -----------------------------------------------------------------------------
// --- 辅助函数区域 ---
// -----------------------------------------------------------------------------

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const context = delegator.getAppContext();
const resMgr = context.resourceManager;
const TAG = '[toGeoJSONTest]';

async function getRawFileContent(fileName: string): Promise<string> {
  try {
    const rawFile = await resMgr.getRawFileContent(fileName);
    const decoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    return decoder.decodeWithStream(rawFile, { stream: false });
  } catch (error) {
    if (typeof error === 'object' && error !== null) {
      interface PotentialError {
        code?: number;
        message?: string;
      }
      const potentialError = error as PotentialError;
      if (typeof potentialError.code === 'number' && typeof potentialError.message === 'string') {
        throw new Error(`[ohtest] 读取 rawfile 文件失败 ${fileName}. Code: ${potentialError.code}, Message: ${potentialError.message}`);
      } else if (error instanceof Error) {
        throw new Error(`[ohtest] 读取 rawfile 文件 '${fileName}' 时发生错误: ${error.message}`);
      } else {
        throw new Error(`[ohtest] 读取 rawfile 文件 '${fileName}' 时发生未知对象错误: ${JSON.stringify(error)}`);
      }
    } else {
      throw new Error(`[ohtest] 读取 rawfile 文件 '${fileName}' 时发生未知非对象错误: ${String(error)}`);
    }
  }
}



//统一处理精确度
function roundGeoJsonCoordinates<T extends ProcessableGeoObject>(geojson: T, precision: number = 9): T {
  if (!geojson || typeof geojson !== 'object') {
    return geojson;
  }
  const newGeoJson = JSON.parse(JSON.stringify(geojson)) as T;

  switch (newGeoJson.type) {
    case 'root':
    case 'folder':
      const container = newGeoJson as RootObject | FolderObject;
      if (Array.isArray(container.children)) {
        container.children = container.children.map(child => roundGeoJsonCoordinates(child as GeoJSON.Feature | FolderObject, precision));
      }
      break;

    case 'FeatureCollection':
      const fc = newGeoJson as GeoJSON.FeatureCollection;
      fc.features.forEach((feature) => {
        if (feature.geometry) {
          feature.geometry = roundGeoJsonCoordinates(feature.geometry as GeoJSON.Geometry, precision);
        }
      });
      break;
    case 'Feature':
      const feature = newGeoJson as GeoJSON.Feature;
      if (feature.geometry) {
        feature.geometry = roundGeoJsonCoordinates(feature.geometry as GeoJSON.Geometry, precision);
      }
      break;
    case 'GeometryCollection':
      const gc = newGeoJson as GeoJSON.GeometryCollection;
      gc.geometries = gc.geometries.map(geometry => roundGeoJsonCoordinates(geometry, precision));
      break;
    case 'Point':
      const pt = newGeoJson as GeoJSON.Point;
      pt.coordinates = pt.coordinates.map((n: number) => parseFloat(n.toFixed(precision)));
      break;
    case 'MultiPoint':
    case 'LineString':
      const ls = newGeoJson as GeoJSON.MultiPoint | GeoJSON.LineString;
      ls.coordinates = ls.coordinates.map((p: GeoJSON.Position) => // 使用 GeoJSON.Position
      p.map((n: number) => parseFloat(n.toFixed(precision)))
      );
      break;
    case 'MultiLineString':
    case 'Polygon':
      const poly = newGeoJson as GeoJSON.MultiLineString | GeoJSON.Polygon;
      poly.coordinates = poly.coordinates.map((l: GeoJSON.Position[]) =>
      l.map((p: GeoJSON.Position) => p.map((n: number) => parseFloat(n.toFixed(precision))))
      );
      break;
    case 'MultiPolygon':
      const mpoly = newGeoJson as GeoJSON.MultiPolygon;
      mpoly.coordinates = mpoly.coordinates.map((p: GeoJSON.Position[][]) =>
      p.map((l: GeoJSON.Position[]) => l.map((pos: GeoJSON.Position) => pos.map((n: number) => parseFloat(n.toFixed(precision)))))
      );
      break;
  }
  return newGeoJson;
}


// -----------------------------------------------------------------------------
// --- 测试套件主函数
// -----------------------------------------------------------------------------
export default function MiniTest() {
  describe("Mini_CasesTest", () => {
    console.log(`${TAG} 测试套件 'Mini_Cases' 开始执行...`);

    it("skip_null_geometries", 10000, async () => {
      const TEST_NAME = 'skip_null_geometries';
      console.log(`\n${TAG} ------- [${TEST_NAME}] 测试开始 -------`);
      try {
        console.log(`${TAG} [${TEST_NAME}] -> 步骤 1: 读取并解析 'null_geometry.kml'...`);
        const xmlContent = await getRawFileContent('null_geometry.kml');
        const dom = new xmldom.DOMParser().parseFromString(xmlContent, 'text/xml') as Document;
        console.log(`${TAG} [${TEST_NAME}] -> 步骤 1: 完成。`);

        console.log(`${TAG} [${TEST_NAME}] -> 步骤 2: 测试 skipNullGeometry: true...`);
        const resSkip = tj.kml(dom, { skipNullGeometry: true }) as GeoJSON.FeatureCollection;
        expect(resSkip.features.length).assertEqual(0);
        console.log(`${TAG} [${TEST_NAME}] -> 断言成功: features.length 是 0。`);

        console.log(`${TAG} [${TEST_NAME}] -> 步骤 3: 测试 skipNullGeometry: false...`);
        const resNoSkip = tj.kml(dom, { skipNullGeometry: false }) as GeoJSON.FeatureCollection;
        expect(resNoSkip.features.length).assertEqual(1);
        console.log(`${TAG} [${TEST_NAME}] -> 断言成功: features.length 是 1。`);

        console.log(`${TAG} ------- [${TEST_NAME}] 测试成功结束 -------`);
      } catch (e) {
        console.error(`${TAG} [${TEST_NAME}] -> 测试意外失败: ${(e as Error).message}`);
        expect().assertFail();
      }
    });

    it("folder_nesting", 10000, async () => {
      const TEST_NAME = 'folder_nesting';
      console.log(`\n${TAG} ------- [${TEST_NAME}] 测试开始 -------`);
      try {
        console.log(`${TAG} [${TEST_NAME}] -> 步骤 1: 读取并解析 'inline_style_mini.kml'...`);
        const xmlContent = await getRawFileContent('inline_style_mini.kml');
        const dom = new xmldom.DOMParser().parseFromString(xmlContent, 'text/xml') as Document;
        console.log(`${TAG} [${TEST_NAME}] -> 步骤 1: 完成。`);

        console.log(`${TAG} [${TEST_NAME}] -> 步骤 2: 使用 kmlWithFolders 进行转换...`);
        const result = tj.kmlWithFolders(dom) as ProcessableGeoObject;
        console.log(`${TAG} [${TEST_NAME}] -> 步骤 2: 完成。`);

        console.log(`${TAG} [${TEST_NAME}] -> 步骤 3: 读取期望结果 'inline_style_mini_kml_with_folders.json'...`);
        const expectedJsonContent = await getRawFileContent('inline_style_mini_kml_with_folders.json');
        const expectedJSON = JSON.parse(expectedJsonContent) as ProcessableGeoObject;
        console.log(`${TAG} [${TEST_NAME}] -> 步骤 3: 完成。`);

        console.log(`${TAG} [${TEST_NAME}] -> 步骤 4: 对比前进行坐标舍入...`);
        const roundedResult = roundGeoJsonCoordinates(result);
        const roundedExpected = roundGeoJsonCoordinates(expectedJSON);
        console.log(`${TAG} [${TEST_NAME}] -> 步骤 4: 完成。`);

        console.log(`${TAG} [${TEST_NAME}] -> 步骤 5: 断言比对 (assertDeepEquals)...`);
        expect(roundedResult).assertDeepEquals(roundedExpected);
        console.log(`${TAG} [${TEST_NAME}] -> 步骤 5: 断言成功。`);

        console.log(`${TAG} ------- [${TEST_NAME}] 测试成功结束 -------`);
      } catch (e) {
        console.error(`${TAG} [${TEST_NAME}] -> 测试意外失败: ${(e as Error).message}`);
        expect().assertFail();
      }
    });
  });
}

