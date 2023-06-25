import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import gcoord from 'gcoord'

export default function GcoordTest() {
  describe('Gcoord', function () {
    it('BD092GCJ02', 0, function () {
      expect(gcoord.transform(
        [116.403988, 39.914266], // 经纬度坐标
      gcoord.BD09, // 当前坐标系
      gcoord.GCJ02 // 目标坐标系
      )).assertDeepEquals([116.39761462515557, 39.90792254403078])
    })
    it('GCJ022BD09', 0, function () {
      expect(gcoord.transform(
        [116.403988, 39.914266], // 经纬度坐标
      gcoord.GCJ02, // 当前坐标系
      gcoord.BD09 // 目标坐标系
      )).assertDeepEquals([116.41035800409784,39.920603218738634])
    })
    it('GCJ022WGS84', 0, function () {
      expect(gcoord.transform(
        [116.403988, 39.914266], // 经纬度坐标
      gcoord.GCJ02, // 当前坐标系
      gcoord.WGS84 // 目标坐标系
      )).assertDeepEquals([116.39774359252733,39.91286174888657])
    })
    it('WGS842GCJ02', 0, function () {
      expect(gcoord.transform(
        [116.403988, 39.914266], // 经纬度坐标
      gcoord.WGS84, // 当前坐标系
      gcoord.GCJ02 // 目标坐标系
      )).assertDeepEquals([116.41023240747266,39.915670251113426])
    })
    it('BD092WGS84', 0, function () {
      expect(gcoord.transform(
        [116.403988, 39.914266], // 经纬度坐标
      gcoord.BD09, // 当前坐标系
      gcoord.WGS84 // 目标坐标系
      )).assertDeepEquals([116.39137353150247,39.906521276697305])
    })
    it('WGS842BD09', 0, function () {
      expect(gcoord.transform(
        [116.403988, 39.914266], // 经纬度坐标
      gcoord.WGS84, // 当前坐标系
      gcoord.BD09 // 目标坐标系
      )).assertDeepEquals([116.41661560068297,39.92196580126834])
    })
  })
}