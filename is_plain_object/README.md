# is-plain-object

## Introduction

> is-plain-object returns **true** if an object is created by the **object** constructor or **object.create(null)**.

## How to Install

```shell
ohpm  install is-plain-object@5.0.0
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use


```js
import { isPlainObject } from 'is-plain-object';
```


```js
isPlainObject(Object.create({}));
//=> true
isPlainObject(Object.create(Object.prototype));
//=> true
isPlainObject({ foo: 'bar' });
//=> true
isPlainObject({});
//=> true
isPlainObject(null);
//=> true
```


```js
isPlainObject(1);
//=> false
isPlainObject(['foo', 'bar']);
//=> false
isPlainObject([]);
//=> false
isPlainObject(new Foo);
//=> false
isPlainObject(Object.create(null));
//=> false
```

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API 11 (4.1.0.36)

## Directory Structure

````
|---- is_plain_object
|     |---- entry  # Sample code
          ├── src  
              ├── main   
                   ├── ets
                       ├── pages
                             ├── Index.ets  # Sample code
|     |---- README.md  # Readme           
|     |---- README_zh.md  # Readme         
````

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/is-plain-object/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/is-plain-object/pulls).

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/is-plain-object/blob/master/LICENSE).
