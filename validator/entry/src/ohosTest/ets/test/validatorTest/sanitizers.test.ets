/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

import validator from 'validator';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

export default function SanitizersTest() {
  describe('Sanitizers', function () {
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

    function test(options) {
      let args = options.args || [];

      args.unshift(null);

      Object.keys(options.expect).forEach((input) => {
        args[0] = input;
        let result = validator[options.sanitizer](...args);
        let expected = options.expect[input];
        if (isNaN(result) && !result.length && isNaN(expected)) {
          expect(result).assertNaN()
          return;
        }
        expect(result).assertEqual(expected)
      });
    }

    it('should_sanitize_boolean_strings', 0, () => {
      test({
        sanitizer: 'toBoolean',
        expect: {
          0: false,
          '': false,
          1: true,
          true: true,
          True: true,
          TRUE: true,
          foobar: true,
          '   ': true,
          false: false,
          False: false,
          FALSE: false,
        },
      });
      test({
        sanitizer: 'toBoolean',
        args: [true], // strict
        expect: {
          0: false,
          '': false,
          1: true,
          true: true,
          True: true,
          TRUE: true,
          foobar: false,
          '   ': false,
          false: false,
          False: false,
          FALSE: false,
        },
      });
    });

    it('should_trim_whitespace', 0, () => {
      test({
        sanitizer: 'trim',
        expect: {
          '  \r\n\tfoo  \r\n\t   ': 'foo',
          '      \r': '',
        },
      });

      test({
        sanitizer: 'ltrim',
        expect: {
          '  \r\n\tfoo  \r\n\t   ': 'foo  \r\n\t   ',
          '   \t  \n': '',
        },
      });

      test({
        sanitizer: 'rtrim',
        expect: {
          '  \r\n\tfoo  \r\n\t   ': '  \r\n\tfoo',
          ' \r\n  \t': '',
        },
      });
    });

    it('should_trim_custom_characters', 0, () => {
      test({
        sanitizer: 'trim',
        args: ['01'],
        expect: {
          '010100201000': '2'
        },
      });

      test({
        sanitizer: 'ltrim',
        args: ['01'],
        expect: {
          '010100201000': '201000'
        },
      });

      test({
        sanitizer: 'ltrim',
        args: ['\\S'],
        expect: {
          '\\S01010020100001': '01010020100001'
        },
      });


      test({
        sanitizer: 'rtrim',
        args: ['01'],
        expect: {
          '010100201000': '0101002'
        },
      });

      test({
        sanitizer: 'rtrim',
        args: ['\\S'],
        expect: {
          '01010020100001\\S': '01010020100001'
        },
      });
    });

    it('should_convert_strings_to_integers', 0, () => {
      test({
        sanitizer: 'toInt',
        expect: {
          3: 3,
          ' 3 ': 3,
          2.4: 2,
          foo: NaN,
        },
      });

      test({
        sanitizer: 'toInt',
        args: [16],
        expect: {
          ff: 255
        },
      });
    });

    it('should_convert_strings_to_floats', 0, () => {
      test({
        sanitizer: 'toFloat',
        expect: {
          2: 2.0,
          '2.': 2.0,
          '-2.5': -2.5,
          '.5': 0.5,
          '2020-01-06T14:31:00.135Z': NaN,
          foo: NaN,
        },
      });
    });

    it('should_escape_HTML', 0, () => {
      test({
        sanitizer: 'escape',
        expect: {
          '<script> alert("xss&fun"); </script>':
          '&lt;script&gt; alert(&quot;xss&amp;fun&quot;); &lt;&#x2F;script&gt;',

          "<script> alert('xss&fun'); </script>":
          '&lt;script&gt; alert(&#x27;xss&amp;fun&#x27;); &lt;&#x2F;script&gt;',

          'Backtick: `':
          'Backtick: &#96;',

          'Backslash: \\':
          'Backslash: &#x5C;',
        },
      });
    });

    it('should_unescape_HTML', 0, () => {
      test({
        sanitizer: 'unescape',
        expect: {
          '&lt;script&gt; alert(&quot;xss&amp;fun&quot;); &lt;&#x2F;script&gt;':
          '<script> alert("xss&fun"); </script>',

          '&lt;script&gt; alert(&#x27;xss&amp;fun&#x27;); &lt;&#x2F;script&gt;':
          "<script> alert('xss&fun'); </script>",

          'Backtick: &#96;':
          'Backtick: `',

          'Escaped string: &amp;lt;':
          'Escaped string: &lt;',
        },
      });
    });

    it('should_remove_control_characters_32_and_127', 0, () => {
      // Check basic functionality
      test({
        sanitizer: 'stripLow',
        expect: {
          'foo\x00': 'foo',
          '\x7Ffoo\x02': 'foo',
          '\x01\x09': '',
          'foo\x0A\x0D': 'foo',
        },
      });
      // Unicode safety
      test({
        sanitizer: 'stripLow',
        expect: {
          perché: 'perch\u00e9',
          '\u20ac': '\u20ac',
          '\u2206\x0A': '\u2206',
          '\ud83d\ude04': '\ud83d\ude04',
        },
      });
      // Preserve newlines
      test({
        sanitizer: 'stripLow',
        args: [true], // keep_new_lines
        expect: {
          'foo\x0A\x0D': 'foo\x0A\x0D',
          '\x03foo\x0A\x0D': 'foo\x0A\x0D',
        },
      });
    });

    it('should_sanitize_a_string_based_on_a_whitelist', 0, () => {
      test({
        sanitizer: 'whitelist',
        args: ['abc'],
        expect: {
          abcdef: 'abc',
          aaaaaaaaaabbbbbbbbbb: 'aaaaaaaaaabbbbbbbbbb',
          a1b2c3: 'abc',
          '   ': '',
        },
      });
    });

    it('should_sanitize_a_string_based_on_a_blacklist', 0, () => {
      test({
        sanitizer: 'blacklist',
        args: ['abc'],
        expect: {
          abcdef: 'def',
          aaaaaaaaaabbbbbbbbbb: '',
          a1b2c3: '123',
          '   ': '   ',
        },
      });
    });

    it('should_score_passwords', 0, () => {
      test({
        sanitizer: 'isStrongPassword',
        args: [{
          returnScore: true,
          pointsPerUnique: 1,
          pointsPerRepeat: 0.5,
          pointsForContainingLower: 10,
          pointsForContainingUpper: 10,
          pointsForContainingNumber: 10,
          pointsForContainingSymbol: 10,
        }],
        expect: {
          abc: 13,
          abcc: 13.5,
          aBc: 23,
          'Abc123!': 47,
          '!@#$%^&*()': 20,
        },
      });
    });

    it('should_score_passwords_with_default_options', 0, () => {
      test({
        sanitizer: 'isStrongPassword',
        expect: {
          abc: false,
          abcc: false,
          aBc: false,
          'Abc123!': false,
          '!@#$%^&*()': false,
          'abc123!@f#rA': true,
        },
      });
    });

    it('should_normalize_an_email_based_on_domain', 0, () => {
      test({
        sanitizer: 'normalizeEmail',
        expect: {
          'test@me.com': 'test@me.com',
          'some.name@gmail.com': 'somename@gmail.com',
          'some.name@googleMail.com': 'somename@gmail.com',
          'some.name+extension@gmail.com': 'somename@gmail.com',
          'some.Name+extension@GoogleMail.com': 'somename@gmail.com',
          'some.name.middleName+extension@gmail.com': 'somenamemiddlename@gmail.com',
          'some.name.middleName+extension@GoogleMail.com': 'somenamemiddlename@gmail.com',
          'some.name.midd.leNa.me.+extension@gmail.com': 'somenamemiddlename@gmail.com',
          'some.name.midd.leNa.me.+extension@GoogleMail.com': 'somenamemiddlename@gmail.com',
          'some.name+extension@unknown.com': 'some.name+extension@unknown.com',
          'hans@m端ller.com': 'hans@m端ller.com',
          'some.name.midd..leNa...me...+extension@GoogleMail.com': 'somenamemidd..lena...me...@gmail.com',
          'matthew..example@gmail.com': 'matthew..example@gmail.com',
          '"foo@bar"@baz.com': '"foo@bar"@baz.com',
          'test@ya.ru': 'test@yandex.ru',
          'test@yandex.kz': 'test@yandex.ru',
          'test@yandex.ru': 'test@yandex.ru',
          'test@yandex.ua': 'test@yandex.ru',
          'test@yandex.com': 'test@yandex.ru',
          'test@yandex.by': 'test@yandex.ru',
          '@gmail.com': false,
          '@icloud.com': false,
          '@outlook.com': false,
          '@yahoo.com': false,
        },
      });

      // Testing all_lowercase switch, should apply to domains not known to be case-insensitive
      test({
        sanitizer: 'normalizeEmail',
        args: [{
          all_lowercase: false
        }],
        expect: {
          'test@foo.com': 'test@foo.com',
          'hans@m端ller.com': 'hans@m端ller.com',
          'test@FOO.COM': 'test@foo.com', // Hostname is always lowercased
          'blAH@x.com': 'blAH@x.com',
          // In case of domains that are known to be case-insensitive, there's a separate switch
          'TEST@me.com': 'test@me.com',
          'TEST@ME.COM': 'test@me.com',
          'SOME.name@GMAIL.com': 'somename@gmail.com',
          'SOME.name.middleName+extension@GoogleMail.com': 'somenamemiddlename@gmail.com',
          'SOME.name.midd.leNa.me.+extension@gmail.com': 'somenamemiddlename@gmail.com',
          'SOME.name@gmail.com': 'somename@gmail.com',
          'SOME.name@yahoo.ca': 'some.name@yahoo.ca',
          'SOME.name@outlook.ie': 'some.name@outlook.ie',
          'SOME.name@me.com': 'some.name@me.com',
          'SOME.name@yandex.ru': 'some.name@yandex.ru',
        },
      });

      // Testing *_lowercase
      test({
        sanitizer: 'normalizeEmail',
        args: [{
          all_lowercase: false,
          gmail_lowercase: false,
          icloud_lowercase: false,
          outlookdotcom_lowercase: false,
          yahoo_lowercase: false,
          yandex_lowercase: false,
        }],
        expect: {
          'TEST@FOO.COM': 'TEST@foo.com', // all_lowercase
          'ME@gMAil.com': 'ME@gmail.com', // gmail_lowercase
          'ME@me.COM': 'ME@me.com', // icloud_lowercase
          'ME@icloud.COM': 'ME@icloud.com', // icloud_lowercase
          'ME@outlook.COM': 'ME@outlook.com', // outlookdotcom_lowercase
          'JOHN@live.CA': 'JOHN@live.ca', // outlookdotcom_lowercase
          'ME@ymail.COM': 'ME@ymail.com', // yahoo_lowercase
          'ME@yandex.RU': 'ME@yandex.ru', // yandex_lowercase
        },
      });

      // Testing all_lowercase
      // Should overwrite all the *_lowercase options
      test({
        sanitizer: 'normalizeEmail',
        args: [{
          all_lowercase: true,
          gmail_lowercase: false, // Overruled
          icloud_lowercase: false, // Overruled
          outlookdotcom_lowercase: false, // Overruled
          yahoo_lowercase: false, // Overruled
        }],
        expect: {
          'TEST@FOO.COM': 'test@foo.com', // all_lowercase
          'ME@gMAil.com': 'me@gmail.com', // gmail_lowercase
          'ME@me.COM': 'me@me.com', // icloud_lowercase
          'ME@icloud.COM': 'me@icloud.com', // icloud_lowercase
          'ME@outlook.COM': 'me@outlook.com', // outlookdotcom_lowercase
          'JOHN@live.CA': 'john@live.ca', // outlookdotcom_lowercase
          'ME@ymail.COM': 'me@ymail.com', // yahoo_lowercase
        },
      });

      // Testing *_remove_dots
      test({
        sanitizer: 'normalizeEmail',
        args: [{
          gmail_remove_dots: false,
        }],
        expect: {
          'SOME.name@GMAIL.com': 'some.name@gmail.com',
          'SOME.name+me@GMAIL.com': 'some.name@gmail.com',
          'my.self@foo.com': 'my.self@foo.com',
        },
      });

      test({
        sanitizer: 'normalizeEmail',
        args: [{
          gmail_remove_dots: true,
        }],
        expect: {
          'SOME.name@GMAIL.com': 'somename@gmail.com',
          'SOME.name+me@GMAIL.com': 'somename@gmail.com',
          'some.name..multiple@gmail.com': 'somename..multiple@gmail.com',
          'my.self@foo.com': 'my.self@foo.com',
        },
      });

      // Testing *_remove_subaddress
      test({
        sanitizer: 'normalizeEmail',
        args: [{
          gmail_remove_subaddress: false,
          icloud_remove_subaddress: false,
          outlookdotcom_remove_subaddress: false,
          yahoo_remove_subaddress: false, // Note Yahoo uses "-"
        }],
        expect: {
          'foo+bar@unknown.com': 'foo+bar@unknown.com',
          'foo+bar@gmail.com': 'foo+bar@gmail.com', // gmail_remove_subaddress
          'foo+bar@me.com': 'foo+bar@me.com', // icloud_remove_subaddress
          'foo+bar@icloud.com': 'foo+bar@icloud.com', // icloud_remove_subaddress
          'foo+bar@live.fr': 'foo+bar@live.fr', // outlookdotcom_remove_subaddress
          'foo+bar@hotmail.co.uk': 'foo+bar@hotmail.co.uk', // outlookdotcom_remove_subaddress
          'foo-bar@yahoo.com': 'foo-bar@yahoo.com', // yahoo_remove_subaddress
          'foo+bar@yahoo.com': 'foo+bar@yahoo.com', // yahoo_remove_subaddress
        },
      });

      test({
        sanitizer: 'normalizeEmail',
        args: [{
          gmail_remove_subaddress: true,
          icloud_remove_subaddress: true,
          outlookdotcom_remove_subaddress: true,
          yahoo_remove_subaddress: true, // Note Yahoo uses "-"
        }],
        expect: {
          'foo+bar@unknown.com': 'foo+bar@unknown.com',
          'foo+bar@gmail.com': 'foo@gmail.com', // gmail_remove_subaddress
          'foo+bar@me.com': 'foo@me.com', // icloud_remove_subaddress
          'foo+bar@icloud.com': 'foo@icloud.com', // icloud_remove_subaddress
          'foo+bar@live.fr': 'foo@live.fr', // outlookdotcom_remove_subaddress
          'foo+bar@hotmail.co.uk': 'foo@hotmail.co.uk', // outlookdotcom_remove_subaddress
          'foo-bar@yahoo.com': 'foo@yahoo.com', // yahoo_remove_subaddress
          'foo+bar@yahoo.com': 'foo+bar@yahoo.com', // yahoo_remove_subaddress
        },
      });

      // Testing gmail_convert_googlemaildotcom
      test({
        sanitizer: 'normalizeEmail',
        args: [{
          gmail_convert_googlemaildotcom: false,
        }],
        expect: {
          'SOME.name@GMAIL.com': 'somename@gmail.com',
          'SOME.name+me@GMAIL.com': 'somename@gmail.com',
          'SOME.name+me@googlemail.com': 'somename@googlemail.com',
          'SOME.name+me@googlemail.COM': 'somename@googlemail.com',
          'SOME.name+me@googlEmail.com': 'somename@googlemail.com',
          'my.self@foo.com': 'my.self@foo.com',
        },
      });

      test({
        sanitizer: 'normalizeEmail',
        args: [{
          gmail_convert_googlemaildotcom: true,
        }],
        expect: {
          'SOME.name@GMAIL.com': 'somename@gmail.com',
          'SOME.name+me@GMAIL.com': 'somename@gmail.com',
          'SOME.name+me@googlemail.com': 'somename@gmail.com',
          'SOME.name+me@googlemail.COM': 'somename@gmail.com',
          'SOME.name+me@googlEmail.com': 'somename@gmail.com',
          'my.self@foo.com': 'my.self@foo.com',
        },
      });
    });
  });
}
