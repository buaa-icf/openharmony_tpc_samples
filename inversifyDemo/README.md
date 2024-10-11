# inversifyDemo

## Overview

Inversify is a powerful lightweight inversion control container. inversifyDemo illustrates how to use the third-party JavaScript library [inversify](https://github.com/inversify/InversifyJS) on OpenHarmony. The library is applicable to JavaScript and Node.js applications supported by TypeScript.

## How to Install
```
ohpm install inversify reflect-metadata
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).
## How to Use

```
   import { injectable, inject } from "inversify";
   import "reflect-metadata";
   import { Weapon, ThrowableWeapon, Warrior } from "./interfaces";
   import { TYPES } from "./types";
   
   @injectable()
   class Katana implements Weapon {
       public hit() {
           return "cut!";
       }
   }
   
   @injectable()
   class Shuriken implements ThrowableWeapon {
       public throw() {
           return "hit!";
       }
   }
   
   @injectable()
   @Reflect.metadata("design:paramtypes",[Object,Object])
   class Ninja implements Warrior {
   
       private _katana: Weapon;
       private _shuriken: ThrowableWeapon;
   
       public constructor(
           @inject(TYPES.Weapon) katana: Weapon,
           @inject(TYPES.ThrowableWeapon) shuriken: ThrowableWeapon
       ) {
           this._katana = katana;
           this._shuriken = shuriken;
       }
   
       public fight() { return this._katana.hit(); }
       public sneak() { return this._shuriken.throw(); }
   
   }
   
   export { Ninja, Katana, Shuriken };
```

## Available APIs

|       Name       |      Parameter      |    Description   |
|:----------------:|:-------------:|:----------:|
|   injectable()   |               |    Decorator    |
|     inject()     |    |    Injection   |
|   Container()    |   |     Container    |

For details, see the [Official Documentation](https://github.com/inversify/InversifyJS/tree/master/wiki) and [Unit Test Cases](./TEST.md).

## Constraints
inversifyDemo has been verified in the following version:

DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)
DevEco Studio: 4.0 Beta1 (4.0.3.400), SDK: API10 (4.0.9.6)

## License

This project is licensed under [Apache License 2.0](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/tree/master/inversifyDemo/LICENSE).

## How to Contribute

If you find any problem when using inversifyDemo, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls).
