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
    return cb(null);
  }

  // If an error occured like rate limiting or HTTP issue, we'll bubble up the error.
  if (err) {
    return cb(err);
  }
};

export function expressJwtSecret(options){
  if (options === null || options === undefined) {
    console.error('An options object must be provided when initializing expressJwtSecret');
  }

  const client = new JwksClient(options);
  const onError = options.handleSigningKeyError || handleSigningKeyError;

  const expressJwt7Provider = async (req, token) => {
    if (!token) { return; }
    const header = token.header;
    if (!header || !supportedAlg.includes(header.alg)) {
      return;
    }
    try {
      const key = await client.getSigningKey(header.kid);
      return key.publicKey || key.rsaPublicKey;
    } catch (err) {
      return new Promise((resolve, reject) => {
        onError(err, (newError) => {
          if (!newError) { return resolve(); }
          reject(newError);
        });
      });
    }
  };

  return function secretProvider(req, header, payload, cb) {
    //This function has 4 parameters to make it work with express-jwt@6
    //but it also supports express-jwt@7 which only has 2.
    if (arguments.length === 4) {
      expressJwt7Provider(req, { header })
        .then(key => {
          cb(key);
        }).catch(err => {
          cb(err);
        });

      return;
    }

    return expressJwt7Provider(req, arguments[1]);
  };
};
