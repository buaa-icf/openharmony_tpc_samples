/**
 *  The MIT License (MIT)
 *
 *  Copyright (c) 2022 HUAWEI
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import Jwks from '@ohos/jwks_rsa'

var jwksClient: Jwks.JwksClient;
var signingKey;
export default function JwksClientTest() {
  describe('JwksClientTest', function () {
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      console.info("===== beforeAll ======")
      jwksClient = new Jwks.JwksClient({
        jwksUri: 'https://sandrino.auth0.com/.well-known/jwks.json',
        requestHeaders: {}, // Optional
        timeout: 5000, // Defaults to 30s
        cache: false,
        rateLimit: true
      });
      expect(jwksClient != null).assertTrue()
    })

    it('JwksClient_Test_getKeys',0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      expect(await jwksClient.getKeys() != null).assertTrue()
    })

    it('JwksClient_Test_getSigningKeys',0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      expect(await jwksClient.getSigningKeys() != null).assertTrue()
    })

    it('JwksClient_Test_signingKey',0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const kid = 'RkI5MjI5OUY5ODc1N0Q4QzM0OUYzNkVGMTJDOUEzQkFCOTU3NjE2Rg';
      signingKey = await jwksClient.getSigningKey(kid);
      expect(signingKey != null).assertTrue()
    })

    it('JwksClient_Test_kid',0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      expect(signingKey.kid != null).assertTrue()
    })

    it('JwksClient_Test_algorithm',0, function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      expect(signingKey.algorithm != null).assertTrue()
    })

    it('JwksClient_Test_type',0, function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      expect(signingKey.type != null).assertTrue()
    })

    it('JwksClient_Test_usage',0, function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      expect(signingKey.usage != null).assertTrue()
    })

    it('JwksClient_Test_getPublicKey',0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let publicKey = await signingKey.getPublicKey()
      expect(publicKey != null).assertTrue()
    })
  })
}