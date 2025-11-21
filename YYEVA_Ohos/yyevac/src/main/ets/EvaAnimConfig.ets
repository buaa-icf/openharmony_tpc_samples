/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { PointRect } from '../ets/util/PointRect'
import { ELog } from './util/ELog'
import { EvaConstant } from './util/EvaConstant'

export class EvaAnimConfig {
    static readonly TAG: string = `EvaAnimConfig`
    width: number = 0
    height: number = 0
    videoWidth: number = 0
    videoHeight: number = 0
    descript: Descript | null = null //视频描述信息
    effects: Array<Effect> | null = null //动态元素的遮罩描述信息
    datas: Array<Datas> | null = null //每一帧的动态元素位置信息
    isDefaultConfig: boolean = false // 没有effectmp4json配置时默认逻辑
    fps: number = 0
    alphaPointRect: PointRect = new PointRect(0, 0, 0, 0)
    rgbPointRect: PointRect = new PointRect(0, 0, 0, 0)
    defaultVideoMode: number = EvaConstant.VIDEO_MODE_SPLIT_HORIZONTAL_REVERSE
    jsonConfig: Record<string, Object> | null = null
    isMix: boolean = false

    /**
     * 解析动画配置
     * @returns 解析是否成功，失败按默认配置走
     */
    parse(json: Record<string, Object>): boolean {
        try {
            const descriptObj = json['descript'] as Record<string, Object>
            if (descriptObj) {
                this.descript = new Descript(
                    descriptObj['width'] as number,
                    descriptObj['height'] as number,
                    descriptObj['isEffect'] as boolean,
                    descriptObj['version'] as number,
                    this.getFrame(descriptObj['rgbFrame'] as number[]),
                    this.getFrame(descriptObj['alphaFrame'] as number[]),
                    descriptObj['fps'] as number ?? 30,
                    descriptObj['hasAudio'] as boolean ?? false,
                    descriptObj['hasBg'] as boolean ?? false
                )

                this.videoWidth = this.descript.width
                this.videoHeight = this.descript.height
                this.width = this.descript.rgbFrame.w
                this.height = this.descript.rgbFrame.h
                this.alphaPointRect = this.descript.alphaFrame
                this.rgbPointRect = this.descript.rgbFrame
                this.fps = this.descript.fps
            }

            const effectsArr = json['effect'] as Array<Record<string, Object>>
            if (effectsArr && effectsArr.length > 0) {
                this.effects = effectsArr.map(item => this.getEffect(item))
            }

            const datasArr = json['datas'] as Array<Record<string, Object>>
            if (datasArr && datasArr.length > 0) {
                this.datas = datasArr.map(item => this.getDatas(item))
            }

            this.isMix = this.effects != null && this.effects.length > 0 && this.datas != null && this.datas.length > 0
            return true
        } catch (err) {
            ELog.e(EvaAnimConfig.TAG, `${EvaAnimConfig.TAG} json parse fail: ${err}`)
            this.isMix = false
            return false
        }
    }

    getFrame(arr?: number[]): PointRect {
        if (!arr || arr.length < 4) {
            return new PointRect(0, 0, 0, 0)
        }
        return new PointRect(arr[0], arr[1], arr[2], arr[3])
    }

    getEffect(obj: Record<string, Object>): Effect {
        return new Effect(
            obj['effectWidth'] as number ?? 0,
            obj['effectHeight'] as number ?? 0,
            obj['effectId'] as number ?? 0,
            obj['effectTag'] as string ?? '',
            obj['effectType'] as string ?? '',
            obj['scaleMode'] as string ?? '',
            obj['fontColor'] as string ?? '#ffffff',
            obj['fontSize'] as number ?? 12,
            obj['textAlign'] as string ?? 'center'
        )
    }

    getDatas(obj: Record<string, Object>): Datas {
        const dataList: Array<Data> = []
        const frameIndex = obj['frameIndex'] as number ?? 0
        const dataArr = obj['data'] as Array<Record<string, Object>>
        if (dataArr && dataArr.length > 0) {
            for (let item of dataArr) {
                dataList.push(this.getData(item))
            }
        }
        return new Datas(frameIndex, dataList)
    }

    getData(obj: Record<string, Object>): Data {
        const renderFrame = this.getFrame(obj['renderFrame'] as number[])
        const effectId = obj['effectId'] as number ?? 0
        const outputFrame = this.getFrame(obj['outputFrame'] as number[])
        return new Data(renderFrame, effectId, outputFrame)
    }

    toString(): string {
        return `EvaAnimConfig(descript=${JSON.stringify(this.descript)}, effects=${JSON.stringify(this.effects)}, datas=${JSON.stringify(this.datas)})`
    }
}

export class Descript {
    public width: number;
    public height: number;
    public isEffect: boolean;
    public version: number;
    public rgbFrame: PointRect;
    public alphaFrame: PointRect;
    public fps: number;
    public hasAudio: boolean;
    public hasBg: boolean;

    constructor(
        width: number,
        height: number,
        isEffect: boolean,
        version: number,
        rgbFrame: PointRect,
        alphaFrame: PointRect,
        fps: number,
        hasAudio: boolean,
        hasBg: boolean
    ) {
        this.width = width;
        this.height = height;
        this.isEffect = isEffect;
        this.version = version;
        this.rgbFrame = rgbFrame;
        this.alphaFrame = alphaFrame;
        this.fps = fps;
        this.hasAudio = hasAudio;
        this.hasBg = hasBg;
    }
}

export class Effect {
    public effectWidth: number;
    public effectHeight: number;
    public effectId: number;
    public effectTag: string;
    public effectType: string;
    public scaleMode: string;
    public fontColor: string;
    public fontSize: number;
    public textAlign: string;

    constructor(
        effectWidth: number,
        effectHeight: number,
        effectId: number,
        effectTag: string,
        effectType: string,
        scaleMode: string,
        fontColor: string,
        fontSize: number,
        textAlign: string
    ) {
        this.effectWidth = effectWidth;
        this.effectHeight = effectHeight;
        this.effectId = effectId;
        this.effectTag = effectTag;
        this.effectType = effectType;
        this.scaleMode = scaleMode;
        this.fontColor = fontColor;
        this.fontSize = fontSize;
        this.textAlign = textAlign;
    }
}

export class Data {
    public renderFrame: PointRect;
    public effectId: number;
    public outputFrame: PointRect;

    constructor(
        renderFrame: PointRect,
        effectId: number,
        outputFrame: PointRect
    ) {
        this.renderFrame = renderFrame;
        this.effectId = effectId;
        this.outputFrame = outputFrame;
    }
}

export class Datas {
    public frameIndex: number;
    public data: Array<Data>;

    constructor(
        frameIndex: number,
        data: Array<Data>
    ) {
        this.frameIndex = frameIndex;
        this.data = data;
    }
}
