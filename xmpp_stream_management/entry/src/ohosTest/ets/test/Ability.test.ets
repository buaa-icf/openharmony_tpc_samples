/**
 * ISC License
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import streamManagement from '@ohos/xmpp_stream_management'
import _middleware from "@ohos/xmpp_middleware";
import { Client } from "@ohos/xmpp_client_core";
import _streamFeatures from "@ohos/xmpp_stream_features";

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    class Options {
      service: string = ''
      domain: string = ''
      resource: string = ''
      username: string = ''
      password: string = ''
      caPath: string = ''
    }
    const entity = new Client(new Options());
    const middleware = _middleware({
      entity
    });
    const streamFeatures = _streamFeatures({
      middleware
    });
    const sm = streamManagement({
      streamFeatures, entity, middleware
    });

    it('streamManagement_enabled',0, () => {
      expect(sm.enabled).assertFalse();
    });

    it('streamManagement_allowResume',0, () => {
      expect(sm.allowResume).assertTrue();
    });

    it('streamManagement_id',0, () => {
      expect(sm.id).assertEqual('');
    });

    it('streamManagement_outbound',0, () => {
      expect(sm.outbound).assertEqual(0);
    });

    it('streamManagement_inbound',0, () => {
      expect(sm.outbound).assertEqual(0);
    });

    it('streamManagement_preferredMaximum',0, () => {
      expect(sm.preferredMaximum).assertNull();
    });

    it('streamManagement_max',0, () => {
      expect(sm.preferredMaximum).assertNull();
    });
  })
}