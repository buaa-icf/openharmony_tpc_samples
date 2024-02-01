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

import asPromise from '@protobufjs/aspromise'

let result = ""

@Entry
@Component
struct Index {
    @State message: string = ''

    build() {
        Row() {
            Column() {
                Button("resolve")
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                    .onClick(event => {
                        result = ""
                        let that = this
                        let ctx: ESObject = {};
                        let promise: Promise<ESObject> = asPromise(this.fn, ctx, 1, 2);
                        promise.then((arg2: ESObject) => {
                            result += "function should be resolved with arg2 = " + arg2
                            that.message = result
                        }).catch((err: ESObject) => {
                            result += "function should not be rejected (" + err + ")"
                            that.message = result
                        });
                    })

                Button("reject")
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                    .margin({ top: 20 })
                    .onClick(event => {
                        result = ""
                        let that = this
                        let ctx: ESObject = {};
                        let promise: Promise<ESObject> = asPromise(this.fn1, ctx, 1, 2);
                        promise.then(() => {
                            result += "promise should not be resolved"
                            that.message = result
                        }).catch((err: ESObject) => {
                            result += "promise should be rejected with err = " + err
                            that.message = result
                        });
                    })

                Button("resolve twice")
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                    .margin({ top: 20 })
                    .onClick(event => {
                        result = ""
                        let count: number = 0;
                        let that = this
                        let ctx: ESObject = {};
                        let promise: Promise<ESObject> = asPromise(this.fn2, ctx, 1, 2);
                        promise.then((arg2: ESObject) => {
                            result += "promise should be resolved with arg2 = " + arg2
                            if (++count > 1) {
                                result += "promise should not be resolved twice"
                            }
                            that.message = result
                        }).catch((err: ESObject) => {
                            result += "promise should not be rejected  " + err
                            that.message = result
                        });
                    })

                Button("reject twice")
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                    .margin({ top: 20 })
                    .onClick(event => {
                        result = ""
                        let that = this
                        let count: number = 0;
                        let ctx: ESObject = {};
                        let promise: Promise<ESObject> = asPromise(this.fn3, ctx, 1, 2);
                        promise.then(() => {
                            result += "promise should not be resolved"
                            that.message = result
                        }).catch((err: ESObject) => {
                            result += "promise should be rejected with err = " + err
                            if (++count > 1) {
                                result += "promise should not be rejected twice"
                            }
                            that.message = result
                        });
                    })

                Button("reject error")
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                    .margin({ top: 20 })
                    .onClick(event => {
                        result = ""
                        let that = this
                        let promise: Promise<ESObject> = asPromise(this.fn4, null,null,null);
                        promise.then(() => {
                            result += "promise should not be resolved"
                            that.message = result
                        }).catch((err: ESObject) => {
                            result += "promise should be rejected with err = " + err
                            that.message = result
                        });
                    })

                Button("reject and error")
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                    .margin({ top: 20 })
                    .onClick(event => {
                        result = ""
                        let that = this
                        let count: number = 0;
                        let promise: Promise<ESObject> = asPromise(this.fn5, null);
                        promise.then(() => {
                            result += "promise should not be resolved"
                            that.message = result
                        }).catch((err: ESObject) => {
                            result += "promise should be rejected with err = " + err
                            if (++count > 1){
                                result+="promise should not be rejected twice"
                            }
                            that.message = result
                        });
                    })

                Text(this.message)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .height("50%")

            }
            .width('100%')
        }
        .height('100%')
    }

    fn(error: Error | null, param1: ESObject, callback: Function) {
        result += "function should be called with this = ctx\r\n"
        result += "function should be called with arg1 = " + error + "\r\n"
        result += "function should be called with arg2 = " + param1 + "\r\n"
        callback(null, param1)

        class test {
        }

        return new test()
    }

    fn1(error: Error | null, param1: ESObject, callback: Function) {
        result += "function should be called with this = ctx\r\n"
        result += "function should be called with arg1 = " + error + "\r\n"
        result += "function should be called with arg2 = " + param1 + "\r\n"
        callback(error)

        class test {
        }

        return new test()
    }

    fn2(error: Error | null, param1: ESObject, callback: Function) {
        result += "function should be called with this = ctx\r\n"
        result += "function should be called with arg1 = " + error + "\r\n"
        result += "function should be called with arg2 = " + param1 + "\r\n"
        callback(null, param1)
        callback(null, error)

        class test {
        }

        return new test()
    }

    fn3(error: Error | null, param1: ESObject, callback: Function) {
        result += "function should be called with this = ctx\r\n"
        result += "function should be called with arg1 = " + error + "\r\n"
        result += "function should be called with arg2 = " + param1 + "\r\n"
        callback(error)
        callback(param1)

        class test {
        }

        return new test()
    }

    fn4(error: Error | null, param1: ESObject, callback: Function) {
        if (arguments.length === 1 && callback instanceof Function) {
            result += "unction should be called with just a callback\r\n"
            this.message = result
            throw new Error("3")
        }

        class test {
        }

        return new test()
    }

    fn5(error: Error | null, param1: ESObject, callback: Function) {
        callback(3)
        throw new Error("4")
        class test {
        }
        return new test()
    }
}

