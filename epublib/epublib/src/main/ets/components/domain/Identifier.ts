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


class Identifier {

    /**
     *
     */
    private static readonly serialVersionUID: number = 955949951416391810;
    private UUID: string = "UUID";
    private ISBN: string = "ISBN";
    private URL: string = "URL";
    private URI: string = "URI";
    private bookId: boolean = false;
    private scheme: string;
    private value: string;

    public constructor(scheme ?: string, value ?: string) {
        this.scheme = scheme ? scheme : this.UUID;
        this.value = value ? value : this.UUID;
    }

    /**
     * The first identifier for which the bookId is true is made the bookId identifier.
     * If no identifier has bookId == true then the first bookId identifier is written as the primary.
     *
     * @param identifiers
     * @return The first identifier for which the bookId is true is made the bookId identifier.
     */
    public static getBookIdIdentifier(identifiers: Array<Identifier>): Identifier {
        if (identifiers == null || identifiers.length == 0) {
            return null;
        }

        let result: Identifier = null;
        for (let identifier of identifiers) {
            if (identifier.isBookId()) {
                result = identifier;
                break;
            }
        }

        if (result == null) {
            result = identifiers[0];
        }

        return result;
    }

    public getScheme(): string {
        return this.scheme;
    }

    public setScheme(scheme: string): void {
        this.scheme = scheme;
    }

    public getValue(): string {
        return this.value;
    }

    public setValue(value: string): void {
        this.value = value;
    }

    public setBookId(bookId: boolean): void {
        this.bookId = bookId;
    }

    /**
     * This bookId property allows the book creator to add multiple ids and tell the epubwriter which one to write out as the bookId.
     *
     * The Dublin Core metadata spec allows multiple identifiers for a Book.
     * The epub spec requires exactly one identifier to be marked as the book id.
     *
     * @return whether this is the unique book id.
     */
    public isBookId(): boolean {
        return this.bookId;
    }

    public hashCode(): number {
        return StringUtil.hashCode(StringUtil.defaultIfNull(this.scheme)) ^ StringUtil.hashCode(StringUtil.defaultIfNull(this.value));
    }

    public equals(otherIdentifier: Object): boolean {
        if (!(otherIdentifier instanceof Identifier)) {
            return false;
        }
        return StringUtil.equals(this.scheme, otherIdentifier.scheme)
        && StringUtil.equals(this.value, otherIdentifier.value);
    }

    public toString(): string {
        if (StringUtil.isBlank(this.scheme)) {
            return "" + this.value;
        }
        return "" + this.scheme + ":" + this.value;
    }
}

export default Identifier