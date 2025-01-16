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

"use strict";
import st from "../lib/stRuntime";
import w from "../lib/autoIndentWriter";
import { hilog } from "@kit.PerformanceAnalysisKit";

export class ProcessTemplate {
    private ststVersion: string = '1.0.0';
    get version() {
        return this.ststVersion;
    }

    processTemplate(compiledGroup: Function, data: object, templateName: string): string {
        let template = templateName;
        // 直接导入compiledGroup 即编译好的getInstance
        var t, g, p, writer;

        g = st.loadGroup(compiledGroup);
        // @ts-ignore
        writer = w.makeWriter();

        t = g.getTemplate(template);
        for (p in data) {
            if (data.hasOwnProperty(p)) {
                t.add(p, data[p]);
            }
        }
        t.write(writer);
        hilog.info(0x0001, "StringTemplate:", "process template result %{public}s", writer.toString());
        return writer.toString();
    }
}