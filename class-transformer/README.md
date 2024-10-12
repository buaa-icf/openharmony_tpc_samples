# class-transformer

## Introduction

This library provides decorator-based conversion, serialization, and deserialization between objects and class instances.

## How to Install

```
ohpm install class-transformer
```

For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

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

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).

## License

This project is licensed under [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/class-transformer/LICENSE).
