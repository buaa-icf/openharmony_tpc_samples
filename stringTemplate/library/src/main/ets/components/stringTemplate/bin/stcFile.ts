/**
 * BSD License
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *  list of conditions and the following disclaimer.
 *
 * * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * * Neither the name Facebook nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { path } from "@ohos/node-polyfill";
import { fileIo as fs } from '@kit.CoreFileKit';
import stc from "../compiler/stc";
import group from "../compiler/group";
import { hilog } from "@kit.PerformanceAnalysisKit";

export class Stc {
    static rawFilePath: string = "";
    private inputPath: string = "";
    private delimitersStat: string = "$";
    private delimitersEnd: string = "$";
    private raw: boolean = false;
    private stcVersion: string = "1.0.0";

    set path(inputPath: string) {
        this.inputPath = inputPath;
    }
    get path(): string {
        return this.inputPath;
    }
    set statDelimiters(delimitersStat: string) {
        this.delimitersStat = delimitersStat;
    }
    get statDelimiters(): string {
        return this.delimitersStat;
    }
    set endDelimiters(delimitersEnd: string) {
        this.delimitersEnd = delimitersEnd;
    }
    get endDelimiters(): string {
        return this.delimitersEnd;
    }
    get version() {
        return this.stcVersion;
    }

    private callback(err) {
        if (err) {
            hilog.info(0x0001, "StringTemplate:", "compiled error: %{public}s", err.message);
            return;
        }
        hilog.info(0x0001, "StringTemplate:", "%{public}s", "Compiled file.");
    }

    compile(inputPath: string){
        Stc.rawFilePath = inputPath;
        this.inputPath = inputPath;
        let options = {
            encoding: 'utf-8',
            verbose: false,
            outputAST: false,
            output: "",
            minify: false,
            raw: false,
            delimiterStartChar: this.delimitersStat,
            delimiterStopChar: this.delimitersEnd
        };
        let ext, stat;

        try {
            stat = fs.statSync(inputPath);
        } catch (ex) {
            if (ex.code === "ENOENT") {
                hilog.info(0x0001, "StringTemplate:", "Error: No such file or directory ' %{public}s '." , inputPath);
            } else if (ex.code === "EACCES") {
                hilog.info(0x0001, "StringTemplate:", "Error: Permission denied to access ' %{public}s '.", inputPath);
            } else {
                hilog.info(0x0001, "StringTemplate:", "%{public}s", ex.message);
            }
        }
        if (stat.isDirectory()) {
            if (this.raw) {
                stc.compileRawGroupDir(inputPath, options, this.callback);
            } else {
                stc.compileGroupDir(inputPath, options, this.callback);
            }
        } else {
            ext = path.extname(inputPath);
            if (ext === group.GROUP_FILE_EXTENSION) {
                stc.compileGroupFile(inputPath, options, this.callback);
            } else if (ext === group.TEMPLATE_FILE_EXTENSION) {
                stc.compileGroupFile(inputPath, options, this.callback);
            } else {
                hilog.info(0x0001, "StringTemplate:", "Error: Unrecognized file extension ' %{public}s '.", inputPath);
            }
        }

    }
}