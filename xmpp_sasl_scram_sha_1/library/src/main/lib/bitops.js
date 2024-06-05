/**
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE
 */

import { crypto, buffer } from "@ohos/node-polyfill/Index"
import xor from './xor'

export function H(text) {
    return crypto.createHash('sha1').update(text).digest();
};

export function HMAC(key, msg) {
    return crypto.createHmac('sha1', key).update(msg).digest();
};

export function Hi(text, salt, iterations) {
    var ui1 = HMAC(text, buffer.Buffer.concat([salt, new buffer.Buffer([0, 0, 0, 1], 'binary')]));
    var ui = ui1;
    for (var i = 0; i < iterations - 1; i++) {
        console.info(i)
        ui1 = HMAC(text, ui1);
        ui = xor(ui, ui1);
    }
    return ui;
};

