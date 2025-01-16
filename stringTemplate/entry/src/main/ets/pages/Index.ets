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

import { Stc, ProcessTemplate, st } from '@ohos/stringtemplate'
import { fileIo as fs } from '@kit.CoreFileKit';
import helloInstance from '../../resources/rawfile/hello_stg';
import introInstance from '../../resources/rawfile/introduce_stg';
import processTemplateDir from '../../resources/rawfile/testDir_stg';
import { util } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import { JSON } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  // 将unit8Array转为字符串
  private uint8ArrayToString(array: Uint8Array) {
    let textDecoderOptions: util.TextDecoderOptions = {
      fatal: false,
      ignoreBOM: true
    }
    let decodeToStringOptions: util.DecodeToStringOptions = {
      stream: false
    }
    let textDecoder = util.TextDecoder.create('utf-8', textDecoderOptions);
    let retStr = textDecoder.decodeToString(array, decodeToStringOptions);
    return retStr;
  }

  // 将rawfile写入沙箱 并返回写入的沙箱路径
  private pushRawFile(srcFileName: string): string {
    let context = getContext(this) as common.UIAbilityContext;
    let filesDir = context.filesDir;

    // 获取rawfile内容
    let rawfileContent = context.resourceManager.getRawFileContentSync(srcFileName);
    // 写入沙箱
    let destFilePath = filesDir + "/" + srcFileName;
    let fileStream = fs.createStreamSync(destFilePath, "w+");
    fileStream.writeSync(rawfileContent.buffer);
    fileStream.close();
    return destFilePath;
  }

  // 将rawfile写入沙箱文件夹 并返回写入的沙箱路径
  private pushRawFileDir(srcFileNameList: string[], dirName: string): string {
    let context = getContext(this) as common.UIAbilityContext;
    let filesDir = context.filesDir;
    let dir = filesDir + dirName;
    try {
      fs.mkdirSync(dir);
    } catch (e) {
      console.error("mkdir failed with error message: " + e.message + ", error code: " + e.code);
    }
    srcFileNameList.forEach( item => {
      let rawfileContent = context.resourceManager.getRawFileContentSync(item);
      let destFilePath = dir + "/" + item;
      let fileStream = fs.createStreamSync(destFilePath, "w+");
      fileStream.writeSync(rawfileContent.buffer);
      fileStream.close();
    })
    return dir;
  }

  private getCompiledFileContent(compiledPath: string): string {
    let rr = compiledPath.replace('.st', '') + '_stg.js';
    let stat = fs.statSync(rr);
    // 读文件
    let file = fs.openSync(rr, fs.OpenMode.READ_WRITE);
    let buf = new ArrayBuffer(stat.size);
    fs.readSync(file.fd, buf);
    fs.closeSync(file);
    // 转为字符串
    let decoder = util.TextDecoder.create('utf-8');
    let str = decoder.decodeToString(new Uint8Array(buf));
    return str;
  }

  private getJson(jsonName: string): Object | null {
    // 获取json数据
    let context = getContext(this) as common.UIAbilityContext;
    let jsonContent = context.resourceManager.getRawFileContentSync(jsonName);
    let strJson = this.uint8ArrayToString(jsonContent)
    let data = JSON.parse(strJson);
    return data;
  }

  private compile(destFilePath: string) {
    // 设置编译选项 编译文件
    let stc = new Stc();
    stc.compile(destFilePath);
  }

  private processTemplate(getInstance: Function, data: object, template: string): string {
    // 设置填充配置 填充模版
    // getInstance: 编译好的文件内导出的函数
    // data: 用于填充模版的数据对象
    // template: 模版名称
    let p = new ProcessTemplate();
    let res: string = p.processTemplate(getInstance, data, template);
    return res;
  }

  private processTemplateInCode(getInstance: Function, templateName: string, templateData: object): string {
    return st.loadGroup(getInstance).render(templateName, templateData);
  }

  build() {
    RelativeContainer() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Button('version', { type: ButtonType.Normal, stateEffect: true })
          // 输出编译好的文件
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(200)
          .height(60)
          .margin({ left: 90, right: 80, top: 20, bottom: 20 })
          .onClick(() => {
            let stc = new Stc();
            let stcVersion = stc.version;
            let statDelimiters = stc.statDelimiters;
            let endDelimiters = stc.endDelimiters;
            let p = new ProcessTemplate();
            let pVersion = p.version;
            hilog.info(0x0001, "StringTemplate TEST:", "stringTemplate stc verison: %{public}s", stcVersion);
            hilog.info(0x0001, "StringTemplate TEST:", "stringTemplate processTemplate verison: %{public}s", pVersion);
            // 默认的开始结束符都为 $
            hilog.info(0x0001, "StringTemplate TEST:",
              "stringTemplate Delimiters: %{public}s  %{public}s", statDelimiters, endDelimiters);
            // 可能的开始和结束符: #$%^&*<>
            stc.statDelimiters = '<';
            stc.endDelimiters = '>';
            hilog.info(0x0001, "StringTemplate TEST:",
              "stringTemplate Delimiters change: %{public}s  %{public}s", stc.statDelimiters, stc.endDelimiters);
          })
        Button('compile', { type: ButtonType.Normal, stateEffect: true })
          // 输出编译好的文件
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(200)
          .height(60)
          .margin({ left: 90, right: 80, top: 20, bottom: 20 })
          .onClick(() => {
            // 1. 将resource/rawfile文件夹下待编译文件传入沙箱 并返回其沙箱路径
            let compilePath = this.pushRawFile('hello.st');
            // 2. 编译此文件 编译成功会在日志输出"compiled."
            this.compile(compilePath);
            // 3. 获取此文件 查看编译好的文件
            let compiledFile = this.getCompiledFileContent(compilePath);
            hilog.info(0x0001, "StringTemplate TEST:", "compiled file: %{public}s", compiledFile);
          })
        Button('processTemplate', { type: ButtonType.Normal, stateEffect: true })
          // 输出替换好的模版
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(200)
          .height(60)
          .margin({ left: 90, right: 80, top: 20, bottom: 20 })
          .onClick(() => {
            // 1. 将resource/rawfile文件夹下json文件传入沙箱 并返回json数据
            let data = this.getJson('hello.json');
            // 2. 传入编译好的文件导出的函数 用于填充模版的数据对象 以及 模版名称
            // 返回处理好的数据
            let res = this.processTemplate(helloInstance, data!, 'hello');
            hilog.info(0x0001, "StringTemplate TEST:", "process Template: %{public}s", res);
          })
        Button('processTemplate value null', { type: ButtonType.Normal, stateEffect: true })
          // 输出替换好的模版
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(200)
          .height(60)
          .margin({ left: 90, right: 80, top: 20, bottom: 20 })
          .onClick(() => {
            // 1. 将resource/rawfile文件夹下json文件传入沙箱 并返回json数据
            let data = this.getJson('hello_empty.json');
            // 2. 传入编译好的文件导出的函数 用于填充模版的数据对象 以及 模版名称
            // 返回处理好的数据
            let res = this.processTemplate(helloInstance, data!, 'hello');
            hilog.info(0x0001, "StringTemplate TEST:", "process Template with value null: %{public}s", res);
          })
        Button('processTemplate without json', { type: ButtonType.Normal, stateEffect: true })
          // 不使用json文件 在工程文件中 输出替换好的模版
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(200)
          .height(60)
          .margin({ left: 90, right: 80, top: 20, bottom: 20 })
          .onClick(() => {
            let temData = new Object({audience: "wwwww"});
            let temRes = this.processTemplateInCode(helloInstance, 'hello', temData);
            hilog.info(0x0001, "StringTemplate TEST:", "compiled template without json: %{public}s", temRes);
          })
        Button('introduce', { type: ButtonType.Normal, stateEffect: true })
          // 输出编译好的文件
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(200)
          .height(60)
          .margin({ left: 90, right: 80, top: 20, bottom: 20 })
          .onClick(() => {
            // 1. 将resource/rawfile文件夹下待编译文件传入沙箱 并返回其沙箱路径
            let compilePath = this.pushRawFile('introduce.st');
            // 2. 编译此文件 编译成功会在日志输出"compiled."
            this.compile(compilePath);
            // 3. 获取此文件 查看编译好的文件
            let compiledFile = this.getCompiledFileContent(compilePath);
            hilog.info(0x0001, "StringTemplate TEST:", "compiled introduce file: %{public}s", compiledFile);
          })
        Button('introduce processTemplate', { type: ButtonType.Normal, stateEffect: true })
          // 不使用json文件 在工程文件中 输出替换好的模版
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(200)
          .height(60)
          .margin({ left: 90, right: 80, top: 20, bottom: 20 })
          .onClick(() => {
            // 1. 将resource/rawfile文件夹下json文件传入沙箱 并返回json数据
            let data = this.getJson('introduce.json');
            // 2. 传入编译好的文件导出的函数 用于填充模版的数据对象 以及 模版名称
            // 返回处理好的数据
            let res = this.processTemplate(introInstance, data!, 'introduce');
            hilog.info(0x0001, "StringTemplate TEST:", "process introduce Template: %{public}s", res);
          })
        Button('introduce processTemplate without json', { type: ButtonType.Normal, stateEffect: true })
          // 不使用json文件 在工程文件中 输出替换好的模版
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(200)
          .height(60)
          .margin({ left: 90, right: 80, top: 20, bottom: 20 })
          .onClick(() => {
            let temData = new Object({ name: "LiHua", like: "Orange" });
            let temRes = this.processTemplateInCode(introInstance, 'introduce', temData);
            hilog.info(0x0001, "StringTemplate TEST:",
              "compiled introduce template without json: %{public}s", temRes);
          })
        Button('compile dir', { type: ButtonType.Normal, stateEffect: true })
          // test for dir
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(200)
          .height(60)
          .margin({ left: 90, right: 80, top: 20, bottom: 20 })
          .onClick(() => {
            // 1. 将resource/rawfile文件夹下待编译文件全部传入沙箱文件夹内 并返回其沙箱路径
            let compilePathList = ['hello.st', 'introduce.st', 'testDir.st'];
            let compileDirPath = this.pushRawFileDir(compilePathList, "/stDir3");
            // 2. 传入文件夹 编译文件夹内的内容 将会在文件夹内生成一个统一的文件 编译成功会在日志输出"compiled."
            this.compile(compileDirPath);
            // 3. 获取此文件 查看编译好的文件
            let compiledFile =
              this.getCompiledFileContent(compileDirPath + '/' + compilePathList[compilePathList.length - 1]);
            hilog.info(0x0001, "StringTemplate TEST:", "compiled Dir file: %{public}s", compiledFile);
          })
        Button('processTemplate dir', { type: ButtonType.Normal, stateEffect: true })
          // test for dir
          .borderRadius(8)
          .backgroundColor(0x317aff)
          .width(200)
          .height(60)
          .margin({ left: 90, right: 80, top: 20, bottom: 20 })
          .onClick(() => {
            let temData1 = new Object({name: "LiHua", like: "Orange" });
            let temRes1 = this.processTemplateInCode(processTemplateDir, 'introduce', temData1);
            hilog.info(0x0001, "StringTemplate TEST:", "compiled dir template without json: %{public}s", temRes1);
            let temData2 = new Object({ color: "red" });
            let temRes2 = this.processTemplateInCode(processTemplateDir, 'testDir', temData2);
            hilog.info(0x0001, "StringTemplate TEST:", "compiled dir template without json: %{public}s", temRes2);
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}