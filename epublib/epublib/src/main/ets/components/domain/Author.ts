/**
 *
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

import StringUtil from "../util/StringUtil"
import Relator from "./Relator"

class Author {
    private static readonly serialVersionUID: number = 6663408501416574200;
    private firstname: string;
    private lastname: string;
    private relator: Relator = Relator.AUTHOR;

    public constructor(lastname: string, firstname?: string) {
        if (firstname == null) {
            firstname = '';
        }
        this.firstname = firstname;
        this.lastname = lastname;
    }

    public getFirstname(): string {
        return this.firstname;
    }

    public setFirstname(firstname: string): void {
        this.firstname = firstname;
    }

    public getLastname(): string {
        return this.lastname;
    }

    public setLastname(lastname: string): void {
        this.lastname = lastname;
    }

    public toString(): string {
        return this.lastname + ", " + this.firstname;
    }

    public hashCode(): number {
        return StringUtil.hashCode(this.firstname, this.lastname);
    }

    public equals(authorObject: Object): boolean {
        if (!(authorObject instanceof Author)) {
            return false;
        }
        let other: Author = authorObject;
        return StringUtil.equals(this.firstname, other.firstname)
        && StringUtil.equals(this.lastname, other.lastname);
    }

    public setRole(code: string): Relator {
        let result: Relator = Relator.byCode(code);
        if (result == null) {
            result = Relator.AUTHOR;
        }
        this.relator = result;
        return result;
    }

    public getRelator(): Relator {
        return this.relator;
    }

    public setRelator(relator: Relator): void {
        this.relator = relator;
    }
}

export default Author