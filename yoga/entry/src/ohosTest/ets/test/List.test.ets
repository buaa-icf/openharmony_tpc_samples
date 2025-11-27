/**
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

import yogaNodeTest from './YogaNodeTest.test';
import yogaNodeStylePropertiesTest from './YogaNodeStylePropertiesTest.test';
import yogaExceptionTest from './YogaExceptionTest.test';
import yogaFlexTest from './YGFlexTest.test';
import yogaAlignBaselineTest from './YGAlignBaselineTest.test';
import yogaGapTest from './YGGapTest.test';
import yogaJustifyContentTest from './YGJustifyContentTest.test';
import yogaAlignContentTest from './YGAlignContentTest.test';
import yogaAbsolutePositionTest from './YGAbsolutePositionTest.test';
import yogaAlignItemsTest from './YGAlignItemsTest.test';
import yogaAlignSelfTest from './YGAlignSelfTest.test';
import yogaAspectRatioTest from './YGAspectRatioTest.test';
import yogaAutoTest from './YGAutoTest.test';
import yogaBorderTest from './YGBorderTest.test';
import yogaBoxSizingTest from './YGBoxSizingTest.test';
import yogaDisplayTest from './YGDisplayTest.test';
import yogaFlexDirectionTest from './YGFlexDirectionTest.test';
import yogaFlexWrapTest from './YGFlexWrapTest.test';
import yogaMarginTest from './YGMarginTest.test';
import yogaMinMaxDimensionTest from './YGMinMaxDimensionTest.test';
import yogaPaddingTest from './YGPaddingTest.test';
import yogaPercentageTest from './YGPercentageTest.test';
import yogaSizeOverflowTest from './YGSizeOverflowTest.test';
import yogaPositionTest from './YGPositionTest.test';

export default function testsuite() {
  yogaNodeTest();
  yogaNodeStylePropertiesTest();
  yogaExceptionTest();
  yogaFlexTest();
  yogaAlignBaselineTest();
  yogaGapTest();
  yogaJustifyContentTest();
  yogaAlignContentTest();
  yogaAbsolutePositionTest();
  yogaAlignItemsTest();
  yogaAlignSelfTest();
  yogaAspectRatioTest();
  yogaAutoTest();
  yogaBorderTest();
  yogaBoxSizingTest();
  yogaDisplayTest();
  yogaFlexDirectionTest();
  yogaFlexWrapTest();
  yogaMarginTest();
  yogaMinMaxDimensionTest();
  yogaPaddingTest();
  yogaPercentageTest();
  yogaSizeOverflowTest();
  yogaPositionTest();
}