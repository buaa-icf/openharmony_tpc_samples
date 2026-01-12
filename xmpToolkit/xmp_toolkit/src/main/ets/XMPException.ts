/*
Copyright (c) 2026 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/**
 * This exception wraps all errors that occur in the XMP Toolkit.
 */
export default  class XMPException extends Error {
    /** the errorCode of the XMP toolkit */
    private errorCode: number;

    /**
     * Constructs an exception with a message and an error code. 
     * @param message the message
     * @param errorCode the error code
     */
    // constructor(message: string, errorCode: number) {
    //     super(message);
    //     this.errorCode = errorCode;
    //     this.name = 'XMPException';
    // }

    /**
     * Constructs an exception with a message, an error code and a <code>Throwable</code>
     * @param message the error message.
     * @param errorCode the error code
     * @param t the exception source
     */
    constructor(message: string, errorCode: number, t?: Error) {
        super(message);
        this.errorCode = errorCode;
        this.name = 'XMPException';
    }

    /**
     * @return Returns the errorCode.
     */
    public getErrorCode(): number {
        return this.errorCode;
    }
}

