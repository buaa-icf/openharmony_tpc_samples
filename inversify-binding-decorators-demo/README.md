# inversify-binding-decoratorsDemo

#### Overview

inversify-binding-decoratorsDemo is a utility that helps to verify the function of declaring InversifyJS binding by using the ES2016 decorator on OpenHarmony.

#### How to Install
```shell
ohpm install inversify-binding-decorators
```
For details, see [Installing an OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

#### How to Use
Using ES2016 decorator to declare InversifyJS binding
````
import { injectable, Container } from "inversify";
import { provide, buildProviderModule } from "inversify-binding-decorators/es/index";
import "reflect-metadata";

let container = new Container();

interface Warrior {
    katana: Weapon;
    shuriken: ThrowableWeapon;

    fight(): string;
    
    sneak(): string;
}

interface Weapon {
    hit(): string;
}

interface ThrowableWeapon {
    throw(): string;
}

let TYPE = {
    ThrowableWeapon: "ThrowableWeapon",
    Warrior: "Warrior",
    Weapon: "Weapon"
};

@provide(TYPE.Weapon)
class Katana implements Weapon {
    public hit() {
        return "cut!";
    }
}

@provide(TYPE.ThrowableWeapon)
class Shuriken implements ThrowableWeapon {
    public throw() {
        return "hit!";
    }
}

@provide(TYPE.Warrior)
class Ninja implements Warrior {
    public katana: Weapon;
    public shuriken: ThrowableWeapon;
    
    public constructor(
        @inject(TYPE.Weapon) katana: Weapon,
        @inject(TYPE.ThrowableWeapon) shuriken: ThrowableWeapon
    ) {
        this.katana = katana;
        this.shuriken = shuriken;
    }
    
    public fight() {
        return this.katana.hit();
    }
    
    public sneak() {
        return this.shuriken.throw();
    }
}

container.load(buildProviderModule());
let ninja = container.get<Warrior>(TYPE.Warrior);

expect(ninja instanceof Ninja).eql(true);
expect(ninja.katana instanceof Katana).eql(true);
expect(ninja.shuriken instanceof Shuriken).eql(true);[README.md](..%2FEasyrelpace%2FREADME.md)
expect(ninja.fight()).eql("cut!");
expect(ninja.sneak()).eql("hit!");
````

For details about unit test cases, see [TEST.md](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/inversify-binding-decorators-demo/TEST.md).

For details on how to use inversify-binding-decoratorsDemo, see [inversify-binding-decorators](https://github.com/inversify/inversify-binding-decorators).

### Constraints

inversify-binding-decoratorsDemo has been verified in the following version:

DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)

DevEco Studio: 4.0 Beta1 (4.0.3.400), SDK API10 (4.0.9.6)

### Directory Structure

````
|---- inversify-binding-decorators-demo  [README.md](..%2FEasyrelpace%2FREADME.md)
|     |---- entry  # Sample code
|     |---- ohosTest # Unit test cases
|     |---- README.MD  # Readme
|     |---- README_zh.MD  # Readme
````

## How to Contribute

If you find any problem when using inversify-binding-decoratorsDemo, submit an [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues) or
a [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

## License

This project is licensed under the terms of the [MIT License](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/inversify-binding-decorators-demo/LICENSE).
