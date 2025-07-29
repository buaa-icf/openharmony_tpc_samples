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

interface Material {
  name: string;
}

interface Weapon {
  name: string;
  material: Material;
}

class Katana implements Weapon {
  public name = 'Katana';
  public material: Material;
  public constructor(material: Material) {
    this.material = material;
  }
}

class Shuriken implements Weapon {
  public name = 'Shuriken';
  public material: Material;
  public constructor(material: Material) {
    this.material = material;
  }
}


interface Samurai {
  katana: Weapon;
}

interface Ninja {
  shuriken: Weapon;
}

class NinjaMaster implements Ninja {
  public shuriken: Weapon;
  public constructor(shuriken: Weapon) {
    this.shuriken = shuriken;
  }
}

class SamuraiMaster implements Samurai {
  public katana: Weapon;
  public constructor(katana: Weapon) {
    this.katana = katana;
  }
}

class NinjaStudent implements Ninja {
  public shuriken: Weapon;
  public constructor(shuriken: Weapon) {
    this.shuriken = shuriken;
  }
}

class SamuraiStudent implements Samurai {
  public katana: Weapon;
  public constructor(katana: Weapon) {
    this.katana = katana;
  }
}