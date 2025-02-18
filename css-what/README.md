# css-what

## Overview
A CSS selector parser.

## How to Install
```shell
ohpm install css-what
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```js
import * as CSSwhat from "css-what";

@Entry
@Component
struct Index {
  build() {
    Column() {
      Text("CSS what " + JSON.stringify(CSSwhat.parse("[attr]")))
        .fontSize(20)
      Text("CSS what " + CSSwhat.stringify(CSSwhat.parse("[attr]")))
        .fontSize(20)
      Text("CSS what " + JSON.stringify(CSSwhat.isTraversal(CSSwhat.parse("foo[bar]:baz")[0][0])))
        .fontSize(20)
      Text("CSS what " + JSON.stringify(CSSwhat.isTraversal(CSSwhat.parse(">")[0][0])))
        .fontSize(20)
    }
    .height('100%')
    .width('100%')
  }
}
```
## Available APIs

- The function returns a two-dimensional array. The first array represents selectors separated by commas (eg. sub1, sub2), the second contains the relevant tokens for that selector. Possible token types are:

```typescript
    parse(selector: string): Selector[][]
    eg：CSSwhat.parse("[attr]")
  | name                | properties                              | example       | output                                                                                   |
  | ------------------- | --------------------------------------- | ------------- | ---------------------------------------------------------------------------------------- |
  | `tag`               | `name`                                  | `div`         | `{ type: 'tag', name: 'div' }`                                                           |
  | `universal`         | -                                       | `*`           | `{ type: 'universal' }`                                                                  |
  | `pseudo`            | `name`, `data`                          | `:name(data)` | `{ type: 'pseudo', name: 'name', data: 'data' }`                                         |
  | `pseudo`            | `name`, `data`                          | `:name`       | `{ type: 'pseudo', name: 'name', data: null }`                                           |
  | `pseudo-element`    | `name`                                  | `::name`      | `{ type: 'pseudo-element', name: 'name' }`                                               |
  | `attribute`         | `name`, `action`, `value`, `ignoreCase` | `[attr]`      | `{ type: 'attribute', name: 'attr', action: 'exists', value: '', ignoreCase: false }`    |
  | `attribute`         | `name`, `action`, `value`, `ignoreCase` | `[attr=val]`  | `{ type: 'attribute', name: 'attr', action: 'equals', value: 'val', ignoreCase: false }` |
  | `attribute`         | `name`, `action`, `value`, `ignoreCase` | `[attr^=val]` | `{ type: 'attribute', name: 'attr', action: 'start', value: 'val', ignoreCase: false }`  |
  | `attribute`         | `name`, `action`, `value`, `ignoreCase` | `[attr$=val]` | `{ type: 'attribute', name: 'attr', action: 'end', value: 'val', ignoreCase: false }`    |
  | `child`             | -                                       | `>`           | `{ type: 'child' }`                                                                      |
  | `parent`            | -                                       | `<`           | `{ type: 'parent' }`                                                                     |
  | `sibling`           | -                                       | `~`           | `{ type: 'sibling' }`                                                                    |
  | `adjacent`          | -                                       | `+`           | `{ type: 'adjacent' }`                                                                   |
  | `descendant`        | -                                       |               | `{ type: 'descendant' }`                                                                 |
  | `column-combinator` | -                                       | `\|\|`        | `{ type: 'column-combinator' }`                                                          |
```
- Turns selector back into a string.

```typescript
    stringify(selector: Selector[][]): string;
    eg：CSSwhat.stringify(CSSwhat.parse("[attr]"))
```
- Checks whether a specific selector is a traversal.

```typescript
    isTraversal(selector: Selector): selector is Traversal;
    eg：CSSwhat.isTraversal(CSSwhat.parse(">")[0][0])
```
## Constraints

css-what has been verified in the following version:

- DevEco Studio Version: 5.0.1 Release (5.0.5.310), OpenHarmony SDK: 13 (5.0.0(13))
- DevEco Studio Version: DevEco Studio 5.1.0 Canary1(5.1.0.229)，OpenHarmony SDK:5.1.0.229 API16（5.1.0.46）

## Directory Structure
```
|----css-what
|     |---- entry  # Sample code
|          |----src
|              |----main
|                  |----ets
|                      |----pages
|                          |---- Index.ets
|     |---- README.md  # Readme 
|     |---- README_zh.md  # Readme 
```

## How to Contribute
If you find any problem when using css-what, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/css-what/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/css-what/pulls).

## License
This project is licensed under [BSD 2-Clause](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/css-what/blob/master/LICENSE).
