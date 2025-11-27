/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import { IEvaFileContainer } from './IEvaFileContainer';
import { EvaConstant } from '../util/EvaConstant';
import { ELog } from '../util/ELog';
import fs from '@ohos.file.fs';
import { EvaPref } from './EvaPref';
import { resourceManager } from '@kit.LocalizationKit';
import { media } from '@kit.MediaKit';
import { JSON, taskpool } from '@kit.ArkTS';
import { copyFileToBox, getFileMD5 } from './FileUtil';

/**
 * YYEVA 文件容器
 * 负责管理文件的数据访问
 */
export class EvaRawFileContainer implements IEvaFileContainer {
    private static readonly TAG = `${EvaConstant.TAG}.EvaRawFileContainer`
    public filePath: string | null = null;
    public fileName: string
    private randomAccessFile: fs.RandomAccessFile | null = null
    private md5: string = ''
    public avFd: media.AVFileDescriptor
    public context: Context;

    constructor(context: Context, fileName: string, rawFileDescriptor: resourceManager.RawFileDescriptor) {
        ELog.i(EvaRawFileContainer.TAG,
            `constructor fileName = ${fileName}; rawFileDescriptor = ${JSON.stringify(rawFileDescriptor)}`)
        this.context = context
        this.avFd = { fd: rawFileDescriptor.fd, offset: rawFileDescriptor.offset, length: rawFileDescriptor.length };
        this.fileName = fileName
    }

    async init(): Promise<boolean> {
        // 将raw中的文件拷贝到沙箱路径下，以便后面进行随机读取
        await this.copyFileToBox()
        let isValid = await this.isValid()
        if (!isValid) {
            throw new Error(`Unable to read ${this.filePath}`)
        }
        return true
    }

    /**
     * 将raw中的文件拷贝到沙箱路径下，以便后面进行随机读取
     */
    async copyFileToBox() {
        // 创建缓存文件夹
        let dirPath = this.context.getApplicationContext().filesDir + '/EvaAnimVideo'
        const task = new taskpool.Task(copyFileToBox, dirPath, this.fileName, this.avFd.fd, this.avFd.length ?? 1024,
            this.avFd.offset ?? 0)
        try {
            const path = await taskpool.execute(task)
            if (path) {
                this.filePath = path as string
            }
        } catch (error) {
            ELog.e(EvaRawFileContainer.TAG, `将raw中的文件拷贝到沙箱路径下失败，error = ${JSON.stringify(error)}`)
        }
    }

    async getAVFileDescriptor(): Promise<media.AVFileDescriptor | null> {
        return this.avFd
    }

    /**
     * 检查文件是否存在
     */
    private async fileExists(): Promise<boolean> {
        try {
            // 在 HarmonyOS 中，使用文件系统 API 检查文件存在
            let isExists = await fs.access(this.filePath ?? '')
            return isExists;
        } catch (e) {
            ELog.e(EvaRawFileContainer.TAG, `fileExists error = ${JSON.stringify(e)}`);
            return false
        }
    }

    /**
     * 检查是否为文件
     */
    private isFile(): boolean {
        try {
            // 在 HarmonyOS 中，使用文件系统 API 检查文件类型
            let isFile = fs.statSync(this.filePath ?? '').isFile()
            return isFile
        } catch (e) {
            ELog.e(EvaRawFileContainer.TAG, `isFile error = ${JSON.stringify(e)}`);
            return false
        }
    }

    /**
     * 检查是否可读
     */
    private async canRead(): Promise<boolean> {
        try {
            // 在 HarmonyOS 中，使用文件系统 API 检查文件权限
            let isCanRead = await fs.access(this.filePath ?? '', fs.AccessModeType.READ)
            return isCanRead
        } catch (e) {
            ELog.e(EvaRawFileContainer.TAG, `canRead error = ${JSON.stringify(e)}`);
            return false
        }
    }

    /**
     * 开始随机读取
     */
    async startRandomRead(): Promise<void> {
        try {
            this.randomAccessFile = await fs.createRandomAccessFile(this.filePath ?? '', fs.OpenMode.READ_ONLY);
        } catch (e) {
            ELog.e(EvaRawFileContainer.TAG, `startRandomRead error = ${JSON.stringify(e)}`);
        }
    }

    /**
     * 读取数据
     */
    async read(buffer: Uint8Array, offset: number, length: number): Promise<number> {
        try {
            if (this.randomAccessFile) {
                let num = await this.randomAccessFile.read(buffer.buffer, { length: length, offset: offset })
                return num
            }
            return -1
        } catch (e) {
            ELog.e(EvaRawFileContainer.TAG, 'read error')
            return -1
        }
    }

    /**
     * 跳过位置
     */
    skip(position: number): void {
        try {
            if (this.randomAccessFile) {
                this.randomAccessFile.setFilePointer(this.randomAccessFile.filePointer + position)
            }
        } catch (e) {
            ELog.e(EvaRawFileContainer.TAG, 'skip error')
        }
    }

    /**
     * 关闭随机读取
     */
    closeRandomRead(): void {
        try {
            if (this.randomAccessFile) {
                this.randomAccessFile.close()
                this.randomAccessFile = null
            }
        } catch (e) {
            ELog.e(EvaRawFileContainer.TAG, 'closeRandomRead error')
        }
    }

    /**
     * 关闭文件
     */
    close(): void {
        try {
            this.randomAccessFile?.close()
        } catch (error) {
            ELog.e(EvaRawFileContainer.TAG, `colse error = ${error}`)
        }
    }

    /**
     * 获取文件对象
     */
    getFile(): string | null {
        return this.filePath
    }

    /**
     * 获取文件MD5
     */
    async getMd5(): Promise<string> {
        if (!this.md5 && this.filePath) {
            const task = new taskpool.Task(getFileMD5, this.filePath)
            try {
                let data = await taskpool.execute(task)
                if (data) {
                    this.md5 = data as string
                }
            } catch (error) {
                ELog.e(EvaRawFileContainer.TAG, `getMd5 error = ${JSON.stringify(error)}`)
            }
        }
        return this.md5
    }


    /**
     * 设置EVA JSON配置
     */
    async setEvaJson(json: string): Promise<void> {
        await EvaPref.setEvaJson(this.filePath ?? '', await this.getMd5(), json)
    }

    /**
     * 获取EVA JSON配置
     */
    async getEvaJson(): Promise<string | null> {
        return await EvaPref.getEvaJson(await this.getMd5())
    }

    /**
     * 设置EVA MP4类型
     */
    async setEvaMp4Type(type: number): Promise<void> {
        await EvaPref.setEvaMp4Type(this.filePath ?? '', await this.getMd5(), type)
    }

    /**
     * 获取EVA MP4类型
     */
    async getEvaMp4Type(): Promise<number> {
        return await EvaPref.getEvaMp4Type(await this.getMd5())
    }

    /**
     * 是否有效
     */
    async isValid(): Promise<boolean> {
        let isFileExists = await this.fileExists()
        let isFile = this.isFile()
        let isCanRead = await this.canRead()
        return isFileExists && isFile && isCanRead
    }
}