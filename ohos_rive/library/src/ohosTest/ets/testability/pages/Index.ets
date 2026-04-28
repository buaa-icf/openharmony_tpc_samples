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

import rive from 'libohos_rive.so';
import { RiveAnimationView } from '../../../../../main/ets/runtime/RiveAnimationView';
import {
  FileAsset,
  ImageAsset,
  FontAsset,
  AudioAsset,
} from '../../../../../main/ets/runtime/core/FileAsset';
import { Alignment } from '../../../../../main/ets/runtime/core/Alignment';
import { Fit } from '../../../../../main/ets/runtime/core/Fit';
import { Loop } from '../../../../../main/ets/runtime/core/Loop';
import { RendererType } from '../../../../../main/ets/runtime/renderers/RendererType';
import { File as RiveFile } from '../../../../../main/ets/runtime/core/File';

const HOST_TAG = 'RiveTestabilityHost';

@Entry
@Component
struct Index {
  @State status: string = 'init';
  @State viewReady: boolean = false;
  private capturedView: RiveAnimationView | null = null;
  private testRivBytes: ArrayBuffer | null = null;
  private testFile: RiveFile | null = null;

  aboutToAppear(): void {
    try {
      rive.Napi_Rive_cppInitialize();
      rive.Napi_Rive_cppRegisterClass(FileAsset);
      rive.Napi_Rive_cppRegisterClass(ImageAsset);
      rive.Napi_Rive_cppRegisterClass(FontAsset);
      rive.Napi_Rive_cppRegisterClass(AudioAsset);

      const ctx = getContext(this) as Context;
      const raw = ctx.resourceManager.getRawFileContentSync('acqua_text.riv') as Uint8Array;
      this.testRivBytes = raw.buffer.slice(0);
      this.testFile = new RiveFile(this.testRivBytes!, RendererType.Rive);
    } catch (e) {
      console.error(`${HOST_TAG}: aboutToAppear failed: ${e}`);
    }
  }

  build() {
    Stack() {
      Column() {
        // Anchor — tests wait on this id before driving any scenario.
        Text('rive-host-ready')
          .id('rive_host_anchor')
          .fontSize(12)
          .height(20)

        // Status echo — tests verify state transitions through this Text.
        Text(this.status)
          .id('rive_status')
          .fontSize(12)
          .height(20)

        // View-ready flag echo (string).
        Text(this.viewReady ? 'view_ready' : 'view_pending')
          .id('rive_view_ready')
          .fontSize(12)
          .height(20)

        // Echoed view-state fields after each setRive* call so the test can read them back.
        Text(`autoplay=${this.capturedView?.getAutoplay() ?? 'none'}`)
          .id('rive_echo_autoplay')
          .fontSize(12)
          .height(20)
        Text(`fit=${this.capturedView?.getFit() ?? 'none'}`)
          .id('rive_echo_fit')
          .fontSize(12)
          .height(20)
        Text(`alignment=${this.capturedView?.getAlignment() ?? 'none'}`)
          .id('rive_echo_alignment')
          .fontSize(12)
          .height(20)
        Text(`artboard=${this.capturedView?.getArtboardName() ?? 'none'}`)
          .id('rive_echo_artboard')
          .fontSize(12)
          .height(20)

        // Scenario buttons (one per setRive* method) — drives real production code paths.
        Button('setRiveResource')
          .id('btn_set_rive_resource')
          .onClick(() => {
            try {
              this.capturedView?.setRiveResource(
                '@rawfile/acqua_text.riv',
                'Artboard', 'idle', 'sm',
                false, true,
                Fit.COVER, Alignment.TOP_LEFT, Loop.LOOP
              );
              this.status = 'setRiveResource_ok';
            } catch (e) {
              this.status = `setRiveResource_err:${e}`;
            }
          })

        Button('setRiveBytes')
          .id('btn_set_rive_bytes')
          .onClick(() => {
            try {
              this.capturedView?.setRiveBytes(
                this.testRivBytes!,
                'Artboard', 'idle', 'sm',
                true, false,
                Fit.FILL, Alignment.BOTTOM_RIGHT, Loop.PINGPONG
              );
              this.status = 'setRiveBytes_ok';
            } catch (e) {
              this.status = `setRiveBytes_err:${e}`;
            }
          })

        Button('setRiveFile')
          .id('btn_set_rive_file')
          .onClick(() => {
            try {
              this.capturedView?.setRiveFile(
                this.testFile!,
                'Artboard', 'idle', 'sm',
                false, true,
                Fit.CONTAIN, Alignment.CENTER, Loop.ONESHOT
              );
              this.status = 'setRiveFile_ok';
            } catch (e) {
              this.status = `setRiveFile_err:${e}`;
            }
          })

        // Drives the renderer-type guard early-throw branch in setRiveFile.
        Button('setRiveFileIncompat')
          .id('btn_set_rive_file_incompat')
          .onClick(() => {
            try {
              const canvasFile = new RiveFile(this.testRivBytes!, RendererType.Canvas);
              this.capturedView?.setRiveFile(canvasFile);
              this.status = 'setRiveFileIncompat_no_throw';
            } catch (e) {
              this.status = 'setRiveFileIncompat_threw';
            }
          })

        // NOTE: Renderer.transform / cppTransform cannot be exercised via a
        // direct on-click invocation here. The native rive library requires
        // an active render-frame context (Skia/PLS canvas attached during
        // cppDoFrame) — calling Napi_Renderer_cppTransform outside of that
        // SIGSEGVs in libohos_rive.so. The XComponent surface lifecycle that
        // wires this up is asynchronous and does not run while Hypium drives
        // the test ability, so Renderer.transform / cppTransform are not
        // covered by Instrument Test in this project. Reported in the CSV
        // `note` column for records 824 (cppTransform) and 873 (transform).

        // The component under test. The onReady callback hands the struct
        // instance back to the host so scenario buttons can call setRive* on it.
        RiveAnimationView({
          riveFit: 'contain',
          onReady: (view: RiveAnimationView) => {
            this.capturedView = view;
            this.viewReady = true;
          }
        })
          .id('rive_anim_view')
          .width('100%')
          .height(200)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}
