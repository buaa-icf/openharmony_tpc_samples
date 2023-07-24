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
import { Binding } from 'inversify/lib/bindings/binding';
import { BindingScopeEnum, TargetTypeEnum } from 'inversify';
import { Container } from 'inversify';
import { interfaces } from 'inversify';
import { Context } from 'inversify/lib/planning/context';
import { Metadata } from 'inversify/es/planning/metadata';
import { Request } from 'inversify/lib/planning/request';
import { Target } from 'inversify/es/planning/target';
import { BindingWhenSyntax } from 'inversify/lib/syntax/binding_when_syntax';
import { typeConstraint } from 'inversify/lib/syntax/constraint_helpers';
export default function binding_when_syntaxTest() {
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

  const context = new Context(new Container());

  // Samurai
  const samuraiMasterBinding = new Binding<Samurai>('Samurai', BindingScopeEnum.Transient);
  samuraiMasterBinding.implementationType = SamuraiMaster;

  const samuraiStudentBinding = new Binding<Samurai>('Samurai', BindingScopeEnum.Transient);
  samuraiStudentBinding.implementationType = SamuraiStudent;

  const samuraiTarget = new Target(TargetTypeEnum.ConstructorArgument, '', 'Samurai', new Metadata('sneaky', false));
  const samuraiMasterRequest = new Request('Samurai', context, null, samuraiMasterBinding, samuraiTarget);
  const samuraiStudentRequest = new Request('Samurai', context, null, samuraiStudentBinding, samuraiTarget);

  // Ninja
  const ninjaMasterBinding = new Binding<Ninja>('Ninja', BindingScopeEnum.Transient);
  ninjaMasterBinding.implementationType = NinjaMaster;

  const ninjaStudentBinding = new Binding<Ninja>('Ninja', BindingScopeEnum.Transient);
  ninjaStudentBinding.implementationType = NinjaStudent;

  const ninjaTarget = new Target(TargetTypeEnum.ConstructorArgument, '', 'Ninja', new Metadata('sneaky', true));
  const ninjaMasterRequest = new Request('Ninja', context, null, ninjaMasterBinding, ninjaTarget);
  const ninjaStudentRequest = new Request('Ninja', context, null, ninjaStudentBinding, ninjaTarget);

  // Katana
  const katanaBinding = new Binding<Weapon>('Weapon', BindingScopeEnum.Transient);
  katanaBinding.implementationType = Katana;
  const katanaBindingWhenSyntax = new BindingWhenSyntax<Weapon>(katanaBinding);
  const katanaTarget = new Target(TargetTypeEnum.ConstructorArgument, 'katana', 'Weapon');
  const ironKatanaRequest = new Request('Weapon', context, samuraiMasterRequest, katanaBinding, katanaTarget);
  const woodKatanaRequest = new Request('Weapon', context, samuraiStudentRequest, katanaBinding, katanaTarget);

  // Shuriken
  const shurikenBinding = new Binding<Weapon>('Weapon', BindingScopeEnum.Transient);
  shurikenBinding.implementationType = Shuriken;
  const shurikenBindingWhenSyntax = new BindingWhenSyntax<Weapon>(shurikenBinding);
  const shurikenTarget = new Target(TargetTypeEnum.ConstructorArgument, 'shuriken', 'Weapon');
  const ironShurikenRequest = new Request('Weapon', context, ninjaMasterRequest, shurikenBinding, shurikenTarget);
  const woodShurikenRequest = new Request('Weapon', context, ninjaStudentRequest, shurikenBinding, shurikenTarget);
  describe('binding_when_syntaxTest', function () {
    _it('Should_set_its_own_properties_correctly', () => {

      interface Ninja { }
      const ninjaIdentifier = 'Ninja';

      const binding = new Binding<Ninja>(ninjaIdentifier, BindingScopeEnum.Transient);
      const bindingWhenSyntax = new BindingWhenSyntax<Ninja>(binding);
      const _bindingWhenSyntax = bindingWhenSyntax as unknown as { _binding: Binding<unknown> };

      expect(_bindingWhenSyntax._binding.serviceIdentifier).eql(ninjaIdentifier);

    });

    _it('Should_be_able_to_configure_custom_constraint_of_a_binding', () => {

      interface Ninja { }
      const ninjaIdentifier = 'Ninja';

      const binding = new Binding<Ninja>(ninjaIdentifier, BindingScopeEnum.Transient);
      const bindingWhenSyntax = new BindingWhenSyntax<Ninja>(binding);

      bindingWhenSyntax.when((theRequest: interfaces.Request) =>
      theRequest.target.name.equals('ninja'));

      const target = new Target(TargetTypeEnum.ConstructorArgument, 'ninja', ninjaIdentifier);
      const context = new Context(new Container());
      const request = new Request(ninjaIdentifier, context, null, binding, target);
      expect(binding.constraint(request)).eql(true);

    });

    _it('Should_have_false_constraint_binding_null_request_whenTargetIsDefault', () => {

      interface Weapon {
        name: string;
      }

      const shurikenBinding = new Binding<Weapon>('Weapon', BindingScopeEnum.Transient);
      const shurikenBindingWhenSyntax = new BindingWhenSyntax<Weapon>(shurikenBinding);

      shurikenBindingWhenSyntax.whenTargetIsDefault();
      expect(shurikenBinding.constraint(null)).eql(false);

    });

    _it('Should_be_able_to_constraint_a_binding_to_a_named_target', () => {

      interface Ninja { }
      const ninjaIdentifier = 'Ninja';

      const binding = new Binding<Ninja>(ninjaIdentifier, BindingScopeEnum.Transient);
      const bindingWhenSyntax = new BindingWhenSyntax<Ninja>(binding);

      const named = 'primary';

      bindingWhenSyntax.whenTargetNamed(named);
      expect(binding.constraint).not.to.eql(null);

      const context = new Context(new Container());

      const target = new Target(TargetTypeEnum.ConstructorArgument, 'ninja', ninjaIdentifier, named);
      const request = new Request(ninjaIdentifier, context, null, binding, target);
      expect(binding.constraint(request)).eql(true);

      const target2 = new Target(TargetTypeEnum.ConstructorArgument, 'ninja', ninjaIdentifier);
      const request2 = new Request(ninjaIdentifier, context, null, binding, target2);
      expect(binding.constraint(request2)).eql(false);

    });

    _it('Should_be_able_to_constraint_a_binding_to_a_tagged_target', () => {

      interface Ninja { }
      const ninjaIdentifier = 'Ninja';

      const binding = new Binding<Ninja>(ninjaIdentifier, BindingScopeEnum.Transient);
      const bindingWhenSyntax = new BindingWhenSyntax<Ninja>(binding);

      bindingWhenSyntax.whenTargetTagged('canSwim', true);
      expect(binding.constraint).not.to.eql(null);

      const context = new Context(new Container());

      const target = new Target(TargetTypeEnum.ConstructorArgument, 'ninja', ninjaIdentifier, new Metadata('canSwim', true));
      const request = new Request(ninjaIdentifier, context, null, binding, target);
      expect(binding.constraint(request)).eql(true);

      const target2 = new Target(TargetTypeEnum.ConstructorArgument, 'ninja', ninjaIdentifier, new Metadata('canSwim', false));
      const request2 = new Request(ninjaIdentifier, context, null, binding, target2);
      expect(binding.constraint(request2)).eql(false);

    });

    _it('Should_be_able_to_constraint_a_binding_to_its_parent', () => {

      interface Weapon {
        name: string;
      }

      interface JaponeseWarrior {
        katana: Weapon;
      }

      interface ChineseWarrior {
        shuriken: Weapon;
      }

      class Ninja implements ChineseWarrior {
        public shuriken: Weapon;
        public constructor(shuriken: Weapon) {
          this.shuriken = shuriken;
        }
      }

      class Samurai implements JaponeseWarrior {
        public katana: Weapon;
        public constructor(katana: Weapon) {
          this.katana = katana;
        }
      }

      const context = new Context(new Container());

      const samuraiBinding = new Binding<Samurai>('Samurai', BindingScopeEnum.Transient);
      samuraiBinding.implementationType = Samurai;
      const samuraiTarget = new Target(TargetTypeEnum.Variable, '', 'Samurai');
      const samuraiRequest = new Request('Samurai', context, null, samuraiBinding, samuraiTarget);

      const ninjaBinding = new Binding<Ninja>('Ninja', BindingScopeEnum.Transient);
      ninjaBinding.implementationType = Ninja;
      const ninjaTarget = new Target(TargetTypeEnum.Variable, '', 'Ninja');
      const ninjaRequest = new Request('Ninja', context, null, ninjaBinding, ninjaTarget);

      const katanaBinding = new Binding<Weapon>('Weapon', BindingScopeEnum.Transient);
      const katanaBindingWhenSyntax = new BindingWhenSyntax<Weapon>(katanaBinding);
      const katanaTarget = new Target(TargetTypeEnum.ConstructorArgument, 'katana', 'Weapon');
      const katanaRequest = new Request('Weapon', context, samuraiRequest, katanaBinding, katanaTarget);

      const shurikenBinding = new Binding<Weapon>('Weapon', BindingScopeEnum.Transient);
      const shurikenBindingWhenSyntax = new BindingWhenSyntax<Weapon>(shurikenBinding);
      const shurikenTarget = new Target(TargetTypeEnum.ConstructorArgument, 'shuriken', 'Weapon');
      const shurikenRequest = new Request('Weapon', context, ninjaRequest, shurikenBinding, shurikenTarget);

      katanaBindingWhenSyntax.whenInjectedInto(Samurai);
      expect(katanaBinding.constraint(katanaRequest)).eql(true);
      expect(katanaBinding.constraint(shurikenRequest)).eql(false);

      katanaBindingWhenSyntax.whenInjectedInto(Ninja);
      expect(katanaBinding.constraint(katanaRequest)).eql(false);
      expect(katanaBinding.constraint(shurikenRequest)).eql(true);

      shurikenBindingWhenSyntax.whenInjectedInto(Samurai);
      expect(shurikenBinding.constraint(katanaRequest)).eql(true);
      expect(shurikenBinding.constraint(shurikenRequest)).eql(false);

      shurikenBindingWhenSyntax.whenInjectedInto(Ninja);
      expect(shurikenBinding.constraint(katanaRequest)).eql(false);
      expect(shurikenBinding.constraint(shurikenRequest)).eql(true);

      katanaBindingWhenSyntax.whenInjectedInto('Samurai');
      expect(katanaBinding.constraint(katanaRequest)).eql(true);
      expect(katanaBinding.constraint(shurikenRequest)).eql(false);

      katanaBindingWhenSyntax.whenInjectedInto('Ninja');
      expect(katanaBinding.constraint(katanaRequest)).eql(false);
      expect(katanaBinding.constraint(shurikenRequest)).eql(true);

      shurikenBindingWhenSyntax.whenInjectedInto('Samurai');
      expect(shurikenBinding.constraint(katanaRequest)).eql(true);
      expect(shurikenBinding.constraint(shurikenRequest)).eql(false);

      shurikenBindingWhenSyntax.whenInjectedInto('Ninja');
      expect(shurikenBinding.constraint(katanaRequest)).eql(false);
      expect(shurikenBinding.constraint(shurikenRequest)).eql(true);

    });

    _it('Should_be_able_to_constraint_a_binding_to_a_named_parent', () => {

      interface Weapon {
        name: string;
      }

      interface JaponeseWarrior {
        katana: Weapon;
      }

      interface ChineseWarrior {
        shuriken: Weapon;
      }

      class Ninja implements ChineseWarrior {
        public shuriken: Weapon;
        public constructor(shuriken: Weapon) {
          this.shuriken = shuriken;
        }
      }

      class Samurai implements JaponeseWarrior {
        public katana: Weapon;
        public constructor(katana: Weapon) {
          this.katana = katana;
        }
      }

      const samuraiBinding = new Binding<Samurai>('Samurai', BindingScopeEnum.Transient);
      samuraiBinding.implementationType = Samurai;

      const context = new Context(new Container());

      const samuraiTarget = new Target(TargetTypeEnum.ConstructorArgument, '', 'Samurai', 'japonese');
      const samuraiRequest = new Request('Samurai', context, null, samuraiBinding, samuraiTarget);
      const ninjaBinding = new Binding<Ninja>('Ninja', BindingScopeEnum.Transient);

      ninjaBinding.implementationType = Ninja;

      const ninjaTarget = new Target(TargetTypeEnum.ConstructorArgument, '', 'Ninja', 'chinese');
      const ninjaRequest = new Request('Ninja', context, null, ninjaBinding, ninjaTarget);

      const katanaBinding = new Binding<Weapon>('Weapon', BindingScopeEnum.Transient);
      const katanaBindingWhenSyntax = new BindingWhenSyntax<Weapon>(katanaBinding);
      const katanaTarget = new Target(TargetTypeEnum.ConstructorArgument, 'katana', 'Weapon');
      const katanaRequest = new Request('Weapon', context, samuraiRequest, katanaBinding, katanaTarget);

      const shurikenBinding = new Binding<Weapon>('Weapon', BindingScopeEnum.Transient);
      const shurikenBindingWhenSyntax = new BindingWhenSyntax<Weapon>(shurikenBinding);
      const shurikenTarget = new Target(TargetTypeEnum.ConstructorArgument, 'shuriken', 'Weapon');
      const shurikenRequest = new Request('Weapon', context, ninjaRequest, shurikenBinding, shurikenTarget);

      katanaBindingWhenSyntax.whenParentNamed('chinese');
      shurikenBindingWhenSyntax.whenParentNamed('chinese');
      expect(katanaBinding.constraint(katanaRequest)).eql(false);
      expect(shurikenBinding.constraint(shurikenRequest)).eql(true);

      katanaBindingWhenSyntax.whenParentNamed('japonese');
      shurikenBindingWhenSyntax.whenParentNamed('japonese');
      expect(katanaBinding.constraint(katanaRequest)).eql(true);
      expect(shurikenBinding.constraint(shurikenRequest)).eql(false);

    });

    _it('Should_be_able_to_constraint_a_binding_to_a_tagged_parent', () => {

      interface Weapon {
        name: string;
      }

      interface JaponeseWarrior {
        katana: Weapon;
      }

      interface ChineseWarrior {
        shuriken: Weapon;
      }

      class Ninja implements ChineseWarrior {
        public shuriken: Weapon;
        public constructor(shuriken: Weapon) {
          this.shuriken = shuriken;
        }
      }

      class Samurai implements JaponeseWarrior {
        public katana: Weapon;
        public constructor(katana: Weapon) {
          this.katana = katana;
        }
      }

      const context = new Context(new Container());

      const samuraiBinding = new Binding<Samurai>('Samurai', BindingScopeEnum.Transient);
      samuraiBinding.implementationType = Samurai;

      const samuraiTarget = new Target(TargetTypeEnum.ConstructorArgument, '', 'Samurai', new Metadata('sneaky', false));
      const samuraiRequest = new Request('Samurai', context, null, samuraiBinding, samuraiTarget);

      const ninjaBinding = new Binding<Ninja>('Ninja', BindingScopeEnum.Transient);
      ninjaBinding.implementationType = Ninja;
      const ninjaTarget = new Target(TargetTypeEnum.ConstructorArgument, '', 'Ninja', new Metadata('sneaky', true));
      const ninjaRequest = new Request('Ninja', context, null, ninjaBinding, ninjaTarget);

      const katanaBinding = new Binding<Weapon>('Weapon', BindingScopeEnum.Transient);
      const katanaBindingWhenSyntax = new BindingWhenSyntax<Weapon>(katanaBinding);
      const katanaTarget = new Target(TargetTypeEnum.ConstructorArgument, 'katana', 'Weapon');
      const katanaRequest = new Request('Weapon', context, samuraiRequest, katanaBinding, katanaTarget);

      const shurikenBinding = new Binding<Weapon>('Weapon', BindingScopeEnum.Transient);
      const shurikenBindingWhenSyntax = new BindingWhenSyntax<Weapon>(shurikenBinding);
      const shurikenTarget = new Target(TargetTypeEnum.ConstructorArgument, 'shuriken', 'Weapon');
      const shurikenRequest = new Request('Weapon', context, ninjaRequest, shurikenBinding, shurikenTarget);

      katanaBindingWhenSyntax.whenParentTagged('sneaky', true);
      shurikenBindingWhenSyntax.whenParentTagged('sneaky', true);
      expect(katanaBinding.constraint(katanaRequest)).eql(false);
      expect(shurikenBinding.constraint(shurikenRequest)).eql(true);

      katanaBindingWhenSyntax.whenParentTagged('sneaky', false);
      shurikenBindingWhenSyntax.whenParentTagged('sneaky', false);
      expect(katanaBinding.constraint(katanaRequest)).eql(true);
      expect(shurikenBinding.constraint(shurikenRequest)).eql(false);

    });



    _it('Should_be_able_to_apply_a_type_constraint_to_some_of_its_ancestors', () => {

      shurikenBindingWhenSyntax.whenAnyAncestorIs(NinjaMaster);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(false);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(true);

      shurikenBindingWhenSyntax.whenAnyAncestorIs(NinjaStudent);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(true);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(false);

      katanaBindingWhenSyntax.whenAnyAncestorIs(SamuraiMaster);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(false);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(true);

      katanaBindingWhenSyntax.whenAnyAncestorIs(SamuraiStudent);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(true);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(false);

    });

    _it('Should_be_able_to_apply_a_type_constraint_to_none_of_its_ancestors', () => {

      shurikenBindingWhenSyntax.whenNoAncestorIs(NinjaMaster);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(true);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(false);

      shurikenBindingWhenSyntax.whenNoAncestorIs(NinjaStudent);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(false);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(true);

      katanaBindingWhenSyntax.whenNoAncestorIs(SamuraiMaster);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(true);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(false);

      katanaBindingWhenSyntax.whenNoAncestorIs(SamuraiStudent);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(false);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(true);

    });

    _it('Should_be_able_to_apply_a_named_constraint_to_some_of_its_ancestors', () => {

      shurikenBindingWhenSyntax.whenAnyAncestorNamed('chinese');
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(false);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(false);

      shurikenBindingWhenSyntax.whenAnyAncestorNamed('chinese');
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(false);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(false);

      katanaBindingWhenSyntax.whenAnyAncestorNamed('japonese');
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(false);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(false);

      katanaBindingWhenSyntax.whenAnyAncestorNamed('japonese');
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(false);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(false);

    });

    _it('Should_be_able_to_apply_a_named_constraint_to_none_of_its_ancestors', () => {

      shurikenBindingWhenSyntax.whenNoAncestorNamed('chinese');
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(true);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(true);

      shurikenBindingWhenSyntax.whenNoAncestorNamed('chinese');
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(true);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(true);

      katanaBindingWhenSyntax.whenNoAncestorNamed('japonese');
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(true);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(true);

      katanaBindingWhenSyntax.whenNoAncestorNamed('japonese');
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(true);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(true);

    });

    _it('Should_be_able_to_apply_a_tagged_constraint_to_some_of_its_ancestors', () => {

      shurikenBindingWhenSyntax.whenAnyAncestorTagged('sneaky', true);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(true);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(true);

      shurikenBindingWhenSyntax.whenAnyAncestorTagged('sneaky', false);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(false);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(false);

      katanaBindingWhenSyntax.whenAnyAncestorTagged('sneaky', true);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(false);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(false);

      katanaBindingWhenSyntax.whenAnyAncestorTagged('sneaky', false);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(true);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(true);

    });

    _it('Should_be_able_to_apply_a_tagged_constraint_to_none_of_its_ancestors', () => {

      shurikenBindingWhenSyntax.whenNoAncestorTagged('sneaky', true);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(false);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(false);

      shurikenBindingWhenSyntax.whenNoAncestorTagged('sneaky', false);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(true);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(true);

      katanaBindingWhenSyntax.whenNoAncestorTagged('sneaky', true);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(true);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(true);

      katanaBindingWhenSyntax.whenNoAncestorTagged('sneaky', false);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(false);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(false);

    });

    _it('Should_be_able_to_apply_a_custom_constraint_to_some_of_its_ancestors', () => {

      const anyAncestorIsNinjaMasterConstraint = typeConstraint(NinjaMaster);
      const anyAncestorIsNinjaStudentConstraint = typeConstraint(NinjaStudent);

      shurikenBindingWhenSyntax.whenAnyAncestorMatches(anyAncestorIsNinjaMasterConstraint);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(false);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(true);

      shurikenBindingWhenSyntax.whenAnyAncestorMatches(anyAncestorIsNinjaStudentConstraint);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(true);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(false);

      const anyAncestorIsSamuraiMasterConstraint = typeConstraint(SamuraiMaster);
      const anyAncestorIsSamuraiStudentConstraint = typeConstraint(SamuraiStudent);

      katanaBindingWhenSyntax.whenAnyAncestorMatches(anyAncestorIsSamuraiMasterConstraint);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(false);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(true);

      katanaBindingWhenSyntax.whenAnyAncestorMatches(anyAncestorIsSamuraiStudentConstraint);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(true);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(false);

    });

    _it('Should_be_able_to_apply_a_custom_constraint_to_none_of_its_ancestors', () => {

      const anyAncestorIsNinjaMasterConstraint = typeConstraint(NinjaMaster);
      const anyAncestorIsNinjaStudentConstraint = typeConstraint(NinjaStudent);

      shurikenBindingWhenSyntax.whenNoAncestorMatches(anyAncestorIsNinjaMasterConstraint);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(true);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(false);

      shurikenBindingWhenSyntax.whenNoAncestorMatches(anyAncestorIsNinjaStudentConstraint);
      expect(shurikenBinding.constraint(woodShurikenRequest)).eql(false);
      expect(shurikenBinding.constraint(ironShurikenRequest)).eql(true);

      const anyAncestorIsSamuraiMasterConstraint = typeConstraint(SamuraiMaster);
      const anyAncestorIsSamuraiStudentConstraint = typeConstraint(SamuraiStudent);

      katanaBindingWhenSyntax.whenNoAncestorMatches(anyAncestorIsSamuraiMasterConstraint);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(true);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(false);

      katanaBindingWhenSyntax.whenNoAncestorMatches(anyAncestorIsSamuraiStudentConstraint);
      expect(katanaBinding.constraint(woodKatanaRequest)).eql(false);
      expect(katanaBinding.constraint(ironKatanaRequest)).eql(true);
    });
  })
}