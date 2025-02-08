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
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import { describe, it, expect } from '@ohos/hypium'
import { ElementType, isTag } from 'domelementtype'

export default function abilityTest() {
    describe('ActsAbilityTest', () => {
        it('isTag_ElementType.CDATA', 0, () => {
            expect(isTag({
                type: ElementType.CDATA
            })).assertFalse()
        })

        it('isTag_ElementType.Root', 0, () => {
            expect(isTag({
                type: ElementType.Root
            })).assertFalse()
        })

        it('isTag_ElementType.Text', 0, () => {
            expect(isTag({
                type: ElementType.Text
            })).assertFalse()
        })

        it('isTag_ElementType.Directive', 0, () => {
            expect(isTag({
                type: ElementType.Directive
            })).assertFalse()
        })

        it('isTag_ElementType.Script', 0, () => {
            expect(isTag({
                type: ElementType.Script
            })).assertTrue()
        })

        it('isTag_ElementType.Style', 0, () => {
            expect(isTag({
                type: ElementType.Style
            })).assertTrue()
        })

        it('isTag_ElementType.Tag', 0, () => {
            expect(isTag({
                type: ElementType.Tag
            })).assertTrue()
        })

        it('isTag_ElementType.Doctype', 0, () => {
            expect(isTag({
                type: ElementType.Doctype
            })).assertFalse()
        })


        it('isTag_ElementType.Comment', 0, () => {
            expect(isTag({
                type: ElementType.Comment
            })).assertFalse()
        })

        it('testNull', 0, () => {
            expect(isTag({
                type: null
            })).assertFalse()
        })

        it('testUndefined', 0, () => {
            expect(isTag({
                type: undefined
            })).assertFalse()
        })
    })
}