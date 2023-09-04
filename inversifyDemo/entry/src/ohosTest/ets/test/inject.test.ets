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
declare function __decorate(
    decorators: ClassDecorator[],
    target: NewableFunction,
    key?: string | symbol,
    descriptor?: PropertyDescriptor | undefined
): void;
declare function __param(paramIndex: number, decorator: ParameterDecorator): ClassDecorator;
import { describe, beforeAll, beforeEach, afterEach, afterAll, it as _it, expect } from '../utils/util'
import { decorate } from 'inversify';
import { inject } from 'inversify';
import { LazyServiceIdentifer, ServiceIdentifierOrFunc } from 'inversify/lib/annotation/lazy_service_identifier';
import * as ERROR_MSGS from 'inversify/lib/constants/error_msgs';
import * as METADATA_KEY from 'inversify/lib/constants/metadata_keys';
import { interfaces } from 'inversify';
import { multiInject } from 'inversify';
import  "reflect-metadata"

export default function injectTest() {
  interface Katana { }
  interface Shuriken { }
  interface Sword { }
  class Katana implements Katana { }
  class Shuriken implements Shuriken { }
  class Sword implements Sword { }

  const lazySwordId = new LazyServiceIdentifer(() => 'Sword');
  class DecoratedWarrior {

    private _primaryWeapon: Katana;
    private _secondaryWeapon: Shuriken;
    private _tertiaryWeapon: Sword;

    public constructor(
      @inject('Katana') primary: Katana,
      @inject('Shuriken') secondary: Shuriken,
      @inject(lazySwordId) tertiary: Shuriken
    ) {
      this._primaryWeapon = primary;
      this._secondaryWeapon = secondary;
      this._tertiaryWeapon = tertiary;
    }

    public debug() {
      return {
        primaryWeapon: this._primaryWeapon,
        secondaryWeapon: this._secondaryWeapon,
        tertiaryWeapon: this._tertiaryWeapon
      };
    }

  }

  class InvalidDecoratorUsageWarrior {

    private _primaryWeapon: Katana;
    private _secondaryWeapon: Shuriken;

    public constructor(
      primary: Katana,
      secondary: Shuriken
    ) {

      this._primaryWeapon = primary;
      this._secondaryWeapon = secondary;
    }

    public test(a: string) { /*...*/ }

    public debug() {
      return {
        primaryWeapon: this._primaryWeapon,
        secondaryWeapon: this._secondaryWeapon
      };
    }

  }
  describe('injectTest', function () {
    _it('Should_generate_metadata_for_named_parameters', () => {

    const metadataKey = METADATA_KEY.TAGGED;
    const paramsMetadata = Reflect.getMetadata(metadataKey, DecoratedWarrior);
    expect(paramsMetadata).to.be.an('object');

    // assert metadata for first argument
    expect(paramsMetadata['0']).to.be.instanceof(Array);
    const m1: interfaces.Metadata = paramsMetadata['0'][0];
    expect(m1.key).to.be.eql(METADATA_KEY.INJECT_TAG);
    expect(m1.value).to.be.eql('Katana');
    expect(paramsMetadata['0'][1]).to.eq(undefined);
    // assert metadata for second argument
    expect(paramsMetadata['1']).to.be.instanceof(Array);
    const m2: interfaces.Metadata = paramsMetadata['1'][0];
    expect(m2.key).to.be.eql(METADATA_KEY.INJECT_TAG);
    expect(m2.value).to.be.eql('Shuriken');
    expect(paramsMetadata['1'][1]).to.eq(undefined);

    // assert metadata for second argument
    expect(paramsMetadata['2']).to.be.instanceof(Array);
    const m3: interfaces.Metadata = paramsMetadata['2'][0];
    expect(m3.key).to.be.eql(METADATA_KEY.INJECT_TAG);
    expect(m3.value).to.be.eql(lazySwordId);
    expect(paramsMetadata['2'][1]).to.eq(undefined);
    // no more metadata should be available
    expect(paramsMetadata['3']).to.eq(undefined);

  });


  _it('Should_throw_when_applied_multiple_times', () => {

    const useDecoratorMoreThanOnce = function () {
      __decorate([__param(0, inject('Katana')), __param(0, inject('Shurien'))], InvalidDecoratorUsageWarrior);
    };

    const msg = `${ERROR_MSGS.DUPLICATED_METADATA} ${METADATA_KEY.INJECT_TAG}`;
    expect(useDecoratorMoreThanOnce).to.throw(msg);

  });

  _it('Should_throw_when_not_applied_to_a_constructor', () => {

    const useDecoratorOnMethodThatIsNotAConstructor = function () {
      __decorate([__param(0, inject('Katana'))],
        InvalidDecoratorUsageWarrior.prototype as unknown as NewableFunction,
        'test', Object.getOwnPropertyDescriptor(InvalidDecoratorUsageWarrior.prototype, 'test'));
    };

    const msg = `${ERROR_MSGS.INVALID_DECORATOR_OPERATION}`;
    expect(useDecoratorOnMethodThatIsNotAConstructor).to.throw(msg);

  });

  _it('Should_throw_when_applied_w_ith_undefined', () => {

    // this can happen when there is circular dependency between symbols
    const useDecoratorW_ithUndefined = function () {
      __decorate([__param(0, inject(undefined as unknown as ServiceIdentifierOrFunc<unknown>))], InvalidDecoratorUsageWarrior);
    };

    const msg = `${ERROR_MSGS.UNDEFINED_INJECT_ANNOTATION('InvalidDecoratorUsageWarrior')}`;
    expect(useDecoratorW_ithUndefined).to.throw(msg);

  });

  _it('Should_be_usable_in_VanillaJS_applications', () => {

    interface Shurien { }

    const VanillaJSWarrior = (function () {
      function Warrior(primary: Katana, secondary: Shurien) {
        // ...
      }
      return Warrior;
    })();

    decorate(inject('Katana'), VanillaJSWarrior, 0);
    decorate(inject('Shurien'), VanillaJSWarrior, 1);

    const metadataKey = METADATA_KEY.TAGGED;
    const paramsMetadata = Reflect.getMetadata(metadataKey, VanillaJSWarrior);
    expect(paramsMetadata).to.be.an('object');

    // assert metadata for first argument
    expect(paramsMetadata['0']).to.be.instanceof(Array);
    const m1: interfaces.Metadata = paramsMetadata['0'][0];
    expect(m1.key).to.be.eql(METADATA_KEY.INJECT_TAG);
    expect(m1.value).to.be.eql('Katana');
    expect(paramsMetadata['0'][1]).to.eq(undefined);

    // assert metadata for second argument
    expect(paramsMetadata['1']).to.be.instanceof(Array);
    const m2: interfaces.Metadata = paramsMetadata['1'][0];
    expect(m2.key).to.be.eql(METADATA_KEY.INJECT_TAG);
    expect(m2.value).to.be.eql('Shurien');
    expect(paramsMetadata['1'][1]).to.eq(undefined);

    // no more metadata should be available
    expect(paramsMetadata['2']).to.eq(undefined);

  });

  _it('should_throw_when_applied_inject_decorator_w_ith_undefined_service_identifier_to_a_property', () => {
    expect(() => {
      //@ts-ignore
      class W_ithUndefinedInject {
        @inject(undefined as unknown as ServiceIdentifierOrFunc<undefined>)
        property!: string
      }
    }).to.throw(`${ERROR_MSGS.UNDEFINED_INJECT_ANNOTATION('W_ithUndefinedInject')}`)
  });

  _it('should_throw_when_applied_multiInject_decorator_w_ith_undefined_service_identifier_to_a_constructor_parameter', () => {
    expect(() => {
      //@ts-ignore
      class W_ithUndefinedInject {
        constructor(
          @multiInject(undefined as unknown as ServiceIdentifierOrFunc<undefined>)
          readonly dependency: string[]
        ) { }
      }
    }).to.throw(`${ERROR_MSGS.UNDEFINED_INJECT_ANNOTATION('W_ithUndefinedInject')}`)
  });

  _it('Should_unwrap_LazyServiceIdentifer', () => {
    const unwrapped = lazySwordId.unwrap();
    expect(unwrapped).to.be.equal('Sword');
  });
  })
}