# js-tokens

### Introduction

This project is an OpenHarmony development example based on the [js-tokens](https://github.com/lydell/js-tokens) library. js-tokens is a tiny, regex powered, lenient, almost spec-compliant JavaScript tokenizer.

### How to Install

1. Make sure Node.js has been installed. Then run the following command:
```
ohpm install js-tokens
```

2. Import js-tokens on the target page.

```
import jsTokens from 'js-tokens'
var tokens = jsTokens.default
var matchToToken = jsTokens.matchToToken
```

### How to Use

### `jsTokens` ###

A regex with the `g` flag that matches JavaScript tokens.

The regex _always_ matches, even invalid JavaScript and the empty string.

The next match is always directly after the previous.

### `var token = matchToToken(match)` ###

```js
import {matchToToken} from "js-tokens"
```

Takes a `match` returned by `jsTokens.exec(string)`, and returns a `{type:
String, value: String}` object. The following types are available:

- string
- comment
- regex
- number
- name
- punctuator
- whitespace
- invalid

Multi-line comments and strings also have a `closed` property indicating if the
token was closed or not (see below).

Comments and strings both come in several flavors. To distinguish them, check if
the token starts with `//`, `/*`, `'`, `"` or ` ` `.

Names are ECMAScript IdentifierNames, that is, including both identifiers and
keywords. You may use [is-keyword-js] to tell them apart.

Whitespace includes both line terminators and other whitespace.

### Description
1. Tokenizing JavaScript using regexes - essentially, _one single regex_ - won't be
perfect. However, that's not the main goal. 

You may compare jsTokens with [esprima] by using **esprima-compare.js**.
See **npm run esprima-compare**.

2. Template strings are matched as single tokens, from the starting \` to the
ending \`, including interpolations (whose tokens are not matched
individually).

Matching template string interpolations requires recursive balancing of `{` and
`}`—something that JavaScript regexes cannot handle. Only one level of nesting is
supported.

3. Division and regex literals collision

Consider this example:

```js
var g = 9.82
var number = bar / 2/g

var regex = / 2/g
```

### Available APIs

1. jsTokens.default; // Matching expressions

2. jsTokens.matchToToken // Tokenizer function

For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/js-tokens/TEST.md).

### Constraints
This project has been verified in the following versions:

- DevEco Studio: 4.0 Beta2 (4.0.3.512), SDK: API 10 (4.0.10.9)

- DevEco Studio: 3.1.1 Release (3.1.0.501), SDK: API 9 Release (3.2.12.5)

### Directory Structure

```
|-ets
|   |-Application
|           |-AbilityStage.ts
|   |-MainAbility
|           |-MainAbility.ts
|   |-pages
|           |-index.ets            # Home page demo
```

### Version

Current version:

```
1.0.0
```

For details about the version history, see [CHANGELOG.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/js-tokens/CHANGELOG.md).

### How to Contribute

If you find any problem during the use, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

### License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/js-tokens/LICENSE).
