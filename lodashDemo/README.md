# lodash


## 简介
本项目是OpenHarmony系统下使用lodash的示例，lodash是一个提供拓展功能的JavaScript实用工具库


## 下载安装

```sh
npm install lodash --save
npm install @types/lodash --save
```

## 使用说明
```javascript
    //导入lodash
    import _ from 'lodash'
    //将字符串转换为驼峰式大小写。
    // => 'fooBar'
    console.info("camelCase:" + _.camelCase('Foo Bar'));
    //将字符串的第一个字符转换为大写，将其余字符转换为小写。
    // => 'Fred'
    console.info("capitalize:" + _.capitalize('FRED'));
```
更多api的使用可参考index.ets

## 接口说明
常用模块如下：

|模块名 | 功能 |
|---|---|
| array | 数组相关的拓展api，比如截取，比较，组合等操作 |
| collection | 集合相关的拓展api，比如过滤，查找，排序等操作 |
| math | 数学运算相关的拓展api，比如四舍五入，求和，比大小等操作 |
| string | 字符串相关的拓展api，比如替换，截取，转大小写等操作 |
| util | 常用工具集，比如转驼峰命名，生成唯一id等操作 |

更多模块的使用可参考[官方文档](https://lodash.com/docs/4.17.15)
## 兼容性
- [DevEco Studio版本](https://developer.harmonyos.com/cn/develop/deveco-studio#download)：DevEco Studio 3.1Beta1及以上版本。
- OpenHarmony SDK版本：API version 9及以上版本。

## 贡献代码

使用过程中发现任何问题都可以提 Issue 给我们，当然，我们也非常欢迎你给我们发 PR 。

## 开源协议

该项目基于 [MIT License](https://github.com/lodash/lodash/blob/master/LICENSE) ，请自由地享受和参与开源。