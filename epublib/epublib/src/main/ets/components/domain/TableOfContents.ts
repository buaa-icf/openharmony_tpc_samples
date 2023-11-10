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
import TOCReference from "./TOCReference"

class TableOfContents {
    public DEFAULT_PATH_SEPARATOR: string = "/";
    private tocReferences: Array<TOCReference> = [];

    public constructor(tocReferences: Array<TOCReference>) {
        this.tocReferences = tocReferences;
    }

    public getTocReferences(): Array<TOCReference>  {
        return this.tocReferences;
    }

    public setTocReferences(tocReferences: Array<TOCReference>): void {
        this.tocReferences = tocReferences;
    }

    /**
         * Finds the first TOCReference in the given list that has the same title as the given Title.
         *
         * @param title
         * @param tocReferences
         * @return null if not found.
         */
    private findTocReferenceByTitle(title: string, tocReferences: Array<TOCReference>): TOCReference {
        for (let tocReference of tocReferences) {
            if (title == tocReference.getTitle()) {
                return tocReference;
            }
        }
        return null;
    }

    public addSection(resourceNew: EpubResource, path?: string, pathSeparator?: string, pathElements?: number[] | string[],
                      sectionTitlePrefix?: string, sectionNumberSeparator?: string): TOCReference {
        if (path != null && pathSeparator != null) {
            pathElements = path.split(pathSeparator);
        } else if (path != null && pathSeparator == null) {
            pathSeparator = this.DEFAULT_PATH_SEPARATOR;
        }
        let result: TOCReference = null;
        let currentTocReferences: Array<TOCReference> = this.tocReferences;
        let currentTitle: any;
        let currentIndex: any;
        if (pathElements == null || pathElements.length == 0) {
            ;
        } else if (typeof pathElements[0] === 'string') {
            for (let i = 0; i < pathElements.length; i++) {
                currentTitle = pathElements[i];
                result = this.findTocReferenceByTitle(currentTitle, currentTocReferences);
                if (result == null) {
                    result = new TOCReference(currentTitle, null);
                    currentTocReferences.push(result);
                }
                currentTocReferences = result.getChildren();
            }
        } else if (typeof pathElements[0] === 'number') {
            let pathElementsNew: number[];
            for (let i = 0; i < pathElements.length; i++) {
                currentIndex = pathElements[i];
                pathElementsNew.push(currentIndex)
                if (currentIndex > 0 && currentIndex < (currentTocReferences.length - 1)) {
                    result = currentTocReferences[currentIndex];
                } else {
                    result = null;
                }
                if (result == null) {
                    this.paddTOCReferences(currentTocReferences, pathElementsNew, i, sectionTitlePrefix, sectionNumberSeparator);
                    result = currentTocReferences[currentIndex];
                }
                currentTocReferences = result.getChildren();
            }
        }

        result.setResource(resourceNew);
        return result;
    }

    private paddTOCReferences(currentTocReferences: Array<TOCReference>,
                              pathElements: number[], pathPos: number, sectionPrefix: string, sectionNumberSeparator: string): void {
        for (let i = currentTocReferences.length; i <= pathElements[pathPos]; i++) {
            let sectionTitle: string = this.createSectionTitle(pathElements, pathPos, i, sectionPrefix,
                sectionNumberSeparator);
            currentTocReferences.push(new TOCReference(sectionTitle, null));
        }
    }

    private createSectionTitle(pathElements: number[], pathPos: number, lastPos: number,
                               sectionPrefix: string, sectionNumberSeparator: string): string {
        let title: string[] = [sectionPrefix];
        for (let i = 0; i < pathPos; i++) {
            if (i > 0) {
                title.push(sectionNumberSeparator);
            }
            title.push(String(pathElements[i] + 1));
        }
        if (pathPos > 0) {
            title.push(sectionNumberSeparator);
        }
        title.push(String(lastPos + 1));
        return title.join("");
    }

    public addTOCReference(tocReference: TOCReference): TOCReference {
        if (this.tocReferences == null) {
            this.tocReferences = new Array<TOCReference>();
        }
        this.tocReferences.push(tocReference);
        return tocReference;
    }

    /**
         * All unique references (unique by href) in the order in which they are referenced to in the table of contents.
         *
         * @return All unique references (unique by href) in the order in which they are referenced to in the table of contents.
         */
    public getAllUniqueResources(): Array<EpubResource> {
        let uniqueHrefs: Set<string> = new Set<string>();
        let result: Array<EpubResource> = new Array<EpubResource>();
        this.getAllUniqueResourcesNew(uniqueHrefs, result, this.tocReferences);
        return result;
    }

    private getAllUniqueResourcesNew(uniqueHrefs: Set<string>, result: Array<EpubResource>, tocReferences: Array<TOCReference>): void {
        for (let tocReference of tocReferences) {
            let resourceNew: EpubResource = tocReference.getResource();
            if (resourceNew != null && !uniqueHrefs.has(resourceNew.getHref())) {
                uniqueHrefs.add(resourceNew.getHref());
                result.push(resourceNew);
            }
            this.getAllUniqueResourcesNew(uniqueHrefs, result, tocReference.getChildren());
        }
    }

    /**
         * The total number of references in this table of contents.
         *
         * @return The total number of references in this table of contents.
         */
    public size(): number {
        return this.getTotalSize(this.tocReferences);
    }

    private getTotalSize(tocReferences: Array<TOCReference>): number {
        let result: number = tocReferences.length;
        for (let tocReference of tocReferences) {
            result += this.getTotalSize(tocReference.getChildren());
        }
        return result;
    }


    /**
         * The maximum depth of the reference tree
         * @return The maximum depth of the reference tree
         */
    public calculateDepth(): number {
        return this.calculateDepthNew(this.tocReferences, 0);
    }

    private calculateDepthNew(tocReferences: Array<TOCReference>, currentDepth: number): number {
        let maxChildDepth: number = 0;
        for (let tocReference of tocReferences) {
            let childDepth: number = this.calculateDepthNew(tocReference.getChildren(), 1);
            if (childDepth > maxChildDepth) {
                maxChildDepth = childDepth;
            }
        }
        return currentDepth + maxChildDepth;
    }
}

export default TableOfContents