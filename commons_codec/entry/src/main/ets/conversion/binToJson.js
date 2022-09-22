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
export function strToArr(str) {
    var rs = [];
    ([].slice.call(str)).forEach(function (char) {
        rs.push(char.charCodeAt(0).toString(2));
    });

    return rs;
}

/**
 * 字符串转16进制
 * @param str
 */
export function strToHexCharCode(str) {
    if (str === "")
    return "";
    var hexCharCode = [];
    hexCharCode.push("0x");
    for (var i = 0; i < str.length; i++) {
        hexCharCode.push((str.charCodeAt(i)).toString(16));
    }
    return hexCharCode.join("");
}


/**
 * 16进制转字符串
 * @param hexCharCodeStr
 */
export function hexCharCodeToStr(hexCharCodeStr) {
    var trimedStr = hexCharCodeStr.trim();
    var rawStr =
            trimedStr.substr(0, 2).toLowerCase() === "0x"
            ?
        trimedStr.substr(2)
            :
            trimedStr;
    var len = rawStr.length;
    if (len % 2 !== 0) {
        alert("Illegal Format ASCII Code!");
        return "";
    }
    var curCharCode;
    var resultStr = [];
    for (var i = 0; i < len; i = i + 2) {
        curCharCode = parseInt(rawStr.substr(i, 2), 16); // ASCII Code Value
        resultStr.push(String.fromCharCode(curCharCode));
    }
    return resultStr.join("");
}


export function urlEncode(str) {

    return encodeURIComponent(str);
}


export function urlDecode(str) {

    return decodeURIComponent(str);
}