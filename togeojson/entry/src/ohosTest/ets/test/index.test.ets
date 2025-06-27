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
import resourceManager from '@ohos.resourceManager';
import { path } from '@ohos/node-polyfill';
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
// --- 辅助函数区域
// -----------------------------------------------------------------------------

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const context = delegator.getAppContext();
const resMgr = context.resourceManager;
const TAG = '[toGeoJSONTest]';

//读文件函数
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


//控制精度函数
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
      ls.coordinates = ls.coordinates.map((p: GeoJSON.Position) =>
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

export default function toGeoJSON_TestSuite() {
  describe("toGeoJSON", () => {
    it("should_correctly_process_all_files_in_rawfile_directory", 20000, async () => {
      console.log(`${TAG} 开始动态读取 rawfile 目录下的所有文件...`);
      const allRawFiles = await resMgr.getRawFileList("");
      const filesToTest = allRawFiles
        .filter((item) => !item.startsWith("."))
        .filter((item) => ['.gpx', '.kml', '.tcx'].includes(path.extname(item).toLowerCase()));

      if (filesToTest.length === 0) {
        console.warn(`${TAG} 警告: 在 rawfile 目录中没有找到任何 .gpx, .kml, 或 .tcx 文件进行测试。`);
        return;
      }
      console.log(`${TAG} 过滤后，找到 ${filesToTest.length} 个测试用例需要执行。`);

      for (const file of filesToTest) {
        console.log(`\n${TAG} ------- 开始处理文件: [${file}] -------`);
        const ext = path.extname(file).substring(1).toLowerCase() as "kml" | "tcx" | "gpx";

        console.log(`${TAG} [${file}] -> 步骤 1: 读取并解析XML文件...`);
        const xmlContent = await getRawFileContent(file);
        const dom = new xmldom.DOMParser().parseFromString(xmlContent, "text/xml") as Document;
        console.log(`${TAG} [${file}] -> 步骤 1: 完成。`);

        console.log(`${TAG} [${file}] -> 步骤 2: 转换 ${ext.toUpperCase()} 为 GeoJSON...`);
        const rawRes = tj[ext](dom);
        const res = JSON.parse(JSON.stringify(rawRes)) as GeoJSON.GeoJSON;
        console.log(`${TAG} [${file}] -> 步骤 2: 完成。`);

        console.log(`${TAG} [${file}] -> 步骤 3: 读取期望结果的JSON文件...`);
        const expectedFileName = file.replace(path.extname(file), `_${ext}.json`);
        const expectedJsonContent = await getRawFileContent(expectedFileName);
        const expectedJSON = JSON.parse(expectedJsonContent) as GeoJSON.GeoJSON;
        console.log(`${TAG} [${file}] -> 步骤 3: 完成。`);

        console.log(`${TAG} [${file}] -> 步骤 4: 对坐标进行四舍五入以消除浮点精度差异...`);
        console.log('------------正在处理解析后结果的精度--------------')
        const roundedRes = roundGeoJsonCoordinates(res, 9);
        console.log('生成',JSON.stringify(roundedRes));
        console.log('------------正在处理解析期望结果的精度--------------')
        const roundedExpected = roundGeoJsonCoordinates(expectedJSON, 9);
        console.log('期望',JSON.stringify(roundedExpected))
        console.log(`${TAG} [${file}] -> 步骤 4: 完成。`);
        console.log(`${TAG} [${file}] -> 步骤 5: 断言比对 (assertDeepEquals)...`);
        expect(roundedRes).assertDeepEquals(roundedExpected);
        console.log(`${TAG} [${file}] -> 步骤 5: 完成。`);

        if (ext === 'kml') {
          console.log(`${TAG} [${file}] -> 开始 KML 文件的额外测试...`);

          // --- 测试 1: kmlWithFolders 默认行为 ---
          console.log(`${TAG} [${file}] -> 额外测试 1/2: kmlWithFolders(dom)`);
          const resWithFoldersRaw = tj.kmlWithFolders(dom);
          const resWithFolders = JSON.parse(JSON.stringify(resWithFoldersRaw)) as ProcessableGeoObject;
          const expectedFileNameWithFolders = file.replace(path.extname(file), '_kml_with_folders.json');
          const expectedJsonWithFolders = JSON.parse(await getRawFileContent(expectedFileNameWithFolders)) as ProcessableGeoObject;
          const roundedResWf = roundGeoJsonCoordinates(resWithFolders);
          const roundedExpectedWf =  roundGeoJsonCoordinates(expectedJsonWithFolders);
          expect(roundedResWf).assertDeepEquals(roundedExpectedWf);
          console.log(`${TAG} [${file}] -> 测试 1/2: 完成。`);


          // --- 测试 2: kmlWithFolders 带有 { skipNullGeometry: true } 选项 ---
          console.log(`${TAG} [${file}] -> 额外测试 2/2: kmlWithFolders(dom, { skipNullGeometry: true })`);
          const resSkipNullRaw = tj.kmlWithFolders(dom, { skipNullGeometry: true });
          const resSkipNull = JSON.parse(JSON.stringify(resSkipNullRaw)) as ProcessableGeoObject;
          const expectedFileNameSkipNull = file.replace(path.extname(file), '_kml_with_folders_skip_null.json');
          const expectedJsonSkipNull = JSON.parse(await getRawFileContent(expectedFileNameSkipNull)) as ProcessableGeoObject;
          const roundedResSn = roundGeoJsonCoordinates(resSkipNull);
          const roundedExpectedSn = roundGeoJsonCoordinates(expectedJsonSkipNull);
          expect(roundedResSn).assertDeepEquals(roundedExpectedSn);
          console.log(`${TAG} [${file}] -> 测试 2/2: 完成。`);
        }
        console.log(`${TAG} ------- 文件处理结束: [${file}] -------`);
      }
    });
  });
}




