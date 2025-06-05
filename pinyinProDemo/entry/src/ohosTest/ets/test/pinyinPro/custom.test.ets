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

@Concurrent
async function customNone(): Promise<string> {
  customPinyin();
  const result = pinyin('干一行行一行');
  return result
}

@Concurrent
async function customCustom1(): Promise<string> {
  customPinyin({
    能: 'nài',
  });
  const result = pinyin('我姓能');
  return result
}

@Concurrent
async function customCustom2(): Promise<string> {
  customPinyin({
    好好: 'hào hǎo',
  });
  const result = pinyin('爱好好多');
  return result
}

@Concurrent
async function customCustom3(): Promise<string> {
  customPinyin({
    哈什玛: 'hà shén mǎ',
  });
  const result = pinyin('哈什玛');
  return result
}

@Concurrent
async function customCustom4(): Promise<string> {
  customPinyin({
    暴虎冯河: 'bào hǔ píng hé',
  });
  const result = pinyin('暴虎冯河');
  return result
}

@Concurrent
async function customCustom5(): Promise<string> {
  customPinyin({
    干一行行一行: 'gàn yī háng xíng yī háng',
  });
  const result = pinyin('干一行行一行');
  return result
}

@Concurrent
async function customCustoms(): Promise<string> {
  customPinyin({
    好: 'hào',
    好好: 'hào hǎo',
  });
  const result = pinyin('好好');
  return result
}

@Concurrent
async function customLevel(): Promise<string> {
  customPinyin({
    银行: 'yin hang',
  });
  const result = pinyin('银行');
  return result
}

@Concurrent
async function customUnicode(): Promise<string> {
  customPinyin({
    𧒽: 'lei',
  });
  const result = pinyin('𧒽沙发𧒽𧒽𧒽算法是');
  return result
}

@Concurrent
async function customUnicodes(): Promise<string> {
  customPinyin({
    𧒽𧒽: 'lei ke',
  });
  const result = pinyin('𧒽沙发𧒽𧒽𧒽算法是');
  return result
}

export default function customConfigTest() {
  describe('customConfig', () => {
    it('custom_custom_none', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customNone);
        expect(result).assertEqual('gàn yì háng xíng yì háng');
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_custom1', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customCustom1);
        expect(result).assertEqual('wǒ xìng nài');
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_custom2', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customCustom2);
        expect(result).assertEqual('ài hào hǎo duō');
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_custom3', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customCustom3);
        expect(result).assertEqual('hà shén mǎ');
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_custom4', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customCustom4);
        expect(result).assertEqual('bào hǔ píng hé');
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_custom5', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customCustom5);
        expect(result).assertEqual('gàn yī háng xíng yī háng');
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_custom_with_surname', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customSurname, '乐嘉啊');
        expect(result).assertEqual('lè jiā a');

        let result1: ESObject = await taskpool.execute(customSurname, '啊乐嘉');
        expect(result1).assertEqual('a lè jiā');

        let result2: ESObject = await taskpool.execute(customSurname, '啊乐嘉是');
        expect(result2).assertEqual('a lè jiā shì');
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_customs', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customCustoms);
        expect(result).assertEqual('hào hǎo');
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_custom_with_multiple', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customMultiple);
        expect(result).assertDeepEquals(['en0']);
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_ac_high_level', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customLevel);
        expect(result).assertEqual('yin hang');
        customPinyin({});
      } finally {
        done()
      }

    });

    it('custom_double_unicode', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customUnicode);
        expect(result).assertEqual('lei shā fā lei lei lei suàn fǎ shì');
        customPinyin({});
      } finally {
        done()
      }

    });

    it('_custom_double_unicode', 0, async (done: Function) => {
      try {
        let result: ESObject = await taskpool.execute(customUnicodes);
        expect(result).assertEqual('lei shā fā lei lei ke suàn fǎ shì');
        customPinyin({});
      } finally {
        done()
      }

    });
  });
}

