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

import EpubResource from "./EpubResource"

class ResourceReference {
    protected resourceNew: EpubResource ;

    public constructor(resourceNew: EpubResource) {
        this.resourceNew = resourceNew;
    }

    public getResource(): EpubResource {
        return this.resourceNew;
    }

    /**
         * Besides setting the resourceNew it also sets the fragmentId to null.
         *
         * @param resourceNew
         */
    public setResource(resourceNew: EpubResource): void {
        this.resourceNew = resourceNew;
    }

    /**
         * The id of the reference referred to.
         *
         * null of the reference is null or has a null id itself.
         *
         * @return The id of the reference referred to.
         */
    public getResourceId(): string {
        if (this.resourceNew != null) {
            return this.resourceNew.getId();
        }
        return null;
    }
}

export default ResourceReference