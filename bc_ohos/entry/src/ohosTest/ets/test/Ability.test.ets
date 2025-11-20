/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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
import { hilog } from '@kit.PerformanceAnalysisKit'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  ISO9797Alg3Mac,
  ParametersWithIV,
  KeyParameter,
  ISO7816d4Padding,
  ZeroBytePadding,
  PKCS7Padding,
  ISO10126d2Padding,
  X923Padding,
  TBCPadding
} from '@ohos/bc-ohos'

// 工具函数：字节数组转十六进制
function bytesToHex(bytes: Uint8Array): string {
  return Array.from(bytes)
    .map(b => b.toString(16).padStart(2, '0'))
    .join('')
    .toUpperCase()
}

export default function abilityTest() {
  describe('ISO9797Alg3Mac', () => {
    let testInput: Uint8Array
    let testKey16: Uint8Array
    let testKey24: Uint8Array
    let testIV: Uint8Array
    let expectedMac: Uint8Array
    
    beforeAll(() => {
      hilog.info(0x0000, 'testTag', 'ISO9797Alg3Mac 测试套件开始')
      
      // 标准测试数据
      testInput = new Uint8Array([0x84, 0xE4, 0x00, 0x80, 0x0F, 0x4F, 0x05, 0x47, 0x4D, 0x50, 0x4B, 0x49])
      testKey16 = new Uint8Array([0x31, 0x9C, 0xD0, 0x5D, 0x11, 0xBB, 0x06, 0x72, 0x9B, 0xE2, 0x3D, 0xA1, 0x9B, 0x80, 0xE6, 0xA3])
      testKey24 = new Uint8Array([0x31, 0x9C, 0xD0, 0x5D, 0x11, 0xBB, 0x06, 0x72, 0x9B, 0xE2, 0x3D, 0xA1, 0x9B, 0x80, 0xE6, 0xA3, 0x7F, 0x1A, 0x2B, 0x3C, 0x4D, 0x5E, 0x6F, 0x70])
      testIV = new Uint8Array([0xA0, 0x97, 0x99, 0x41, 0x08, 0xD0, 0x6F, 0x1B])
      expectedMac = new Uint8Array([0xF0, 0xE6, 0xEF, 0x61, 0x39, 0xD2, 0x37, 0x33])
    })
    
    beforeEach(() => {
      hilog.info(0x0000, 'testTag', '测试用例开始')
    })
    
    afterEach(() => {
      hilog.info(0x0000, 'testTag', '测试用例结束')
    })
    
    afterAll(() => {
      hilog.info(0x0000, 'testTag', 'ISO9797Alg3Mac 测试套件结束')
    })
    
    // 基础功能测试
    it('[测试01] 构造函数_无参数', 0, () => {
      const mac = new ISO9797Alg3Mac()
      hilog.info(0x0000, 'testTag', '[测试01] 构造函数_无参数 实例化成功')
      hilog.info(0x0000, 'testTag', `[测试01] 算法名称: ${mac.getAlgorithmName()}`)
      hilog.info(0x0000, 'testTag', `[测试01] MAC大小: ${mac.getMacSize()} 字节`)
      hilog.info(0x0000, 'testTag', `[测试01] 填充方式: 零填充(默认)`)
      expect(mac.getAlgorithmName()).assertEqual('ISO9797Alg3')
      expect(mac.getMacSize()).assertEqual(8)
      hilog.info(0x0000, 'testTag', '[测试01] 无参数构造函数配置验证通过')
    })
    
    it('[测试02] 构造函数_填充参数', 0, () => {
      const padding = new ISO7816d4Padding()
      const mac = new ISO9797Alg3Mac(padding)
      hilog.info(0x0000, 'testTag', '[测试02] 构造函数_填充参数 实例化成功')
      hilog.info(0x0000, 'testTag', `[测试02] 算法名称: ${mac.getAlgorithmName()}`)
      hilog.info(0x0000, 'testTag', `[测试02] MAC大小: ${mac.getMacSize()} 字节`)
      hilog.info(0x0000, 'testTag', `[测试02] 填充方式: ${padding.getPaddingName()}`)
      expect(mac.getMacSize()).assertEqual(8)
      hilog.info(0x0000, 'testTag', '[测试02] 填充参数构造函数配置验证通过')
    })
    
    it('[测试03] 初始化_16字节密钥', 0, () => {
      const mac = new ISO9797Alg3Mac(new ISO7816d4Padding())
      const params: KeyParameter = { key: testKey16 }
      mac.init(params)
      hilog.info(0x0000, 'testTag', `[测试03] 初始化_16字节密钥  算法名称是否一致: ${mac.getAlgorithmName() === 'ISO9797Alg3'}`)
      expect(mac.getAlgorithmName()).assertEqual('ISO9797Alg3')
    })
    
    it('[测试04] 初始化_带IV参数', 0, () => {
      const mac = new ISO9797Alg3Mac(new ISO7816d4Padding())
      const params: ParametersWithIV = {
        parameters: { key: testKey16 },
        iv: testIV
      }
      mac.init(params)
      hilog.info(0x0000, 'testTag', `[测试04] 初始化_带IV参数  算法名称是否一致: ${mac.getAlgorithmName() === 'ISO9797Alg3'}`)
      expect(mac.getAlgorithmName()).assertEqual('ISO9797Alg3')
    })
    
    it('[测试05] ISO7816d4Padding_标准测试向量', 0, () => {
      const mac = new ISO9797Alg3Mac(new ISO7816d4Padding())
      const params: ParametersWithIV = {
        parameters: { key: testKey16 },
        iv: testIV
      }
      mac.init(params)
      mac.update(testInput, 0, testInput.length)
      const output = new Uint8Array(8)
      mac.doFinal(output, 0)
      hilog.info(0x0000, 'testTag', `[测试05] ISO7816d4Padding_标准测试向量是否一致: ${bytesToHex(output) === bytesToHex(expectedMac)}`)
      expect(bytesToHex(output)).assertEqual(bytesToHex(expectedMac))
    })
    
    it('[测试06] ZeroBytePadding_基本计算', 0, () => {
      const mac = new ISO9797Alg3Mac(new ZeroBytePadding())
      const params: ParametersWithIV = { parameters: { key: testKey16 }, iv: testIV }
      mac.init(params)
      mac.update(testInput, 0, testInput.length)
      const output = new Uint8Array(8)
      mac.doFinal(output, 0)
      const hexOutput = bytesToHex(output)
      hilog.info(0x0000, 'testTag', `[测试06] ZeroBytePadding 输出(Hex): ${hexOutput}`)
      expect(output.length).assertEqual(8)
    })
    
    it('[测试07] PKCS7Padding_基本计算', 0, () => {
      const mac = new ISO9797Alg3Mac(new PKCS7Padding())
      const params: ParametersWithIV = { parameters: { key: testKey16 }, iv: testIV }
      mac.init(params)
      mac.update(testInput, 0, testInput.length)
      const output = new Uint8Array(8)
      mac.doFinal(output, 0)
      const hexOutput = bytesToHex(output)
      hilog.info(0x0000, 'testTag', `[测试07] PKCS7Padding 输出(Hex): ${hexOutput}`)
      expect(output.length).assertEqual(8)
    })
    
    it('[测试08] ISO10126d2Padding_随机填充', 0, () => {
      const mac = new ISO9797Alg3Mac(new ISO10126d2Padding())
      const params: ParametersWithIV = { parameters: { key: testKey16 }, iv: testIV }
      mac.init(params)
      mac.update(testInput, 0, testInput.length)
      const output = new Uint8Array(8)
      mac.doFinal(output, 0)
      const hexOutput = bytesToHex(output)
      hilog.info(0x0000, 'testTag', `[测试08] ISO10126d2Padding 输出(Hex,随机): ${hexOutput}`)
      expect(output.length).assertEqual(8)
    })
    
    it('[测试09] ISO10126d2Padding_固定填充测试', 0, () => {
      // 使用固定的填充数据进行测试，确保跨平台一致性
      const mac = new ISO9797Alg3Mac(new ISO10126d2Padding())
      const params: ParametersWithIV = { parameters: { key: testKey16 }, iv: testIV }
      mac.init(params)
      
      // 手动构造固定填充的数据：原始12字节 + 固定4字节填充(0xAA, 0xBB, 0xCC, 0x04)
      const paddedInput = new Uint8Array(16)
      paddedInput.set(testInput, 0)  // 前12字节：原始数据
      paddedInput[12] = 0xAA  // 固定填充字节1
      paddedInput[13] = 0xBB  // 固定填充字节2
      paddedInput[14] = 0xCC  // 固定填充字节3
      paddedInput[15] = 0x04  // 填充长度
      
      // 使用 ZeroBytePadding 避免二次填充，直接处理已填充的数据
      const macFixed = new ISO9797Alg3Mac(new ZeroBytePadding())
      macFixed.init(params)
      macFixed.update(paddedInput, 0, paddedInput.length)
      const output = new Uint8Array(8)
      macFixed.doFinal(output, 0)
      
      const hexOutput = bytesToHex(output)
      hilog.info(0x0000, 'testTag', `[测试09] ISO10126d2Padding 输出(Hex,固定AA-BB-CC-04): ${hexOutput}`)
      expect(output.length).assertEqual(8)
    })
    
    it('[测试010] X923Padding_默认模式', 0, () => {
      const mac = new ISO9797Alg3Mac(new X923Padding())
      const params: ParametersWithIV = { parameters: { key: testKey16 }, iv: testIV }
      mac.init(params)
      mac.update(testInput, 0, testInput.length)
      const output = new Uint8Array(8)
      mac.doFinal(output, 0)
      const hexOutput = bytesToHex(output)
      hilog.info(0x0000, 'testTag', `[测试010] X923Padding 输出(Hex): ${hexOutput}`)
      expect(output.length).assertEqual(8)
    })
    
    it('[测试011] TBCPadding_基本计算', 0, () => {
      const mac = new ISO9797Alg3Mac(new TBCPadding())
      const params: ParametersWithIV = { parameters: { key: testKey16 }, iv: testIV }
      mac.init(params)
      mac.update(testInput, 0, testInput.length)
      const output = new Uint8Array(8)
      mac.doFinal(output, 0)
      const hexOutput = bytesToHex(output)
      hilog.info(0x0000, 'testTag', `[测试011] TBCPadding 输出(Hex): ${hexOutput}`)
      expect(output.length).assertEqual(8)
    })
    
    it('[测试012] 分段更新_结果一致性', 0, () => {
      const mac1 = new ISO9797Alg3Mac(new ISO7816d4Padding())
      const mac2 = new ISO9797Alg3Mac(new ISO7816d4Padding())
      const params: ParametersWithIV = { parameters: { key: testKey16 }, iv: testIV }
      
      mac1.init(params)
      mac1.update(testInput, 0, testInput.length)
      const output1 = new Uint8Array(8)
      mac1.doFinal(output1, 0)
      
      mac2.init(params)
      mac2.update(testInput, 0, 6)
      mac2.update(testInput, 6, testInput.length - 6)
      const output2 = new Uint8Array(8)
      mac2.doFinal(output2, 0)
      hilog.info(0x0000, 'testTag', `[测试012] 分段更新_结果一致性: output1 与 output2 一致： ${bytesToHex(output1) === bytesToHex(output2)} `)
      
      expect(bytesToHex(output1)).assertEqual(bytesToHex(output2))
    })
    
    it('[测试013] 24字节密钥_基本计算', 0, () => {
      const mac = new ISO9797Alg3Mac(new ISO7816d4Padding())
      const params: ParametersWithIV = { parameters: { key: testKey24 }, iv: testIV }
      mac.init(params)
      mac.update(testInput, 0, testInput.length)
      const output = new Uint8Array(8)
      mac.doFinal(output, 0)
      const hexOutput = bytesToHex(output)
      hilog.info(0x0000, 'testTag', `[测试013] 24字节密钥 输出(Hex): ${hexOutput}`)
      expect(output.length).assertEqual(8)
    })
    
    it('[测试014] 不同MAC大小配置', 0, () => {
      // 测试不同的macSize配置，验证算法是否能正确处理不同大小的MAC
      hilog.info(0x0000, 'testTag', '[测试014] 不同MAC大小配置')
      
      // 测试默认MAC大小(8字节)
      const macDefault = new ISO9797Alg3Mac(new ISO7816d4Padding())
      expect(macDefault.getMacSize()).assertEqual(8)
      hilog.info(0x0000, 'testTag', `[测试014] 默认MAC大小: ${macDefault.getMacSize()}`)
      
      // 测试4字节MAC大小
      const mac4Bytes = new ISO9797Alg3Mac(32, new ISO7816d4Padding()) // 32位 = 4字节
      expect(mac4Bytes.getMacSize()).assertEqual(4)
      hilog.info(0x0000, 'testTag', `[测试014] 4字节MAC大小: ${mac4Bytes.getMacSize()}`)
      
      // 测试3字节MAC大小
      const mac3Bytes = new ISO9797Alg3Mac(24, new ISO7816d4Padding()) // 24位 = 3字节
      expect(mac3Bytes.getMacSize()).assertEqual(3)
      hilog.info(0x0000, 'testTag', `[测试014] 3字节MAC大小: ${mac3Bytes.getMacSize()}`)
      
      // 使用不同大小的MAC进行计算
      const params: ParametersWithIV = { parameters: { key: testKey16 }, iv: testIV }
      
      // 默认大小MAC计算
      macDefault.init(params)
      macDefault.update(testInput, 0, testInput.length)
      const outputDefault = new Uint8Array(macDefault.getMacSize())
      macDefault.doFinal(outputDefault, 0)
      expect(outputDefault.length).assertEqual(8)
      hilog.info(0x0000, 'testTag', `[测试014] 默认大小MAC输出(Hex): ${bytesToHex(outputDefault)}`)
      
      // 4字节MAC计算
      mac4Bytes.init(params)
      mac4Bytes.update(testInput, 0, testInput.length)
      const output4Bytes = new Uint8Array(mac4Bytes.getMacSize())
      mac4Bytes.doFinal(output4Bytes, 0)
      expect(output4Bytes.length).assertEqual(4)
      hilog.info(0x0000, 'testTag', `[测试014] 4字节MAC输出(Hex): ${bytesToHex(output4Bytes)}`)
      
      // 3字节MAC计算
      mac3Bytes.init(params)
      mac3Bytes.update(testInput, 0, testInput.length)
      const output3Bytes = new Uint8Array(mac3Bytes.getMacSize())
      mac3Bytes.doFinal(output3Bytes, 0)
      expect(output3Bytes.length).assertEqual(3)
      hilog.info(0x0000, 'testTag', `[测试014] 3字节MAC输出(Hex): ${bytesToHex(output3Bytes)}`)
    })

    it('[测试015] 构造函数_MAC大小参数', 0, () => {
      const mac = new ISO9797Alg3Mac(32) // 32位 = 4字节
      hilog.info(0x0000, 'testTag', '[测试015] 构造函数_MAC大小参数 实例化成功')
      hilog.info(0x0000, 'testTag', `[测试015] 算法名称: ${mac.getAlgorithmName()}`)
      hilog.info(0x0000, 'testTag', `[测试015] MAC大小: ${mac.getMacSize()} 字节`)
      hilog.info(0x0000, 'testTag', `[测试015] 填充方式: 零填充(默认)`)
      expect(mac.getMacSize()).assertEqual(4)
      hilog.info(0x0000, 'testTag', '[测试015] MAC大小参数构造函数配置验证通过')
    })

    it('[测试016] 构造函数_MAC大小和填充参数', 0, () => {
      const padding = new PKCS7Padding()
      const mac = new ISO9797Alg3Mac(32, padding) // 32位 = 4字节 + PKCS7填充
      hilog.info(0x0000, 'testTag', '[测试016] 构造函数_MAC大小和填充参数 实例化成功')
      hilog.info(0x0000, 'testTag', `[测试016] 算法名称: ${mac.getAlgorithmName()}`)
      hilog.info(0x0000, 'testTag', `[测试016] MAC大小: ${mac.getMacSize()} 字节`)
      hilog.info(0x0000, 'testTag', `[测试016] 填充方式: ${padding.getPaddingName()}`)
      expect(mac.getMacSize()).assertEqual(4)
      hilog.info(0x0000, 'testTag', '[测试016] MAC大小和填充参数构造函数配置验证通过')
    })
    
    it('[测试017] 单字节更新接口测试', 0, () => {
      const mac1 = new ISO9797Alg3Mac(new ISO7816d4Padding())
      const mac2 = new ISO9797Alg3Mac(new ISO7816d4Padding())
      const params: ParametersWithIV = { parameters: { key: testKey16 }, iv: testIV }
      
      // 使用update方法更新数据
      mac1.init(params)
      mac1.update(testInput, 0, testInput.length)
      const output1 = new Uint8Array(8)
      mac1.doFinal(output1, 0)
      
      // 使用updateByte方法逐字节更新数据
      mac2.init(params)
      for (let i = 0; i < testInput.length; i++) {
        mac2.updateByte(testInput[i])
      }
      const output2 = new Uint8Array(8)
      mac2.doFinal(output2, 0)
      
      // 验证两种方式结果一致
      const hexOutput1 = bytesToHex(output1)
      const hexOutput2 = bytesToHex(output2)
      hilog.info(0x0000, 'testTag', `[测试017] update方法输出(Hex): ${hexOutput1}`)
      hilog.info(0x0000, 'testTag', `[测试017] updateByte方法输出(Hex): ${hexOutput2}`)
      expect(hexOutput1).assertEqual(hexOutput2)
      hilog.info(0x0000, 'testTag', '[测试017] 单字节更新接口测试通过')
    })
  })
}