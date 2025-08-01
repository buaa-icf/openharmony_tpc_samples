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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from '../utils/util'
import { Container, injectable, Provider, ResolutionContext } from 'inversify';

async function valueOrDefault<T>(
  provider: () => Promise<T>,
  defaultValue: T
): Promise<T> {
  try {
    return await provider();
  } catch {
    return defaultValue;
  }
}

interface NinjaMasterLike {
  rank: string;
}

export default function providerTest() {
  describe('providerTest',  ()=> {
    _it('Should_support_complex_asynchronous_initialization_processes', (done:ESObject) => {
      @injectable()
      class Ninja {
        public level: number;
        public rank: string;
        public constructor() {
          this.level = 0;
          this.rank = 'Ninja';
        }
        public train(): Promise<number> {
          return new Promise<number>((resolve) => {
            setTimeout(() => {
              this.level += 10;
              resolve(this.level);
            }, 10);
          });
        }
      }

      @injectable()
      class NinjaMaster {
        public rank: string;
        public constructor() {
          this.rank = 'NinjaMaster';
        }
      }

      type NinjaMasterProvider = () => Promise<NinjaMaster>;

      const container: Container = new Container();

      container.bind<Ninja>('Ninja').to(Ninja).inSingletonScope();
      container.bind<NinjaMasterProvider>('Provider<NinjaMaster>').toProvider(
        (context: ResolutionContext) => async () =>
        new Promise<NinjaMaster>(
          (
            resolve: (value: NinjaMaster | PromiseLike<NinjaMaster>) => void,
            reject: (reason?: string) => void,
          ) => {
            const ninja: Ninja = context.get<Ninja>('Ninja');

            void ninja.train().then((level: number) => {
              if (level >= 20) {
                resolve(new NinjaMaster());
              } else {
                reject('Not enough training');
              }
            });
          },
        ),
      );

      const ninjaMasterProvider: NinjaMasterProvider =
        container.get<NinjaMasterProvider>('Provider<NinjaMaster>');

      void valueOrDefault(ninjaMasterProvider, {
        rank: 'DefaultNinjaMaster',
      } as NinjaMasterLike).then((ninjaMaster: NinjaMaster) => {
        expect(ninjaMaster.rank).to.eql('DefaultNinjaMaster');
      });

      void valueOrDefault(ninjaMasterProvider, {
        rank: 'DefaultNinjaMaster',
      } as NinjaMasterLike).then((ninjaMaster: NinjaMaster) => {
        expect(ninjaMaster.rank).to.eql('NinjaMaster');
        done();
      });
    });

    _it('Should_support_custom_arguments', (done:ESObject) => {
      const container: Container = new Container();

      interface Sword {
        material: string;
        damage: number;
      }

      @injectable()
      class Katana implements Sword {
        public material!: string;
        public damage!: number;
      }

      container.bind<Sword>('Sword').to(Katana);

      type SwordProvider = Provider<Sword, [string, number]>;

      container.bind<SwordProvider>('SwordProvider').toProvider(
        (context: ResolutionContext): SwordProvider =>
        async (material: string, damage: number) =>
        new Promise<Sword>(
          (resolve: (value: Sword | PromiseLike<Sword>) => void) => {
            setTimeout(() => {
              const katana: Sword = context.get<Sword>('Sword');
              katana.material = material;
              katana.damage = damage;
              resolve(katana);
            }, 10);
          },
        ),
      );

      const katanaProvider: SwordProvider =
        container.get<SwordProvider>('SwordProvider');

      void katanaProvider('gold', 100).then((powerfulGoldKatana: Sword) => {
        expect(powerfulGoldKatana.material).to.eql('gold');

        expect(powerfulGoldKatana.damage).to.eql(100);

        void katanaProvider('gold', 10).then((notSoPowerfulGoldKatana: Sword) => {
          expect(notSoPowerfulGoldKatana.material).to.eql('gold');

          expect(notSoPowerfulGoldKatana.damage).to.eql(10);
          done();
        });
      });
    });

    _it('Should_support_the_declaration_of_singletons', (done:ESObject) => {
      const container: Container = new Container();

      interface Warrior {
        level: number;
      }

      @injectable()
      class Ninja implements Warrior {
        public level: number;
        constructor() {
          this.level = 0;
        }
      }

      type WarriorProvider = (level: number) => Promise<Warrior>;

      container.bind<Warrior>('Warrior').to(Ninja).inSingletonScope(); // Value is singleton!

      container.bind<WarriorProvider>('WarriorProvider').toProvider(
        (context: ResolutionContext) => async (increaseLevel: number) =>
        new Promise<Warrior>((resolve: (value: Warrior) => void) => {
          setTimeout(() => {
            const warrior: Warrior = context.get<Warrior>('Warrior');
            warrior.level += increaseLevel;
            resolve(warrior);
          }, 100);
        }),
      );

      const warriorProvider: WarriorProvider = container.get('WarriorProvider');

      void warriorProvider(10).then((warrior: Warrior) => {
        expect(warrior.level).to.eql(10);

        void warriorProvider(10).then((warrior2: Warrior) => {
          expect(warrior2.level).to.eql(20);
          done();
        });
      });
    });
  })
}