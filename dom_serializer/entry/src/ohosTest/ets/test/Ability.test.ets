/**
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

import { describe, it, expect } from '@ohos/hypium';
import { DomSerializerOptions, render } from "dom-serializer";
import { Document, DomUtils, parseDocument } from "@ohos/htmlparser2";

const htmlStr = `
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
<body>
    <h1 class="tagh1">
        kkkk
        <p>hhhhh</p>
    </h1>
    <div style="color:red; height:100px;" class="one-div">cshi</div>
    <img src="https:baidu.com" alt="wwww"/>
    <p>wjdwekfe</p>
    <em>dsjfw
    <div>dksfmjk</div>
    owqkdo</em>
</body>
</html>
`

interface CheerioOptions extends DomSerializerOptions {
    _useHtmlParser2?: boolean;
}

function html(str: string, options: CheerioOptions = {}) {
    const dom = parseDocument(str) as Document;
    return render(dom, options);
}

export default function abilityTest() {
    describe('ActsAbilityTest', () => {
        it('render', 0, () => {
            let dom: Document = parseDocument(htmlStr);
            let element = DomUtils.getElementsByTagName('style', dom);
            let result = render(element)
            expect(result)
                .assertEqual("<style>\n    .tagh1{\n        background-color: aquamarine;\n        color:'blue';\n    }\n    .one-div{\n        line-height: 30px;\n    }\n</style>")
        })

        it('should_handle_double_quotes_within_single_quoted_attributes_properly', 0, () => {
            const str = "<hr class='an \"edge\" case' />";
            expect(html(str)).assertEqual(
                '<hr class="an &quot;edge&quot; case">',
            );
        })

        it('should_escape_entities_to_utf8_if_requested', 0, () => {
            const str = '<a href="a < b &quot; & c">& " &lt; &gt;</a>';
            const dom = parseDocument(str) as Document;
            expect(render(dom, {
                encodeEntities: "utf8"
            }))
                .assertEqual('<a href="a < b &quot; &amp; c">&amp; " &lt; &gt;</a>');
        })

        it('should_append_empty_to_attributes_with_no_value', 0, () => {
            const str = "<div dropdown-toggle>";
            const dom = parseDocument(str) as Document;
            expect(render(dom, {
                xmlMode: true
            })).assertEqual('<div dropdown-toggle=""/>');
        });

        it('should_append_empty_to_boolean_attributes_with_no_value', 0, () => {
            const str = "<input disabled>";
            const dom = parseDocument(str) as Document;
            expect(render(dom, {
                xmlMode: true
            })).assertEqual('<input disabled=""/>');
        });

        it("should_preserve_XML_prefixes_on_attributes", 0, () => {
            const str =
                '<div xmlns:ex="http://example.com/ns"><p ex:ample="attribute">text</p></div>';
            const dom = parseDocument(str) as Document;
            expect(render(dom, {
                xmlMode: true
            })).assertEqual(str);
        });

        it("should_preserve_mixed_case_XML_elements_and_attributes", 0, () => {
            const str = '<svg viewBox="0 0 8 8"><radialGradient/></svg>';
            const dom = parseDocument(str, {
                xmlMode: true
            }) as Document;
            expect(render(dom, {
                xmlMode: true
            })).assertEqual(str);
        });

        it("should_encode_entities_in_otherwise_special_tags", 0, () => {
            const dom = parseDocument('<script>"<br/>"</script>', {
                xmlMode: true
            }) as Document;

            expect(render(dom, {
                xmlMode: true
            })).assertEqual(
                "<script>&quot;<br/>&quot;</script>",
            );
        });

        it("should_not_encode_entities_if_disabled", 0, () => {
            const str = '<script>"<br/>"</script>';
            const dom = parseDocument(str) as Document;
            expect(render(dom, {
                decodeEntities: false,
                xmlMode: true
            })).assertEqual(str);
        });

        it("test_html", 0, () => {
            testBody()
        });
    })
}

function testBody() {
    it("should_render_<br_/>_tags_without_a_slash", 0, () => {
        const str = "<br />";
        expect(html(str)).assertEqual("<br>");
    });

    it("should_retain_encoded_HTML_content_within_attributes", 0, () => {
        const str = '<hr class="cheerio &amp; node = happy parsing" />';
        expect(html(str)).assertEqual(
            '<hr class="cheerio &amp; node = happy parsing">',
        );
    });

    it('should_shorten_the_"checked"_attribute_when_it_contains_the_value_"checked"', 0, () => {
        const str = "<input checked/>";
        expect(html(str)).assertEqual("<input checked>");
    });

    it("should_render_empty_attributes_if_asked_for", 0, () => {
        const str = "<input checked/>";
        expect(html(str, { emptyAttrs: true })).assertEqual('<input checked="">');
    });

    it('should_not_shorten_the_"name"_attribute_when_it_contains_the_value_"name"', 0, () => {
        const str = '<input name="name"/>';
        expect(html(str)).assertEqual('<input name="name">');
    });

    it('should_not_append_=""_to_attributes_with_no_value', 0, () => {
        const str = "<div dropdown-toggle>";
        expect(html(str)).assertEqual("<div dropdown-toggle></div>");
    });

    it("should_render_comments_correctly", 0, () => {
        const str = "<!-- comment -->";
        expect(html(str)).assertEqual("<!-- comment -->");
    });

    it("should_render_whitespace_by_default", 0, () => {
        const str = '<a href="./haha.html">hi</a> <a href="./blah.html">blah</a>';
        expect(html(str)).assertEqual(str);
    });

    it("should_preserve_multiple_hyphens_in_data_attributes", 0, () => {
        const str = '<div data-foo-bar-baz="value"></div>';
        expect(html(str)).assertEqual('<div data-foo-bar-baz="value"></div>');
    });

    it("should_not_encode_tags_in_script_tag", 0, () => {
        const str = '<script>alert("hello world")</script>';
        expect(html(str)).assertEqual(str);
    });

    it("should_not_encode_tags_in_script_tag", 0, () => {
        const str = '<script>"<br>"</script>';
        expect(html(str)).assertEqual(str);
    });

    it("should_not_encode_json_data", 0, () => {
        const str =
            '<script>var json = {"simple_value": "value", "value_with_tokens": "&quot;here & \'there\'&quot;"};</script>';
        expect(html(str)).assertEqual(str);
    });

    it("should_render_childless_SVG_nodes_with_a_closing_slash_in_HTML_mode", 0, () => {
        const str =
            '<svg><circle x="12" y="12"/><path d="123M"/><polygon points="60,20 100,40 100,80 60,100 20,80 20,40"/></svg>';
        expect(html(str)).assertEqual(str);
    });

    it("should_render_childless_MathML_nodes_with_a_closing_slash_in_HTML_mode", 0, () => {
        const str = "<math><infinity/></math>";
        expect(html(str)).assertEqual(str);
    });

    it("should_allow_SVG_elements_to_have_children", 0, () => {
        const str = '<svg><circle cx="12" r="12"><title>dot</title></circle></svg>';
        expect(html(str)).assertEqual(str);
    });

    it("should_not_include_extra_whitespace_in_SVG_self-closed_elements", 0, () => {
        const str = '<svg><image href="x.png"/>     </svg>';
        expect(html(str)).assertEqual(str);
    });

    it("should_fix-up_bad_nesting_in_SVG_in_HTML_mode", 0, () => {
        const str = '<svg><g><image href="x.png"></svg>';
        expect(html(str)).assertEqual('<svg><g><image href="x.png"/></g></svg>');
    });

    it("should_preserve_XML_prefixed_attributes_on_inline_SVG_nodes_in_HTML_mode", 0, () => {
        const str =
            '<svg><text id="t" xml:lang="fr">Bonjour</text><use xlink:href="#t"/></svg>';
        expect(html(str)).assertEqual(str);
    });

    it("should_handle_mixed-case_SVG_content_in_HTML_mode", 0, () => {
        const str = '<svg viewBox="0 0 8 8"><radialGradient/></svg>';
        expect(html(str)).assertEqual(str);
    });

    it("should_render_HTML_content_in_SVG_foreignObject_in_HTML_mode", 0, () => {
        const str =
            '<svg><foreignObject requiredFeatures=""><img src="test.png" viewbox>text<svg viewBox="0 0 8 8"><circle r="3"/></svg></foreignObject></svg>';
        expect(html(str)).assertEqual(str);
    });

    it("should_render_iframe_nodes_with_a_closing_tag_in_HTML_mode", 0, () => {
        const str = '<iframe src="test"></iframe>';
        expect(html(str)).assertEqual(str);
    });

    it("should_encode_double_quotes_in_attribute", 0, () => {
        const str = `<img src="/" alt='title" onerror="alert(1)" label="x'>`;
        expect(html(str)).assertEqual(
            '<img src="/" alt="title&quot; onerror=&quot;alert(1)&quot; label=&quot;x">',
        );
    });
}