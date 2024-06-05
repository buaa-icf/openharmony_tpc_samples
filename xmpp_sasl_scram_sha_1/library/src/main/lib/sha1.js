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

import { buffer } from "@ohos/node-polyfill"
import * as bitops from "./bitops"
import * as utils from "./utils"
import XOR from "./xor"

var RESP = {};
var CLIENT_KEY = 'Client Key';
var SERVER_KEY = 'Server Key';


function Mechanism(options) {
    options = options || {};
    this._genNonce = options.genNonce || utils.genNonce;
    this._stage = 'initial';
}

// Conform to the SASL lib's expectations
Mechanism.Mechanism = Mechanism;


Mechanism.prototype.name = 'SCRAM-SHA-1';
Mechanism.prototype.clientFirst = true;


Mechanism.prototype.response = function (cred) {
    return RESP[this._stage](this, cred);
};

Mechanism.prototype.challenge = function (chal) {
    var values = utils.parse(chal);

    this._salt = new buffer.Buffer(values.s || '', 'base64');
    this._iterationCount = parseInt(values.i, 10);
    this._nonce = values.r;
    this._verifier = values.v;
    this._error = values.e;
    this._challenge = chal;
    return this;
};


RESP.initial = function (mech, cred) {
    mech._cnonce = mech._genNonce();

    var authzid = '';
    if (cred.authzid) {
        authzid = 'a=' + utils.saslname(cred.authzid);
    }

    mech._gs2Header = 'n,' + authzid + ',';

    var nonce = 'r=' + mech._cnonce;
    var username = 'n=' + utils.saslname(cred.username || '');

    mech._clientFirstMessageBare = username + ',' + nonce;
    var result = mech._gs2Header + mech._clientFirstMessageBare;

    mech._stage = 'challenge';

    return result;
};


RESP.challenge = function (mech, cred) {
    var gs2Header = new buffer.Buffer(mech._gs2Header).toString('base64');

    mech._clientFinalMessageWithoutProof = 'c=' + gs2Header + ',r=' + mech._nonce;

    var saltedPassword, clientKey, serverKey;

    // If our cached salt is the same, we can reuse cached credentials to speed
    // up the hashing process.
    if (cred.salt && buffer.Buffer.compare(cred.salt, mech._salt) === 0) {
        if (cred.clientKey && cred.serverKey) {
            clientKey = cred.clientKey;
            serverKey = cred.serverKey;
        } else if (cred.saltedPassword) {
            saltedPassword = cred.saltedPassword;
            clientKey = bitops.HMAC(saltedPassword, CLIENT_KEY);
            serverKey = bitops.HMAC(saltedPassword, SERVER_KEY);
        }
    } else {
        saltedPassword = bitops.Hi(cred.password || '', mech._salt, mech._iterationCount);
        clientKey = bitops.HMAC(saltedPassword, CLIENT_KEY);
        serverKey = bitops.HMAC(saltedPassword, SERVER_KEY);
    }
    var storedKey = bitops.H(clientKey);
    var authMessage = mech._clientFirstMessageBare + ',' +
                      mech._challenge + ',' +
                      mech._clientFinalMessageWithoutProof;
    var clientSignature = bitops.HMAC(storedKey, authMessage);
    var clientProof = XOR(clientKey, clientSignature).toString('base64');
    mech._serverSignature = bitops.HMAC(serverKey, authMessage);
    var result = mech._clientFinalMessageWithoutProof + ',p=' + clientProof;

    mech._stage = 'final';

    mech.cache = {
        salt: mech._salt,
        saltedPassword: saltedPassword,
        clientKey: clientKey,
        serverKey: serverKey
    };

    return result;
};

RESP.final = function () {
    // TODO: Signal errors
    return '';
};



export  default Mechanism  ;
