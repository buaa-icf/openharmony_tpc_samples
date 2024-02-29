/*
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import * as ParserHTMLJson from 'parser-html-json';

const html = `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<style>
    .tagh1{
        background-color: aquamarine;
        color:'blue';
    }
    .one-div{
        line-height: 30px;
    }
</style>
<body><h1 class="tagh1">kkkk<p>hhhhh</p></h1><div style="color:red; height:100px;" class="one-div">cshi</div><img src="https:baidu.com" alt="wwww"/><p>wjdwekfe</p><em>dsjfw<div>dksfmjk</div>owqkdo</em></body></html>
`


export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    it('getClassStyleJson', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let asserResult = '{"tagh1":"background-color:aquamarine;color:\'blue\';","one-div":"line-height:30px;"}';
      let parserJson = new ParserHTMLJson.default(html);
      let result = JSON.stringify(parserJson.getClassStyleJson());
      expect(result).assertEqual(asserResult);
    })

    it('getHtmlJson', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let asserResult = '[{"tagName":"body","text":"","children":[{"tagName":"h1","text":"kkkk","children":[{"tagName":"p","text":"hhhhh","children":[]}],"attr":{"class":"tagh1"}},{"tagName":"div","text":"cshi","children":[],"attr":{"style":"color:red; height:100px;","class":"one-div"}},{"tagName":"img","text":"","children":[],"attr":{"src":"https:baidu.com","alt":"wwww"}},{"tagName":"p","text":"wjdwekfe","children":[]},{"tagName":"em","text":"dsjfw","children":[{"tagName":"div","text":"dksfmjkowqkdo","children":[]}]}]}]';
      asserResult = asserResult.replace('\n', '');
      let parserJson = new ParserHTMLJson.default(html);
      let result = JSON.stringify(parserJson.getHtmlJson()).replace('\n', '');
      expect(result).assertEqual(asserResult);
    })
  })
}