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
import * as sourceMap from 'source-map-js'

@Entry
@Component
struct Index {
  @State message: string = 'Test'
  @State public SourceMapGenerator: string = ""
  @State public SourceMapConsumer: boolean = true
  @State public SourceNode: String = ''

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('generator')
          .width('90%')
          .height(50)
          .margin({
            bottom: 10
          })
          .onClick(() => {
            this.generatorClick()
          })
        Text("结果 :" + this.SourceMapGenerator)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: "30px" })
        Button('consuming')
          .width('90%')
          .height(50)
          .margin({
            bottom: 10
          })
          .onClick(() => {
            this.consumingClick()
          })
        Text("结果 :" + this.SourceMapConsumer)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: "30px" })
        Button('node')
          .width('90%')
          .height(50)
          .margin({
            bottom: 10
          })
          .onClick(() => {
            this.nodeClick()
          })
        Text("结果 :" + this.SourceNode)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: "30px" })
      }
      .width('100%')
    }
    .height('100%')
  }

  generatorClick() {
    let map = new sourceMap.SourceMapGenerator({
      file: "source-mapped.js"
    });

    map.addMapping({
      generated: {
        line: 10,
        column: 35
      },
      source: "foo.js",
      original: {
        line: 33,
        column: 2
      },
      name: "christopher"
    });
    this.SourceMapGenerator = map.toString()
  }

  consumingClick() {
    class RawSourceMap {
      version: string = '';
      sources: string[] | ESObject;
      names: string[] | ESObject;
      sourcesContent?: string[];
      mappings: string = '';
    }

    let testMap: RawSourceMap = {
      version: '3',
      names: ['bar', 'baz', 'n'],
      sources: ['one.js', 'two.js'],
      sourcesContent: ['/the/root'],
      mappings: 'CAAC,IAAI,IAAM,SAAUA,GAClB,OAAOC,IAAID;CCDb,IAAI,IAAM,SAAUE,GAClB,OAAOA'
    };
    let smc = new sourceMap.SourceMapConsumer(testMap);
    this.SourceMapConsumer = smc.hasContentsOfAllSources()
  }

  nodeClick() {
    let node = new sourceMap.SourceNode(1, 2, "a.cpp", 'hello world');
    node.replaceRight('world', 'universe');
    this.SourceNode = node.toString();
  }
}