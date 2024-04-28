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
import { Element } from "@xmpp/xml";

export = XMPPError;

declare class XMPPError<TName extends string = "XMPPError"> extends Error {
  readonly name: TName;
  readonly condition: string;
  readonly text: string | undefined;
  readonly application: Element | undefined;
  element?: Element | undefined;

  constructor(condition: string, text?: string, application?: Element);

  static fromElement(element: Element): XMPPError;
}
