/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  * */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import * as flatbuffers from '@ohos/flatbuffers'
import { BasicScalars } from './example';

const builder = new flatbuffers.Builder();

export default function basicTest() {
  describe('BasicTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.

    it('intMax', 0, () => {
      // 开始初始化
      BasicScalars.startBasicScalars(builder);

      // 添加数据
      BasicScalars.addInt8(builder,127);
      BasicScalars.addInt16(builder,32767);
      BasicScalars.addInt32(builder,2147483647);
      BasicScalars.addInt64(builder,9223372036854775807n);

      // 完成初始化
      let offset = BasicScalars.endBasicScalars(builder);
      BasicScalars.finishBasicScalarsBuffer(builder, offset);

      // 序列化
      let serializeBuffer = builder.asUint8Array();

      // 反序列化
      let buffer = new flatbuffers.ByteBuffer(serializeBuffer);
      let basicScalars = BasicScalars.getRootAsBasicScalars(buffer);
      expect(127).assertEqual(basicScalars.int8());
      expect(32767).assertEqual(basicScalars.int16());
      expect(2147483647).assertEqual(basicScalars.int32());
      expect(9223372036854775807n).assertEqual(basicScalars.int64());
    })

    it('intMin', 0, () => {
      // 开始初始化
      BasicScalars.startBasicScalars(builder);

      // 添加数据
      BasicScalars.addInt8(builder,-128);
      BasicScalars.addInt16(builder,-32768);
      BasicScalars.addInt32(builder,-2147483648);
      BasicScalars.addInt64(builder,-9223372036854775808n);

      // 完成初始化
      let offset = BasicScalars.endBasicScalars(builder);
      BasicScalars.finishBasicScalarsBuffer(builder, offset);

      // 序列化
      let serializeBuffer = builder.asUint8Array();

      // 反序列化
      let buffer = new flatbuffers.ByteBuffer(serializeBuffer);
      let basicScalars = BasicScalars.getRootAsBasicScalars(buffer);
      expect(-128).assertEqual(basicScalars.int8());
      expect(-32768).assertEqual(basicScalars.int16());
      expect(-2147483648).assertEqual(basicScalars.int32());
      expect(-9223372036854775808n).assertEqual(basicScalars.int64());
    })

    it('uintMax', 0, () => {
      // 开始初始化
      BasicScalars.startBasicScalars(builder);

      // 添加数据
      BasicScalars.addUint8(builder,127);
      BasicScalars.addUint16(builder,32767);
      BasicScalars.addUint32(builder,2147483647);
      BasicScalars.addUint64(builder,9223372036854775807n);

      // 完成初始化
      let offset = BasicScalars.endBasicScalars(builder);
      BasicScalars.finishBasicScalarsBuffer(builder, offset);

      // 序列化
      let serializeBuffer = builder.asUint8Array();

      // 反序列化
      let buffer = new flatbuffers.ByteBuffer(serializeBuffer);
      let basicScalars = BasicScalars.getRootAsBasicScalars(buffer);
      expect(127).assertEqual(basicScalars.uint8());
      expect(32767).assertEqual(basicScalars.uint16());
      expect(2147483647).assertEqual(basicScalars.uint32());
      expect(9223372036854775807n).assertEqual(basicScalars.uint64());
    })

    it('float_and_bool', 0, () => {
      // 开始初始化
      BasicScalars.startBasicScalars(builder);

      // 添加数据
      BasicScalars.addFloat32(builder,1.0);
      BasicScalars.addFloat64(builder,1.0);
      BasicScalars.addBool(builder,true);

      // 完成初始化
      let offset = BasicScalars.endBasicScalars(builder);
      BasicScalars.finishBasicScalarsBuffer(builder, offset);

      // 序列化
      let serializeBuffer = builder.asUint8Array();

      // 反序列化
      let buffer = new flatbuffers.ByteBuffer(serializeBuffer);
      let basicScalars = BasicScalars.getRootAsBasicScalars(buffer);
      expect(1.0).assertEqual(basicScalars.float32());
      expect(1.0).assertEqual(basicScalars.float64());
      expect(basicScalars.bool()).assertTrue();
    })
  })
}