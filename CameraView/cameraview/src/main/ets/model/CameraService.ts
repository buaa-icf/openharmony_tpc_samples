/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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

import { MediaUtils } from '../model/MediaUtils'
// @ts-ignore
import camera from '@ohos.multimedia.camera'
import image from '@ohos.multimedia.image'
import media from '@ohos.multimedia.media'
import fileio from '@ohos.fileio'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'


const CameraMode = {
    MODE_PHOTO: 0,
    MODE_VIDEO: 1
}

const CameraSize = {
    WIDTH: 1920,
    HEIGHT: 1080
}

class CameraService {
    private tag: String = 'CameraService'
    private static instance: CameraService = new CameraService()
    private mediaUtil = MediaUtils.getInstance()
    private cameraManager: camera.CameraManager = undefined
    private cameras: Array<camera.CameraDevice> = undefined
    private cameraId: string = ''
    private cameraInput: camera.CameraInput = undefined
    private previewOutput: camera.PreviewOutput = undefined
    private photoOutPut: camera.PhotoOutput = undefined
    private captureSession: camera.CaptureSession = undefined
    private mReceiver: image.ImageReceiver = undefined
    private photoUri: string = ''
    private fileAsset: mediaLibrary.FileAsset = undefined
    private fd: number = -1
    private curMode = CameraMode.MODE_PHOTO
    // @ts-ignore
    private videoRecorder: media.VideoRecorder = undefined
    private videoOutput: camera.VideoOutput = undefined
    private handleTakePicture: (photoUri: string) => void = undefined
    private focusModeStatus: any
    private videoConfig: any = {
        videoSourceType: 0,
        profile: {
            videoBitrate: 48000,
            videoCodec: 'video/mp4v-es',
            videoFrameWidth: CameraSize.WIDTH,
            videoFrameHeight: CameraSize.HEIGHT,
            videoFrameRate: 30
        },
        url: '',
        orientationHint: 0,
        location: { latitude: 30, longitude: 130 },
        maxSize: 10000,
        maxDuration: 10000
    }

    constructor() {
        this.mReceiver = image.createImageReceiver(CameraSize.WIDTH, CameraSize.HEIGHT, 4, 8)
        this.mReceiver.on('imageArrival', () => {
            this.mReceiver.readNextImage((err, image) => {
                if (err || image === undefined) {
                    return
                }
                image.getComponent(4, (errMsg, img) => {
                    if (errMsg || img === undefined) {
                        return
                    }
                    let buffer = new ArrayBuffer(4096)
                    if (img.byteBuffer) {
                        buffer = img.byteBuffer
                    }
                    this.savePicture(buffer, image)
                })

            })
        })
    }

    async savePicture(buffer: ArrayBuffer, img: image.Image) {
        this.fileAsset = await this.mediaUtil.createAndGetUri(mediaLibrary.MediaType.IMAGE)
        this.photoUri = this.fileAsset.uri
        this.fd = await this.mediaUtil.getFdPath(this.fileAsset)
        await fileio.write(this.fd, buffer)
        await this.fileAsset.close(this.fd)
        await img.release()
        if (this.handleTakePicture) {
            this.handleTakePicture(this.photoUri)
        }
    }

    async initCamera(surfaceId: string) {
        if (this.curMode === CameraMode.MODE_VIDEO) {
            await this.releaseCamera()
            this.curMode = CameraMode.MODE_PHOTO
        }
        this.cameraManager = await camera.getCameraManager(globalThis.abilityContext)
        this.cameras = await this.cameraManager.getSupportedCameras()
        if (this.cameras.length === 0) {
            return
        }
        this.cameraId = this.cameras[0].cameraId
        this.cameraInput = await this.cameraManager.createCameraInput(this.cameras[0])
        let p = {
            format: camera.CameraFormat.CAMERA_FORMAT_JPEG,
            size: {
                width: 1920,
                height: 1080
            }
        }
        this.cameraInput.open();
        this.previewOutput = await this.cameraManager.createPreviewOutput(p, surfaceId)
        let mSurfaceId = await this.mReceiver.getReceivingSurfaceId()
        this.photoOutPut = await this.cameraManager.createPhotoOutput(p, mSurfaceId)
        this.captureSession = await this.cameraManager.createCaptureSession()
        await this.captureSession.beginConfig()
        await this.captureSession.addInput(this.cameraInput)
        await this.captureSession.addOutput(this.previewOutput)
        await this.captureSession.addOutput(this.photoOutPut)
        await this.captureSession.commitConfig()
        await this.captureSession.start()

    }

    setTakePictureCallback(callback) {
        this.handleTakePicture = callback
    }

    async takePicture() {
        if (this.curMode === CameraMode.MODE_VIDEO) {
            this.curMode = CameraMode.MODE_PHOTO
        }
        let photoSettings = {
            rotation: camera.ImageRotation.ROTATION_0,
            quality: camera.QualityLevel.QUALITY_LEVEL_MEDIUM,
            location: {
                latitude: 12.968,
                longitude: 77.7500,
                altitude: 1000
            },
            mirror: false
        }
        // @ts-ignore
        await this.photoOutPut.capture(photoSettings)
    }

    async startVideo() {
        if (this.curMode === CameraMode.MODE_PHOTO) {
            this.curMode = CameraMode.MODE_VIDEO
        }
        await this.captureSession.stop()
        await this.captureSession.beginConfig()
        if (this.videoOutput) {
            await this.captureSession.removeOutput(this.videoOutput)
        }
        this.fileAsset = await this.mediaUtil.createAndGetUri(mediaLibrary.MediaType.VIDEO)
        this.fd = await this.mediaUtil.getFdPath(this.fileAsset)
        // @ts-ignore
        this.videoRecorder = await media.createVideoRecorder()
        this.videoConfig.url = `fd://${this.fd}`
        await this.videoRecorder.prepare(this.videoConfig)
        let videoId = await this.videoRecorder.getInputSurface()

        let videoP = {
            format: camera.CameraFormat.CAMERA_FORMAT_JPEG,
            size: {
                width: 1920,
                height: 1080
            },
            frameRateRange: {
                min: 10,
                max: 50
            }

        }

        this.videoOutput = await this.cameraManager.createVideoOutput(videoP, videoId)
        await this.captureSession.addOutput(this.videoOutput)
        await this.captureSession.commitConfig()
        await this.captureSession.start()
        await this.videoOutput.start()
        await this.videoRecorder.start()
    }

    async stopVideo() {
        await this.videoRecorder.stop()
        await this.videoOutput.stop()
        await this.fileAsset.close(this.fd)
    }

    async releaseCamera() {
        await this.captureSession.stop()
        if (this.cameraInput) {
            await this.cameraInput.release()
        }
        if (this.previewOutput) {
            await this.previewOutput.release()
        }
        if (this.photoOutPut) {
            await this.photoOutPut.release()
        }
        if (this.videoOutput) {
            await this.videoOutput.release()
        }
        await this.cameraInput.release()
        await this.captureSession.release()
    }

    setCameraFocus() {
        this.captureSession.isFocusModeSupported(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO, (err, status) => {
            if (err) {
                return
            }
            this.focusModeStatus = status
        })
        if (this.focusModeStatus) {
            this.captureSession.setFocusMode(camera.FocusMode.FOCUS_MODE_CONTINUOUS_AUTO, (err) => {
            })
        }
    }

    setFlashMode(mode?: camera.FlashMode) {
        if (!mode) {
            mode = camera.FlashMode.FLASH_MODE_AUTO
        }
        this.captureSession.setFlashMode(mode, (err) => {
            if (err) {
                return
            }
        })
    }

    getCameraInput() {
        return this.cameraInput
    }
}

export default new CameraService()
