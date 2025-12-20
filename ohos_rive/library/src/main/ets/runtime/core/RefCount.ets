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

export class AtomicInteger {
    private sharedBuffer: SharedArrayBuffer;
    private intArray: Int32Array;

    constructor(initialValue: BigInt = 0n) {
        this.sharedBuffer = new SharedArrayBuffer(4);
        this.intArray = new Int32Array(this.sharedBuffer);
        this.set(initialValue);
    }

    get(): bigint  {
        return BigInt(Atomics.load(this.intArray, 0));
    }

    set(value: BigInt): void {
        Atomics.store(this.intArray, 0, Number(value));
    }

    incrementAndGet(): number {
        return Atomics.add(this.intArray, 0, 1) + 1;
    }

    decrementAndGet(): number {
        return Atomics.sub(this.intArray, 0, 1) - 1;
    }

    getAndIncrement(): number {
        return Atomics.add(this.intArray, 0, 1);
    }

    getAndDecrement(): number {
        return Atomics.sub(this.intArray, 0, 1);
    }

    compareAndSet(expect: number, update: number): boolean {
        return Atomics.compareExchange(this.intArray, 0, expect, update) === expect;
    }
}

export class AtomicLong {
    private buffer: SharedArrayBuffer;
    private int64Array: BigInt64Array;

    constructor(initialValue: bigint = 0n) {
        this.buffer = new SharedArrayBuffer(8);
        this.int64Array = new BigInt64Array(this.buffer);
        Atomics.store(this.int64Array, 0, initialValue);
    }

    get(): bigint {
        return Atomics.load(this.int64Array, 0);
    }

    set(value: bigint): void {
        Atomics.store(this.int64Array, 0, value);
    }

    getAndSet(value: bigint): bigint {
        return Atomics.exchange(this.int64Array, 0, value);
    }

    compareAndSet(expected: bigint, update: bigint): boolean {
        const result = Atomics.compareExchange(this.int64Array, 0, expected, update);
        return result === expected;
    }

    addAndGet(delta: bigint): bigint {
        return Atomics.add(this.int64Array, 0, delta);
    }

    getAndAdd(delta: bigint): bigint {
        const oldValue = Atomics.load(this.int64Array, 0);
        Atomics.add(this.int64Array, 0, delta);
        return oldValue;
    }

    incrementAndGet(): bigint {
        return this.addAndGet(1n);
    }

    getAndIncrement(): bigint {
        return this.getAndAdd(1n);
    }

    decrementAndGet(): bigint {
        return this.addAndGet(-1n);
    }

    getAndDecrement(): bigint {
        return this.getAndAdd(-1n);
    }

    getSharedBuffer(): SharedArrayBuffer {
        return this.buffer;
    }

    static fromSharedBuffer(buffer: SharedArrayBuffer, offset: number = 0): AtomicLong {
        const atomicLong = new AtomicLong(0n);
        atomicLong.buffer = buffer;
        atomicLong.int64Array = new BigInt64Array(buffer, offset, 1);
        return atomicLong;
    }
}

export class RefCount {
    public refs: AtomicInteger;
    private _refCount: BigInt;

    constructor(initialRefs: BigInt = 0n) {
        this.refs = new AtomicInteger(initialRefs);
        this._refCount = this.refs.get()
    }

    public get refCount(): BigInt {
        return this._refCount;
    }

    acquire(): number {
        return this.refs.incrementAndGet();
    }

    release(): number {
        return this.refs.decrementAndGet();
    }
}