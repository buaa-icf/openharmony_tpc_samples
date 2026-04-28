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

import { describe, it, expect } from '@ohos/hypium';
import {
  RendererAttributes,
  ResourceType,
  ResourceId,
  ResourceUrl,
  ResourceBytes,
  ResourceRiveFile,
  ResourceTypeFactory,
} from '../../../main/ets/runtime/renderers/RendererAttributes';
import { Alignment } from '../../../main/ets/runtime/core/Alignment';
import { Fit } from '../../../main/ets/runtime/core/Fit';
import { Loop } from '../../../main/ets/runtime/core/Loop';
import { RendererType, rendererTypeToIndex } from '../../../main/ets/runtime/renderers/RendererType';
import { File } from '../../../main/ets/runtime/core/File';
import { Renderer } from '../../../main/ets/runtime/renderers/Renderer';

/** 轻量 mock，仅提供 ResourceRiveFile 构造所需的 File 引用 */
class MockFileForRA {
  public readonly rendererType: RendererType = RendererType.Rive;
}

/**
 * 测试用具体子类：重写 transform 捕获参数。
 * 仅用于断言入参传递正确，不进入 native。Renderer.transform / cppTransform
 * 的真实生产代码路径覆盖由 RiveAnimationView.test.ets 中的 host page
 * 场景按钮（btn_renderer_transform）触发——那里有合法的 UIContext。
 */
class TestRenderer extends Renderer {
  public capturedArgs: number[] = [];

  draw(): void {}
  advance(_elapsed: number): void {}

  override transform(x: number, sy: number, sx: number, y: number, tx: number, ty: number): void {
    this.capturedArgs = [x, sy, sx, y, tx, ty];
  }

  protected override cppDelete(_pointer: BigInt): void {}
}

function makeTestRenderer(type: RendererType = RendererType.Rive): TestRenderer {
  return new TestRenderer(new Object() as ESObject as UIContext, type);
}

export default function RendererAttributesTest() {
  describe('RendererAttributesTest', () => {

    // ════════════════════════════════════════════════════════════════════════
    // ResourceId
    // ════════════════════════════════════════════════════════════════════════

    it('ResourceId_withNumber_hasCorrectTypeAndValue', 0, () => {
      const id = new ResourceId(42);
      expect(id.type).assertEqual('resourceId');
      expect(id.value).assertEqual(42);
    });

    it('ResourceId_withString_hasCorrectTypeAndValue', 0, () => {
      const id = new ResourceId('@rawfile/test.riv');
      expect(id.type).assertEqual('resourceId');
      expect(id.value).assertEqual('@rawfile/test.riv');
    });

    it('ResourceId_withZero_storedCorrectly', 0, () => {
      const id = new ResourceId(0);
      expect(id.type).assertEqual('resourceId');
      expect(id.value).assertEqual(0);
    });

    // ════════════════════════════════════════════════════════════════════════
    // ResourceUrl
    // ════════════════════════════════════════════════════════════════════════

    it('ResourceUrl_hasCorrectTypeAndValue', 0, () => {
      const url = new ResourceUrl('https://example.com/anim.riv');
      expect(url.type).assertEqual('resourceUrl');
      expect(url.value).assertEqual('https://example.com/anim.riv');
    });

    it('ResourceUrl_withEmptyString_storedCorrectly', 0, () => {
      const url = new ResourceUrl('');
      expect(url.type).assertEqual('resourceUrl');
      expect(url.value).assertEqual('');
    });

    // ════════════════════════════════════════════════════════════════════════
    // ResourceBytes
    // ════════════════════════════════════════════════════════════════════════

    it('ResourceBytes_hasCorrectTypeAndValue', 0, () => {
      const buf = new ArrayBuffer(16);
      const rb = new ResourceBytes(buf);
      expect(rb.type).assertEqual('resourceBytes');
      expect(rb.value).assertInstanceOf('ArrayBuffer');
    });

    it('ResourceBytes_withEmptyBuffer_storedCorrectly', 0, () => {
      const rb = new ResourceBytes(new ArrayBuffer(0));
      expect(rb.type).assertEqual('resourceBytes');
    });

    // ════════════════════════════════════════════════════════════════════════
    // ResourceRiveFile
    // ════════════════════════════════════════════════════════════════════════

    it('ResourceRiveFile_hasCorrectTypeAndValue', 0, () => {
      const mock = new MockFileForRA() as Object as File;
      const rf = new ResourceRiveFile(mock);
      expect(rf.type).assertEqual('resourceRiveFile');
      expect(rf.value !== null && rf.value !== undefined).assertTrue();
    });

    // ════════════════════════════════════════════════════════════════════════
    // ResourceTypeFactory.makeMaybeResource
    // ════════════════════════════════════════════════════════════════════════

    it('makeMaybeResource_number_returnsResourceId', 0, () => {
      const r = ResourceTypeFactory.makeMaybeResource(123);
      expect(r !== null && r !== undefined).assertTrue();
      expect(r!.type).assertEqual('resourceId');
      expect((r as ResourceId).value).assertEqual(123);
    });

    it('makeMaybeResource_rawfileString_returnsResourceId', 0, () => {
      const r = ResourceTypeFactory.makeMaybeResource('@rawfile/artboard.riv');
      expect(r!.type).assertEqual('resourceId');
    });

    it('makeMaybeResource_httpString_returnsResourceUrl', 0, () => {
      const r = ResourceTypeFactory.makeMaybeResource('https://cdn.example.com/a.riv');
      expect(r!.type).assertEqual('resourceUrl');
      expect((r as ResourceUrl).value).assertEqual('https://cdn.example.com/a.riv');
    });

    it('makeMaybeResource_plainString_returnsResourceUrl', 0, () => {
      const r = ResourceTypeFactory.makeMaybeResource('relative/path.riv');
      expect(r!.type).assertEqual('resourceUrl');
    });

    it('makeMaybeResource_arrayBuffer_returnsResourceBytes', 0, () => {
      const r = ResourceTypeFactory.makeMaybeResource(new ArrayBuffer(8));
      expect(r!.type).assertEqual('resourceBytes');
    });

    // ════════════════════════════════════════════════════════════════════════
    // RendererAttributes — default()
    // ════════════════════════════════════════════════════════════════════════

    it('default_alignmentIndexIsCenter', 0, () => {
      expect(RendererAttributes.default().alignmentIndex).assertEqual(Alignment.CENTER);
    });

    it('default_fitIndexIsContain', 0, () => {
      expect(RendererAttributes.default().fitIndex).assertEqual(Fit.CONTAIN);
    });

    it('default_loopIsAuto', 0, () => {
      expect(RendererAttributes.default().loop).assertEqual(Loop.AUTO);
    });

    it('default_autoplayIsTrue', 0, () => {
      expect(RendererAttributes.default().autoplay).assertTrue();
    });

    it('default_autoBindIsFalse', 0, () => {
      expect(RendererAttributes.default().autoBind).assertFalse();
    });

    it('default_traceAnimationsIsFalse', 0, () => {
      expect(RendererAttributes.default().riveTraceAnimations).assertFalse();
    });

    it('default_artboardNameIsNull', 0, () => {
      expect(RendererAttributes.default().artboardName).assertNull();
    });

    it('default_animationNameIsNull', 0, () => {
      expect(RendererAttributes.default().animationName).assertNull();
    });

    it('default_stateMachineNameIsNull', 0, () => {
      expect(RendererAttributes.default().stateMachineName).assertNull();
    });

    it('default_resourceIsUndefined', 0, () => {
      expect(RendererAttributes.default().resource).assertUndefined();
    });

    it('default_rendererTypeIsRive', 0, () => {
      expect(RendererAttributes.default().rendererType).assertEqual(RendererType.Rive);
    });

    it('default_alignmentIsCenter', 0, () => {
      expect(RendererAttributes.default().alignment).assertEqual(Alignment.CENTER);
    });

    it('default_fitIsContain', 0, () => {
      expect(RendererAttributes.default().fit).assertEqual(Fit.CONTAIN);
    });

    // ════════════════════════════════════════════════════════════════════════
    // RendererAttributes — explicit constructor
    // ════════════════════════════════════════════════════════════════════════

    it('constructor_setsAlignmentIndex', 0, () => {
      const a = new RendererAttributes(Alignment.TOP_LEFT);
      expect(a.alignmentIndex).assertEqual(Alignment.TOP_LEFT);
      expect(a.alignment).assertEqual(Alignment.TOP_LEFT);
    });

    it('constructor_setsFitIndex', 0, () => {
      const a = new RendererAttributes(Alignment.CENTER, Fit.FILL);
      expect(a.fitIndex).assertEqual(Fit.FILL);
      expect(a.fit).assertEqual(Fit.FILL);
    });

    it('constructor_setsLoop', 0, () => {
      const a = new RendererAttributes(Alignment.CENTER, Fit.CONTAIN, Loop.LOOP);
      expect(a.loop).assertEqual(Loop.LOOP);
      expect(a.loopIndex).assertEqual(Loop.LOOP.valueOf());
    });

    it('constructor_setsRendererType', 0, () => {
      const a = new RendererAttributes(
        Alignment.CENTER, Fit.CONTAIN, Loop.AUTO,
        rendererTypeToIndex(RendererType.Canvas)
      );
      expect(a.rendererType).assertEqual(RendererType.Canvas);
      expect(a.rendererIndex).assertEqual(rendererTypeToIndex(RendererType.Canvas));
    });

    it('constructor_setsAutoplay', 0, () => {
      const a = new RendererAttributes(
        Alignment.CENTER, Fit.CONTAIN, Loop.AUTO,
        rendererTypeToIndex(RendererType.Rive),
        false
      );
      expect(a.autoplay).assertFalse();
    });

    it('constructor_setsAutoBind', 0, () => {
      const a = new RendererAttributes(
        Alignment.CENTER, Fit.CONTAIN, Loop.AUTO,
        rendererTypeToIndex(RendererType.Rive),
        true, true
      );
      expect(a.autoBind).assertTrue();
    });

    it('constructor_setsTraceAnimations', 0, () => {
      const a = new RendererAttributes(
        Alignment.CENTER, Fit.CONTAIN, Loop.AUTO,
        rendererTypeToIndex(RendererType.Rive),
        true, false, true
      );
      expect(a.riveTraceAnimations).assertTrue();
    });

    it('constructor_setsArtboardName', 0, () => {
      const a = new RendererAttributes(
        Alignment.CENTER, Fit.CONTAIN, Loop.AUTO,
        rendererTypeToIndex(RendererType.Rive),
        true, false, false, 'Square'
      );
      expect(a.artboardName).assertEqual('Square');
    });

    it('constructor_setsAnimationName', 0, () => {
      const a = new RendererAttributes(
        Alignment.CENTER, Fit.CONTAIN, Loop.AUTO,
        rendererTypeToIndex(RendererType.Rive),
        true, false, false, null, 'idle'
      );
      expect(a.animationName).assertEqual('idle');
    });

    it('constructor_setsStateMachineName', 0, () => {
      const a = new RendererAttributes(
        Alignment.CENTER, Fit.CONTAIN, Loop.AUTO,
        rendererTypeToIndex(RendererType.Rive),
        true, false, false, null, null, 'State Machine 1'
      );
      expect(a.stateMachineName).assertEqual('State Machine 1');
    });

    it('constructor_setsResource', 0, () => {
      const res = new ResourceId('@rawfile/test.riv');
      const a = new RendererAttributes(
        Alignment.CENTER, Fit.CONTAIN, Loop.AUTO,
        rendererTypeToIndex(RendererType.Rive),
        true, false, false, null, null, null, res
      );
      expect(a.resource !== undefined).assertTrue();
      expect(a.resource!.type).assertEqual('resourceId');
    });

    // ════════════════════════════════════════════════════════════════════════
    // RendererAttributes — getters / setters
    // ════════════════════════════════════════════════════════════════════════

    it('alignment_setter_updatesAlignmentAndGetter', 0, () => {
      const a = RendererAttributes.default();
      a.alignment = Alignment.BOTTOM_RIGHT;
      expect(a.alignment).assertEqual(Alignment.BOTTOM_RIGHT);
    });

    it('fit_setter_updatesFitAndGetter', 0, () => {
      const a = RendererAttributes.default();
      a.fit = Fit.COVER;
      expect(a.fit).assertEqual(Fit.COVER);
    });

    it('loop_setter_updatesLoopAndGetter', 0, () => {
      const a = RendererAttributes.default();
      a.loop = Loop.PINGPONG;
      expect(a.loop).assertEqual(Loop.PINGPONG);
    });

    it('rendererType_setter_updatesRendererTypeAndGetter', 0, () => {
      const a = RendererAttributes.default();
      a.rendererType = RendererType.Canvas;
      expect(a.rendererType).assertEqual(RendererType.Canvas);
    });

    it('resource_canBeReplacedWithResourceUrl', 0, () => {
      const a = RendererAttributes.default();
      a.resource = new ResourceUrl('https://example.com/b.riv');
      expect(a.resource!.type).assertEqual('resourceUrl');
    });

    it('resource_canBeReplacedWithResourceBytes', 0, () => {
      const a = RendererAttributes.default();
      a.resource = new ResourceBytes(new ArrayBuffer(4));
      expect(a.resource!.type).assertEqual('resourceBytes');
    });

    it('artboardName_canBeUpdated', 0, () => {
      const a = RendererAttributes.default();
      a.artboardName = 'NewBoard';
      expect(a.artboardName).assertEqual('NewBoard');
    });

    it('artboardName_canBeSetToNull', 0, () => {
      const a = RendererAttributes.default();
      a.artboardName = 'Board';
      a.artboardName = null;
      expect(a.artboardName).assertNull();
    });

    it('animationName_canBeUpdated', 0, () => {
      const a = RendererAttributes.default();
      a.animationName = 'run';
      expect(a.animationName).assertEqual('run');
    });

    it('stateMachineName_canBeUpdated', 0, () => {
      const a = RendererAttributes.default();
      a.stateMachineName = 'FSM';
      expect(a.stateMachineName).assertEqual('FSM');
    });

    it('autoplay_canBeSetToFalse', 0, () => {
      const a = RendererAttributes.default();
      a.autoplay = false;
      expect(a.autoplay).assertFalse();
    });

    it('autoBind_canBeSetToTrue', 0, () => {
      const a = RendererAttributes.default();
      a.autoBind = true;
      expect(a.autoBind).assertTrue();
    });

    // ════════════════════════════════════════════════════════════════════════
    // Renderer.cppTransform（通过公开方法间接验证）
    // ════════════════════════════════════════════════════════════════════════

    // ── 初始状态 ──────────────────────────────────────────────────────────

    it('renderer_constructor_isPlayingIsFalse', 0, () => {
      const r = makeTestRenderer();
      expect(r.isPlaying).assertFalse();
    });

    it('renderer_constructor_isAttachedIsFalse', 0, () => {
      const r = makeTestRenderer();
      expect(r.isAttached).assertFalse();
    });

    it('renderer_constructor_typeIsRive', 0, () => {
      const r = makeTestRenderer();
      expect(r.type).assertEqual(RendererType.Rive);
    });

    it('renderer_constructor_traceIsFalse', 0, () => {
      const r = makeTestRenderer();
      expect(r.trace).assertFalse();
    });

    it('renderer_constructor_traceCanBeSetToTrue', 0, () => {
      const r = new TestRenderer(new Object() as ESObject as UIContext, RendererType.Rive, true);
      expect(r.trace).assertTrue();
    });

    // ── setRendererType ───────────────────────────────────────────────────

    it('setRendererType_differentType_updatesType', 0, () => {
      const r = makeTestRenderer(RendererType.Rive);
      r.setRendererType(RendererType.Canvas.valueOf());
      expect(r.type).assertEqual(RendererType.Canvas);
    });

    it('setRendererType_sameType_doesNotChange', 0, () => {
      const r = makeTestRenderer(RendererType.Rive);
      r.setRendererType(RendererType.Rive.valueOf());
      expect(r.type).assertEqual(RendererType.Rive);
    });

    it('setRendererType_toCanvas_thenBackToRive_updatesCorrectly', 0, () => {
      const r = makeTestRenderer(RendererType.Rive);
      r.setRendererType(RendererType.Canvas.valueOf());
      r.setRendererType(RendererType.Rive.valueOf());
      expect(r.type).assertEqual(RendererType.Rive);
    });

    // ── transform → cppTransform 参数透传 ────────────────────────────────

    it('transform_passesAllSixArgsToCapture', 0, () => {
      const r = makeTestRenderer();
      r.transform(1, 2, 3, 4, 5, 6);
      expect(r.capturedArgs[0]).assertEqual(1); // x
      expect(r.capturedArgs[1]).assertEqual(2); // sy
      expect(r.capturedArgs[2]).assertEqual(3); // sx
      expect(r.capturedArgs[3]).assertEqual(4); // y
      expect(r.capturedArgs[4]).assertEqual(5); // tx
      expect(r.capturedArgs[5]).assertEqual(6); // ty
    });

    it('transform_withZeros_passesAllZeros', 0, () => {
      const r = makeTestRenderer();
      r.transform(0, 0, 0, 0, 0, 0);
      expect(r.capturedArgs[0]).assertEqual(0);
      expect(r.capturedArgs[1]).assertEqual(0);
      expect(r.capturedArgs[2]).assertEqual(0);
      expect(r.capturedArgs[3]).assertEqual(0);
      expect(r.capturedArgs[4]).assertEqual(0);
      expect(r.capturedArgs[5]).assertEqual(0);
    });

    it('transform_withNegativeValues_passedCorrectly', 0, () => {
      const r = makeTestRenderer();
      r.transform(-1, -2, -3, -4, -5, -6);
      expect(r.capturedArgs[0]).assertEqual(-1);
      expect(r.capturedArgs[5]).assertEqual(-6);
    });

    // ── scale → transform(sx,0,0,sy,0,0) ─────────────────────────────────

    it('scale_callsTransformWithSxAsx_SyAsY_zerosElsewhere', 0, () => {
      const r = makeTestRenderer();
      r.scale(2, 3);
      expect(r.capturedArgs[0]).assertEqual(2); // x  = sx
      expect(r.capturedArgs[1]).assertEqual(0); // sy = 0
      expect(r.capturedArgs[2]).assertEqual(0); // sx = 0
      expect(r.capturedArgs[3]).assertEqual(3); // y  = sy
      expect(r.capturedArgs[4]).assertEqual(0); // tx = 0
      expect(r.capturedArgs[5]).assertEqual(0); // ty = 0
    });

    it('scale_withUniformScale_bothDiagonalsEqual', 0, () => {
      const r = makeTestRenderer();
      r.scale(5, 5);
      expect(r.capturedArgs[0]).assertEqual(5);
      expect(r.capturedArgs[3]).assertEqual(5);
    });

    it('scale_withFractional_passedCorrectly', 0, () => {
      const r = makeTestRenderer();
      r.scale(0.5, 1.5);
      expect(r.capturedArgs[0]).assertEqual(0.5);
      expect(r.capturedArgs[3]).assertEqual(1.5);
    });

    // ── translate → transform(1,0,0,1,dx,dy) ─────────────────────────────

    it('translate_callsTransformWithDxAsTx_DyAsTy_identityDiagonal', 0, () => {
      const r = makeTestRenderer();
      r.translate(10, 20);
      expect(r.capturedArgs[0]).assertEqual(1);  // x  = 1
      expect(r.capturedArgs[1]).assertEqual(0);  // sy = 0
      expect(r.capturedArgs[2]).assertEqual(0);  // sx = 0
      expect(r.capturedArgs[3]).assertEqual(1);  // y  = 1
      expect(r.capturedArgs[4]).assertEqual(10); // tx = dx
      expect(r.capturedArgs[5]).assertEqual(20); // ty = dy
    });

    it('translate_withZeroOffset_identityTransform', 0, () => {
      const r = makeTestRenderer();
      r.translate(0, 0);
      expect(r.capturedArgs[0]).assertEqual(1);
      expect(r.capturedArgs[3]).assertEqual(1);
      expect(r.capturedArgs[4]).assertEqual(0);
      expect(r.capturedArgs[5]).assertEqual(0);
    });

    it('translate_withNegativeOffset_passedCorrectly', 0, () => {
      const r = makeTestRenderer();
      r.translate(-5, -10);
      expect(r.capturedArgs[4]).assertEqual(-5);
      expect(r.capturedArgs[5]).assertEqual(-10);
    });

    // ════════════════════════════════════════════════════════════════════════
    // Renderer.transform — 参数位置独立性 & 边界值
    // ════════════════════════════════════════════════════════════════════════

    // ── 身份矩阵 (1,0,0,1,0,0) ───────────────────────────────────────────

    it('transform_identity_allArgsMatchExpected', 0, () => {
      const r = makeTestRenderer();
      r.transform(1, 0, 0, 1, 0, 0);
      expect(r.capturedArgs[0]).assertEqual(1); // x
      expect(r.capturedArgs[1]).assertEqual(0); // sy
      expect(r.capturedArgs[2]).assertEqual(0); // sx
      expect(r.capturedArgs[3]).assertEqual(1); // y
      expect(r.capturedArgs[4]).assertEqual(0); // tx
      expect(r.capturedArgs[5]).assertEqual(0); // ty
    });

    // ── 各参数位置独立验证（只有一个非零）────────────────────────────────

    it('transform_onlyXNonZero_otherArgsAreZero', 0, () => {
      const r = makeTestRenderer();
      r.transform(7, 0, 0, 0, 0, 0);
      expect(r.capturedArgs[0]).assertEqual(7);
      expect(r.capturedArgs[1]).assertEqual(0);
      expect(r.capturedArgs[2]).assertEqual(0);
      expect(r.capturedArgs[3]).assertEqual(0);
      expect(r.capturedArgs[4]).assertEqual(0);
      expect(r.capturedArgs[5]).assertEqual(0);
    });

    it('transform_onlySyNonZero_otherArgsAreZero', 0, () => {
      const r = makeTestRenderer();
      r.transform(0, 7, 0, 0, 0, 0);
      expect(r.capturedArgs[0]).assertEqual(0);
      expect(r.capturedArgs[1]).assertEqual(7);
      expect(r.capturedArgs[2]).assertEqual(0);
      expect(r.capturedArgs[3]).assertEqual(0);
      expect(r.capturedArgs[4]).assertEqual(0);
      expect(r.capturedArgs[5]).assertEqual(0);
    });

    it('transform_onlySxNonZero_otherArgsAreZero', 0, () => {
      const r = makeTestRenderer();
      r.transform(0, 0, 7, 0, 0, 0);
      expect(r.capturedArgs[0]).assertEqual(0);
      expect(r.capturedArgs[1]).assertEqual(0);
      expect(r.capturedArgs[2]).assertEqual(7);
      expect(r.capturedArgs[3]).assertEqual(0);
      expect(r.capturedArgs[4]).assertEqual(0);
      expect(r.capturedArgs[5]).assertEqual(0);
    });

    it('transform_onlyYNonZero_otherArgsAreZero', 0, () => {
      const r = makeTestRenderer();
      r.transform(0, 0, 0, 7, 0, 0);
      expect(r.capturedArgs[0]).assertEqual(0);
      expect(r.capturedArgs[1]).assertEqual(0);
      expect(r.capturedArgs[2]).assertEqual(0);
      expect(r.capturedArgs[3]).assertEqual(7);
      expect(r.capturedArgs[4]).assertEqual(0);
      expect(r.capturedArgs[5]).assertEqual(0);
    });

    it('transform_onlyTxNonZero_otherArgsAreZero', 0, () => {
      const r = makeTestRenderer();
      r.transform(0, 0, 0, 0, 7, 0);
      expect(r.capturedArgs[0]).assertEqual(0);
      expect(r.capturedArgs[1]).assertEqual(0);
      expect(r.capturedArgs[2]).assertEqual(0);
      expect(r.capturedArgs[3]).assertEqual(0);
      expect(r.capturedArgs[4]).assertEqual(7);
      expect(r.capturedArgs[5]).assertEqual(0);
    });

    it('transform_onlyTyNonZero_otherArgsAreZero', 0, () => {
      const r = makeTestRenderer();
      r.transform(0, 0, 0, 0, 0, 7);
      expect(r.capturedArgs[0]).assertEqual(0);
      expect(r.capturedArgs[1]).assertEqual(0);
      expect(r.capturedArgs[2]).assertEqual(0);
      expect(r.capturedArgs[3]).assertEqual(0);
      expect(r.capturedArgs[4]).assertEqual(0);
      expect(r.capturedArgs[5]).assertEqual(7);
    });

    // ── 浮点数精度 ────────────────────────────────────────────────────────

    it('transform_withFloatValues_passedCorrectly', 0, () => {
      const r = makeTestRenderer();
      r.transform(1.5, 0.25, -0.25, 1.5, 10.5, -20.75);
      expect(r.capturedArgs[0]).assertEqual(1.5);
      expect(r.capturedArgs[1]).assertEqual(0.25);
      expect(r.capturedArgs[2]).assertEqual(-0.25);
      expect(r.capturedArgs[3]).assertEqual(1.5);
      expect(r.capturedArgs[4]).assertEqual(10.5);
      expect(r.capturedArgs[5]).assertEqual(-20.75);
    });

    // ── 大值 ──────────────────────────────────────────────────────────────

    it('transform_withLargeValues_passedCorrectly', 0, () => {
      const r = makeTestRenderer();
      r.transform(1000, 0, 0, 1000, 99999, -88888);
      expect(r.capturedArgs[0]).assertEqual(1000);
      expect(r.capturedArgs[3]).assertEqual(1000);
      expect(r.capturedArgs[4]).assertEqual(99999);
      expect(r.capturedArgs[5]).assertEqual(-88888);
    });

    // ── 多次调用，capturedArgs 以最后一次为准 ─────────────────────────────

    it('transform_calledTwice_capturesLastCall', 0, () => {
      const r = makeTestRenderer();
      r.transform(1, 2, 3, 4, 5, 6);
      r.transform(9, 8, 7, 6, 5, 4);
      expect(r.capturedArgs[0]).assertEqual(9);
      expect(r.capturedArgs[1]).assertEqual(8);
      expect(r.capturedArgs[2]).assertEqual(7);
      expect(r.capturedArgs[3]).assertEqual(6);
      expect(r.capturedArgs[4]).assertEqual(5);
      expect(r.capturedArgs[5]).assertEqual(4);
    });

  });
}
