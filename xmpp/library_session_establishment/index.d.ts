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
import { IQCaller } from "@xmpp/iq/src/main/types/caller";
import { Entity } from "@xmpp/middleware";
import { StreamFeatures } from "@xmpp/stream-features";

export = sessionEstablishment;

declare function sessionEstablishment<TEntity extends Entity>({
                                                                iqCaller,
                                                                streamFeatures,
                                                              }: {
  iqCaller: IQCaller<TEntity>;
  streamFeatures: StreamFeatures<TEntity>;
}): void;
