# path-to-regexp

## Overview

path-to-regexp is a library that converts path strings (such as **/user/:name**) into regular expressions.

## How to Install

```
ohpm install path-to-regexp 
```

For details, see [Installing an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## Usage

After installing path-to-regexp library, import the APIs provided by path-to-regexp before use.

```typescript
import { compile, Key, match, parse, pathToRegexp } from 'path-to-regexp';
```

### pathToRegexp

  ```typescript
const keys = [];
const regexp = pathToRegexp("/foo/:bar", keys);
// regexp = /^\/foo(?:\/([^\/#\?]+?))[\/#\?]?$/i
// keys = [{ name: 'bar', prefix: '/', suffix: '', pattern: '[^\\/#\\?]+?', modifier: '' }]
  ```

This function converts the provided path into a regular expression and returns a **RegExp** object that contains information related to the regular expression for validation or path concatenation and conversion.

### Parameters

#### Named Parameters

```typescript
const regexp = pathToRegexp("/:foo/:bar");
// keys = [{ name: 'foo', prefix: '/', ... }, { name: 'bar', prefix: '/', ... }]

regexp.exec("/test/route");
//=> [ '/test/route', 'test', 'route', index: 0, input: '/test/route', groups: undefined ]
```

You can define a parameter by adding a colon (:) before the parameter name, for example, **:foo,:bar**. You can use **exec** to parse the named parameters that meet the conditions in the path.

#### Custom Matching Parameters

  ```typescript
const regexpNumbers = pathToRegexp("/icon-:foo(\\d+).png");
// keys = [{ name: 'foo', ... }]

regexpNumbers.exec("/icon-123.png");
//=> ['/icon-123.png', '123']

regexpNumbers.exec("/icon-abc.png");
//=> null

const regexpWord = pathToRegexp("/(user|u)");
// keys = [{ name: 0, ... }]

regexpWord.exec("/u");
//=> ['/u', 'u']

regexpWord.exec("/users");
//=> null
  ```

The parameter contains a custom regexp, for example, **\\d+**, to match the number or name in the path.

#### Custom Prefix and Suffix

  ```typescript
 const regexp = pathToRegexp("/:attr1?{-:attr2}?{-:attr3}?");

regexp.exec("/test");
// => ['/test', 'test', null, null]

regexp.exec("/test-test");
// => ['/test-test', 'test', 'test', null]
  ```

Parameters enclosed in {} are used to add custom prefixes and suffixes to path parameters.

#### Unnamed Parameters

  ```typescript
const regexp = pathToRegexp("/:foo/(.*)");
// keys = [{ name: 'foo', ... }, { name: 0, ... }]

regexp.exec("/test/route");
//=> [ '/test/route', 'test', 'route']
  ```

The principle is the same as that for named parameters. An unnamed parameter is composed only of regexp, for example, (.*), which is indexed by numbers in the generated Regexp, for example, ({ name: 0, ... }), to match any parameters.

#### Modifiers

##### Optional

  ```typescript
const regexp = pathToRegexp("/:foo/:bar?");
// keys = [{ name: 'foo', ... }, { name: 'bar', prefix: '/', modifier: '?' }]

regexp.exec("/test");
//=> [ '/test', 'test', null ]

regexp.exec("/test/route");
//=> [ '/test/route', 'test', 'route' ]
  ```

A parameter becomes optional if it is followed by a question mark (?). It is up to you whether to pass the parameter, and an error will not be thrown for this parameter during verification.

If the character ? in a parameter means query rather than an optional parameter, the ? needs to be escaped as follows:

```typescript
const regexp = pathToRegexp("/search/:tableName\\?useIndex=true&term=amazing");

regexp.exec("/search/people?useIndex=true&term=amazing");
//=> [ '/search/people?useIndex=true&term=amazing', 'people', index: 0, input: '/search/people?useIndex=true&term=amazing', groups: undefined ]

// This library does not handle query strings in different orders
regexp.exec("/search/people?term=amazing&useIndex=true");
//=> null
```

##### Zero or More

```typescript
const regexp = pathToRegexp("/:foo*");
// keys = [{ name: 'foo', prefix: '/', modifier: '*' }]

regexp.exec("/");
//=> [ '/', null ]

regexp.exec("/bar/baz");
//=> [ '/bar/baz', 'bar/baz' ]
```

A parameter ending with an asterisk (*) indicates that zero or multiple parameters are matched. The return value is a result array. If no value is matched, the value in the result array contains null.

##### One or More

```typescript
const regexp = pathToRegexp("/:foo+");
// keys = [{ name: 'foo', prefix: '/', modifier: '+' }]

regexp.exec("/");
//=> null

regexp.exec("/bar/baz");
//=> [ '/bar/baz','bar/baz']
```

A parameter ending with a plus sign (+) indicates that one or more parameters are matched. If no parameter is matched, null instead of the matching result array is returned. If any parameter is matched, the result array is returned.

### Match

  ```typescript
// Make sure you consistently `decode` segments.
const fn = match("/user/:id", { decode: decodeURIComponent });

fn("/user/123"); //=> { path: '/user/123', index: 0, params: { id: '123' } }
fn("/invalid"); //=> false
fn("/user/caf%C3%A9"); //=> { path: '/user/caf%C3%A9', index: 0, params: { id: 'café' } }
  ```

This function converts a path to parameters after a series of transformations according to the specified rules.

The function can also be used to customize named parameters, for example, **tab(home|photos|bio)**.

```typescript
const urlMatch = match("/users/:id/:tab(home|photos|bio)", {
  decode: decodeURIComponent,
});

urlMatch("/users/1234/photos");
//=> { path: '/users/1234/photos', index: 0, params: { id: '1234', tab: 'photos' } }

urlMatch("/users/1234/bio");
//=> { path: '/users/1234/bio', index: 0, params: { id: '1234', tab: 'bio' } }

urlMatch("/users/1234/otherstuff");
//=> false
```

#### Process Pathname

```typescript
const fn = match("/café", { encode: encodeURI });

fn("/caf%C3%A9"); //=> { path: '/caf%C3%A9', index: 0, params: {} }
```

Sometimes, the matching result is specially encoded. To ensure that the matching result is correct, you can use the optional parameter **{encode: encodeURI}** to set the encoding for the conversion function.

#### Alternative Using Normalize

```typescript
/**
 * Normalize a pathname for matching, replaces multiple slashes with a single
 * slash and normalizes unicode characters to "NFC". When using this method,
 * `decode` should be an identity function so you don't decode strings twice.
 */
function normalizePathname(pathname: string) {
  return (
    decodeURI(pathname)
      // Replaces repeated slashes in the URL.
      .replace(/\/+/g, "/")
      // Reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/normalize
      // Note: Missing native IE support, may want to skip this step.
      .normalize()
  );
}

// Two possible ways of writing `/café`:
const re = pathToRegexp("/caf\u00E9");
const input = encodeURI("/cafe\u0301");

re.test(input); //=> false
re.test(normalizePathname(input)); //=> true
```

If the current optional encoding mode does not meet the requirements, you can use the **normalize** method to preprocess the input path.

### Parse

This function is used to parse the input path and returns the parsing result and key list of each parameter.

```typescript
const tokens = parse("/route/:foo/(.*)");

console.log(tokens[0]);
//=> "/route"

console.log(tokens[1]);
//=> { name: 'foo', prefix: '/', suffix: '', pattern: '[^\\/#\\?]+?', modifier: '' }

console.log(tokens[2]);
//=> { name: 0, prefix: '/', suffix: '', pattern: '.*', modifier: '' }
```

### Compile

This function converts path rules into a function that can concatenate input parameters into a valid path.

```typescript
 // Make sure you encode your path segments consistently.
const toPath = compile("/user/:id", { encode: encodeURIComponent });

toPath({ id: 123 }); //=> "/user/123"
toPath({ id: "café" }); //=> "/user/caf%C3%A9"
toPath({ id: "/" }); //=> "/user/%2F"

toPath({ id: ":/" }); //=> "/user/%3A%2F"

// Without `encode`, you need to make sure inputs are encoded correctly.
const toPathRaw = compile("/user/:id");
toPathRaw({ id: "%3A%2F" }); //=> "/user/%3A%2F"
const toPathRawVali = compile("/user/:id", { validate: false });
toPathRawVali({ id: ":/" }); //=> "/user/:/"

const toPathRepeated = compile("/:segment+");
toPathRepeated({ segment: "foo" }); //=> "/foo"
toPathRepeated({ segment: ["a", "b", "c"] }); //=> "/a/b/c"

const toPathRegexp = compile("/user/:id(\\d+)");

toPathRegexp({ id: 123 }); //=> "/user/123"
toPathRegexp({ id: "123" }); //=> "/user/123"
toPathRegexp({ id: "abc" }); //=> Throws `TypeError`.
const toPathRegexpVali = compile("/user/:id(\\d+)", { validate: false });
toPathRegexpVali({ id: "abc" }); //=> "/user/abc"
```

## Available APIs

### path-to-regexp

| Name          | Parameter                                                                         | Return Value          | Description                                                |
| ---------------- |-----------------------------------------------------------------------------| ---------------- | ---------------------------------------------------- |
| pathToRegexp     | path: Path,<br>keys?: Key[],<br>options?: TokensToRegexpOptions & ParseOptions | RegExp           | Standardizes the given path and returns the processed regular expression. |
| match            | str: Path,<br>options?: ParseOptions & TokensToRegexpOptions & RegexpToFunctionOptions | MatchFunction<P> | Creates a path matching function according to the path-to-regexp rules.            |
| parse            | str: string,<br>options?: ParseOptions                                     | Token[]          | Parses the provided string and returns the original tokens.                            |
| compile          | str: string,<br>options?: ParseOptions & TokensToFunctionOptions           | PathFunction<P>  | Compiles a string into a path template function.                          |
| tokensToFunction | tokens: Token[],<br>options: TokensToFunctionOptions = {}                  | PathFunction<P>  | Converts a token into a path function.                             |
| regexpToFunction | re: RegExp,<br>keys: Key[],<br>options: RegexpToFunctionOptions = {}      | MatchFunction<P> | Creates a path matching function from the path-to-regexp output.        |
| tokensToRegexp   | tokens: Token[],<br>keys?: Key[],<br>options: TokensToRegexpOptions = {}  | RegExp           | Converts a token to RegExp.                               |

### RegExp

| API | Parameter          | Return Value                 | Description                                                  |
| ------ | -------------- | ----------------------- | ------------------------------------------------------ |
| exec   | string: string | RegExpExecArray \| null | Verifies a string using the regular expression pattern and returns an array containing the verification result. |
| test   | string: string | boolean                 | Checks whether the input string complies with the specified rules and returns a Boolean value indicating the result.            |

For more details, see [Official Documentation](https://github.com/pillarjs/path-to-regexp/blob/master/Readme.md) and [Unit Test Cases](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/PathToRegexpDemo/TEST.md).

## Constraints

path-to-regexp has been verified in the following versions:

DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)

DevEco Studio: 4.0 Beta2 (4.0.3.512), SDK: API10 (4.0.10.9)

DevEco Studio: 3.1 Beta2 (3.1.0.400), SDK: API9 Release (3.2.11.9)

## Directory Structure

```javascript
|---- PathToRegexpDemo  
|     |---- entry  # Sample code
			|---- pages  # Application pages, which may vary depending on the API
			|---- CommonResultBean # Parameter wrapper class, which is used to wrap the parameters that need to be redirected to and displayed on the UI
            |---- JumpPathConfig # Page redirection configuration, which is used to display list data on the homepage and obtain redirection parameters
            |---- TestApi  # Classes for calling PathToRegexp APIs
|     |---- README_EN.MD  # Readme file                  
```

## How to Contribute

If you find any problem when using path-to-regexp, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under the terms of the [MIT License ](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/PathToRegexpDemo/LICENSE).
