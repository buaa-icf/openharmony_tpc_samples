/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

// Not exported from index
/** @private */
export class TextMessageFormat {
    public static RecordSeparatorCode = 0x1e;
    public static RecordSeparator = String.fromCharCode(TextMessageFormat.RecordSeparatorCode);

    public static write(output: string): string {
        return `${output}${TextMessageFormat.RecordSeparator}`;
    }

    public static parse(input: string): string[] {
        if (input[input.length - 1] !== TextMessageFormat.RecordSeparator) {
            throw new Error("Message is incomplete.");
        }

        const messages = input.split(TextMessageFormat.RecordSeparator);
        messages.pop();
        return messages;
    }
}
