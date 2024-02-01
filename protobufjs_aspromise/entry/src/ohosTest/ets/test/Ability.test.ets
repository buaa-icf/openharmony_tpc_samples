/**
 *
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import { describe, expect, it } from '@ohos/hypium';
import asPromise from '@protobufjs/aspromise';

let ctx: ESObject = {};

export default function abilityTest() {
    describe('ActsAbilityTest', () => {

        it('resolve', 0, () => {
            let count = 0;
            let promise: Promise<ESObject> = asPromise(fn, ctx, 1, 2);
            promise.then((arg2: ESObject) => {
                expect(arg2).assertEqual(2)
                if (++count > 1) {
                    expect().assertFail()
                }
            }).catch((err: ESObject) => {
                expect().assertFail()
            });
        })

        it('resolveTwice', 0, () => {
            let count = 0;
            let promise: Promise<ESObject> = asPromise(fn1, ctx, 1, 2);
            promise.then((arg2: ESObject) => {
                expect(arg2).assertEqual(2)
                if (++count > 1) {
                    expect().assertFail()
                }
            }).catch((err: ESObject) => {
                expect().assertFail()
            });
        })

        it('reject', 0, () => {
            let count = 0;
            let promise: Promise<ESObject> = asPromise(fn2, ctx, 1, 2);
            promise.then(() => {
                expect().assertFail()
            }).catch((err: ESObject) => {
                expect(err).assertEqual(1)
                if (++count > 1) {
                    expect().assertFail()
                }
            });
        })

        it('rejectTwice', 0, () => {
            let count = 0;
            let promise: Promise<ESObject> = asPromise(fn3, ctx, 1, 2);
            promise.then(() => {
                expect().assertFail()
            }).catch((err: ESObject) => {
                expect(err).assertEqual(1)
                if (++count > 1) {
                    expect().assertFail()
                }
            });
        })

        it('reject_error', 0, () => {

            let fn4: (error: Error | null, param1: ESObject, callback: Function) => ESObject = (error: Error | null, param1: ESObject, callback: Function): ESObject => {
                expect(arguments.length).assertEqual(0)
                throw new Error();
                return new Result()
            }

            let promise: Promise<ESObject> = asPromise(fn4, null);
            promise.then(() => {
                expect().assertFail()
            }).catch((err: ESObject) => {
                expect(true).assertTrue()
            });
        })

        it('reject_and_error', 0, () => {
            let fn4: (error: Error | null, param1: ESObject, callback: Function) => ESObject = (error: Error | null, param1: ESObject, callback: Function): ESObject => {
                callback(3);
                throw new Error("4");
                return new Result()
            }

            let count = 0;

            let promise: Promise<ESObject> = asPromise(fn4, null);
            promise.then(() => {
                expect().assertFail()
            }).catch((err: ESObject) => {
                expect(true).assertTrue()
                if (++count > 1) {
                    expect().assertFail();
                }
            });
        })
    })
}

function fn(error: Error | null, param1: ESObject, callback: Function) {
    expect(error).assertEqual(1)
    expect(param1).assertEqual(2)
    callback(null, param1)
    return new Result()
}

function fn1(error: Error | null, param1: ESObject, callback: Function) {
    expect(error).assertEqual(1)
    expect(param1).assertEqual(2)
    callback(null, param1);
    callback(null, error);
    return new Result()
}

function fn2(error: Error | null, param1: ESObject, callback: Function) {
    expect(error).assertEqual(1)
    expect(param1).assertEqual(2)
    callback(error)
    return new Result()
}

function fn3(error: Error | null, param1: ESObject, callback: Function) {
    expect(error).assertEqual(1)
    expect(param1).assertEqual(2)
    callback(error);
    callback(param1);
    return new Result()
}


class Result {
}
