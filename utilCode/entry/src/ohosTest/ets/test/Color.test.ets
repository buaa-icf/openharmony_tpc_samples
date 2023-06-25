import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
// @ts-ignore
import randomColor from 'randomcolor';
export default function PictureTest() {
  describe('picture', function () {
    it('randomColorFormat_rgb', 0, function () { //第一个参数自定义
      expect(randomColor.randomColor({
        format:'hex'
      })).not().assertNull()
    })
  })
}