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

import DCAttributes from './DCAttributes';
import OPFAttributes from './OPFAttributes';
import DCTags from './DCTags';
import OPFTags from './OPFTags';
import StringUtil from '../util/StringUtil';
import Identifier from '../domain/Identifier';
import Author from '../domain/Author';
import DOMUtil from './DOMUtil';
import Metadata from '../domain/Metadata';
import PackageDocumentBase from './PackageDocumentBase';
import Date from '../domain/Date';

/**
 * Reads the package document metadata.
 *
 * In its own separate class because the PackageDocumentReader became a bit large and unwieldy.
 *
 * @author paul
 *
 */
class PackageDocumentMetadataReader {
    constructor() {
    }

    public static readMetadata(packageDocument: Document): Metadata {
        let result: Metadata = new Metadata();
        let metadataElement: Element = DOMUtil.getFirstElementByTagNameNS(packageDocument.documentElement, PackageDocumentBase.NAMESPACE_OPF, OPFTags.metadata);
        if (metadataElement == null) {
            console.error("Package does not contain element " + OPFTags.metadata);
            return result;
        }
        result.setTitles(DOMUtil.getElementsTextChild(metadataElement, PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.title));
        result.setPublishers(DOMUtil.getElementsTextChild(metadataElement, PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.publisher));
        result.setDescriptions(DOMUtil.getElementsTextChild(metadataElement, PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.description));
        result.setRights(DOMUtil.getElementsTextChild(metadataElement, PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.rights));
        result.setTypes(DOMUtil.getElementsTextChild(metadataElement, PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.type));
        result.setSubjects(DOMUtil.getElementsTextChild(metadataElement, PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.subject));
        result.setIdentifiers(PackageDocumentMetadataReader.readIdentifiers(metadataElement));
        result.setAuthors(PackageDocumentMetadataReader.readCreators(metadataElement));
        result.setContributors(PackageDocumentMetadataReader.readContributors(metadataElement));
        result.setDates(PackageDocumentMetadataReader.readDates(metadataElement));
        result.setOtherProperties(PackageDocumentMetadataReader.readOtherProperties(metadataElement));
        result.setMetaAttributes(PackageDocumentMetadataReader.readMetaProperties(metadataElement));
        let languageTag: Element = DOMUtil.getFirstElementByTagNameNS(metadataElement, PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.language);
        if (languageTag != null) {
            result.setLanguage(DOMUtil.getTextChildrenContent(languageTag));
        }
        return result;
    }

    /**
         * consumes meta tags that have a property attribute as defined in the standard. For example:
         * &lt;meta property="rendition:layout"&gt;pre-paginated&lt;/meta&gt;
         * @param metadataElement
         * @return
         */
    private static readOtherProperties(metadataElement: Element): Map<string, string>  {
        let result: Map<string, string> = new Map<string, string>();
        let metaTags = metadataElement.getElementsByTagName(OPFTags.meta);
        for (let i: number = 0; i < metaTags.length; i++) {
            let metaNode = metaTags.item(i);
            let property = metaNode.getAttribute(OPFAttributes.property);
            if (property != null) {
                let name: string = property;
                let value: string = metaNode.textContent;
                result.set(name, value);
            }
        }

        return result;
    }

    /**
         * consumes meta tags that have a property attribute as defined in the standard. For example:
         * &lt;meta property="rendition:layout"&gt;pre-paginated&lt;/meta&gt;
         * @param metadataElement
         * @return
         */
    private static readMetaProperties(metadataElement: Element): Map<string, string>  {
        let result: Map<string, string> = new Map<string, string>();

        let metaTags = metadataElement.getElementsByTagName(OPFTags.meta);
        for (let i: number = 0; i < metaTags.length; i++) {
            let metaElement: Element = <Element> metaTags.item(i);
            let name: string = metaElement.getAttribute(OPFAttributes.name);
            let value: string = metaElement.getAttribute(OPFAttributes.content);
            result.set(name, value);
        }

        return result;
    }

    private static getBookIdId(document: Document): string {
        let packageElement: Element = DOMUtil.getFirstElementByTagNameNS(document.documentElement, PackageDocumentBase.NAMESPACE_OPF, OPFTags.packageTag);
        if (packageElement == null) {
            return null;
        }
        let result: string = packageElement.getAttributeNS(PackageDocumentBase.NAMESPACE_OPF, OPFAttributes.uniqueIdentifier);
        return result;
    }

    private static readCreators(metadataElement: Element): Author[] {
        return PackageDocumentMetadataReader.readAuthors(DCTags.creator, metadataElement);
    }

    private static readContributors(metadataElement: Element): Author[]{
        return PackageDocumentMetadataReader.readAuthors(DCTags.contributor, metadataElement);
    }

    private static readAuthors(authorTag: string, metadataElement: Element): Author[] {
        let elements = metadataElement.getElementsByTagNameNS(PackageDocumentBase.NAMESPACE_DUBLIN_CORE, authorTag);
        let result: Author[] = new Array<Author>();
        for (let i = 0; i < elements.length; i++) {
            let authorElement = elements.item(i);
            let author: Author = PackageDocumentMetadataReader.createAuthor(authorElement);
            if (author != null) {
                result.push(author);
            }
        }
        return result;
    }

    private static readDates(metadataElement: Element): Date[] {
        let elements = metadataElement.getElementsByTagNameNS(PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.date);
        let result: Date[] = new Array<Date>();
        for (let i: number = 0; i < elements.length; i++) {
            let dateElement: Element = <Element> elements.item(i);
            let date: Date;
            try {
                date = new Date(DOMUtil.getTextChildrenContent(dateElement), dateElement.getAttributeNS(PackageDocumentBase.NAMESPACE_OPF, OPFAttributes.event));
                result.push(date);
            } catch (e) {
                console.error(e.getMessage());
            }
        }
        return result;

    }

    private static createAuthor(authorElement: Element): Author{
        let authorString: string = DOMUtil.getTextChildrenContent(authorElement);
        if (StringUtil.isBlank(authorString)) {
            return null;
        }
        let spacePos: number = authorString.lastIndexOf(' ');
        let result: Author;
        if (spacePos < 0) {
            result = new Author(authorString);
        } else {
            result = new Author(authorString.substring(0, spacePos), authorString.substring(spacePos + 1));
        }
        result.setRole(authorElement.getAttributeNS(PackageDocumentBase.NAMESPACE_OPF, OPFAttributes.role));
        return result;
    }

    private static readIdentifiers(metadataElement: Element): Identifier[]{
        let identifierElements = metadataElement.getElementsByTagNameNS(PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.identifier);
        if (identifierElements.length == 0) {
            console.error("Package does not contain element " + DCTags.identifier);
            return new Array<Identifier>();
        }
        let bookIdId: string = PackageDocumentMetadataReader.getBookIdId(metadataElement.ownerDocument);
        let result: Identifier[] = new Array<Identifier>();
        for (let i: number = 0; i < identifierElements.length; i++) {
            let identifierElement: Element = <Element> identifierElements.item(i);
            let schemeName: string = identifierElement.getAttributeNS(PackageDocumentBase.NAMESPACE_OPF, DCAttributes.scheme);
            let identifierValue: string = DOMUtil.getTextChildrenContent(identifierElement);
            if (StringUtil.isBlank(identifierValue)) {
                continue;
            }
            let identifier: Identifier = new Identifier(schemeName, identifierValue);
            if (identifierElement.getAttribute("id") == bookIdId) {
                identifier.setBookId(true);
            }
            result.push(identifier);
        }
        return result;
    }
}

export default PackageDocumentMetadataReader