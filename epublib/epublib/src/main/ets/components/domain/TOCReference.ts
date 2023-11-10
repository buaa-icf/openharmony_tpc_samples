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

import TitledResourceReference from "./TitledResourceReference"
import EpubResource from "./EpubResource"


class TOCReference extends TitledResourceReference {
    private children: Array<TOCReference> = new Array<TOCReference>();

    constructor(title: string, resource?: EpubResource, fragmentId?: string, children?: Array<TOCReference>) {
        super(resource, title, fragmentId);
        this.children = children;
    }

    public getChildren(): Array<TOCReference> {
        return this.children;
    }

    public addChildSection(childSection: TOCReference): TOCReference{
        this.children.push(childSection);
        return childSection;
    }

    public setChildren(children: Array<TOCReference>): void {
        this.children = children;
    }
}

export default TOCReference