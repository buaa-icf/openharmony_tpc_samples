/**
 * MIT License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to all conditions.
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, } from '@ohos/hypium'
import { BlufiParameter, BlufiStatusResponse } from '@ohos/espblufiforharmony'

export default function BlufiStatusResponseTest() {
  describe('BlufiStatusResponseTest', () => {

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
    it('BlufiStatusResponse', 0, () => {

      let statusResponse: BlufiStatusResponse
        = new BlufiStatusResponse();
      let opMode: number = BlufiParameter.OP_MODE_STA;
      statusResponse.setOpMode(opMode);

      let softAPConnectCount: number = 1;
      statusResponse.setSoftAPConnectionCount(softAPConnectCount);
      let newSoftApCount: number = statusResponse.getSoftAPConnectionCount();
      expect(newSoftApCount).assertEqual(softAPConnectCount);

      let softAPMaxCount: number = 2;
      statusResponse.setSoftAPMaxConnectionCount(softAPMaxCount);
      let newSoftAPMaxCount: number = statusResponse.getSoftAPMaxConnectionCount();
      expect(newSoftAPMaxCount).assertEqual(softAPMaxCount);

      let softAPSecrity: number = 1;
      statusResponse.setSoftAPSecurity(softAPSecrity);
      let newSoftAPSecrity: number = statusResponse.getSoftAPSecurity();
      expect(newSoftAPSecrity).assertEqual(softAPSecrity);

      let softAPChannel: number = 1;
      statusResponse.setSoftAPChannel(softAPChannel);
      let newSPChannel: number = statusResponse.getSoftAPChannel();
      expect(newSPChannel).assertEqual(softAPChannel);

      let ssid: string = "she other wifi";
      let pwd: string = "123456789";
      statusResponse.setSoftAPPassword(pwd);
      let newSPPwd: string = statusResponse.getSoftAPPassword();
      expect(newSPPwd).assertEqual(pwd);

      statusResponse.setSoftAPSSID(ssid);
      let newSPSSid: string = statusResponse.getSoftAPSSID();
      expect(newSPSSid).assertEqual(ssid);

      let bssid: string = "cdfDD";
      statusResponse.setStaBSSID(bssid);
      let newStaBSSid: string = statusResponse.getStaBSSID();
      expect(newStaBSSid).assertEqual(bssid);

      statusResponse.setStaSSID(ssid);
      let newStaSSid: string = statusResponse.getStaSSID();
      expect(newStaSSid).assertEqual(ssid);

      statusResponse.setStaPassword(pwd);
      let newStaPwd: string = statusResponse.getStaPassword();
      expect(newStaPwd).assertEqual(pwd);

      let staStatus: number = 1;
      statusResponse.setStaConnectionStatus(staStatus);
      let newStaStatus: number = statusResponse.getStaConnectionStatus();
      expect(newStaStatus).assertEqual(staStatus);

      let responseStr: string = statusResponse.generateValidInfo();
      expect(responseStr.length).assertLarger(0);

    })
  })
}