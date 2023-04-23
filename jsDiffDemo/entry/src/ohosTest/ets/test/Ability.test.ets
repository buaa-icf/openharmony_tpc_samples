/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  diffChars,
  diffWords,
  diffWordsWithSpace,
  diffLines,
  diffTrimmedLines,
  diffSentences,
  diffCss,
  diffJson,
  diffArrays,
  createPatch,
  createTwoFilesPatch,
  structuredPatch,
  parsePatch,
  convertChangesToXML,
  canonicalize,
  merge,
  convertChangesToDMP,
} from 'diff'

import applyTest from './apply.test'

export default function abilityTest() {
  describe('jsDiffTest', function () {
    //-----------------------------------diffChars-------------------------------------------------
    it('diffChars_should_diff_chars', 0, function () {
      const diffResult = diffChars('New Value.', 'New ValueMoreData.');
      expect(convertChangesToXML(diffResult)).assertEqual('New Value<ins>MoreData</ins>.');
    })
    it('diffChars_is_considered_when_there_is_no_difference', 0, function () {
      const diffResult = diffChars('New Value.', 'New value.', {
        ignoreCase: true
      });
      expect(convertChangesToXML(diffResult)).assertEqual('New value.');
    })
    it('diffChars_is_considered_when_there_is_a_difference', 0, function () {
      const diffResult = diffChars('New Values.', 'New value.', {
        ignoreCase: true
      });
      expect(convertChangesToXML(diffResult)).assertEqual('New value<del>s</del>.');
    })

    //-----------------------------------diffWords-------------------------------------------------
    it('diffWords_width_whitespace', 0, function () {
      const diffResult = diffWords('New Value', 'New  ValueMoreData');
      expect(convertChangesToXML(diffResult)).assertEqual('New  <del>Value</del><ins>ValueMoreData</ins>');
    })
    it('diffWords_multiple_whitespace_value', 0, function () {
      const diffResult = diffWords('New Value  ', 'New  ValueMoreData ');
      expect(convertChangesToXML(diffResult)).assertEqual('New  <del>Value</del><ins>ValueMoreData</ins> ');
    })
    it('diffWords_on_word_boundaries', 0, function () {
      let diffResult = diffWords('New :Value:Test', 'New  ValueMoreData ');
      expect(convertChangesToXML(diffResult)).assertEqual('New  <del>:Value:Test</del><ins>ValueMoreData </ins>');

      diffResult = diffWords('New Value:Test', 'New  Value:MoreData ');
      expect(convertChangesToXML(diffResult)).assertEqual('New  Value:<del>Test</del><ins>MoreData </ins>');

      diffResult = diffWords('New Value-Test', 'New  Value:MoreData ');
      expect(convertChangesToXML(diffResult)).assertEqual('New  Value<del>-Test</del><ins>:MoreData </ins>');

      diffResult = diffWords('New Value', 'New  Value:MoreData ');
      expect(convertChangesToXML(diffResult)).assertEqual('New  Value<ins>:MoreData </ins>');
    })
    it('diffWords_identity_or_empty_or_identical_content', 0, function () {
      const diffResult = diffWords('New Value', 'New Value');
      expect(convertChangesToXML(diffResult)).assertEqual('New Value');
      const diffResult_empty = diffWords('', '');
      expect(convertChangesToXML(diffResult_empty)).assertEqual('');
      const diffResult_identical = diffWords('New Value', 'New  Value');
      expect(convertChangesToXML(diffResult_identical)).assertEqual('New  Value');

    })
    it('diffWords_Empty_diffs', 0, function () {
      const diffResult = diffWords('New Value', '');
      expect(diffResult.length).assertEqual(1);
      expect(convertChangesToXML(diffResult)).assertEqual('<del>New Value</del>');
      const diffResult_old_content = diffWords('', 'New Value');
      expect(convertChangesToXML(diffResult_old_content)).assertEqual('<ins>New Value</ins>');
      const diffResult_anchor_value = diffWords('New Value New Value', 'Value Value New New');
      expect(convertChangesToXML(diffResult_anchor_value))
        .assertEqual('<del>New</del><ins>Value</ins> Value New <del>Value</del><ins>New</ins>');
    })

    it('diffWords_should_include_count_with_identity_cases', 0, function () {
      expect(diffWords('foo', 'foo')).assertDeepEquals([{
        value: 'foo', count: 1
      }]);
      expect(diffWords('foo bar', 'foo bar')).assertDeepEquals([{
        value: 'foo bar', count: 3
      }]);
    })
    it('diffWords_should_include_count_with_empty_cases', 0, function () {
      expect(diffWords('foo', '')).assertDeepEquals([{
        value: 'foo', count: 1, added: undefined, removed: true
      }]);
      expect(diffWords('foo bar', '')).assertDeepEquals([{
        value: 'foo bar', count: 3, added: undefined, removed: true
      }]);
      expect(diffWords('', 'foo')).assertDeepEquals([{
        value: 'foo', count: 1, added: true, removed: undefined
      }]);
      expect(diffWords('', 'foo bar')).assertDeepEquals([{
        value: 'foo bar', count: 3, added: true, removed: undefined
      }]);
    })
    it('diffWords_ignore_whitespace', 0, function () {
      expect(diffWords('hase igel fuchs', 'hase igel fuchs')).assertDeepEquals([{
        count: 5, value: 'hase igel fuchs'
      }]);
      expect(diffWords('hase igel fuchs', 'hase igel fuchs\n')).assertDeepEquals([{
        count: 5, value: 'hase igel fuchs\n'
      }]);
      expect(diffWords('hase igel fuchs\n', 'hase igel fuchs')).assertDeepEquals([{
        count: 5, value: 'hase igel fuchs\n'
      }]);
      expect(diffWords('hase igel fuchs', 'hase igel\nfuchs')).assertDeepEquals([{
        count: 5, value: 'hase igel\nfuchs'
      }]);
      expect(diffWords('hase igel\nfuchs', 'hase igel fuchs')).assertDeepEquals([{
        count: 5, value: 'hase igel fuchs'
      }]);
    })
    it('diffWords_whitespace_with_flag', 0, function () {
      const diffResult = diffWords('New Value', 'New  ValueMoreData', {
        ignoreWhitespace: false
      });
      expect(convertChangesToXML(diffResult)).assertEqual('New<del> Value</del><ins>  ValueMoreData</ins>');
    })
    it('diffWords_with_only_whitespace', 0, function () {
      let diffResult = diffWords('', ' ');
      expect(convertChangesToXML(diffResult)).assertEqual('<ins> </ins>');
      diffResult = diffWords(' ', '');
      expect(convertChangesToXML(diffResult)).assertEqual('<del> </del>');
    })
    it('diffWords_async_whitespace', 0, function () {
      diffWords('New Value', 'New  ValueMoreData', function (err, diffResult) {
        expect(err).assertUndefined();
        expect(convertChangesToXML(diffResult)).assertEqual('New  <del>Value</del><ins>ValueMoreData</ins>');
      });
    })

    it('diffWords_async_multiple_whitespace_values', 0, function () {
      diffWords('New Value  ', 'New  ValueMoreData ', function (err, diffResult) {
        expect(err).assertUndefined();
        expect(convertChangesToXML(diffResult)).assertEqual('New  <del>Value</del><ins>ValueMoreData</ins> ');
      });
    })

    it('diffWords_async_boundary', 0, function () {
      diffWords('New :Value:Test', 'New  ValueMoreData ', function (err, diffResult) {
        expect(err).assertUndefined();
        expect(convertChangesToXML(diffResult)).assertEqual('New  <del>:Value:Test</del><ins>ValueMoreData </ins>');
      });
    })

    it('diffWords_async_handle_empty', 0, function () {
      diffWords('', '', function (err, diffResult) {
        expect(err).assertUndefined();
        expect(convertChangesToXML(diffResult)).assertEqual('');
      });
    })

    it('diffWords_async_identical_content', 0, function () {
      diffWords('New Value', '', function (err, diffResult) {
        expect(err).assertUndefined();
        expect(convertChangesToXML(diffResult)).assertEqual('<del>New Value</del>');
      });
    })

    it('diffWords_async_empty_new_content', 0, function () {
      diffWords('New Value', 'New  Value', function (err, diffResult) {
        expect(err).assertUndefined();
        expect(convertChangesToXML(diffResult)).assertEqual('New  Value');
      });
    })

    it('diffWords_async_empty_old_content', 0, function () {
      diffWords('', 'New Value', function (err, diffResult) {
        expect(convertChangesToXML(diffResult)).assertEqual('<ins>New Value</ins>');
      });
    })

    it('diffWords_async_no_anchor_value', 0, function () {
      diffWords('New Value New Value', 'Value Value New New', function (err, diffResult) {
        expect(convertChangesToXML(diffResult))
          .assertEqual('<del>New</del><ins>Value</ins> Value New <del>Value</del><ins>New</ins>');
      });
    })

    //-----------------------------------diffWordsWithSpace-------------------------------------------------
    it('diffWordsWithSpace_diff_whitespace', 0, function () {
      const diffResult = diffWordsWithSpace('New Value', 'New  ValueMoreData');
      expect(convertChangesToXML(diffResult)).assertEqual('New<del> Value</del><ins>  ValueMoreData</ins>');
    })

    it('diffWordsWithSpace_multiple_whitespace_values', 0, function () {
      const diffResult = diffWordsWithSpace('New Value  ', 'New  ValueMoreData ');
      expect(convertChangesToXML(diffResult)).assertEqual('New<ins>  ValueMoreData</ins> <del>Value  </del>');
    })

    it('diffWordsWithSpace_inserts_values_in_parenthesis', 0, function () {
      const diffResult = diffWordsWithSpace('()', '(word)');
      expect(convertChangesToXML(diffResult)).assertEqual('(<ins>word</ins>)')
    })

    it('diffWordsWithSpace_inserts_values_in_brackets', 0, function () {
      const diffResult = diffWordsWithSpace('[]', '[word]');
      expect(convertChangesToXML(diffResult)).assertEqual('[<ins>word</ins>]');
    })
    it('diffWordsWithSpace_inserts_values_in_curly_braces', 0, function () {
      const diffResult = diffWordsWithSpace('{}', '{word}');
      expect(convertChangesToXML(diffResult)).assertEqual('{<ins>word</ins>}');
    })

    it('diffWordsWithSpace_inserts_values_in_quotes', 0, function () {
      const diffResult = diffWordsWithSpace("''", "'word'");
      expect(convertChangesToXML(diffResult)).assertEqual("'<ins>word</ins>'");
    })
    it('diffWordsWithSpace_inserts_values_in_double_quotes', 0, function () {
      const diffResult = diffWordsWithSpace('""', '"word"');
      expect(convertChangesToXML(diffResult)).assertEqual('&quot;<ins>word</ins>&quot;');
    })
    it('diffWordsWithSpace_threat_newline_as_separate_token', 0, function () {
      // #180
      const diffResult1 = diffWordsWithSpace('foo\nbar', 'foo\n\n\nbar');
      expect(convertChangesToXML(diffResult1)).assertEqual('foo\n<ins>\n\n</ins>bar');
      // #211
      const diffResult2 = diffWordsWithSpace('A\n\nB\n', 'A\nB\n');
      expect(convertChangesToXML(diffResult2)).assertEqual('A\n<del>\n</del>B\n');
    })

    it('diffWordsWithSpace_async_operations', 0, function () {
      diffWordsWithSpace('New Value  ', 'New  ValueMoreData ', function (err, diffResult) {
        expect(convertChangesToXML(diffResult)).assertEqual('New<ins>  ValueMoreData</ins> <del>Value  </del>');
      });
    })
    it('diffWordsWithSpace_case_insensitivity', 0, function () {
      const diffResult = diffWordsWithSpace('new value', 'New  ValueMoreData', {
        ignoreCase: true
      });
      expect(convertChangesToXML(diffResult)).assertEqual('New<del> value</del><ins>  ValueMoreData</ins>');
      const diffResult_no_difference = diffWordsWithSpace('new value', 'New Value', {
        ignoreCase: true
      });
      expect(convertChangesToXML(diffResult_no_difference)).assertEqual('New Value');
    })
    //-----------------------------------diffLines-------------------------------------------------
    it('diffLines_should_diff_lines', 0, function () {
      const diffResult = diffLines(
        'line\nold value\nline',
        'line\nnew value\nline');
      expect(convertChangesToXML(diffResult)).assertEqual('line\n<del>old value\n</del><ins>new value\n</ins>line');
      const diffResult1 = diffLines(
        'line\nvalue\nline',
        'line\nvalue\nline');
      expect(convertChangesToXML(diffResult1)).assertEqual('line\nvalue\nline');
      const diffResult2 = diffLines(
        'line\nvalue \nline',
        'line\nvalue\nline');
      expect(convertChangesToXML(diffResult2)).assertEqual('line\n<del>value \n</del><ins>value\n</ins>line');
      const diffResult3 = diffLines(
        'line\r\nold value \r\nline',
        'line\r\nnew value\r\nline');
      expect(convertChangesToXML(diffResult3))
        .assertEqual('line\r\n<del>old value \r\n</del><ins>new value\r\n</ins>line');
      const diffResult4 = diffLines(
        'line\n\nold value \n\nline',
        'line\n\nnew value\n\nline');
      expect(convertChangesToXML(diffResult4))
        .assertEqual('line\n\n<del>old value \n</del><ins>new value\n</ins>\nline');
      const diffResult5 = diffLines(
        'line\n\nold value \n\nline',
        '');
      expect(convertChangesToXML(diffResult5)).assertEqual('<del>line\n\nold value \n\nline</del>');

      expect(diffLines('restaurant', 'restaurant\n', {
        newlineIsToken: true
      })).assertDeepEquals([
        {
          value: 'restaurant', count: 1
        },
        {
          value: '\n', count: 1, added: true, removed: undefined
        }
      ]);
      expect(diffLines('restaurant', 'restaurant\nhello', {
        newlineIsToken: true
      })).assertDeepEquals([
        {
          value: 'restaurant', count: 1
        },
        {
          value: '\nhello', count: 2, added: true, removed: undefined
        }
      ]);
    })

    //-----------------------------------diffTrimmedLines-------------------------------------------------
    it('diffTrimmedLines', 0, function () {
      const diffResult = diffTrimmedLines(
        'line\nold value\nline',
        'line\nnew value\nline');
      expect(convertChangesToXML(diffResult)).assertEqual('line\n<del>old value\n</del><ins>new value\n</ins>line');
      const diffResult1 = diffTrimmedLines(
        'line\nvalue\nline',
        'line\nvalue\nline');
      expect(convertChangesToXML(diffResult1)).assertEqual('line\nvalue\nline');
      const diffResult2 = diffTrimmedLines(
        'line\nvalue \nline',
        'line\nvalue\nline');
      expect(convertChangesToXML(diffResult2)).assertEqual('line\nvalue\nline');
      const diffResult3 = diffTrimmedLines(
        'line\r\nold value \r\nline',
        'line\r\nnew value\r\nline');
      expect(convertChangesToXML(diffResult3))
        .assertEqual('line\r\n<del>old value\r\n</del><ins>new value\r\n</ins>line');
    })

    //-----------------------------------diffSentences-------------------------------------------------
    it('diffSentences', 0, function () {
      const diffResult = diffSentences('New Value.', 'New ValueMoreData.');
      expect(convertChangesToXML(diffResult)).assertEqual('<del>New Value.</del><ins>New ValueMoreData.</ins>');
      const diffResult1 = diffSentences('Here im. Rock you like old man.', 'Here im. Rock you like hurricane.');
      expect(convertChangesToXML(diffResult1))
        .assertEqual('Here im. <del>Rock you like old man.</del><ins>Rock you like hurricane.</ins>');
    })

    //-----------------------------------diffCss-------------------------------------------------
    it('diffCss_should_diff_css', 0, function () {
      const diffResult = diffCss(
        '.test,#value .test{margin-left:50px;margin-right:-40px}',
        '.test2, #value2 .test {\nmargin-top:50px;\nmargin-right:-400px;\n}');
      expect(convertChangesToXML(diffResult)).assertEqual(
        '<del>.test</del><ins>.test2</ins>,<del>#value</del> <ins>#value2 </ins>.test<ins> </ins>{'
        + '<del>margin-left</del><ins>\nmargin-top</ins>:50px;<ins>\n</ins>'
        + 'margin-right:<del>-40px</del><ins>-400px;\n</ins>}');
    })

    //-----------------------------------diffJson-------------------------------------------------
    it('diffJson_should_accept_objects', 0, function () {
      expect(diffJson(
        {
          a: 123, b: 456, c: 789
        },
        {
          a: 123, b: 456
        }
      )).assertDeepEquals([
        {
          count: 3, value: '{\n  "a": 123,\n  "b": 456,\n'
        },
        {
          count: 1, value: '  "c": 789\n', added: undefined, removed: true
        },
        {
          count: 1, value: '}'
        }
      ]);
    })

    it('diffJson_should_accept_objects_with_different_order', 0, function () {
      expect(diffJson(
        {
          a: 123, b: 456, c: 789
        },
        {
          b: 456, a: 123
        }
      )).assertDeepEquals([
        {
          count: 3, value: '{\n  "a": 123,\n  "b": 456,\n'
        },
        {
          count: 1, value: '  "c": 789\n', added: undefined, removed: true
        },
        {
          count: 1, value: '}'
        }
      ]);
    })

    it('diffJson_should_accept_objects_with_nested_structures', 0, function () {
      expect(diffJson(
        {
          a: 123, b: 456, c: [1, 2, {
          foo: 'bar'
        }, 4]
        },
        {
          a: 123, b: 456, c: [1, {
          foo: 'bar'
        }, 4]
        }
      )).assertDeepEquals([
        {
          count: 5, value: '{\n  "a": 123,\n  "b": 456,\n  "c": [\n    1,\n'
        },
        {
          count: 1, value: '    2,\n', added: undefined, removed: true
        },
        {
          count: 6, value: '    {\n      "foo": "bar"\n    },\n    4\n  ]\n}'
        }
      ]);
    })

    it('diffJson_should_accept_dates', 0, function () {
      expect(diffJson(
        {
          a: new Date(123), b: new Date(456), c: new Date(789)
        },
        {
          a: new Date(124), b: new Date(456)
        }
      )).assertDeepEquals([
        {
          count: 1, value: '{\n'
        },
        {
          count: 1, value: '  "a": "1970-01-01T00:00:00.123Z",\n', added: undefined, removed: true
        },
        {
          count: 1, value: '  "a": "1970-01-01T00:00:00.124Z",\n', added: true, removed: undefined
        },
        {
          count: 1, value: '  "b": "1970-01-01T00:00:00.456Z",\n'
        },
        {
          count: 1, value: '  "c": "1970-01-01T00:00:00.789Z"\n', added: undefined, removed: true
        },
        {
          count: 1, value: '}'
        }
      ]);
    })

    it('diffJson_should_accept_undefined_key', 0, function () {
      expect(diffJson(
        {
          a: 123, b: 456, c: null
        },
        {
          a: 123, b: 456
        }
      )).assertDeepEquals([
        {
          count: 3, value: '{\n  "a": 123,\n  "b": 456,\n'
        },
        {
          count: 1, value: '  "c": null\n', added: undefined, removed: true
        },
        {
          count: 1, value: '}'
        }
      ]);
      expect(diffJson(
        {
          a: 123, b: 456, c: undefined
        },
        {
          a: 123, b: 456
        }
      )).assertDeepEquals([
        {
          count: 4, value: '{\n  "a": 123,\n  "b": 456\n}'
        }
      ]);
      expect(diffJson(
        {
          a: 123, b: 456, c: undefined
        },
        {
          a: 123, b: 456
        },
        {
          undefinedReplacement: null
        }
      )).assertDeepEquals([
        {
          count: 3, value: '{\n  "a": 123,\n  "b": 456,\n'
        },
        {
          count: 1, value: '  "c": null\n', added: undefined, removed: true
        },
        {
          count: 1, value: '}'
        }
      ]);
    })

    it('diffJson_should_accept_already_stringified_JSON', 0, function () {
      expect(diffJson(
      JSON.stringify({
        a: 123, b: 456, c: 789
      }, undefined, '  '),
      JSON.stringify({
        a: 123, b: 456
      }, undefined, '  ')
      )).assertDeepEquals([
        {
          count: 3, value: '{\n  "a": 123,\n  "b": 456,\n'
        },
        {
          count: 1, value: '  "c": 789\n', added: undefined, removed: true
        },
        {
          count: 1, value: '}'
        }
      ]);
    })
    it('diffJson_should_ignore_trailing_comma_on_the_previous', 0, function () {
      const diffResult = diffJson(
        {
          a: 123, b: 456, c: 789
        },
        {
          a: 123, b: 456
        });
      expect(convertChangesToXML(diffResult))
        .assertDeepEquals('{\n  &quot;a&quot;: 123,\n  &quot;b&quot;: 456,\n<del>  &quot;c&quot;: 789\n</del>}');
    })

    it('diffJson_should_ignore_the_missing_trailing_comma_on_the_last_line', 0, function () {
      const diffResult = diffJson(
        {
          a: 123, b: 456
        },
        {
          a: 123, b: 456, c: 789
        });
      expect(convertChangesToXML(diffResult))
        .assertEqual('{\n  &quot;a&quot;: 123,\n  &quot;b&quot;: 456,\n<ins>  &quot;c&quot;: 789\n</ins>}');
    })
    it('diffJson_should_accept_a_custom_JSON.stringify_replacer_function', 0, function () {
      let s = diffJson(
        {
          a: 123
        },
        {
          a: /foo/
        }
      );
      expect(s).assertDeepEquals(
        [
          {
            count: 1, value: '{\n'
          },
          {
            count: 1, value: '  "a": 123\n', added: undefined, removed: true
          },
          {
            count: 1, value: '  "a": {}\n', added: true, removed: undefined
          },
          {
            count: 1, value: '}'
          }
        ]
      );

      expect(diffJson(
        {
          a: 123
        },
        {
          a: /foo/gi
        },
        {
          stringifyReplacer: (k, v) => v instanceof RegExp ? v.toString() : v
        }
      )).assertDeepEquals([
        {
          count: 1, value: '{\n'
        },
        {
          count: 1, value: '  "a": 123\n', added: undefined, removed: true
        },
        {
          count: 1, value: '  "a": "/foo/gi"\n', added: true, removed: undefined
        },
        {
          count: 1, value: '}'
        }
      ]);

      expect(diffJson(
        {
          a: 123
        },
        {
          a: new Error('ohaider')
        },
        {
          stringifyReplacer: (k, v) => v instanceof Error ? `${v.name}: ${v.message}` : v
        }
      )).assertDeepEquals([
        {
          count: 1, value: '{\n'
        },
        {
          count: 1, value: '  "a": 123\n', added: undefined, removed: true
        },
        {
          count: 1, value: '  "a": "Error: ohaider"\n', added: true, removed: undefined
        },
        {
          count: 1, value: '}'
        }
      ]);

      expect(diffJson(
        {
          a: 123
        },
        {
          a: [new Error('ohaider')]
        },
        {
          stringifyReplacer: (k, v) => v instanceof Error ? `${v.name}: ${v.message}` : v
        }
      )).assertDeepEquals([
        {
          count: 1, value: '{\n'
        },
        {
          count: 1, value: '  "a": 123\n', added: undefined, removed: true
        },
        {
          count: 3, value: '  "a": [\n    "Error: ohaider"\n  ]\n', added: true, removed: undefined
        },
        {
          count: 1, value: '}'
        }
      ]);
    })
    //-----------------------------------diffArrays-------------------------------------------------
    it('diffArrays_should_diff_arrays', 0, function () {
      const a = {
        a: 0
      }, b = {
        b: 1
      }, c = {
        c: 2
      };
      const diffResult = diffArrays([a, b, c], [a, c, b]);
      let result = [
        {
          count: 1, value: [a]
        },
        {
          count: 1, value: [c], removed: undefined, added: true
        },
        {
          count: 1, value: [b]
        },
        {
          count: 1, value: [c], removed: true, added: undefined
        }
      ]
      expect(result).assertDeepEquals(diffResult)
    })

    it('diffArrays_should_diff_falsey_values', 0, function () {
      const a = false;
      const b = 0;
      const c = '';
      const arrayA = [c, b, a, b, a, c];
      const arrayB = [a, b, c, a, b, b, a];
      const diffResult = diffArrays(arrayA, arrayB)
      let result = [
        {
          count: 2, value: [a, b], removed: undefined, added: true
        },
        {
          count: 1, value: [c]
        },
        {
          count: 1, value: [b], removed: true, added: undefined
        },
        {
          count: 2, value: [a, b]
        },
        {
          count: 1, value: [b], removed: undefined, added: true
        },
        {
          count: 1, value: [a]
        },
        {
          count: 1, value: [c], removed: true, added: undefined
        }
      ]
      expect(result).assertDeepEquals(diffResult)
    })

    it('diffArrays_should_diff_arrays_with_comparato', 0, function () {
      const a = {
        a: 0
      }, b = {
        a: 1
      }, c = {
        a: 2
      }, d = {
        a: 3
      };

      function comparator(left, right) {
        return left.a === right.a;
      }

      const diffResult = diffArrays([a, b, c], [a, b, d], {
        comparator: comparator
      });
      let result = [
        {
          count: 2, value: [a, b]
        },
        {
          count: 1, value: [c], removed: true, added: undefined
        },
        {
          count: 1, value: [d], removed: undefined, added: true
        }
      ]
      expect(result).assertDeepEquals(diffResult)
    })

    it('diffArrays_returns_correct_deep_result_for_identical_inputs', 0, function () {
      const value = [0, 1, 2];
      const expected = [
        {
          count: value.length, value: value
        }
      ];
      const input = value.slice();
      const diffResult = diffArrays(input, input);
      expect(diffResult).assertDeepEquals(expected);
    })

    it('createPatch', 0, function () {
      expect(createPatch('test', 'line2\nline3\nline5\n', 'line2\nline3\nline4\nline5\n', 'header1', 'header2'))
        .assertEqual(
          'Index: test\n'
          + '===================================================================\n'
          + '--- test\theader1\n'
          + '+++ test\theader2\n'
          + '@@ -1,3 +1,4 @@\n'
          + ' line2\n'
          + ' line3\n'
          + '+line4\n'
          + ' line5\n');
    })
    it('createTwoFilesPatch', 0, function () {
      const expectedResult =
        '===================================================================\n'
        + '--- foo\n'
        + '+++ bar\n';
      const diffResult = createTwoFilesPatch('foo', 'bar', '', '');
      expect(diffResult).assertEqual(expectedResult);
    })

    it('structuredPatch', 0, function () {
      const res = structuredPatch(
        'oldfile', 'newfile',
        'line2\nline3\nline4\n', 'line2\nline3\nline5',
        'header1', 'header2'
      );
      const result = {
        oldFileName: 'oldfile',
        newFileName: 'newfile',
        oldHeader: 'header1',
        newHeader: 'header2',
        hunks: [{
          oldStart: 1,
          oldLines: 3,
          newStart: 1,
          newLines: 3,
          lines: [' line2', ' line3', '-line4', '+line5', '\\ No newline at end of file']
        }]
      };
      expect(JSON.stringify(res)).assertEqual(JSON.stringify(result));
    })

    it('parsePatch', 0, function () {
      const result = [
        {
          "index": "test",
          "oldFileName": "test",
          "oldHeader": "header1",
          "newFileName": "test",
          "newHeader": "header2",
          "hunks":
          [
            {
              "oldStart": 1,
              "oldLines": 3,
              "newStart": 1,
              "newLines": 4,
              "lines":
              [" line2", " line3", "+line4", " line5"],
              "linedelimiters": ["\n", "\n", "\n", "\n"
              ]
            }
          ]
        }
      ]
      const patch = parsePatch(
        'Index: test\n'
        + '===================================================================\n'
        + '--- test\theader1\n'
        + '+++ test\theader2\n'
        + '@@ -1,3 +1,4 @@\n'
        + ' line2\n'
        + ' line3\n'
        + '+line4\n'
        + ' line5\n');
      expect(JSON.stringify(result)).assertEqual(JSON.stringify(patch))
    })

    it('convertChangesToXML', 0, function () {
      const result = "<del>beep</del><ins>beepboob</ins> <del>boop   afff测试</del><ins>2022真热</ins>样本<del>one1</del><ins> e </ins>"
      const one = 'beep boop   afff测试样本one1';
      const other = 'beepboob 2022真热样本 e ';
      const diff = diffWords(one, other);
      const patch = convertChangesToXML(diff);
      expect(result).assertEqual(patch)
    })

    it('convertChangesToDMP', 0, function () {
      const diffResult = diffWords('New Value  ', 'New  ValueMoreData ');
      expect(JSON.stringify(convertChangesToDMP(diffResult)))
        .assertEqual(JSON.stringify([[0, 'New  '], [-1, 'Value'], [1, 'ValueMoreData'], [0, ' ']]));
    })

    it('merge', 0, function () {
      expect(JSON.stringify(merge('foo\nbar\nbaz\n', 'foo\nbaz\nbat\n', 'foo\nbaz\n'))).assertEqual(JSON.stringify({
        hunks: [
          {
            oldStart: 1,
            oldLines: 2,
            newStart: 1,
            newLines: 4,
            lines: [
              ' foo',
              '+bar',
              ' baz',
              '+bat'
            ]
          }
        ]
      }));
    })

    //-----------------------------------canonicalize-------------------------------------------------
    it('canonicalize_should_put_the_keys_in_canonical_order', 0, function () {
      let result = canonicalize({
        b: 456, a: 123
      }, null, null);
      expect(getKeys(result)).assertDeepEquals(['a', 'b']);
    })

    it('canonicalize_should_dive_into_nested_objects', 0, function () {
      const canonicalObj = canonicalize({
        b: 456, a: {
          d: 123, c: 456
        }
      }, null, null);
      expect(getKeys(canonicalObj.a)).assertDeepEquals(['c', 'd']);
    })
    it('canonicalize_should_dive_into_nested_arrays', 0, function () {
      const canonicalObj = canonicalize({
        b: 456, a: [789, {
          d: 123, c: 456
        }]
      }, null, null);
      expect(getKeys(canonicalObj.a[1])).assertDeepEquals(['c', 'd']);
    })
    it('canonicalize_should_handle_circular_references_correctly', 0, function () {
      const obj = {
        b: 456
      };
      // @ts-ignore
      obj.a = obj;
      const canonicalObj = canonicalize(obj, null, null);
      expect(getKeys(canonicalObj)).assertDeepEquals(['a', 'b']);
      expect(getKeys(canonicalObj.a)).assertDeepEquals(['a', 'b']);
    })

  })

  function getKeys(obj) {
    const keys = [];
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        keys.push(key);
      }
    }
    return keys;
  }
}