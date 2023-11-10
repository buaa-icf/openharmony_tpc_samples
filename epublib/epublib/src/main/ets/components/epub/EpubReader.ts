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

import Book from "../domain/Book"
import MediaType from "../domain/MediaType"
import MediatypeService from "../service/MediatypeService"
import ResourcesLoader from "../epub/ResourcesLoader"
import { Constants } from '../Constants';
import EpubResource from "../domain/EpubResource"
import Resources from "../domain/Resources"
import { DOMParser } from '@xmldom/xmldom'
import StringUtil from '../util/StringUtil'
import PackageDocumentReader from "./PackageDocumentReader"
import NCXDocument from './NCXDocument'
import fs from '@ohos.file.fs';

class EpubReader {
    constructor() {
    }

    public static readEpub(epubPath: string, encoding?: string, lazyLoadedTypes?: Array<MediaType>): Promise<Book> {
        return new Promise(result => {
            ResourcesLoader.loadResourcesZip(epubPath).then((outFile) => {
                let book = EpubReader.readEpubFile(outFile, encoding, lazyLoadedTypes);
                result(book)
            })
        });
    }

    public  static unEpub(epubPath: string): Promise<string> {
        return ResourcesLoader.loadResourcesZip(epubPath)

    }


    public  static outFile(inZipPath: string): string {
        return inZipPath.substring(0, inZipPath.length - ".epub".length)
    }


    public static readEpubFile(inPath: string, encoding?: string, lazyLoadedTypes?: Array<MediaType>): Book {
        try{
            let res = fs.accessSync(inPath);
            if(res) {
                return this.readEpubToBook(ResourcesLoader.loadResources(
                    inPath, encoding ? encoding : Constants.CHARACTER_ENCODING, lazyLoadedTypes ? lazyLoadedTypes : null));
            }
        }catch(err){
            console.info("accessSync failed : " + err.message + ", error code: " + err.code);
        }
    }

    public static readEpubLazy(inPath: string, encoding?: string, lazyLoadedTypes?: Array<MediaType>): Book {
        return this.readEpubToBook(
        ResourcesLoader.loadResources(
            inPath,
                encoding ? encoding : Constants.CHARACTER_ENCODING,
                lazyLoadedTypes ? lazyLoadedTypes : Array.from(MediatypeService.mediatypes)));
    }

    public static readEpubToBook(resources: Resources, result?: Book): Book {
        result = result || new Book();
        this.handleMimeType(resources);
        let packageResourceHref = this.getPackageResourceHref(resources);
        let packageResource = this.processPackageResource(packageResourceHref, result, resources);
        result.setOpfResource(packageResource);
        let ncxResource = this.processNcxResource(packageResource, result);
        result.setNcxResource(ncxResource);
        return result;
    }

    private static processNcxResource(packageResource: EpubResource, book: Book): EpubResource {
        return NCXDocument.read(book);
    }

    private static getPackageResourceHref(resources: Resources): string {
        let defaultResult: string = "content.opf";
        let result: string = defaultResult;

        let containerResource: EpubResource = resources.remove("container.xml");
        if (containerResource == null) {
            return result;
        }
        try {
            let domParser = new DOMParser();
            let document = domParser.parseFromString(containerResource.getStrData());
            let rootFileElement = document.getElementsByTagName("rootfiles")[0].getElementsByTagName("rootfile")[0];
            result = rootFileElement.getAttribute("full-path");
        } catch (e) {
            console.error(e);
        }
        if (StringUtil.isBlank(result)) {
            result = defaultResult;
        }
        return result;
    }

    private static processPackageResource(packageResourceHref: string, book: Book, resources: Resources): EpubResource {
        let packageResource = resources.remove(packageResourceHref);
        try {
            PackageDocumentReader.read(packageResource, this, book, resources);
        } catch (e) {
            console.error(e);
        }
        return packageResource;
    }

    private static handleMimeType(resources: Resources): void {
        resources.remove("mimetype");
    }
}

export default EpubReader