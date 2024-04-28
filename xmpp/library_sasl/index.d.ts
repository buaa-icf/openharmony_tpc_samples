/**
 * Copyright (C) 2024 Huawei Device Co., Ltd.
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
import { Entity } from "@xmpp/middleware";
import streamFeatures from "@xmpp/stream-features";
import SASLFactory from "saslmechanisms";

export = sasl;

// eslint-disable-next-line @definitelytyped/no-unnecessary-generics
declare function sasl<TEntity extends Entity>(
  {
    streamFeatures,
  }: {
    streamFeatures: streamFeatures.StreamFeatures<TEntity>;
  },
  credentials: sasl.Credentials,
): sasl.SASL;

declare namespace sasl {
  type Credentials = Partial<CredentialsObj> | CredentialsFactory;

  interface CredentialsObj {
    username: string;
    password: string;
  }

  type CredentialsFactory = (
    callback: (credentials: CredentialsObj) => Promise<void>,
    mechanism: string,
  ) => Promise<void>;

  interface SASL {
    use(name: string, mechanism: SASLFactory.MechanismStatic): SASLFactory;
    use(mechanism: SASLFactory.MechanismStatic): SASLFactory;
  }
}
