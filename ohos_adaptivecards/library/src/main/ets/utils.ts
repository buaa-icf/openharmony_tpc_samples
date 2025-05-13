// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
import * as Enums from "./enums";
import * as Shared from "./shared";
import { FrameNode } from "@kit.ArkUI";


export function isInternetExplorer(): boolean {
    return false
}

export function isMobileOS(): boolean {
    return true
}

/**
 * Generate a UUID prepended with "__ac-"
 */
export function generateUniqueId(): string {
    return "__ac-" + Shared.UUID.generate();
}

// 这里应该是framenode的类型 先用esobject顶  后续换掉
export function appendChild(node: ESObject, child: ESObject | undefined) {
    if (child) {
        node.appendChild(child);
    }
}

export function parseString(obj: ESObject, defaultValue?: string): string | undefined {
    return typeof obj === "string" ? obj : defaultValue;
}

export function parseNumber(obj: ESObject, defaultValue?: number): number | undefined {
    return typeof obj === "number" ? obj : defaultValue;
}

export function DeleteRecord(source: Record<any, any>, key: any): Record<any, any> {
    delete source[key];
    return source;
}

export function parseBool(value: ESObject, defaultValue?: boolean): boolean | undefined {
    if (typeof value === "boolean") {
        return value;
    } else if (typeof value === "string") {
        switch (value.toLowerCase()) {
            case "true":
                return true;
            case "false":
                return false;
            default:
                return defaultValue;
        }
    }

    return defaultValue;
}

export function getEnumValueByName(
    enumType:Record< number , string>,
    name: string
): number | undefined {
    // eslint-disable-next-line guard-for-in
    for (let key of Object.entries(enumType)) {
        const keyAsNumber = parseInt(key[0], 10);

        if (keyAsNumber >= 0) {
            const value = enumType[Number(key[0])];

            if (value && typeof value === "string" && value.toLowerCase() === name.toLowerCase()) {
                return keyAsNumber;
            }
        }
    }

    return undefined;
}

export function parseEnum(
    enumType: Record< number , string>,
    name: string,
    defaultValue?: number
): number | undefined {
    if (!name) {
        return defaultValue;
    }

    const enumValue = getEnumValueByName(enumType, name);

    return enumValue !== undefined ? enumValue : defaultValue;
}

export function stringToCssColor(color: string | undefined): string | undefined {
    if (color) {
        const regEx = /#([0-9A-F]{2})([0-9A-F]{2})([0-9A-F]{2})([0-9A-F]{2})?/gi;
        const matches = regEx.exec(color);

        if (matches && matches[4]) {
            const a = parseInt(matches[1], 16) / 255;
            const r = parseInt(matches[2], 16);
            const g = parseInt(matches[3], 16);
            const b = parseInt(matches[4], 16);

            return "rgba(" + r + "," + g + "," + b + "," + a + ")";
        }
    }

    return color;
}

function truncateWorker(
    element: FrameNode,
    maxHeight: number,
    fullText: string,
    truncateAt: (text: string, idx: number) => void,
    lineHeight?: number
) {
    const fits = () => {
        // Allow a one pixel overflow to account for rounding differences
        // between browsers
        // 这里有替换
        return maxHeight - element.getPositionToWindow().y >= -1.0;
    };

    if (fits()) {
        return;
    }

    const breakableIndices = findBreakableIndices(fullText);
    let lo = 0;
    let hi = breakableIndices.length;
    let bestBreakIdx = 0;

    // Do a binary search for the longest string that fits
    while (lo < hi) {
        const mid = Math.floor((lo + hi) / 2);
        truncateAt(fullText, breakableIndices[mid]);

        if (fits()) {
            bestBreakIdx = breakableIndices[mid];
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }

    truncateAt(fullText, bestBreakIdx);

    // If we have extra room, try to expand the string letter by letter
    // (covers the case where we have to break in the middle of a long word)
    if (lineHeight && maxHeight - element.getPositionToWindow().y >= lineHeight - 1.0) {
        let idx = findNextCharacter(fullText, bestBreakIdx);

        while (idx < fullText.length) {
            truncateAt(fullText, idx);

            if (fits()) {
                bestBreakIdx = idx;
                idx = findNextCharacter(fullText, idx);
            } else {
                break;
            }
        }

        truncateAt(fullText, bestBreakIdx);
    }
}

// 这里一定是有问题的 只是先用别的顶下  后续修改
export function truncateText(element: FrameNode, maxHeight: number, lineHeight?: number) {
    truncateWorker(
        element,
        maxHeight,
        element.getNodeType(),
        (text: string, idx: number) => {
        },
        lineHeight
    );
}

function findBreakableIndices(html: string): number[] {
    const results: number[] = [];
    let idx = findNextCharacter(html, -1);

    while (idx < html.length) {
        if (html[idx] === " ") {
            results.push(idx);
        }

        idx = findNextCharacter(html, idx);
    }

    return results;
}

function findNextCharacter(html: string, currIdx: number): number {
    currIdx += 1;

    // If we found the start of an HTML tag, keep advancing until we get
    // past it, so we don't end up truncating in the middle of the tag
    while (currIdx < html.length && html[currIdx] === "<") {
        while (currIdx < html.length && html[currIdx++] !== ">") {
            continue;
        }
    }

    return currIdx;
}

export function getScrollX(): number {
    return 0;
}

export function getScrollY(): number {
    return 0;
}

export function clearElementChildren(element: FrameNode) {
    while (element.getFirstChild()) {
        element.removeChild(element.getFirstChild());
    }
}

export function addCancelSelectActionEventHandler(element: FrameNode) {

}

