/*
Copyright (c) 2026 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/**
 * InputSource interface for XML parsing.
 * This interface represents an input source for XML parsing.
 */

/**
 * InputSource interface
 */
export default interface InputSource {
  getCharacterStream(): ESObject;
  getByteStream(): ESObject | null;
  getSystemId(): string | null;
  getPublicId(): string | null;
  setPublicId(publicId: string): void;
  setSystemId(systemId: string): void;
  setByteStream(byteStream: ESObject): void;
  setCharacterStream(charStream: ESObject): void;
}

