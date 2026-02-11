/*
 * Copyright (C) 2026 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import { Xlog, XLogConfig } from '@ohos/xlog';
import prompt from '@system.prompt';
import app from '@system.app';

@Entry
@Component
struct Demo {
  scroller: Scroller= new Scroller()
  sendCount: number = 0;
  receiveCount: number = 0;
  pubKey: string = 'PUBKEY';
  log: Xlog|null = new Xlog();
  @State nameprefix: string = 'test_prefix';
  @State logPath: string = getContext().filesDir + '/xlog';
  @State cachDir: string = getContext().cacheDir + '/xlog';
  @State levelIndex: number = 1;
  @State arrayLevel: Array<SelectOption> = [
    {value: 'VERBOSE'},
    {value: 'DEBUG'},
    {value: 'INFO'},
    {value: 'WARNING'},
    {value: 'ERROR'},
    {value: 'FATAL'},
    {value: 'NONE'}
  ];
  @State modeIndex: number = 1;
  @State arrayMode: Array<SelectOption> = [
    {value: 'APPENDER_MODE_ASYNC(异步)'},
    {value: 'APPENDER_MODE_SYNC(同步)'}
  ];
  @State compressModeIndex: number = 0;
  @State arrayCompressMode: Array<SelectOption> = [
    {value: 'ZLIB'},
    {value: 'ZSTD'}
  ];
  @State compressLevelIndex: number = 0;
  @State arrayCompressLevel: Array<SelectOption> = [
    {value: 'COMPRESS_LEVEL1'},
    {value: 'COMPRESS_LEVEL12'},
    {value: 'COMPRESS_LEVEL13'},
    {value: 'COMPRESS_LEVEL14'},
    {value: 'COMPRESS_LEVEL15'},
    {value: 'COMPRESS_LEVEL16'},
    {value: 'COMPRESS_LEVEL17'},
    {value: 'COMPRESS_LEVEL18'},
    {value: 'COMPRESS_LEVEL19'},
  ];
  @State cacheDays: number = 1;

  @State isConsole: boolean = false;
  @State tag: string = 'xlog_test'
  @State outLevelIndex: number = 1;
  @State arrayOutLevel: Array<SelectOption> = [
    {value: 'VERBOSE'},
    {value: 'DEBUG'},
    {value: 'INFO'},
    {value: 'WARNING'},
    {value: 'ERROR'},
    {value: 'FATAL'}
  ];

  public getConfig() : XLogConfig {
		return {
      level: this.levelIndex,
      mode: this.modeIndex,
      logdir: this.logPath,
      nameprefix: this.nameprefix,
      pubkey: this.pubKey,
      compressmode: this.compressModeIndex,
      compresslevel: this.compressLevelIndex+1,
      cachedir: this.cachDir,
      cachedays: this.cacheDays
    };
	}


  private showOutput(name: string, desc: string): void {
    console.log(`${name}: ${desc}`)
  }

  public showResult(name: string, result: number, desc?: string): void {
    if (result == 1) {
      this.showOutput(name, 'Sucess');
    } else if(result == 0) {
      this.showOutput(name, `Error: ${desc}`);
    } else {
      this.showOutput(name, `Please Check: ${desc}`)
    }
    prompt.showToast({
      message: `${desc}`,
      duration: 2000,
    });
  }

  aboutToAppear() {
  }

  aboutToDisappear() {
  }

  build() {
    Column({ space: 10 }) {
      Text('XLog Demo')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Scroll() {
        Column({ space: 5 }) {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text('日志级别:').width('15%').fontSize('30px').margin('15px')
            Select(this.arrayLevel)
              .width('85%')
              .height('40vp')
              .selected(this.levelIndex)
              .value(this.arrayLevel[this.levelIndex].value)
              .onSelect((index: number, value: String) => {
                this.levelIndex = index;
                this.showOutput('日志级别', this.arrayLevel[this.levelIndex].value.toString())
              })
          }
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text('Appender模式:').width('15%').fontSize('30px').margin('15px')
            Select(this.arrayMode)
              .width('85%')
              .height('40vp')
              .selected(this.modeIndex)
              .value(this.arrayMode[this.modeIndex].value)
              .onSelect((index: number, value: String) => {
                this.modeIndex = index;
                this.showOutput('Appender模式', this.arrayMode[this.modeIndex].value.toString())
              })
          }
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text('压缩模式:').width('15%').fontSize('30px').margin('15px')
            Select(this.arrayCompressMode)
              .width('85%')
              .height('40vp')
              .selected(this.compressModeIndex)
              .value(this.arrayCompressMode[this.compressModeIndex].value)
              .onSelect((index: number, value: String) => {
                this.compressModeIndex = index;
                this.showOutput('压缩模式', this.arrayCompressMode[this.compressModeIndex].value.toString())
              })
          }
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text('压缩级别:').width('15%').fontSize('30px').margin('15px')
            Select(this.arrayCompressLevel)
              .width('85%')
              .height('40vp')
              .selected(this.compressLevelIndex)
              .value(this.arrayCompressLevel[this.compressLevelIndex].value)
              .onSelect((index: number, value: String) => {
                this.compressLevelIndex = index;
                this.showOutput('压缩级别', this.arrayCompressLevel[this.compressLevelIndex].value.toString())
              })
          }
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text('名称前缀:').width('15%').fontSize('30px').margin('15px')
            TextInput({ placeholder: '请输入内容', text: this.nameprefix })
              .width('85%')
              .height('40vp')
              .onChange((value: string) => {
                this.nameprefix = value;
              })
          }
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text('日志路径:').width('15%').fontSize('30px').margin('15px')
            TextInput({ placeholder: '必须是沙箱路径', text: this.logPath })
              .width('85%')
              .height('40vp')
              .onChange((value: string) => {
                this.logPath = value;
                this.showOutput('日志路径', `${this.logPath}/${this.nameprefix}_xxxx.xlog`)
              })
          }
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text('cache路径:').width('15%').fontSize('30px').margin('15px')
            TextInput({ placeholder: '必须是沙箱路径', text: this.cachDir })
              .width('85%')
              .height('40vp')
              .onChange((value: string) => {
                this.cachDir = value;
                this.showOutput('cache路径', `${this.cachDir}/${this.nameprefix}_xxxx.xlog`)
              })
          }
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text(`保存天数(${this.cacheDays}):`).width('15%').fontSize('30px').margin('15px')
            Slider({
              value: this.cacheDays,
              min: 0,
              max: 10,
              step: 1,
              style: SliderStyle.OutSet
            })
              .width('85%')
              .blockColor(Color.Blue)
              .trackColor(Color.Gray)
              .selectedColor(Color.Blue)
              .showSteps(true)
              .showTips(true)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.cacheDays = value
              })
          }
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Button(`创建对象`).onClick(event => {
              console.log('Xlog_newXlogInstance ');
              this.showOutput('名称前缀', this.nameprefix)
              let xLogConfig: XLogConfig = this.getConfig()
              let ret = this.log?.createXlog(xLogConfig);
              if (ret) {
                this.log?.setConsoleLogOpen(this.isConsole)
              }
              this.showResult('创建', ret==false?0:1, `${this.cachDir}/${this.nameprefix}_xxxx.xlog`);
            }).width('100%')
            Button(`释放对象`).onClick(event => {
              if (this.log == null) {
                this.showOutput('错误信息', '已经被释放或没有创建')
                return;
              }
              this.log.release()
              this.showResult('释放', 1, `${this.cachDir}/${this.nameprefix}_xxxx.xlog`);
            }).width('100%')
          }
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text('输出日志级别:').width('15%').fontSize('30px').margin('15px')
            Select(this.arrayOutLevel)
              .width('85%')
              .height('40vp')
              .selected(this.outLevelIndex)
              .value(this.arrayOutLevel[this.outLevelIndex].value)
              .onSelect((index: number, value: String) => {
                this.outLevelIndex = index;
                this.showOutput('日志级别', this.arrayOutLevel[this.outLevelIndex].value.toString())
              })
          }
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text('输出tag:').width('15%').fontSize('30px').margin('15px')
            TextInput({ placeholder: '必须是沙箱路径', text: this.tag })
              .width('35%')
              .height('40vp')
              .onChange((value: string) => {
                this.tag = value;
                this.showOutput('输出tag', `${this.tag}`)
              })
            Text('输出到控制台:').width('15%').fontSize('30px').margin('15px')
            Toggle({ type: ToggleType.Switch, isOn: this.isConsole })
              .onChange((isOn: boolean) => {
                if (this.log == null) {
                  this.showOutput('错误信息', '已经被释放或没有创建')
                  return;
                }
                this.isConsole = isOn
                this.log?.setConsoleLogOpen(this.isConsole)
                this.showOutput('输出到控制台', `${this.isConsole?'是':'否'}`)
              })
              .width('35%')
          }
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Button(`输出日志`).onClick(event => {
              if (this.log == null) {
                this.showOutput(`输出日志`, '已经被释放或没有创建')
                return;
              }
              let logOut = ''
              switch (this.outLevelIndex) {
                case Xlog.LEVEL_VERBOSE:
                  logOut = 'verbose log'
                  this.log?.logV(this.tag, 'test.kkk', 'test', 37, logOut);
                  break;
                case Xlog.LEVEL_DEBUG:
                  logOut = 'debug log'
                  this.log?.logD(this.tag, 'test.kkk', 'test', 37, 'debug log');
                  break;
                case Xlog.LEVEL_INFO:
                  logOut = 'info log'
                  this.log?.logI(this.tag, 'test.kkk', 'test', 37, 'info log');
                  break;
                case Xlog.LEVEL_WARNING:
                  logOut = 'warn log'
                  this.log?.logW(this.tag, 'test.kkk', 'test', 37, 'warn log');
                  break;
                case Xlog.LEVEL_ERROR:
                  logOut = 'error log'
                  this.log?.logE(this.tag, 'test.kkk', 'test', 37, 'error log');
                  break;
                case Xlog.LEVEL_FATAL:
                  logOut = 'fatal log'
                  this.log?.logF(this.tag, 'test.kkk', 'test', 37, 'fatal log');
                  break;
              }
              if (this.isConsole) {
                this.showOutput('输出日志', `输出到控制台,测试时请检查输出。 tag: ${this.tag}, [test.kkk:37, test]:${logOut}`);
              } else {
                this.showOutput('输出日志', `输出到文件${this.cachDir}/${this.nameprefix}_xxxx.xlog,测试时请检查文件。  tag: ${this.tag}, [test.kkk:37, test]:${logOut}`);
              }
            }).width('100%')
          }
        }
        .margin({ bottom: 150, right: 20 })
      }
      .scrollable(ScrollDirection.Vertical).scrollBar(BarState.Auto)
      .scrollBarColor(Color.Blue).scrollBarWidth(20).height('100%')
    }.gridSpan(10)
  }
}