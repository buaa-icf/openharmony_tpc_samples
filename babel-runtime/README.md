# @babel/runtime

## Introduction
> Based on the source code of open-source software [@babel/runtime](https://babeljs.io/docs/babel-runtime), this software uses the TypeScript language to implement related functions. It supports a Babel-runtime auxiliary library to provide necessary runtime support during ES6+ code conversion.

## How to Install
```shell
ohpm install @babel/runtime@7.27.6
```
For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use
1. Import files and code dependencies.
 ```
import _createRawReactElement from '@babel/runtime/helpers/esm/jsx';
import _iterableToArrayLimit from '@babel/runtime/helpers/esm/iterableToArrayLimit';
import _objectSpread2 from "@babel/runtime/helpers/esm/objectSpread2";
import _typeof from '@babel/runtime/helpers/esm/typeof';
import _get from '@babel/runtime/helpers/esm/get';
 ```

## Available APIs
* classCallCheck: Checks whether the keyword **new** is used to instantiate a class in the constructor function of the class.
* defineProperties: Defines multiple attributes of an object.
* defineProperty: Defines a single property of an object.
* extends: Implement class inheritance.
* get: Obtains the attribute value of an object.
* inherits: Implements prototype chain inheritance.
* instanceof: Checks whether an object is an instanceof a class.
* interopRequireDefault: Processes the default export during module import.
* interopRequireWildcard: Processes wildcard export during module import.
* newArrowCheck: Checks whether the keyword **new** is used in the arrow function.
* objectDestructuringEmpty: Processes empty objects during object deconstruction.
* objectWithoutPropertiesLoose: Excludes a specified property from an object.
* possibleConstructorReturn: Returns an instance in the constructor.
* set: Sets the attribute value of an object.
* slicedToArray: Converts a class array object to an array.
* slicedToArrayLoose: Provides functions similar to slicedToArray, but works properly for non-array objects.
* superPropBase: Calls the attributes of the parent class in a child class.
* toArray: Converts a class array object to an array.
* toConsumableArray: Converts an iterable object to an array.
* typeof: Obtains the type of an variable.
* unsupportedIterableToArray: Converts a non-iterative object to an array.
* wrapNativeSuper: Wraps native JavaScript classes.
* asyncGeneratorDelegate: Generates a delegate for an asynchronous iterator.
* asyncIterator: Creates an asynchronous iterator.
* asyncToGenerator: Converts an asynchronous function to a generator function.
* classPrivateFieldGet: Obtains the private fields of a class.
* classPrivateFieldSet: Sets the private fields of a class.
* createSuper: Indicates a superclass used to create a class.
* getPrototypeOf: Obtains the prototype of an object.
* inheritsLoose: Provides functions similar to **inherits**, but works properly for non-function objects.

## Constraints

This project has been verified in the following version:

- DevEco Studio: 4.1 Canary (4.1.3.317), OpenHarmony SDK: API11 (4.1.0.36)

## Directory Structure
````
|---- babel-runtime
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
If you find any problem during the use, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License
This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/babel-runtime/LICENSE).
