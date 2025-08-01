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
import { Container, ContainerModule, ContainerModuleLoadOptions, ResolutionContext, } from 'inversify';

export default function container_moduleTest() {
  describe('container_moduleTest',  ()=> {
    _it('Should_be_able_to_set_the_registry_of_a_container_module', () => {
      const registry: (
        options: ContainerModuleLoadOptions,
      ) => Promise<void> = async (_options: ContainerModuleLoadOptions) =>
      undefined;

      const warriors: ContainerModule = new ContainerModule(registry);

      expect(warriors.id).to.be.a('number');
    });

    _it('Should_be_able_to_remove_some_bindings_from_within_a_container_module', async () => {
      const container: Container = new Container();

      container.bind<string>('A').toConstantValue('1');
      expect(container.get<string>('A')).to.eql('1');

      const warriors: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          await options.unbind('A');

          expect(() => {
            container.get<string>('A');
          }).to.throw();

          options.bind<string>('A').toConstantValue('2');
          expect(container.get<string>('A')).to.eql('2');

          options.bind<string>('B').toConstantValue('3');
          expect(container.get<string>('B')).to.eql('3');
        },
      );

      await container.load(warriors);

      expect(container.get<string>('A')).to.eql('2');
      expect(container.get<string>('B')).to.eql('3');
    });

    _it('Should_be_able_to_check_for_existence_of_bindings_within_a_container_module', async () => {
      const container: Container = new Container();
      container.bind<string>('A').toConstantValue('1');
      expect(container.get<string>('A')).to.eql('1');

      const warriors: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          expect(options.isBound('A')).to.eql(true);
          await options.unbind('A');
          expect(options.isBound('A')).to.eql(false);
        },
      );

      await container.load(warriors);

    });

    _it('Should_be_able_to_override_a_binding_using_rebind_within_a_container_module', async () => {
      interface TypeType {
        someType: string,
      };

      const TYPES :TypeType = {
        someType: 'someType',
      };

      const container: Container = new Container();

      const module1: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          options.bind<number>(TYPES.someType).toConstantValue(1);
          options.bind<number>(TYPES.someType).toConstantValue(2);
        },
      );

      const module2: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          await options.unbind(TYPES.someType);
          options.bind<number>(TYPES.someType).toConstantValue(3);
        },
      );

      await container.load(module1);

      const values1: number[] = container.getAll(TYPES.someType);
      expect(values1[0]).to.eq(1);

      expect(values1[1]).to.eq(2);

      await container.load(module2);

      const values2: number[] = container.getAll(TYPES.someType);

      expect(values2[0]).to.eq(3);
      expect(values2[1]).to.eq(undefined);
    });

    _it('Should_be_able_use_await_async_functions_in_container_modules', async () => {
      const container: Container = new Container();

      const someAsyncFactory: () => Promise<number> = async () =>
      new Promise<number>(
        (res: (value: number | PromiseLike<number>) => void) =>
        setTimeout(() => {
          res(1);
        }, 100),
      );
      const A = 'A';
      const B = 'B';

      const moduleOne: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          const val: number = await someAsyncFactory();
          options.bind(A).toConstantValue(val);
        },
      );

      const moduleTwo: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          options.bind(B).toConstantValue(2);
        },
      );

      await container.load(moduleOne, moduleTwo);

      const aIsBound: boolean = container.isBound(A);
      expect(aIsBound).to.eq(true);
      const a: number = container.get(A);
      expect(a).to.eq(1);
  });

    _it('Should_be_able_to_add_an_activation_hook_through_a_container_module', async () => {
      const container: Container = new Container();

      const module: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          options
            .bind<string>('B')
            .toConstantValue('2')
            .onActivation(() => 'C');

          options.onActivation('A', () => 'B');

          container.bind<string>('A').toConstantValue('1');
        },
      );

      await container.load(module);

      expect(container.get<string>('A')).to.eql('B');
      expect(container.get('B')).to.eql('C');
    });

    _it('Should_be_able_to_add_a_deactivation_hook_through_a_container_module', async () => {
      const container: Container = new Container();
      container.bind<string>('A').toConstantValue('1');

      let deact: boolean = false;
      const warriors: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          options.onDeactivation('A', () => {
            deact = true;
          });
        },
      );

      await container.load(warriors);
      container.get('A');
      await container.unbind('A');

      expect(deact).eql(true);
    });

    _it('Should_be_able_to_add_an_async_deactivation_hook_through_a_container_module_async', async () => {
      const container: Container = new Container();
      container.bind<string>('A').toConstantValue('1');

      let deact: boolean = false;

      const warriors: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          options.onDeactivation('A', async () => {
            deact = true;
          });
        },
      );

      await container.load(warriors);

      container.get('A');

      await container.unbind('A');

      expect(deact).eql(true);
    });

    _it('Should_remove_module_bindings_when_unload', async () => {
      const sid: string = 'sid';
      const container: Container = new Container();
      container.bind<string>(sid).toConstantValue('Not module');
      const module: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          options.bind<string>(sid).toConstantValue('Module');
        },
      );

      await container.load(module);

      expect(container.getAll(sid)).to.deep.equal(['Not module', 'Module']);

      await container.unload(module);

      expect(container.getAll(sid)).to.deep.equal(['Not module']);
    });

    _it('Should_deactivate_singletons_from_module_bindings_when_unload', async () => {
      const sid: string = 'sid';
      const container: Container = new Container();
      let moduleBindingDeactivated: string | undefined;
      let containerDeactivated: string | undefined;
      const module: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          options
            .bind<string>(sid)
            .toConstantValue('Module')
            .onDeactivation((injectable: string) => {
              moduleBindingDeactivated = injectable;
            });
          options.onDeactivation<string>(sid, (injectable: string) => {
            containerDeactivated = injectable;
          });
        },
      );

      await container.load(module);

      container.get(sid);

      await container.unload(module);

      expect(moduleBindingDeactivated).to.equal('Module');
      expect(containerDeactivated).to.equal('Module');
    });

    _it('Should_remove_container_handlers_from_module_when_unload', async () => {
      const sid: string = 'sid';
      const container: Container = new Container();
      let activatedNotModule: string | undefined;
      let deactivatedNotModule: string | undefined;
      container.onActivation<string>(
        sid,
        (_: ResolutionContext, injected: string) => {
          activatedNotModule = injected;
          return injected;
        },
      );
      container.onDeactivation<string>(sid, (injected: string) => {
        deactivatedNotModule = injected;
      });
      container.bind<string>(sid).toConstantValue('Value');
      let activationCount: number = 0;
      let deactivationCount: number = 0;
      const module: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          options.onDeactivation<string>(sid, (_: string) => {
            deactivationCount++;
          });
          options.onActivation<string>(
            sid,
            (_: ResolutionContext, injected: string) => {
              activationCount++;
              return injected;
            },
          );
        },
      );

      await container.load(module);
      await container.unload(module);

      container.get(sid);
      await container.unbind(sid);

      expect(activationCount).to.equal(0);
      expect(deactivationCount).to.equal(0);

      expect(activatedNotModule).to.equal('Value');
      expect(deactivatedNotModule).to.equal('Value');
    })

    _it('Should_remove_module_bindings_when_unloadAsync', async () => {
      const sid: string = 'sid';
      const container: Container = new Container();
      container.onDeactivation(sid, async (_injected: Function) =>
      Promise.resolve(),
      );
      container.bind<string>(sid).toConstantValue('Not module');
      const module: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          options.bind<string>(sid).toConstantValue('Module');
        },
      );

      await container.load(module);
      let values: number[] = container.getAll(sid);
      expect(values).to.deep.equal(['Not module', 'Module']);

      await container.unload(module);
      values = container.getAll(sid);
      expect(values).to.deep.equal(['Not module']);
    });

    _it('Should_deactivate_singletons_from_module_bindings_when_unloadAsync', async () => {
      const sid: string = 'sid';
      const container: Container = new Container();
      let moduleBindingDeactivated: string | undefined;
      let containerDeactivated: string | undefined;
      const module: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          options
            .bind<string>(sid)
            .toConstantValue('Module')
            .onDeactivation((injectable: string) => {
              moduleBindingDeactivated = injectable;
            });
          options.onDeactivation<string>(sid, async (injectable: string) => {
            containerDeactivated = injectable;
            return Promise.resolve();
          });
        },
      );

      await container.load(module);
      container.get(sid);

      await container.unload(module);
      expect(moduleBindingDeactivated).to.equal('Module');
      expect(containerDeactivated).to.equal('Module');
    });

    _it('Should_remove_container_handlers_from_module_when_unloadAsync', async () => {
      const sid: string = 'sid';
      const container: Container = new Container();
      let activatedNotModule: string | undefined;
      let deactivatedNotModule: string | undefined;
      container.onActivation<string>(
        sid,
        (_: ResolutionContext, injected: string) => {
          activatedNotModule = injected;
          return injected;
        },
      );
      container.onDeactivation<string>(sid, (injected: string) => {
        deactivatedNotModule = injected;
      });
      container.bind<string>(sid).toConstantValue('Value');
      let activationCount: number = 0;
      let deactivationCount: number = 0;
      const module: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          options.onDeactivation<string>(sid, async (_: string) => {
            deactivationCount++;
            return Promise.resolve();
          });
          options.onActivation<string>(
            sid,
            (_: ResolutionContext, injected: string) => {
              activationCount++;
              return injected;
            },
          );
        },
      );

      await container.load(module);
      await container.unload(module);

      container.get(sid);
      await container.unbind(sid);

      expect(activationCount).to.equal(0);
      expect(deactivationCount).to.equal(0);

      expect(activatedNotModule).to.equal('Value');
      expect(deactivatedNotModule).to.equal('Value');
    });

    _it('should_be_able_to_unbindAsync_from_a_module', async () => {
      const sid: string = 'sid';

      const container: Container = new Container();
      const module: ContainerModule = new ContainerModule(
        async (options: ContainerModuleLoadOptions) => {
          await options.unbind(sid);
        },
      );

      container.bind<string>(sid).toConstantValue('Value');
      container.bind<string>(sid).toConstantValue('Value2');
      const deactivated: string[] = [];
      container.onDeactivation<string>(sid, async (injected: string) => {
        deactivated.push(injected);
        return Promise.resolve();
      });

      container.getAll(sid);
      await container.load(module);

      expect(deactivated).to.deep.equal(['Value', 'Value2']);
      expect(container.getAll(sid)).to.deep.equal([]);
    });
  })
}