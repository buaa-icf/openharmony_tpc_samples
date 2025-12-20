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
import { ViewModelInstance } from './ViewModelInstance';
import { ViewModelException } from './errors/ViewModelException';
import { NativeObject } from './NativeObject';

export class ViewModel extends NativeObject {
  constructor(unsafeCppPointer: BigInt) {
    super(unsafeCppPointer)
  }

  get name(): string {
    try {
      return rive.Napi_ViewModel_cppName(this.cppPointer);
    } catch (error) {
      console.error(`Error getting ViewModel name: ${error}`);
      return '';
    }
  }

  /** The number of instances of this ViewModel. Useful for index-based iteration. */
  get instanceCount(): number {
    try {
       return rive.Napi_ViewModel_instanceCount(this.cppPointer);
    } catch (error) {
      console.error(`Error getting instance count: ${error}`);
      return 0;
    }
  }

  /** The number of properties in this ViewModel. */
  get propertyCount(): number {
    try {
      return rive.Napi_ViewModel_propertyCount(this.cppPointer);
    } catch (error) {
      console.error(`Error getting property count: ${error}`);
      return 0;
    }
  }

  /** The available properties of the ViewModel. */
  get properties(): PropertyData[] {
    try {
      const nativeProperties = rive.Napi_ViewModel_getProperties(this.cppPointer);
      interface NativeProperty {
        type: number;
        name: string;
      }
      return nativeProperties.map((prop: NativeProperty) => {
        return new PropertyData(prop.type, prop.name);
      });
    } catch (error) {
      console.error(`Error getting properties: ${error}`);
      return [];
    }
  }
  /**
   * Create a new blank ViewModelInstance. Use Artboard::setViewModel to apply it. The instance
   * name will be an empty string.
   *
   * Property values will be defaulted:
   * - Numbers will be 0
   * - Strings will be empty
   * - Booleans will be false
   * - Colors will be ARGB(0xFF, 0, 0, 0)
   * - Enums will be their first value
   *
   * Useful when you want to supply all property values yourself.
   *
   * @return A new instance of the ViewModel with initial values defaulted.
   * @throws ViewModelException If a blank instance cannot be created.
   */
  createBlankInstance(): ViewModelInstance {
    try {
      const instancePointer = rive.Napi_ViewModel_createBlankInstance(this.cppPointer);
      if (instancePointer === NativeObject.NULL_POINTER) {
        throw new ViewModelException('Could not create a blank ViewModel instance');
      }
      const instance = new ViewModelInstance(instancePointer);
      this.addDependency(instance);
      return instance;
    } catch (error) {
      console.error(`Error creating blank ViewModel instance: ${error}`);
      throw new ViewModelException(
        `Failed to create blank ViewModel instance: ${
          error instanceof Error ? error.message : String(error)
        }`
      );
    }
  }

  /**
   * Create a new ViewModelInstance. Use Artboard::setViewModel to apply it.
   *
   * Property values will be those of the instance marked as "Default" in the Rive editor.
   *
   * @return A new instance of the ViewModel with initial values supplied by the default instance.
   * @throws ViewModelException If the default instance cannot be created.
   */
  createDefaultInstance(): ViewModelInstance {
    try {
      console.log(`[ohos_rive_ui] ViewModel.ets: createDefaultInstance C++ Napi_ViewModel_createDefaultInstance`);
      const  instancePointer = rive.Napi_ViewModel_createDefaultInstance(this.cppPointer)
      if (instancePointer === NativeObject.NULL_POINTER) {
        throw new ViewModelException('Could not create default ViewModel instance');
      }
      const instance = new ViewModelInstance(instancePointer);
      this.addDependency(instance);
      return instance;
    } catch (error) {
      console.error(`Error creating default ViewModel instance: ${error}`);
      throw new ViewModelException(
        `Failed to create default ViewModel instance: ${
          error instanceof Error ? error.message : String(error)
        }`
      );
    }
  }

  /**
   * Create a new ViewModelInstance. Use Artboard::setViewModel to apply it.
   *
   * Useful when the Rive file has a set of default property values that you want to initialize
   * with.
   *
   * @param index Rive file 0-based index for this instance.
   * @return A new instance of the ViewModel with initial values supplied by the indexed instance.
   * @throws ViewModelException If the instance is not found.
   */
  createInstanceFromIndex(index: number): ViewModelInstance {
    try {
      console.log(`[ohos_rive_ui] ViewModel.ets: createInstanceFromIndex C++ Napi_ViewModel_createInstanceFromIndex`);
      const instancePointer = rive.Napi_ViewModel_createInstanceFromIndex(this.cppPointer, index);
      if (instancePointer === NativeObject.NULL_POINTER) {
        throw new ViewModelException(`ViewModel instance not found: ${index}`);
      }
      const instance = new ViewModelInstance(instancePointer);
      this.addDependency(instance);
      return instance;
    } catch (error) {
      console.error(`Error creating ViewModel instance from index ${index}: ${error}`);
      throw new ViewModelException(
        `Failed to create ViewModel instance from index ${index}: ${
          error instanceof Error ? error.message : String(error)
        }`
      );
    }
  }


  /**
   * Create a new ViewModelInstance. Use Artboard::setViewModel to apply it.
   *
   * Useful when the Rive file has a set of default property values that you want to initialize
   * with.
   *
   * @param name Rive file name for this instance.
   * @return A new instance of the ViewModel with initial values supplied by the named instance.
   * @throws ViewModelException If the instance is not found.
   */
  createInstanceFromName(name: string): ViewModelInstance {
    try {
      console.log(`[ohos_rive_ui] ViewModel.ets: createInstanceFromName C++ Napi_ViewModel_createInstanceFromName`);
      const instancePointer = rive.Napi_ViewModel_createInstanceFromName(this.cppPointer, name);
      if (instancePointer === NativeObject.NULL_POINTER) {
        throw new ViewModelException(`ViewModel instance not found: ${name}`);
      }
      const instance = new ViewModelInstance(instancePointer);
      this.addDependency(instance);
      return instance;
    } catch (error) {
      console.error(`Error creating ViewModel instance from name ${name}: ${error}`);
      throw new ViewModelException(
        `Failed to create ViewModel instance from name ${name}: ${
          error instanceof Error ? error.message : String(error)
        }`
      );
    }
  }
}
/**
 * A description of a property in the ViewModel.
 *
 * These can't be used to get or set the value of the property. For that, you will need a
 * ViewModelInstance and use its methods.
 */
export class PropertyData {
  public readonly type: PropertyDataType;
  public readonly name: string;

  constructor(type: PropertyDataType, name: string) {
    this.type = type;
    this.name = name;
  }
}
// Enum values mirror those in rive::DataType
export enum PropertyDataType {
  NONE = 0,
  STRING = 1,
  NUMBER = 2,
  BOOLEAN = 3,
  COLOR = 4,
  LIST = 5,
  ENUM = 6,
  TRIGGER = 7,
  VIEW_MODEL = 8,
  INTEGER = 9,
  SYMBOL_LIST_INDEX = 10,
  ASSET_IMAGE = 11,
  ARTBOARD = 12,
}

const values = [
  PropertyDataType.NONE, PropertyDataType.STRING, PropertyDataType.NUMBER, PropertyDataType.BOOLEAN,
  PropertyDataType.COLOR, PropertyDataType.LIST, PropertyDataType.ENUM, PropertyDataType.TRIGGER,
  PropertyDataType.VIEW_MODEL, PropertyDataType.INTEGER, PropertyDataType.SYMBOL_LIST_INDEX,
  PropertyDataType.ASSET_IMAGE, PropertyDataType.ARTBOARD
];

export class PropertyDataUtils {
  /**
   * Returns the PropertyDataType associated to index.
   *
   * @throws Error If the index is out of bounds.
   */

  static fromIndex(index : number) : PropertyDataType {
    const maxIndex = values.length - 1;
    if (index < 0 || index > maxIndex) {
      throw new RangeError(`Invalid PropertyDataType index value ${index}.It must be between 0 and $ { maxIndex }`);
    }
    return values[index];
  }
}