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

export class ImageSelectionManager {
  private static instance: ImageSelectionManager;
  private imageUrls: Array<string> = [];
  private imagePaths: Array<string> = [];
  private obtainOriginalState: boolean = false;

  private constructor() {}

  static getInstance(): ImageSelectionManager {
    if (!ImageSelectionManager.instance) {
      ImageSelectionManager.instance = new ImageSelectionManager();
    }
    return ImageSelectionManager.instance;
  }

  saveImageUrls(urls: Array<string>): void {
    this.imageUrls = urls;
  }

  getImageUrls(): Array<string> {
    return this.imageUrls;
  }

  saveImagePaths(paths: Array<string>): void {
    this.imagePaths = paths;
  }

  getImagePaths(): Array<string> {
    return this.imagePaths;
  }

  saveObtainOriginalState(state: boolean): void {
    this.obtainOriginalState = state;
  }

  getObtainOriginalState(): boolean {
    return this.obtainOriginalState;
  }

  clearAll(): void {
    this.imageUrls = [];
    this.imagePaths = [];
    this.obtainOriginalState = false;
  }
}