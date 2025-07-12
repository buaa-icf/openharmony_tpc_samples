/*
Copyright (c) 2022 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import JpegSegmentType from './JpegSegmentType'
import LogUtil from '../../tools/LogUtils';

const TAG: string = "JpegSegmentData";

class JpegSegmentData {
  private readonly _segmentDataMap: Map<number, Set<Int8Array>> = new Map<number, Set<Int8Array>>();

  public addSegment(segmentType: number, segmentBytes: Int8Array) {
    LogUtil.debug(TAG, `addSegment start, segmentType: ${segmentType}, segmentBytes: ${segmentBytes}`);
    this.getOrCreateSegmentList(segmentType).add(segmentBytes);
    LogUtil.debug(TAG, `addSegment end`);
  }

  public getSegmentTypes(): Iterable<JpegSegmentType> {
    LogUtil.debug(TAG, `getSegmentTypes start`);
    let segmentTypes: Set<JpegSegmentType> = new  Set<JpegSegmentType>();
    for (let segmentTypeByte of this._segmentDataMap.keys()) {
      let segmentType: JpegSegmentType = JpegSegmentType.fromByte(segmentTypeByte);
      if (segmentType == null) {
        throw new Error("Should not have a segmentTypeByte that is not in the enum: " + segmentTypeByte.toString(16));
      }
      segmentTypes.add(segmentType);
    }

    LogUtil.debug(TAG, `getSegmentTypes end, segmentTypes: ${segmentTypes}`);
    return segmentTypes;
  }

  public getSegment(segmentType?: number, segmentTypel?: JpegSegmentType, occurrence?: number): Int8Array {
    LogUtil.debug(TAG, `getSegment start, segmentType: ${segmentType}, segmentTypel: ${segmentTypel}, occurrence: ${occurrence}`);
    if ((segmentType == undefined || segmentType == null) && (segmentTypel != undefined || segmentTypel != null))
    segmentType = segmentTypel.byteValue
    if (occurrence == undefined || occurrence == null)
    occurrence = 0
    let segmentList = this.getSegmentList(segmentType);

    LogUtil.debug(TAG, `getSegment end, segmentList: ${segmentList}, occurrence: ${occurrence}`);
    return segmentList != null && segmentList.size > occurrence
      ? Array.from(segmentList)[occurrence]
      : null;

  }

  public getSegments(segmentType: number): Set<Int8Array> {
    LogUtil.debug(TAG, `getSegments start, segmentType: ${segmentType}`);
    let segmentList = this.getSegmentList(segmentType);
    LogUtil.debug(TAG, `getSegments end, segmentList: ${segmentList}`);
    return segmentList == null ? new Set<Int8Array>() : segmentList;
  }

  public getSegmentList(segmentType: number): Set<Int8Array> {
    LogUtil.debug(TAG, `getSegmentList start, segmentType: ${segmentType}`);
    return this._segmentDataMap.get(segmentType);
  }

  public getSegmentCount(segmentType: number): number {
    LogUtil.debug(TAG, `getSegmentCount start, segmentType: ${segmentType}`);
    let segmentList = this.getSegmentList(segmentType);
    LogUtil.debug(TAG, `getSegmentCount end, segmentList length: ${segmentList == null ? 0 : segmentList.size}`);
    return segmentList == null ? 0 : segmentList.size;
  }

  public removeSegmentOccurrence(segmentType: number, occurrence: number) {
    LogUtil.debug(TAG, `removeSegmentOccurrence start, segmentType: ${segmentType}, occurrence: ${occurrence}`);
    let segmentList = this._segmentDataMap.get(segmentType);
    segmentList.delete(new Int8Array(occurrence));
  }

  public removeSegment(segmentType: number) {
    LogUtil.debug(TAG, `removeSegment start, segmentType: ${segmentType}`);
    this._segmentDataMap.delete(segmentType);
  }

  public containsSegment(segmentTypel: JpegSegmentType): boolean {
    LogUtil.debug(TAG, `containsSegment start, segmentTypel: ${segmentTypel}`);
    return this._segmentDataMap.has(segmentTypel.byteValue);
  }

  private getOrCreateSegmentList(segmentType: number): Set<Int8Array> {
    LogUtil.debug(TAG, `getOrCreateSegmentList start, segmentType: ${segmentType}`);
    let segmentList: Set<Int8Array>;
    if (this._segmentDataMap.has(segmentType)) {
      LogUtil.debug(TAG, `getOrCreateSegmentList: segmentType already exists`);
      segmentList = this._segmentDataMap.get(segmentType);
    } else {
      LogUtil.debug(TAG, `getOrCreateSegmentList: creating new segmentList`);
      segmentList = new Set<Int8Array>();
      this._segmentDataMap.set(segmentType, segmentList);
    }
    LogUtil.debug(TAG, `getOrCreateSegmentList end, segmentList: ${segmentList}`);
    return segmentList;
  }
}

export default JpegSegmentData