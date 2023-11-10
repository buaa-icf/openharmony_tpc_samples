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
import Identifier from '../domain/Identifier';
import { Constants } from '../Constants';
import OPFValues from './OPFValues';
import EpubWriter from './EpubWriter';
import StringUtil from '../util/StringUtil';
import OPFAttributes from './OPFAttributes';
import DCTags from './DCTags';
import OPFTags from './OPFTags';
import Book from '../domain/Book';
import PackageDocumentBase from './PackageDocumentBase';

class PackageDocumentMetadataWriter extends PackageDocumentBase {

	/**
	 * Writes the book's metadata.
	 *
	 * @param book
	 * @param serializer
	 * @throws IOException
	 * @throws IllegalStateException
	 * @throws IllegalArgumentException
	 */
	public static writeMetaData(book : Book, parentElement:Element, document:Document) : void  {
		let metadataElement:Element = document.createElementNS(PackageDocumentBase.NAMESPACE_OPF, OPFTags.metadata);
		metadataElement.setAttribute("xmlns:" + PackageDocumentBase.PREFIX_DUBLIN_CORE, PackageDocumentBase.NAMESPACE_DUBLIN_CORE);
		metadataElement.setAttribute("xmlns:" + PackageDocumentBase.PREFIX_OPF, PackageDocumentBase.NAMESPACE_OPF);

		PackageDocumentMetadataWriter.writeIdentifiers(book.getMetadata().getIdentifiers(), metadataElement, document);
		PackageDocumentMetadataWriter.writeSimpleMetdataElements(DCTags.title, book.getMetadata().getTitles(), metadataElement, document);
		PackageDocumentMetadataWriter.writeSimpleMetdataElements(DCTags.subject, book.getMetadata().getSubjects(), metadataElement, document);
		PackageDocumentMetadataWriter.writeSimpleMetdataElements(DCTags.description, book.getMetadata().getDescriptions(), metadataElement, document);
		PackageDocumentMetadataWriter.writeSimpleMetdataElements(DCTags.publisher, book.getMetadata().getPublishers(), metadataElement, document);
		PackageDocumentMetadataWriter.writeSimpleMetdataElements(DCTags.type, book.getMetadata().getTypes(), metadataElement, document);
		PackageDocumentMetadataWriter.writeSimpleMetdataElements(DCTags.rights, book.getMetadata().getRights(), metadataElement, document);

		// write authors
		for(let author of book.getMetadata().getAuthors()) {
      let creatorElement:Element = document.createElementNS(PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.creator);
		  creatorElement.setAttributeNS(PackageDocumentBase.NAMESPACE_OPF, OPFAttributes.role, author.getRelator().getCode());
		  creatorElement.setAttributeNS(PackageDocumentBase.NAMESPACE_OPF, OPFAttributes.file_as, author.getLastname() + ", " + author.getFirstname());
		  creatorElement.textContent = author.getFirstname() + " " + author.getLastname();
		  metadataElement.appendChild(creatorElement);
		}

		// write contributors
		for(let author of book.getMetadata().getContributors()) {
      let contributorElement:Element = document.createElementNS(PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.contributor);
		  contributorElement.setAttributeNS(PackageDocumentBase.NAMESPACE_OPF, OPFAttributes.role, author.getRelator().getCode());
		  contributorElement.setAttributeNS(PackageDocumentBase.NAMESPACE_OPF, OPFAttributes.file_as, author.getLastname() + ", " + author.getFirstname());
		  contributorElement.textContent = author.getFirstname() + " " + author.getLastname();
		  metadataElement.appendChild(contributorElement);
		}

		// write dates
		for (let date of book.getMetadata().getDates()) {
      let dateElement:Element = document.createElementNS(PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.date);
      if (date.getEvent() != null) {
        dateElement.setAttributeNS(PackageDocumentBase.NAMESPACE_OPF, OPFAttributes.event, date.getEvent().toString());
      }
		  dateElement.textContent = date.getValue();
		  metadataElement.appendChild(dateElement);
		}

		// write language
		if(StringUtil.isNotBlank(book.getMetadata().getLanguage())) {
			let languageElement: Element = document.createElementNS(PackageDocumentBase.NAMESPACE_DUBLIN_CORE, "language");
			languageElement.textContent = book.getMetadata().getLanguage();
			metadataElement.appendChild(languageElement);
		}

		// write other properties
		if(book.getMetadata().getOtherProperties() != null) {
			book.getMetadata().getOtherProperties().forEach((value, key)=>{
				let metaElement: Element = document.createElementNS(PackageDocumentBase.NAMESPACE_DUBLIN_CORE, OPFTags.meta);
				metaElement.setAttributeNS(EpubWriter.EMPTY_NAMESPACE_PREFIX, OPFAttributes.property, key);
				metaElement.textContent = value;
				metadataElement.appendChild(metaElement);
			})
		}

		// write coverimage
		if(book.getCoverImage() != null) { // write the cover image
			let metaElement: Element = document.createElementNS(PackageDocumentBase.NAMESPACE_OPF, OPFTags.meta);
			metaElement.setAttributeNS(EpubWriter.EMPTY_NAMESPACE_PREFIX, OPFAttributes.name, OPFValues.meta_cover);
			metaElement.setAttributeNS(EpubWriter.EMPTY_NAMESPACE_PREFIX, OPFAttributes.content, book.getCoverImage().getId());
			metadataElement.appendChild(metaElement);
		}

		// write generator
		let metaElement: Element = document.createElementNS(PackageDocumentBase.NAMESPACE_OPF, OPFTags.meta);
		metaElement.setAttributeNS(EpubWriter.EMPTY_NAMESPACE_PREFIX, OPFAttributes.name, OPFValues.generator);
		metaElement.setAttributeNS(EpubWriter.EMPTY_NAMESPACE_PREFIX, OPFAttributes.content, Constants.EPUBLIB_GENERATOR_NAME);
		metadataElement.appendChild(metaElement);

		parentElement.appendChild(metadataElement);
	}

	private static writeSimpleMetdataElements(tagName:string, values:string[], parentElement:Element, document:Document) : void {
		for(let value of values) {
			if (StringUtil.isBlank(value)) {
				continue;
			}
			let tagElement: Element = document.createElementNS(PackageDocumentBase.NAMESPACE_DUBLIN_CORE, tagName);
			tagElement.textContent = value;
			parentElement.appendChild(tagElement);
		}
	}

	/**
	 * Writes out the complete list of Identifiers to the package document.
	 * The first identifier for which the bookId is true is made the bookId identifier.
	 * If no identifier has bookId == true then the first bookId identifier is written as the primary.
	 *
	 * @param identifiers
	 * @param serializer
	 * @throws IOException
	 * @throws IllegalStateException
	 * @throws IllegalArgumentException
	 * @
	 */

	private static writeIdentifiers(identifiers:Identifier[], parentElement:Element, document:Document) : void {
		let bookIdIdentifier : Identifier = Identifier.getBookIdIdentifier(identifiers);
		if(bookIdIdentifier == null) {
			return;
		}

		let identifierElement: Element = document.createElementNS(PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.identifier);
		identifierElement.setAttributeNS(EpubWriter.EMPTY_NAMESPACE_PREFIX, DCAttributes.id, PackageDocumentBase.BOOK_ID_ID);
		identifierElement.setAttributeNS(PackageDocumentBase.NAMESPACE_OPF, OPFAttributes.scheme, bookIdIdentifier.getScheme());
		identifierElement.textContent = bookIdIdentifier.getValue();
		parentElement.appendChild(identifierElement);

		for(let identifier of identifiers.slice(1, identifiers.length)) {
			if(identifier == bookIdIdentifier) {
				continue;
			}
			let tmpElement: Element = document.createElementNS(PackageDocumentBase.NAMESPACE_DUBLIN_CORE, DCTags.identifier);
			tmpElement.setAttributeNS(PackageDocumentBase.NAMESPACE_OPF, "scheme", identifier.getScheme());
			tmpElement.textContent = identifier.getValue();
			parentElement.appendChild(tmpElement);
		}
	}

}

export default PackageDocumentMetadataWriter