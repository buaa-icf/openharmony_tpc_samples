/**
 *  The MIT License (MIT)
 *
 *  Copyright (c) 2022 HUAWEI
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */
import cryptoFramework from '@ohos.security.cryptoFramework';
import util from '@ohos.util';
import SigningKeyNotFoundError from '../common/errors/SigningKeyNotFoundError'

const ALGORITHM_RSA = "RSA";
const ALGORITHM_RSA2048 = "RSA2048";
const ALGORITHM_ELLIPTIC_CURVE = "EC";
const ALGORITHM_ECC256 = "ECC256";
const ALGORITHM_ECC384 = "ECC384";
const ALGORITHM_ECC512 = "ECC512";
const ELLIPTIC_CURVE_TYPE_P256 = "P-256";
const ELLIPTIC_CURVE_TYPE_P384 = "P-384";
const ELLIPTIC_CURVE_TYPE_P512 = "P-512";

export function retrieveSigningKeys(keys) {

    return keys.map((key) => {
        return {
            kid: key.kid,
            algorithm: key.alg,
            type: key.kty,
            usage: key.use,
            x5u: key.x5u,
            x5c: key.x5c,
            x5t: key.x5t,
            async getPublicKey() {
                return await convertKey(key);
            }
        };
    });
    return keys
}

async function convertKey(key) {
    let base64 = new util.Base64();
    let asyKeyGenerator, pubKeyBlob;
    switch(key.kty) {
        case ALGORITHM_RSA:
            let n = base64.decodeSync(key.n)
            let e = base64.decodeSync(key.e)
            pubKeyBlob = getRsaPubData(n, e) //根据n(模值)和e(指数)生成公钥材料
            asyKeyGenerator = cryptoFramework.createAsyKeyGenerator(ALGORITHM_RSA2048);
            break;
        case ALGORITHM_ELLIPTIC_CURVE:
            let x = base64.decodeSync(key.x);
            let y = base64.decodeSync(key.y);
            pubKeyBlob = new Uint8Array(x.length + y.length + 1)
            pubKeyBlob.set([0x04]);
            pubKeyBlob.set(x, 1);
            pubKeyBlob.set(y, x.length + 1)
            switch(key.crv) {
                case ELLIPTIC_CURVE_TYPE_P256:
                    asyKeyGenerator = cryptoFramework.createAsyKeyGenerator(ALGORITHM_ECC256);
                    break;
                case ELLIPTIC_CURVE_TYPE_P384:
                    asyKeyGenerator = cryptoFramework.createAsyKeyGenerator(ALGORITHM_ECC384);
                    break;
                case ELLIPTIC_CURVE_TYPE_P512:
                    asyKeyGenerator = cryptoFramework.createAsyKeyGenerator(ALGORITHM_ECC512);
                    break;
                default:
                    throw new SigningKeyNotFoundError("Invalid or unsupported curve type " + key.crv);
                    break;
            }
            break;
        default:
            throw new SigningKeyNotFoundError("The key type of " + key.kty + " is not supported");
            break;
    }
    try {
        //根据秘钥材料生成秘钥
        let keyPair = await asyKeyGenerator.convertKey({ data: pubKeyBlob }, { data: pubKeyBlob });
        let publicKey = keyPair.pubKey;
        return publicKey;
    } catch (err) {
        throw new SigningKeyNotFoundError("convert key err = " + err);
    }

}

function getRsaPubData(nVal, eVal) {
    let eLen = eVal.length;
    let nLen = nVal.length;
    let keySize = 2048;
    let result = new Uint8Array(nLen + eLen + 16)
    let offset = 0;
    result.set(number2Uint8Array(keySize), offset)
    offset += 4;
    result.set(number2Uint8Array(nLen), offset)
    offset += 4
    result.set(number2Uint8Array(eLen), offset)
    offset += 4
    result.set(number2Uint8Array(0), offset)
    offset += 4
    result.set(nVal, offset)
    offset += nLen
    result.set(eVal, offset)
    console.info('length = ' + result.length + '; result = ' + result)
    return result;
}

function number2Uint8Array(val) {
    //return new Uint8Array([(val >> 24) & 0xff, (val >> 16) & 0xff, (val >> 8) & 0xff, val & 0xff]); //big endian
    return new Uint8Array([val & 0xff, (val >> 8) & 0xff, (val >> 16) & 0xff, (val >> 24) & 0xff]); //little endian
}


