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

import { EvaResource } from '../mix/EvaResource'

/**
 * YYEVA 资源点击监听器接口
 * 定义资源点击事件处理
 */
export interface OnEvaResourceClickListener {
  /**
   * 返回被点击的资源
   * @param resource 被点击的资源
   */
  onClick(resource: EvaResource): void
}