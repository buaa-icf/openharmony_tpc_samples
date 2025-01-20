/**
 * BSD License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *  list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * * Neither the name Facebook nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Stc, ProcessTemplate, st } from '@ohos/stringtemplate'
import { fileIo as fs } from '@kit.CoreFileKit';
import processTemplateDir from './testDir_stg';
import { util } from '@kit.ArkTS';
import GlobalContext from './GlobalContext';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
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

    it('test_compile', 0, () => {
      let context:Context = GlobalContext.getContext().getValue("context") as Context;
      let filesDir = GlobalContext.getContext().getValue("filesPath");
      let rawfileContent = context.resourceManager.getRawFileContentSync('hello.st');
      let destFilePath = filesDir + '/hello.st';
      let fileStream = fs.createStreamSync(destFilePath, "w+");
      fileStream.writeSync(rawfileContent.buffer);
      fileStream.close();

      let stc = new Stc();
      stc.compile(destFilePath);
      let compiledFilePath = destFilePath.replace('.st', '') + '_stg.js';
      let stat = fs.statSync(compiledFilePath);
      let file = fs.openSync(compiledFilePath, fs.OpenMode.READ_WRITE);
      let buf = new ArrayBuffer(stat.size);
      fs.readSync(file.fd, buf);
      fs.closeSync(file);
      let decoder = util.TextDecoder.create('utf-8');
      let str = decoder.decodeToString(new Uint8Array(buf));
      expect(str.length > 0).assertEqual(true);
    })

    it('test_loadgroup', 1, () => {
      let temData = new Object({color:"red"});
      let temRes: string = '';
      temRes = st.loadGroup(processTemplateDir).render('testDir', temData);
      expect(temRes).assertEqual('my favourite color is red.');
    })

    it('test_processtemplate', 2, () => {
      let p = new ProcessTemplate();
      let temData = new Object({ color:"red" });
      let res: string = '';
      res = p.processTemplate(processTemplateDir, temData, 'testDir');
      expect(res).assertEqual('my favourite color is red.');
    })
  })
}