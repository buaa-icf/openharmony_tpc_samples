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

import { EvaAnimConfig } from './EvaAnimConfig'
import { EvaAnimPlayer } from './EvaAnimPlayer'
import { IEvaFileContainer } from './file/IEvaFileContainer'
import { EvaConstant } from './util/EvaConstant'
import { ELog } from './util/ELog'
import fs from '@ohos.file.fs'
import { JSON, taskpool } from '@kit.ArkTS'
import { PointRect } from './util/PointRect'
import { getJsonStr, getVoideMode } from './util/DecoderUtils'


/**
 * YYEVA 配置管理器
 * 负责解析和管理动画配置
 */
export class EvaAnimConfigManager {
    private static readonly TAG = `${EvaConstant.TAG}.EvaAnimConfigManager`
    playerEva: EvaAnimPlayer;
    config: EvaAnimConfig | null = null
    isParsingConfig: boolean = false // 是否正在读取配置
    private audioSpeed: number = 1.0

    constructor(playerEva: EvaAnimPlayer) {
        this.playerEva = playerEva
    }

    /**
     * 解析配置
     * @param evaFileContainer 文件容器
     * @param enableVersion1 是否启用版本1
     * @param defaultVideoMode 默认视频模式
     * @param defaultFps 默认帧率
     * @return 状态码
     */
    async parseConfig(evaFileContainer: IEvaFileContainer, defaultFps: number): Promise<number> {
        try {
            this.isParsingConfig = true
            // 解析mp4配置
            const time = Date.now()
            const result = await this.parse(evaFileContainer, defaultFps)
            ELog.i(EvaAnimConfigManager.TAG, `parseConfig cost=${Date.now() - time}ms result=${result}`)

            if (!result) {
                this.isParsingConfig = false
                return EvaConstant.REPORT_ERROR_TYPE_PARSE_CONFIG
            }

            let resultCode = EvaConstant.OK;
            if (this.config) {
                resultCode = await this.playerEva.pluginManager.onConfigCreate(this.config)
            }

            this.isParsingConfig = false
            return resultCode
        } catch (e) {
            ELog.e(EvaAnimConfigManager.TAG, 'parseConfig error ')
            this.isParsingConfig = false
            return EvaConstant.REPORT_ERROR_TYPE_PARSE_CONFIG
        }
    }

    /**
     * 解析配置实现
     */
    private async parse(evaFileContainer: IEvaFileContainer, defaultFps: number): Promise<boolean> {
        try {
            // 创建配置对象
            this.config = new EvaAnimConfig()

            if (this.playerEva.isNormalMp4) {
                this.setNormalMp4(defaultFps)
                return true
            }

            // 获取EVA JSON配置
            let jsonStr = await evaFileContainer.getEvaJson() ?? '' //读取sp缓存
            if (jsonStr.length < 1 || jsonStr == '') {
                const filePath = evaFileContainer.getFile()
                if (!filePath) {
                    return false
                }
                const task = new taskpool.Task(getJsonStr, filePath);
                jsonStr = await taskpool.execute(task) as string

                if (jsonStr.length < 1 || jsonStr == '' || jsonStr == 'none') {
                    ELog.e(EvaAnimConfigManager.TAG, "yyeffectmp4json not found")
                    evaFileContainer.setEvaJson("none") //检测后认为资源不存在json,不重复检测
                    this.setNoJson(evaFileContainer, defaultFps)
                    return true
                } else {
                    ELog.d(EvaAnimConfigManager.TAG, `jsonStr:${jsonStr}`)
                    evaFileContainer.setEvaJson(jsonStr) //检测后认为资源存在json,保存缓存
                }
            } else if (jsonStr == 'none') { //检测过后，认为是null
                ELog.i(EvaAnimConfigManager.TAG, `${evaFileContainer.getFile()} 不存在json`)
                this.setNoJson(evaFileContainer, defaultFps)
                return true
            } else {
                ELog.i(EvaAnimConfigManager.TAG, `检测正常，使用缓存json ${jsonStr}`)
            }
            const jsonObj = JSON.parse(jsonStr) as Record<string, Object>
            this.config.jsonConfig = jsonObj
            const result = this.config.parse(jsonObj)
            if (this.config.fps == 0) {
                this.config.fps = defaultFps
            }
            this.playerEva.fps = this.config.fps
            return result
        } catch (e) {
            ELog.e(EvaAnimConfigManager.TAG, 'parse error')
            return false
        }
    }

    setNoJson(evaFileContainer: IEvaFileContainer, defaultFps: number) {
        if (this.playerEva.videoMode == EvaConstant.VIDEO_MODE_NORMAL_MP4) { // 没有设置,默认为正常mp4
            this.getMp4Type(evaFileContainer)
        }
        // 按照默认配置生成config
        this.setNormalMp4(defaultFps)
    }

    async getMp4Type(evaFileContainer: IEvaFileContainer) {
        const type = await evaFileContainer.getEvaMp4Type()
        if (type > EvaConstant.VIDEO_MODE_NORMAL_MP4_NONE) { //判断已经检测过
            ELog.i(EvaAnimConfigManager.TAG, "已经检测过，getMp4Type $type")
            this.playerEva.videoMode = type
            return
        }

        const filePath = evaFileContainer.getFile()
        try {
            if (filePath != null && await fs.access(filePath)) {
                const task = new taskpool.Task(getVoideMode, filePath);
                const voidMode = await taskpool.execute(task) as number | boolean | null
                if (typeof voidMode == 'number') {
                    this.playerEva.videoMode = voidMode
                } else if (typeof voidMode == 'boolean') {
                    this.playerEva.isNormalMp4 = voidMode
                }
                evaFileContainer.setEvaMp4Type(this.playerEva.videoMode)
            }
        } catch (error) {
            ELog.e(EvaAnimConfigManager.TAG, `获取视频模式失败：error = ${JSON.stringify(error)}`)
        }
    }

    setNormalMp4(defaultFps: number) {
        if (this.config != null) {
            this.config!!.isDefaultConfig = true
            this.config!!.defaultVideoMode = this.playerEva.videoMode
            this.config!!.fps = defaultFps
            if (this.playerEva.videoMode == EvaConstant.VIDEO_MODE_NORMAL_MP4) {
                this.playerEva.isNormalMp4 = true //设定为正常mp4
            }
            if (this.config.fps) {
                this.playerEva.fps = this.config.fps
            } else {
                this.playerEva.fps = defaultFps
            }
        }
    }

    /**
     * 销毁
     */
    destroy(): void {
        ELog.i(EvaAnimConfigManager.TAG, 'destroy')
        this.config = null
        this.isParsingConfig = false
    }

    /**
     * 获取配置
     */
    getConfig(): EvaAnimConfig | null {
        return this.config
    }

    /**
     * 设置音频速度
     */
    setAudioSpeed(speed: number): void {
        this.audioSpeed = speed
    }

    /**
     * 获取音频速度
     */
    getAudioSpeed(): number {
        return this.audioSpeed
    }

    /**
     * 是否正在解析配置
     */
    isParsing(): boolean {
        return this.isParsingConfig
    }

    /**
     * 默认配置解析
     */
    defaultConfig(_videoWidth: number, _videoHeight: number) {
        if (!this.config) {
            return
        }
        if (this.config.isDefaultConfig == false) {
            return
        }
        // 设置基本视频尺寸
        this.config.videoWidth = _videoWidth;
        this.config.videoHeight = _videoHeight;

        // 根据默认视频模式配置不同的区域设置
        switch (this.config.defaultVideoMode) {
            case EvaConstant.VIDEO_MODE_SPLIT_HORIZONTAL:
                // 视频左右对齐（alpha左\rgb右）
                this.config.width = Math.floor(_videoWidth / 2);
                this.config.height = _videoHeight;
                this.config.alphaPointRect = new PointRect(0, 0, this.config.width, this.config.height)
                this.config.rgbPointRect = new PointRect(this.config.width, 0, this.config.width, this.config.height)
                break;

            case EvaConstant.VIDEO_MODE_SPLIT_VERTICAL:
                // 视频上下对齐（alpha上\rgb下）
                this.config.width = _videoWidth;
                this.config.height = Math.floor(_videoHeight / 2);
                this.config.alphaPointRect = new PointRect(0, 0, this.config.width, this.config.height)
                this.config.rgbPointRect = new PointRect(0, this.config.height, this.config.width, this.config.height)
                break;

            case EvaConstant.VIDEO_MODE_SPLIT_HORIZONTAL_REVERSE:
                // 视频左右对齐（rgb左\alpha右）
                this.config.width = Math.floor(_videoWidth / 2);
                this.config.height = _videoHeight;
                this.config.rgbPointRect = new PointRect(0, 0, this.config.width, this.config.height)
                this.config.alphaPointRect = new PointRect(this.config.width, 0, this.config.width, this.config.height)
                break;

            case EvaConstant.YYEVAColorRegion_AlphaMP4_alphaHalfRightTop:
                this.config.width = Math.floor(_videoWidth * 2 / 3);
                this.config.height = _videoHeight;
                this.config.rgbPointRect = new PointRect(0, 0, this.config.width, this.config.height)
                this.config.alphaPointRect = new PointRect(this.config.width, 0, Math.floor(this.config.width / 2),
                    Math.floor(this.config.height / 2))
                break;

            case EvaConstant.VIDEO_MODE_SPLIT_VERTICAL_REVERSE:
                // 视频上下对齐（rgb上\alpha下）
                this.config.width = _videoWidth;
                this.config.height = Math.floor(_videoHeight / 2);
                this.config.rgbPointRect = new PointRect(0, 0, this.config.width, this.config.height)
                this.config.alphaPointRect = new PointRect(0, this.config.height, this.config.width, this.config.height)
                break;

            default:
            // 默认视频左右对齐（alpha左\rgb右）
                this.config.width = Math.floor(_videoWidth / 2);
                this.config.height = _videoHeight;
                this.config.alphaPointRect = new PointRect(0, 0, this.config.width, this.config.height)
                this.config.rgbPointRect = new PointRect(this.config.width, 0, this.config.width, this.config.height)
                break;
        }
    }
}
