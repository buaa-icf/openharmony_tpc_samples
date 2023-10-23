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
..import 'reflect-metadata';
import {
  instanceToInstance,
  classToClassFromExist,
  instanceToPlain,
  classToPlainFromExist,
  plainToInstance,
  plainToClassFromExist,
} from 'class_transformer';
import { defaultMetadataStorage } from 'class_transformer';
import { Exclude, Expose, Type, Transform } from 'class_transformer';
import { describe,it as _it,expect } from "../utils/utils";

export default function implicit_type_declarationsTest() {
  describe('implicit_type_declarationsTest', function () {
    _it('should run only when enabled', () => {
      defaultMetadataStorage.clear();

      class SimpleExample {
        @Expose()
        readonly implicitTypeNumber: number;

        @Expose()
        readonly implicitTypeString: string;
      }

      const result1: SimpleExample = plainToInstance(
        SimpleExample,
        {
          implicitTypeNumber: '100',
          implicitTypeString: 133123,
        },
        { enableImplicitConversion: true }
      );

      const result2: SimpleExample = plainToInstance(
        SimpleExample,
        {
          implicitTypeNumber: '100',
          implicitTypeString: 133123,
        },
        { enableImplicitConversion: false }
      );
      console.log(`bbbbb----${result1} ${JSON.stringify(result1)}`)
      console.log(`bbbbb----${result2} ${JSON.stringify(result2)}`)

      expect(result1).toEqual({ implicitTypeNumber: 100, implicitTypeString: '133123' });
      expect(result2).toEqual({ implicitTypeNumber: '100', implicitTypeString: 133123 });
    });

    _it("implicit and explicity type declarations" ,() => {
      class Example {
        @Expose()
        readonly implicitTypeViaOtherDecorator: Date;

        @Type()
        readonly implicitTypeViaEmptyTypeDecorator: number;

        @Type(() => String)
        readonly explicitType: string;
      }

      const result: Example = plainToInstance(
        Example,
        {
          implicitTypeViaOtherDecorator: '2018-12-24T12:00:00Z',
          implicitTypeViaEmptyTypeDecorator: '100',
          explicitType: 100,
        },
        { enableImplicitConversion: true }
      );

      _it('should use implicitly defined design:type to convert value when no @Type decorator is used', () => {
        expect(result.implicitTypeViaOtherDecorator).toBeInstanceOf(Date);
        expect(result.implicitTypeViaOtherDecorator.getTime()).toEqual(new Date('2018-12-24T12:00:00Z').getTime());
      });

      _it('should use implicitly defined design:type to convert value when empty @Type() decorator is used', () => {
        expect(typeof result.implicitTypeViaEmptyTypeDecorator).toBe('number');
        expect(result.implicitTypeViaEmptyTypeDecorator).toEqual(100);
      });

      _it('should use explicitly defined type when @Type(() => Construtable) decorator is used', () => {
        expect(typeof result.explicitType).toBe('string');
        expect(result.explicitType).toEqual('100');
      });
    });


    _it("plainToInstance transforms built-in primitive types properly",() => {
      class Example {
        @Type()
        date: Date;

        @Type()
        string: string;

        @Type()
        string2: string;

        @Type()
        number: number;

        @Type()
        number2: number;

        @Type()
        boolean: boolean;

        @Type()
        boolean2: boolean;
      }

      const result: Example = plainToInstance(
        Example,
        {
          date: '2018-12-24T12:00:00Z',
          string: '100',
          string2: 100,
          number: '100',
          number2: 100,
          boolean: 1,
          boolean2: 0,
        },
        { enableImplicitConversion: true }
      );

      _it('should recognize and convert to Date', () => {
        expect(result.date).toBeInstanceOf(Date);
        expect(result.date.getTime()).toEqual(new Date('2018-12-24T12:00:00Z').getTime());
      });

      _it('should recognize and convert to string', () => {
        expect(typeof result.string).toBe('string');
        expect(typeof result.string2).toBe('string');
        expect(result.string).toEqual('100');
        expect(result.string2).toEqual('100');
      });

      _it('should recognize and convert to number', () => {
        expect(typeof result.number).toBe('number');
        expect(typeof result.number2).toBe('number');
        expect(result.number).toEqual(100);
        expect(result.number2).toEqual(100);
      });


    })
  })
}