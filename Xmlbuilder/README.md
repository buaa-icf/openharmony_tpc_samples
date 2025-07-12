# xmlbuilder

## Introduction

> xmlbuilder is a JavaScript library for building XML documents. It provides a simple and intuitive way to create and generate XML documents.

## How to Install

````
ohpm install xmlbuilder@15.1.1
````

OpenHarmony

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### Organizing XML Information

```
  buildXml() {
    const xml = xmlbuilder.create('root', { version: '1.0', encoding: 'UTF-8' })
      .ele('child', 'Child Element')
      .end({ pretty: true});
    this.message = xml
  }
```

### Organizing HTML Information

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

## Available APIs

| API                                | Description                       |
| ---------------------------------------- | --------------------------- |
| create(type:string,opt:Option)           | Creates an XML or HTML builder instance.|
| ele(name:string,ele:string,obj:ESObject) | Adds an element and its content.             |
| end(opt?:ESObject)                       | Sets the parameter for ending the generation.         |
| att(name:string,content:string)          | Sets the property content.               |
| removeAttribute(name:string)             | Removes a property.               |
| cdata(content:string)                    | Sets the cdata content.              |
| raw(content:string)                      | Sets the raw content.                |
| com(content:string)                      | Sets the comment content.                |
| ins(name:string,content:string)          | Sets an instruction name and its content.            |

## Constraints

This project has been verified in the following version:

DevEco Studio 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT LICENSE](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/Xmlbuilder/LICENSE).
