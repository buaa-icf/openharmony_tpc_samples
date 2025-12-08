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
import testNapi from 'libspine.so';

export class Spine {
  static initResourceManager(resourceManager: object): boolean {
    return testNapi.initResourceManager(resourceManager);
  }

  static registerXComponent(xComponentId: string): boolean {
    return testNapi.registerXComponent(xComponentId);
  }

  static loadSkeleton(
    xComponentId: string,
    instanceName: string,
    atlasPath: string,
    skeletonPath: string,
    scale: number
  ): boolean {
    return testNapi.loadSkeleton(xComponentId,instanceName,atlasPath,skeletonPath,scale);
  }

  static setAnimation(
    xComponentId: string,
    instanceName: string,
    trackIndex: number,
    animationName: string,
    loop: boolean
  ): boolean {
    return testNapi.setAnimation(xComponentId,instanceName,trackIndex,animationName,loop);
  }

  static setPosition(
    xComponentId: string,
    instanceName: string,
    x: number,
    y: number
  ): void {
    testNapi.setPosition(xComponentId,instanceName,x,y);
  }

  static setScale(
    xComponentId: string,
    instanceName: string,
    scaleX: number,
    scaleY: number
  ): void {
    testNapi.setScale(xComponentId,instanceName,scaleX,scaleY);
  }

  static renderFrame(xComponentId?: string): void {
    testNapi.renderFrame(xComponentId);
  }

  static getAnimations(xComponentId: string, instanceName: string): string[] {
    return testNapi.getAnimations(xComponentId,instanceName);
  }

  static removeInstance(xComponentId: string, instanceName: string): void {
    testNapi.removeInstance(xComponentId,instanceName);
  }
}