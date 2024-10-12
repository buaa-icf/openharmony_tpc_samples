# inversify_inject_decorators-demo

### Overview

inversify_inject_decorators-demo is a utility library that provides methods such as lazyInject on OpenHarmony. In addition to literally lazy, another important function of inversify-inject-decorators is to allow inversifyJs to be integrated into any library or framework created by its own control class instance, such as react.  


### How to Install

```shell
ohpm install inversify-inject-decorators inversify reflect-metadata
```
For details, see [Installing an OpenHarmony HAR](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

inversify-inject-decorators depends on the **inversify** and **reflect-metadata** libraries.

### How to Use

#### 1.lazyInject

The following example shows how to inject dependencies in lazy mode.
````typescript
import getDecorators from "inversify-inject-decorators/es/index";
import { Container, injectable, tagged, named } from "inversify";
@Entry
@Component
struct LazyInjectPage {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear(){
    this.sample()
  }

  sample(){
    let container = new Container();
    let { lazyInject } = getDecorators(container);
    let TYPES = { Weapon: "Weapon" };

    interface Weapon {
      name: string;
      durability: number;
      use(): void;
    }

    @injectable()
    class Sword implements Weapon {
      public name: string;
      public durability: number;
      public constructor() {
        this.durability = 100;
        this.name = "Sword";
      }
      public use() {
        this.durability = this.durability - 10;
      }
    }

    class Warrior {
      @lazyInject(TYPES.Weapon)
      public weapon: Weapon;
    }

    container.bind<Weapon>(TYPES.Weapon).to(Sword);

    let warrior = new Warrior();
    console.log((warrior.weapon instanceof Sword)+""); // true
    this.message=(warrior.weapon instanceof Sword)+"";
  }
}
````

#### 2.lazyInjectNamed

The following example shows how to inject dependencies based on the name.
````typescript
import getDecorators from "inversify-inject-decorators/es/index";
import { Container, injectable, tagged, named } from "inversify";
@Entry
@Component
struct LazyInjectNamedPage {
  @State message: string = 'Hello World'
  @State message2: string = 'Hello World 2'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Text(this.message2)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear(){
    this.sample()
  }

  sample(){
    let container = new Container();
    let { lazyInjectNamed } = getDecorators(container);
    let TYPES = { Weapon: "Weapon" };

    interface Weapon {
      name: string;
      durability: number;
      use(): void;
    }

    @injectable()
    class Sword implements Weapon {
      public name: string;
      public durability: number;
      public constructor() {
        this.durability = 100;
        this.name = "Sword";
      }
      public use() {
        this.durability = this.durability - 10;
      }
    }

    @injectable()
    class Shuriken implements Weapon {
      public name: string;
      public durability: number;
      public constructor() {
        this.durability = 100;
        this.name = "Shuriken";
      }
      public use() {
        this.durability = this.durability - 10;
      }
    }

    class Warrior {

      @lazyInjectNamed(TYPES.Weapon, "not-throwable")
      @named("not-throwable")
      public primaryWeapon: Weapon;

      @lazyInjectNamed(TYPES.Weapon, "throwable")
      @named("throwable")
      public secondaryWeapon: Weapon;

    }

    container.bind<Weapon>(TYPES.Weapon).to(Sword).whenTargetNamed("not-throwable");
    container.bind<Weapon>(TYPES.Weapon).to(Shuriken).whenTargetNamed("throwable");

    let warrior = new Warrior();
    console.log((warrior.primaryWeapon instanceof Sword)+""); // true
    console.log((warrior.primaryWeapon instanceof Shuriken)+""); // true
    this.message=(warrior.primaryWeapon instanceof Sword)+"";
    this.message2=(warrior.primaryWeapon instanceof Shuriken)+"";
  }
}
````

#### 3.lazyInjectTagged

The following example shows how to inject dependencies based on the tag.
````typescript
import getDecorators from "inversify-inject-decorators/es/index";
import { Container, injectable, tagged, named } from "inversify";
@Entry
@Component
struct LazyInjectTaggedPage {
  @State message: string = 'Hello World'
  @State message2: string = 'Hello World 2'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Text(this.message2)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear(){
    this.sample()
  }

  sample(){
    let container = new Container();
    let { lazyInjectTagged } = getDecorators(container);
    let TYPES = { Weapon: "Weapon" };

    interface Weapon {
      name: string;
      durability: number;
      use(): void;
    }

    @injectable()
    class Sword implements Weapon {
      public name: string;
      public durability: number;
      public constructor() {
        this.durability = 100;
        this.name = "Sword";
      }
      public use() {
        this.durability = this.durability - 10;
      }
    }

    @injectable()
    class Shuriken implements Weapon {
      public name: string;
      public durability: number;
      public constructor() {
        this.durability = 100;
        this.name = "Shuriken";
      }
      public use() {
        this.durability = this.durability - 10;
      }
    }

    class Warrior {

      @lazyInjectTagged(TYPES.Weapon, "throwable", false)
      @tagged("throwwable", false)
      public primaryWeapon: Weapon;

      @lazyInjectTagged(TYPES.Weapon, "throwable", true)
      @tagged("throwwable", true)
      public secondaryWeapon: Weapon;

    }

    container.bind<Weapon>(TYPES.Weapon).to(Sword).whenTargetTagged("throwable", false);
    container.bind<Weapon>(TYPES.Weapon).to(Shuriken).whenTargetTagged("throwable", true);

    let warrior = new Warrior();
    console.log((warrior.primaryWeapon instanceof Sword)+""); // true
    console.log((warrior.primaryWeapon instanceof Shuriken)+""); // true
    this.message=(warrior.primaryWeapon instanceof Sword)+"";
    this.message2=(warrior.primaryWeapon instanceof Shuriken)+"";
  }
}
````

#### 4.lazyMultiInject

The following example shows how to inject multiple dependencies.
````typescript
import getDecorators from "inversify-inject-decorators/es/index";
import { Container, injectable, tagged, named } from "inversify";
@Entry
@Component
struct LazyMultiInjectPage {
  @State message: string = 'Hello World'
  @State message2: string = 'Hello World 2'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Text(this.message2)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear(){
    this.sample()
  }

  sample(){
    let container = new Container();
    let { lazyMultiInject } = getDecorators(container);
    let TYPES = { Weapon: "Weapon" };

    interface Weapon {
      name: string;
      durability: number;
      use(): void;
    }

    @injectable()
    class Sword implements Weapon {
      public name: string;
      public durability: number;
      public constructor() {
        this.durability = 100;
        this.name = "Sword";
      }
      public use() {
        this.durability = this.durability - 10;
      }
    }

    @injectable()
    class Shuriken implements Weapon {
      public name: string;
      public durability: number;
      public constructor() {
        this.durability = 100;
        this.name = "Shuriken";
      }
      public use() {
        this.durability = this.durability - 10;
      }
    }

    class Warrior {

      @lazyMultiInject(TYPES.Weapon)
      public weapons: Weapon[];

    }

    container.bind<Weapon>(TYPES.Weapon).to(Sword);
    container.bind<Weapon>(TYPES.Weapon).to(Shuriken);

    let warrior = new Warrior();
    console.log((warrior.weapons[0] instanceof Sword)+""); // true
    console.log((warrior.weapons[1] instanceof Shuriken)+""); // true
    this.message=(warrior.weapons[0] instanceof Sword)+"";
    this.message2=(warrior.weapons[1] instanceof Shuriken)+"";
  }
}
````
For details about unit test cases, see [TEST.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/inversify-inject-decorators-demo/TEST.md).

For details on how to use inversify-binding-decoratorsDemo, see [inversify-binding-decorators][inversify-inject-decorators](https://github.com/inversify/inversify-inject-decorators).

## Available APIs

|          Name          |                                           Description                                           |
|:----------------------:|:-----------------------------------------------------------------------------------------:|
|      @lazyInject       |           Declares dependencies on the attributes of a class, but not in a constructor. This decorator delays acquisition of dependencies from the InversifyJS container until it is really needed, implementing the so-called lazy loading.          |
|    @lazyInjectNamed    |                                       Selects the dependency to be injected based on the name.                                      |
|   @lazyInjectTagged    |                      Selects the dependency to be injected based on the tag instead of name. This allows you to distinguish dependencies based on specific metadata or tags.                     |


### Constraints

inversify-inject-decorators has been verified in the following version:

DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release (5.0.0.66)

DevEco Studio: 4.0 Beta1 (4.0.3.400), SDK: API10 (4.0.9.6)

### Directory Structure

````
|---- inversify-inject-decorators-demo  
|     |---- entry  # Sample code
|     |---- ohosTest # Unit test cases
|     |---- README.MD  # Readme 
|     |---- README_zh.MD  # Readme 
````

### How to Contribute

If you find any problem when using inversify-inject-decoratorsDemo, submit an [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues) or
a [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) to us.

### License

This project is licensed under the terms of the [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/inversify_inject_decorators-demo/LICENSE).
