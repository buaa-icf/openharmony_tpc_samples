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
import sax from 'sax';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.


    it("attribute_name", 0, () => {
      let parser: ESObject = sax.parser(true, {
        xmlns: true
      })

      parser.onopentagstart = (nodeName: ESObject) => {
        expect(nodeName.node).assertEqual(undefined)
      };

      parser.onattribute = (nodeName: ESObject) => {
        expect(nodeName.value).assertEqual("12345")
      };

      parser.onopentag = (nodeName: ESObject) => {
        expect(nodeName.name).assertEqual("root")
      };

      parser.onclosetag = (nodeName: ESObject) => {
        expect(nodeName).assertEqual("root")
      };


      parser.write("<root length='12345'></root>");
      parser.end();

    })

    it("attribute_no_space_1", 0, () => {
      let parser: ESObject = sax.parser(false, {
        lowercase: true
      })
      parser.write('<root attr1="first"attr2="second"/>');
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };

      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("root")
      };
      parser.end();
    })

    it("attribute_no_space_2", 0, () => {
      let parser: ESObject = sax.parser(true, {})
      parser.write('<root attr1="first"attr2="second"/>');
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };
      parser.onerror = (a: ESObject) => {
        expect(a).assertEqual('No whitespace between attributes\nLine: 0\nColumn: 20\nChar: a')
      };

      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("root")
      };
      parser.end();
    })

    it("attribute_no_space_3", 0, () => {
      let parser: ESObject = sax.parser(true, {})
      parser.write('<root attr1="first"\nattr2="second"/>');
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };

      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("root")
      };
      parser.end();
    })

    it("attribute_no_space_4", 0, () => {
      let parser: ESObject = sax.parser(true, {})
      parser.write('<root attr1="first"  attr2="second"/>');
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };

      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("root")
      };
      parser.end();
    })

    it("attribute_unquoted", 0, () => {
      let parser: ESObject = sax.parser(false, {
        xmlns: true
      })
      parser.write('<root length=12').write('345></root>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("ROOT")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("ROOT")
      };

      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("ROOT")
      };
    })

    it("bom_1", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('\uFEFF<P></P>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("P")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("P")
      };

      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("P")
      };
    })

    it("bom_2", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('\uFEFF<P BOM="\uFEFF">\uFEFFStarts and ends with BOM\uFEFF</P>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("P")
      };
      parser.onattribute = (a: ESObject) => {
        expect(a.name).assertEqual("BOM")
      };
      parser.ontext = (a: ESObject) => {
        expect(a).assertEqual('\uFEFFStarts and ends with BOM\uFEFF')
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("P")
      };

      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("P")
      };
    })


    it("buffer_overrun", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('\uFEFF\uFEFF<P></P>')
        .write('<abcdefghijklmn')
        .write('opqrstuvwxyzABC')
        .write('DEFGHIJKLMNOPQR')
        .write('STUVWXYZ>')
        .write('yo')
        .write('</abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ>')
        .close()
      parser.onerror = (a: ESObject) => {
        expect(a).assertEqual('Max buffer length exceeded: tagName\nLine: 0\nColumn: 15\nChar: ')
      };
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ")
      };
      parser.ontext = (a: ESObject) => {
        expect(a).assertEqual('yo')
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ")
      };

      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("P")
      };
    })


    it("case", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('<span class="test" hello="world"></span>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("SPAN")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("SPAN")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("SPAN")
      };
    })

    it("cdata_chunked", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('<r><![CDATA[ this is ').write('character data  ').write(']]></r>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.oncdata = (a: ESObject) => {
        expect(a).assertEqual(" this is character data  ")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("R")
      };
    })

    it("cdata_end_split", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('<r><![CDATA[ this is ]')
        .write(']>')
        .write('</r>')
        .close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.oncdata = (a: ESObject) => {
        expect(a).assertEqual(" this is ")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("R")
      };
    })

    it("cdata_fake_end", 0, () => {
      let parser: ESObject = sax.parser(false)
      let x: string = '<r><![CDATA[[[[[[[[[]]]]]]]]]]></r>'
      for (let i = 0; i < x.length; i++) {
        parser.write(x.charAt(i))
      }
      parser.close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.oncdata = (a: ESObject) => {
        expect(a).assertEqual("[[[[[[[[]]]]]]]]")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("R")
      };
    })

    it("cdata_multiple", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('<r><![CDATA[ this is ]]>')
        .write('<![CDA')
        .write('T')
        .write('A[')
        .write('character data  ')
        .write(']]></r>')
        .close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.oncdata = (a: ESObject) => {
        expect(a).assertEqual("character data  ")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("R")
      };
    })

    it("cdata", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('<r><![CDATA[ this is character data  ]]></r>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.oncdata = (a: ESObject) => {
        expect(a).assertEqual(" this is character data  ")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("R")
      };
    })

    it("cyrillic", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('<Р>тест</Р>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("P")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("P")
      };
      parser.ontext = (a: ESObject) => {
        expect(a).assertEqual("тест")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("P")
      };
    })

    it("duplicate_attribute", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('<span id="hello" id="there"></span>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("SPAN")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("SPAN")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("SPAN")
      };
    })

    it("emoji", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('<a>&#x1f525;</a>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("A")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("A")
      };
      parser.ontext = (a: ESObject) => {
        expect(a).assertEqual("\ud83d\udd25")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("A")
      };
    })

    it("entities", 0, () => {
      let parser: ESObject = sax.parser(false)
      parser.write('<r>&rfloor; ' +
        '&spades; &copy; &rarr; &amp; ' +
        '&lt; < <  <   < &gt; &real; &weierp; &euro;</r>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.ontext = (a: ESObject) => {
        expect(a).assertEqual("⌋ ♠ © → & < < <  <   < > ℜ ℘ €")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("R")
      };
    })

    it("entity_attr", 0, () => {
      let parser: ESObject = sax.parser(false, {
        unparsedEntities: true
      })
      parser.ENTITIES.elem = '<B"/>';
      parser.write('<A ATTR="&elem;"/>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("A")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("A")
      };
      parser.onattribute = (a: ESObject) => {
        expect(a.name).assertEqual("ATTR")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("A")
      };
    })

    it("entity_elem", 0, () => {
      let parser: ESObject = sax.parser(false, {
        unparsedEntities: true
      })
      parser.ENTITIES.attr = "1";
      parser.ENTITIES.text = "2.&attr;";
      parser.ENTITIES.elem = '<B ATTR="&attr;.3"/>';
      parser.write('<A ATTR="&attr;.2">&text;&elem;</A>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("A")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("A")
      };
      parser.onattribute = (a: ESObject) => {
        expect(a.name).assertEqual("ATTR")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("A")
      };
    })


    it("entity_recursive", 0, () => {
      let parser: ESObject = sax.parser(false, {
        unparsedEntities: true
      })
      parser.ENTITIES.attr = "1";
      parser.ENTITIES.text = "2.&attr;";
      parser.write('<A>&text;</A>').close()
      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("A")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("A")
      };
      parser.ontext = (a: ESObject) => {
        expect(a).assertEqual("2.1")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("A")
      };
    })

    it("flush", 0, () => {
      let parser: ESObject = sax.parser(false)

      parser.write('<T>flush')
      parser.flush()
      parser.write('rest</T>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("T")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("T")
      };
      parser.ontext = (a: ESObject) => {
        expect(a).assertEqual("flush")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("T")
      };
    })

    it("issue_23", 0, () => {
      let parser: ESObject = sax.parser(false)

      parser.write('<compileClassesResponse>' +
        '<result>' +
        '<bodyCrc>653724009</bodyCrc>' +
        '<column>-1</column>' +
        '<id>01pG0000002KoSUIA0</id>' +
        '<line>-1</line>' +
        '<name>CalendarController</name>' +
        '<success>true</success>' +
        '</result>' +
        '</compileClassesResponse>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("COMPILECLASSESRESPONSE")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("COMPILECLASSESRESPONSE")
      };
      parser.ontext = (a: ESObject) => {
        expect(a).assertEqual("653724009")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("COMPILECLASSESRESPONSE")
      };
    })

    it("issue_30", 0, () => {
      let parser: ESObject = sax.parser(true)

      parser.write('<xml>\n' +
        '<!-- \n' +
        '  comment with a single dash- in it\n' +
        '-->\n' +
        '<data/>\n' +
        '</xml>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("xml")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("xml")
      };
      parser.ontext = (a: ESObject) => {
        expect(a).assertEqual("\n")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("xml")
      };
    })

    it("issue_35", 0, () => {
      let parser: ESObject = sax.parser(true)

      parser.write('<xml>&#Xd;&#X0d;\n</xml>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("xml")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("xml")
      };
      parser.ontext = (a: ESObject) => {
        expect(a).assertEqual("\r\r\n")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("xml")
      };
    })


    it("issue_49", 0, () => {
      let parser: ESObject = sax.parser(false)

      parser.write('<xml><script>hello world</script></xml>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("xml")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("xml")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("xml")
      };
    })

    it("issue_84", 0, () => {
      let parser: ESObject = sax.parser(false)

      parser.write('<?has unbalanced "quotes?><xml>body</xml>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("xml")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("xml")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("xml")
      };
    })

    it("issue_86", 0, () => {
      let parser: ESObject = sax.parser(false)

      parser.write('<root>abc</root>de<f')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("ROOT")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("ROOT")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("ROOT")
      };
    })
    it("opentagstart", 0, () => {
      let parser: ESObject = sax.parser(true)

      parser.write("<root length='12345'></root>")
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("true")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("true")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("true")
      };
    })


    it("script", 0, () => {
      let parser: ESObject = sax.parser(false)

      parser.write("<html><head><script>if (1 < 0) { console.log('elo there'); }</script></head></html>")
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("HTML")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("HTML")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("HTML")
      };
    })

    it("self_closing_child_strict", 0, () => {
      let parser: ESObject = sax.parser(true)

      parser.write('<root>' +
        '<child>' +
        '<haha />' +
        '</child>' +
        '<monkey>' +
        '=(|)' +
        '</monkey>' +
        '</root>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("root")
      };
    })

    it("self_closing_child", 0, () => {
      let parser: ESObject = sax.parser(false)

      parser.write('<root>' +
        '<child>' +
        '<haha />' +
        '</child>' +
        '<monkey>' +
        '=(|)' +
        '</monkey>' +
        '</root>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("ROOT")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("ROOT")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("ROOT")
      };
    })


    it("self_closing_tag", 0, () => {
      let parser: ESObject = sax.parser(false)

      parser.write('<root>   ' +
        '<haha /> ' +
        '<haha/>  ' +
        '<monkey> ' +
        '=(|)     ' +
        '</monkey>' +
        '</root>  ')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("ROOT")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("ROOT")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("ROOT")
      };
    })

    it("stand_alone_comment", 0, () => {
      let parser: ESObject = sax.parser(true)

      parser.write('<!-- stand alone comment -->')
      parser.close()

      parser.oncomment = (a: ESObject) => {
        expect(a).assertEqual(" stand alone comment ")
      };
    })


    it("stray_ending", 0, () => {
      let parser: ESObject = sax.parser(false)

      parser.write('<a><b></c></b></a>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("A")
      };
      parser.onopentag = (a: ESObject) => {
        expect(a.name).assertEqual("A")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("A")
      };
    })

    it("trailing_attribute_no_value", 0, () => {
      let parser: ESObject = sax.parser(false, {
        trim: true
      })

      parser.write('<root attrib>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("ROOT")
      };
      parser.onattribute = (a: ESObject) => {
        expect(a.name).assertEqual("ATTRIB")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("ATTRIB")
      };
    })


    it("trailing_non_whitespace", 0, () => {
      let parser: ESObject = sax.parser(false)

      parser.write('<span>Welcome,</span> to monkey land')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("SPAN")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("SPAN")
      };
    })


    it("unclosed_root", 0, () => {
      let parser: ESObject = sax.parser(true)

      parser.write('<root>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("root")
      };
    })

    it("unquoted", 0, () => {
      let parser: ESObject = sax.parser(false)

      parser.write('<span class=test hello=world></span>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("SPAN")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("SPAN")
      };
    })

    it("xml_entities", 0, () => {
      let parser: ESObject = sax.parser(false,{ strictEntities: true })

      parser.write( '<r>&rfloor; ' +
        '&spades; &copy; &rarr; &amp; ' +
        '&lt; < <  <   < &gt; &real; &weierp; &euro;</r>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("R")
      };
    })

    it("xmlns_as_tag_name", 0, () => {
      let parser: ESObject = sax.parser(false,{ strictEntities: true })

      parser.write( '<r>&rfloor; ' +
        '&spades; &copy; &rarr; &amp; ' +
        '&lt; < <  <   < &gt; &real; &weierp; &euro;</r>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("R")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("R")
      };
    })

    it("xmlns_rebinding", 0, () => {
      let parser: ESObject = sax.parser(true,{
        xmlns: true
      })

      parser.write( '<root xmlns:x="x1" xmlns:y="y1" x:a="x1" y:a="y1">' +
        '<rebind xmlns:x="x2">' +
        '<check x:a="x2" y:a="y1"/>' +
        '</rebind>' +
        '<check x:a="x1" y:a="y1"/>' +
        '</root>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("root")
      };
    })


    it("xmlns_strict", 0, () => {
      let parser: ESObject = sax.parser(true,{
        xmlns: true
      })

      parser.write( '<root>' +
        '<plain attr="normal" />' +
        '<ns1 xmlns="uri:default">' +
        '<plain attr="normal"/>' +
        '</ns1>' +
        '<ns2 xmlns:a="uri:nsa">' +
        '<plain attr="normal"/>' +
        '<a:ns a:attr="namespaced"/>' +
        '</ns2>' +
        '</root>')
      parser.close()

      parser.onopentagstart = (a: ESObject) => {
        expect(a.name).assertEqual("root")
      };
      parser.onclosetag = (a: ESObject) => {
        expect(a).assertEqual("root")
      };
    })

  })
}