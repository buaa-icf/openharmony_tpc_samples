/**
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE
 */

import { Entity } from "@ohos/xmpp_middleware";
import streamFeatures from "@ohos/xmpp_stream_features";
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
    authzid: string;
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
