/*
 * The MIT License (MIT)
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import  EventSource  from '@ohos/eventsource'
export default function abilityTest() {
  describe('ssePerformance', () => {
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
    let url = 'http://localhost:8080/sse'
    const BASE_COUNT = 2
    it('addEventListener', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let startTime = new Date().getTime()
      let es = new EventSource(url)
      es.addEventListener('server-time',(e:Record<'data',string>)=>{
        expect(!!e.data).assertTrue()
      })
      let endTime = new Date().getTime()
      console.info("EndTime:" + endTime)
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.info("AverageTime:" + averageTime)
      expect(averageTime).assertLess(2000)
    })
    it('removeEventListener', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let startTime = new Date().getTime()
      let es = new EventSource(url)
      es.removeEventListener('server-time',(e:Record<'data',string>)=>{
        console.info('Stop listening')
        expect(!!e.data).assertFalse()
      })
      let endTime = new Date().getTime()
      console.info("EndTime:" + endTime)
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.info("AverageTime:" + averageTime)
      expect(averageTime).assertLess(2000)
    })
    it('close', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let startTime = new Date().getTime()
      let es = new EventSource(url)
      es.close()
      es.addEventListener('server-time',(e:Record<'data',string>)=>{
        expect(!!e.data).assertFalse()
      })
      let endTime = new Date().getTime()
      console.info("EndTime:" + endTime)
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.info("AverageTime:" + averageTime)
      expect(averageTime).assertLess(2000)
    })
    it('onFailure', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let startTime = new Date().getTime()
      let es = new EventSource(url)
      es.onFailure((e:Record<"message", string>)=>{
        expect(e.message).assertContain('error')
      })
      es.close()
      let endTime = new Date().getTime()
      console.info("EndTime:" + endTime)
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.info("AverageTime:" + averageTime)
      expect(averageTime).assertLess(2000)
    })
  })
}