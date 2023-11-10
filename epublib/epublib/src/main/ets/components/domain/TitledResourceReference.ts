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

import StringUtil from '../util/StringUtil';
import { Constants } from '../Constants';
import EpubResource from './EpubResource';
import ResourceReference from './ResourceReference';

class TitledResourceReference extends ResourceReference {
    private fragmentId: string;
    private title: string;

    constructor(resourceNew: EpubResource, title?: string, fragmentId?: string) {
        super(resourceNew);
        this.title = title;
        this.fragmentId = fragmentId;
    }

    public getFragmentId(): string {
        return this.fragmentId;
    }

    public setFragmentId(fragmentId: string): void {
        this.fragmentId = fragmentId;
    }

    public getTitle(): string {
        return this.title;
    }

    public setTitle(title: string): void {
        this.title = title;
    }


    /**
         * If the fragmentId is blank it returns the resource href, otherwise it returns the resource href + '#' + the fragmentId.
         *
         * @return If the fragmentId is blank it returns the resource href, otherwise it returns the resource href + '#' + the fragmentId.
         */
    public getCompleteHref(): string  {
        if (StringUtil.isBlank(this.fragmentId)) {
            return this.resourceNew.getHref();
        } else {
            return this.resourceNew.getHref() + Constants.FRAGMENT_SEPARATOR_CHAR + this.fragmentId;
        }
    }

    /**
         * Sets the resource to the given resource and sets the fragmentId .
         *
         */
    public setResource(resourceNew: EpubResource, fragmentId?: string): void{
        super.setResource(resourceNew);
        this.fragmentId = fragmentId;
    }
}

export default TitledResourceReference