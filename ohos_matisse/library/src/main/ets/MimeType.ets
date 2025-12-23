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
import { photoAccessHelper } from '@kit.MediaLibraryKit';

export class MimeType {
  private readonly mimeType: string;
  private readonly extensions: Set<string>;

  constructor(mime: string, exts: string[]) {
    this.mimeType = mime;
    this.extensions = new Set(exts);
  }

  toString(): string {
    return this.mimeType;
  }

  matches(pathOrExt: string): boolean {
    const low = pathOrExt.toLowerCase();
    for (const ext of this.extensions) {
      if (low.endsWith('.' + ext) || low === ext) {
        return true;
      }
    }
    return false;
  }

  static ofAll(): string {
    return photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
  }

  static ofImage(): string {
    return photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
  }

  static ofVideo(): string {
    return photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
  }

  static ofGif(): string {
    return 'image/gif';
  }

  static ofMovingPhotoImage(): string {
    return photoAccessHelper.PhotoViewMIMETypes.MOVING_PHOTO_IMAGE_TYPE;
  }
}