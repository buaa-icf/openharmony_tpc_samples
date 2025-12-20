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

import { ArrayList } from '@kit.ArkTS';
import { AtomicInteger, AtomicLong, RefCount } from './RefCount';

export abstract class NativeObject extends RefCount {
  public static readonly NULL_POINTER: BigInt = 0n;
  private _unsafeCppPointer: BigInt;
  public refs: AtomicInteger;
  protected dependencies: ArrayList<RefCount> = new ArrayList();

  constructor(initialPointer: BigInt = NativeObject.NULL_POINTER) {
    super(initialPointer)
    this._unsafeCppPointer = initialPointer;
    this.refs = new AtomicInteger(initialPointer === NativeObject.NULL_POINTER ? 0n : 1n)
  }

  get hasCppObject(): boolean {
    return this._unsafeCppPointer !== NativeObject.NULL_POINTER;
  }

  public get cppPointer(): BigInt {
    const pointer = this._unsafeCppPointer;
    if (pointer === NativeObject.NULL_POINTER) {
      throw new Error(`Accessing released C++ object: ${this.constructor.name}`);
    }
    return pointer;
  }

  protected set cppPointer(pointer: BigInt) {
    this._unsafeCppPointer = pointer
  }

  protected checkPointer(): void {
    if (!this.hasCppObject) {
      throw new Error(`C++ object not initialized: ${this.constructor.name}`);
    }
  }

  public acquire(): number {
    const count = super.acquire()
    if (count <= 1) {
      throw new Error(`Attempting to acquire a released object: ${this.constructor.name}`);
    }
    return count;
  }

  public release(): number {
    const count = super.acquire()
    if (count < 0) {
      throw new Error(`Reference count already zero: ${this.constructor.name}`);
    }
    if (count == 0 && this.hasCppObject) {
      this.dispose();
    }
    return count;
  }

  protected addDependency(dependency: RefCount): void {
    if (this.dependencies.getIndexOf(dependency) === -1) {
      this.dependencies.add(dependency)
      dependency.acquire();
    }
  }

  protected removeDependency(dependency: RefCount): void {
    this.dependencies.remove(dependency)
    dependency.release();
  }

  private dispose(): void {
    if (this.refs.get() !== 0n) {
      throw new Error(`Dispose called with non-zero ref count: ${this.constructor.name}, refs: ${this.refs}`);
    }
    for (const dependency of this.dependencies) {
      dependency.release();
    }
    this.dependencies = new ArrayList();
    if (this.hasCppObject) {
      try {
        this.cppDelete(this._unsafeCppPointer);
      } catch (error) {
        console.error(`Error releasing C++ object: ${error}`);
      }
      this._unsafeCppPointer = NativeObject.NULL_POINTER;
    }
  }

  protected cppDelete(pointer: BigInt): void {
    // Subclasses should override when needed.
  }
  
  protected safeNativeCall<T>(callback: () => T, fallback: T): T {
    try {
      this.checkPointer();
      return callback();
    } catch (error) {
      console.error(`Native method call failed: ${error}`);
      return fallback;
    }
  }
}