import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { compile, Key, match, parse, pathToRegexp } from 'path-to-regexp';

export default function ApiTest() {
  describe('PathToRegexpTest', function () {
    beforeAll(function () {
    })
    beforeEach(function () {
    })
    afterEach(function () {
    })
    afterAll(function () {
    })

    it('KeysTest', 0, function () {
      const keys = [];
      const regexp = pathToRegexp("/foo/:bar", keys);
      let keyStr = JSON.stringify(keys);
      let objStr = JSON.stringify([{
        name: 'bar',
        prefix: '/',
        suffix: '',
        pattern: '[^\\/#\\?]+?',
        modifier: ''
      }]);
      expect(keyStr).assertEqual(objStr)
    })

    it('Named Parameters Test', 0, function () {
      const keys = [];
      const regexp = pathToRegexp("/:foo/:bar", keys);
      let testStr = JSON.stringify(regexp.exec("/test/route"));
      let objStr = JSON.stringify(['/test/route', 'test', 'route']);
      expect(testStr).assertEqual(objStr)
    })

    it('Custom Matching Parameters Test', 0, function () {
      const regexpNumbers = pathToRegexp("/icon-:foo(\\d+).png");
      let testStr1 = JSON.stringify(regexpNumbers.exec("/icon-123.png"));
      let objStr1 = JSON.stringify(['/icon-123.png', '123']);
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = regexpNumbers.exec("/icon-abc.png");
      let objStr2 = null;
      expect(testStr2).assertEqual(objStr2)


      const regexpWord = pathToRegexp("/(user|u)");
      let testStr3 = JSON.stringify(regexpWord.exec("/u"));
      let objStr3 = JSON.stringify(['/u', 'u']);
      expect(testStr3).assertEqual(objStr3)


      let testStr4 = regexpWord.exec("/users");
      let objStr4 = null;
      expect(testStr4).assertEqual(objStr4)
    })

    it('Custom Prefix and Suffix Test', 0, function () {
      const regexp = pathToRegexp("/:attr1?{-:attr2}?{-:attr3}?");
      let testStr1 = JSON.stringify(regexp.exec("/test"));
      let objStr1 = JSON.stringify(['/test', 'test', null, null]);
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = JSON.stringify(regexp.exec("/test-test"));
      let objStr2 = JSON.stringify(['/test', 'test', 'test', null]);
      expect(testStr2).assertEqual(objStr2)
    })

    it('Unnamed Parameters Test', 0, function () {
      const regexp = pathToRegexp("/:foo/(.*)");
      let testStr1 = JSON.stringify(regexp.exec("/test/route"));
      let objStr1 = JSON.stringify(['/test/route', 'test', 'route']);
      expect(testStr1).assertEqual(objStr1)
    })

    it('Modifiers  Test', 0, function () {
      const regexp = pathToRegexp("/:foo/:bar?");
      let testStr1 = JSON.stringify(regexp.exec("/test"));
      let objStr1 = JSON.stringify(['/test', 'test', null]);
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = JSON.stringify(regexp.exec("/test/route"));
      let objStr2 = JSON.stringify(['/test/route', 'test', 'route']);
      expect(testStr2).assertEqual(objStr2)
    })

    it('optional Test', 0, function () {
      const regexp = pathToRegexp("/search/:tableName\\?useIndex=true&term=amazing");
      let testStr1 = JSON.stringify(regexp.exec("/search/people?useIndex=true&term=amazing"));
      let objStr1 = JSON.stringify(['/search/people?useIndex=true&term=amazing', 'people']);
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = regexp.exec("/search/people?term=amazing&useIndex=true");
      let objStr2 = null;
      expect(testStr2).assertEqual(objStr2)
    })

    it('Zero or more Test', 0, function () {
      const regexp = pathToRegexp("/:foo*");
      let testStr1 = JSON.stringify(regexp.exec("/"));
      let objStr1 = JSON.stringify(['/', undefined]);
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = JSON.stringify(regexp.exec("/bar/baz"));
      let objStr2 = JSON.stringify(['/bar/baz', 'bar/baz']);
      ;
      expect(testStr2).assertEqual(objStr2)
    })

    it('One or more Test', 0, function () {
      const regexp = pathToRegexp("/:foo+");
      let testStr1 = regexp.exec("/");
      let objStr1 = null;
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = JSON.stringify(regexp.exec("/bar/baz"));
      let objStr2 = JSON.stringify(['/bar/baz', 'bar/baz']);
      ;
      expect(testStr2).assertEqual(objStr2)
    })

    it('Match Test', 0, function () {
      const fn = match("/user/:id", {
        decode: decodeURIComponent
      });
      let testStr1 = JSON.stringify(fn("/user/123"));
      let objStr1 = JSON.stringify({
        path: '/user/123', index: 0, params: {
          id: '123'
        }
      });
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = fn("/invalid");
      let objStr2 = false;
      ;
      expect(testStr2).assertEqual(objStr2);
    })

    it('Match Test', 0, function () {
      const fn = match("/user/:id", {
        decode: decodeURIComponent
      });
      let testStr1 = JSON.stringify(fn("/user/123"));
      let objStr1 = JSON.stringify({
        path: '/user/123', index: 0, params: {
          id: '123'
        }
      });
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = fn("/invalid");
      let objStr2 = false;
      ;
      expect(testStr2).assertEqual(objStr2);
    })

    it('urlMatch  Test', 0, function () {
      const urlMatch = match("/users/:id/:tab(home|photos|bio)", {
        decode: decodeURIComponent,
      });
      let testStr1 = JSON.stringify(urlMatch("/users/1234/photos"));
      let objStr1 = JSON.stringify({
        path: '/users/1234/photos', index: 0, params: {
          id: '1234', tab: 'photos'
        }
      });
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = JSON.stringify(urlMatch("/users/1234/bio"));
      let objStr2 = JSON.stringify({
        path: '/users/1234/bio', index: 0, params: {
          id: '1234', tab: 'bio'
        }
      });
      expect(testStr2).assertEqual(objStr2);

      let testStr3 = urlMatch("/users/1234/otherstuff");
      let objStr3 = false;
      expect(testStr3).assertEqual(objStr3);
    })


    it('Process Pathname  Test', 0, function () {
      const fn = match("/café", {
        encode: encodeURI
      });
      let testStr1 = JSON.stringify(fn("/caf%C3%A9"));
      let objStr1 = JSON.stringify({
        path: '/caf%C3%A9', index: 0, params: {}
      });
      expect(testStr1).assertEqual(objStr1)
    })

    function normalizePathname(pathname: string) {
      return (
      decodeURI(pathname)
        .replace(/\/+/g, "/")
        .normalize()
      );
    }

    it('Alternative Using Normalize Test', 0, function () {
      const re = pathToRegexp("/caf\u00E9");
      const input = encodeURI("/cafe\u0301");

      let testStr1 = re.test(input);
      let objStr1 = false;
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = re.test(normalizePathname(input));
      let objStr2 = true;
      expect(testStr2).assertEqual(objStr2)
    })

    it('Parse  Test', 0, function () {
      const tokens = parse("/route/:foo/(.*)");

      let testStr1 = tokens[0];
      let objStr1 = "/route";
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = JSON.stringify(tokens[1]);
      let objStr2 = JSON.stringify({
        name: 'foo',
        prefix: '/',
        suffix: '',
        pattern: '[^\\/#\\?]+?',
        modifier: ''
      }
      );
      expect(testStr2).assertEqual(objStr2);

      let testStr3 = JSON.stringify(tokens[2]);
      let objStr3 = JSON.stringify({
        name: 0,
        prefix: '/',
        suffix: '',
        pattern: '.*',
        modifier: ''
      });
      expect(testStr3).assertEqual(objStr3);
    })

    it('Compile Test', 0, function () {
      const toPath = compile("/user/:id", {
        encode: encodeURIComponent
      });

      let testStr1 = toPath({
        id: 123
      });
      let objStr1 = "/user/123";
      expect(testStr1).assertEqual(objStr1)

      let testStr2 = toPath({
        id: "café"
      });
      let objStr2 = "/user/caf%C3%A9";
      expect(testStr2).assertEqual(objStr2);

      let testStr3 = toPath({
        id: "/"
      });
      let objStr3 = "/user/%2F";
      expect(testStr3).assertEqual(objStr3);

      let testStr4 = toPath({
        id: ":/"
      });
      let objStr4 = "/user/%3A%2F";
      expect(testStr4).assertEqual(objStr4);



      const toPathRaw = compile("/user/:id");

      let testStr5 = toPathRaw({
        id: "%3A%2F"
      });
      let objStr5 = "/user/%3A%2F";
      expect(testStr5).assertEqual(objStr5);

      const toPathRaw1 = compile("/user/:id", {
        validate: false
      });
      let testStr6 = toPathRaw1({
        id: ":/"
      });
      let objStr6 = "/user/:/";
      expect(testStr6).assertEqual(objStr6);

      const toPathRepeated = compile("/:segment+");

      let testStr7 = toPathRepeated({
        segment: "foo"
      }); //=> "/foo"
      let objStr7 = "/foo";
      expect(testStr7).assertEqual(objStr7);

      let testStr8 = toPathRepeated({
        segment: ["a", "b", "c"]
      }); //=> "/a/b/c"
      let objStr8 = "/a/b/c";
      expect(testStr8).assertEqual(objStr8);

      const toPathRegexp = compile("/user/:id(\\d+)");

      let testStr9 = toPathRegexp({
        id: 123
      });
      let objStr9 = "/user/123";
      expect(testStr9).assertEqual(objStr9);

      let testStr10 = toPathRegexp({
        id: "123"
      });
      let objStr10 = "/user/123";
      expect(testStr10).assertEqual(objStr10);

      try {
        toPathRegexp({
          id: "abc"
        });
      } catch (err) {
        let isTypeErr = false;
        if (err instanceof TypeError) {
          isTypeErr = true;
        }
        expect(isTypeErr).assertTrue();
      }

      const toPathRegexp1 = compile("/user/:id(\\d+)",{ validate: false });

      let testStr11 = toPathRegexp1({
        id: "abc"
      });
      let objStr11 = "/user/abc";
      expect(testStr11).assertEqual(objStr11);

    })


  })
}