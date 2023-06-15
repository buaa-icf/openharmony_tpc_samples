# path-to-regexp

## 简介

path-to-regexp是一个将路径字符串(如/user/:name)转换为正则表达式的库。

## 下载安装

```
ohpm install path-to-regexp 
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

安装path-to-regexp库之后，在需要使用的界面先导入path-to-regexp提供的API

```typescript
import { compile, Key, match, parse, pathToRegexp } from 'path-to-regexp';
```

### pathToRegexp---路径转换

  ```typescript
const keys = [];
const regexp = pathToRegexp("/foo/:bar", keys);
// regexp = /^\/foo(?:\/([^\/#\?]+?))[\/#\?]?$/i
// keys = [{ name: 'bar', prefix: '/', suffix: '', pattern: '[^\\/#\\?]+?', modifier: '' }]
  ```

将提供的路径参数转换为正则表达式，返回一个RegExp对象，里面包含了正则表达式的相关信息，用于验证或者路径拼接转换。

### Parameters---参数

#### Named Parameters---命名参数

```typescript
const regexp = pathToRegexp("/:foo/:bar");
// keys = [{ name: 'foo', prefix: '/', ... }, { name: 'bar', prefix: '/', ... }]

regexp.exec("/test/route");
//=> [ '/test/route', 'test', 'route', index: 0, input: '/test/route', groups: undefined ]
```

通过在参数名称之前添加冒号来定义，例如:foo，:bar。使用exec可以解析出路径中符合条件的命名参数。

#### Custom Matching Parameters---自定义Regexp

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

参数中具有自定义regexp，如\\d+，去匹配路径中的数字或者名称。

#### Custom Prefix and Suffix---自定义前缀和后缀

  ```typescript
 const regexp = pathToRegexp("/:attr1?{-:attr2}?{-:attr3}?");

regexp.exec("/test");
// => ['/test', 'test', null, null]

regexp.exec("/test-test");
// => ['/test-test', 'test', 'test', null]
  ```

通过包装在{}里面的参数来实现为路径参数添加自定义的前后缀。

#### Unnamed Parameters---未命名参数

  ```typescript
const regexp = pathToRegexp("/:foo/(.*)");
// keys = [{ name: 'foo', ... }, { name: 0, ... }]

regexp.exec("/test/route");
//=> [ '/test/route', 'test', 'route']
  ```

与命名参数原理相同，仅由regexp组成，例如(.*)，在生成的Regexp里面被数字索引（{ name: 0, ... }），用以匹配任意参数。

#### Modifiers---修饰器

##### Optional---可选参数

  ```typescript
const regexp = pathToRegexp("/:foo/:bar?");
// keys = [{ name: 'foo', ... }, { name: 'bar', prefix: '/', modifier: '?' }]

regexp.exec("/test");
//=> [ '/test', 'test', null ]

regexp.exec("/test/route");
//=> [ '/test/route', 'test', 'route' ]
  ```

在参数后面加上?，可以使得该参数变为可选参数，该参数可传可不传，匹配校验的时候不会失败。

如果参数中含有字符?，它的意义是查询而不是可选参数的时候，需要将?转义，如下所示：

```typescript
const regexp = pathToRegexp("/search/:tableName\\?useIndex=true&term=amazing");

regexp.exec("/search/people?useIndex=true&term=amazing");
//=> [ '/search/people?useIndex=true&term=amazing', 'people', index: 0, input: '/search/people?useIndex=true&term=amazing', groups: undefined ]

// This library does not handle query strings in different orders
regexp.exec("/search/people?term=amazing&useIndex=true");
//=> null
```

##### Zero or more---零个或者多个参数

```typescript
const regexp = pathToRegexp("/:foo*");
// keys = [{ name: 'foo', prefix: '/', modifier: '*' }]

regexp.exec("/");
//=> [ '/', null ]

regexp.exec("/bar/baz");
//=> [ '/bar/baz', 'bar/baz' ]
```

参数以星号*结尾，表示0个或者多个参数匹配。返回值均为结果数组，匹配到0个则数组里面的值包含null。

##### One or more---一个或者多个参数

```typescript
const regexp = pathToRegexp("/:foo+");
// keys = [{ name: 'foo', prefix: '/', modifier: '+' }]

regexp.exec("/");
//=> null

regexp.exec("/bar/baz");
//=> [ '/bar/baz','bar/baz']
```

参数以加号+结尾，表示1个或者多个参数匹配。匹配不到结果返回null而不是匹配结果数组，匹配到了则显示结果数组。

### Match---匹配

  ```typescript
// Make sure you consistently `decode` segments.
const fn = match("/user/:id", { decode: decodeURIComponent });

fn("/user/123"); //=> { path: '/user/123', index: 0, params: { id: '123' } }
fn("/invalid"); //=> false
fn("/user/caf%C3%A9"); //=> { path: '/user/caf%C3%A9', index: 0, params: { id: 'café' } }
  ```

根据指定的规则，经过一系列变换之后，返回一个用于将路径转换为参数的函数。

match也可用于自定义匹配命名参数，如下方所示的tab(home|photos|bio)：

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

#### Process Pathname---路径预处理

```typescript
const fn = match("/café", { encode: encodeURI });

fn("/caf%C3%A9"); //=> { path: '/caf%C3%A9', index: 0, params: {} }
```

有时候匹配的结果是经过特殊编码的，为了确保匹配结果正确，可以通过可选参数 { encode: encodeURI }预先设置转换函数的编码。

#### Alternative Using Normalize---替代方案

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

如果当前可选的encode方式没有符合要求，我们可以使用normalize方法自己提前预处理传入的路径。

### Parse---解析

解析函数负责解析传入的路径字符串，并返回各个参数的解析结果字符串和key的列表。

```typescript
const tokens = parse("/route/:foo/(.*)");

console.log(tokens[0]);
//=> "/route"

console.log(tokens[1]);
//=> { name: 'foo', prefix: '/', suffix: '', pattern: '[^\\/#\\?]+?', modifier: '' }

console.log(tokens[2]);
//=> { name: 0, prefix: '/', suffix: '', pattern: '.*', modifier: '' }
```

### Compile ---编译

Compile将路径规则转换为一个函数，该函数可以将传入的参数拼接为一个有效的路径。

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

## 接口说明

### path-to-regexp

| 接口名           | 参数                                                                          | 返回值           | 说明                                                 |
| ---------------- |-----------------------------------------------------------------------------| ---------------- | ---------------------------------------------------- |
| pathToRegexp     | path: Path,<br/>keys?: Key[],<br/>options?: TokensToRegexpOptions & ParseOptions | RegExp           | 标准化处理给定的路径字符串，返回处理好的正则表达式。 |
| match            | str: Path,<br/>options?: ParseOptions & TokensToRegexpOptions & RegexpToFunctionOptions | MatchFunction<P> | 根据path-to-regexp规范创建路径匹配函数。             |
| parse            | str: string,<br/>options?: ParseOptions                                     | Token[]          | 解析字符串返回原始tokens                             |
| compile          | str: string,<br/>options?: ParseOptions & TokensToFunctionOptions           | PathFunction<P>  | 将字符串编译为路径模版函数                           |
| tokensToFunction | tokens: Token[],<br/>options: TokensToFunctionOptions = {}                  | PathFunction<P>  | 将token转换为路径函数。                              |
| regexpToFunction | re: RegExp,<br/>keys: Key[],<br/>options: RegexpToFunctionOptions = {}      | MatchFunction<P> | 从“path to regexp”输出创建一个路径匹配函数。         |
| tokensToRegexp   | tokens: Token[],<br/>keys?: Key[],<br/>options: TokensToRegexpOptions = {}  | RegExp           | 将token转换为RegExp。                                |

### RegExp

| 接口名 | 参数           | 返回值                  | 说明                                                   |
| ------ | -------------- | ----------------------- | ------------------------------------------------------ |
| exec   | string: string | RegExpExecArray \| null | 使用正则表达式模式校验字符串，返回包含校验结果的数组。 |
| test   | string: string | boolean                 | 校验传入的字符串是否符合规则，返回布尔值。             |

更多模块的使用可参考[官方文档](https://github.com/pillarjs/path-to-regexp/blob/master/Readme.md)，[单元测试用例](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/PathToRegexpDemo/TEST.md)详情可参考

## 约束与限制

在下述版本验证通过：
DevEco Studio: 3.1 Beta2(3.1.0.400),

 SDK: API9 Release(3.2.11.9)

## 目录结构

```javascript
|---- PathToRegexpDemo  
|     |---- entry  # 示例代码文件夹
			|---- pages  # 应用页面，根据测试的不同API分为不同页面。
			|---- CommonResultBean  # 参数包装类，用于组装跳转到公共结果显示界面携带的参数
            |---- JumpPathConfig  # 页面跳转辅助类，用于首页列表的数据显示以及点击跳转参数获取
            |---- TestApi  # PathToRegexp的API调用类 返回API调用处理结果
|     |---- README.MD  # 安装使用方法                   
```

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls)。

## 开源协议

本项目基于 [MIT License ](https://gitee.com/zdy09/openharmony_tpc_samples/blob/master/PathToRegexpDemo/LICENSE)，请自由地享受和参与开源。

