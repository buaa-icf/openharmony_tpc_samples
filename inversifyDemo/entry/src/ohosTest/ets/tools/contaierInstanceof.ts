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
import * as ns from "reflect-metadata";
import {inject, injectable , Container} from 'inversify';
ns;
export function contaierInstance(test){
  interface Warrior {
  }

  @injectable()
  class Ninja implements Warrior { }

  @injectable()
  class Samurai implements Warrior { }

  const container = new Container();
  container.bind<Warrior>(Ninja).to(Ninja);
  container.bind<Warrior>(Samurai).to(Samurai);

    if(test == "Samurai"){
      let aa =  (container.get(Samurai)) instanceof Samurai
      return aa
    }
    if(test == "Ninja"){
      let aa =  (container.get(Ninja)) instanceof Ninja
      return aa
    }
  return false
}

export function arrayConversion1(a) {

  return [a];

}

export function weaponProperty1() {

  interface Weapon { }
  @injectable()
  class Shuriken implements Weapon { }
  @injectable()
  class Ninja {
    @inject('Weapon')
    weaponProperty: Weapon
  }
  const container = new Container();
  container.bind('Weapon').to(Shuriken);
  const myNinja = container.get(Ninja);
  const weapon = myNinja.weaponProperty;
  let boo=weapon instanceof Shuriken
  return {boo:boo}
}