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
// import Parser from "../src/Parser";
//
// export = Parser;

import { EventEmitter } from "@ohos/node-polyfill";
import Element from "./Element";

export default class Parser extends EventEmitter {
  static DefaultParser: typeof Parser;
  static DefaultElement: typeof Element;

  constructor(options?: ParserOptions);

  write(data: string | { toString(): string }): void;
  end(data: string | { toString(): string }): void;
}

export interface ParserOptions {
  Parser?: typeof Parser | undefined;
  Element?: typeof Element | undefined;
}