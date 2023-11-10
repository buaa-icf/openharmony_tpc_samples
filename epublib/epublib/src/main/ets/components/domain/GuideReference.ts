/**
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

import EpubResource from './EpubResource';
import TitledResourceReference from './TitledResourceReference';


class GuideReference extends TitledResourceReference {
    private static serialVersionUID: number = -316179702440631834;

    /**
      * the book cover(s), jacket information, etc.
      */
    public static COVER: string = "cover";

    /**
      * human-readable page with title, author, publisher, and other metadata
      */
    public static TITLE_PAGE: string = "title-page";

    /**
      * Human-readable table of contents.
      * Not to be confused the epub file table of contents
      *
      */
    public static TOC: string = "toc";

    /**
      * back-of-book style index
      */
    public static INDEX: string = "index";
    public static GLOSSARY: string = "glossary";
    public static ACKNOWLEDGEMENTS: string = "acknowledgements";
    public static BIBLIOGRAPHY: string = "bibliography";
    public static COLOPHON: string = "colophon";
    public static COPYRIGHT_PAGE: string = "copyright-page";
    public static DEDICATION: string = "dedication";

    /**
      *  an epigraph is a phrase, quotation, or poem that is set at the beginning of a document or component.
      *  source: http://en.wikipedia.org/wiki/Epigraph_%28literature%29
      */
    public static EPIGRAPH: string = "epigraph";
    public static FOREWORD: string = "foreword";

    /**
      * list of illustrations
      */
    public static LOI: string = "loi";

    /**
      * list of tables
      */
    public static LOT: string = "lot";
    public static NOTES: string = "notes";
    public static PREFACE: string = "preface";

    /**
      * A page of content (e.g. "Chapter 1")
      */
    public static TEXT: string = "text";
    private typeNew: string;

    constructor(resourceNew: EpubResource, typeNew?: string, title?: string, fragmentId?: string) {
        super(resourceNew, title, fragmentId);
        //todo  StringUtil  this.type = StringUtil.isNotBlank(type) ? type.toLowerCase() : null;
        if (null == typeNew || "" == typeNew) {
            this.typeNew = null;
        } else {
            this.typeNew = typeNew.toLowerCase();
        }

    }

    public getType(): string {
        return this.typeNew;
    }

    public setType(typeNew: string): void {
        this.typeNew = typeNew;
    }
}

export default GuideReference