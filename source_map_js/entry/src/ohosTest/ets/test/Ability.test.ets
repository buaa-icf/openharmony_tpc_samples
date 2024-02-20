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
import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import * as sourceMap from 'source-map-js'

export default function abilityTest() {
  describe('ActsAbilityTest', ()=> {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(()=> {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(()=> {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(()=> {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(()=> {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('assertContain',0, ()=> {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let a = 'abc'
      let b = 'b'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b)
      expect(a).assertEqual(a)
    })
    it('test01',0, ()=> {
      let node:ESObject = new sourceMap.SourceNode(1, 2, "a.cpp");
      node.prepend('function noop() {}');
      expect(node.children.length).assertDeepEquals(1)
    })
    it('test02',0, ()=> {
      let node:ESObject = new sourceMap.SourceNode(1, 2, "a.cpp");
      expect(node.toString()).assertDeepEquals("")
    })
    it('test03',0, ()=> {
      let node:ESObject = new sourceMap.SourceNode(1, 2, "a.cpp");
      node.join(', ')
      expect(node.children.length).assertDeepEquals(0)
    })
    it('test04',0, ()=> {
      let node:ESObject = new sourceMap.SourceNode(1, 2, "a.cpp");
      node.add('function noop() {}')
      expect(node.children.length).assertDeepEquals(1)
    })
    it('test05',0, ()=> {
      let node:ESObject = new sourceMap.SourceNode(1, 2, "a.cpp");
      node.setSourceContent('function noop() {}','abc')
      expect(node.children.length).assertDeepEquals(0)
    })
    it('test06',0, ()=> {
      let node = new sourceMap.SourceNode(1, 2, "a.cpp", 'hello world');
      node.replaceRight('world', 'universe');
      expect(node.toString()).assertDeepEquals('hello universe')
    })
    it('test07',0, ()=> {
      let map = new sourceMap.SourceMapGenerator({
        file: 'foo.js',
        sourceRoot: '.'
      });
      expect(map.toString()).assertDeepEquals(JSON.stringify(map))
    })
    it('test08',0, ()=> {
      let map:ESObject = new sourceMap.SourceMapGenerator({
        file: 'min.js',
        sourceRoot: '/the/root'
      });
      map.addMapping({
        generated: { line: 1, column: 1 },
        original: { line: 1, column: 1 },
        source: 'one.js'
      });
      map.addMapping({
        generated: { line: 2, column: 1 },
        original: { line: 1, column: 1 },
        source: 'two.js'
      });
      map.setSourceContent('one.js', 'one file content');

      map = JSON.parse(map.toString());
      expect(map.sources[0]).assertDeepEquals('one.js')
    })
    it('test09',0, ()=> {
      class RawSourceMap {
        version: string = '';
        sources: string[]|ESObject;
        names: string[]|ESObject;
        sourcesContent?: string[];
        mappings: string = '';
      }
      let testMap:RawSourceMap= {
        version: '3',
        names: ['bar', 'baz', 'n'],
        sources: ['one.js', 'two.js'],
        sourcesContent: ['/the/root'],
        mappings: 'CAAC,IAAI,IAAM,SAAUA,GAClB,OAAOC,IAAID;CCDb,IAAI,IAAM,SAAUE,GAClB,OAAOA'
      };
      let map:ESObject = new sourceMap.SourceMapConsumer(testMap);
      expect(map.sourceContentFor('abc',true)).assertDeepEquals(null)
    })
    it('test10',0, ()=> {
      class RawSourceMap {
        version: string = '';
        sources: string[]|ESObject;
        names: string[]|ESObject;
        sourcesContent?: string[];
        mappings: string = '';
      }
      let testMap:RawSourceMap= {
        version: '3',
        names: ['bar', 'baz', 'n'],
        sources: ['one.js', 'two.js'],
        sourcesContent: ['/the/root'],
        mappings: 'CAAC,IAAI,IAAM,SAAUA,GAClB,OAAOC,IAAID;CCDb,IAAI,IAAM,SAAUE,GAClB,OAAOA'
      };
      let map:ESObject = new sourceMap.SourceMapConsumer(testMap);
      expect(map.hasContentsOfAllSources()).assertDeepEquals(false)
    })
  })
}