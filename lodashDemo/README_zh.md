# lodash


## 简介
本项目是OpenHarmony系统下使用lodash的示例，lodash是一个提供拓展功能的JavaScript实用工具库


## 下载安装

```shell
ohpm install lodash
ohpm install @types/lodash --save-dev //import lodash 的时候语法报错.其原因是lodash包内不含类型声明,需要 @types/lodash 下载这个包的声明文件,从而解决语法的报错.

```
OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明
```javascript
    //导入lodash相关接口
    import { camelCase, capitalize } from 'lodash'
    let camelCaseString = camelCase('__FOO_BAR__');
    // => 'fooBar'
    console.log('转换字符串为驼峰写法为：' + camelCaseString);
    let capitalizeString = capitalize('FRED');
    // => 'Fred'
    console.log('转换字符串首字母为大写，剩下为小写为：' + capitalizeString);
```
更多api的使用可参考ArrayTest.ets,FunctionTest.ets,NumberTest.ets,CollectionTest.ets,DateTest.ets,LangTest.ets,MathTest.ets,ObjectTest.ets,StringTest.ets,UtilTest.ets

## 接口说明
常用模块如下：

|模块名 | 功能 |
|---|---|
| array | 数组相关的拓展api，比如截取，比较，组合等操作 |
| collection | 集合相关的拓展api，比如过滤，查找，排序等操作 |
| math | 数学运算相关的拓展api，比如四舍五入，求和，比大小等操作 |
| string | 字符串相关的拓展api，比如替换，截取，转大小写等操作 |
| util | 常用工具集，比如转驼峰命名，生成唯一id等操作 |


| 方法名 | 入参 | 接口描述 |
| --- | --- | --- |
| `chunk` | `array`, `[size=1]` | 将数组拆分成多个指定长度的区块，并将这些区块组成一个新数组。 |
| `compact` | `array` | 创建一个新数组，包含原数组中所有的非假值元素。 |
| `uniq` | `array` | 创建一个去重后的 `array` 数组副本。 |
| `union` | `[arrays]` | 创建唯一值的数组，这个数组包含所有给定数组的元素，去除重复的值。 |
| `forEach` | `collection`, `[iteratee=identity]` | 遍历集合中的元素，对每个元素执行 `iteratee` 函数。 |
| `sample` | `collection` | 从集合中随机返回一个元素。 |
| `flatMap` | `collection`, `[iteratee=identity]` | 创建一个扁平化的数组，其结果是 `iteratee` 遍历 `collection` 中每个元素返回的结果。 |
| `now` |  | 返回当前的时间戳。 |
| `map` | `collection`, `[iteratee=identity]` | 创建一个数组，值是 `iteratee` 遍历 `collection` 中的每个元素后返回的结果。 |
| `ary` | `func`, `[n=func.length]` | 创建一个函数，该函数最多接受 `n` 个参数，忽略多余的参数。 |
| `curry` | `func`, `[arity=func.length]` | 创建一个函数，该函数可以分次接收参数，直到参数数量达到 `arity` 后执行原函数。 |
| `debounce` | `func`, `[wait=0]`, `[options={}]` | 创建一个防抖函数，该函数会延迟 `func` 执行，在延迟期间如果再次调用防抖函数，则重新计算延迟时间。 |
| `delay` | `func`, `[wait=0]`, `[args]` | 延迟 `wait` 毫秒后执行 `func`，并传入 `args` 参数。 |
| `castArray` | `value` | 如果 `value` 不是数组，则强制将其转换为数组。 |
| `clone` | `value` | 创建一个 `value` 的浅拷贝。 |
| `eq` | `value`, `other` | 执行浅比较来确定两者的值是否相等。 |
| `isArrayBuffer` | `value` | 检查 `value` 是否是一个 `ArrayBuffer`。 |
| `isNumber` | `value` | 检查 `value` 是否是 `number` 类型。 |
| `add` | `augend`, `addend` | 计算两个数字的和。 |
| `ceil` | `number`, `[precision=0]` | 向上取整 `number` 到 `precision` 小数位。 |
| `meanBy` | `collection`, `[iteratee=identity]` | 计算 `collection` 中每个元素经过 `iteratee` 处理后的平均值。 |
| `clamp` | `number`, `[lower]`, `upper` | 将 `number` 限制在 `lower` 和 `upper` 之间。 |
| `inRange` | `number`, `[start=0]`, `end` | 检查 `number` 是否在 `start` 和 `end` 之间。 |
| `random` | `[lower=0]`, `[upper=1]`, `[floating]` | 生成一个随机数。 |
| `assignIn` | `object`, `[sources]` | 将所有可枚举属性的值（包括继承的属性）从一个或多个源对象复制到目标对象。 |
| `findKey` | `object`, `[predicate=identity]` | 遍历对象的自身和继承的可枚举属性，返回第一个使 `predicate` 返回真值的属性的键名，否则返回 `undefined`。 |
| `forIn` | `object`, `[iteratee=identity]` | 遍历对象的自身和继承的可枚举属性。 |
| `keys` | `object` | 获取对象自身的所有可枚举属性的键名。 |
| `get` | `object`, `path`, `[defaultValue]` | 根据对象的路径获取属性值。 |
| `invert` | `object` | 创建一个对象，这个对象的键值对是原对象的值键对。 |
| `camelCase` | `[string='']` | 将字符串转换为驼峰式。 |
| `capitalize` | `[string='']` | 将字符串的首字母大写。 |
| `escape` | `[string='']` | 转义字符串中的 HTML 实体。 |
| `kebabCase` | `[string='']` | 将字符串转换为短横线分隔形式。 |
| `pad` | `[string='']`, `[length=0]`, `[chars=' ']` | 在字符串的开头和结尾填充 `chars` 直到字符串达到 `length` 长度。 |
| `parseInt` | `string`, `[radix=10]` | 将字符串转换为整数。 |
| `conforms` | `source` | 创建一个函数，该函数检查给定的对象是否满足 `source` 中的条件。 |
| `filter` | `collection`, `[predicate=identity]` | 遍历集合中的元素，返回一个所有元素测试结果为真值的数组。 |
| `defaultTo` | `value`, `defaultValue` | 如果 `value` 是 `NaN`、`null` 或 `undefined`，则返回 `defaultValue`。 |
| `identity` | `value` | 返回传入的值。 |
| `nthArg` | `n` | 创建一个函数，该函数返回其第 `n` 个参数。 |
| `stubObject` |  | 返回一个空对象。 |
| `times` | `n`, `[iteratee=identity]` | 调用 `iteratee` 函数 `n` 次，返回一个包含每次调用结果的数组。 |


更多模块的使用可参考[官方文档](https://lodash.com/docs/4.17.15)
## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 4.1 Canary(4.1.3.317)

- OpenHarmony SDK:API11 (4.1.0.36)

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

该项目基于 [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/lodashDemo/LICENSE) ，请自由地享受和参与开源。