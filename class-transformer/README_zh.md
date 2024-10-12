# class-transformer

## 简介

本库提供对象和类之间基于修饰符的转换、序列化和反序列化的能力。

## 安装

```
ohpm install class-transformer
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 使用说明

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
运行结果：
class-TRANSFORMER----Johny Cage
class-TRANSFORMER----false
```

## 约束与限制

在下述版本验证通过：
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)

- DevEco Studio: 4.1 Canary(4.1.3.213), SDK: API11 4.1.2.3

## 目录结构

```
|---- class-transformer
|     |---- entry  # 示例代码文件夹
|     |---- README.md  # 安装使用方法
|     |---- README_zh.md  # 安装使用方法
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) 给组件，当然，也非常欢迎发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 共建。

## 开源协议

本项目基于 [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/class-transformer/LICENSE) ，请自由地享受和参与开源。
