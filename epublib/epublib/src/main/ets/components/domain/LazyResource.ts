/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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

import EpubResource from "../domain/EpubResource"
import MediatypeService from "../service/MediatypeService"


class LazyResource extends EpubResource {
    private filename: string;
    private cachedSize: number;

    /**
     * Creates a Lazy resource, by not actually loading the data for this entry.
     *
     * The data will be loaded on the first call to getData()
     *
     * @param filename the file name for the epub we're created from.
     * @param size the size of this resource.
     * @param href The resource's href within the epub.
     */
    public constructor(filename: string, size: number, href: string) {
        super(href, MediatypeService.determineMediaType(href), null, null, null);
        this.filename = filename;
        this.cachedSize = size;
    }

    /**
     * Returns the size of this resource in bytes.
     *
     * @return the size.
     */
    public getSize(): number {
        if (this.data != null) {
            return this.data.length;
        }
        return this.cachedSize;
    }
}

export default LazyResource