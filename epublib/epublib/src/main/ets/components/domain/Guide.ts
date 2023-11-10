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


import ResourceReference from './ResourceReference';
import GuideReference from './GuideReference';
import EpubResource from "./EpubResource"


class Guide {
    public static DEFAULT_COVER_TITLE: string = GuideReference.COVER
    private references: Array<GuideReference> = new Array<GuideReference>()
    private static readonly COVERPAGE_NOT_FOUND: number = -1
    private static readonly COVERPAGE_UNITIALIZED: number = -2
    private coverPageIndex: number = -1

    constructor() {
    }

    public getReferences(): Array<GuideReference>{
        return this.references;
    }

    public setReferences(references: Array<GuideReference>): void{
        this.references = references;
        this.uncheckCoverPage();
    }

    private uncheckCoverPage(): void {
        this.coverPageIndex = Guide.COVERPAGE_UNITIALIZED;
    }

    public getCoverReference(): GuideReference {
        this.checkCoverPage();
        if (this.coverPageIndex >= 0) {
            return this.references[this.coverPageIndex];
        }
        return null;
    }

    public setCoverReference(guideReference: GuideReference): number{
        if (this.coverPageIndex >= 0) {
            this.references.splice(this.coverPageIndex, 0, guideReference)
        } else {
            this.references.splice(0, 0, guideReference);
            this.coverPageIndex = 0;
        }
        return this.coverPageIndex;
    }

    private checkCoverPage(): void {
        if (this.coverPageIndex == Guide.COVERPAGE_UNITIALIZED) {
            this.initCoverPage();
        }
    }

    private initCoverPage(): void {
        let result: number = Guide.COVERPAGE_NOT_FOUND;
        for (let i: number = 0; i < this.references.length; i++) {
            let guideReference: GuideReference = this.references[i];
            if (guideReference.getType() == GuideReference.COVER) {
                result = i;
                break;
            }
        }
        this.coverPageIndex = result;
    }

    /**
         * The coverPage of the book.
         *
         * @return The coverPage of the book.
         */
    public getCoverPage(): EpubResource {
        let guideReference: GuideReference = this.getCoverReference();
        if (guideReference == null) {
            return null;
        }
        return guideReference.getResource();
    }

    public setCoverPage(coverPage: EpubResource): void {
        let coverPageGuideReference: GuideReference = new GuideReference(coverPage, GuideReference.COVER, Guide.DEFAULT_COVER_TITLE);
        this.setCoverReference(coverPageGuideReference);
    }

    public addReference(reference: GuideReference): ResourceReference {
        this.references.push(reference);
        this.uncheckCoverPage();
        return reference;
    }

    /**
         * A list of all GuideReferences that have the given referenceTypeName (ignoring case).
         *
         * @param referenceTypeName
         * @return A list of all GuideReferences that have the given referenceTypeName (ignoring case).
         */
    public getGuideReferencesByType(referenceTypeName: string): Array<GuideReference>{
        let result: Array<GuideReference> = new Array<GuideReference>();
        for (let guideReference of this.references) {
            if (referenceTypeName.toLowerCase() == guideReference.getType().toLowerCase()) {
                result.push(guideReference);
            }
        }
        return result;
    }
}


export default Guide