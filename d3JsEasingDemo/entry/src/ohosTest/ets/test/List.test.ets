/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * * Neither the name of the author nor the names of contributors may be used to
 *   endorse or promote products derived from this software without specific prior
 *   written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import abilityTest from './Ability.test';
import LinearEasingTest from './linear.test';
import easeQuadTest from './quad.test';
import easeCubicTest from './cubic.test';
import easePolyTest from './poly.test';
import easeSinTest from './sin.test';
import easeExpTest from './exp.test';
import easeCircleTest from './circle.test';
import easeBounceTest from './bounce.test';
import easeBackTest from './back.test';
import easeElasticTest from './elastic.test';
import performanceTest from './performance.test';

export default function testsuite() {
  abilityTest();
  LinearEasingTest();
  easeQuadTest();
  easeCubicTest();
  easePolyTest();
  easeSinTest();
  easeExpTest();
  easeCircleTest();
  easeBounceTest();
  easeBackTest();
  easeElasticTest();
  performanceTest();
}