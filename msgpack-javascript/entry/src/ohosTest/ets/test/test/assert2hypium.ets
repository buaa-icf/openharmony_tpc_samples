/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

var strictEqual = function(src,dst,info?){
    expect(src).assertEqual(dst)
    if(info){
        console.log(info)
    }
}

var deepStrictEqual = function(src,dst,info?){
    expect(src).assertDeepEquals(dst)
    if(info){
        console.log(info)
    }
}
var notDeepStrictEqual = function(src,dst,info?){
    expect(src).not().assertDeepEquals(dst)
    if(info){
        console.log(info)
    }
}

var context = function (string,callback){
    callback();
}

var throws = function (srcCallback, dstInfo){
    try{
        srcCallback();
        // 如果不报错就是用例失败
        expect(false).assertTrue()
    }catch (err){
        // 报错
        expect(true).assertTrue()
        console.log("err.msg="+err.message)
        console.log("dstInfo="+dstInfo)
    }
}




var assert = {strictEqual,deepStrictEqual,notDeepStrictEqual,context,throws }

export default assert;