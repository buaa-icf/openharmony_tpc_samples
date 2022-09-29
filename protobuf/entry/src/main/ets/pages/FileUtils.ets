/*
 * Copyright (C) 2021 Huawei Device Co., Ltd.
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
import fileio from '@ohos.fileio'

export class FileUtils {
    private static sInstance: FileUtils
    static readonly SEPARATOR: string = '/'
    base64Str: string = ''

    /**
     * 单例实现FileUtils类
     */
    public static getInstance(): FileUtils {
        if (!this.sInstance) {
            this.sInstance = new FileUtils();
        }
        return this.sInstance;
    }

    private constructor() {
    }

    /**
    * 新建文件
    *
    * @param path 文件绝对路径及文件名
    * @return number 文件句柄id
    */
    createFile(path: string): number {
        return fileio.openSync(path, 0o100, 0o664)
    }

    /**
    * 删除文件
    *
    * @param path 文件绝对路径及文件名
    */
    deleteFile(path: string): void {
        fileio.unlinkSync(path);
    }

    /**
     * 拷贝文件
     *
     * @param src 文件绝对路径及文件名
     * @param dest 拷贝到对应的路径
     */
    copyFile(src: string, dest: string) {
        fileio.copyFileSync(src, dest);
    }

    /**
     * 异步拷贝文件
     *
     * @param src 文件绝对路径及文件名
     * @param dest 拷贝到对应的路径
     */
    async copyFileAsync(src: string, dest: string): Promise<void> {
        await fileio.copyFile(src, dest);
    }

    /**
     * 清空已有文件数据
     *
     * @param path 文件绝对路径
     */
    clearFile(path: string): number {
        return fileio.openSync(path, 0o1000)
    }

    /**
     * 向path写入数据
     *
     * @param path 文件绝对路径
     * @param content 文件内容
     */
    writeData(path: string, content: ArrayBuffer | string) {
        let fd = fileio.openSync(path, 0o102, 0o664)
        let stat = fileio.statSync(path)
        fileio.writeSync(fd, content, { position: stat.size })
        fileio.closeSync(fd)
    }

    /**
     * 异步向path写入数据
     *
     * @param path 文件绝对路径
     * @param content 文件内容
     */
    async writeDataAsync(path: string, content: ArrayBuffer | string): Promise<void> {
        let fd = await fileio.open(path, 0o102, 0o664)
        let stat = await fileio.stat(path)
        await fileio.write(fd, content, { position: stat.size })
        await fileio.close(fd)
    }

    /**
     * 判断path文件是否存在
     *
     * @param path 文件绝对路径
     */
    exist(path: string): boolean {
        try {
            let stat = fileio.statSync(path)
            return stat.isFile()
        } catch (e) {
            console.error("FileUtils exist e " + e)
            return false
        }
    }

    /**
     * 向path写入数据
     *
     * @param path 文件绝对路径
     * @param data 文件内容
     */
    writeNewFile(path: string, data: ArrayBuffer) {
        this.createFile(path)
        this.writeFile(path, data)
    }

    /**
     * 向path写入数据
     *
     * @param path 文件绝对路径
     * @param data 文件内容
     */
    async writeNewFileAsync(path: string, data: ArrayBuffer): Promise<void> {
        await fileio.open(path, 0o100, 0o664)
        let fd = await fileio.open(path, 0o102, 0o664)
        await fileio.ftruncate(fd)
        await fileio.write(fd, data)
        await fileio.fsync(fd)
        await fileio.close(fd)
    }

    /**
     * 获取path的文件大小
     *
     * @param path 文件绝对路径
     */
    getFileSize(path: string): number {
        try {
            let stat = fileio.statSync(path)
            return stat.size
        } catch (e) {
            console.error("FileUtils getFileSize e " + e)
            return -1
        }
    }

    /**
     * 读取路径path的文件
     *
     * @param path 文件绝对路径
     */
    readFile(path: string): ArrayBuffer {
        let fd = fileio.openSync(path, 0o2);
        let length = fileio.statSync(path).size
        let buf = new ArrayBuffer(length);
        fileio.readSync(fd, buf)
        return buf
    }

    /**
     * 读取路径path的文件
     *
     * @param path 文件绝对路径
     */
    async readFileAsync(path: string): Promise<ArrayBuffer> {
        let stat = await fileio.stat(path);
        let fd = await fileio.open(path, 0o2);
        let length = stat.size;
        let buf = new ArrayBuffer(length);
        await fileio.read(fd, buf);
        return buf
    }

    /**
     * 创建文件夹
     *
     * @param path 文件夹绝对路径，只有是权限范围内的路径，可以生成
     * @param recursive
     */
    createFolder(path: string, recursive?: boolean) {
        if (recursive) {
            if (!this.existFolder(path)) {
                let lastInterval = path.lastIndexOf(FileUtils.SEPARATOR)
                if (lastInterval == 0) {
                    return
                }
                let newPath = path.substring(0, lastInterval)
                this.createFolder(newPath, true)
                if (!this.existFolder(path)) {
                    fileio.mkdirSync(path)
                }
            }
        } else {
            if (!this.existFolder(path)) {
                fileio.mkdirSync(path)
            }
        }
    }

    /**
     * 判断文件夹是否存在
     *
     * @param path 文件夹绝对路径
     */
    existFolder(path: string): boolean {
        try {
            let stat = fileio.statSync(path)
            return stat.isDirectory()
        } catch (e) {
            console.error("FileUtils folder exist e " + e)
            return false
        }
    }

    private writeFile(path: string, content: ArrayBuffer | string) {
        let fd = fileio.openSync(path, 0o102, 0o664)
        fileio.ftruncateSync(fd)
        fileio.writeSync(fd, content)
        fileio.fsyncSync(fd)
        fileio.closeSync(fd)
    }
}