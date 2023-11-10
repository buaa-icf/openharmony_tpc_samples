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

import EpubResource from "../domain/EpubResource"
import {DOMParser} from '@xmldom/xmldom'
import util from '@ohos.util';

class ResourceUtil {

	constructor() {}

	public static createResource(href:string, data:Uint8Array) {
		console.debug("createResource-------------"+href)
		var textDecoder = new util.TextDecoder("utf-8",{ignoreBOM:true});
		console.debug("createResource----------textDecoder---"+textDecoder)
		console.debug("createResource----==="+href+"----strData---start===="+data)
		let strData = textDecoder.decode(data);
		console.debug("createResource-----==="+href+"---strData--end===="+strData)
		return new EpubResource(href, null, null, data, strData)
	}

	public static createStrResource(href:string, data:string) {
		return new EpubResource(href, null, null, null, data)
	}



	public static decode(data:Uint8Array):string {
		var textDecoder = new util.TextDecoder("utf-8",{ignoreBOM:true});
		let strData = textDecoder.decode(data);
		return strData;
	}

	/**
     * Reads the given resources inputstream, parses the xml therein and returns the result as a Document
     *
     * @param resource
     * @param documentBuilder
     * @return the document created from the given resource
     * @throws UnsupportedEncodingException
     * @throws SAXException
     * @throws IOException
     * @throws ParserConfigurationException
     */
	public static getAsDocument(resource:EpubResource):Document {
		if (resource.getStrData() == null) {
			return null;
		}
		console.debug("---ResourceUtil-----DOMParser----DOMParser----DOMParser--DOMParser--DOMParser--DOMParser---DOMParser----DOMParser------")
		let domParser = new DOMParser();
		let result:Document = domParser.parseFromString(resource.getStrData());
		return result;
	}
}
export default ResourceUtil