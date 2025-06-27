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
import { coord, coord1, fixRing } from '../../../main/ets/kml/geometry';

export default function geometryTest() {
  describe('coord1', () => {
    it('parses_coordinate', 0, () => {
      expect(coord1("42,24")).assertDeepEquals([42, 24]);
      expect(coord1("2,2")).assertDeepEquals([2, 2]);
      expect(coord1("2,2,4")).assertDeepEquals([2, 2, 4]);
    });
    it('removes_nans', 0, () => {
      expect(coord1("a,24")).assertDeepEquals([24]);
    });
  });

  describe('coord', () => {
    it('parses_coordinates', 0, () => {
      expect(coord("42,24 1,2")).assertDeepEquals([
        [42, 24],
        [1, 2],
      ]);
      expect(coord("42,24 1,2 alpha,beta")).assertDeepEquals([
        [42, 24],
        [1, 2],
      ]);
    });
  });

  describe('fixRing', () => {
    it('completes_a_ring_if_necessary', 0, () => {
      const ring = [
        [1, 2],
        [3, 4],
        [5, 6],
      ];
      const expected = [
        [1, 2],
        [3, 4],
        [5, 6],
        [1, 2],
      ];
      expect(fixRing(ring)).assertDeepEquals(expected);
    });
    it('does_not_touch_good_rings', 0, () => {
      const ring = [
        [1, 2],
        [3, 4],
        [5, 6],
        [1, 2],
      ];
      expect(fixRing(ring)).assertDeepEquals(ring);
    });
  });
}