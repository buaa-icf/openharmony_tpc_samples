/**
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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, TestType } from '@ohos/hypium'
import EventBus from 'eventbusjs'
import { Event } from '@ohos.worker'

export default function telephonyPerfJsunit(){
  describe("telephonyPerfJsunit",()=>{
    const BASE_COUNT=2000
    const HTTP_COUNT=2
    const BASELINE_HASSIMECASR=500
    const BASELINE_CREATEHTTP=500
    const BASELINE_REQUEST=2500
    const BASELINE_DESTROY=30


    it("addEventListener", TestType.PERFORMANCE, async ()=> {
      let startTime=new Date().getTime()
      console.log("Telephony_Http_CreateHttp_Perf_0100_SVGDeclares startTime:"+startTime);

      for (let index = 0; index < BASE_COUNT; index++) {
        let basicTestCallBack =(event:Event)=>{
        }
        EventBus.addEventListener("basicTest",basicTestCallBack)
      }


      let endTime=new Date().getTime()
      console.log("Telephony_Http_CreateHttp_Perf_0100_addEventListener endTime:"+endTime);

      let averageTime=((endTime-startTime)*1000)/BASE_COUNT
      console.log("Telephony_Http_CreateHttp_Perf_0100_addEventListener averageTime:"+averageTime+"μs");
      expect(averageTime<BASELINE_CREATEHTTP).assertTrue();
    });

    it("removeEventListener", TestType.PERFORMANCE, async ()=> {
      let startTime=new Date().getTime()
      console.log("Telephony_Http_CreateHttp_Perf_0100_SVGDeclares startTime:"+startTime);

      for (let index = 0; index < BASE_COUNT; index++) {
        let basicTestCallBack =(event:Event)=>{
        }
        EventBus.addEventListener("basicTest",basicTestCallBack)
        EventBus.removeEventListener("basicTest",basicTestCallBack)
      }

      let endTime=new Date().getTime()
      console.log("Telephony_Http_CreateHttp_Perf_0100_removeEventListener endTime:"+endTime);

      let averageTime=((endTime-startTime)*1000)/BASE_COUNT
      console.log("Telephony_Http_CreateHttp_Perf_0100_removeEventListener averageTime:"+averageTime+"μs");
      expect(averageTime<BASELINE_CREATEHTTP).assertTrue();
    });


    it("hasEventListener", TestType.PERFORMANCE, async ()=> {
      let startTime=new Date().getTime()
      console.log("Telephony_Http_CreateHttp_Perf_0100_SVGCircle startTime:"+startTime);

      for (let index = 0; index < BASE_COUNT; index++) {
        let basicEventTestCallBack =(event:Event)=>{
        }
        let isHasFirst:boolean=EventBus.hasEventListener("basicEvents",basicEventTestCallBack)
        EventBus.addEventListener("basicEventBus",basicEventTestCallBack)
        let isHasSecond:boolean=EventBus.hasEventListener("basicEvents",basicEventTestCallBack)
      }

      let endTime=new Date().getTime()
      console.log("Telephony_Http_CreateHttp_Perf_0100_hasEventListener endTime:"+endTime);

      let averageTime=((endTime-startTime)*1000)/BASE_COUNT
      console.log("Telephony_Http_CreateHttp_Perf_0100_hasEventListener averageTime:"+averageTime+"μs");
      expect(averageTime<BASELINE_CREATEHTTP).assertTrue();
    });

    it("dispatch", TestType.PERFORMANCE, async ()=> {
      let startTime=new Date().getTime()
      console.log("Telephony_Http_CreateHttp_Perf_0100_SVGCircle startTime:"+startTime);

      for (let index = 0; index < BASE_COUNT; index++) {
        let basicEventTestCallBack =(event:Event)=>{
        }
        EventBus.addEventListener("basicEventBus",basicEventTestCallBack)
      }

      let endTime=new Date().getTime()
      console.log("Telephony_Http_CreateHttp_Perf_0100_dispatch endTime:"+endTime);

      let averageTime=((endTime-startTime)*1000)/BASE_COUNT
      console.log("Telephony_Http_CreateHttp_Perf_0100_dispatch averageTime:"+averageTime+"μs");
      expect(averageTime<BASELINE_CREATEHTTP).assertTrue();
    });


    it("getEvents", TestType.PERFORMANCE, async ()=> {
      let startTime=new Date().getTime()
      console.log("Telephony_Http_CreateHttp_Perf_0100_SVGCircle startTime:"+startTime);

      for (let index = 0; index < BASE_COUNT; index++) {
        console.info("getEvents begin")
        let abcCallBack = (event: Event)=>{
        }
        let cbdCallBack = (event: Event)=>{
        }
        EventBus.addEventListener('abc',abcCallBack)
        EventBus.addEventListener('cbd',cbdCallBack)
        console.info("getEvents end")
      }


      let endTime=new Date().getTime()
      console.log("Telephony_Http_CreateHttp_Perf_0100_getEvents endTime:"+endTime);

      let averageTime=((endTime-startTime)*1000)/BASE_COUNT
      console.log("Telephony_Http_CreateHttp_Perf_0100_getEvents averageTime:"+averageTime+"μs");
      expect(averageTime<BASELINE_CREATEHTTP).assertTrue();
    });

  })
}