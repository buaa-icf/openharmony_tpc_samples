/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { Container, injectable } from 'inversify';

export function ninjaFun(){
  @injectable()
  class Katana {
    public h_it() {
      return 'cut!';
    }
  }

  @injectable()
  class Shuriken {
    public throw() {
      return 'hit!';
    }
  }

  @injectable()
  class Ninja {

    public _katana: Katana;
    public _shuriken: Shuriken;

    public constructor(katana: Katana, shuriken: Shuriken) {
      this._katana = katana;
      this._shuriken = shuriken;
    }

    public fight():string { return this._katana.h_it(); }
    public sneak():string { return this._shuriken.throw(); }

  }

  const container = new Container();
  container.bind<Ninja>(Ninja).to(Ninja);
  container.bind<Katana>(Katana).to(Katana);
  container.bind<Shuriken>(Shuriken).to(Shuriken);
    let ninja1
    return ninja1 = container.get<Ninja>(Ninja);
}


export function tryGetNinjaFun() {
  @injectable()
  class Katana {
    public h_it() {
      return "cut!";
    }
  }

  interface Ninja1 {
    fight(): string;

  }

  @injectable()
  class Ninja implements Ninja1 {
    public katana: Katana;

    public constructor(katana: Katana) {
      this.katana = katana;
    }

    public fight(): string {
      return this.katana.h_it();
    }
  }

  const container = new Container();
  container.bind(Katana).toSelf();

  const tryGet = () => container.get(Ninja);
  const ninja = container.get(Ninja);
 return{tryGet,ninja,container,Ninja}

}

export function ninjaContainerFun(){
  @injectable()
  class Katana {
    public h_it() {
      return "cut!";
    }
  }
  interface Ninja1 {
    fight(): string;

  }
  @injectable()
  class Ninja implements Ninja1 {
    public katana: Katana;
    public constructor(katana: Katana) {
      this.katana = katana;
    }
    public fight():string { return this.katana.h_it(); }
  }

  const container = new Container();
  container.bind(Katana).toSelf();
  container.bind(Ninja).toSelf();

  const ninja = container.get(Ninja);
  return ninja
}
