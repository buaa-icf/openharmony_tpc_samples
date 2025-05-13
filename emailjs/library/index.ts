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

import { addressparser, AddressObject } from './src/main/ets/address';
import { SMTPClient } from './src/main/ets/client';
import { SMTPConnection, SMTPState, AUTH_METHODS, DEFAULT_TIMEOUT } from './src/main/ets/connection';
import { getRFC2822Date, getRFC2822DateUTC, isRFC2822Date } from './src/main/ets/date';
import { SMTPErrorStates, SMTPError } from './src/main/ets/error';
import {
  Message,
  MIMECHUNK,
  BUFFERSIZE,
  MIME64CHUNK,
  MessageAttachmentHeaders,
  MessageAttachment,
  MessageHeaders
} from './src/main/ets//message';
import { mimeEncode, mimeWordEncode } from './src/main/ets/mime';
import { SMTPResponseMonitor } from './src/main/ets/response';


export { MessageAttachmentHeaders,
  MessageAttachment,
  MessageHeaders,
  AUTH_METHODS,
  BUFFERSIZE,
  DEFAULT_TIMEOUT,
  MIME64CHUNK,
  MIMECHUNK,
  Message,
  SMTPClient,
  SMTPConnection,
  SMTPError,
  SMTPErrorStates,
  SMTPResponseMonitor,
  SMTPState,
  addressparser,
  AddressObject,
  getRFC2822Date,
  getRFC2822DateUTC,
  isRFC2822Date,
  mimeEncode,
  mimeWordEncode };
