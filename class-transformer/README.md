# class-transformer

## Introduction

This library provides decorator-based conversion, serialization, and deserialization between objects and class instances.

## How to Install

```
ohpm install class-transformer
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

```
import  { plainToClass } from "class-transformer";
interface UserJson {
  id: number,
  firstName: string,
  lastName: string,
  age: number
}
const userJson:UserJson = {
  id: 1,
  firstName: "Johny",
  lastName: "Cage",
  age: 27
}

class User {
 id:number;
 firstName:string;
 lastName:string;
 age:number;

  constructor() {
    this.id = 0;
    this.firstName = "";
    this.lastName = "";
    this.age = 0;
  }

 getName() {
   return this.firstName + ' ' + this.lastName;
 }

 isAdult() {
   return this.age > 36 && this.age < 60;
 }
}


const user:User = plainToClass(User,userJson);
log(user.getName());
```

```
Execution result:
class-TRANSFORMER----Johny Cage
class-TRANSFORMER----false
```

## API

| API                                                                 | Description                                                                                                                                                                                                                                                                                                                                                                                                                         |
|---------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `plainToInstance(cls: ClassConstructor<object>, plain: objectJson)` | This method transforms a plain javascript object to instance of specific class.                                                                                                                                                                                                                                                                                                                                                                                                         |
| `plainToClassFromExist(clsObject: object, plain: CompareValue)`     | This method transforms a plain object into an instance using an already filled Object which is an instance of the target class.                                                                                                                                                                                                                                                                                                                                                                                        |
| `instanceToPlain(obj: object);`                                     | This method transforms your class object back to plain javascript object, that can be JSON.stringify later.                                                                                                                                                                                                                                                                                                                                                                                     |
| `instanceToInstance(obj: object);`        | This method transforms your class object into a new instance of the class object. This may be treated as deep clone of your objects.                                                                                                                                                                                                                                                                                                                                                                                           |
| `serialize(obj: object)`                                                 | You can serialize your model right to json using serialize method:                                                                                                                                                                                                                                                                                                                                                                                                            |
| `deserialize(cls: ClassConstructor<object>, obj: object)`                                                  | You can deserialize your model from json using the deserialize method                                                                                                                                                                                                                                                                                                                                                                                                             |

## Constraints

This project has been verified in the following version:

- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)

- DevEco Studio: 4.1 Canary (4.1.3.213), SDK: API11 4.1.2.3

## Directory Structure

```
|---- class-transformer
|     |---- entry      # Sample code
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme
```

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/class-transformer/LICENSE).
