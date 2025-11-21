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

import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { ELog } from '../util/ELog';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 获取文件MD5
 * @param file 文件对象
 * @return MD5字符串
 */
@Concurrent
export async function getFileMD5(file: string): Promise<string | null> {
    const TAG = 'FileUtil getFileMD5'

    const hexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']

    /**
     * 添加十六进制对
     */
    const appendHexPair = (byte: number, sb: string[]): void => {
        const c0 = hexDigits[(byte & 0xf0) >> 4]
        const c1 = hexDigits[byte & 0x0f]
        sb.push(c0)
        sb.push(c1)
    }

    /**
     * 字节数组转十六进制字符串（指定范围）
     */
    const bufferToHexA = (bytes: Uint8Array, start: number, length: number): string => {
        const sb: string[] = []
        const end = start + length

        for (let i = start; i < end; i++) {
            appendHexPair(bytes[i], sb)
        }

        return sb.join('')
    }

    /**
     * 字节数组转十六进制字符串
     */
    const bufferToHex = (bytes: Uint8Array): string => {
        return bufferToHexA(bytes, 0, bytes.length)
    }

    try {
        ELog.i(TAG, `filePath = ${file}`)
        // 检查文件是否存在
        fs.stat(file).then((stat: fs.Stat) => {
            ELog.i(TAG, "get file info succeed, the size of file is " + stat.size);
            if (!stat.isFile || stat.size <= 0) {
                ELog.e(TAG, `Invalid file`)
                throw new Error(`Invalid file`)
            }
        }).catch((err: BusinessError) => {
            ELog.e(TAG, "get file info failed with error message: " + err.message + ", error code: " + err.code);
        });

        // 创建MD5哈希对象
        let md5 = cryptoFramework.createMd('MD5');

        // 打开文件
        const openFile = await fs.open(file, fs.OpenMode.READ_ONLY);

        try {
            const arrayBuffer = new ArrayBuffer(4096); // 4KB缓冲区
            const arr = new Uint8Array(arrayBuffer);
            let bytesRead: number = 0;
            let readResult: number = 0;
            // 循环读取文件内容
            do {
                readResult =
                    await fs.read(openFile.fd, arr.buffer, { offset: bytesRead, length: arrayBuffer.byteLength });

                if (readResult > 0) {
                    // 更新MD5哈希
                    let updateMessage = arr.subarray(0, readResult);
                    let updateMessageBlob: cryptoFramework.DataBlob = { data: updateMessage };
                    try {
                        await md5.update(updateMessageBlob);
                    } catch (err) {
                        ELog.e(TAG, '计算文件MD5失败, md5.update error:' + JSON.stringify(err));
                    }
                }
                bytesRead += readResult;
            } while (readResult > 0);

            // 计算最终哈希值
            const mdOutput = await md5.digest();
            const strMD5 = bufferToHex(mdOutput.data)
            ELog.i(TAG, `计算文件MD5成功，MD5 = ${strMD5}`)
            return strMD5
        } catch (err) {
            ELog.e(TAG, '计算文件MD5失败1:' + JSON.stringify(err));
            return null;
        } finally {
            // 确保文件正确关闭
            await fs.close(openFile.fd);
        }
    } catch (err) {
        ELog.e(TAG, '计算文件MD5失败:' + err);
        return null;
    }
}

/**
 * 将资源文件拷贝到沙箱路径下
 */
@Concurrent
export async function copyFileToBox(dirPath: string, fileName: string, avFdFd: number, avFdLength: number,
    avFdOffset: number): Promise<string | null> {
    const TAG = 'FileUtil copyFileToBox'
    try {
        if (!await fs.access(dirPath)) {
            await fs.mkdir(dirPath);
        }
        // 创建缓存文件(当前是覆盖式创建)
        let cFile = dirPath + `/${fileName}`
        if (await fs.access(cFile)) {
            // 已经存在视频文件，则直接返回沙箱地址，防止重复创建
            ELog.i(TAG, '沙箱路径中已有同名的视频文件直接返回')
            return cFile
        }
        let cacheFile = await fs.open(cFile, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)

        // 读取缓冲区大小
        let bufferSize = avFdLength ?? 1024
        let buffer = new ArrayBuffer(bufferSize); // 创建buffer缓冲区

        // 要copy的文件的offset和length
        let currentOffset = avFdOffset;

        let readOption: ReadOptions = {
            length: bufferSize, // 每次期望读取数据的长度。可选，默认缓冲区长度
            offset: currentOffset // 期望读取文件的位置。可选，默认从当前位置开始读
        }

        // 后面len会一直减，直到没有
        while (true) {
            // 读取buffer容量的内容
            let readLength = await fs.read(avFdFd, buffer, readOption);
            // 写入buffer容量的内容
            // 写到cacheFile里
            await fs.write(cacheFile.fd, buffer, { length: readLength })
            // 判断后续内容，修改读文件的参数
            // buffer没读满代表文件读完了
            if (readLength < bufferSize) {
                break;
            }
            if (readOption.offset != undefined) {
                readOption.offset += readLength;
            }
        }
        ELog.i(TAG, 'Copy Success!!!')
        await fs.close(cacheFile).catch(() => {
            ELog.e(TAG, `fs.close(cacheFile)失败`)
        });
        ELog.i(TAG, `拷贝资源成功`)
        return cFile
    } catch (error) {
        ELog.e(TAG, `拷贝资源失败，error = ${JSON.stringify(error)}`)
        return null
    }
}
