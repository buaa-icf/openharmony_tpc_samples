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
import { bindingScopeValues, Container,inject, injectable, postConstruct, ResolutionContext} from 'inversify';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from '../utils/util'
import { symbolFor } from '../tools/symbol';
import { contaierInstance } from "../tools/contaierInstanceof"

export default function containerTest() {
  describe('containerTest',  ()=> {
    _it('Should_unbind_a_binding_when_requested', async() => {

      @injectable()
      class Ninja {}
      const ninjaId: string = 'Ninja';

      const container: Container = new Container();
      container.bind<Ninja>(ninjaId).to(Ninja);

      await container.unbind(ninjaId);

      expect(container.isBound(ninjaId)).equal(false);

    });

    _it('Should_throw_when_cannot_unbind', () => {
      const serviceIdentifier = 'Ninja';
      const container = new Container();

      if (container.isBound(serviceIdentifier)) {
        container.unbind(serviceIdentifier);
      }

      let errorThrown = false;
      try {
        container.unbind(serviceIdentifier);
      } catch (error) {
        errorThrown = true;
      }

      expect(errorThrown).to.be.true;
    });

    _it('Should_throw_when_cannot_unbind_(async)', async () => {
      const serviceIdentifier = 'Ninja';
      const container = new Container();

      try {
        await container.unbindSync(serviceIdentifier);
      } catch (err) {
        expect((err as Error).message).to.eql(``);
      }
    });

    _it('Should_unbind_a_binding_when_requested_', async () => {

      @injectable()
      class Ninja {}

      @injectable()
      class Samurai {}

      const ninjaId: string = 'Ninja';
      const samuraiId: string = 'Samurai';

      const container: Container = new Container();
      container.bind<Ninja>(ninjaId).to(Ninja);
      container.bind<Samurai>(samuraiId).to(Samurai);

      expect(container.isBound(ninjaId)).equal(true);
      expect(container.isBound(samuraiId)).equal(true);

      await container.unbind(ninjaId);

      expect(container.isBound(ninjaId)).equal(false);
      expect(container.isBound(samuraiId)).equal(true);
    });

    _it('Should_be_able_unbound_all_dependencies', async () => {

      @injectable()
      class Ninja {}

      @injectable()
      class Samurai {}

      const ninjaId: string = 'Ninja';
      const samuraiId: string = 'Samurai';

      const container: Container = new Container();
      container.bind<Ninja>(ninjaId).to(Ninja);
      container.bind<Samurai>(samuraiId).to(Samurai);

      expect(container.isBound(ninjaId)).equal(true);
      expect(container.isBound(samuraiId)).equal(true);

      await container.unbindAll();

      expect(container.isBound(ninjaId)).equal(false);
      expect(container.isBound(samuraiId)).equal(false);

    });

    _it('Should_NOT_be_able_to_get_unregistered_services', () => {

      interface Ninja1 { }

      @injectable()
      class Ninja implements Ninja1 { }
      const ninjaId = 'Ninja';

      const container = new Container();
      const throwFunction = () => { container.get<Ninja>(ninjaId); };

      expect(throwFunction).to.throw(``);
    });

    _it('Should_NOT_be_able_to_get_ambiguous_match', () => {
      interface Warrior {};

      @injectable()
      class Ninja {}

      @injectable()
      class Samurai {}

      const warriorId: string = 'Warrior';

      const container: Container = new Container();
      container.bind<Warrior>(warriorId).to(Ninja);
      container.bind<Warrior>(warriorId).to(Samurai);

      const throwFunction: () => void = () => {
        container.get<Warrior>(warriorId);
      };
      expect(throwFunction).to.throw('');
    });

    _it('Should_NOT_be_able_to_getAll_of_an_unregistered_services', () => {

      interface Ninja1 { }

      @injectable()
      class Ninja implements Ninja1 { }
      const ninjaId = 'Ninja';

      const container: Container = new Container();

      expect(container.getAll<Ninja>(ninjaId)).to.deep.equal([]);

    });

    _it('Should_be_able_to_snapshot_and_restore_container', () => {

      interface Warrior {
      }

      @injectable()
      class Ninja implements Warrior { }

      @injectable()
      class Samurai implements Warrior { }

      const container = new Container();
      container.bind<Warrior>(Ninja).to(Ninja);
      container.bind<Warrior>(Samurai).to(Samurai);
      let contaierInstance1:Boolean = contaierInstance("Samurai")
      expect(contaierInstance1).equal(true)

      let contaierInstance2:Boolean = contaierInstance("Ninja")
      expect(contaierInstance2).equal(true)

      container.snapshot(); // snapshot container = v1

      container.unbind(Ninja);

      let contaierInstance3:Boolean = contaierInstance("Samurai")
      expect(contaierInstance3).equal(true)
      expect(() => container.get(Ninja)).to.throw();

      container.snapshot(); // snapshot container = v2
      expect(() => container.get(Ninja)).to.throw();

      container.bind<Warrior>(Ninja).to(Ninja);
      let contaierInstance4:Boolean = contaierInstance("Samurai")
      expect(contaierInstance4).equal(true)

      let contaierInstance5:Boolean = contaierInstance("Ninja")
      expect(contaierInstance5).equal(true)


      container.restore(); // restore container to v2
      let contaierInstance6:Boolean = contaierInstance("Samurai")
      expect(contaierInstance6).equal(true)
      expect(() => container.get(Ninja)).to.throw();

      container.restore(); // restore container to v1
      let contaierInstance7:Boolean = contaierInstance("Samurai")
      expect(contaierInstance7).equal(true)

      let contaierInstance8:Boolean = contaierInstance("Ninja")
      expect(contaierInstance8).equal(true)


    });

    _it('Should_maintain_the_activation_state_of_a_singleton_when_doing_a_snapshot_of_a_container', () => {

      let timesCalled = 0;

      @injectable()
      class Ninja {
        @postConstruct()
        public postConstruct() {
          timesCalled++;
        }
      }

      const container = new Container();

      container.bind<Ninja>(Ninja).to(Ninja).inSingletonScope();

      container.get<Ninja>(Ninja);
      container.snapshot();
      container.restore();
      container.get<Ninja>(Ninja);

      expect(timesCalled).to.be.equal(1);
    });

    _it('Should_save_and_restore_the_container_activations_and_deactivations_when_snapshot_and_restore', () => {
      const sid = 'sid';
      const container = new Container();
      container.bind<string>(sid).toConstantValue('Value');

      let activated = false;
      let deactivated = false

      container.snapshot();

      container.onActivation<string>(sid, (c, i) => {
        activated = true;
        return i;
      });
      container.onDeactivation(sid, (i:ESObject) => {
        deactivated = true;
      });

      container.restore();

      container.get(sid);
      container.unbind(sid);

      expect(activated).to.equal(false);
      expect(deactivated).to.equal(false);
    })

    _it('Should_be_able_to_check_is_there_are_bindings_available_for_a_given_identifier', () => {

      interface Warrior { }
      const warriorId = 'Warrior';
      const warriorSymbol = symbolFor('Warrior');

      @injectable()
      class Ninja implements Warrior { }

      const container = new Container();
      container.bind<Warrior>(Ninja).to(Ninja);
      container.bind<Warrior>(warriorId).to(Ninja);
      container.bind<Warrior>(warriorSymbol).to(Ninja);

      expect(container.isBound(Ninja)).equal(true);
      expect(container.isBound(warriorId)).equal(true);
      expect(container.isBound(warriorSymbol)).equal(true);

      interface Katana1 { }
      const katanaId = 'Katana';
      const katanaSymbol = symbolFor('Katana');

      @injectable()
      class Katana implements Katana1 { }

      expect(container.isBound(Katana)).equal(false);
      expect(container.isBound(katanaId)).equal(false);
      expect(container.isBound(katanaSymbol)).equal(false);

    });

    _it('Should_be_able_to_check_is_there_are_bindings_available_for_a_given_identifier_only_in_current_container', () => {
      @injectable()
      class Ninja {}

      const containerParent: Container = new Container();
      const containerChild: Container = new Container({
        parent: containerParent,
      });

      containerParent.bind(Ninja).to(Ninja);

      expect(containerParent.isBound(Ninja)).to.eql(true);
      expect(containerChild.isBound(Ninja)).to.eql(true);
      expect(containerChild.isCurrentBound(Ninja)).to.eql(false);
    });

    _it('Should_be_able_to_get_services_from_parent_container', () => {
      const weaponIdentifier: string = 'Weapon';

      @injectable()
      class Katana {}

      const container: Container = new Container();
      container.bind(weaponIdentifier).to(Katana);

      const childContainer: Container = new Container({ parent: container });

      const secondChildContainer: Container = new Container({
        parent: childContainer,
      });

      expect(secondChildContainer.get(weaponIdentifier)).to.be.instanceOf(Katana);
    });

    _it('Should_be_able_to_check_if_services_are_bound_from_parent_container', () => {
      const weaponIdentifier: string = 'Weapon';

      @injectable()
      class Katana {}

      const container: Container = new Container();
      container.bind(weaponIdentifier).to(Katana);

      const childContainer: Container = new Container({ parent: container });

      const secondChildContainer: Container = new Container({
        parent: childContainer,
      });

      expect(secondChildContainer.isBound(weaponIdentifier)).to.be.equal(true);
    });

    _it('Should_prioritize_requested_container_to_resolve_a_service_identifier', () => {
      const weaponIdentifier: string = 'Weapon';

      @injectable()
      class Katana {}

      @injectable()
      class DivineRapier {}

      const container: Container = new Container();
      container.bind(weaponIdentifier).to(Katana);

      const childContainer: Container = new Container({ parent: container });

      const secondChildContainer: Container = new Container({
        parent: childContainer,
      });
      secondChildContainer.bind(weaponIdentifier).to(DivineRapier);

      expect(secondChildContainer.get(weaponIdentifier)).to.be.instanceOf(
        DivineRapier,
      );
    });

    _it('Should_be_able_to_resolve_named_multi-injection', () => {
      interface Intl {
        hello?: string;
        goodbye?: string;
      }

      const container: Container = new Container();
      container
        .bind<Intl>('Intl')
        .toConstantValue({ hello: 'bonjour' })
        .whenNamed('fr');
      container
        .bind<Intl>('Intl')
        .toConstantValue({ goodbye: 'au revoir' })
        .whenNamed('fr');
      container
        .bind<Intl>('Intl')
        .toConstantValue({ hello: 'hola' })
        .whenNamed('es');
      container
        .bind<Intl>('Intl')
        .toConstantValue({ goodbye: 'adios' })
        .whenNamed('es');

      const fr: Intl[] = container.getAll<Intl>('Intl', { name: 'fr' });

      expect(fr.length).to.equal(2);
      expect(fr[0]?.hello).to.equal('bonjour');
      expect(fr[1]?.goodbye).to.equal('au revoir');

      const es: Intl[] = container.getAll<Intl>('Intl', { name: 'es' });

      expect(es.length).to.equal(2);
      expect(es[0]?.hello).to.equal('hola');
      expect(es[1]?.goodbye).to.equal('adios');
    });

    _it('Should_be_able_to_resolve_tagged_multi-injection', () => {
      interface Intl {
        hello?: string;
        goodbye?: string;
      }

      const container: Container = new Container();
      container
        .bind<Intl>('Intl')
        .toConstantValue({ hello: 'bonjour' })
        .whenTagged('lang', 'fr');
      container
        .bind<Intl>('Intl')
        .toConstantValue({ goodbye: 'au revoir' })
        .whenTagged('lang', 'fr');
      container
        .bind<Intl>('Intl')
        .toConstantValue({ hello: 'hola' })
        .whenTagged('lang', 'es');
      container
        .bind<Intl>('Intl')
        .toConstantValue({ goodbye: 'adios' })
        .whenTagged('lang', 'es');

      const fr: Intl[] = container.getAll<Intl>('Intl', {
        tag: { key: 'lang', value: 'fr' },
      });

      expect(fr.length).to.equal(2);
      expect(fr[0]?.hello).to.equal('bonjour');
      expect(fr[1]?.goodbye).to.equal('au revoir');

      const es: Intl[] = container.getAll<Intl>('Intl', {
        tag: { key: 'lang', value: 'es' },
      });

      expect(es.length).to.equal(2);
      expect(es[0]?.hello).to.equal('hola');
      expect(es[1]?.goodbye).to.equal('adios');
    });

    _it('Should_be_able_to_resolve_optional_injection', async () => {
      const container: Container = new Container();

      const serviceIdentifier: string = 'service-id';

      expect(container.get(serviceIdentifier, { optional: true })).to.eq(
        undefined,
      );
      expect(
        await container.getAsync(serviceIdentifier, {
          optional: true,
        }),
      ).to.eq(undefined);
      expect(
        container.get(serviceIdentifier, {
          name: 'name',
          optional: true,
        }),
      ).to.eq(undefined);
      expect(
        await container.getAsync(serviceIdentifier, {
          name: 'name',
          optional: true,
        }),
      ).to.eq(undefined);
      expect(
        container.get(serviceIdentifier, {
          optional: true,
          tag: { key: 'tag', value: 'value' },
        }),
      ).to.eq(undefined);
      expect(
        await container.getAsync(serviceIdentifier, {
          optional: true,
          tag: { key: 'tag', value: 'value' },
        }),
      ).to.eq(undefined);
    });

    _it('Should_be_able_configure_the_default_scope_at_a_global_level', () => {
      interface Warrior {
        health: number;
        takeHit(damage: number): void;
      }

      interface TypeType {
        Warrior: string;
      }

      @injectable()
      class Ninja implements Warrior {
        public health: number;
        constructor() {
          this.health = 100;
        }
        public takeHit(damage: number) {
          this.health = this.health - damage;
        }
      }

      const TYPES : TypeType= {
        Warrior: 'Warrior',
      };

      const container1: Container = new Container();
      container1.bind<Warrior>(TYPES.Warrior).to(Ninja);

      const transientNinja1: Warrior = container1.get<Warrior>(TYPES.Warrior);

      expect(transientNinja1.health).to.equal(100);

      transientNinja1.takeHit(10);

      expect(transientNinja1.health).to.equal(90);

      const transientNinja2: Warrior = container1.get<Warrior>(TYPES.Warrior);

      expect(transientNinja2.health).to.equal(100);

      transientNinja2.takeHit(10);

      expect(transientNinja2.health).to.equal(90);

      const container2: Container = new Container({
        defaultScope: bindingScopeValues.Singleton,
      });
      container2.bind<Warrior>(TYPES.Warrior).to(Ninja);

      const singletonNinja1: Warrior = container2.get<Warrior>(TYPES.Warrior);

      expect(singletonNinja1.health).to.equal(100);

      singletonNinja1.takeHit(10);

      expect(singletonNinja1.health).to.equal(90);

      const singletonNinja2: Warrior = container2.get<Warrior>(TYPES.Warrior);

      expect(singletonNinja2.health).to.equal(90);

      singletonNinja2.takeHit(10);

      expect(singletonNinja2.health).to.equal(80);
    });

    _it('Should_be_able_to_override_options_to_child_containers', () => {
      @injectable()
      class Warrior {}

      const parent: Container = new Container({
        defaultScope: bindingScopeValues.Request,
      });

      const child: Container = new Container({
        defaultScope: 'Singleton',
        parent,
      });

      child.bind(Warrior).toSelf();

      const singletonWarrior1: Warrior = child.get(Warrior);
      const singletonWarrior2: Warrior = child.get(Warrior);
      expect(singletonWarrior1).to.equal(singletonWarrior2);
    });

    _it('Should_be_able_check_if_a_named_binding_is_bound', async () => {
      const zero: string = 'Zero';
      const invalidDivisor: string = 'InvalidDivisor';
      const validDivisor: string = 'ValidDivisor';
      const container: Container = new Container();

      expect(container.isBound(zero)).to.equal(false);
      container.bind<number>(zero).toConstantValue(0);
      expect(container.isBound(zero)).to.equal(true);

      await container.unbindAll();

      expect(container.isBound(zero)).to.equal(false);

      container.bind<number>(zero).toConstantValue(0).whenNamed(invalidDivisor);

      expect(container.isBound(zero, { name: invalidDivisor })).to.equal(true);
      expect(container.isBound(zero, { name: validDivisor })).to.equal(false);

      container.bind<number>(zero).toConstantValue(1).whenNamed(validDivisor);
      expect(container.isBound(zero, { name: invalidDivisor })).to.equal(true);
      expect(container.isBound(zero, { name: validDivisor })).to.equal(true);
    });

    _it('Should_be_able_to_check_if_a_named_binding_is_bound_from_parent_container', () => {
      const zero: string = 'Zero';
      const invalidDivisor: string = 'InvalidDivisor';
      const validDivisor: string = 'ValidDivisor';
      const container: Container = new Container();
      const childContainer: Container = new Container({ parent: container });
      const secondChildContainer: Container = new Container({
        parent: childContainer,
      });

      container.bind<number>(zero).toConstantValue(0).whenNamed(invalidDivisor);

      expect(
        secondChildContainer.isBound(zero, { name: invalidDivisor }),
      ).to.equal(true);
      expect(secondChildContainer.isBound(zero, { name: validDivisor })).to.equal(
        false,
      );

      container.bind<number>(zero).toConstantValue(1).whenNamed(validDivisor);

      expect(
        secondChildContainer.isBound(zero, { name: invalidDivisor }),
      ).to.equal(true);
      expect(secondChildContainer.isBound(zero, { name: validDivisor })).to.equal(
        true,
      );
    });

    _it('Should_be_able_to_get_a_tagged_binding', () => {
      const zero: string = 'Zero';
      const isValidDivisor: string = 'IsValidDivisor';
      const container: Container = new Container();

      container
        .bind<number>(zero)
        .toConstantValue(0)
        .whenTagged(isValidDivisor, false);

      expect(
        container.get(zero, {
          tag: { key: isValidDivisor, value: false },
        }),
      ).to.equal(0);

      container
        .bind<number>(zero)
        .toConstantValue(1)
        .whenTagged(isValidDivisor, true);
      expect(
        container.get(zero, {
          tag: { key: isValidDivisor, value: false },
        }),
      ).to.equal(0);
      expect(
        container.get(zero, {
          tag: { key: isValidDivisor, value: true },
        }),
      ).to.equal(1);
    });

    _it('Should_be_able_to_get_a_tagged_binding_from_parent_container', () => {
      const zero: string = 'Zero';
      const isValidDivisor: string = 'IsValidDivisor';
      const container: Container = new Container();
      const childContainer: Container = new Container({ parent: container });
      const secondChildContainer: Container = new Container({
        parent: childContainer,
      });

      container
        .bind<number>(zero)
        .toConstantValue(0)
        .whenTagged(isValidDivisor, false);
      container
        .bind<number>(zero)
        .toConstantValue(1)
        .whenTagged(isValidDivisor, true);
      expect(
        secondChildContainer.get(zero, {
          tag: { key: isValidDivisor, value: false },
        }),
      ).to.equal(0);
      expect(
        secondChildContainer.get(zero, {
          tag: { key: isValidDivisor, value: true },
        }),
      ).to.equal(1);
    });

    _it('Should_be_able_check_if_a_tagged_binding_is_bound', async () => {
      const zero: string = 'Zero';
      const isValidDivisor: string = 'IsValidDivisor';
      const container: Container = new Container();

      expect(container.isBound(zero)).to.equal(false);
      container.bind<number>(zero).toConstantValue(0);
      expect(container.isBound(zero)).to.equal(true);

      await container.unbindAll();
      expect(container.isBound(zero)).to.equal(false);
      container
        .bind<number>(zero)
        .toConstantValue(0)
        .whenTagged(isValidDivisor, false);
      expect(
        container.isBound(zero, {
          tag: { key: isValidDivisor, value: false },
        }),
      ).to.equal(true);
      expect(
        container.isBound(zero, {
          tag: { key: isValidDivisor, value: true },
        }),
      ).to.equal(false);

      container
        .bind<number>(zero)
        .toConstantValue(1)
        .whenTagged(isValidDivisor, true);
      expect(
        container.isBound(zero, {
          tag: { key: isValidDivisor, value: false },
        }),
      ).to.equal(true);
      expect(
        container.isBound(zero, {
          tag: { key: isValidDivisor, value: true },
        }),
      ).to.equal(true);
    });

    _it('Should_be_able_to_check_if_a_tagged_binding_is_bound_from_parent_container', () => {
      const zero: string = 'Zero';
      const isValidDivisor: string = 'IsValidDivisor';
      const container: Container = new Container();
      const childContainer: Container = new Container({ parent: container });
      const secondChildContainer: Container = new Container({
        parent: childContainer,
      });

      container
        .bind<number>(zero)
        .toConstantValue(0)
        .whenTagged(isValidDivisor, false);
      expect(
        secondChildContainer.isBound(zero, {
          tag: { key: isValidDivisor, value: false },
        }),
      ).to.equal(true);
      expect(
        secondChildContainer.isBound(zero, {
          tag: { key: isValidDivisor, value: true },
        }),
      ).to.equal(false);

      container
        .bind<number>(zero)
        .toConstantValue(1)
        .whenTagged(isValidDivisor, true);
      expect(
        secondChildContainer.isBound(zero, {
          tag: { key: isValidDivisor, value: false },
        }),
      ).to.equal(true);
      expect(
        secondChildContainer.isBound(zero, {
          tag: { key: isValidDivisor, value: true },
        }),
      ).to.equal(true);
    });

    _it('Should_be_able_to_override_a_binding_using_rebind', async () => {
      interface TypeType {
        someType :string
      }
      const TYPES :TypeType = {
        someType: 'someType',
      };

      const container: Container = new Container();
      container.bind<number>(TYPES.someType).toConstantValue(1);

      container.bind<number>(TYPES.someType).toConstantValue(2);

      const values1: number[] = container.getAll(TYPES.someType);
      expect(values1[0]).to.eq(1);

      expect(values1[1]).to.eq(2);

      await container.unbind(TYPES.someType);

      container.bind<number>(TYPES.someType).toConstantValue(3);
      const values2: number[] = container.getAll(TYPES.someType);

      expect(values2[0]).to.eq(3);
      expect(values2[1]).to.eq(undefined);
    });

    _it('Should_be_able_to_override_a_binding_using_rebindAsync', async () => {
      interface TypeType {
        someType :string
      }
      const TYPES :TypeType = {
        someType: 'someType',
      };

      const container: Container = new Container();
      container.bind<number>(TYPES.someType).toConstantValue(1);

      container.bind<number>(TYPES.someType).toConstantValue(2);

      const values1: number[] = (await container.getAllAsync(TYPES.someType)) as number[];
      expect(values1[0]).to.eq(1);

      expect(values1[1]).to.eq(2);

      await container.unbind(TYPES.someType);

      container.bind<number>(TYPES.someType).toConstantValue(3);
      const values2: number[] = (await container.getAllAsync(TYPES.someType)) as number[];

      expect(values2[0]).to.eq(3);
      expect(values2[1]).to.eq(undefined);

    });

    _it('Should_be_able_to_resolve_named_multi-injection_(async)', async () => {
      interface Intl {
        hello?: string;
        goodbye?: string;
      }

      const container: Container = new Container();
      container
        .bind<Intl>('Intl')
        .toDynamicValue(async () => Promise.resolve({ hello: 'bonjour' } as Intl))
        .whenNamed('fr');
      container
        .bind<Intl>('Intl')
        .toDynamicValue(async () => Promise.resolve({ goodbye: 'au revoir' } as Intl))
        .whenNamed('fr');
      container
        .bind<Intl>('Intl')
        .toDynamicValue(async () => Promise.resolve({ hello: 'hola' } as Intl))
        .whenNamed('es');
      container
        .bind<Intl>('Intl')
        .toDynamicValue(async () => Promise.resolve({ goodbye: 'adios' } as Intl))
        .whenNamed('es');

      const fr: Intl[] = await container.getAllAsync<Intl>('Intl', {
        name: 'fr',
      });

      expect(fr.length).to.equal(2);
      expect(fr[0]?.hello).to.equal('bonjour');
      expect(fr[1]?.goodbye).to.equal('au revoir');

      const es: Intl[] = await container.getAllAsync<Intl>('Intl', {
        name: 'es',
      });

      expect(es.length).to.equal(2);
      expect(es[0]?.hello).to.equal('hola');
      expect(es[1]?.goodbye).to.equal('adios');
    });

    _it('Should_be_able_to_resolve_named_async', async () => {
      interface Intl {
        hello?: string;
        goodbye?: string;
      }

      const container: Container = new Container();
      container
        .bind<Intl>('Intl')
        .toDynamicValue(async () => Promise.resolve({ hello: 'bonjour' } as Intl))
        .whenNamed('fr');
      container
        .bind<Intl>('Intl')
        .toDynamicValue(async () => Promise.resolve({ hello: 'hola' } as Intl))
        .whenNamed('es');

      const fr: Intl = await container.getAsync<Intl>('Intl', { name: 'fr' });
      expect(fr.hello).to.equal('bonjour');

      const es: Intl = await container.getAsync<Intl>('Intl', { name: 'es' });
      expect(es.hello).to.equal('hola');
    });

    _it('Should_be_able_to_resolve_tagged_multi_injectionasync', async () => {
      interface Intl {
        hello?: string;
        goodbye?: string;
      }

      const container: Container = new Container();
      container
        .bind<Intl>('Intl')
        .toDynamicValue(async () => Promise.resolve({ hello: 'bonjour' } as Intl))
        .whenTagged('lang', 'fr');
      container
        .bind<Intl>('Intl')
        .toDynamicValue(async () => Promise.resolve({ goodbye: 'au revoir' } as Intl))
        .whenTagged('lang', 'fr');
      container
        .bind<Intl>('Intl')
        .toDynamicValue(async () => Promise.resolve({ hello: 'hola' } as Intl))
        .whenTagged('lang', 'es');
      container
        .bind<Intl>('Intl')
        .toDynamicValue(async () => Promise.resolve({ goodbye: 'adios' } as Intl))
        .whenTagged('lang', 'es');

      const fr: Intl[] = await container.getAllAsync<Intl>('Intl', {
        tag: { key: 'lang', value: 'fr' },
      });

      expect(fr.length).to.equal(2);
      expect(fr[0]?.hello).to.equal('bonjour');
      expect(fr[1]?.goodbye).to.equal('au revoir');

      const es: Intl[] = await container.getAllAsync<Intl>('Intl', {
        tag: { key: 'lang', value: 'es' },
      });

      expect(es.length).to.equal(2);
      expect(es[0]?.hello).to.equal('hola');
      expect(es[1]?.goodbye).to.equal('adios');

    });

    _it('Should_be_able_to_get_a_tagged_binding_async', async () => {
      const zero: string = 'Zero';
      const isValidDivisor: string = 'IsValidDivisor';
      const container: Container = new Container();

      container
        .bind<number>(zero)
        .toDynamicValue(async () => Promise.resolve(0))
        .whenTagged(isValidDivisor, false);
      expect(
        await container.getAsync(zero, {
          tag: { key: isValidDivisor, value: false },
        }),
      ).to.equal(0);

      container
        .bind<number>(zero)
        .toDynamicValue(async () => Promise.resolve(1))
        .whenTagged(isValidDivisor, true);
      expect(
        await container.getAsync(zero, {
          tag: { key: isValidDivisor, value: false },
        }),
      ).to.equal(0);
      expect(
        await container.getAsync(zero, {
          tag: { key: isValidDivisor, value: true },
        }),
      ).to.equal(1);
    });

    _it('should_be_able_to_get_all_the_services_binded_async', async () => {
      const serviceIdentifier: string = 'service-identifier';

      const container: Container = new Container();

      const firstValueBinded: string = 'value-one';
      const secondValueBinded: string = 'value-two';
      const thirdValueBinded: string = 'value-three';

      container.bind(serviceIdentifier).toConstantValue(firstValueBinded);
      container.bind(serviceIdentifier).toConstantValue(secondValueBinded);
      container
        .bind(serviceIdentifier)
        .toDynamicValue(async (_: ResolutionContext) =>
        Promise.resolve(thirdValueBinded),
        );
      const services: string[] =
        await container.getAllAsync<string>(serviceIdentifier);

      expect(services[0]).to.equal(firstValueBinded);
      expect(services[1]).to.equal(secondValueBinded);
      expect(services[2]).to.equal(thirdValueBinded);
    });
    _it('Should_be_able_to_inject_when_symbol_property_key', () => {
      const weaponProperty = "weapon";
      interface Weapon {
        use(): void;
      }
      @injectable()
      class Shuriken {}
      @injectable()
      class Ninja {
        @inject('Weapon')
        public weapon!: Weapon;
      }
      const container: Container = new Container();
      container.bind('Weapon').to(Shuriken);
      container.bind(Ninja).toSelf();

      const myNinja: Ninja = container.get(Ninja);

      expect(myNinja.weapon).to.be.instanceOf(Shuriken);
    });

  })
}