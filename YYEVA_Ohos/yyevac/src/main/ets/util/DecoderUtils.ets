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

import fs from '@ohos.file.fs';
import { ELog } from './ELog';
import { JSON, util } from '@kit.ArkTS'
import zlib from '@ohos.zlib';
import { media } from '@kit.MediaKit';
import { EvaConstant } from './EvaConstant';
import { image } from '@kit.ImageKit';

@Concurrent
export async function getJsonStr(path: string): Promise<string> {
    const TAG = 'DecoderUtils getJsonStr'
    let jsonStr = ''

    /**
     * 比较两个Uint8Array是否相等
     * @param array1
     * @param array2
     * @returns
     */
    const areUint8ArraysEqual = (array1: Uint8Array, array2: Uint8Array): boolean => {
        // 1. 先比较长度：长度不同则内容必然不同
        if (array1.length !== array2.length) {
            return false;
        }

        // 2. 逐个比较元素
        for (let i = 0; i < array1.length; i++) {
            if (array1[i] !== array2[i]) {
                return false; // 发现不相等的元素，立即返回false
            }
        }

        // 3. 所有元素均相等
        return true;
    }

    /**
     * 执行zlib解压操作
     * @param inBuf
     * @returns
     */
    const unzip = async (inBuf: ArrayBuffer): Promise<Uint8Array> => {

        let zip = zlib.createZipSync();

        // 将压缩后的arrayBuffer 解压的正确姿势
        let strm: zlib.ZStream = {};
        let BUFLEN = 4096;
        let count = inBuf.byteLength / BUFLEN
        if (count > 1) {
            BUFLEN *= count
        }

        let outBuf = new ArrayBuffer(BUFLEN);
        let output: ArrayBuffer[] = []; // 用于存储解压后的数据

        let initStatus = await zip.inflateInit(strm);
        ELog.d(TAG, 'inflateInit ret: ' + initStatus.valueOf());

        let offset = 0; // 用于跟踪读取的字节数
        do {
            let readLen = Math.min(BUFLEN, inBuf.byteLength - offset);
            if (readLen <= 0) {
                break;
            }

            strm.availableIn = readLen;
            strm.nextIn = inBuf.slice(offset, offset + readLen);
            offset += readLen; // 更新偏移量

            do {
                strm.availableOut = BUFLEN;
                strm.nextOut = outBuf; // 压缩后的输出字节

                try {
                    let inflateStatus = await zip.inflate(strm, zlib.CompressFlushMode.SYNC_FLUSH);
                    ELog.d(TAG, 'inflate ret: ' + inflateStatus.valueOf());

                    let innerStrm = zip.getZStream();
                    strm.availableIn = (await innerStrm).availableIn;
                    strm.nextIn = (await innerStrm).nextIn;
                    strm.availableOut = (await innerStrm).availableOut;
                    strm.nextOut = (await innerStrm).nextOut;
                    strm.totalIn = (await innerStrm).totalIn;
                    strm.totalOut = (await innerStrm).totalOut;

                    if (strm.availableOut != undefined) {
                        let have = BUFLEN - strm.availableOut;
                        if (have > 0) {
                            // 将解压后的数据存储到 output 数组中
                            output.push(outBuf.slice(0, have));
                        }
                    }
                } catch (err) {
                    ELog.e(TAG, 'inflate err: ' + JSON.stringify(err));
                }
            } while (strm.availableOut == 0);
        } while (strm.availableIn! > 0 || strm.availableOut! > 0);

        try {
            await zip.inflateEnd(strm);
        } catch (error) {
            ELog.e(TAG, `zip.inflateEnd 失败 error = ${JSON.stringify(error)}`)
        }

        // 将 output 数组中的 Uint8Array 合并为一个单一的 Uint8Array
        let totalLength = output.reduce((acc, val) => acc + val.byteLength, 0);
        // 解压后的buff
        let result = new Uint8Array(totalLength);
        let pos = 0;
        for (let arr of output) {
            // 将 ArrayBuffer 转换为 Uint8Array
            let u = new Uint8Array(arr);
            // 将解压后的数据写入 result
            result.set(u, pos);
            // 更新位置
            pos += u.byteLength;
        }
        return result
    }

    try {
        const randomAccessFile = await fs.createRandomAccessFile(path, fs.OpenMode.READ_ONLY);

        let readBytes = new ArrayBuffer(1024)
        let readArray = new Uint8Array(readBytes)
        let readBytesLast = new ArrayBuffer(1024)
        let readArrayLast = new Uint8Array(readBytesLast)
        let bufStr = ""
        let bufStrS = ""
        let matchStart = "yyeffectmp4json[["
        let matchEnd = "]]yyeffectmp4json"
        let findStart = false
        let findEnd = false
        let length = 0
        // 创建解码器（默认UTF-8编码）
        let decoder = util.TextDecoder.create('utf-8');
        while (true) {
            length = await randomAccessFile.read(readArray.buffer, { length: readArray.length, offset: 0 })
            if (length <= 0) {
                break
            }
            if (!findStart) { //没找到开头
                bufStr = decoder.decodeToString(readArray)
                let index = bufStr.indexOf(matchStart)
                if (index > 0) { //分段1找到匹配开头
                    jsonStr = bufStr.substring(index + matchStart.length)
                    findStart = true
                    index = jsonStr.indexOf(matchEnd)
                    if (index > 0) { //同时包含结尾段进行截取
                        findEnd = true
                        jsonStr = jsonStr.substring(0, index)
                        break
                    }
                } else {
                    if (readArrayLast.length > 0) {
                        let mergedArray: Uint8Array = new Uint8Array(readArray.length + readArrayLast.length);
                        mergedArray.set(readArrayLast)
                        mergedArray.set(readArray)
                        bufStrS = decoder.decodeToString(mergedArray)
                        let indexS = bufStrS.indexOf(matchStart)
                        if (indexS > 0) { //合并分段找到匹配开头
                            jsonStr = bufStrS.substring(indexS + matchStart.length)
                            findStart = true
                            indexS = jsonStr.indexOf(matchEnd)
                            if (indexS > 0) { // 同时包含结尾段进行截取
                                findEnd = true
                                jsonStr = jsonStr.substring(0, indexS)
                                break
                            }
                        }
                    }
                    //保存分段
                    readBytesLast = readBytes
                }
            } else {
                bufStr = decoder.decodeToString(readArray)
                let index = bufStr.indexOf(matchEnd)
                if (index > 0) { //分段1找到匹配结尾
                    jsonStr += bufStr.substring(0, index)
                    findEnd = true
                    break
                } else if (!areUint8ArraysEqual(readArray, readArrayLast)) { //判定内容不一致
                    if (readArrayLast.length > 0) {
                        let mergedArray: Uint8Array = new Uint8Array(readArray.length + readArrayLast.length);
                        mergedArray.set(readArrayLast)
                        mergedArray.set(readArray)
                        bufStrS = decoder.decodeToString(mergedArray)
                        let indexS = bufStrS.indexOf(matchEnd)
                        if (indexS > 0) { //合并分段找到匹配结尾
                            if (indexS > readArrayLast.length) {
                                jsonStr =
                                    jsonStr.substring(0, jsonStr.length - (indexS - readArrayLast.length) - 1)
                            } else {
                                jsonStr.substring(0, jsonStr.length - (readArrayLast.length - indexS) - 1)
                            }
                            findEnd = true
                            break
                        }
                    }
                    //保存数据
                    jsonStr += bufStr
                    //保存分段
                    readBytesLast = readBytes
                }
            }
        }

        randomAccessFile.close()

        if (!findStart || !findEnd) {
            ELog.e(TAG, "yyeffectmp4json not found")
            return "none"
        } else {
            //先用base64解密
            let base64Helper = new util.Base64Helper();
            let arrFromBase64: Uint8Array = await base64Helper.decode(jsonStr)
            //再用zlib解密
            let arr = await unzip(arrFromBase64.buffer as ArrayBuffer)
            jsonStr = decoder.decodeToString(arr)
        }

    } catch (e) {
        ELog.e(TAG, `startRandomRead error = ${JSON.stringify(e)}`);
    }
    ELog.d(TAG, `jsonStr:${jsonStr}`)
    return jsonStr
}

@Concurrent
export async function getVoideMode(path: string): Promise<number | boolean | null> {
    const TAG = `DecoderUtils getVoidMode`

    /**
     * 创建BGRA_8888像素值
     *
     * @param arr
     * @returns
     */
    const createPixel = (arr: Uint8Array): number => {
        let alpha = arr[3]
        let red = arr[2]
        let green = arr[1]
        let blue = arr[0]
        return ((alpha & 0xFF) << 24) | ((red & 0xFF) << 16) | ((green & 0xFF) << 8) | (blue & 0xFF);
    }

    const getArray =
        async (pixelMap: image.PixelMap, start_x: number, start_y: number, count: number): Promise<Array<number>> => {
            const imageInfo = await pixelMap.getImageInfo()
            const w = imageInfo.size.width
            const h = imageInfo.size.height
            const w_i = w / (2 * (count + 1))
            const h_i = h / (2 * (count + 1))
            const a = new Array<number>(count * count)
            for (let i = 0; i < count; i++) {
                for (let j = 0; j < count; j++) {
                    const area: image.PositionArea = {
                        pixels: new ArrayBuffer(4), // 4为需要创建的像素buffer大小，取值为：height * width *4。像素。仅支持BGRA_8888格式的图像像素数据。
                        offset: 0,
                        stride: 8,
                        region: { size: { height: 1, width: 1 }, x: start_x + w_i * j, y: start_y + h_i * i }
                    };
                    await pixelMap.readPixels(area)
                    const pixels = new Uint8Array(area.pixels)
                    a[i * count + j] = createPixel(pixels)
                }
            }
            return a;
        }

    // 判断数组是否为灰度
    const isGray = (pixels: Array<number>): boolean => {
        // 在ArkTS中，假设pixels是RGBA格式的数据
        // 检查每个像素是否是灰度（RGB三个通道值相近）
        for (let i = 0; i < pixels.length; i++) {
            const b = (pixels[i] >> 0) & 0xFF
            const g = (pixels[i] >> 8) & 0xFF
            const r = (pixels[i] >> 16) & 0xFF

            ELog.i(TAG, `打印选择的值,r=${r} ,g=${g} ,b=${b}`)
            // 如果RGB值差异太大，不是灰度
            if ((Math.abs(r - g) > 25 || Math.abs(g - b) > 25 || Math.abs(r - b) > 25) &&
                (r > 30 && g > 30 && b > 30)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 返回已经判断完成
     */
    const getVideoMode = async (pixelMap: PixelMap): Promise<number | boolean | null> => {
        if (pixelMap != null) {
            const imageInfo = await pixelMap.getImageInfo()
            const w = imageInfo.size.width
            const h = imageInfo.size.height
            const count = 10

            ELog.i(TAG, 'ltIsGray');
            let ltUnit8Array = await getArray(pixelMap, 0, 0, count)
            const ltIsGray = isGray(ltUnit8Array);

            ELog.i(TAG, 'rtIsGray');
            let rtUnit8Array = await getArray(pixelMap, w / 2, 0, count)
            const rtIsGray = isGray(rtUnit8Array);

            ELog.i(TAG, 'lbIsGray');
            let lbUnit8Array = await getArray(pixelMap, 0, h / 2, count)
            const lbIsGray = isGray(lbUnit8Array);

            ELog.i(TAG, 'rbIsGray');
            let rbUnit8Array = await getArray(pixelMap, w / 2, h / 2, count)
            const rbIsGray = isGray(rbUnit8Array);

            ELog.i(TAG,
                `ltIsGray ${ltIsGray}, rtIsGray ${rtIsGray}, lbIsGray ${lbIsGray}, rbIsGray ${rbIsGray}`);

            if (!ltIsGray && !lbIsGray && !rtIsGray && !rbIsGray) {
                // 正常mp4
                ELog.i(TAG, '正常mp4');
                return true;
            } else if (ltIsGray && lbIsGray && (!rtIsGray || !rbIsGray)) {
                // 左灰右彩
                ELog.i(TAG, '左灰右彩');
                return EvaConstant.VIDEO_MODE_SPLIT_HORIZONTAL;
            } else if ((!ltIsGray || !lbIsGray) && rtIsGray && rbIsGray) {
                // 左彩右灰
                ELog.i(TAG, '左彩右灰');
                return EvaConstant.VIDEO_MODE_SPLIT_HORIZONTAL_REVERSE;
            } else if (ltIsGray && rtIsGray && (!lbIsGray || !rbIsGray)) {
                // 上灰下彩
                ELog.i(TAG, '上灰下彩');
                return EvaConstant.VIDEO_MODE_SPLIT_VERTICAL;
            } else if ((!ltIsGray || !rtIsGray) && lbIsGray && rbIsGray) {
                // 上彩下灰
                ELog.i(TAG, '上彩下灰');
                return EvaConstant.VIDEO_MODE_SPLIT_VERTICAL_REVERSE;
            } else {
                return null;
            }
        } else {
            ELog.e(TAG, 'getConfigManager bitmap is null');
            return null;
        }
    }

    try {
        // 1. 获取文件描述符（FD）
        let file = await fs.open(path, fs.OpenMode.READ_ONLY);
        let fd = file.fd;
        // 1. 创建元数据提取器
        let metadataExtractor: media.AVMetadataExtractor = await media.createAVMetadataExtractor();
        let generator: media.AVImageGenerator = await media.createAVImageGenerator();
        // 2. 设置视频路径（沙箱路径）
        metadataExtractor.fdSrc = { fd: fd };
        // 3. 提取元数据
        const metadata = await metadataExtractor.fetchMetadata();
        // 4. 获取时长（字符串格式，单位毫秒）
        const durationMs: number = Number(metadata.duration);

        let queryOption: media.AVImageQueryOptions = media.AVImageQueryOptions.AV_IMAGE_QUERY_PREVIOUS_SYNC;
        let param: media.PixelMapParams = {}

        if (durationMs != undefined && durationMs > 0) {
            for (let i = 0; i < 6; i++) {
                let startDetect = Date.now()
                const pixelMap: image.PixelMap =
                    await generator.fetchFrameByTime(i * durationMs / 6 * 1000, queryOption, param);
                const videoMode = await getVideoMode(pixelMap)
                pixelMap.release()
                ELog.i(TAG, `detect image mp4Type ${Date.now() - startDetect}`)
                ELog.i(TAG, `detect mp4Type ${videoMode}`)
                if (videoMode != null) {
                    return videoMode
                }
            }
        }
        generator.release().catch(()=>{
            ELog.e(TAG, `generator.release 失败`)
        })
        metadataExtractor.release().catch(() => {
            ELog.e(TAG, `metadataExtractor.release 失败`)
        })
        fs.close(file).catch(() => {
            ELog.e(TAG, `fs.close(file) 失败`)
        })
    } catch (error) {
        ELog.e(TAG, `获取视频模式失败：error = ${JSON.stringify(error)}`)
        return null
    }
    return null
}

