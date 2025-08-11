/*
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import xmlbuilder from 'xmlbuilder';
import { describe, it, expect } from '@ohos/hypium'

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    it('test1', 0, () => {
      let xml: string = xmlbuilder.create('test4', {
        headless: true
      })
        .ele('node', 'element', {
          "first": "1", "second": "2"
        })
        .att("third", "3")
        .end()
      expect(xml).assertEqual('<test4><node first="1" second="2" third="3">element</node></test4>')
    })

    it('test2', 0, () => {
      let xml: string = xmlbuilder.create('test4', {
        headless: true
      })
        .ele('node').att({
          "first": "1", "second": "2"
        })
        .end()
      expect(xml).assertEqual('<test4><node first="1" second="2"/></test4>')
    })

    it('test3', 0, () => {
      let xml: string = xmlbuilder.create('test4', {
        headless: true
      })
        .ele('node', 'element', {
          "first": "1", "second": "2", "third": "3"
        })
        .removeAttribute("second")
        .end()
      expect(xml).assertEqual('<test4><node first="1" third="3">element</node></test4>')
    })

    it('test4', 0, () => {
      let xml: string = xmlbuilder.create('test4', {
        headless: true
      })
        .ele('node', 'element', {
          "first": "1", "second": "2", "third": "3"
        })
        .removeAttribute(["second", "third"])
        .end()
      expect(xml).assertEqual('<test4><node first="1">element</node></test4>')
    })

    it('test5', 0, () => {
      let xml: string = xmlbuilder.create('test', {
        headless: true
      })
        .ele('node', 'element', {
          "first": "", "second": "2", "third": ""
        })
        .end()
      expect(xml).assertEqual('<test><node first="" second="2" third="">element</node></test>')
    })

    it('test6', 0, () => {
      let xml: string = xmlbuilder.create('test4', {
        headless: true
      })
        .ele('node', 'element', {
          "first": null, "second": '2'
        })
        .end()
      expect(xml).assertEqual('<test4><node second="2">element</node></test4>')
    })

    it('test7', 0, () => {
      let xml: string = xmlbuilder.create('test4', {
        headless: true
      })
        .ele('node').att("first")
        .end()
      expect(xml).assertEqual('<test4><node/></test4>')
    })

    it('test8', 0, () => {
      let xml: string = xmlbuilder.create('test4', {
        headless: true
      })
        .ele({
          '@first': null, '@second': '2'
        })
        .end()
      expect(xml).assertEqual('<test4 second="2"/>')
    })

    it('test9', 0, () => {
      let xml: string = xmlbuilder.create('test4', {
        headless: true, keepNullAttributes: true
      })
        .ele('node', 'element', {
          "first": null, "second": '2'
        })
        .end()
      expect(xml).assertEqual('<test4><node first="" second="2">element</node></test4>')
    })

    it('test10', 0, () => {
      let xml: string = xmlbuilder.create('test4', {
        headless: true, keepNullAttributes: true
      })
        .ele('node').att("first")
        .end()
      expect(xml).assertEqual('<test4><node first=""/></test4>')
    })

    it('test11', 0, () => {
      let xml: string = xmlbuilder.create('test4', {
        headless: true, keepNullAttributes: true
      })
        .ele({
          '@first': null, '@second': '2'
        })
        .end()
      expect(xml).assertEqual('<test4 first="" second="2"/>')
    })

    it('test12', 0, () => {
      let xml: string = xmlbuilder.create('test4', {
        headless: true, keepNullAttributes: true
      })
        .ele({
          '@first': null, '@second': '2'
        })
        .end()
      expect(xml).assertEqual('<test4 first="" second="2"/>')
    })

    it('test13', 0, () => {
      let xml: string = xmlbuilder.begin({
        headless: true
      } as ESObject).ele('root', {
        att: 'val'
      } as ESObject).ele('test').end()
      expect(xml).assertEqual('<root att="val"><test/></root>')
    })

    it('test14', 0, () => {
      let xml: string = xmlbuilder.begin()
        .dec()
        .dtd()
        .up()
        .ele('root')
        .end()
      expect(xml).assertEqual('<?xml version="1.0"?><!DOCTYPE root><root/>')
    })

    it('test15', 0, () => {
      let xml: string = xmlbuilder.create('test', {}, {}, {
        headless: true
      })
        .cdata('foo and <![CDATA[<foo>bar</foo>]]> bar')
        .end()
      expect(xml).assertEqual('<test><![CDATA[foo and <![CDATA[<foo>bar</foo>]]]]><![CDATA[> bar]]></test>')
    })

    it('test16', 0, () => {
      let xml: string = xmlbuilder.create('comment', {
        headless: true
      })
        .comment('<>\'"&\t\n\r').end()
      expect(xml).assertEqual('<comment><!-- <>\'"&\t\n\r --></comment>')
    })

    it('test17', 0, () => {
      let xml: string = xmlbuilder.create('comment', {
        headless: true
      })
        .commentBefore('pre').commentAfter('post').end()
      expect(xml).assertEqual('<!-- pre --><comment/><!-- post -->')
    })

    it('test18', 0, () => {
      let xml: string = xmlbuilder.create('root')
        .ele('xmlbuilder')
        .att('for', 'node-js')
        .com('CoffeeScript is awesome.')
        .nod('repo')
        .att('type', 'git')
        .txt('git://github.com/oozcitak/xmlbuilder-js.git')
        .up()
        .up()
        .ele('cdata')
        .cdata('<test att="val">this is a test</test>\nSecond line')
        .up()
        .ele('raw')
        .raw('&<>&')
        .up()
        .ele('atttest', {
          'att': 'val'
        }, 'text')
        .up()
        .ele('atttest', 'text')
        .end()
      expect(xml).assertEqual('<?xml version="1.0"?>' +
        '<root>' +
        '<xmlbuilder for="node-js">' +
        '<!-- CoffeeScript is awesome. -->' +
        '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
        '</xmlbuilder>' +
        '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
        '<raw>&<>&</raw>' +
        '<atttest att="val">text</atttest>' +
        '<atttest>text</atttest>' +
        '</root>')
    })

    it('test19', 0, () => {
      let xml: string = xmlbuilder.create('root')
        .ele('xmlbuilder', {
          'for': 'node-js'
        })
        .com('CoffeeScript is awesome.')
        .nod('repo', {
          'type': 'git'
        }, 'git://github.com/oozcitak/xmlbuilder-js.git')
        .up()
        .up()
        .ele('cdata')
        .cdata('<test att="val">this is a test</test>\nSecond line')
        .up()
        .ele('raw')
        .raw('&<>&')
        .up()
        .ele('atttest', {
          'att': 'val'
        }, 'text')
        .up()
        .ele('atttest', 'text')
        .att('att', () => 'val')
        .end()
      expect(xml).assertEqual('<?xml version="1.0"?>' +
        '<root>' +
        '<xmlbuilder for="node-js">' +
        '<!-- CoffeeScript is awesome. -->' +
        '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
        '</xmlbuilder>' +
        '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
        '<raw>&<>&</raw>' +
        '<atttest att="val">text</atttest>' +
        '<atttest att="val">text</atttest>' +
        '</root>')
    })

    it('test20', 0, () => {
      let xml: string = xmlbuilder.create('root')
        .e('xmlbuilder', {
          'for': 'node-js'
        })
        .c('CoffeeScript is awesome.')
        .n('repo', {
          'type': 'git'
        }, 'git://github.com/oozcitak/xmlbuilder-js.git')
        .u()
        .u()
        .e('cdata')
        .d('<test att="val">this is a test</test>\nSecond line')
        .u()
        .e('raw')
        .r('&<>&')
        .u()
        .e('atttest', {
          'att': 'val'
        }, 'text')
        .u()
        .e('atttest')
        .a('att2', 'val2')
        .i('pi', 'pival')
        .t('text2')
        .end()
      expect(xml).assertEqual('<?xml version="1.0"?>' +
        '<root>' +
        '<xmlbuilder for="node-js">' +
        '<!-- CoffeeScript is awesome. -->' +
        '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
        '</xmlbuilder>' +
        '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
        '<raw>&<>&</raw>' +
        '<atttest att="val">text</atttest>' +
        '<atttest att2="val2"><?pi pival?>text2</atttest>' +
        '</root>')
    })

    it('test21', 0, () => {
      let xml: string = xmlbuilder.create('test14').ele('node').txt('test').end()
      expect(xml).assertEqual('<?xml version="1.0"?><test14><node>test</node></test14>')
    })

    it('test22', 0, () => {
      let xml: string = xmlbuilder.create('test14', {
        'version': '1.1'
      }).ele('node').txt('test').end()
      expect(xml).assertEqual('<?xml version="1.1"?><test14><node>test</node></test14>')
    })

    it('test23', 0, () => {
      let xml: string = xmlbuilder.create('test14', {
        version: '1.1', encoding: 'UTF-8', standalone: true, sysID: 'hello.dtd'
      })
        .ele('node').txt('test').end()
      expect(xml).assertEqual('<?xml version="1.1" encoding="UTF-8" standalone="yes"?>' +
        '<!DOCTYPE test14 SYSTEM "hello.dtd"><test14><node>test</node></test14>')
    })

    it('test24', 0, () => {
      let xml: string = xmlbuilder.create('test14', {
        headless: true,
        version: '1.1',
        encoding: 'UTF-8',
        standalone: true,
        sysID: 'hello.dtd'
      })
        .ele('node').txt('test').end()
      expect(xml).assertEqual('<test14><node>test</node></test14>')
    })

    it('test25', 0, () => {
      let xml: string = xmlbuilder.create('test15', {
        headless: true
      })
        .ele('node').end({
          allowEmpty: true
        })
      expect(xml).assertEqual('<test15><node></node></test15>')
    })

    it('test26', 0, () => {
      let xml: string = xmlbuilder.create('test7', {}, {}, {
        headless: true
      })
        .ele('nodes')
        .ele('node', '1')
        .up()
        .ele('node', '2')
        .up()
        .ele('node', '3')
        .end()
      expect(xml).assertEqual('<test7><nodes><node>1</node><node>2</node><node>3</node></nodes></test7>')
    })

    it('test27', 0, () => {
      let xml: string = xmlbuilder.create('root', {
        sysID: 'hello.dtd'
      }).ele('node').txt('test').end()
      expect(xml).assertEqual('<?xml version="1.0"?><!DOCTYPE root SYSTEM "hello.dtd"><root><node>test</node></root>')
    })

    it('test28', 0, () => {
      let xml: string = xmlbuilder.create('HTML', {
        pubID: '-//W3C//DTD HTML 4.01//EN',
        sysID: 'http://www.w3.org/TR/html4/strict.dtd'
      }).end()
      expect(xml).assertEqual('<?xml version="1.0"?>' +
        '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" ' +
        '"http://www.w3.org/TR/html4/strict.dtd">' +
        '<HTML/>')
    })

    it('test29', 0, () => {
      let xml: string = xmlbuilder.create('root', {
        sysID: ''
      }).ele('node').txt('test').end()
      expect(xml).assertEqual('<?xml version="1.0"?><!DOCTYPE root><root><node>test</node></root>')
    })

    it('test30', 0, () => {
      let xml: string = xmlbuilder.create('root')
        .dtd('hello.dtd')
        .up()
        .ele('node')
        .txt('test')
        .dtd('bye.dtd')
        .end()
      expect(xml).assertEqual('<?xml version="1.0"?><!DOCTYPE root SYSTEM "bye.dtd"><root><node>test</node></root>')
    })

    it('test31', 0, () => {
      let xml: string = xmlbuilder.create('root')
        .dtd('hello.dtd')
        .ins('pub_border', 'thin')
        .ele('img', 'EMPTY')
        .com('Image attributes follow')
        .att('img', 'height', 'CDATA', '#REQUIRED')
        .att('img', 'visible', '(yes|no)', '#DEFAULT', "yes")
        .not('fs', {
          sysID: 'http://my.fs.com/reader'
        })
        .not('fs-nt', {
          pubID: 'FS Network Reader 1.0'
        })
        .not('fs-nt', {
          pubID: 'FS Network Reader 1.0', sysID: 'http://my.fs.com/reader'
        })
        .att('img', 'src', 'NOTATION (fs|fs-nt)', '#REQUIRED')
        .dat('<owner>John</owner>')
        .ele('node')
        .ent('ent', 'my val')
        .ent('ent', {
          sysID: 'http://www.myspec.com/ent'
        })
        .ent('ent', {
          pubID: '-//MY//SPEC ENT//EN', sysID: 'http://www.myspec.com/ent'
        })
        .ent('ent', {
          sysID: 'http://www.myspec.com/ent', nData: 'entprg'
        })
        .ent('ent', {
          pubID: '-//MY//SPEC ENT//EN', sysID: 'http://www.myspec.com/ent', nData: 'entprg'
        })
        .pent('ent', 'my val')
        .pent('ent', {
          sysID: 'http://www.myspec.com/ent'
        })
        .pent('ent', {
          pubID: '-//MY//SPEC ENT//EN', sysID: 'http://www.myspec.com/ent'
        })
        .ele('nodearr', ['a', 'b'])
        .root()
        .ele('node')
        .txt('test')
        .end()
      expect(xml).assertEqual('<?xml version="1.0"?>' +
        '<!DOCTYPE root SYSTEM "hello.dtd" [' +
        '<?pub_border thin?>' +
        '<!ELEMENT img EMPTY>' +
        '<!-- Image attributes follow -->' +
        '<!ATTLIST img height CDATA #REQUIRED>' +
        '<!ATTLIST img visible (yes|no) "yes">' +
        '<!NOTATION fs SYSTEM "http://my.fs.com/reader">' +
        '<!NOTATION fs-nt PUBLIC "FS Network Reader 1.0">' +
        '<!NOTATION fs-nt PUBLIC "FS Network Reader 1.0" "http://my.fs.com/reader">' +
        '<!ATTLIST img src NOTATION (fs|fs-nt) #REQUIRED>' +
        '<![CDATA[<owner>John</owner>]]>' +
        '<!ELEMENT node (#PCDATA)>' +
        '<!ENTITY ent "my val">' +
        '<!ENTITY ent SYSTEM "http://www.myspec.com/ent">' +
        '<!ENTITY ent PUBLIC "-//MY//SPEC ENT//EN" "http://www.myspec.com/ent">' +
        '<!ENTITY ent SYSTEM "http://www.myspec.com/ent" NDATA entprg>' +
        '<!ENTITY ent PUBLIC "-//MY//SPEC ENT//EN" "http://www.myspec.com/ent" NDATA entprg>' +
        '<!ENTITY % ent "my val">' +
        '<!ENTITY % ent SYSTEM "http://www.myspec.com/ent">' +
        '<!ENTITY % ent PUBLIC "-//MY//SPEC ENT//EN" "http://www.myspec.com/ent">' +
        '<!ELEMENT nodearr (a,b)>' +
        ']>' +
        '<root><node>test</node></root>')
    })

    it('test32', 0, () => {
      let xml: string = xmlbuilder.create('root', {
        headless: true
      })
        .ele('e', 'escaped <>\'"&\t\n')
        .up()
        .ele('e', 'escaped <>\'"&\t\r\n')
        .up()
        .ele('e', 'escaped <>\'"&\t\n\r')
        .up()
        .ele('e')
        .att('a1', 'escaped <>\'"&\t\n')
        .att('a2', 'escaped <>\'"&\t\r')
        .att('a3', 'escaped <>\'"&\t\n\r')
        .att('a4', 'escaped <>\'"&\t\r\n')
        .up()
        .end()
      expect(xml).assertEqual('<root>' +
        '<e>escaped &lt;&gt;\'"&amp;\t\n</e>' +
        '<e>escaped &lt;&gt;\'"&amp;\t&#xD;\n</e>' +
        '<e>escaped &lt;&gt;\'"&amp;\t\n&#xD;</e>' +
        '<e' +
        ' a1="escaped &lt;>\'&quot;&amp;&#x9;&#xA;"' +
        ' a2="escaped &lt;>\'&quot;&amp;&#x9;&#xD;"' +
        ' a3="escaped &lt;>\'&quot;&amp;&#x9;&#xA;&#xD;"' +
        ' a4="escaped &lt;>\'&quot;&amp;&#x9;&#xD;&#xA;"' +
        '/>' +
        '</root>')
    })

    it('test33', 0, () => {
      let xml: string = xmlbuilder.create('root', {}, {}, {
        headless: true
      })
        .ele('xmlbuilder', {
          'for': 'node-js'
        })
        .ele('repo', {
          'type': 'git'
        }, 'git://github.com/oozcitak/xmlbuilder-js.git')
        .end()
      expect(xml).assertEqual('<root>' +
        '<xmlbuilder for="node-js">' +
        '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
        '</xmlbuilder>' +
        '</root>')
    })

    it('test34', 0, () => {
      let xml: string = xmlbuilder.create('test6', {}, {}, {
        headless: true
      })
        .e('node', 'last')
        .insertBefore('node', '1')
        .insertAfter('node', '2')
        .end()
      expect(xml).assertEqual('<test6><node>1</node><node>2</node><node>last</node></test6>')
    })

    it('test35', 0, () => {
      let xml: string = xmlbuilder.create('test17', {
        headless: true
      }).ins('pi', 'mypi').end()
      expect(xml).assertEqual('<test17><?pi mypi?></test17>')
    })

    it('test36', 0, () => {
      let xml: string = xmlbuilder.create('test17', {
        headless: true
      }).ins({
        'pi': 'mypi', 'pi2': 'mypi2', 'pi3': null
      }).end()
      expect(xml).assertEqual('<test17><?pi mypi?><?pi2 mypi2?><?pi3?></test17>')
    })

    it('test37', 0, () => {
      let xml: string = xmlbuilder.create('test17', {
        headless: true
      }).ins(['pi', 'pi2']).end()
      expect(xml).assertEqual('<test17><?pi?><?pi2?></test17>')
    })

    it('test38', 0, () => {
      let xml: string = xmlbuilder.create('test18', {
        headless: true
      })
        .ins('renderCache.subset', '"Verdana" 0 0 ISO-8859-1 4 268 67 "#(),-./')
        .ins('pitarget', () => 'pivalue')
        .end()
      expect(xml)
        .assertEqual('<test18><?renderCache.subset "Verdana" 0 0 ISO-8859-1 4 268 67 "#(),-./?><?pitarget pivalue?></test18>')
    })

    it('test39', 0, () => {
      let xml: string = xmlbuilder.create('ins', {
        headless: true
      })
        .instructionBefore('pre', 'val1').instructionAfter('post', 'val2').end()
      expect(xml).assertEqual('<?pre val1?><ins/><?post val2?>')
    })

    it('test40', 0, () => {
      let xml: string = xmlbuilder.create('first').ele('node1', {
        'testatt1': 'testattval1'
      }, 'text1').end()
      expect(xml).assertEqual('<?xml version="1.0"?><first><node1 testatt1="testattval1">text1</node1></first>')
    })

    it('test41', 0, () => {
      let xml: string = xmlbuilder.create('second').ele('node2', {
        'testatt2': 'testattval2'
      }, 'text2').end()
      expect(xml).assertEqual('<?xml version="1.0"?><second><node2 testatt2="testattval2">text2</node2></second>')
    })

    it('test42', 0, () => {
      let xml: string = xmlbuilder.create('test5', {
        headless: true
      })
        .e('node', '1')
        .up()
        .e('node', 'element')
        .up()
        .e('node', '2')
        .prev()
        .prev()
        .att('prev', 'yes')
        .next()
        .next()
        .att('next', 'yes')
        .root()
        .att('root', 'yes')
        .end()
      expect(xml)
        .assertEqual('<test5 root="yes"><node prev="yes">1</node><node>element</node><node next="yes">2</node></test5>')
    })


    it('test43', 0, () => {
      let xml: string = xmlbuilder.create('test', {
        headless: true
      })
        .dtd()
        .com('internal subset')
        .up()
        .ele('node')
        .end()
      expect(xml).assertEqual('<!DOCTYPE test [<!-- internal subset -->]>' + '<test><node/></test>')
    })

    it('test44', 0, () => {
      let xml: string = xmlbuilder.create('test3', {}, {}, {
        headless: true
      })
        .e('node', 'first instance')
        .u()
        .e('node', 'second instance')
        .remove()
        .e('node', 'third instance')
        .end()
      expect(xml).assertEqual('<test3><node>first instance</node><node>third instance</node></test3>')
    })

    it('test45', 0, () => {
      let xml: string = xmlbuilder.create('test', {
        headless: true
      })
        .ele('node1', 'val1')
        .up()
        .ele('node2', null)
        .up()
        .ele('node3', undefined)
        .up()
        .ele('node4', 'val4')
        .up()
        .ele('node5', '')
        .up()
        .ele('node6', {
          att: 'val'
        })
        .up()
        .end()
      expect(xml).assertEqual('<test>' +
        '<node1>val1</node1>' +
        '<node3/>' +
        '<node4>val4</node4>' +
        '<node5/>' +
        '<node6 att="val"/>' +
        '</test>')
    })

    it('test46', 0, () => {
      let xml: string = xmlbuilder.create('test', {
        headless: true
      })
        .ele({
          node1: 'val1',
          node2: null,
          node3: undefined,
          node4: 'val4',
          node5: ''
        })
        .end()
      expect(xml).assertEqual('<test>' +
        '<node1>val1</node1>' +
        '<node4>val4</node4>' +
        '<node5/>' +
        '</test>')
    })


    it('test47', 0, () => {
      let xml: string = xmlbuilder.create('test', {
        headless: true, keepNullNodes: true
      })
        .ele('node1', 'val1')
        .up()
        .ele('node2', null)
        .up()
        .ele('node3', undefined)
        .up()
        .ele('node4', 'val4')
        .up()
        .ele('node5', '')
        .up()
        .end()
      expect(xml).assertEqual('<test>' +
        '<node1>val1</node1>' +
        '<node2/>' +
        '<node3/>' +
        '<node4>val4</node4>' +
        '<node5/>' +
        '</test>')
    })

    it('test48', 0, () => {
      let xml: string = xmlbuilder.create('test', {
        headless: true, keepNullNodes: true
      })
        .ele({
          node1: 'val1',
          node2: null,
          node3: undefined,
          node4: 'val4',
          node5: ''
        })
        .end()
      expect(xml).assertEqual('<test>' +
        '<node1>val1</node1>' +
        '<node2/>' +
        '<node3/>' +
        '<node4>val4</node4>' +
        '<node5/>' +
        '</test>')
    })


    it('test49', 0, () => {
      let xml: string = xmlbuilder.create('test16', {
        'version': '1.1'
      }).ele('node').txt('test').end()
      expect(xml).assertEqual('<?xml version="1.1"?><test16><node>test</node></test16>')
    })

    it('test50', 0, () => {
      let xml: string = xmlbuilder.create('test').doc().end()
      expect(xml).assertEqual('<?xml version="1.0"?><test/>')
    })

    it('test51', 0, () => {
      let addns = (val: ESObject) => 'my:' + val
      let xml: string = xmlbuilder.create('test7', {
        headless: true, stringify: {
          name: addns
        }
      })
        .ele('nodes')
        .ele('node', '1')
        .up()
        .ele('node', '2')
        .up()
        .ele('node', '3')
        .end()
      expect(xml)
        .assertEqual('<my:test7><my:nodes><my:node>1</my:node><my:node>2</my:node><my:node>3</my:node></my:nodes></my:test7>')
    })

    it('test52', 0, () => {
      let xml: string = xmlbuilder.create('test8', {}, {}, {
        headless: true
      }).ele('node', '"').end()
      expect(xml).assertEqual('<test8><node>"</node></test8>')
    })

    it('test53', 0, () => {
      let xml: string = xmlbuilder.create('test9', {}, {}, {
        headless: true
      }).text('').end()
      expect(xml).assertEqual('<test9/>')
    })

    it('test54', 0, () => {
      let xml: string = xmlbuilder.create('test10', {}, {}, {
        headless: true
      }).text('').end()
      expect(xml).assertEqual('<test10/>')
    })

    it('test55', 0, () => {

      expect(xmlbuilder.create('root').doc().toString()).assertEqual('<?xml version="1.0"?><root/>')
      expect(xmlbuilder.create('root').toString()).assertEqual('<root/>')
      expect(xmlbuilder.create('root').att('att', 'val').attribs['att'].toString()).assertEqual(' att="val"')
      expect(xmlbuilder.create('root').dat('val').children[0].toString()).assertEqual('<![CDATA[val]]>')
      expect(xmlbuilder.create('root').com('val').children[0].toString()).assertEqual('<!-- val -->')
      expect(xmlbuilder.create('root').ins('target', 'val').children[0].toString()).assertEqual('<?target val?>')
      expect(xmlbuilder.create('root').text('val').children[0].toString()).assertEqual('val')

    })

    it('test56', 0, () => {
      let xml: string = xmlbuilder.create('root').dtd({
        pubID: 'pub', sysID: 'sys'
      }).toString()
      expect(xml).assertEqual('<!DOCTYPE root PUBLIC "pub" "sys">')
    })

    it('test57', 0, () => {
      let xml: string = xmlbuilder.create('root')
        .dtd()
        .att('img', 'visible', '(yes|no)', '#DEFAULT', "yes")
        .children[0]
        .toString()
      expect(xml).assertEqual('<!ATTLIST img visible (yes|no) "yes">')
    })

    it('test58', 0, () => {
      let xml: string = xmlbuilder.create('root')
        .dtd()
        .ele('img', 'EMPTY')
        .children[0]
        .toString()
      expect(xml).assertEqual('<!ELEMENT img EMPTY>')
    })

    it('test59', 0, () => {
      let xml: string = xmlbuilder.create('root')
        .dtd()
        .ent('ent', 'my val')
        .children[0]
        .toString()
      expect(xml).assertEqual('<!ENTITY ent "my val">')
    })

    it('test60', 0, () => {
      let xml: string = xmlbuilder.create('root')
        .dtd()
        .not('fs', {
          sysID: 'http://my.fs.com/reader'
        })
        .children[0]
        .toString()
      expect(xml).assertEqual('<!NOTATION fs SYSTEM "http://my.fs.com/reader">')
    })


    it('test61', 0, () => {
      let xml: string = xmlbuilder.create('root')
        .dec()
        .doc()
        .children[0]
        .toString()
      expect(xml).assertEqual('<?xml version="1.0"?>')
    })

    it('test62', 0, () => {
      let xml: string = xmlbuilder.create('test').end()
      expect(xml).assertEqual('<?xml version="1.0"?><test/>')
    })

    it('test63', 0, () => {
      let xml: string = xmlbuilder.create('test', {
        version: '1.1', encoding: 'UTF-8', standalone: true
      }).end()
      expect(xml).assertEqual('<?xml version="1.1" encoding="UTF-8" standalone="yes"?><test/>')
    })

    it('test64', 0, () => {
      let xml: string = xmlbuilder.create('test', {
        headless: true
      }).dec().ele('node').end()
      expect(xml).assertEqual('<?xml version="1.0"?><test><node/></test>')
    })

    it('test65', 0, () => {
      let xml: string = xmlbuilder.create('test').dec({
        version: '1.1', encoding: 'UTF-8', standalone: true
      }).ele('node').end()
      expect(xml).assertEqual('<?xml version="1.1" encoding="UTF-8" standalone="yes"?><test><node/></test>')
    })

  })
}