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

export enum ValueType {
  NULL = 0,
  INT = 1,
  UINT = 2,
  FLOAT = 3,
  KEY = 4,
  STRING = 5,
  INDIRECT_INT = 6,
  INDIRECT_UINT = 7,
  INDIRECT_FLOAT = 8,
  MAP = 9,
  VECTOR = 10,
  VECTOR_INT = 11,
  VECTOR_UINT = 12,
  VECTOR_FLOAT = 13,
  VECTOR_KEY = 14,
  VECTOR_STRING_DEPRECATED = 15,
  VECTOR_INT2 = 16,
  VECTOR_UINT2 = 17,
  VECTOR_FLOAT2 = 18,
  VECTOR_INT3 = 19,
  VECTOR_UINT3 = 20,
  VECTOR_FLOAT3 = 21,
  VECTOR_INT4 = 22,
  VECTOR_UINT4 = 23,
  VECTOR_FLOAT4 = 24,
  BLOB = 25,
  BOOL = 26,
  VECTOR_BOOL = 36,
}