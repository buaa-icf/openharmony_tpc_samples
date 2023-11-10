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
const { JwksClient } = require('../JwksClient');
const supportedAlg = require('./config');

const handleSigningKeyError = (err, cb) => {
  // If we didn't find a match, can't provide a key.
  if (err && err.name === 'SigningKeyNotFoundError') {
    return cb(err, null, null);
  }

  // If an error occured like rate limiting or HTTP issue, we'll bubble up the error.
  if (err) {
    return cb(err, null, null);
  }
};

/**
 * Call hapiJwt2Key as a Promise
 * @param {object} options 
 * @returns
 */
export function hapiJwt2KeyAsync(options) {
  const secretProvider = this.hapiJwt2Key(options);
  return function(decoded) {
    return new Promise((resolve, reject) => {
      const cb = (err, key) => {
          (!key || err) ? reject(err) : resolve({ key });
      };
      secretProvider(decoded, cb);
    });
  };
}

export function hapiJwt2Key(options) {
  if (options === null || options === undefined) {
    console.error('An options object must be provided when initializing hapiJwt2Key');
  }

  const client = new JwksClient(options);
  const onError = options.handleSigningKeyError || handleSigningKeyError;

  return function secretProvider(decoded, cb) {
    // We cannot find a signing certificate if there is no header (no kid).
    if (!decoded || !decoded.header) {
      return cb(new Error('Cannot find a signing certificate if there is no header'), null, null);
    }

    if (!supportedAlg.includes(decoded.header.alg)) {
      return cb(new Error('Unsupported algorithm ' + decoded.header.alg + ' supplied.'), null, null);
    }

    client.getSigningKey(decoded.header.kid)
      .then(key => {
        return cb(null, key.publicKey || key.rsaPublicKey, key);
      }).catch(err => {
        return onError(err, (newError) => cb(newError, null, null));
      });
  };
};
