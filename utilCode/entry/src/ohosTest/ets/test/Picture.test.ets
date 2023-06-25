import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
// @ts-ignore
import imtype from 'imtype';
import fs from '@ohos.file.fs';

export default function PictureTest() {


  describe('PictureTest', function () {

    it('isJpg', 0, function () {
      globalThis.context.resourceManager.getMedia($r('app.media.jpg'))
        .then(data => {
          expect(imtype.isJPG(new Uint8Array(data))).assertTrue()
        })
        .catch(err => {
          console.log('addFileToDisk err=' + err)
        })
    })

    it('isPNG', 0, function () {
      globalThis.context.resourceManager.getMedia($r('app.media.png'))
        .then(data => {
          expect(imtype.isPNG(new Uint8Array(data))).assertTrue()
        })
        .catch(err => {
          console.log('addFileToDisk err=' + err)
        })
    })
    it('isGIF', 0, function () {
      globalThis.context.resourceManager.getMedia($r('app.media.gif'))
        .then(data => {
          expect(imtype.isGIF(new Uint8Array(data))).assertTrue()
        })
        .catch(err => {
          console.log('addFileToDisk err=' + err)
        })
    })
    it('isBMP', 0, function () {
      globalThis.context.resourceManager.getMedia($r('app.media.bmp'))
        .then(data => {
          expect(imtype.isBMP(new Uint8Array(data))).assertTrue()
        })
        .catch(err => {
          console.log('addFileToDisk err=' + err)
        })
    })
    it('isTIF', 0, function () {
      globalThis.context.resourceManager.getMedia($r('app.media.tif'))
        .then(data => {
          expect(imtype.isTIF(new Uint8Array(data))).assertTrue()
        })
        .catch(err => {
          console.log('addFileToDisk err=' + err)
        })
    })

    it('textTest', 0, function () {
      globalThis.context.resourceManager.getMedia($r('app.media.text'))
        .then(data => {
          expect(imtype.isJPG(new Uint8Array(data))).assertFalse()
          expect(imtype.isPNG(new Uint8Array(data))).assertFalse()
          expect(imtype.isGIF(new Uint8Array(data))).assertFalse()
          expect(imtype.isBMP(new Uint8Array(data))).assertFalse()
          expect(imtype.isTIF(new Uint8Array(data))).assertFalse()
        })
        .catch(err => {
          console.log('addFileToDisk err=' + err)
        })
    })
  })
}