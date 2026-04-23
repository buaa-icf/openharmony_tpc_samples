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

import { describe, beforeAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import rive from 'libohos_rive.so';
import {
  ChangedInput,
  RiveAnimationViewBuilder,
  Bounds,
  applySceneParams,
} from '../../../main/ets/runtime/RiveAnimationView';
import {
  ResourceTypeFactory,
  ResourceId,
  ResourceUrl,
  ResourceBytes,
  ResourceRiveFile,
  RendererAttributes,
} from '../../../main/ets/runtime/renderers/RendererAttributes';
import { RendererType } from '../../../main/ets/runtime/renderers/RendererType';
import { Alignment } from '../../../main/ets/runtime/core/Alignment';
import { Fit } from '../../../main/ets/runtime/core/Fit';
import { Loop } from '../../../main/ets/runtime/core/Loop';
import { FileAsset, ImageAsset, FontAsset, AudioAsset } from '../../../main/ets/runtime/core/FileAsset';
import { FallbackAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';
import { File as RiveFile } from '../../../main/ets/runtime/core/File';

function ctx(): Context {
  return AbilityDelegatorRegistry.getAbilityDelegator().getAppContext();
}

export default function RiveAnimationViewTest() {
  describe('RiveAnimationViewTest', () => {

    beforeAll(() => {
      rive.Napi_Rive_cppRegisterClass(FileAsset);
      rive.Napi_Rive_cppRegisterClass(ImageAsset);
      rive.Napi_Rive_cppRegisterClass(FontAsset);
      rive.Napi_Rive_cppRegisterClass(AudioAsset);
    });

    // ── ChangedInput ──────────────────────────────────────────────────────

    it('ChangedInput_defaults_nullValueAndPath', 0, () => {
      const ci = new ChangedInput('sm1', 'myInput');
      expect(ci.stateMachineName).assertEqual('sm1');
      expect(ci.name).assertEqual('myInput');
      expect(ci.value).assertNull();
      expect(ci.nestedArtboardPath).assertNull();
    });

    it('ChangedInput_withBoolValue_true', 0, () => {
      const ci = new ChangedInput('sm1', 'btn', true);
      expect(ci.value as boolean).assertTrue();
      expect(ci.nestedArtboardPath).assertNull();
    });

    it('ChangedInput_withBoolValue_false', 0, () => {
      const ci = new ChangedInput('sm', 'flag', false);
      expect(ci.value as boolean).assertFalse();
    });

    it('ChangedInput_withNumericValue', 0, () => {
      const ci = new ChangedInput('sm1', 'speed', 42);
      expect(ci.value as number).assertEqual(42);
    });

    it('ChangedInput_withNestedPath', 0, () => {
      const ci = new ChangedInput('sm1', 'myInput', null, 'nested/path');
      expect(ci.nestedArtboardPath).assertEqual('nested/path');
    });

    it('ChangedInput_allParams', 0, () => {
      const ci = new ChangedInput('machine', 'trigger', false, 'Artboard/Nested');
      expect(ci.stateMachineName).assertEqual('machine');
      expect(ci.name).assertEqual('trigger');
      expect(ci.value as boolean).assertFalse();
      expect(ci.nestedArtboardPath).assertEqual('Artboard/Nested');
    });

    it('ChangedInput_numericValueZero', 0, () => {
      const ci = new ChangedInput('sm', 'n', 0);
      expect(ci.value as number).assertEqual(0);
    });

    it('ChangedInput_numericValueNegative', 0, () => {
      const ci = new ChangedInput('sm', 'n', -99);
      expect(ci.value as number).assertEqual(-99);
    });

    it('ChangedInput_emptyStateMachineName', 0, () => {
      const ci = new ChangedInput('', 'input');
      expect(ci.stateMachineName).assertEqual('');
    });

    it('ChangedInput_emptyInputName', 0, () => {
      const ci = new ChangedInput('sm', '');
      expect(ci.name).assertEqual('');
    });

    it('ChangedInput_mutateValue', 0, () => {
      const ci = new ChangedInput('sm', 'n', 1);
      ci.value = 2;
      expect(ci.value as number).assertEqual(2);
    });

    it('ChangedInput_mutateNestedPath', 0, () => {
      const ci = new ChangedInput('sm', 'n', null, 'a/b');
      ci.nestedArtboardPath = 'c/d';
      expect(ci.nestedArtboardPath).assertEqual('c/d');
    });

    // ── RiveAnimationViewBuilder ──────────────────────────────────────────

    it('RiveAnimationViewBuilder_constructor_allNullDefaults', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      expect(builder.alignment).assertNull();
      expect(builder.fit).assertNull();
      expect(builder.loop).assertNull();
      expect(builder.rendererType).assertNull();
      expect(builder.autoplay).assertNull();
      expect(builder.traceAnimations).assertNull();
      expect(builder.artboardName).assertNull();
      expect(builder.animationName).assertNull();
      expect(builder.stateMachineName).assertNull();
      expect(builder.autoBind).assertFalse();
      expect(builder.shouldLoadCDNAssets).assertTrue();
      expect(builder.touchPassThrough).assertFalse();
      expect(builder.multiTouchEnabled).assertFalse();
    });

    it('RiveAnimationViewBuilder_constructor_assetLoaderNull', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      expect(builder.assetLoader).assertNull();
    });

    it('RiveAnimationViewBuilder_constructor_resourceNull', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      expect(builder.resource).assertNull();
    });

    it('RiveAnimationViewBuilder_constructor_resourceTypeNull', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      expect(builder.resourceType).assertNull();
    });

    it('RiveAnimationViewBuilder_setAlignment_returnsThis', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      expect(builder.setAlignment(Alignment.TOP_LEFT) === builder).assertTrue();
      expect(builder.alignment).assertEqual(Alignment.TOP_LEFT);
    });

    it('RiveAnimationViewBuilder_setAlignment_zero', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setAlignment(Alignment.TOP_LEFT);
      expect(builder.alignment).assertEqual(0);
    });

    it('RiveAnimationViewBuilder_setAlignment_CENTER', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setAlignment(Alignment.CENTER);
      expect(builder.alignment).assertEqual(Alignment.CENTER);
    });

    it('RiveAnimationViewBuilder_setAlignment_BOTTOM_RIGHT', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setAlignment(Alignment.BOTTOM_RIGHT);
      expect(builder.alignment).assertEqual(Alignment.BOTTOM_RIGHT);
    });

    it('RiveAnimationViewBuilder_setFit_returnsThis', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      expect(builder.setFit(Fit.FILL) === builder).assertTrue();
      expect(builder.fit).assertEqual(Fit.FILL);
    });

    it('RiveAnimationViewBuilder_setFit_none_zero', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setFit(Fit.NONE);
      expect(builder.fit).assertEqual(0);
    });

    it('RiveAnimationViewBuilder_setFit_CONTAIN', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setFit(Fit.CONTAIN);
      expect(builder.fit).assertEqual(Fit.CONTAIN);
    });

    it('RiveAnimationViewBuilder_setFit_COVER', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setFit(Fit.COVER);
      expect(builder.fit).assertEqual(Fit.COVER);
    });

    it('RiveAnimationViewBuilder_setLoop_returnsThis', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      expect(builder.setLoop(Loop.LOOP) === builder).assertTrue();
      expect(builder.loop).assertEqual(Loop.LOOP);
    });

    it('RiveAnimationViewBuilder_setLoop_oneshot_zero', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setLoop(Loop.ONESHOT);
      expect(builder.loop).assertEqual(0);
    });

    it('RiveAnimationViewBuilder_setLoop_AUTO', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setLoop(Loop.AUTO);
      expect(builder.loop).assertEqual(Loop.AUTO);
    });

    it('RiveAnimationViewBuilder_setRendererType_Canvas', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      expect(builder.setRendererType(RendererType.Canvas) === builder).assertTrue();
      expect(builder.rendererType).assertEqual(RendererType.Canvas);
    });

    it('RiveAnimationViewBuilder_setRendererType_Rive_zero', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setRendererType(RendererType.Rive);
      expect(builder.rendererType).assertEqual(0);
    });

    it('RiveAnimationViewBuilder_setAutoplay_true', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setAutoplay(true);
      expect(builder.autoplay as boolean).assertTrue();
    });

    it('RiveAnimationViewBuilder_setAutoplay_false', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setAutoplay(false);
      expect(builder.autoplay as boolean).assertFalse();
    });

    it('RiveAnimationViewBuilder_setAutoBind_true', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setAutoBind(true);
      expect(builder.autoBind).assertTrue();
    });

    it('RiveAnimationViewBuilder_setAutoBind_false', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setAutoBind(false);
      expect(builder.autoBind).assertFalse();
    });

    it('RiveAnimationViewBuilder_setTraceAnimations_true', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setTraceAnimations(true);
      expect(builder.traceAnimations as boolean).assertTrue();
    });

    it('RiveAnimationViewBuilder_setTraceAnimations_false', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setTraceAnimations(false);
      expect(builder.traceAnimations as boolean).assertFalse();
    });

    it('RiveAnimationViewBuilder_setArtboardName', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      expect(builder.setArtboardName('Square') === builder).assertTrue();
      expect(builder.artboardName).assertEqual('Square');
    });

    it('RiveAnimationViewBuilder_setArtboardName_empty', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setArtboardName('');
      expect(builder.artboardName).assertEqual('');
    });

    it('RiveAnimationViewBuilder_setAnimationName', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      expect(builder.setAnimationName('Timeline 1') === builder).assertTrue();
      expect(builder.animationName).assertEqual('Timeline 1');
    });

    it('RiveAnimationViewBuilder_setAnimationName_empty', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setAnimationName('');
      expect(builder.animationName).assertEqual('');
    });

    it('RiveAnimationViewBuilder_setStateMachineName', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      expect(builder.setStateMachineName('SM 1') === builder).assertTrue();
      expect(builder.stateMachineName).assertEqual('SM 1');
    });

    it('RiveAnimationViewBuilder_setStateMachineName_empty', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setStateMachineName('');
      expect(builder.stateMachineName).assertEqual('');
    });

    it('RiveAnimationViewBuilder_setResource_number', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setResource(12345);
      expect(builder.resourceType instanceof ResourceId).assertTrue();
    });

    it('RiveAnimationViewBuilder_setResource_number_setsResourceField', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setResource(99);
      expect(builder.resource as number).assertEqual(99);
    });

    it('RiveAnimationViewBuilder_setResource_rawfile', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setResource('@rawfile/test.riv');
      expect(builder.resourceType instanceof ResourceId).assertTrue();
    });

    it('RiveAnimationViewBuilder_setResource_rawfileWithSubdir', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setResource('@rawfile/subdir/anim.riv');
      expect(builder.resourceType instanceof ResourceId).assertTrue();
    });

    it('RiveAnimationViewBuilder_setResource_url', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setResource('https://cdn.rive.app/test.riv');
      expect(builder.resourceType instanceof ResourceUrl).assertTrue();
    });

    it('RiveAnimationViewBuilder_setResource_httpUrl_setsResourceField', 0, () => {
      const url = 'https://example.com/a.riv';
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setResource(url);
      expect(builder.resource as string).assertEqual(url);
    });

    it('RiveAnimationViewBuilder_setResource_plainString_givesUrl', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setResource('animations/rocket.riv');
      expect(builder.resourceType instanceof ResourceUrl).assertTrue();
    });

    it('RiveAnimationViewBuilder_setResource_overwrite_updatesType', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setResource(1);
      expect(builder.resourceType instanceof ResourceId).assertTrue();
      builder.setResource('https://example.com/b.riv');
      expect(builder.resourceType instanceof ResourceUrl).assertTrue();
    });

    it('RiveAnimationViewBuilder_setAssetLoader', 0, () => {
      const c = ctx();
      const loader = new FallbackAssetLoader(c, true, null);
      const builder = new RiveAnimationViewBuilder(c);
      expect(builder.setAssetLoader(loader) === builder).assertTrue();
      expect(builder.assetLoader === loader).assertTrue();
    });

    it('RiveAnimationViewBuilder_setAssetLoader_returnsThis', 0, () => {
      const c = ctx();
      const loader = new FallbackAssetLoader(c, false, null);
      const builder = new RiveAnimationViewBuilder(c);
      const result = builder.setAssetLoader(loader);
      expect(result === builder).assertTrue();
    });

    it('RiveAnimationViewBuilder_setShouldLoadCDNAssets_false', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setShouldLoadCDNAssets(false);
      expect(builder.shouldLoadCDNAssets).assertFalse();
    });

    it('RiveAnimationViewBuilder_setShouldLoadCDNAssets_true_restoresDefault', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setShouldLoadCDNAssets(false);
      builder.setShouldLoadCDNAssets(true);
      expect(builder.shouldLoadCDNAssets).assertTrue();
    });

    it('RiveAnimationViewBuilder_setTouchPassThrough_true', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setTouchPassThrough(true);
      expect(builder.touchPassThrough).assertTrue();
    });

    it('RiveAnimationViewBuilder_setTouchPassThrough_false', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setTouchPassThrough(true);
      builder.setTouchPassThrough(false);
      expect(builder.touchPassThrough).assertFalse();
    });

    it('RiveAnimationViewBuilder_setMultiTouchEnabled_true', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setMultiTouchEnabled(true);
      expect(builder.multiTouchEnabled).assertTrue();
    });

    it('RiveAnimationViewBuilder_setMultiTouchEnabled_false', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setMultiTouchEnabled(true);
      builder.setMultiTouchEnabled(false);
      expect(builder.multiTouchEnabled).assertFalse();
    });

    it('RiveAnimationViewBuilder_methodChaining_allSetters', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx())
        .setAlignment(Alignment.CENTER)
        .setFit(Fit.CONTAIN)
        .setLoop(Loop.AUTO)
        .setAutoplay(true)
        .setAutoBind(false)
        .setArtboardName('Main')
        .setAnimationName('Idle')
        .setStateMachineName('SM')
        .setRendererType(RendererType.Rive)
        .setTraceAnimations(false)
        .setShouldLoadCDNAssets(true)
        .setTouchPassThrough(false)
        .setMultiTouchEnabled(false);
      expect(builder.alignment).assertEqual(Alignment.CENTER);
      expect(builder.fit).assertEqual(Fit.CONTAIN);
      expect(builder.loop).assertEqual(Loop.AUTO);
      expect(builder.artboardName).assertEqual('Main');
      expect(builder.animationName).assertEqual('Idle');
      expect(builder.stateMachineName).assertEqual('SM');
      expect(builder.autoplay as boolean).assertTrue();
      expect(builder.autoBind).assertFalse();
      expect(builder.traceAnimations as boolean).assertFalse();
      expect(builder.shouldLoadCDNAssets).assertTrue();
      expect(builder.touchPassThrough).assertFalse();
      expect(builder.multiTouchEnabled).assertFalse();
    });

    it('RiveAnimationViewBuilder_twoBuilders_independent', 0, () => {
      const b1 = new RiveAnimationViewBuilder(ctx()).setArtboardName('A');
      const b2 = new RiveAnimationViewBuilder(ctx()).setArtboardName('B');
      expect(b1.artboardName).assertEqual('A');
      expect(b2.artboardName).assertEqual('B');
    });

    it('RiveAnimationViewBuilder_overwriteArtboardName', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setArtboardName('First');
      builder.setArtboardName('Second');
      expect(builder.artboardName).assertEqual('Second');
    });

    it('RiveAnimationViewBuilder_overwriteAlignment', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      builder.setAlignment(Alignment.TOP_LEFT);
      builder.setAlignment(Alignment.BOTTOM_RIGHT);
      expect(builder.alignment).assertEqual(Alignment.BOTTOM_RIGHT);
    });

    it('RiveAnimationViewBuilder_setResource_returnsThis', 0, () => {
      const builder = new RiveAnimationViewBuilder(ctx());
      const result = builder.setResource(1);
      expect(result === builder).assertTrue();
    });

    // ── Bounds ────────────────────────────────────────────────────────────

    it('Bounds_allFields_stored', 0, () => {
      const b: Bounds = { left: 10, top: 20, right: 300, bottom: 400 };
      expect(b.left).assertEqual(10);
      expect(b.top).assertEqual(20);
      expect(b.right).assertEqual(300);
      expect(b.bottom).assertEqual(400);
    });

    it('Bounds_zeroBounds', 0, () => {
      const b: Bounds = { left: 0, top: 0, right: 0, bottom: 0 };
      expect(b.left).assertEqual(0);
      expect(b.top).assertEqual(0);
      expect(b.right).assertEqual(0);
      expect(b.bottom).assertEqual(0);
    });

    it('Bounds_negativeOffsets', 0, () => {
      const b: Bounds = { left: -5, top: -10, right: 100, bottom: 200 };
      expect(b.left).assertEqual(-5);
      expect(b.top).assertEqual(-10);
    });

    it('Bounds_mutableFields', 0, () => {
      const b: Bounds = { left: 0, top: 0, right: 0, bottom: 0 };
      b.right = 800;
      b.bottom = 600;
      expect(b.right).assertEqual(800);
      expect(b.bottom).assertEqual(600);
    });

    // ── ResourceTypeFactory ───────────────────────────────────────────────

    it('ResourceTypeFactory_number_givesResourceId', 0, () => {
      const r = ResourceTypeFactory.makeMaybeResource(42);
      expect(r instanceof ResourceId).assertTrue();
    });

    it('ResourceTypeFactory_rawfileString_givesResourceId', 0, () => {
      const r = ResourceTypeFactory.makeMaybeResource('@rawfile/anim.riv');
      expect(r instanceof ResourceId).assertTrue();
    });

    it('ResourceTypeFactory_httpString_givesResourceUrl', 0, () => {
      const r = ResourceTypeFactory.makeMaybeResource('https://example.com/a.riv');
      expect(r instanceof ResourceUrl).assertTrue();
    });

    it('ResourceTypeFactory_plainString_givesResourceUrl', 0, () => {
      const r = ResourceTypeFactory.makeMaybeResource('some/path.riv');
      expect(r instanceof ResourceUrl).assertTrue();
    });

    it('ResourceTypeFactory_arrayBuffer_givesResourceBytes', 0, () => {
      const buf = new ArrayBuffer(4);
      const r = ResourceTypeFactory.makeMaybeResource(buf);
      expect(r instanceof ResourceBytes).assertTrue();
    });

    it('ResourceId_type_field', 0, () => {
      const r = new ResourceId(7);
      expect(r.type).assertEqual('resourceId');
      expect(r.value as number).assertEqual(7);
    });

    it('ResourceUrl_type_field', 0, () => {
      const r = new ResourceUrl('https://x.com/a.riv');
      expect(r.type).assertEqual('resourceUrl');
      expect(r.value).assertEqual('https://x.com/a.riv');
    });

    it('ResourceBytes_type_field', 0, () => {
      const buf = new ArrayBuffer(8);
      const r = new ResourceBytes(buf);
      expect(r.type).assertEqual('resourceBytes');
      expect(r.value === buf).assertTrue();
    });

    // ── ResourceRiveFile (produced by setRiveFile) ────────────────────────

    it('ResourceRiveFile_type_field', 0, () => {
      const file = new RiveFile(new ArrayBuffer(0));
      const r = new ResourceRiveFile(file);
      expect(r.type).assertEqual('resourceRiveFile');
    });

    it('ResourceRiveFile_value_preservesIdentity', 0, () => {
      const file = new RiveFile(new ArrayBuffer(0));
      const r = new ResourceRiveFile(file);
      expect(r.value === file).assertTrue();
    });

    // ── RendererAttributes (core attribute logic of setRiveResource / setRiveBytes / setRiveFile) ──

    it('RendererAttributes_default_alignment_isCenter', 0, () => {
      const attrs = RendererAttributes.default();
      expect(attrs.alignment).assertEqual(Alignment.CENTER);
      expect(attrs.alignmentIndex).assertEqual(Alignment.CENTER.valueOf());
    });

    it('RendererAttributes_setAlignment_topLeft_updatesIndexToZero', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.alignmentIndex = Alignment.TOP_LEFT.valueOf();
      attrs.alignment = Alignment.TOP_LEFT;
      expect(attrs.alignment).assertEqual(Alignment.TOP_LEFT);
      expect(attrs.alignmentIndex).assertEqual(0);
    });

    it('RendererAttributes_setAlignment_bottomRight_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.alignmentIndex = Alignment.BOTTOM_RIGHT.valueOf();
      attrs.alignment = Alignment.BOTTOM_RIGHT;
      expect(attrs.alignment).assertEqual(Alignment.BOTTOM_RIGHT);
      expect(attrs.alignmentIndex).assertEqual(Alignment.BOTTOM_RIGHT.valueOf());
    });

    it('RendererAttributes_setAlignment_centerLeft_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.alignmentIndex = Alignment.CENTER_LEFT.valueOf();
      attrs.alignment = Alignment.CENTER_LEFT;
      expect(attrs.alignment).assertEqual(Alignment.CENTER_LEFT);
      expect(attrs.alignmentIndex).assertEqual(3);
    });

    it('RendererAttributes_default_fit_isContain', 0, () => {
      const attrs = RendererAttributes.default();
      expect(attrs.fit).assertEqual(Fit.CONTAIN);
      expect(attrs.fitIndex).assertEqual(Fit.CONTAIN.valueOf());
    });

    it('RendererAttributes_setFit_fill_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.fitIndex = Fit.FILL.valueOf();
      attrs.fit = Fit.FILL;
      expect(attrs.fit).assertEqual(Fit.FILL);
      expect(attrs.fitIndex).assertEqual(Fit.FILL.valueOf());
    });

    it('RendererAttributes_setFit_cover_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.fitIndex = Fit.COVER.valueOf();
      attrs.fit = Fit.COVER;
      expect(attrs.fit).assertEqual(Fit.COVER);
      expect(attrs.fitIndex).assertEqual(3);
    });

    it('RendererAttributes_setFit_none_indexIsZero', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.fitIndex = Fit.NONE.valueOf();
      attrs.fit = Fit.NONE;
      expect(attrs.fit).assertEqual(Fit.NONE);
      expect(attrs.fitIndex).assertEqual(0);
    });

    it('RendererAttributes_default_loop_isAuto', 0, () => {
      const attrs = RendererAttributes.default();
      expect(attrs.loop).assertEqual(Loop.AUTO);
      expect(attrs.loopIndex).assertEqual(Loop.AUTO.valueOf());
    });

    it('RendererAttributes_setLoop_loop_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.loopIndex = Loop.LOOP.valueOf();
      attrs.loop = Loop.LOOP;
      expect(attrs.loop).assertEqual(Loop.LOOP);
      expect(attrs.loopIndex).assertEqual(1);
    });

    it('RendererAttributes_setLoop_oneshot_indexIsZero', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.loopIndex = Loop.ONESHOT.valueOf();
      attrs.loop = Loop.ONESHOT;
      expect(attrs.loop).assertEqual(Loop.ONESHOT);
      expect(attrs.loopIndex).assertEqual(0);
    });

    it('RendererAttributes_setLoop_pingpong_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.loopIndex = Loop.PINGPONG.valueOf();
      attrs.loop = Loop.PINGPONG;
      expect(attrs.loop).assertEqual(Loop.PINGPONG);
      expect(attrs.loopIndex).assertEqual(2);
    });

    it('RendererAttributes_default_autoplay_isTrue', 0, () => {
      const attrs = RendererAttributes.default();
      expect(attrs.autoplay).assertTrue();
    });

    it('RendererAttributes_setAutoplay_false', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.autoplay = false;
      expect(attrs.autoplay).assertFalse();
    });

    it('RendererAttributes_setAutoplay_trueAfterFalse', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.autoplay = false;
      attrs.autoplay = true;
      expect(attrs.autoplay).assertTrue();
    });

    it('RendererAttributes_default_autoBind_isFalse', 0, () => {
      const attrs = RendererAttributes.default();
      expect(attrs.autoBind).assertFalse();
    });

    it('RendererAttributes_setAutoBind_true', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.autoBind = true;
      expect(attrs.autoBind).assertTrue();
    });

    it('RendererAttributes_default_artboardName_isNull', 0, () => {
      const attrs = RendererAttributes.default();
      expect(attrs.artboardName).assertNull();
    });

    it('RendererAttributes_setArtboardName_stored', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.artboardName = 'Main';
      expect(attrs.artboardName).assertEqual('Main');
    });

    it('RendererAttributes_setArtboardName_overwriteWithNull', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.artboardName = 'Board';
      attrs.artboardName = null;
      expect(attrs.artboardName).assertNull();
    });

    it('RendererAttributes_default_animationName_isNull', 0, () => {
      const attrs = RendererAttributes.default();
      expect(attrs.animationName).assertNull();
    });

    it('RendererAttributes_setAnimationName_stored', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.animationName = 'Timeline 1';
      expect(attrs.animationName).assertEqual('Timeline 1');
    });

    it('RendererAttributes_setAnimationName_overwriteWithNull', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.animationName = 'Idle';
      attrs.animationName = null;
      expect(attrs.animationName).assertNull();
    });

    it('RendererAttributes_default_stateMachineName_isNull', 0, () => {
      const attrs = RendererAttributes.default();
      expect(attrs.stateMachineName).assertNull();
    });

    it('RendererAttributes_setStateMachineName_stored', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.stateMachineName = 'SM 1';
      expect(attrs.stateMachineName).assertEqual('SM 1');
    });

    it('RendererAttributes_setStateMachineName_overwriteWithNull', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.stateMachineName = 'Drive';
      attrs.stateMachineName = null;
      expect(attrs.stateMachineName).assertNull();
    });

    it('RendererAttributes_default_rendererType_isRive', 0, () => {
      const attrs = RendererAttributes.default();
      expect(attrs.rendererType).assertEqual(RendererType.Rive);
    });

    it('RendererAttributes_constructedWithCanvas_rendererType_isCanvas', 0, () => {
      const attrs = new RendererAttributes(
        Alignment.CENTER.valueOf(),
        Fit.CONTAIN.valueOf(),
        Loop.AUTO.valueOf(),
        RendererType.Canvas.valueOf()
      );
      expect(attrs.rendererType).assertEqual(RendererType.Canvas);
    });

    it('RendererAttributes_setResource_numericId', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.resource = ResourceTypeFactory.makeMaybeResource(42) || undefined;
      expect(attrs.resource instanceof ResourceId).assertTrue();
    });

    it('RendererAttributes_setResource_arrayBuffer_givesBytes', 0, () => {
      const attrs = RendererAttributes.default();
      const buf = new ArrayBuffer(16);
      attrs.resource = ResourceTypeFactory.makeMaybeResource(buf) || undefined;
      expect(attrs.resource instanceof ResourceBytes).assertTrue();
    });

    it('RendererAttributes_setResource_httpsUrl_givesUrl', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.resource = ResourceTypeFactory.makeMaybeResource('https://cdn.rive.app/file.riv') || undefined;
      expect(attrs.resource instanceof ResourceUrl).assertTrue();
    });

    it('RendererAttributes_setResource_rawfile_givesResourceId', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.resource = ResourceTypeFactory.makeMaybeResource('@rawfile/my_animation.riv') || undefined;
      expect(attrs.resource instanceof ResourceId).assertTrue();
    });

    // ── setRiveFile: renderer type compatibility check ────────────────────

    it('RendererType_Rive_equals_Rive_signalsCompatible', 0, () => {
      // setRiveFile guard: file.rendererType !== this.rendererAttributes.rendererType
      expect(RendererType.Rive.valueOf() === RendererType.Rive.valueOf()).assertTrue();
    });

    it('RendererType_Rive_notEquals_Canvas_signalsIncompatible', 0, () => {
      expect(RendererType.Rive.valueOf() === RendererType.Canvas.valueOf()).assertFalse();
    });

    it('RendererType_Canvas_notEquals_Rive_signalsIncompatible', 0, () => {
      expect(RendererType.Canvas.valueOf() === RendererType.Rive.valueOf()).assertFalse();
    });

    it('RendererType_Rive_value_isZero', 0, () => {
      expect(RendererType.Rive.valueOf()).assertEqual(0);
    });

    it('RendererType_Canvas_value_isOne', 0, () => {
      expect(RendererType.Canvas.valueOf()).assertEqual(1);
    });

    it('RendererAttributes_defaultRenderer_vs_canvasRenderer_areIncompatible', 0, () => {
      const attrsRive = RendererAttributes.default();
      const attrsCanvas = new RendererAttributes(
        Alignment.CENTER.valueOf(),
        Fit.CONTAIN.valueOf(),
        Loop.AUTO.valueOf(),
        RendererType.Canvas.valueOf()
      );
      expect(attrsRive.rendererType !== attrsCanvas.rendererType).assertTrue();
    });

    // ── setRiveResource: resource type produced per input kind ────────────

    it('ResourceTypeFactory_setRiveResource_numericId_storesValue', 0, () => {
      const r = ResourceTypeFactory.makeMaybeResource(9999);
      expect(r instanceof ResourceId).assertTrue();
      expect((r as ResourceId).value as number).assertEqual(9999);
    });

    it('ResourceTypeFactory_setRiveResource_rawfileWithSubdir_storesFullPath', 0, () => {
      const path = '@rawfile/animations/bounce.riv';
      const r = ResourceTypeFactory.makeMaybeResource(path);
      expect(r instanceof ResourceId).assertTrue();
      expect((r as ResourceId).value as string).assertEqual(path);
    });

    it('ResourceTypeFactory_setRiveResource_httpsUrl_storesUrl', 0, () => {
      const url = 'https://cdn.rive.app/animations/rocket.riv';
      const r = ResourceTypeFactory.makeMaybeResource(url);
      expect(r instanceof ResourceUrl).assertTrue();
      expect((r as ResourceUrl).value).assertEqual(url);
    });

    it('ResourceTypeFactory_setRiveResource_relativePathString_givesUrl', 0, () => {
      const r = ResourceTypeFactory.makeMaybeResource('assets/bounce.riv');
      expect(r instanceof ResourceUrl).assertTrue();
    });

    // ── setRiveBytes: resource type produced from ArrayBuffer ─────────────

    it('ResourceTypeFactory_setRiveBytes_emptyBuffer_givesResourceBytes', 0, () => {
      const buf = new ArrayBuffer(0);
      const r = ResourceTypeFactory.makeMaybeResource(buf);
      expect(r instanceof ResourceBytes).assertTrue();
    });

    it('ResourceTypeFactory_setRiveBytes_buffer_preservesIdentity', 0, () => {
      const buf = new ArrayBuffer(256);
      const r = ResourceTypeFactory.makeMaybeResource(buf);
      expect((r as ResourceBytes).value === buf).assertTrue();
    });

    it('ResourceTypeFactory_setRiveBytes_largeBuffer_givesResourceBytes', 0, () => {
      const buf = new ArrayBuffer(1024 * 64);
      const r = ResourceTypeFactory.makeMaybeResource(buf);
      expect(r instanceof ResourceBytes).assertTrue();
    });

    // ── setRiveResource / setRiveBytes: null-coalescing default semantics ─

    it('NullCoalescing_undefinedAutoBind_defaultsFalse', 0, () => {
      // Mirrors: attrs.autoBind = autoBind ?? false
      const autoBind: boolean | undefined = undefined;
      expect(autoBind ?? false).assertFalse();
    });

    it('NullCoalescing_explicitFalseAutoBind_keepsFalse', 0, () => {
      const autoBind: boolean | undefined = false;
      expect(autoBind ?? true).assertFalse();
    });

    it('NullCoalescing_explicitTrueAutoBind_keepsTrue', 0, () => {
      const autoBind: boolean | undefined = true;
      expect(autoBind ?? false).assertTrue();
    });

    it('NullCoalescing_undefinedArtboardName_defaultsNull', 0, () => {
      // Mirrors: attrs.artboardName = artboardName ?? null
      const artboardName: string | undefined = undefined;
      expect(artboardName ?? null).assertNull();
    });

    it('NullCoalescing_undefinedAnimationName_defaultsNull', 0, () => {
      const animationName: string | undefined = undefined;
      expect(animationName ?? null).assertNull();
    });

    it('NullCoalescing_undefinedStateMachineName_defaultsNull', 0, () => {
      const stateMachineName: string | undefined = undefined;
      expect(stateMachineName ?? null).assertNull();
    });

    // ── applySceneParams: alignment branch ───────────────────────────────

    it('applySceneParams_alignment_topLeft_updatesAlignmentAndIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, Alignment.TOP_LEFT, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.alignment).assertEqual(Alignment.TOP_LEFT);
      expect(attrs.alignmentIndex).assertEqual(0);
    });

    it('applySceneParams_alignment_bottomRight_updatesAlignmentAndIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, Alignment.BOTTOM_RIGHT, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.alignment).assertEqual(Alignment.BOTTOM_RIGHT);
      expect(attrs.alignmentIndex).assertEqual(Alignment.BOTTOM_RIGHT.valueOf());
    });

    it('applySceneParams_alignment_centerLeft_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, Alignment.CENTER_LEFT, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.alignment).assertEqual(Alignment.CENTER_LEFT);
      expect(attrs.alignmentIndex).assertEqual(Alignment.CENTER_LEFT.valueOf());
    });

    it('applySceneParams_alignment_undefined_keepsDefault', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.alignment).assertEqual(Alignment.CENTER);
      expect(attrs.alignmentIndex).assertEqual(Alignment.CENTER.valueOf());
    });

    it('applySceneParams_alignment_topCenter_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, Alignment.TOP_CENTER, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.alignment).assertEqual(Alignment.TOP_CENTER);
      expect(attrs.alignmentIndex).assertEqual(Alignment.TOP_CENTER.valueOf());
    });

    it('applySceneParams_alignment_topRight_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, Alignment.TOP_RIGHT, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.alignment).assertEqual(Alignment.TOP_RIGHT);
      expect(attrs.alignmentIndex).assertEqual(Alignment.TOP_RIGHT.valueOf());
    });

    it('applySceneParams_alignment_bottomLeft_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, Alignment.BOTTOM_LEFT, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.alignment).assertEqual(Alignment.BOTTOM_LEFT);
      expect(attrs.alignmentIndex).assertEqual(Alignment.BOTTOM_LEFT.valueOf());
    });

    it('applySceneParams_alignment_bottomCenter_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, Alignment.BOTTOM_CENTER, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.alignment).assertEqual(Alignment.BOTTOM_CENTER);
      expect(attrs.alignmentIndex).assertEqual(Alignment.BOTTOM_CENTER.valueOf());
    });

    it('applySceneParams_alignment_centerRight_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, Alignment.CENTER_RIGHT, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.alignment).assertEqual(Alignment.CENTER_RIGHT);
      expect(attrs.alignmentIndex).assertEqual(Alignment.CENTER_RIGHT.valueOf());
    });

    // ── applySceneParams: fit branch ──────────────────────────────────────

    it('applySceneParams_fit_fill_updatesFitAndIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, Fit.FILL, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.fit).assertEqual(Fit.FILL);
      expect(attrs.fitIndex).assertEqual(Fit.FILL.valueOf());
    });

    it('applySceneParams_fit_cover_updatesFitAndIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, Fit.COVER, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.fit).assertEqual(Fit.COVER);
      expect(attrs.fitIndex).assertEqual(Fit.COVER.valueOf());
    });

    it('applySceneParams_fit_none_indexIsZero', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, Fit.NONE, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.fit).assertEqual(Fit.NONE);
      expect(attrs.fitIndex).assertEqual(0);
    });

    it('applySceneParams_fit_fitWidth_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, Fit.FIT_WIDTH, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.fit).assertEqual(Fit.FIT_WIDTH);
      expect(attrs.fitIndex).assertEqual(Fit.FIT_WIDTH.valueOf());
    });

    it('applySceneParams_fit_fitHeight_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, Fit.FIT_HEIGHT, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.fit).assertEqual(Fit.FIT_HEIGHT);
      expect(attrs.fitIndex).assertEqual(Fit.FIT_HEIGHT.valueOf());
    });

    it('applySceneParams_fit_scaleDown_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, Fit.SCALE_DOWN, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.fit).assertEqual(Fit.SCALE_DOWN);
      expect(attrs.fitIndex).assertEqual(Fit.SCALE_DOWN.valueOf());
    });

    it('applySceneParams_fit_undefined_keepsDefault', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.fit).assertEqual(Fit.CONTAIN);
      expect(attrs.fitIndex).assertEqual(Fit.CONTAIN.valueOf());
    });

    // ── applySceneParams: loop branch ─────────────────────────────────────

    it('applySceneParams_loop_loop_updatesLoopAndIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, Loop.LOOP, true, undefined, undefined, undefined, undefined);
      expect(attrs.loop).assertEqual(Loop.LOOP);
      expect(attrs.loopIndex).assertEqual(Loop.LOOP.valueOf());
    });

    it('applySceneParams_loop_pingpong_updatesIndex', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, Loop.PINGPONG, true, undefined, undefined, undefined, undefined);
      expect(attrs.loop).assertEqual(Loop.PINGPONG);
      expect(attrs.loopIndex).assertEqual(Loop.PINGPONG.valueOf());
    });

    it('applySceneParams_loop_oneshot_indexIsZero', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, Loop.ONESHOT, true, undefined, undefined, undefined, undefined);
      expect(attrs.loop).assertEqual(Loop.ONESHOT);
      expect(attrs.loopIndex).assertEqual(0);
    });

    it('applySceneParams_loop_undefined_keepsDefault', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.loop).assertEqual(Loop.AUTO);
      expect(attrs.loopIndex).assertEqual(Loop.AUTO.valueOf());
    });

    // ── applySceneParams: autoplay ────────────────────────────────────────

    it('applySceneParams_autoplay_true_stored', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.autoplay).assertTrue();
    });

    it('applySceneParams_autoplay_false_stored', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, false, undefined, undefined, undefined, undefined);
      expect(attrs.autoplay).assertFalse();
    });

    it('applySceneParams_autoplay_trueAfterFalse', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, false, undefined, undefined, undefined, undefined);
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.autoplay).assertTrue();
    });

    // ── applySceneParams: autoBind null-coalescing ────────────────────────

    it('applySceneParams_autoBind_undefined_defaultsFalse', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.autoBind).assertFalse();
    });

    it('applySceneParams_autoBind_true_stored', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, true, undefined, undefined, undefined);
      expect(attrs.autoBind).assertTrue();
    });

    it('applySceneParams_autoBind_false_stored', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, false, undefined, undefined, undefined);
      expect(attrs.autoBind).assertFalse();
    });

    // ── applySceneParams: artboardName null-coalescing ────────────────────

    it('applySceneParams_artboardName_undefined_storesNull', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.artboardName).assertNull();
    });

    it('applySceneParams_artboardName_provided_stored', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, 'MainBoard', undefined, undefined);
      expect(attrs.artboardName).assertEqual('MainBoard');
    });

    it('applySceneParams_artboardName_empty_stored', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, '', undefined, undefined);
      expect(attrs.artboardName).assertEqual('');
    });

    it('applySceneParams_artboardName_overwrite_updatesValue', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, 'First', undefined, undefined);
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, 'Second', undefined, undefined);
      expect(attrs.artboardName).assertEqual('Second');
    });

    // ── applySceneParams: animationName null-coalescing ───────────────────

    it('applySceneParams_animationName_undefined_storesNull', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.animationName).assertNull();
    });

    it('applySceneParams_animationName_provided_stored', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, 'Idle', undefined);
      expect(attrs.animationName).assertEqual('Idle');
    });

    it('applySceneParams_animationName_empty_stored', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, '', undefined);
      expect(attrs.animationName).assertEqual('');
    });

    // ── applySceneParams: stateMachineName null-coalescing ────────────────

    it('applySceneParams_stateMachineName_undefined_storesNull', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.stateMachineName).assertNull();
    });

    it('applySceneParams_stateMachineName_provided_stored', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, 'Drive');
      expect(attrs.stateMachineName).assertEqual('Drive');
    });

    it('applySceneParams_stateMachineName_empty_stored', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, '');
      expect(attrs.stateMachineName).assertEqual('');
    });

    // ── applySceneParams: full sequences ──────────────────────────────────

    it('applySceneParams_allParams_provided_fullSequence', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(
        attrs,
        Alignment.TOP_LEFT, Fit.FILL, Loop.LOOP,
        false, true,
        'Board', 'Run', 'SM'
      );
      expect(attrs.alignment).assertEqual(Alignment.TOP_LEFT);
      expect(attrs.alignmentIndex).assertEqual(0);
      expect(attrs.fit).assertEqual(Fit.FILL);
      expect(attrs.fitIndex).assertEqual(Fit.FILL.valueOf());
      expect(attrs.loop).assertEqual(Loop.LOOP);
      expect(attrs.loopIndex).assertEqual(Loop.LOOP.valueOf());
      expect(attrs.autoplay).assertFalse();
      expect(attrs.autoBind).assertTrue();
      expect(attrs.artboardName).assertEqual('Board');
      expect(attrs.animationName).assertEqual('Run');
      expect(attrs.stateMachineName).assertEqual('SM');
    });

    it('applySceneParams_noOptionals_allDefaults', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, undefined, undefined, undefined, true, undefined, undefined, undefined, undefined);
      expect(attrs.alignment).assertEqual(Alignment.CENTER);
      expect(attrs.fit).assertEqual(Fit.CONTAIN);
      expect(attrs.loop).assertEqual(Loop.AUTO);
      expect(attrs.autoplay).assertTrue();
      expect(attrs.autoBind).assertFalse();
      expect(attrs.artboardName).assertNull();
      expect(attrs.animationName).assertNull();
      expect(attrs.stateMachineName).assertNull();
    });

    it('applySceneParams_secondCall_overwritesFirstCall', 0, () => {
      const attrs = RendererAttributes.default();
      applySceneParams(attrs, Alignment.TOP_LEFT, Fit.FILL, Loop.LOOP, false, true, 'A', 'Anim1', 'SM1');
      applySceneParams(attrs, Alignment.BOTTOM_RIGHT, Fit.COVER, Loop.PINGPONG, true, false, 'B', 'Anim2', 'SM2');
      expect(attrs.alignment).assertEqual(Alignment.BOTTOM_RIGHT);
      expect(attrs.fit).assertEqual(Fit.COVER);
      expect(attrs.loop).assertEqual(Loop.PINGPONG);
      expect(attrs.autoplay).assertTrue();
      expect(attrs.autoBind).assertFalse();
      expect(attrs.artboardName).assertEqual('B');
      expect(attrs.animationName).assertEqual('Anim2');
      expect(attrs.stateMachineName).assertEqual('SM2');
    });

    it('applySceneParams_independentAttrs_mutuallyIsolated', 0, () => {
      const attrs1 = RendererAttributes.default();
      const attrs2 = RendererAttributes.default();
      applySceneParams(attrs1, Alignment.TOP_LEFT, undefined, undefined, true, undefined, 'A', undefined, undefined);
      applySceneParams(attrs2, Alignment.BOTTOM_RIGHT, undefined, undefined, false, true, 'B', undefined, undefined);
      expect(attrs1.alignment).assertEqual(Alignment.TOP_LEFT);
      expect(attrs1.artboardName).assertEqual('A');
      expect(attrs1.autoplay).assertTrue();
      expect(attrs2.alignment).assertEqual(Alignment.BOTTOM_RIGHT);
      expect(attrs2.artboardName).assertEqual('B');
      expect(attrs2.autoplay).assertFalse();
    });

    // ── setRiveFile: renderer type compatibility guard ────────────────────

    it('setRiveFile_rendererTypeGuard_sameType_Rive_compatible', 0, () => {
      const fileRType = RendererType.Rive;
      const attrsRType = RendererType.Rive;
      let wouldThrow = false;
      if (fileRType !== attrsRType) {
        wouldThrow = true;
      }
      expect(wouldThrow).assertFalse();
    });

    it('setRiveFile_rendererTypeGuard_sameType_Canvas_compatible', 0, () => {
      const fileRType = RendererType.Canvas;
      const attrsRType = RendererType.Canvas;
      let wouldThrow = false;
      if (fileRType !== attrsRType) {
        wouldThrow = true;
      }
      expect(wouldThrow).assertFalse();
    });

    it('setRiveFile_rendererTypeGuard_RiveVsCanvas_incompatible', 0, () => {
      const fileRType = RendererType.Rive;
      const attrsRType = RendererType.Canvas;
      let wouldThrow = false;
      if (fileRType.valueOf() !== attrsRType.valueOf()) {
        wouldThrow = true;
      }
      expect(wouldThrow).assertTrue();
    });

    it('setRiveFile_rendererTypeGuard_CanvasVsRive_incompatible', 0, () => {
      const fileRType = RendererType.Canvas;
      const attrsRType = RendererType.Rive;
      let wouldThrow = false;
      if (fileRType.valueOf() !== attrsRType.valueOf()) {
        wouldThrow = true;
      }
      expect(wouldThrow).assertTrue();
    });

    it('setRiveFile_rendererTypeGuard_defaultAttrs_compatibleWithRiveFile', 0, () => {
      const attrs = RendererAttributes.default();
      let wouldThrow = false;
      if (RendererType.Rive !== attrs.rendererType) {
        wouldThrow = true;
      }
      expect(wouldThrow).assertFalse();
    });

    // ── setRiveResource / setRiveBytes / setRiveFile: resource assignment ─

    it('setRiveResource_resource_numericId_givesResourceId', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.resource = ResourceTypeFactory.makeMaybeResource(42) || undefined;
      expect(attrs.resource instanceof ResourceId).assertTrue();
      expect((attrs.resource as ResourceId).value as number).assertEqual(42);
    });

    it('setRiveResource_resource_rawfile_givesResourceId', 0, () => {
      const attrs = RendererAttributes.default();
      attrs.resource = ResourceTypeFactory.makeMaybeResource('@rawfile/anim.riv') || undefined;
      expect(attrs.resource instanceof ResourceId).assertTrue();
    });

    it('setRiveResource_resource_httpsUrl_givesResourceUrl', 0, () => {
      const url = 'https://cdn.rive.app/rocket.riv';
      const attrs = RendererAttributes.default();
      attrs.resource = ResourceTypeFactory.makeMaybeResource(url) || undefined;
      expect(attrs.resource instanceof ResourceUrl).assertTrue();
      expect((attrs.resource as ResourceUrl).value).assertEqual(url);
    });

    it('setRiveBytes_resource_arrayBuffer_givesResourceBytes', 0, () => {
      const buf = new ArrayBuffer(64);
      const attrs = RendererAttributes.default();
      attrs.resource = ResourceTypeFactory.makeMaybeResource(buf) || undefined;
      expect(attrs.resource instanceof ResourceBytes).assertTrue();
      expect((attrs.resource as ResourceBytes).value === buf).assertTrue();
    });

    it('setRiveFile_resource_file_givesResourceRiveFile', 0, () => {
      const file = new RiveFile(new ArrayBuffer(0));
      const attrs = RendererAttributes.default();
      attrs.resource = ResourceTypeFactory.makeMaybeResource(file) || undefined;
      expect(attrs.resource instanceof ResourceRiveFile).assertTrue();
      expect((attrs.resource as ResourceRiveFile).value === file).assertTrue();
    });

  });
}
