/**
 * MIT License
 *
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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
// @ts-nocheck
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import sanitizeHtml from 'sanitize-html'

export default function sanitizeHtmlTest() {
  describe('SanitizeHtmlTest', function () {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(function () {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(function () {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(function () {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(function () {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    //    it('assertContain',0, function () {
    //      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
    //      hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    //      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
    //      let a = 'abc'
    //      let b = 'b'
    //      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
    //      expect(a).assertContain(b)
    //      expect(a).assertEqual(a)
    //    })


    it('should escape self closing tags', 0, function () {
      expect(sanitizeHtml('before <img src="test.png" /> after', {
        disallowedTagsMode: 'escape',
        allowedTags: [],
        allowedAttributes: false
      })).assertEqual('before &lt;img src="test.png" /&gt; after');
    });
    it('should pass through simple, well-formed markup', 0, function () {
      expect(sanitizeHtml('<div><p>Hello <b>there</b></p></div>')).assertEqual('<div><p>Hello <b>there</b></p></div>');
    });
    it('should not pass through any text outside html tag boundary since html tag is found and option is ON', 0, function () {
      expect(sanitizeHtml('Text before html tag<html><div><p>Hello <b>there</b></p></div></html>Text after html tag!P�X��[<p>paragraph after closing html</p>', {
        enforceHtmlBoundary: true
      }
      )).assertEqual('<div><p>Hello <b>there</b></p></div>');
    });
    it('should pass through text outside html tag boundary since option is OFF', 0, function () {
      expect(sanitizeHtml('Text before html tag<html><div><p>Hello <b>there</b></p></div></html>Text after html tag!P�X��[<p>paragraph after closing html</p>', {
        enforceHtmlBoundary: false
      }
      ))
        .assertEqual('Text before html tag<div><p>Hello <b>there</b></p></div>Text after html tag!P�X��[<p>paragraph after closing html</p>');
    });
    it('should pass through text outside html tag boundary since option is ON but html tag is not found', 0, function () {
      expect(sanitizeHtml('Text before div tag<div><p>Hello <b>there</b></p></div>Text after div tag!P�X��[<p>paragraph after closing div</p>', {
        enforceHtmlBoundary: true
      }
      ))
        .assertEqual('Text before div tag<div><p>Hello <b>there</b></p></div>Text after div tag!P�X��[<p>paragraph after closing div</p>');
    });
    it('should pass through all markup if allowedTags and allowedAttributes are set to false', 0, function () {
      expect(sanitizeHtml('<div><wiggly worms="ewww">hello</wiggly></div>', {
        allowedTags: false,
        allowedAttributes: false
      })).assertEqual('<div><wiggly worms="ewww">hello</wiggly></div>');
    });
    it('should not pass through any markup if allowedTags is set to undefined (falsy but not exactly false)', 0, function () {
      expect(sanitizeHtml('<div><wiggly worms="ewww">hello</wiggly></div>', {
        allowedTags: undefined
      })).assertEqual('hello');
    });
    it('should not pass through any markup if allowedTags is set to 0 (falsy but not exactly false)', 0, function () {
      expect(sanitizeHtml('<div><wiggly worms="ewww">hello</wiggly></div>', {
        allowedTags: 0
      })).assertEqual('hello');
    });
    it('should not pass through any markup if allowedTags is set to null (falsy but not exactly false)', 0, function () {
      expect(sanitizeHtml('<div><wiggly worms="ewww">hello</wiggly></div>', {
        allowedTags: null
      })).assertEqual('hello');
    });
    it('should not pass through any markup if allowedTags is set to empty string (falsy but not exactly false)', 0, function () {
      expect(sanitizeHtml('<div><wiggly worms="ewww">hello</wiggly></div>', {
        allowedTags: ''
      })).assertEqual('hello');
    });
    it('should respect text nodes at top level', 0, function () {
      expect(sanitizeHtml('Blah blah blah<p>Whee!</p>')).assertEqual('Blah blah blah<p>Whee!</p>');
    });
    it('should return an empty string when input is explicit "undefined"', 0, function () {
      expect(sanitizeHtml(undefined)).assertEqual('');
    });
    it('should return an empty string when input is explicit "null"', 0, function () {
      expect(sanitizeHtml(null)).assertEqual('');
    });
    it('should return an empty string when input is an empty string', 0, function () {
      expect(sanitizeHtml('')).assertEqual('');
    });
    it('should reject markup not allowlisted without destroying its text', 0, function () {
      expect(sanitizeHtml('<div><wiggly>Hello</wiggly></div>')).assertEqual('<div>Hello</div>');
    });
    it('should escape markup not allowlisted', 0, function () {
      expect(sanitizeHtml('<div><wiggly>Hello</wiggly></div>', {
        disallowedTagsMode: 'escape'
      })).assertEqual('<div>&lt;wiggly&gt;Hello&lt;/wiggly&gt;</div>');
    });
    it('should accept a custom list of allowed tags', 0, function () {
      expect(sanitizeHtml('<blue><red><green>Cheese</green></red></blue>', {
        allowedTags: ['blue', 'green']
      })).assertEqual('<blue><green>Cheese</green></blue>');
    });
    it('should reject attributes not allowlisted', 0, function () {
      expect(sanitizeHtml('<a href="foo.html" whizbang="whangle">foo</a>')).assertEqual('<a href="foo.html">foo</a>');
    });
    it('should accept a custom list of allowed attributes per element', 0, function () {
      expect(sanitizeHtml('<a href="foo.html" whizbang="whangle">foo</a>', {
        allowedAttributes: {
          a: ['href', 'whizbang']
        }
      })).assertEqual('<a href="foo.html" whizbang="whangle">foo</a>');
    });
    it('should clean up unclosed img tags and p tags', 0, function () {
      expect(sanitizeHtml('<img src="foo.jpg"><p>Whee<p>Again<p>Wow<b>cool</b>', {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img'])
      })).assertEqual('<img src="foo.jpg" /><p>Whee</p><p>Again</p><p>Wow<b>cool</b></p>');
    });
    it('should reject hrefs that are not relative, ftp, http, https or mailto', 0, function () {
      expect(sanitizeHtml('<a href="http://google.com">google</a><a href="https://google.com">https google</a><a href="ftp://example.com">ftp</a><a href="mailto:test@test.com">mailto</a><a href="/relative.html">relative</a><a href="javascript:alert(0)">javascript</a>'))
        .assertEqual('<a href="http://google.com">google</a><a href="https://google.com">https google</a><a href="ftp://example.com">ftp</a><a href="mailto:test@test.com">mailto</a><a href="/relative.html">relative</a><a>javascript</a>');
    });
    it('should cope identically with capitalized attributes and tags and should tolerate capitalized schemes', 0, function () {
      expect(sanitizeHtml('<A HREF="http://google.com">google</a><a href="HTTPS://google.com">https google</a><a href="ftp://example.com">ftp</a><a href="mailto:test@test.com">mailto</a><a href="/relative.html">relative</a><a href="javascript:alert(0)">javascript</a>'))
        .assertEqual('<a href="http://google.com">google</a><a href="HTTPS://google.com">https google</a><a href="ftp://example.com">ftp</a><a href="mailto:test@test.com">mailto</a><a href="/relative.html">relative</a><a>javascript</a>');
    });
    it('should drop the content of script elements', 0, function () {
      expect(sanitizeHtml('<script>alert("ruhroh!");</script><p>Paragraph</p>')).assertEqual('<p>Paragraph</p>');
    });
    it('should drop the content of style elements', 0, function () {
      expect(sanitizeHtml('<style>.foo { color: blue; }</style><p>Paragraph</p>')).assertEqual('<p>Paragraph</p>');
    });
    it('should drop the content of textarea elements', 0, function () {
      expect(sanitizeHtml('<textarea>Nifty</textarea><p>Paragraph</p>')).assertEqual('<p>Paragraph</p>');
    });
    it('should drop the content of option elements', 0, function () {
      expect(sanitizeHtml('<select><option>one</option><option>two</option></select><p>Paragraph</p>'))
        .assertEqual('<p>Paragraph</p>');
    });
    it('should drop the content of textarea elements but keep the closing parent tag, when nested', 0, function () {
      expect(sanitizeHtml('<p>Paragraph<textarea>Nifty</textarea></p>')).assertEqual('<p>Paragraph</p>');
    });
    it('should retain the content of fibble elements by default', 0, function () {
      expect(sanitizeHtml('<fibble>Nifty</fibble><p>Paragraph</p>')).assertEqual('Nifty<p>Paragraph</p>');
    });
    it('should discard the content of fibble elements if specified for nonTextTags', 0, function () {
      expect(sanitizeHtml('<fibble>Nifty</fibble><p>Paragraph</p>', {
        nonTextTags: ['fibble']
      })).assertEqual('<p>Paragraph</p>');
    });
    it('should retain allowed tags within a fibble element if fibble is not specified for nonTextTags', 0, function () {
      expect(sanitizeHtml('<fibble>Ni<em>f</em>ty</fibble><p>Paragraph</p>', {}))
        .assertEqual('Ni<em>f</em>ty<p>Paragraph</p>');
    });
    it('should discard allowed tags within a fibble element if fibble is specified for nonTextTags', 0, function () {
      expect(sanitizeHtml('<fibble>Ni<em>f</em>ty</fibble><p>Paragraph</p>', {
        nonTextTags: ['fibble']
      })).assertEqual('<p>Paragraph</p>');
    });
    it('should preserve textarea content if textareas are allowed', 0, function () {
      expect(sanitizeHtml('<textarea>Nifty</textarea><p>Paragraph</p>', {
        allowedTags: ['textarea', 'p']
      })).assertEqual('<textarea>Nifty</textarea><p>Paragraph</p>');
    });
    it('should preserve entities as such', 0, function () {
      expect(sanitizeHtml('<a name="&lt;silly&gt;">&lt;Kapow!&gt;</a>'))
        .assertEqual('<a name="&lt;silly&gt;">&lt;Kapow!&gt;</a>');
    });
    it('should tolerate not closed p tags', 0, function () {
      expect(sanitizeHtml('<div><p>inner text 1<p>inner text 2<p>inner text 3</div>'))
        .assertEqual('<div><p>inner text 1</p><p>inner text 2</p><p>inner text 3</p></div>');
    });
    it('should escape not closed p tags, if not in allowedTags array', 0, function () {
      expect(sanitizeHtml('<div><p>inner text 1<p>inner text 2<p>inner text 3</div>', {
        allowedTags: ['div']
      })).assertEqual('<div>inner text 1inner text 2inner text 3</div>');
    });
    it('should dump comments', 0, function () {
      expect(sanitizeHtml('<p><!-- Blah blah -->Whee</p>')).assertEqual('<p>Whee</p>');
    });
    it('should dump a sneaky encoded javascript url', 0, function () {
      expect(sanitizeHtml('<a href="&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#88;&#83;&#83;&#39;&#41;">Hax</a>'))
        .assertEqual('<a>Hax</a>');
    });
    it('should dump an uppercase javascript url', 0, function () {
      expect(sanitizeHtml('<a href="JAVASCRIPT:alert(\'foo\')">Hax</a>')).assertEqual('<a>Hax</a>');
    });
    it('should dump a javascript URL with a comment in the middle (probably only respected by browsers in XML data islands, but just in case someone enables those)', 0, function () {
      expect(sanitizeHtml('<a href="java<!-- -->script:alert(\'foo\')">Hax</a>')).assertEqual('<a>Hax</a>');
    });
    it('should not mess up a hashcode with a : in it', 0, function () {
      expect(sanitizeHtml('<a href="awesome.html#this:stuff">Hi</a>'))
        .assertEqual('<a href="awesome.html#this:stuff">Hi</a>');
    });
    it('should dump character codes 1-32 before testing scheme', 0, function () {
      expect(sanitizeHtml('<a href="java\0&#14;\t\r\n script:alert(\'foo\')">Hax</a>')).assertEqual('<a>Hax</a>');
    });
    it('should dump character codes 1-32 even when escaped with padding rather than trailing ;', 0, function () {
      expect(sanitizeHtml('<a href="java&#0000001script:alert(\'foo\')">Hax</a>'))
        .assertEqual('<a>Hax</a>');
    });
    it('should still like nice schemes', 0, function () {
      expect(sanitizeHtml('<a href="http://google.com/">Hi</a>')).assertEqual('<a href="http://google.com/">Hi</a>');
    });
    it('should still like nice relative URLs', 0, function () {
      expect(sanitizeHtml('<a href="hello.html">Hi</a>')).assertEqual('<a href="hello.html">Hi</a>');
    });
    it('should replace ol to ul', 0, function () {
      expect(sanitizeHtml('<ol><li>Hello world</li></ol>', {
        transformTags: {
          ol: 'ul'
        }
      })).assertEqual('<ul><li>Hello world</li></ul>');
    });
    it('should replace ol to ul and add class attribute with foo value', 0, function () {
      expect(sanitizeHtml('<ol><li>Hello world</li></ol>', {
        transformTags: {
          ol: sanitizeHtml.simpleTransform('ul', {
            class: 'foo'
          })
        },
        allowedAttributes: {
          ul: ['class']
        }
      })).assertEqual('<ul class="foo"><li>Hello world</li></ul>');
    });
    it('should replace ol to ul, left attributes foo and bar untouched, remove baz attribute and add class attributte with foo value', 0, function () {
      expect(sanitizeHtml('<ol foo="foo" bar="bar" baz="baz"><li>Hello world</li></ol>', {
        transformTags: {
          ol: sanitizeHtml.simpleTransform('ul', {
            class: 'foo'
          })
        },
        allowedAttributes: {
          ul: ['foo', 'bar', 'class']
        }
      })).assertEqual('<ul foo="foo" bar="bar" class="foo"><li>Hello world</li></ul>');
    });
    it('should replace ol to ul and replace all attributes to class attribute with foo value', 0, function () {
      expect(sanitizeHtml('<ol foo="foo" bar="bar" baz="baz"><li>Hello world</li></ol>', {
        transformTags: {
          ol: sanitizeHtml.simpleTransform('ul', {
            class: 'foo'
          }, false)
        },
        allowedAttributes: {
          ul: ['foo', 'bar', 'class']
        }
      })).assertEqual('<ul class="foo"><li>Hello world</li></ul>');
    });
    it('should replace ol to ul and add attribute class with foo value and attribute bar with bar value', 0, function () {
      expect(sanitizeHtml('<ol><li>Hello world</li></ol>', {
        transformTags: {
          ol: function (tagName, attribs) {
            attribs.class = 'foo';
            attribs.bar = 'bar';
            return {
              tagName: 'ul',
              attribs: attribs
            };
          }
        },
        allowedAttributes: {
          ul: ['bar', 'class']
        }
      })).assertEqual('<ul class="foo" bar="bar"><li>Hello world</li></ul>');
    });

    it('should replace text and attributes when they are changed by transforming function', 0, function () {
      expect(sanitizeHtml('<a href="http://somelink">some text</a>', {
        transformTags: {
          a: function (tagName, attribs) {
            return {
              tagName: tagName,
              attribs: attribs,
              text: ''
            };
          }
        }
      })).assertEqual('<a href="http://somelink"></a>');
    });
    it('should replace text and attributes when they are changed by transforming function and textFilter is set', 0, function () {
      expect(sanitizeHtml('<a href="http://somelink">some text</a>', {
        transformTags: {
          a: function (tagName, attribs) {
            return {
              tagName: tagName,
              attribs: attribs,
              text: 'some text need"to<be>filtered'
            };
          }
        },
        textFilter: function (text, tagName) {
          return text.replace(/\s/g, '_');
        }
      })).assertEqual('<a href="http://somelink">some_text_need"to&lt;be&gt;filtered</a>');
    });

    it('should replace text and attributes when they are changed by transforming function and textFilter is not set', 0, function () {
      expect(sanitizeHtml('<a href="http://somelink">some text</a>', {
        transformTags: {
          a: function (tagName, attribs) {
            return {
              tagName: tagName,
              attribs: attribs,
              text: 'some good text'
            };
          }
        }
      })).assertEqual('<a href="http://somelink">some good text</a>');
    });

    it('should preserve trailing text when replacing the tagName and adding new text via transforming function', 0, function () {
      expect(sanitizeHtml('<p>text before <br> text after</p>', {
        transformTags: {
          br: function (_tagName, _attribs) {
            return {
              tagName: 'span',
              text: ' '
            };
          }
        }
      })).assertEqual('<p>text before <span> </span> text after</p>');
    });

    it('should add new text when not initially set and replace attributes when they are changed by transforming function', 0, function () {
      expect(sanitizeHtml('<a href="http://somelink"></a>', {
        transformTags: {
          a: function (tagName, attribs) {
            return {
              tagName: tagName,
              attribs: attribs,
              text: 'some new text'
            };
          }
        }
      })).assertEqual('<a href="http://somelink">some new text</a>');
    });

    it('should preserve text when initially set and replace attributes when they are changed by transforming function', 0, function () {
      expect(sanitizeHtml('<a href="http://somelink">some initial text</a>', {
        transformTags: {
          a: function (tagName, attribs) {
            return {
              tagName: tagName,
              attribs: attribs
            };
          }
        }
      })).assertEqual('<a href="http://somelink">some initial text</a>');
    });

    it('should skip an empty link', 0, function () {
      expect(
      sanitizeHtml('<p>This is <a href="http://www.linux.org"></a><br/>Linux</p>', {
        exclusiveFilter: function (frame) {
          return frame.tag === 'a' && !frame.text.trim();
        }
      })).assertEqual(
        '<p>This is <br />Linux</p>'
      );
    });

    it('Should expose a node\'s inner text and inner HTML to the filter', 0, function () {
      expect(
      sanitizeHtml('<p>12<a href="http://www.linux.org"><br/>3<br></a><audio>4</audio></p>', {
        exclusiveFilter: function (frame) {
          if (frame.tag === 'p') {
            expect(frame.text).assertEqual('124');
          } else if (frame.tag === 'a') {
            expect(frame.text).assertEqual('3');
            return true;
          } else if (frame.tag === 'br') {
            expect(frame.text).assertEqual('');
          } else {
            expect('p, a, br')!.assertEqual(frame.tag);
          }
          return false;
        }
      })).assertEqual(
        '<p>124</p>'
      );
    });

    it('Should collapse nested empty elements', 0, function () {
      expect(
      sanitizeHtml('<p><a href="http://www.linux.org"><br/></a></p>', {
        exclusiveFilter: function (frame) {
          return (frame.tag === 'a' || frame.tag === 'p') && !frame.text.trim();
        }
      })).assertEqual(
        ''
      );
    });

    it('Should find child media elements that are in allowedTags', 0, function () {
      const markup = '<a href="http://www.linux.org"><img /><video></video></a>';
      const sansVideo = '<a href="http://www.linux.org"><img /></a>';
      const sanitizedMarkup = sanitizeHtml(markup, {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img']),
        exclusiveFilter: function (frame) {
          if (frame.tag === 'a') {
            // eslint-disable-next-line no-console
            expect(frame.mediaChildren.length === 1);
          }

          return (frame.tag === 'a') && !frame.text.trim() && !frame.mediaChildren.length;
        }
      });

      expect(sanitizedMarkup).assertEqual(sansVideo);
    });

    it('Exclusive filter should not affect elements which do not match the filter condition', 0, function () {
      expect(
      sanitizeHtml('I love <a href="www.linux.org" target="_hplink">Linux</a> OS',
        {
          exclusiveFilter: function (frame) {
            return (frame.tag === 'a') && !frame.text.trim();
          }
        })).assertEqual(
        'I love <a href="www.linux.org" target="_hplink">Linux</a> OS'
      );
    });
    it('should disallow data URLs with default allowedSchemes', 0, function () {
      expect(
      sanitizeHtml(
        // teeny-tiny valid transparent GIF in a data URL
        '<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" />',
        {
          allowedTags: ['img']
        }
      )).assertEqual(
        '<img />'
      );
    });
    it('should allow data URLs with custom allowedSchemes', 0, function () {
      expect(
      sanitizeHtml(
        // teeny-tiny valid transparent GIF in a data URL
        '<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" />',
        {
          allowedTags: ['img', 'p'],
          allowedSchemes: ['data', 'http']
        }
      )).assertEqual(
        '<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" />'
      );
    });
    it('should allow specific classes when allowlisted with allowedClasses for a single tag', 0, function () {
      expect(
      sanitizeHtml(
        '<p class="nifty simple dippy">whee</p>',
        {
          allowedTags: ['p'],
          allowedClasses: {
            p: ['nifty']
          }
        }
      )).assertEqual(
        '<p class="nifty">whee</p>'
      );
    });
    it('should allow specific classes when allowlisted with allowedClasses for all tags', 0, function () {
      expect(
      sanitizeHtml(
        '<p class="nifty simple dippy">whee</p><div class="dippy nifty simple"></div>',
        {
          allowedTags: ['p', 'div'],
          allowedClasses: {
            '*': ['nifty']
          }
        }
      )).assertEqual(
        '<p class="nifty">whee</p><div class="nifty"></div>'
      );
    });
    it('should allow all classes that are allowlisted for a single tag or all tags', 0, function () {
      expect(
      sanitizeHtml(
        '<p class="nifty simple dippy">whee</p><div class="simple dippy nifty"></div>',
        {
          allowedTags: ['p', 'div'],
          allowedClasses: {
            '*': ['simple'],
            p: ['nifty'],
            div: ['dippy']
          }
        }
      )).assertEqual(
        '<p class="nifty simple">whee</p><div class="simple dippy"></div>'
      );
    });
    it('should allow classes that match wildcards for a single tag or all tags', 0, function () {
      expect(
      sanitizeHtml(
        '<p class="nifty- nifty-a simple dippy dippy-a-simple">whee</p>',
        {
          allowedTags: ['p'],
          allowedClasses: {
            '*': ['dippy-*-simple'],
            p: ['nifty-*']
          }
        }
      )).assertEqual(
        '<p class="nifty- nifty-a dippy-a-simple">whee</p>'
      );
    });
    it('should allow all classes if `allowedClasses` contains a single `*`', 0, function () {
      expect(
      sanitizeHtml(
        '<p class="nifty simple dippy">whee</p>',
        {
          allowedTags: ['p'],
          allowedClasses: {
            '*': ['*']
          }
        }
      )).assertEqual(
        '<p class="nifty simple dippy">whee</p>'
      );
    });
    it('should allow only classes that matches `allowedClasses` regex', 0, function () {
      expect(
      sanitizeHtml(
        '<p class="nifty33 nifty2 dippy">whee</p>',
        {
          allowedTags: ['p'],
          allowedClasses: {
            p: [/^nifty\d{2}$/, /^d\w{4}$/]
          }
        }
      )).assertEqual(
        '<p class="nifty33 dippy">whee</p>'
      );
    });
    it('should allow defining schemes on a per-tag basis', 0, function () {
      expect(
      sanitizeHtml(
        // teeny-tiny valid transparent GIF in a data URL
        '<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" /><a href="https://www.example.com"></a>',
        {
          allowedTags: ['img', 'a'],
          allowedSchemes: ['http'],
          allowedSchemesByTag: {
            img: ['data'],
            a: ['https']
          }
        }
      )).assertEqual(
        '<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" /><a href="https://www.example.com"></a>'
      );
      expect(
      sanitizeHtml(
        // teeny-tiny valid transparent GIF in a data URL
        '<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" /><a href="https://www.example.com"></a>',
        {
          allowedTags: ['img', 'a'],
          allowedSchemes: ['http'],
          allowedSchemesByTag: {
            img: [],
            a: ['https']
          }
        }
      )).assertEqual(
        '<img /><a href="https://www.example.com"></a>'
      );
    });
    it('should not act weird when the class attribute is empty', 0, function () {
      expect(
      sanitizeHtml(
        '<p class="">whee</p>',
        {
          allowedTags: ['p'],
          allowedClasses: {
            p: ['nifty']
          }
        }
      )).assertEqual(
        '<p>whee</p>'
      );
    });
    it('should not crash on bad markup', 0, function () {
      expect(
      sanitizeHtml(
        '<p a'
      )).assertEqual(
        ''
      );
    });
    it('should not allow a naked = sign followed by an unrelated attribute to result in one merged attribute with unescaped double quote marks', 0, function () {
      expect(
      sanitizeHtml(
        '<IMG SRC= onmouseover="alert(\'XSS\');">',
        {
          allowedTags: ['img'],
          allowedAttributes: {
            img: ['src']
          }
        }
      )).assertEqual(
        // This is weird but not dangerous. Without the &quot there
        // would probably be some way to make it come out as a
        // separate attribute
        '<img src="onmouseover=&quot;alert(\'XSS\');&quot;" />'
      );
    });


    it('should allow only approved attributes, but to any tags, if tag is declared as  "*"', 0, function () {
      expect(
      sanitizeHtml(
        '<table bgcolor="1" align="left" notlisted="0"><img src="1.gif" align="center" alt="not listed too"/></table>',
        {
          allowedTags: ['table', 'img'],
          allowedAttributes: {
            '*': ['bgcolor', 'align', 'src']
          }
        }
      )).assertEqual(
        '<table bgcolor="1" align="left"><img src="1.gif" align="center" /></table>'
      );
    });
    it('should not filter if exclusive filter does not match after transforming tags', 0, function () {
      expect(
      sanitizeHtml(
        '<a href="test.html">test</a>',
        {
          allowedTags: ['a'],
          allowedAttributes: {
            a: ['href', 'target']
          },
          transformTags: {
            a: function (tagName, attribs) {
              if (!attribs.href) {
                return false;
              }
              return {
                tagName: tagName,
                attribs: {
                  target: '_blank',
                  href: attribs.href
                }
              };
            }
          },
          exclusiveFilter: function (frame) {
            return frame.tag === 'a' && frame.text.trim() === 'blah';
          }
        }
      )).assertEqual(
        '<a target="_blank" href="test.html">test</a>'
      );
    });
    it('should filter if exclusive filter does match after transforming tags', 0, function () {
      expect(
      sanitizeHtml(
        '<a href="test.html">blah</a>',
        {
          allowedTags: ['a'],
          allowedAttributes: {
            a: ['href', 'target']
          },
          transformTags: {
            a: function (tagName, attribs) {
              if (!attribs.href) {
                return false;
              }
              return {
                tagName: tagName,
                attribs: {
                  target: '_blank',
                  href: attribs.href
                }
              };
            }
          },
          exclusiveFilter: function (frame) {
            return frame.tag === 'a' && frame.text.trim() === 'blah';
          }
        }
      )).assertEqual(
        ''
      );
    });
    it('should allow transform on all tags using \'*\'', 0, function () {
      expect(
      sanitizeHtml(
        '<p>Text</p>',
        {
          allowedTags: ['p'],
          allowedAttributes: {
            p: ['style']
          },
          transformTags: {
            '*': function (tagName, attribs) {
              return {
                tagName: tagName,
                attribs: {
                  style: 'text-align: center'
                }
              };
            }
          }
        }
      )).assertEqual(
        '<p style="text-align:center">Text</p>'
      );
    });
    it('should not be faked out by double <', 0, function () {
      expect(
      sanitizeHtml('<<img src="javascript:evil"/>img src="javascript:evil"/>'
      )).assertEqual(
        '&lt;img src="javascript:evil"/&gt;'
      );
      expect(
      sanitizeHtml('<<a href="javascript:evil"/>a href="javascript:evil"/>'
      )).assertEqual(
        '&lt;<a>a href="javascript:evil"/&gt;</a>'
      );
    });
    it('should allow attributes to be specified as globs', 0, function () {
      expect(
      sanitizeHtml('<a data-target="#test" data-foo="hello">click me</a>', {
        allowedTags: ['a'],
        allowedAttributes: {
          a: ['data-*']
        }
      })).assertEqual('<a data-target="#test" data-foo="hello">click me</a>'
      );
      expect(
      sanitizeHtml('<a data-target="#test" data-my-foo="hello">click me</a>', {
        allowedTags: ['a'],
        allowedAttributes: {
          a: ['data-*-foo']
        }
      })).assertEqual('<a data-my-foo="hello">click me</a>'
      );
    });
    it('should quote regex chars in attributes specified as globs', 0, function () {
      expect(
      sanitizeHtml('<a data-b.c="#test" data-bcc="remove this">click me</a>', {
        allowedTags: ['a'],
        allowedAttributes: {
          a: ['data-b.*']
        }
      })).assertEqual('<a data-b.c="#test">click me</a>'
      );
    });
    it('should not escape inner content of script and style tags (when allowed)', 0, function () {
      expect(
      sanitizeHtml('<div>"normal text"</div><script>"this is code"</script>', {
        allowedTags: ['script']
      })).assertEqual('"normal text"<script>"this is code"</script>'
      );
      expect(
      sanitizeHtml('<div>"normal text"</div><style>body { background-image: url("image.test"); }</style>', {
        allowedTags: ['style']
      })).assertEqual('"normal text"<style>body { background-image: url("image.test"); }</style>'
      );
    });
    it('should not unescape escapes found inside script tags', 0, function () {
      expect(
      sanitizeHtml('<script>alert("&quot;This is cool but just ironically so I quoted it&quot;")</script>',
        {
          allowedTags: ['script']
        }
      )).assertEqual(
        '<script>alert("&quot;This is cool but just ironically so I quoted it&quot;")</script>'
      );
    });
    it('should process text nodes with provided function', 0, function () {
      expect(
      sanitizeHtml('"normal text this should be removed"', {
        textFilter: function (text, tagName) {
          return text.replace(' this should be removed', '');
        }
      })).assertEqual('"normal text"'
      );
    });
    it('should skip text nodes based on tagName', 0, function () {
      expect(
      sanitizeHtml('<a>normal text this should be removed</a><b>normal text this should be removed</b>', {
        textFilter: function (text, tagName) {
          if (tagName === 'a') {
            return text;
          }
          ;
          return text.replace(' this should be removed', '');
        }
      })).assertEqual('<a>normal text this should be removed</a><b>normal text</b>'
      );
    });
    it('should respect htmlparser2 options when passed in', 0, function () {
      expect(
      sanitizeHtml('<Archer><Sterling>I am</Sterling></Archer>', {
        allowedTags: false,
        allowedAttributes: false
      })).assertEqual(
        '<archer><sterling>I am</sterling></archer>'
      );
      expect(
      sanitizeHtml('<Archer><Sterling>I am</Sterling></Archer>', {
        allowedTags: false,
        allowedAttributes: false,
        parser: {
          lowerCaseTags: false
        }
      })).assertEqual(
        '<Archer><Sterling>I am</Sterling></Archer>'
      );
    });
    it('should not crash due to tag names that are properties of the universal Object prototype', 0, function () {
      expect(
      sanitizeHtml('!<__proto__>!')).assertEqual(
        '!&lt;__proto__&gt;!');
    });
    it('should correctly maintain escaping when allowing a nonTextTags tag other than script or style', 0, function () {
      expect(
      sanitizeHtml('!<textarea>&lt;/textarea&gt;&lt;svg/onload=prompt`xs`&gt;</textarea>!',
        {
          allowedTags: ['textarea']
        }
      )).assertEqual('!<textarea>&lt;/textarea&gt;&lt;svg/onload=prompt`xs`&gt;</textarea>!'
      );
    });
    it('should allow protocol relative links by default', 0, function () {
      expect(
      sanitizeHtml('<a href="//cnn.com/example">test</a>')).assertEqual(
        '<a href="//cnn.com/example">test</a>'
      );
    });
    it('should not allow protocol relative links when allowProtocolRelative is false', 0, function () {
      expect(
      sanitizeHtml('<a href="//cnn.com/example">test</a>', {
        allowProtocolRelative: false
      })).assertEqual(
        '<a>test</a>'
      );
      expect(
      sanitizeHtml('<a href="/\\cnn.com/example">test</a>', {
        allowProtocolRelative: false
      })).assertEqual(
        '<a>test</a>'
      );
      expect(
      sanitizeHtml('<a href="\\\\cnn.com/example">test</a>', {
        allowProtocolRelative: false
      })).assertEqual(
        '<a>test</a>'
      );
      expect(
      sanitizeHtml('<a href="\\/cnn.com/example">test</a>', {
        allowProtocolRelative: false
      })).assertEqual(
        '<a>test</a>'
      );
    });
    it('should still allow regular relative URLs when allowProtocolRelative is false', 0, function () {
      expect(
      sanitizeHtml('<a href="/welcome">test</a>', {
        allowProtocolRelative: false
      })).assertEqual(
        '<a href="/welcome">test</a>'
      );
    });
    it('should discard srcset by default', 0, function () {
      expect(
      sanitizeHtml('<img src="fallback.jpg" srcset="foo.jpg 100w 2x, bar.jpg 200w 1x" />', {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img'])
      })).assertEqual(
        '<img src="fallback.jpg" />'
      );
    });
    it('should accept srcset if allowed', 0, function () {
      expect(
      sanitizeHtml('<img src="fallback.jpg" srcset="foo.jpg 100w, bar.jpg 200w" />', {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img']),
        allowedAttributes: {
          img: ['src', 'srcset']
        }
      })).assertEqual(
        '<img src="fallback.jpg" srcset="foo.jpg 100w, bar.jpg 200w" />'
      );
      expect(
      sanitizeHtml('<img src="fallback.jpg" srcset="foo.jpg 2x, bar.jpg 1x" />', {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img']),
        allowedAttributes: {
          img: ['src', 'srcset']
        }
      })).assertEqual(
        '<img src="fallback.jpg" srcset="foo.jpg 2x, bar.jpg 1x" />'
      );
    });
    it('should drop bogus srcset', 0, function () {
      expect(
      sanitizeHtml('<img src="fallback.jpg" srcset="foo.jpg 100w, bar.jpg 200w, javascript:alert(1) 100w" />', {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img']),
        allowedAttributes: {
          img: ['src', 'srcset']
        }
      })).assertEqual(
        '<img src="fallback.jpg" srcset="foo.jpg 100w, bar.jpg 200w" />'
      );
    });
    it('should accept srcset with urls containing commas', 0, function () {
      expect(
      sanitizeHtml('<img src="fallback.jpg" srcset="/upload/f_auto,q_auto:eco,c_fit,w_1460,h_2191/abc.jpg 1460w, /upload/f_auto,q_auto:eco,c_fit,w_1360,h_2041/abc.jpg" />', {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img']),
        allowedAttributes: {
          img: ['src', 'srcset']
        }
      })).assertEqual(
        '<img src="fallback.jpg" srcset="/upload/f_auto,q_auto:eco,c_fit,w_1460,h_2191/abc.jpg 1460w, /upload/f_auto,q_auto:eco,c_fit,w_1360,h_2041/abc.jpg" />'
      );
    });

    it('text from transformTags should not specify tags', 0, function () {
      const input = '<input value="&lt;script&gt;alert(1)&lt;/script&gt;">';
      const want = '<u class="inlined-input">&lt;script&gt;alert(1)&lt;/script&gt;</u>';
      // Runs the sanitizer with a policy that turns an attribute into
      // text.  A policy like this might be used to turn inputs into
      // inline elements that look like the original but which do not
      // affect form submissions.
      const got = sanitizeHtml(
        input,
        {
          allowedTags: ['u'],
          allowedAttributes: {
            '*': ['class']
          },
          transformTags: {
            input: function (tagName, attribs) {
              return {
                tagName: 'u',
                attribs: {
                  class: 'inlined-input'
                },
                text: attribs.value
              };
            }
          }
        });
      expect(got).assertEqual(want);
    });
    it('drop attribute names with meta-characters', 0, function () {
      expect(
      sanitizeHtml('<span data-<script>alert(1)//>', {
        allowedTags: ['span'],
        allowedAttributes: {
          span: ['data-*']
        }
      })).assertEqual(
        '<span>alert(1)//&gt;</span>'
      );
    });
    it('should sanitize styles correctly', 0, function () {
      const sanitizeString = '<p dir="ltr"><strong>beste</strong><em>testestes</em><s>testestset</s><u>testestest</u></p><ul dir="ltr"> <li><u>test</u></li></ul><blockquote dir="ltr"> <ol> <li><u>test</u></li><li><u>test</u></li><li style="text-align: right"><u>test</u></li><li style="text-align: justify"><u>test</u></li></ol> <p><u><span style="color:#00FF00">test</span></u></p><p><span style="color:#00FF00"><span style="font-size:36px">TESTETESTESTES</span></span></p></blockquote>';
      const expected = '<p dir="ltr"><strong>beste</strong><em>testestes</em><s>testestset</s><u>testestest</u></p><ul dir="ltr"> <li><u>test</u></li></ul><blockquote dir="ltr"> <ol> <li><u>test</u></li><li><u>test</u></li><li style="text-align: right"><u>test</u></li><li style="text-align: justify"><u>test</u></li></ol> <p><u><span style="color:#00FF00">test</span></u></p><p><span style="color:#00FF00"><span style="font-size:36px">TESTETESTESTES</span></span></p></blockquote>';
      expect(
      sanitizeHtml(sanitizeString, {
        allowedTags: false,
        allowedAttributes: {
          '*': ['dir'],
          p: ['dir', 'style'],
          li: ['style'],
          span: ['style']
        },
        allowedStyles: {
          '*': {
            // Matches hex
            color: [/#(0x)?[0-9a-f]+/i],
            'text-align': [/left/, /right/, /center/, /justify/, /initial/, /inherit/],
            'font-size': [/36px/]
          }
        }
      }).replace(/ /g, '')).assertEqual(expected.replace(/ /g, '')
      );
    });
    it('Should remove empty style tags', 0, function () {
      expect(
      sanitizeHtml('<span style=\'\'></span>', {
        allowedTags: false,
        allowedAttributes: false
      })).assertEqual(
        '<span></span>'
      );
    });
    it('Should remove invalid styles', 0, function () {
      expect(
      sanitizeHtml('<span style=\'color: blue; text-align: justify\'></span>', {
        allowedTags: false,
        allowedAttributes: {
          span: ['style']
        },
        allowedStyles: {
          span: {
            color: [/blue/],
            'text-align': [/left/]
          }
        }
      })).assertEqual('<span style="color:blue"></span>'
      );
    });
    it('Should support !important styles', 0, function () {
      expect(
      sanitizeHtml('<span style=\'color: blue !important\'></span>', {
        allowedTags: false,
        allowedAttributes: {
          span: ['style']
        },
        allowedStyles: {
          span: {
            color: [/blue/]
          }
        }
      })).assertEqual('<span style="color:blue !important"></span>'
      );
    });
    it('Should allow a specific style from global', 0, function () {
      expect(
      sanitizeHtml('<span style=\'color: yellow; text-align: center; font-family: helvetica\'></span>', {
        allowedTags: false,
        allowedAttributes: {
          span: ['style']
        },
        allowedStyles: {
          '*': {
            color: [/yellow/],
            'text-align': [/center/]
          },
          span: {
            color: [/green/],
            'font-family': [/helvetica/]
          }
        }
      })).assertEqual('<span style="color:yellow;text-align:center;font-family:helvetica"></span>'
      );
    });
    it('should delete the script tag', 0, function () {
      expect(sanitizeHtml('<script src="https://www.unauthorized.com/lib.js"></script>', {
        allowedTags: ['script'],
        allowVulnerableTags: true,
        allowedAttributes: {
          script: ['src']
        },
        allowedScriptHostnames: ['www.authorized.com']
      })).assertEqual('<script></script>');
    });
    it('should delete the script tag since src is not a valid URL', 0, function () {
      expect(sanitizeHtml('<script src="not-a-valid-url"></script>', {
        allowedTags: ['script'],
        allowVulnerableTags: true,
        allowedAttributes: {
          script: ['src']
        },
        allowedScriptHostnames: ['www.unauthorized.com']
      })).assertEqual('<script></script>');
    });
    it('Should allow domains in a script that are in allowedScriptDomains', 0, function () {
      expect(
      sanitizeHtml('<script src="https://www.safe.authorized.com/lib.js"></script>', {
        allowedTags: ['script'],
        allowedAttributes: {
          script: ['src']
        },
        allowedScriptDomains: ['authorized.com']
      })).assertEqual('<script src="https://www.safe.authorized.com/lib.js"></script>'
      );
    });
    it('should delete the script tag content', 0, function () {
      expect(sanitizeHtml('<script src="https://www.authorized.com/lib.js"> alert("evil") </script>', {
        allowedTags: ['script'],
        allowVulnerableTags: true,
        allowedAttributes: {
          script: ['src']
        },
        allowedScriptHostnames: ['www.authorized.com']
      })).assertEqual('<script src="https://www.authorized.com/lib.js"></script>');
    });
    it('should delete the script tag content from script tags with no src when allowedScriptHostnames is present', 0, function () {
      expect(sanitizeHtml('<script>alert("evil")</script>', {
        allowedTags: ['script'],
        allowVulnerableTags: true,
        allowedAttributes: {
          script: ['src']
        },
        allowedScriptHostnames: ['www.authorized.com']
      })).assertEqual('<script></script>');
    });
    it('should delete the script tag content from script tags with no src when allowedScriptDomains is present', 0, function () {
      expect(sanitizeHtml('<script>alert("evil")</script>', {
        allowedTags: ['script'],
        allowVulnerableTags: true,
        allowedAttributes: {
          script: ['src']
        },
        allowedScriptDomains: ['www.authorized.com']
      })).assertEqual('<script></script>');
    });
    it('Should allow hostnames in a script that are in allowedScriptHostnames', 0, function () {
      expect(sanitizeHtml('<script src="https://www.authorized.com/lib.js"></script>', {
        allowedTags: ['script'],
        allowVulnerableTags: true,
        allowedAttributes: {
          script: ['src']
        },
        allowedScriptHostnames: ['www.authorized.com']
      })).assertEqual('<script src="https://www.authorized.com/lib.js"></script>');
    });
    it('Should allow hostnames in an iframe that are in allowedIframeHostnames', 0, function () {
      expect(
      sanitizeHtml('<iframe src="https://www.youtube.com/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com', 'player.vimeo.com']
      })).assertEqual('<iframe src="https://www.youtube.com/embed/c2IlcS7AHxM"></iframe>'
      );
    });
    it('Should remove iframe src urls that are not included in allowedIframeHostnames', 0, function () {
      expect(
      sanitizeHtml('<iframe src="https://www.embed.vevo.com/USUV71704255"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com', 'player.vimeo.com']
      })).assertEqual('<iframe></iframe>'
      );
    });
    it('Should not allow iframe urls that do not have proper hostname', 0, function () {
      expect(
      sanitizeHtml('<iframe src="https://www.vimeo.com/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com', 'player.vimeo.com']
      })).assertEqual('<iframe></iframe>'
      );
    });
    it('Should allow iframe through if no hostname option is set', 0, function () {
      expect(
      sanitizeHtml('<iframe src="https://www.vimeo.com/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        }
      })).assertEqual('<iframe src="https://www.vimeo.com/embed/c2IlcS7AHxM"></iframe>'
      );
    });
    it('Should allow domains in an iframe that are in allowedIframeDomains', 0, function () {
      expect(
      sanitizeHtml('<iframe src="https://www.foo.us02web.zoom.us/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeDomains: ['zoom.us']
      })).assertEqual('<iframe src="https://www.foo.us02web.zoom.us/embed/c2IlcS7AHxM"></iframe>'
      );
    });
    it('Should allow second-level domains in an iframe that are in allowedIframeDomains', 0, function () {
      expect(
      sanitizeHtml('<iframe src="https://zoom.us/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeDomains: ['zoom.us']
      })).assertEqual('<iframe src="https://zoom.us/embed/c2IlcS7AHxM"></iframe>'
      );
    });
    it('Should remove iframe src urls that are not included in allowedIframeDomains', 0, function () {
      expect(
      sanitizeHtml('<iframe src="https://www.prefix.us02web.zoom.us/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeDomains: ['vimeo.com']
      })).assertEqual('<iframe></iframe>'
      );
    });
    it('Should remove iframe src urls with host that ends as allowed domains but not preceded with a dot', 0, function () {
      expect(
      sanitizeHtml('<iframe src="https://www.zoomzoom.us/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeDomains: ['zoom.us']
      })).assertEqual('<iframe></iframe>'
      );
    });
    it('Should allow hostnames in an iframe that are in allowedIframeHostnames and are not in allowedIframeDomains', 0, function () {
      expect(
      sanitizeHtml('<iframe src="https://www.youtube.com/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com', 'player.vimeo.com'],
        allowedIframeDomains: ['zoom.us']
      })).assertEqual('<iframe src="https://www.youtube.com/embed/c2IlcS7AHxM"></iframe>'
      );
    });
    it('Should allow hostnames in an iframe that are not in allowedIframeHostnames ' +
    'and are allowlisted in allowedIframeDomains', 0, function () {
      expect(
      sanitizeHtml('<iframe src="https://www.us02web.zoom.us/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com', 'player.vimeo.com'],
        allowedIframeDomains: ['zoom.us']
      })).assertEqual('<iframe src="https://www.us02web.zoom.us/embed/c2IlcS7AHxM"></iframe>'
      );
    });
    it('Should allow relative URLs for iframes by default', 0, function () {
      expect(
      sanitizeHtml('<iframe src="/foo"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        }
      })).assertEqual('<iframe src="/foo"></iframe>'
      );
    });
    it('Should allow relative URLs for iframes', 0, function () {
      expect(
      sanitizeHtml('<iframe src="/foo"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowIframeRelativeUrls: true
      })).assertEqual('<iframe src="/foo"></iframe>'
      );
    });
    it('Should remove relative URLs for iframes', 0, function () {
      expect(
      sanitizeHtml('<iframe src="/foo"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowIframeRelativeUrls: false
      })).assertEqual('<iframe></iframe>'
      );
    });
    it('Should remove relative URLs for iframes when other hostnames are specified in allowedIframeHostnames', 0, function () {
      expect(
      sanitizeHtml('<iframe src="/foo"></iframe><iframe src="https://www.youtube.com/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com']
      })).assertEqual('<iframe></iframe><iframe src="https://www.youtube.com/embed/c2IlcS7AHxM"></iframe>'
      );
    });
    it('Should allow relative and allowlisted hostname URLs for iframes', 0, function () {
      expect(
      sanitizeHtml('<iframe src="/foo"></iframe><iframe src="https://www.youtube.com/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowIframeRelativeUrls: true,
        allowedIframeHostnames: ['www.youtube.com']
      })).assertEqual('<iframe src="/foo"></iframe><iframe src="https://www.youtube.com/embed/c2IlcS7AHxM"></iframe>'
      );
    });
    it('Should allow protocol-relative URLs for the right domain for iframes', 0, function () {
      expect(
      sanitizeHtml('<iframe src="//www.youtube.com/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com', 'player.vimeo.com']
      })).assertEqual('<iframe src="//www.youtube.com/embed/c2IlcS7AHxM"></iframe>'
      );
    });
    it('Should not allow protocol-relative iframe urls that do not have proper hostname', 0, function () {
      expect(
      sanitizeHtml('<iframe src="//www.vimeo.com/embed/c2IlcS7AHxM"></iframe>', {
        allowedTags: ['p', 'iframe', 'a', 'img', 'i'],
        allowedAttributes: {
          iframe: ['src', 'href'],
          a: ['src', 'href'],
          img: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com', 'player.vimeo.com']
      })).assertEqual('<iframe></iframe>'
      );
    });
    it('Should only allow attributes to have any combination of specific values', 0, function () {
      expect(
      sanitizeHtml('<iframe name="IFRAME" allowfullscreen="true" sandbox="allow-forms allow-modals allow-orientation-lock allow-pointer-lock allow-popups allow-popups-to-escape-sandbox allow-presentation allow-same-origin allow-scripts allow-top-navigation"></iframe>', {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(['iframe']),
        allowedAttributes: {
          iframe: [
            {
              name: 'sandbox',
              multiple: true,
              values: ['allow-popups', 'allow-same-origin', 'allow-scripts']
            },
            'allowfullscreen'
          ]
        }
      }))
        .assertEqual('<iframe allowfullscreen="true" sandbox="allow-popups allow-same-origin allow-scripts"></iframe>');
    });
    it('Should only allow attributes that match a specific value', 0, function () {
      expect(
      sanitizeHtml('<iframe sandbox="allow-popups allow-modals"></iframe><iframe sandbox="allow-popups"></iframe><iframe sandbox="allow-scripts"></iframe>', {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(['iframe']),
        allowedAttributes: {
          iframe: [
            {
              name: 'sandbox',
              multiple: false,
              values: ['allow-popups', 'allow-same-origin', 'allow-scripts']
            }
          ]
        }
      }))
        .assertEqual('<iframe sandbox></iframe><iframe sandbox="allow-popups"></iframe><iframe sandbox="allow-scripts"></iframe>');
    }
    );
    it('Should not allow cite urls that do not have an allowed scheme', 0, function () {
      expect(
      sanitizeHtml('<q cite="http://www.google.com">HTTP</q><q cite="https://www.google.com">HTTPS</q><q cite="mailto://www.google.com">MAILTO</q><q cite="tel://www.google.com">TEL</q><q cite="ms-calculator:">ms-calculator</q><q cite="ftp://www.google.com">FTP</q><q cite="data://www.google.com">DATA</q><q cite="ldap://www.google.com">LDAP</q><q cite="acrobat://www.google.com">ACROBAT</q><q cite="vbscript://www.google.com">VBSCRIPT</q><q cite="file://www.google.com">FILE</q><q cite="rlogin://www.google.com">RLOGIN</q><q cite="webcal://www.google.com">WEBCAL</q><q cite="javascript://www.google.com">JAVASCRIPT</q><q cite="mms://www.google.com">MMS</q>', {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(['q']),
        allowedAttributes: {
          q: ['cite']
        },
        allowedSchemes: sanitizeHtml.defaults.allowedSchemes.concat(['tel'])
      }))
        .assertEqual('<q cite="http://www.google.com">HTTP</q><q cite="https://www.google.com">HTTPS</q><q cite="mailto://www.google.com">MAILTO</q><q cite="tel://www.google.com">TEL</q><q>ms-calculator</q><q cite="ftp://www.google.com">FTP</q><q>DATA</q><q>LDAP</q><q>ACROBAT</q><q>VBSCRIPT</q><q>FILE</q><q>RLOGIN</q><q>WEBCAL</q><q>JAVASCRIPT</q><q>MMS</q>');
    });
    it('Should encode &, <, > and where necessary, "', 0, function () {
      expect(sanitizeHtml('"< & >" <span class="&#34;test&#34;">cool</span>', {
        allowedTags: ['span'],
        allowedAttributes: {
          span: ['class']
        }
      })).assertEqual('"&lt; &amp; &gt;" <span class="&quot;test&quot;">cool</span>');
    });
    it('Should not pass through &0; unescaped if decodeEntities is true (the default)', 0, function () {
      expect(sanitizeHtml('<img src="<0&0;0.2&" />', {
        allowedTags: ['img']
      })).assertEqual('<img src="&lt;0&amp;0;0.2&amp;" />');
    });
    it('Should not double encode ampersands on HTML entities if decodeEntities is false (TODO more tests, this is too loose to rely upon)', 0, function () {
      const textIn = 'This &amp; & that &reg; &#x0000A; &#10; &plusmn; OK?';
      const expectedResult = 'This &amp; &amp; that &reg; &#x0000A; &#10; &plusmn; OK?';
      const sanitizeHtmlOptions = {
        parser: {
          decodeEntities: false
        }
      };
      expect(sanitizeHtml(textIn, sanitizeHtmlOptions)).assertEqual(expectedResult);
    });
    // TODO: make this test and similar tests for entities that are not
    // strictly valid pass, at which point decodeEntities: false is safe
    // to use.
    //
    // it('Should not pass through &0; (a bogus entity) unescaped if decodeEntities is false',0, function() {
    //   expect(sanitizeHtml(
    //     '<img src="<0&0;0.2&" />', {
    //       allowedTags: ['img'],
    //       parser: {
    //         decodeEntities: false
    //       }
    //     }), '<img src="&lt;0&amp;0;0.2&amp;" />');
    // });
    it('should escape markup not allowlisted and all its children in recursive mode', 0, function () {
      expect(
      sanitizeHtml('<div><wiggly>Hello<p>World</p></wiggly></div>', {
        disallowedTagsMode: 'recursiveEscape'
      })
      ).assertEqual(
        '<div>&lt;wiggly&gt;Hello&lt;p&gt;World&lt;/p&gt;&lt;/wiggly&gt;</div>'
      );
    });
    it('should escape markup not allowlisted and but not its children', 0, function () {
      expect(
      sanitizeHtml('<div><wiggly>Hello<p>World</p></wiggly></div>', {
        disallowedTagsMode: 'escape'
      })
      ).assertEqual(
        '<div>&lt;wiggly&gt;Hello<p>World</p>&lt;/wiggly&gt;</div>'
      );
    });
    it('should escape markup even when deocdeEntities is false', 0, function () {
      expect(
      sanitizeHtml('<wiggly>Hello</wiggly>', {
        disallowedTagsMode: 'escape',
        parser: {
          decodeEntities: false
        }
      })).assertEqual(
        '&lt;wiggly&gt;Hello&lt;/wiggly&gt;'
      );
    });
    it('should escape markup not allowlisted even within allowed markup', 0, function () {
      expect(
      sanitizeHtml('<div><wiggly>Hello<p>World</p><tiggly>JS</tiggly></wiggly></div>', {
        disallowedTagsMode: 'recursiveEscape'
      })
      ).assertEqual(
        '<div>&lt;wiggly&gt;Hello&lt;p&gt;World&lt;/p&gt;&lt;tiggly&gt;JS&lt;/tiggly&gt;&lt;/wiggly&gt;</div>'
      );
    });
    it('should escape markup not allowlisted even within allowed markup, but not the allowed markup itself', 0, function () {
      expect(
      sanitizeHtml('<div><wiggly>Hello<p>World</p><tiggly>JS</tiggly></wiggly></div>', {
        disallowedTagsMode: 'escape'
      })
      ).assertEqual(
        '<div>&lt;wiggly&gt;Hello<p>World</p>&lt;tiggly&gt;JS&lt;/tiggly&gt;&lt;/wiggly&gt;</div>'
      );
    });
    it('allows markup of depth 6 with a nestingLimit of depth 6', 0, function () {
      expect(
      sanitizeHtml('<div><div><div><div><div><div></div></div></div></div></div></div>', {
        nestingLimit: 6
      })).assertEqual(
        '<div><div><div><div><div><div></div></div></div></div></div></div>'
      );
    });
    it('disallows markup of depth 7 with a nestingLimit of depth 6', 0, function () {
      expect(
        // 7 divs here
      sanitizeHtml('<div><div><div><div><div><div><div>nested text</div></div></div></div></div></div></div>', {
        nestingLimit: 6
      }),
      ).assertEqual( // only 6 kept
        '<div><div><div><div><div><div>nested text</div></div></div></div></div></div>'
      );
    });
    it('should not allow simple append attacks on iframe hostname validation', 0, function () {
      expect(
      sanitizeHtml('<iframe src=//www.youtube.comissocool>', {
        allowedTags: ['iframe'],
        allowedAttributes: {
          iframe: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com']
      })).assertEqual(
        '<iframe></iframe>'
      );
    });
    it('should not allow IDNA (Internationalized Domain Name) iframe validation bypass attacks', 0, function () {
      expect(
      sanitizeHtml('<iframe src=//www.youtube.com%C3%9E.93.184.216.34.nip.io>', {
        allowedTags: ['iframe'],
        allowedAttributes: {
          iframe: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com']
      })).assertEqual(
        '<iframe></iframe>'
      );
    });
    it('should parse path-rooted relative URLs sensibly', 0, function () {
      expect(
      sanitizeHtml('<a href="/foo"></a>')).assertEqual(
        '<a href="/foo"></a>'
      );
    });
    it('should parse bare relative URLs sensibly', 0, function () {
      expect(
      sanitizeHtml('<a href="foo"></a>')).assertEqual(
        '<a href="foo"></a>'
      );
    });
    it('should parse ../ relative URLs sensibly', 0, function () {
      expect(
      sanitizeHtml('<a href="../../foo"></a>')).assertEqual(
        '<a href="../../foo"></a>'
      );
    });
    it('should parse protocol relative URLs sensibly', 0, function () {
      expect(
      sanitizeHtml('<a href="//foo.com/foo"></a>')).assertEqual(
        '<a href="//foo.com/foo"></a>'
      );
    });
    it('should reject attempts to hack our use of a relative: protocol in our test base URL', 0, function () {
      expect(
      sanitizeHtml('<iframe src="relative://relative-test/aha">', {
        allowedTags: ['iframe'],
        allowedAttributes: {
          iframe: ['src']
        }
      })).assertEqual(
        '<iframe></iframe>'
      );
    });
    it('Should prevent hostname bypass using protocol-relative src', 0, function () {
      expect(
      sanitizeHtml('<iframe src="/\\example.com"></iframe>', {
        allowedTags: ['iframe'],
        allowedAttributes: {
          iframe: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com'],
        allowIframeRelativeUrls: true
      })).assertEqual('<iframe></iframe>');
      expect(
      sanitizeHtml('<iframe src="\\/example.com"></iframe>', {
        allowedTags: ['iframe'],
        allowedAttributes: {
          iframe: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com'],
        allowIframeRelativeUrls: true
      })).assertEqual('<iframe></iframe>'
      );
      const linefeed = decodeURIComponent('%0A');
      expect(
      sanitizeHtml('<iframe src="/' + linefeed + '\\example.com"></iframe>', {
        allowedTags: ['iframe'],
        allowedAttributes: {
          iframe: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com'],
        allowIframeRelativeUrls: true
      })).assertEqual('<iframe></iframe>'
      );
      const creturn = decodeURIComponent('%0D');
      expect(
      sanitizeHtml('<iframe src="/' + creturn + '\\example.com"></iframe>', {
        allowedTags: ['iframe'],
        allowedAttributes: {
          iframe: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com'],
        allowIframeRelativeUrls: true
      })).assertEqual('<iframe></iframe>'
      );
      const tab = decodeURIComponent('%09');
      expect(
      sanitizeHtml('<iframe src="/' + tab + '\\example.com"></iframe>', {
        allowedTags: ['iframe'],
        allowedAttributes: {
          iframe: ['src']
        },
        allowedIframeHostnames: ['www.youtube.com'],
        allowIframeRelativeUrls: true
      })).assertEqual('<iframe></iframe>'
      );
    });
    it('Should allow protocol-relative URLs for script tag', 0, function () {
      expect(
      sanitizeHtml('<script src="//example.com/script.js"></script>', {
        allowedTags: ['script'],
        allowedAttributes: {
          script: ['src']
        }
      })).assertEqual('<script src="//example.com/script.js"></script>'
      );
    });
  })

}