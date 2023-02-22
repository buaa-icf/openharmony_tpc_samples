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

    public namedParametersTest(param: string): object {
        try {
            const regexp = pathToRegexp(param);
            const result = regexp.exec('/test/route')
            return result;
        } catch (err) {
            return err
        }
    }

    public customMatchingParametersTest(param?: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const regexpNumbers = pathToRegexp('/icon-:foo(\\d+).png');
            const firstResult = regexpNumbers.exec('/icon-123.png');
            result.push(firstResult);
            const secondResult = regexpNumbers.exec('/icon-abc.png')
            result.push(secondResult);
            const regexpWord = pathToRegexp('/(user|u)');
            const thirdResult = regexpWord.exec('/u');
            result.push(thirdResult);
            const fourResult = regexpWord.exec('/users');
            result.push(fourResult);

            return result;
        } catch (err) {
            result.push(err);
            return result
        }
    }


    public customPrefixSuffixTest(param?: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const regexp = pathToRegexp("/:attr1?{-:attr2}?{-:attr3}?");
            const single = regexp.exec('/test');
            result.push(single);
            const double = regexp.exec('/test-test')
            result.push(double);
            return result;
        } catch (err) {
            result.push(err);
            return result
        }
    }

    public unNamedParametersTest(param?: string, keys?: Key[]): object {
        try {
            const regexp = pathToRegexp("/:foo/(.*)");
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
            result.push(single);
            const double = regexp.exec('/test/route')
            result.push(double);
            return result;
        } catch (err) {
            result.push(err);
            return result
        }
    }

    public optionalTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const regexp = pathToRegexp('/:foo/:bar?');
            const single = regexp.exec('/test');
            result.push(single);
            const double = regexp.exec('/test/route')
            result.push(double);
            const regexpNew = pathToRegexp('/search/:tableName\\?useIndex=true&term=amazing');
            const positive = regexpNew.exec('/search/people?useIndex=true&term=amazing');
            result.push(positive);
            const reverse = regexpNew.exec('/search/people?term=amazing&useIndex=true');
            result.push(reverse);
            return result;
        } catch (err) {
            result.push(err);
            return result
        }
    }

    public zeroTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const regexp = pathToRegexp('/:foo*');
            const single = regexp.exec('/');
            result.push(single);
            const double = regexp.exec('/bar/baz')
            result.push(double);
            return result;
        } catch (err) {
            result.push(err);
            return result
        }
    }

    public oneTest(param: string, keys?: Key[]): Array<object> {
        const result = []
        try {
            const regexp = pathToRegexp('/:foo+');
            const single = regexp.exec('/');
            result.push(single);
            const double = regexp.exec('/bar/baz')
            result.push(double);
            return result;
        } catch (err) {
            result.push(err);
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
            result.push(number);
            const invalid = fn('/invalid')
            result.push(invalid);
            const decode = fn('/user/caf%c3%A9')
            result.push(decode);

            const urlMatch = match('/users/:id/:tab(home|photos|bio)', {
                decode: decodeURIComponent
            });
            const photos = urlMatch('/users/1234/photos');
            result.push(photos);
            const bio = urlMatch('/users/1234/bio');
            result.push(bio);
            const otherstuff = urlMatch('/users/1234/otherstuff');
            result.push(otherstuff);
            return result;
        } catch (err) {
            result.push(err);
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
            result.push(number);
            return result;
        } catch (err) {
            result.push(err);
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
            result.push(tokens[0]);
            result.push(tokens[1]);
            result.push(tokens[2]);
            return result;
        } catch (err) {
            result.push(err);
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
            result.push(number);
            let words = toPath({
                id: 'cafe'
            })
            result.push(words);
            let symbol = toPath({
                id: '/'
            })
            result.push(symbol);
            let doubleSymbol = toPath({
                id: ':/'
            })
            result.push(doubleSymbol);

            const toPathRaw = compile('/user/:id', {
                validate: false
            });
            let decode = toPathRaw({
                id: '%3A%2F'
            })
            result.push(decode);
            let double = toPathRaw({
                id: ':/'
            })
            result.push(double);

            const toPathRepeated = compile('/:segment+');
            let segment = toPathRepeated({
                segment: 'foo'
            })
            result.push(segment);
            let segments = toPathRepeated({
                segment: ['a', 'b', 'c', 'd']
            })
            result.push(segments);

            const toPathRegexp = compile('/user/:id(\\d+)');
            let numberRegexp = toPathRegexp({
                id: 123
            })
            result.push(numberRegexp);
            let wordRegexp = toPathRegexp({
                id: '123'
            })
            result.push(wordRegexp);
            let lettersRegexp = toPathRegexp({
                id: 'abc'
            })
            result.push(lettersRegexp);

            const toPathValidateRegexp = compile('/user/:id(\\d+)', {
                validate: false
            });
            let lettersValidateRegexp = toPathValidateRegexp({
                id: 'abc'
            })
            result.push(lettersValidateRegexp);
            return result;
        } catch (err) {
            result.push(err);
            return result
        }
    }
}