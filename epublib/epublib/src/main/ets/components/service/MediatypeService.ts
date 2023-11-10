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

import MediaType from "../domain/MediaType"
import StringUtil from "../util/StringUtil"

/**
 * Manages mediatypes that are used by epubs
 * 
 * @author paul
 *
 */
class MediatypeService {
    private static readonly listXHTML: string[] = [".htm", ".html", ".xhtml"];
    public static readonly XHTML: MediaType = new MediaType("application/xhtml+xml", ".xhtml", MediatypeService.listXHTML);
    public static readonly EPUB: MediaType = new MediaType("application/epub+zip", ".epub");
    public static readonly NCX: MediaType = new MediaType("application/x-dtbncx+xml", ".ncx");
    public static readonly JAVASCRIPT: MediaType = new MediaType("text/javascript", ".js");
    public static readonly CSS: MediaType = new MediaType("text/css", ".css");

    // images
    private static readonly listJPG: string[] = [".jpg", ".jpeg"];
    public static readonly JPG: MediaType = new MediaType("image/jpeg", ".jpg", MediatypeService.listJPG);
    public static readonly PNG: MediaType = new MediaType("image/png", ".png");
    public static readonly GIF: MediaType = new MediaType("image/gif", ".gif");
    public static readonly SVG: MediaType = new MediaType("image/svg+xml", ".svg");

    // fonts
    public static readonly TTF: MediaType = new MediaType("application/x-truetype-font", ".ttf");
    public static readonly OPENTYPE: MediaType = new MediaType("application/vnd.ms-opentype", ".otf");
    public static readonly WOFF: MediaType = new MediaType("application/font-woff", ".woff");

    // audio
    public static readonly MP3: MediaType = new MediaType("audio/mpeg", ".mp3");
    public static readonly OGG: MediaType = new MediaType("audio/ogg", ".ogg");

    // video
    public static readonly MP4: MediaType = new MediaType("video/mp4", ".mp4");
    public static readonly SMIL: MediaType = new MediaType("application/smil+xml", ".smil");
    public static readonly XPGT: MediaType = new MediaType("application/adobe-page-template+xml", ".xpgt");
    public static readonly PLS: MediaType = new MediaType("application/pls+xml", ".pls");
    public static mediatypes: MediaType[] = [
        MediatypeService.XHTML, MediatypeService.EPUB, MediatypeService.JPG, MediatypeService.PNG, MediatypeService.GIF,
        MediatypeService.CSS, MediatypeService.SVG, MediatypeService.TTF, MediatypeService.NCX, MediatypeService.XPGT,
        MediatypeService.OPENTYPE, MediatypeService.WOFF, MediatypeService.SMIL, MediatypeService.PLS,
        MediatypeService.JAVASCRIPT, MediatypeService.MP3, MediatypeService.MP4, MediatypeService.OGG
    ];
    public static mediaTypesByName: Map<string, MediaType> = new Map<string, MediaType>();
    //TODO
    //	static {
    //		for(int i = 0; i < mediatypes.length; i++) {
    //			mediaTypesByName.put(mediatypes[i].getName(), mediatypes[i]);
    //		}
    //	}
    constructor() {
    }

    public static isBitmapImage(mediaType: MediaType): boolean {
        return mediaType == MediatypeService.JPG || mediaType == MediatypeService.PNG || mediaType == MediatypeService.GIF;
    }

    /**
     * Gets the MediaType based on the file extension.
     * Null of no matching extension found.
     *
     * @param filename
     * @return the MediaType based on the file extension.
     */
    public static determineMediaType(filename: string): MediaType {
        for (let mediaType of this.mediaTypesByName.values()) {
            for (let extension of mediaType.getExtensions()) {
                if (StringUtil.endsWithIgnoreCase(filename, extension)) {
                    return mediaType;
                }
            }
        }
        return null;
    }

    public static getMediaTypeByName(mediaTypeName: string): MediaType {
        return MediatypeService.mediaTypesByName.get(mediaTypeName);
    }
}

export default MediatypeService


{
    let i: number;
    for (i = 0; i < MediatypeService.mediatypes.length; i++) {
        MediatypeService.mediaTypesByName.set(MediatypeService.mediatypes[i].getName(), MediatypeService.mediatypes[i]);
    }
}