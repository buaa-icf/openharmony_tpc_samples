/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import fileio from '@ohos.fileio';
import JSZip from "jszip";

/**
 * zip解压方法
 *
 * @since 7
 * @permission N
 * @param {string} path - path and name of the decompressed .zip file.
 * @param {string} target -Decompress the package to a specified path.
 * @returns {void | Promise<boolean>} callback return Promise otherwise return true or false.
 */
export async function zipDeCompress(path: string, target?: string, password?: string): Promise<boolean> {
    try {
        // 使用os读取zip的buffer数据
        let stat = fileio.statSync(path);
        let size = stat.size;
        let contentBuffer = new ArrayBuffer(size);
        const open = fileio.openSync(path, 0o2);
        fileio.readSync(open, contentBuffer);

        // 将二进制contentBuffer转换成zip对象,将zip对象中数据写入到指定目录
        var zip = new JSZip();
        let res
        if (!!password) {
            //@ts-ignore
            res = await zip.loadAsync(contentBuffer, { password: password })
        } else {
            res = await zip.loadAsync(contentBuffer)

        }
        let newPath = target;
        if (target == null) {
            newPath = await createNewFileName(path.replace(".zip", ""));
        }
        try {
            fileio.mkdirSync(newPath)
        } catch (err) {
        }
        for (let key in res.files) {
            if (res.files[key].dir) {
                try {
                    fileio.mkdirSync(newPath + "/" + res.files[key].name)
                } catch (err) {
                }
                continue;
            }
            let content = await res.file(res.files[key].name).async("arraybuffer")
            let writer = fileio.openSync(newPath + "/" + res.files[key].name, 0o102, 0o666)
            fileio.writeSync(writer, content);
            fileio.closeSync(writer)
        }
        await fileio.close(open);
        return true;
    } catch (error) {
        return false
    }
}

/**
 * 指定文件夹路径压缩文件夹zip方法
 *
 * @since 7
 * @permission N
 * @param {string} path - folder path.
 * @param {string} dest -path and file name after the .zip file is generated.
 * @returns {void | Promise<boolean>} callback return Promise otherwise return true or false.
 */
export async function zipCompress(path: string, dest: string): Promise<boolean> {
    try {
        var obj = {};
        await dirFor(path, path, obj);
        var zip = new JSZip();
        for (let objKey in obj) {
            zip.file(objKey, obj[objKey]);
        }
        const content = await zip.generateAsync({ type: "arraybuffer" });
        const open = fileio.openSync(dest, 0o102, 0o666);
        fileio.writeSync(open, content);
        fileio.closeSync(open);
        return true;
    } catch (error) {
        return false;
    }
}

/**
 * 压缩时，遍历文件夹下所有的文件，生成zip需要的压缩参数obj对象
 *
 * @since 7
 * @permission N
 * @param {string} root - Path of the folder to be compressed, which is used as the root directory.
 * @param {string} path - Path of the branch folder during traversal, starting with the root directory.
 * @param {any} obj - Traverse all files in the folder to generate the obj object of the compression parameter required
 * by the uzip tool.
 * @returns {void | Promise<void>} no callback return Promise otherwise return void.
 * @throws {TypedError | Error} Parameter check failed
 */
async function dirFor(root: string, path: string, obj: any): Promise<void> {
    let dir = fileio.opendirSync(path);
    let diRent;
    diRent = await dir.read();
    if (diRent.name != "") {
        if (diRent.isFile()) {
            var objFileName;
            let pathName = path.replace(root, "");
            if (pathName == "") {
                objFileName = diRent.name;
            } else {
                // 去除多余第一个"/"
                if (pathName.substring(0, 1) == "/") {
                    objFileName = pathName.substring(1, pathName.length) + "/" + diRent.name;
                } else {
                    objFileName = pathName + "/" + diRent.name;
                }
            }
            let filePath;
            if (path.substring(path.length - 1, path.length) == "/") {
                filePath = path + diRent.name;
            } else {
                filePath = path + "/" + diRent.name;
            }
            const stat = fileio.statSync(filePath);
            const reader = fileio.openSync(filePath, 0o2);
            const buf = new ArrayBuffer(stat.size);
            fileio.readSync(reader, buf);
            obj[objFileName] = buf;
            fileio.closeSync(reader);
        } else {
            if (path.substring(path.length - 1, path.length) == "/") {
                await dirFor(root, path + diRent.name, obj)
            } else {
                await dirFor(root, path + "/" + diRent.name, obj)
            }
        }
    }
    dir.closeSync();
}

async function createNewFileName(path): Promise<string> {
    let stat
    try {
        stat = fileio.statSync(path);
    } catch (err) {
        return path;
    }
    if (stat.isDirectory() || stat.isFile()) {
        // 防止根目录下文件夹名已存在
        path = await createNewFileName(path + "1")
    }
    return path;
}