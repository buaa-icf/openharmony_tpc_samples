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
import * as ns from "reflect-metadata"
import { inject } from 'inversify';
import { injectable } from 'inversify';
import { postConstruct } from 'inversify';
import { Container } from 'inversify';
ns

export async  function postConstruct1(){

  let resolved = false;
  @injectable()
  class Constructable {
    @postConstruct()
    public myPostConstructMethod() {
      return new Promise<ESObject>((r) => {
        resolved = true;
        r({});
      });
    }
  }

  const container = new Container();
  container.bind<Constructable>('Constructable').to(Constructable);

  const result:ESObject = await container.getAsync('Constructable');
  let boo1=result instanceof Constructable
  return {
    boo1:boo1
  }
}


export async  function onActivation(){

  let resolved = false;

  @injectable()
  class Constructable {
  }

  const container = new Container();
  container.bind<Constructable>('Constructable').to(Constructable).inSingletonScope()
    .onActivation((context, c) => new Promise((r) => {
      resolved = true;
      r(c);
    }));

  const result:ESObject = await container.getAsync('Constructable');
  let boo1=result instanceof Constructable
  return {
    boo1:boo1
  }
}

export async  function instance(){

  @injectable()
  class Constructable {
  }
  let activated: Constructable | null = null
  const container = new Container();
  container.bind<Constructable>('Constructable').toDynamicValue(() => Promise.resolve(new Constructable()))
    .inSingletonScope()
    .onActivation((context, c) => new Promise((r) => {
      activated = c
      r(c);
    }));

  await container.getAsync('Constructable');
  let boo1=activated instanceof Constructable
  return {
    boo1:boo1
  }
}
