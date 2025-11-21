/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import { emitter } from "@kit.BasicServicesKit";
import { ELog } from "../util/ELog";
import { EvaAnimComponent } from "./EvaAnimComponent";


export class MyXComponentController extends XComponentController {
    static readonly TAG = 'MyXComponentController'
    uuid: string

    constructor(uuid: string) {
        super();
        this.uuid = uuid
    }

    onSurfaceCreated(surfaceId: string): void {
        ELog.i(MyXComponentController.TAG, `onSurfaceCreated surfaceId: ${surfaceId}`);
        emitter.emit(EvaAnimComponent.EVENT_ID_ON_SURFACE_CREATED, { priority: emitter.EventPriority.IMMEDIATE }, { data: { uuid: this.uuid, surfaceId: surfaceId } })
    }

    onSurfaceChanged(surfaceId: string, rect: SurfaceRect): void {
        ELog.i(MyXComponentController.TAG, `onSurfaceChanged surfaceId: ${surfaceId}, rect: ${JSON.stringify(rect)}}`);
        emitter.emit(EvaAnimComponent.EVENT_ID_ON_SURFACE_CHANGED, { priority: emitter.EventPriority.IMMEDIATE }, { data: { uuid: this.uuid, surfaceId: surfaceId, rect: rect } })
    }

    onSurfaceDestroyed(surfaceId: string): void {
        ELog.i(MyXComponentController.TAG, `onSurfaceDestroyed surfaceId: ${surfaceId}`);
        emitter.emit(EvaAnimComponent.EVENT_ID_ON_SURFACE_DESTROYED, { priority: emitter.EventPriority.IMMEDIATE }, { data: { uuid: this.uuid, surfaceId: surfaceId } })
    }
}