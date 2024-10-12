# js-tokens

### 介绍

本库是OpenHarmony系统下基于[js-tokens](https://github.com/lydell/js-tokens)库使用的开发示例，js-tokens 是一个微型JavaScript的分词器。小巧的、正则表达式驱动的、宽松的、几乎符合规范的 JavaScript 标记器

### 下载安装

1.如果已安装好nodejs后，输入以下命令
```
ohpm install js-tokens
```

2.在需要使用的页面导入js-tokens

```
import jsTokens from 'js-tokens'
var tokens = jsTokens.default
var matchToToken = jsTokens.matchToToken
```

### 使用说明

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
the token starts with `//`, `/*`, `'`, `"` or `` ` ``.

Names are ECMAScript IdentifierNames, that is, including both identifiers and
keywords. You may use [is-keyword-js] to tell them apart.

Whitespace includes both line terminators and other whitespace.

### 限制描述
1、Tokenizing JavaScript using regexes—in fact, _one single regex_—won’t be
perfect. But that’s not the point either.

You may compare jsTokens with [esprima] by using `esprima-compare.js`.
See `npm run esprima-compare`!

2、Template strings are matched as single tokens, from the starting `` ` `` to the
ending `` ` ``, including interpolations (whose tokens are not matched
individually).

Matching template string interpolations requires recursive balancing of `{` and
`}`—something that JavaScript regexes cannot do. Only one level of nesting is
supported.

3、Division and regex literals collision

Consider this example:

```js
var g = 9.82
var number = bar / 2/g

var regex = / 2/g
```

### 接口说明

1、jsTokens.default; // 正在匹配表达式

2、jsTokens.matchToToken // 分词器 function

单元测试用例详情见[TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/js-tokens/TEST.md)

### 约束与限制
在下述版本验证通过：
DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)

DevEco Studio: 4.0 Beta2(4.0.3.512), SDK: API10 (4.0.10.9)

DevEco Studio: 3.1.1 Release(3.1.0.501), SDK: API9 Release(3.2.12.5)

### 软件架构

```
|-ets
|   |-Application
|           |-AbilityStage.ts
|   |-MainAbility
|           |-MainAbility.ts
|   |-pages
|           |-index.ets            #主页demo
```

### 版本

当前版本

```
1.0.0
```

版本日志请查看[CHANGELOG.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/js-tokens/CHANGELOG.md)

### 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls)

### 开源协议

本项目基于[Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/js-tokens/LICENSE),请自由的享受和参与开源