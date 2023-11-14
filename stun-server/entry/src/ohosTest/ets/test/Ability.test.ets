/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { StunServer, StunClient } from '@ohos/stun';
import { Utils } from '../../../../../stun/src/main/ets/common/node-stun/lib/Utils';
export default function abilityTest() {

  describe('ActsAbilityTest', ()=> {
    it('assertinetAton', 0, ()=> {
      let num=Utils.inetAton("2.2")
      expect(num==1536).assertFalse()
    })
    it('assertBufferCompare', 0, ()=> {
      let flag: boolean=Utils.bufferCompare("CQ","CQ")
      expect(flag).assertTrue()
    })
    it('asserteInetNtoa', 0, ()=> {
      let d=Utils.inetNtoa(100)
      expect(d=="200").assertFalse()
    })
    it('assertBuffer', 0, ()=> {
      let Buffer=new ArrayBuffer(100)
      let teststring=Utils.buffer2String(Buffer)
      expect(teststring=="str").assertFalse()
    })

  })
}