# xmlbuilder

## 简介

> xmlbuilder 是一个用于构建 XML 文档的 JavaScript 库。它提供了一种简单而直观的方式来创建和生成符合 XML 标准的文档。

## 下载安装

````
ohpm install xmlbuilder@11.0.0
````

对于OpenHarmony ohpm环境配置的详细信息，请参阅[OpenHarmony环境配置指南](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)。

## 使用说明

### 组织xml信息

```
  buildXml() {
    const xml = xmlbuilder.create('root', { version: '1.0', encoding: 'UTF-8' })
      .ele('child', 'Child Element')
      .end({ pretty: true});
    this.message = xml
  }
```

### 组织html信息

```
  buildHtml() {
    const html = xmlbuilder.create('html', { version: '1.0', encoding: 'UTF-8' })
      .ele('head')
      .ele('title', 'My Page')
      .ele('body')
      .ele('h1', 'Welcome to My Page')
      .ele('p', 'This is a simple HTML document generated using XMLBuilder.')
      .end({ pretty: true });
    this.message = html
  }
```

## 接口说明

| **接口**                                   | 功能                |
|------------------------------------------|-------------------|
| create(type:string,opt:Option)           | 创建一个xml或html生成器实例 |
| ele(name:string,ele:string,obj:ESObject) | 添加元素及内容           |
| end(opt?:ESObject)                       | 设置结束生成的参数         |
| att(name:string,content:string)          | 设置属性内容            |
| removeAttribute(name:string)             | 移除指定属性            |
| cdata(content:string)                    | 设置cdata内容         |
| raw(content:string)                      | 设置raw内容           |
| com(content:string)                      | 设置com内容           |
| ins(name:string,content:string)          | 设置ins名及内容         |

## 约束与限制

在下述版本验证通过：适配DevEco Studio:4.1 Canary(4.1.3.317)，OpenHarmony SDK:API version 11 (4.1.0.36).

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目遵循 [MIT 协议](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Xmlbuilder/LICENSE)。