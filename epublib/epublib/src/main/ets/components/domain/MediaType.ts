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

class MediaType {
    private static readonly serialVersionUID: BigInt = BigInt(-7256091153727506788);
    private name: string;
    private defaultExtension: string;
    private extensions: Array<string>;

    constructor(name: string, defaultExtension: string, extensions?: string[]) {
        this.name = name;
        this.defaultExtension = defaultExtension;
            extensions == null ? this.extensions = [defaultExtension] : this.extensions = extensions;
    }

    public hashCode(): number {
        if (this.name == null) {
            return 0;
        }
        return StringUtil.hashCode(this.name);
    }

    public getName(): string {
        return this.name;
    }

    public getDefaultExtension(): string {
        return this.defaultExtension;
    }

    public getExtensions(): Array<string> {
        return this.extensions;
    }

    public equals(otherMediaType: Object): boolean {
        if (!(otherMediaType instanceof MediaType)) {
            return false;
        }
        return this.name == otherMediaType.getName();
    }

    public toString(): string {
        return this.name;
    }
}

export default MediaType