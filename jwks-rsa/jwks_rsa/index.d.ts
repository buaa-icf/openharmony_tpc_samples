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

declare namespace Jwks {

  class JwksClient {
    constructor(options: Options);

    /**
     * get all keys data.
     *
     * @return all keys data from http.
     * @since 9
     */
    getKeys(): Promise<unknown>;

    /**
     * get all SigningKeys. Convert keys data into SigningKey
     *
     * @return all SigningKeys.
     * @since 9
     */
    getSigningKeys(): Promise<SigningKey[]>;

    /**
     * Obtain the SigningKey based on the id.
     *
     * @param The unique id of jwk.
     * @return SigningKey.
     * @since 9
     */
    getSigningKey(kid: string | null | undefined): Promise<SigningKey>;
  }

  /**
   * HTTP request header.
   */
  interface Headers {
    [key: string]: string;
  }

  /**
   * options to create JwksClient.
   */
  interface Options {
    /**
     * URL for initiating an HTTP request.
     */
    jwksUri: string;
    /**
     * whether to use rateLimit.
     */
    rateLimit?: boolean;
    /**
     * whether to use cache.
     */
    cache?: boolean;
    /**
     * Cache size.
     */
    cacheMaxEntries?: number;
    /**
     * Cache time.
     */
    cacheMaxAge?: number;
    /**
     * Number of requests per minute.
     */
    jwksRequestsPerMinute?: number;
    /**
     * HTTP request header.
     */
    requestHeaders?: Headers;
    /**
     * timeout period. The default value is 30,000, in ms.
     */
    timeout?: number;
  }

  interface SigningKey {
    /**
     * The unique id of jwk.
     */
    kid: string;
    /**
     * The algorithm id of jwk.
     */
    algorithm: string;
    /**
     * The type id of jwk.
     */
    type: string;
    /**
     * The usage id of jwk.
     */
    usage: string;
    /**
     * Obtain the PublicKey.
     *
     * @return PublicKey {@link cryptoFramework.PubKey}.
     * @since 9
     */
    getPublicKey(): cryptoFramework.PubKey;
  }

  /**
   * class to handle ArgumentError.
   */
  class ArgumentError extends Error {
    name: 'ArgumentError';
    constructor(message: string);
  }

  /**
   * class to handle JwksError.
   */
  class JwksError extends Error {
    name: 'JwksError';
    constructor(message: string);
  }

  /**
   * class to handle JwksRateLimitError.
   */
  class JwksRateLimitError extends Error {
    name: 'JwksRateLimitError';
    constructor(message: string);
  }

  /**
   * class to handle SigningKeyNotFoundError.
   */
  class SigningKeyNotFoundError extends Error {
    name: 'SigningKeyNotFoundError';
    constructor(message: string);
  }
}

export default Jwks;