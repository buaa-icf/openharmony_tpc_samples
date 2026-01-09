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

import CountOutputStream from './src/main/ets/impl/CountOutputStream';

// Core interfaces and classes
export { default as XMPMeta } from './src/main/ets/XMPMeta';
export { default as XMPMetaFactory } from './src/main/ets/XMPMetaFactory';
export { default as XMPIterator } from './src/main/ets/XMPIterator';
export { default as XMPConst } from './src/main/ets/XMPConst';
export { default as XMPUtils } from './src/main/ets/XMPUtils';
export { default as XMPError } from './src/main/ets/XMPError';
export { default as XMPException } from './src/main/ets/XMPException';
export { default as XMPPathFactory } from './src/main/ets/XMPPathFactory';
export { default as XMPSchemaRegistry } from './src/main/ets/XMPSchemaRegistry';
export { default as XMPVersionInfo } from './src/main/ets/XMPVersionInfo';

// DateTime
export { default as XMPDateTime } from './src/main/ets/XMPDateTime';
export { default as XMPDateTimeFactory } from './src/main/ets/XMPDateTimeFactory';

// Options
export { default as ParseOptions } from './src/main/ets/options/ParseOptions';
export { default as IteratorOptions } from './src/main/ets/options/IteratorOptions';
export { default as PropertyOptions } from './src/main/ets/options/PropertyOptions';
export { default as SerializeOptions } from './src/main/ets/options/SerializeOptions';
export { default as AliasOptions } from './src/main/ets/options/AliasOptions';
export { default as Options } from './src/main/ets/options/Options';

// Properties
export { default as XMPProperty } from './src/main/ets/properties/XMPProperty';
export { default as XMPPropertyInfo } from './src/main/ets/properties/XMPPropertyInfo';
export { default as XMPAliasInfo } from './src/main/ets/properties/XMPAliasInfo';

// Implementation classes (for advanced usage)
export { default as XMPMetaImpl } from './src/main/ets/impl/XMPMetaImpl';
export { default as XMPDateTimeImpl } from './src/main/ets/impl/XMPDateTimeImpl';
export { default as XMPIteratorImpl } from './src/main/ets/impl/XMPIteratorImpl';
export { default as XMPPropertyImpl } from './src/main/ets/impl/XMPPropertyImpl';
export { default as XMPNode } from './src/main/ets/impl/XMPNode';
export { default as XMPNodeUtils } from './src/main/ets/impl/XMPNodeUtils';

export { default as ByteBuffer } from './src/main/ets/impl/ByteBuffer'
export { default as CountOutputStream } from './src/main/ets/impl/CountOutputStream'
export { default as Base64 } from './src/main/ets/impl/Base64'
export { default as ISO8601Converter } from './src/main/ets/impl/ISO8601Converter'
export { default as Latin1Converter } from './src/main/ets/impl/Latin1Converter'
export { default as XMPPathParser } from './src/main/ets/impl/xpath/XMPPathParser'
export { default as XMPPathSegment } from './src/main/ets/impl/xpath/XMPPathSegment'
export { default as XMPPath } from './src/main/ets/impl/xpath/XMPPath'

export {  FixASCIIControlsReader, CharReader, ReadResult } from './src/main/ets/impl/FixASCIIControlsReader'
export { default as VeraPDFMeta } from './src/main/ets/impl/VeraPDFMeta';
export { default as VeraPDFXMPNode } from './src/main/ets/impl/VeraPDFXMPNode';
export { default as XMPNodeIterator } from './src/main/ets/impl/XMPNodeIterator';