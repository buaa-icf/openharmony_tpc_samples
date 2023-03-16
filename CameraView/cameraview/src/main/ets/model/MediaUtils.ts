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

import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import Logger from '../model/Logger'
import DateTimeUtil from '../model/DateTimeUtil'

export class MediaUtils {
    private tag: string = 'MediaUtils'
    private mediaTest: mediaLibrary.MediaLibrary = mediaLibrary.getMediaLibrary(globalThis.abilityContext);
    private static instance: MediaUtils = new MediaUtils()

    public static getInstance() {
        if (this.instance === undefined) {
            this.instance = new MediaUtils()
        }
        return this.instance
    }

    async createAndGetUri(mediaType: number) {
        let info = this.getInfoFromType(mediaType)
        let dateTimeUtil = new DateTimeUtil()
        let name = `${dateTimeUtil.getDate()}_${dateTimeUtil.getTime()}`
        // @ts-ignore
        let displayName = `${info.prefix}${name}${info.suffix}`
        // @ts-ignore
        let publicPath = await this.mediaTest.getPublicDirectory(info.directory)
        return await this.mediaTest.createAsset(mediaType, displayName, publicPath)
    }

    async getFileAssetsFromType(mediaType: number) {
        Logger.info(this.tag, `getFileAssetsFromType,mediaType = ${mediaType}`)
        let fileKeyObj = mediaLibrary.FileKey
        let fetchOp = {
            selections: `${fileKeyObj.MEDIA_TYPE}=?`,
            selectionArgs: [`${mediaType}`]
        }
        const fetchFileResult = await this.mediaTest.getFileAssets(fetchOp)
        let fileAssets = []
        if (fetchFileResult.getCount() > 0) {
            fileAssets = await fetchFileResult.getAllObject()
        }
        return fileAssets
    }

    async getAlbums() {
        let albums = []
        const [files,images,videos,audios] = await Promise.all([
        this.getFileAssetsFromType(mediaLibrary.MediaType.FILE),
        this.getFileAssetsFromType(mediaLibrary.MediaType.IMAGE),
        this.getFileAssetsFromType(mediaLibrary.MediaType.VIDEO),
        this.getFileAssetsFromType(mediaLibrary.MediaType.AUDIO)
        ])
        albums.push({
            albumName: 'Documents', count: files.length, mediaType: mediaLibrary.MediaType.FILE
        })
        albums.push({
            albumName: 'Pictures', count: images.length, mediaType: mediaLibrary.MediaType.IMAGE
        })
        albums.push({
            albumName: 'Videos', count: videos.length, mediaType: mediaLibrary.MediaType.VIDEO
        })
        albums.push({
            albumName: 'Audios', count: audios.length, mediaType: mediaLibrary.MediaType.AUDIO
        })
        return albums
    }

    async queryFile(dataUri: any) {
        let fileKeyObj = mediaLibrary.FileKey
        if (dataUri !== undefined) {
            let args = dataUri.id.toString()
            let fetchOp = {
                selections: `${fileKeyObj.ID}=?`,
                selectionArgs: [args]
            }
            const fetchFileResult = await this.mediaTest.getFileAssets(fetchOp)
            const fileAsset = await fetchFileResult.getAllObject()
            return fileAsset[0]
        }
    }

    async getFdPath(fileAsset: any) {
        let fd = await fileAsset.open('Rw')
        return fd
    }

    async createFile(mediaType: number) {
        let dataUri = await this.createAndGetUri(mediaType)
        // @ts-ignore
        if (dataUri) {
            let fileAsset = await this.queryFile(dataUri)
            if (fileAsset) {
                let fd = await this.getFdPath(fileAsset)
                return fd
            }
        }
    }

    deleteFile(media: any) {
        let uri = media.uri
        Logger.info(this.tag, 'deleteFile,uri =${uri}')
        // @ts-ignore
        return this.mediaTest.deleteAsset(uri)
    }

    onDateChange(callback: () => void) {
        this.mediaTest.on('albumChange', () => {
            callback()
        })
        this.mediaTest.on('imageChange', () => {
            callback()
        })
        this.mediaTest.on('audioChange', () => {
            callback()
        })
        this.mediaTest.on('videoChange', () => {
            callback()
        })
        this.mediaTest.on('fileChange', () => {
            callback()
        })
    }

    offDateChange() {
        this.mediaTest.off('albumChange')
        this.mediaTest.off('imageChange')
        this.mediaTest.off('audioChange')
        this.mediaTest.off('videoChange')
        this.mediaTest.off('fileChange')
    }

    getInfoFromType(mediaType: number) {
        let result = {
            prefix: '', suffix: '', directory: 0
        }
        switch (mediaType) {
            case mediaLibrary.MediaType.FILE:
                result.prefix = 'FILE_'
                result.suffix = '.txt'
                result.directory = mediaLibrary.DirectoryType.DIR_DOCUMENTS
                break
            case mediaLibrary.MediaType.IMAGE:
                result.prefix = 'IMG_'
                result.suffix = '.jpg'
                result.directory = mediaLibrary.DirectoryType.DIR_IMAGE
                break
            case mediaLibrary.MediaType.VIDEO:
                result.prefix = 'VID_'
                result.suffix = '.mp4'
                result.directory = mediaLibrary.DirectoryType.DIR_VIDEO
                break
            case mediaLibrary.MediaType.AUDIO:
                result.prefix = 'AUD_'
                result.suffix = '.wav'
                result.directory = mediaLibrary.DirectoryType.DIR_AUDIO
                break
        }
    }
}