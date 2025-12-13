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
import { Artboard } from './Artboard';
import { BindableArtboard } from './BindableArtboard';
import { ViewModelException } from './errors/ViewModelException';
import { FileAssetLoader } from './FileAssetLoader';
import { NativeObject } from './NativeObject';
import { ViewModel } from './ViewModel';

const NULL_POINTER: BigInt = 0n;

export class File extends NativeObject{
  public readonly rendererType: rive.RendererType;
  filecppPointer: BigInt = 0n;

  constructor(
    bytes: ArrayBuffer, 
    rendererType: rive.RendererType = rive.RendererType.Rive,
    fileAssetLoader?: FileAssetLoader | null
  ) {
    super();
    this.rendererType = rendererType;
    try {
      if (fileAssetLoader) {
        fileAssetLoader.setRendererType(rendererType);
        fileAssetLoader.acquire();
        this.addDependency(fileAssetLoader);
      }
      this.cppPointer = rive.Napi_File_import(
        bytes,
        rendererType,
        fileAssetLoader ? fileAssetLoader.cppPointer : NULL_POINTER
      );
      console.info('RiveFile created successfully');
    } catch (error) {
      console.error(`Error creating RiveFile: ${error}`);
      this.cppPointer = NULL_POINTER;
    }
    this.refs.incrementAndGet();
  }
  protected cppArtboardByIndex(cppPointer: BigInt, index: number): BigInt {
    return rive.Napi_File_cppArtboardByIndex(cppPointer, index)
  }

  private cppArtboardByName(cppPointer: BigInt, name: string): BigInt {
    return rive.Napi_File_cppArtboardByName(cppPointer, name)
  }

  private cppArtboardNameByIndex(cppPointer: BigInt, index: number): string {
    return rive.Napi_File_cppArtboardNameByIndex(cppPointer, index)
  }

  private cppArtboardCount(cppPointer: BigInt): number {
    return rive.Napi_File_cppArtboardCount(cppPointer)
  }

  private cppCreateBindableArtboardByName(cppPointer: BigInt, name: string): BigInt {
    return rive.Napi_File_cppCreateBindableArtboardByName(cppPointer, name)
  }

  private cppCreateDefaultBindableArtboard(cppPointer: BigInt): BigInt {
    return rive.Napi_File_cppCreateDefaultBindableArtboard(cppPointer)
  }

  private cppEnums(cppPointer: BigInt): rive.RiveEnumItem[] {
    return rive.Napi_File_cppEnums(cppPointer)
  }

  private cppViewModelCount(cppPointer: BigInt): number {
    return rive.Napi_File_cppViewModelCount(cppPointer)
  }

  private cppViewModelByIndex(cppPointer: BigInt, viewModelIdx: number): BigInt {
    return rive.Napi_File_cppViewModelByIndex(cppPointer, viewModelIdx)
  }
  protected cppViewModelByName(cppPointer: BigInt, viewModelName: string): BigInt {
    return rive.Napi_File_cppViewModelByName(cppPointer, viewModelName)
  }

  private cppDefaultViewModelForArtboard(cppPointer: BigInt, artboardPointer: BigInt): BigInt {
    return rive.Napi_File_cppDefaultViewModelForArtboard(cppPointer, artboardPointer)
  }

  protected override cppDelete(pointer: BigInt): void {
    rive.Napi_File_cppDelete(pointer);
  }

  /** Get the first (i.e. the default) artboard in the file. */
  get firstArtboard(): Artboard {
    try {
      return this.artboard(0);
    } catch (error) {
      console.error(`Error getting first artboard: ${error}`);
      throw error instanceof Error ? error : new Error(String(error));
    }
  }

  /**
   * Get the artboard called [name] in the file.
   *
   * If multiple [Artboard]s have the same [name] it will return the first match.
   */
  artboardByName(name: string): Artboard {
    try {
      const artboardPointer = this.cppArtboardByName(this.cppPointer, name);
      if (artboardPointer === NULL_POINTER) {
        const availableNames = this.artboardNames.map(n => `"${n}"`).join(', ');
        throw new Error(`Artboard "${name}" not found. Available Artboards: ${availableNames}`);
      }
      const ab = new Artboard(artboardPointer, this);
      this.dependencies.add(ab)
      return ab;
    } catch (error) {
      console.error(`Error getting artboard by name: ${error}`);
      throw error instanceof Error ? error : new Error(String(error));
    }
  }

  /**
   * Get the artboard at a given [index] in the [File].
   *
   * This starts at 0.
   */
  artboard(index: number): Artboard {
    try {
      const artboardPointer =this.cppArtboardByIndex(this.cppPointer, index);
      if (artboardPointer == NULL_POINTER) {
        throw new Error("No Artboard found at index $index.")
      }
      const ab = new Artboard(artboardPointer, this)
      this.dependencies.add(ab)
      return ab
    } catch (error) {
      console.error(`Error getting artboard by index: ${error}`);
      // Ensure we're throwing a proper Error object for ArkTS type safety
      throw error instanceof Error ? error : new Error(String(error));
    }
  }

  /**
   * Create a [BindableArtboard] by name. This is can then be bound to a
   * [ViewModelArtboardProperty].
   *
   * ⚠️ Important: The bindable artboard can outlive this [File] instance, but in order to do so
   * it has an extra reference count. You need to call [BindableArtboard.release] when you are
   * done with it, otherwise it will leak memory.
   *
   * @param name The name of the artboard in the Rive file to create.
   * @return A new [BindableArtboard] instance.
   * @throws ArtboardException If no artboard with the given name exists.
   */
  createBindableArtboardByName(name: String): BindableArtboard {
    const artboardPointer = this.cppCreateBindableArtboardByName(this.cppPointer, name as string)
    if (artboardPointer == NULL_POINTER) {
      throw new Error("No BindableArtboard found with name $name.")
    }
    const bindableArtboard = new BindableArtboard(artboardPointer)
    this.dependencies.add(bindableArtboard)
    return bindableArtboard
  }

  /**
   * Create the default [BindableArtboard], as marked in the Rive file. This is can then be bound
   * to a [ViewModelArtboardProperty].
   *
   * ⚠️ Important: The bindable artboard can outlive this [File] instance, but in order to do so
   * it has an extra reference count. You need to call [BindableArtboard.release] when you are
   * done with it, otherwise it will leak memory.
   *
   * @return A new [BindableArtboard] instance.
   * @throws ArtboardException If no default artboard exists.
   */
   createDefaultBindableArtboard(): BindableArtboard {
     const artboardPointer =this.cppCreateDefaultBindableArtboard(this.cppPointer)
    if (artboardPointer == NULL_POINTER) {
      throw new Error("No default BindableArtboard.")
    }
     const bindableArtboard = new BindableArtboard(artboardPointer)
     this.dependencies.add(bindableArtboard)
     return bindableArtboard
  }

  /** Get the number of artboards in the file. Useful for index-based iteration. */
  get artboardCount(): number {
    try {
      return this.cppArtboardCount(this.cppPointer);
    } catch (error) {
      console.error(`Error getting artboard count: ${error}`);
      return 0;
    }
  }

  /** Get the names of the artboards in the file. */
  get artboardNames(): string[] {
    try {
      const names: string[] = [];
      const count = this.artboardCount;
      for (let i = 0; i < count; i++) {
      const name = this.cppArtboardNameByIndex(this.cppPointer, i);
        names.push(name);
      }
      return names;
    } catch (error) {
      console.error(`Error getting artboard names: ${error}`);
      return [];
    }
  }

  /** The available [enums][Enum] in the file. */
  get enums(): Array<rive.RiveEnumItem> {
    try {
      return this.cppEnums(this.cppPointer);
    } catch (error) {
      console.error(`Error getting enums: ${error}`);
      return [];
    }
  }

  /** The number of [ViewModel]s in the file. Useful for index-based iteration. */
  get viewModelCount(): number {
    try {
      this.checkPointer();
      return this.cppViewModelCount(this.cppPointer);
    } catch (error) {
      console.error(`Error getting viewModel count: ${error}`);
      return 0;
    }
  }

  /**
   * Get the [ViewModel] definition from the file.
   *
   * @param viewModelIdx The Rive file 0-based index of the ViewModel.
   * @return The [ViewModel] definition.
   * @throws ViewModelException If the ViewModel is not found.
   */
  getViewModelByIndex(viewModelIdx: number): ViewModel {
    try {
      const vmPointer = this.cppViewModelByIndex(this.cppPointer, viewModelIdx);
      if (vmPointer === NULL_POINTER) {
        throw new ViewModelException(`No ViewModel found at index ${viewModelIdx}.`);
      }
      const viewModel = new ViewModel(vmPointer);
      this.dependencies.add(viewModel);
      return viewModel;
    } catch (error) {
      console.error(`Error getting ViewModel by index: ${error}`);
      throw error instanceof Error ? error : new Error(String(error));
    }
  }

  /**
   * Get the [ViewModel] definition from the file.
   *
   * @param viewModelName The Rive file name of the ViewModel.
   * @return The [ViewModel] definition.
   * @throws ViewModelException If the ViewModel is not found.
   */
  getViewModelByName(viewModelName: string): ViewModel {
    try {
      const vmPointer = this.cppViewModelByName(this.cppPointer, viewModelName);
      if (vmPointer === NULL_POINTER) {
        throw new ViewModelException(`No ViewModel found with name ${viewModelName}.`);
      }
      const viewModel = new ViewModel(vmPointer);
      this.dependencies.add(viewModel);
      return viewModel;
    } catch (error) {
      console.error(`Error getting ViewModel by name: ${error}`);
      throw error instanceof Error ? error : new Error(String(error));
    }
  }

  /**
   * Get the default [ViewModel] for an [Artboard]. Usually this will be the ViewModel intended
   * for use with this artboard.
   *
   * @param artboard The artboard to get the default ViewModel for.
   * @return The default ViewModel for the artboard.
   * @throws ViewModelException If the default ViewModel is not found.
   */
  defaultViewModelForArtboard(artboard: Artboard): ViewModel {
    try {
      console.log(`[ohos_rive_ui] defaultViewModelForArtboard st`);
      const vmPointer = this.cppDefaultViewModelForArtboard(this.cppPointer, artboard.cppPointer);
      if (vmPointer === NULL_POINTER) {
        throw new ViewModelException(`No default ViewModel found for artboard ${artboard.name}.`);
      }
      const viewModel = new ViewModel(vmPointer);
      this.dependencies.add(viewModel);
      return viewModel;
    } catch (error) {
      console.error(`Error getting default ViewModel for artboard: ${error}`);
      throw error instanceof Error ? error : new Error(String(error));
    }
  }
  
  release(): number {
    // `super.release()` is already @Synchronized, but wrap this in its own lock.
    return super.release()
  }
}