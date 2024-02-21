/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { pinyin, customPinyin } from 'pinyin-pro'
import taskpool from '@ohos.taskpool';

@Concurrent
async function customMultiple(): Promise<string[]> {
  customPinyin({
    嗯: 'en',
  });
  const result = pinyin('嗯', {
    type: 'array',
    nonZh: 'removed',
    toneType: 'num',
  });
  return result
}

@Concurrent
async function customSurname(word: string): Promise<string> {
  customPinyin({
    乐嘉: 'lè jiā',
  });
  const result = pinyin(word, {
    mode: 'surname'
  });
  return result
}

export default function customConfigTest() {
  describe('customConfig', () => {
    it('custom_custom_none', 0, () => {
      customPinyin();
      const result = pinyin('干一行行一行');
      expect(result).assertEqual('gān yī xíng xíng yī xíng');
      customPinyin({});
    });

    it('custom_custom1', 0, () => {
      customPinyin({
        能: 'nài',
      });
      const result = pinyin('我姓能');
      expect(result).assertEqual('wǒ xìng nài');
      customPinyin({});
    });

    it('custom_custom2', 0, () => {
      customPinyin({
        好好: 'hào hǎo',
      });
      const result = pinyin('爱好好多');
      expect(result).assertEqual('ài hào hǎo duō');
      customPinyin({});
    });

    it('custom_custom3', 0, () => {
      customPinyin({
        哈什玛: 'hà shén mǎ',
      });
      const result = pinyin('哈什玛');
      expect(result).assertEqual('hà shén mǎ');
      customPinyin({});
    });

    it('custom_custom4', 0, () => {
      customPinyin({
        暴虎冯河: 'bào hǔ píng hé',
      });
      const result = pinyin('暴虎冯河');
      expect(result).assertEqual('bào hǔ píng hé');
      customPinyin({});
    });

    it('custom_custom5', 0, () => {
      customPinyin({
        干一行行一行: 'gàn yī háng xíng yī háng',
      });
      const result = pinyin('干一行行一行');
      expect(result).assertEqual('gàn yī háng xíng yī háng');
      customPinyin({});
    });

    it('custom_custom_with_surname', 0, async (done:Function) => {
      try {
        let result:ESObject = await taskpool.execute(customSurname, '乐嘉啊');
        expect(result).assertEqual('lè jiā a');

        let result1:ESObject = await taskpool.execute(customSurname, '啊乐嘉');
        expect(result1).assertEqual('a lè jiā');

        let result2:ESObject = await taskpool.execute(customSurname, '啊乐嘉是');
        expect(result2).assertEqual('a lè jiā shì');
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_customs', 0, () => {
      customPinyin({
        好: 'hào',
        好好: 'hào hǎo',
      });
      const result = pinyin('好好');
      expect(result).assertEqual('hào hǎo');
      customPinyin({});
    });

    it('custom_custom_with_multiple', 0, async (done:Function) => {
      try {
        let result:ESObject = await taskpool.execute(customMultiple);
        expect(result).assertDeepEquals(['en0']);
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_ac_high_level', 0, () => {
      customPinyin({
        银行: 'yin hang',
      });
      const result = pinyin('银行');
      expect(result).assertEqual('yin hang');
      customPinyin({});
    });

    it('custom_double_unicode', 0, () => {
      customPinyin({
        𧒽: 'lei',
      });
      const result = pinyin('𧒽沙发𧒽𧒽𧒽算法是');
      expect(result).assertEqual('lei shā fā lei lei lei suàn fǎ shì');
      customPinyin({});
    });

    it('_custom_double_unicode', 0, () => {
      customPinyin({
        𧒽𧒽: 'lei ke',
      });
      const result = pinyin('𧒽沙发𧒽𧒽𧒽算法是');
      expect(result).assertEqual('𧒽 shā fā lei ke 𧒽 suàn fǎ shì');
      customPinyin({});
    });
  });
}

