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

import * as ParserHTMLJson from 'parser-html-json';
import hilog from '@ohos.hilog';

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

@Entry
@Component
struct Index {
  @State message: string = this.getResourceString($r('app.string.please_click_button'));

  getResourceString(res:Resource){
    try {
      return this.getUIContext().getHostContext()?.resourceManager.getStringSync(res.id) || "";
    }catch (e){
      hilog.error(0x0001, "[lodash.isequal]", "getStringSync error, message %{private}d", JSON.stringify(e));
      return "";
    }
  }

  build() {
    Row() {
      Column() {
        Button('getClassStyleJson')
          .fontSize(20)
          .margin(10)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            let parserJson = new ParserHTMLJson.default(html);
            let result = JSON.stringify(parserJson.getClassStyleJson());
            console.log(result)
            this.message = result
          })
        Button('getHtmlJson')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin(10)
          .onClick(()=>{
            let parserJson = new ParserHTMLJson.default(html);
            let result = JSON.stringify(parserJson.getHtmlJson());
            console.log(result)
            this.message = result
          })
        Text(this.getResourceString($r('app.string.result')) + ':\n' + this.message)
          .fontSize(20)
      }
      .width('100%')
    }
    .height('100%')
  }
}