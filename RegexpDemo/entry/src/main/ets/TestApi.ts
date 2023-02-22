import { compile, Key, match, parse, pathToRegexp } from 'path-to-regexp';

export default class TestApi {
    constructor() {
    }

    public pathToRegexpTest(param: string, keys?: Key[]): object {
        try {
            const regexp = pathToRegexp(param, keys);
            return regexp;
        } catch (err) {
            return err
        }
    }

    public namedParametersTest(param: string, keys?: Key[]): object {
        try {
            const regexp = pathToRegexp(param, keys);
            const result = regexp.exec('/test/route')
            return result;
        } catch (err) {
            return err
        }
    }

    public customMatchingParametersTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const regexpNumbers = pathToRegexp('/icon-:foo(\\d+).png');
            const firstResult = regexpNumbers.exec('/icon-123.png');
            result.fill(firstResult);
            const secondResult = regexpNumbers.exec('/icon-abc.png')
            result.fill(secondResult);
            const regexpWord = pathToRegexp('/(user|u)');
            const thirdResult = regexpWord.exec('/u');
            result.fill(thirdResult);
            const fourResult = regexpWord.exec('/users');
            result.fill(fourResult);

            return result;
        } catch (err) {
            result.fill(err);
            return result
        }
    }


    public customPrefixSuffixTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const regexp = pathToRegexp('/:attr1?{-attr2}?{-:attr3}?');
            const single = regexp.exec('/test');
            result.fill(single);
            const double = regexp.exec('/test-test')
            result.fill(double);
            return result;
        } catch (err) {
            result.fill(err);
            return result
        }
    }

    public unNamedParametersTest(param: string, keys?: Key[]): object {
        try {
            const regexp = pathToRegexp('/foo/(.*)');
            const unNamed = regexp.exec('/test/route');
            return unNamed;
        } catch (err) {
            return err
        }
    }

    public modifiersPageTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const regexp = pathToRegexp('/:foo/:bar?');
            const single = regexp.exec('/test');
            result.fill(single);
            const double = regexp.exec('/test/route')
            result.fill(double);
            return result;
        } catch (err) {
            result.fill(err);
            return result
        }
    }

    public optionalTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const regexp = pathToRegexp('/:foo/:bar?');
            const single = regexp.exec('/test');
            result.fill(single);
            const double = regexp.exec('/test/route')
            result.fill(double);
            const regexpNew = pathToRegexp('/search/:tableName\\?useIndex=true&term=amazing');
            const positive = regexpNew.exec('/search/people?useIndex=true&term=amazing');
            result.fill(positive);
            const reverse = regexpNew.exec('/search/people?term=amazing&useIndex=true');
            result.fill(reverse);
            return result;
        } catch (err) {
            result.fill(err);
            return result
        }
    }

    public zeroTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const regexp = pathToRegexp('/:foo*');
            const single = regexp.exec('/');
            result.fill(single);
            const double = regexp.exec('/bar/baz')
            result.fill(double);
            return result;
        } catch (err) {
            result.fill(err);
            return result
        }
    }

    public oneTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const regexp = pathToRegexp('/:foo+');
            const single = regexp.exec('/');
            result.fill(single);
            const double = regexp.exec('/bar/baz')
            result.fill(double);
            return result;
        } catch (err) {
            result.fill(err);
            return result
        }
    }


    public matchTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const fn = match('/user/:id', {
                decode: decodeURIComponent
            });
            const number = fn('/user/123');
            result.fill(number);
            const invalid = fn('/invalid')
            result.fill(invalid);
            const decode = fn('/user/caf%c3%A9')
            result.fill(decode);

            const urlMatch = match('/users/:id/:tab(home|photos|bio)', {
                decode: decodeURIComponent
            });
            const photos = urlMatch('/users/1234/photos');
            result.fill(photos);
            const bio = urlMatch('/users/1234/bio');
            result.fill(bio);
            const otherstuff = urlMatch('/users/1234/otherstuff');
            result.fill(otherstuff);
            return result;
        } catch (err) {
            result.fill(err);
            return result
        }
    }

    public processPathnameTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const fn = match('/cafe', {
                decode: encodeURI
            });
            const number = fn('/caf%c3%A9');
            result.fill(number);
            return result;
        } catch (err) {
            result.fill(err);
            return result
        }
    }

    private normalizePathname(pathname: string): string {
        try {

            return (decodeURI(pathname).replace(/\/+/g, '/')).normalize();
        } catch (err) {
            return JSON.stringify(err)
        }
    }


    public alternativeTest(param: string, keys?: Key[]): Array<object> {
        const result = new Array()
        try {
            const re = pathToRegexp('/caf\u00E9');
            const input = encodeURI('/cafe\u0301');

            const testPath = re.test(input);
            result.push(testPath);
            const testDiy = re.test(this.normalizePathname(input));
            result.push(testDiy);
            return result;
        } catch (err) {
            result.push(err);
            return result
        }
    }

    public parseTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const tokens = parse('/route/:foo/(.*)');
            result.fill(tokens[0]);
            result.fill(tokens[1]);
            result.fill(tokens[2]);
            return result;
        } catch (err) {
            result.fill(err);
            return result
        }
    }

    public compileTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const toPath = compile('/user/:id', {
                encode: encodeURIComponent
            });
            let number = toPath({
                id: 123
            })
            result.fill(number);
            let words = toPath({
                id: 'cafe'
            })
            result.fill(words);
            let symbol = toPath({
                id: '/'
            })
            result.fill(symbol);
            let doubleSymbol = toPath({
                id: ':/'
            })
            result.fill(doubleSymbol);

            const toPathRaw = compile('/user/:id', {
                validate: false
            });
            let decode = toPathRaw({
                id: '%3A%2F'
            })
            result.fill(decode);
            let double = toPathRaw({
                id: ':/'
            })
            result.fill(double);

            const toPathRepeated = compile('/:segment+');
            let segment = toPathRepeated({
                segment: 'foo'
            })
            result.fill(segment);
            let segments = toPathRepeated({
                segment: ['a', 'b', 'c', 'd']
            })
            result.fill(segments);

            const toPathRegexp = compile('/user/:id(\\d+)');
            let numberRegexp = toPathRegexp({
                id: 123
            })
            result.fill(numberRegexp);
            let wordRegexp = toPathRegexp({
                id: '123'
            })
            result.fill(wordRegexp);
            let lettersRegexp = toPathRegexp({
                id: 'abc'
            })
            result.fill(lettersRegexp);

            const toPathValidateRegexp = compile('/user/:id(\\d+)', {
                validate: false
            });
            let lettersValidateRegexp = toPathValidateRegexp({
                id: 'abc'
            })
            result.fill(lettersValidateRegexp);
            return result;
        } catch (err) {
            result.fill(err);
            return result
        }
    }
}