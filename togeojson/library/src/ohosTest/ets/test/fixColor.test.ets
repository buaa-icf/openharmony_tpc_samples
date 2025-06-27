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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { fixColor } from '../../../main/ets/kml/fixColor';

export default function fixColorTest() {
  describe('fixColor', () => {
    it('parses_coordinate', 0, () => {
      expect(fixColor("#f00", "line")).assertDeepEquals({
        "line-color": "#f00", });
      expect(fixColor("#f00f00", "line")).assertDeepEquals({
        "line-color": "#f00f00", });
    });
    it('rearranges_KML_colors', 0, () => {
      expect(fixColor("#000f0000", "line")).assertDeepEquals({
        "line-color": "#00000f",
        "line-opacity": 0,
      });
      expect(fixColor("#ff000000", "line")).assertDeepEquals({
        "line-color": "#000000",
        "line-opacity": 1,
      });
      expect(fixColor("ff000000", "line")).assertDeepEquals({
        "line-color": "#000000",
        "line-opacity": 1,
      });
      expect(fixColor("#a1ff00ff", "line")).assertDeepEquals({
        "line-color": "#ff00ff",
        "line-opacity": 0.6313725490196078,
      });
    });
  })
}