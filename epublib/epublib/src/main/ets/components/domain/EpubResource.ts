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


import MediatypeService from '../service/MediatypeService';
import StringUtil from '../util/StringUtil';
import { Constants } from '../Constants';
import MediaType from './MediaType';


class EpubResource {
    private id: string;
    private title: string;
    private href: string;
    protected originalHref: string;
    private mediaType: MediaType;
    private inputEncoding: string = Constants.CHARACTER_ENCODING;
    protected data: Uint8Array;
    protected strData: string;

    /**
         * Creates an empty Resource with the given href.
         *
         * Assumes that if the data is of a text type (html/css/etc) then the encoding will be UTF-8
         *
         * @param href The location of the resource within the epub. Example: "chapter1.html".
         */
    constructor(href: string, mediaType: MediaType, id?: string, data?: Uint8Array, strData?: string, inputEncoding?: string) {
        this.id = id;
        this.href = href;
        this.originalHref = href;
        if (mediaType != null) {
            this.mediaType = mediaType;
        } else {
            this.mediaType = MediatypeService.determineMediaType(href);
        }
        if (inputEncoding != null) {
            this.inputEncoding = inputEncoding;
        }
        this.data = data;
        this.strData = strData;
    }

    /**
         * Gets the contents of the Resource as an InputStream.
         *
         * @return The contents of the Resource.
         *
         * @throws IOException
         */
    //  public getInputStream(): object  {
    //    //todo
    //    //return new ByteArrayInputStream(this.getData());
    //    return null;
    //  }

    /**
         * The contents of the resource as a byte[]
         *
         * @return The contents of the resource
         */
    public getData(): Uint8Array {
        return this.data;
    }

    public getStrData(): string{
        return this.strData;
    }

    /**
         * Sets the data of the Resource.
         * If the data is a of a different type then the original data then make sure to change the MediaType.
         *
         * @param data
         */
    public setData(data: Uint8Array): void{
        this.data = data;
    }

    /**
         * Tells this resource to release its cached data.
         *
         * If this resource was not lazy-loaded, this is a no-op.
         */
    public close(): void{

    }
    /**
         * Returns the size of this resource in bytes.
         *
         * @return the size.
         */
    public getSize(): number {
        return this.data.length;
    }

    /**
         * If the title is found by scanning the underlying html document then it is cached here.
         *
         * @return the title
         */
    public getTitle(): string {
        return this.title;
    }

    /**
         * Sets the Resource's id: Make sure it is unique and a valid identifier.
         *
         * @param id
         */
    public setId(id: string): void {
        this.id = id;
    }

    /**
         * The resources Id.
         *
         * Must be both unique within all the resources of this book and a valid identifier.
         * @return The resources Id.
         */
    public getId(): string {
        return this.id;
    }

    /**
         * The location of the resource within the contents folder of the epub file.
         *
         * Example:<br/>
         * images/cover.jpg<br/>
         * content/chapter1.xhtml<br/>
         *
         * @return The location of the resource within the contents folder of the epub file.
         */
    public getHref(): string {
        return this.href;
    }

    /**
         * Sets the Resource's href.
         *
         * @param href
         */
    public setHref(href: string): void {
        this.href = href;
    }

    /**
         * The character encoding of the resource.
         * Is allowed to be null for non-text resources like images.
         *
         * @return The character encoding of the resource.
         */
    public getInputEncoding(): string{
        return this.inputEncoding;
    }

    /**
         * Sets the Resource's input character encoding.
         *
         * @param encoding
         */
    public setInputEncoding(encoding: string): void {
        this.inputEncoding = encoding;
    }

    /**
         * Gets the contents of the Resource as Reader.
         *
         * Does all sorts of smart things (courtesy of apache commons io XMLStreamReader) to handle encodings, byte order markers, etc.
         *
         * @return the contents of the Resource as Reader.
         * @throws IOException
         */
    public getReader(): object {
        //return new XmlStreamReader(new ByteArrayInputStream(getData()), getInputEncoding());
        // todo
        return null;
    }

    /**
         * Gets the hashCode of the Resource's href.
         *
         */
    public hashCode(): number {
        return StringUtil.hashCode(this.href);
    }

    /**
         * Checks to see of the given resourceObject is a resource and whether its href is equal to this one.
         *
         * @return whether the given resourceObject is a resource and whether its href is equal to this one.
         */
    public equals(resourceObject: Object): boolean {
        if (!(resourceObject instanceof EpubResource)) {
            return false;
        }
        return this.href == resourceObject.getHref();
    }

    /**
         * This resource's mediaType.
         *
         * @return This resource's mediaType.
         */
    public getMediaType(): MediaType{
        return this.mediaType;
    }

    public setMediaType(mediaType: MediaType): void{
        this.mediaType = mediaType;
    }

    public setTitle(title: string): void {
        this.title = title;
    }

    public toString(): string {
        return StringUtil.toString(
            {
                "id": this.id,
                "title": this.title,
                "encoding": this.inputEncoding,
                "mediaType": this.mediaType,
                "href": this.href,
                "size": (this.data == null ? 0 : this.data.length)
            });
    }
}

export default EpubResource