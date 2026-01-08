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

import { NativeObject } from './NativeObject';
import rive from 'libohos_rive.so';
import { ViewModelException } from './errors/ViewModelException';
import { RiveException } from './errors/RiveException';
import { Artboard } from './Artboard';
import { BindableArtboard } from './BindableArtboard';
import { RiveRenderImage } from './FileAsset';

type PropertyFactory<
  T extends ViewModelNumberProperty
    | ViewModelStringProperty
    | ViewModelBooleanProperty
    | ViewModelColorProperty
    | ViewModelEnumProperty
    | ViewModelTriggerProperty
    | ViewModelImageProperty
    | ViewModelListProperty
    | ViewModelArtboardProperty
> = (pointer: BigInt) => T;
type NativePropertyGetter = (pointer: BigInt, path: string) => BigInt;

const NULL_POINTER = NativeObject.NULL_POINTER;

export class ViewModelInstance extends NativeObject {
  public ViewModelInstanceCppPointer: BigInt;

  constructor(unsafeCppPointer: BigInt) {
    super(unsafeCppPointer);
    this.ViewModelInstanceCppPointer = unsafeCppPointer;
    this.cppRefInstance(this.cppPointer);
  }

  private cppName(pointer: BigInt): string {
    return rive.Napi_ViewModelInstance_cppName(pointer);
  }

  private cppPropertyNumber(pointer: BigInt, path: string): BigInt {
    return rive.Napi_ViewModelInstance_propertyNumber(pointer, path);
  }

  private cppPropertyString(pointer: BigInt, path: string): BigInt {
    return rive.Napi_ViewModelInstance_propertyString(pointer, path);
  }

  private cppPropertyBoolean(pointer: BigInt, path: string): BigInt {
    return rive.Napi_ViewModelInstance_propertyBoolean(pointer, path);
  }

  private cppPropertyColor(pointer: BigInt, path: string): BigInt {
    return rive.Napi_ViewModelInstance_propertyColor(pointer, path);
  }

  private cppPropertyEnum(pointer: BigInt, path: string): BigInt {
    return rive.Napi_ViewModelInstance_propertyEnum(pointer, path);
  }

  private cppPropertyTrigger(pointer: BigInt, path: string): BigInt {
    return rive.Napi_ViewModelInstance_propertyTrigger(pointer, path);
  }

  private cppPropertyImage(pointer: BigInt, path: string): BigInt {
    return rive.Napi_ViewModelInstance_propertyImage(pointer, path);
  }

  private cppPropertyList(pointer: BigInt, path: string): BigInt {
    return rive.Napi_ViewModelInstance_propertyList(pointer, path);
  }

  private cppPropertyArtboard(pointer: BigInt, path: string): BigInt {
    return rive.Napi_ViewModelInstance_propertyArtboard(pointer, path);
  }

  private cppPropertyInstance(pointer: BigInt, path: string): BigInt {
    return rive.Napi_ViewModelInstance_propertyInstance(pointer, path);
  }

  private cppSetInstanceProperty(pointer: BigInt, path: string, instancePointer: BigInt): boolean {
    return rive.Napi_ViewModelInstance_setInstanceProperty(pointer, path, instancePointer);
  }

  private cppRefInstance(pointer: BigInt): void {
    rive.Napi_ViewModelInstance_refInstance(pointer);
  }

  private cppDerefInstance(pointer: BigInt): void {
    rive.Napi_ViewModelInstance_derefInstance(pointer);
  }

  protected properties: Map<
    string,
    | ViewModelNumberProperty
    | ViewModelStringProperty
    | ViewModelBooleanProperty
    | ViewModelColorProperty
    | ViewModelEnumProperty
    | ViewModelTriggerProperty
    | ViewModelImageProperty
    | ViewModelListProperty
    | ViewModelArtboardProperty
  > =
    new Map();
  protected children: Map<string, ViewModelInstance> = new Map();

  protected override cppDelete(pointer: BigInt): void {
    this.cppDerefInstance(pointer);
  }

  get name(): string {
    return this.cppName(this.cppPointer)
  }

  pollChanges(): void {
    this.properties.forEach(property => property.pollChanges());
    this.children.forEach(child => child.pollChanges());
  }

  public getNativePointer(): BigInt {
    return this.cppPointer;
  }

  transfer(): Transfer {
    return new Transfer(this);
  }

  getNumberProperty(path: string): ViewModelNumberProperty {
    return this.getProperty(path, this.cppPropertyNumber.bind(this), pointer => new ViewModelNumberProperty(pointer));
  }

  getStringProperty(path: string): ViewModelStringProperty {
    return this.getProperty(path, this.cppPropertyString.bind(this), pointer => new ViewModelStringProperty(pointer));
  }

  getBooleanProperty(path: string): ViewModelBooleanProperty {
    return this.getProperty(
      path,
      this.cppPropertyBoolean.bind(this),
      pointer => new ViewModelBooleanProperty(pointer)
    );
  }

  getColorProperty(path: string): ViewModelColorProperty {
    return this.getProperty(path, this.cppPropertyColor.bind(this), pointer => new ViewModelColorProperty(pointer));
  }

  getEnumProperty(path: string): ViewModelEnumProperty {
    return this.getProperty(path, this.cppPropertyEnum.bind(this), pointer => new ViewModelEnumProperty(pointer));
  }

  getTriggerProperty(path: string): ViewModelTriggerProperty {
    return this.getProperty(
      path,
      this.cppPropertyTrigger.bind(this),
      pointer => new ViewModelTriggerProperty(pointer)
    );
  }

  getImageProperty(path: string): ViewModelImageProperty {
    return this.getProperty(path, this.cppPropertyImage.bind(this), pointer => new ViewModelImageProperty(pointer));
  }

  getListProperty(path: string): ViewModelListProperty {
    return this.getProperty(path, this.cppPropertyList.bind(this), pointer => new ViewModelListProperty(pointer));
  }

  getArtboardProperty(path: string): ViewModelArtboardProperty {
    return this.getProperty(path, this.cppPropertyArtboard.bind(this),
      pointer => new ViewModelArtboardProperty(pointer));
  }

  getInstanceProperty(path: string): ViewModelInstance {
    return this.traverse(path.split('/'));
  }

  setInstanceProperty(path: string, instance: ViewModelInstance): void {
    const pathParts = path.split('/');
    const nestedParts = pathParts.slice(0, pathParts.length - 1);
    const propertyName = pathParts[pathParts.length - 1];
    const parentInstance = this.traverse(nestedParts);

    if (!this.cppSetInstanceProperty(parentInstance.cppPointer, propertyName, instance.cppPointer)) {
      throw new ViewModelException(`Property not found: ${path}; or instance is incompatible.`);
    }

    parentInstance.children.set(propertyName, instance);
  }

  private getProperty<T extends ViewModelNumberProperty | ViewModelStringProperty | ViewModelBooleanProperty |
  ViewModelColorProperty | ViewModelEnumProperty | ViewModelTriggerProperty | ViewModelImageProperty |
  ViewModelListProperty | ViewModelArtboardProperty>(
    path: string,
    cppGetter: NativePropertyGetter,
    factory: PropertyFactory<T>
  ): T {
    const pathParts = path.split('/')
    const nestedParts = pathParts.slice(0, pathParts.length - 1);
    const propertyName = pathParts[pathParts.length - 1];
    const instance = this.traverse(nestedParts);
    const cached = instance.properties.get(propertyName);

    if (cached) {
      const isExpectedType =
        cached instanceof ViewModelNumberProperty ||
        cached instanceof ViewModelStringProperty ||
        cached instanceof ViewModelBooleanProperty ||
        cached instanceof ViewModelColorProperty ||
        cached instanceof ViewModelEnumProperty ||
        cached instanceof ViewModelTriggerProperty ||
        cached instanceof ViewModelImageProperty ||
        cached instanceof ViewModelListProperty ||
        cached instanceof ViewModelArtboardProperty;

      if (!isExpectedType) {
        throw new ViewModelException(`Property '${propertyName}' exists but is not of the expected type.`);
      }
      return cached as T;
    }

    const propertyPointer = cppGetter(instance.cppPointer, propertyName);
    if (propertyPointer === NULL_POINTER) {
      throw new ViewModelException(`Property not found: ${path}`);
    }

    const property = factory(propertyPointer);
    instance.properties.set(propertyName, property);
    this.addDependency(property);
    return property;
  }

  private traverse(parts: string[]): ViewModelInstance {
    if (parts.length === 0) {
      return this;
    }
    const childName = parts[0];
    const rest = parts.slice(1);
    let child = this.children.get(childName);
    if (!child) {
      const childPointer = this.cppPropertyInstance(this.cppPointer, childName);
      if (childPointer === NULL_POINTER) {
        throw new ViewModelException(`Property not found: ${childName}`);
      }
      child = new ViewModelInstance(childPointer);
      this.children.set(childName, child);
      this.addDependency(child);
    }
    return child.traverse(rest);
  }
}

export class Transfer {
  private valid: boolean = true;
  private readonly instance: ViewModelInstance;

  constructor(instance: ViewModelInstance) {
    this.instance = instance;
    if (instance.refCount <= 0n) {
      throw new ViewModelException('Cannot transfer a disposed ViewModelInstance.');
    }
    rive.Napi_ViewModelInstance_refInstance(instance.cppPointer);
    instance.acquire();
  }

  dispose(): void {
    if (!this.valid) {
      throw new ViewModelException('Transfer already ended. Cannot dispose.');
    }
    this.valid = false;
    this.instance.release();
  }

  end(): ViewModelInstance {
    if (!this.valid) {
      throw new ViewModelException('Transfer already ended. Cannot end transfer again.');
    }
    this.valid = false;
    return this.instance;
  }
}

export abstract class ViewModelProperty<T> extends NativeObject {
  private readonly valueSubject: ValueSubject<T>;

  constructor(pointer: BigInt) {
    super(pointer);
    this.valueSubject = new ValueSubject<T>(this.nativeGetValue());
  }

  private cppName(pointer: BigInt): string {
    return rive.Napi_ViewModelProperty_cppName(pointer);
  }

  private cppHasChanged(pointer: BigInt): boolean {
    return rive.Napi_ViewModelProperty_hasChanged(pointer);
  }

  private cppFlushChanges(pointer: BigInt): boolean {
    return rive.Napi_ViewModelProperty_flushChanges(pointer);
  }

  get name(): string {
    return this.cppName(this.cppPointer);
  }

  get value(): T {
    return this.valueSubject.value;
  }

  set value(next: T) {
    this.nativeSetValue(next);
    this.valueSubject.value = next;
  }

  get valueFlow(): ValueSubject<T> {
    return this.valueSubject;
  }

  get isSubscribed(): boolean {
    return this.valueSubject.hasSubscribers();
  }

  pollChanges(): void {
    if (this.cppHasChanged(this.cppPointer)) {
      this.valueSubject.value = this.nativeGetValue();
      this.cppFlushChanges(this.cppPointer);
    }
  }

  protected abstract nativeGetValue(): T;

  protected abstract nativeSetValue(value: T): void;
}


class ValueSubject<T> {
  private listeners: Set<(value: T) => void> = new Set();
  private current: T;

  constructor(current: T) {
    this.current = current;
  }

  get value(): T {
    return this.current;
  }

  set value(next: T) {
    this.current = next;
    this.listeners.forEach(listener => listener(next));
  }

  subscribe(listener: (value: T) => void): () => void {
    this.listeners.add(listener);
    listener(this.current);
    return () => this.listeners.delete(listener);
  }

  hasSubscribers(): boolean {
    return this.listeners.size > 0;
  }

  private emit(value: T): void {
    this.listeners.forEach(listener => listener(value));
  }
}

export class ViewModelNumberProperty extends ViewModelProperty<number> {
  private cppGetValue(pointer: BigInt): number {
    return rive.Napi_ViewModelNumberProperty_getValue(pointer);
  }

  private cppSetValue(pointer: BigInt, value: number): void {
    return rive.Napi_ViewModelNumberProperty_setValue(pointer, value);
  }

  protected nativeGetValue(): number {
    return this.cppGetValue(this.cppPointer);
  }

  protected nativeSetValue(value: number): void {
    this.cppSetValue(this.cppPointer, value);
  }
}

export class ViewModelStringProperty extends ViewModelProperty<string> {
  private cppGetValue(pointer: BigInt): string {
    return rive.Napi_ViewModelStringProperty_getValue(pointer);
  }

  private cppSetValue(pointer: BigInt, value: string): void {
    return rive.Napi_ViewModelStringProperty_setValue(pointer, value);
  }

  protected nativeGetValue(): string {
    return this.cppGetValue(this.cppPointer);
  }

  protected nativeSetValue(value: string): void {
    this.cppSetValue(this.cppPointer, value);
  }
}

export class ViewModelBooleanProperty extends ViewModelProperty<boolean> {
  private cppGetValue(pointer: BigInt): boolean {
    return rive.Napi_ViewModelBooleanProperty_getValue(pointer);
  }

  private cppSetValue(pointer: BigInt, value: boolean): void {
    return rive.Napi_ViewModelBooleanProperty_setValue(pointer, value);
  }

  protected nativeGetValue(): boolean {
    return this.cppGetValue(this.cppPointer);
  }

  protected nativeSetValue(value: boolean): void {
    this.cppSetValue(this.cppPointer, value);
  }
}

export class ViewModelColorProperty extends ViewModelProperty<number> {
  private cppGetValue(pointer: BigInt): number {
    return rive.Napi_ViewModelColorProperty_getValue(pointer);
  }

  private cppSetValue(pointer: BigInt, value: number): void {
    return rive.Napi_ViewModelColorProperty_setValue(pointer, value);
  }

  protected nativeGetValue(): number {
    return this.cppGetValue(this.cppPointer);
  }

  protected nativeSetValue(value: number): void {
    this.cppSetValue(this.cppPointer, value);
  }
}

export class ViewModelEnumProperty extends ViewModelProperty<string> {
  private cppGetValue(pointer: BigInt): string {
    return rive.Napi_ViewModelEnumProperty_getValue(pointer);
  }

  private cppSetValue(pointer: BigInt, value: string): void {
    return rive.Napi_ViewModelEnumProperty_setValue(pointer, value);
  }

  protected nativeGetValue(): string {
    return this.cppGetValue(this.cppPointer);
  }

  protected nativeSetValue(value: string): void {
    this.cppSetValue(this.cppPointer, value);
  }
}

export class ViewModelTriggerUnit {
}

export class ViewModelTriggerProperty extends ViewModelProperty<ViewModelTriggerUnit> {
  private cppTrigger(pointer: BigInt): void {
    rive.Napi_ViewModelTriggerProperty_trigger(pointer);
  }

  protected nativeGetValue(): ViewModelTriggerUnit {
    return new ViewModelTriggerUnit();
  }

  protected nativeSetValue(_: ViewModelTriggerUnit): void {
  }

  trigger(): void {
    this.cppTrigger(this.cppPointer);
  }
}

export class ViewModelImageProperty extends ViewModelProperty<void> {
  protected nativeGetValue(): void {
    return undefined;
  }

  protected nativeSetValue(_: void): void {
  }

  private cppSetValue(pointer: BigInt, value: BigInt): void {
    return rive.Napi_ViewModelImageProperty_setValue(pointer, value);
  }

  set(image: RiveRenderImage | null): void {
    this.cppSetValue(this.cppPointer, image ? image.cppPointer : NULL_POINTER);
  }
}

interface CacheEntry {
  instance: ViewModelInstance;
  count: number;
}

export class ViewModelListProperty extends ViewModelProperty<void> {
  private cachedItems: Map<BigInt, CacheEntry> = new Map();

  get(index: number): ViewModelInstance {
    return this.elementAt(index);
  }

  protected nativeGetValue(): void {
    return undefined;
  }

  protected nativeSetValue(_: void): void {
  }

  private cppSize(pointer: BigInt): number {
    return rive.Napi_ViewModelListProperty_size(pointer);
  }

  private cppElementAt(pointer: BigInt, index: number): BigInt {
    return rive.Napi_ViewModelListProperty_elementAt(pointer, index);
  }

  private cppAdd(pointer: BigInt, itemPointer: BigInt): void {
    return rive.Napi_ViewModelListProperty_add(pointer, itemPointer);
  }

  private cppAddAt(pointer: BigInt, index: number, itemPointer: BigInt): void {
    return rive.Napi_ViewModelListProperty_addAt(pointer, index, itemPointer);
  }

  private cppRemove(pointer: BigInt, itemPointer: BigInt): void {
    return rive.Napi_ViewModelListProperty_remove(pointer, itemPointer);
  }

  private cppRemoveAt(pointer: BigInt, index: number): void {
    return rive.Napi_ViewModelListProperty_removeAt(pointer, index);
  }

  private cppSwap(pointer: BigInt, index1: number, index2: number): void {
    return rive.Napi_ViewModelListProperty_swap(pointer, index1, index2);
  }

  protected override cppDelete(pointer: BigInt): void {
    super.cppDelete(pointer);
    this.cachedItems.forEach(entry => entry.instance.release());
    this.cachedItems.clear();
  }

  private boundsCheck(index: number): void {
    if (index < 0 || index >= this.size) {
      throw new RangeError('Index out of bounds for ViewModelListProperty.');
    }
  }

  get size(): number {
    return this.cppSize(this.cppPointer);
  }

  elementAt(index: number): ViewModelInstance {
    this.boundsCheck(index);
    const itemPointer = this.cppElementAt(this.cppPointer, index);
    const cached = this.cachedItems.get(itemPointer);
    if (cached) {
      return cached.instance;
    }
    const instance = new ViewModelInstance(itemPointer);
    this.cachedItems.set(itemPointer, { instance, count: 1 });
    return instance;
  }

  add(item: ViewModelInstance): void {
    if (!item.hasCppObject) {
      throw new Error('Cannot add a disposed ViewModelProperty to ViewModelListProperty.');
    }

    let cacheEntry = this.cachedItems.get(item.cppPointer);
    if (!cacheEntry) {
      item.acquire();
      cacheEntry = { instance: item, count: 0 };
      this.cachedItems.set(item.cppPointer, cacheEntry);
    }
    cacheEntry.count++;

    this.cppAdd(this.cppPointer, item.cppPointer);
  }

  addAt(index: number, item: ViewModelInstance): void {
    this.boundsCheck(index);

    if (!item.hasCppObject) {
      throw new Error('Cannot add a disposed ViewModelProperty to ViewModelListProperty.');
    }

    let cacheEntry = this.cachedItems.get(item.cppPointer);
    if (!cacheEntry) {
      item.acquire();
      cacheEntry = { instance: item, count: 0 };
      this.cachedItems.set(item.cppPointer, cacheEntry);
    }
    cacheEntry.count++;

    this.cppAddAt(this.cppPointer, index, item.cppPointer);
  }

  remove(item: ViewModelInstance): void {
    if (!item.hasCppObject) {
      throw new Error('Cannot remove a disposed ViewModelProperty from ViewModelListProperty.');
    }

    const cacheEntry = this.cachedItems.get(item.cppPointer);
    if (cacheEntry) {
      cacheEntry.instance.release();
      this.cachedItems.delete(item.cppPointer);
    }

    this.cppRemove(this.cppPointer, item.cppPointer);
  }

  removeAt(index: number): void {
    this.boundsCheck(index);

    const itemPointer = this.cppElementAt(this.cppPointer, index);
    const entry = this.cachedItems.get(itemPointer);

    if (entry) {
      if (--entry.count === 0) {
        this.cachedItems.delete(itemPointer);
        entry.instance.release();
      }
    }

    this.cppRemoveAt(this.cppPointer, index);
  }

  swap(index1: number, index2: number): void {
    this.boundsCheck(index1);
    this.boundsCheck(index2);

    if (index1 === index2) {
      return;
    }

    this.cppSwap(this.cppPointer, index1, index2);
  }
}

export class ViewModelArtboardProperty extends ViewModelProperty<void> {
  protected nativeGetValue(): void {
    return undefined;
  }

  protected nativeSetValue(_: void): void {
  }

  private cppSetArtboard(pointer: BigInt, filePointer: BigInt, artboardPointer: BigInt): void {
    rive.Napi_ViewModelArtboardProperty_setArtboard(pointer, filePointer, artboardPointer);
  }

  private cppSetBindableArtboard(pointer: BigInt, bindableArtboardPointer: BigInt): void {
    rive.Napi_ViewModelArtboardProperty_setBindableArtboard(pointer, bindableArtboardPointer);
  }

  setArtboard(artboard: Artboard): void {
    if (!artboard.hasCppObject) {
      throw new RiveException('Cannot set a disposed Artboard to a ViewModelArtboardProperty.');
    }
    if (!artboard.file) {
      throw new RiveException('Cannot set an Artboard with no File reference to a ViewModelArtboardProperty.');
    }
    if (!artboard.file.hasCppObject) {
      throw new RiveException('Cannot set an Artboard whose File has been disposed to a ViewModelArtboardProperty.');
    }
    this.cppSetArtboard(this.cppPointer, artboard.file.cppPointer, artboard.cppPointer);
  }

  setBindableArtboard(bindableArtboard: BindableArtboard | null): void {
    this.cppSetBindableArtboard(
      this.cppPointer,
      bindableArtboard ? bindableArtboard.cppPointer : NULL_POINTER
    );

    for (let i = this.dependencies.length - 1; i >= 0; i--) {
      const dependency = this.dependencies[i];
      if (dependency instanceof BindableArtboard) {
        (dependency as BindableArtboard).release();
        this.removeDependency(dependency);
      }
    }

    if (bindableArtboard) {
      bindableArtboard.acquire();
      this.addDependency(bindableArtboard);
    }
  }
}