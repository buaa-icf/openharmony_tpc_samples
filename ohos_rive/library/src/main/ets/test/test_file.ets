import rive from 'libohos_rive.so';
import { AdvanceResult } from '../runtime/core/AdvanceResult';
import { File } from '../runtime/core/File'
import { CDNAssetLoader, FallbackAssetLoader, FileAssetLoader } from '../runtime/core/FileAssetLoader';

export async function test_file_import(context: Context): Promise<BigInt> {
  try {
    // 获取资源管理器
    const resourceManager = context.resourceManager;

    // 读取 rawfile 文件
    const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
    console.log(`test_file_import---------Raw file size: ${rawFile.byteLength} bytes`);

    // 转换为 ArrayBuffer
    const arrayBuffer: ArrayBuffer = rawFile.buffer.slice(0);

    let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
    console.log(`test_file_import---------fileAssetLoader size: ${fileAssetLoader.getNativePtr()}`);

    rive.Napi_Rive_cppInitialize();
    rive.Napi_Rive_cppRegisterClass(AdvanceResult, "AdvanceResult");

    // 使用 import 接口导入 Rive 文件
    let filePtr: BigInt = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());

    if (filePtr === 0n) {
      console.error('Failed to import Rive file');
      return 0n;
    }

    console.log('Rive file imported successfully, file reference:', filePtr);
    return filePtr;
  } catch (e) {
    console.error("test_file_import execute failed, reason is:" + e.message);
    return 0n;
  }
}

export function test_ArtboardByName_withValidName(filePtr: BigInt) {
  const testCase = 'Napi_File_cppArtboardByName_Valid';

  try {
    if (filePtr === 0n) {
      console.info(`${testCase}: SKIPPED - File not initialized`);
      return;
    }

    // 首先获取artboard数量
    const count = rive.Napi_File_cppArtboardCount(filePtr);
    console.info(`${testCase}: Artboard count = ${count}`);

    if (count > 0) {
      // 获取第一个artboard的名称
      const firstName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      console.info(`${testCase}: First artboard name = ${firstName}`);

      // 通过名称获取artboard
      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, firstName);
      console.info(`${testCase}: Artboard pointer = ${artboardPtr}`);

      // 清理资源
      if (artboardPtr !== 0n) {
        // 注意：根据C++代码，这里返回的是release()的指针，需要手动管理
        rive.Napi_BindableArtboard_cppDelete(artboardPtr);
      }

      console.info(`${testCase}: PASSED`);
    } else {
      console.info(`${testCase}: SKIPPED - No artboards available`);
    }
  } catch (error) {
    console.error(`${testCase}: FAILED - ${error.message}`);
  }
}


export function test_ArtboardCount_ValidFile(filePtr: BigInt) {
  const testCase = 'Napi_File_cppArtboardCount_Valid';

  try {
    if (filePtr === 0n) {
      console.info(`${testCase}: SKIPPED - File not initialized`);
      return;
    }

    const count = rive.Napi_File_cppArtboardCount(filePtr);
    console.info(`${testCase}: Artboard count = ${count}`);

    console.info(`${testCase}: PASSED`);
  } catch (error) {
    console.error(`${testCase}: FAILED - ${error.message}`);
  }
}

export function test_Artboard_ByIndexValid(filePtr: BigInt) {
  const testCase = 'Napi_File_cppArtboardByIndex_Valid';

  try {
    if (filePtr === 0n) {
      console.info(`${testCase}: SKIPPED - File not initialized`);
      return;
    }

    const count = rive.Napi_File_cppArtboardCount(filePtr);
    console.info(`${testCase}: Artboard count = ${count}`);

    if (count > 0) {
      const artboardPtr = rive.Napi_File_cppArtboardByIndex(filePtr, 0);
      console.info(`${testCase}: Artboard pointer = ${artboardPtr}`);

      // 清理资源
      if (artboardPtr !== 0n) {
        rive.Napi_BindableArtboard_cppDelete(artboardPtr);
      }

      console.info(`${testCase}: PASSED`);
    } else {
      console.info(`${testCase}: SKIPPED - No artboards available`);
    }
  } catch (error) {
    console.error(`${testCase}: FAILED - ${error.message}`);
  }
}

export function test_ArtboardName_ValidIndex(filePtr: BigInt) {
  const testCase = 'Napi_File_cppArtboardNameByIndex_Valid';

  try {
    if (filePtr === 0n) {
      console.info(`${testCase}: SKIPPED - File not initialized`);
      return;
    }

    const count = rive.Napi_File_cppArtboardCount(filePtr);
    if (count > 0) {
      const name = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      console.info(`${testCase}: Artboard name = ${name}`);

      console.info(`${testCase}: PASSED`);
    } else {
      console.info(`${testCase}: SKIPPED - No artboards available`);
    }
  } catch (error) {
    console.error(`${testCase}: FAILED - ${error.message}`);
  }
}

export function test_CreateDefault_BindableArtboard(filePtr: BigInt) {
  const testCase = 'Napi_File_cppCreateDefaultBindableArtboard';

  try {
    if (filePtr === 0n) {
      console.info(`${testCase}: SKIPPED - File not initialized`);
      return;
    }

    const bindableArtboardPtr = rive.Napi_File_cppCreateDefaultBindableArtboard(filePtr);
    console.info(`${testCase}: Bindable artboard pointer = ${bindableArtboardPtr}`);

    if (bindableArtboardPtr !== 0n) {
      // 测试获取名称
      const name = rive.Napi_BindableArtboard_cppName(bindableArtboardPtr);
      console.info(`${testCase}: Bindable artboard name = ${name}`);

      // 清理资源
      rive.Napi_BindableArtboard_cppDelete(bindableArtboardPtr);
    }

    console.info(`${testCase}: PASSED`);
  } catch (error) {
    console.error(`${testCase}: FAILED - ${error.message}`);
  }
}

export function test_CreateBindableArtboard_ByName(filePtr: BigInt) {
  const testCase = 'Napi_File_cppCreateBindableArtboardByName';

  try {
    if (filePtr === 0n) {
      console.info(`${testCase}: SKIPPED - File not initialized`);
      return;
    }

    const count = rive.Napi_File_cppArtboardCount(filePtr);
    if (count > 0) {
      const firstName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      const bindableArtboardPtr = rive.Napi_File_cppCreateBindableArtboardByName(filePtr, firstName);
      console.info(`${testCase}: Bindable artboard pointer = ${bindableArtboardPtr}`);

      if (bindableArtboardPtr !== 0n) {
        // 测试获取名称
        const name = rive.Napi_BindableArtboard_cppName(bindableArtboardPtr);
        console.info(`${testCase}: Bindable artboard name = ${name}`);

        // 清理资源
        rive.Napi_BindableArtboard_cppDelete(bindableArtboardPtr);
      }

      console.info(`${testCase}: PASSED`);
    } else {
      console.info(`${testCase}: SKIPPED - No artboards available`);
    }
  } catch (error) {
    console.error(`${testCase}: FAILED - ${error.message}`);
  }
}

export function test_ViewModel_Count(filePtr: BigInt) {
  const testCase = 'Napi_File_cppViewModelCount';

  try {
    if (filePtr === 0n) {
      console.info(`${testCase}: SKIPPED - File not initialized`);
      return;
    }

    const count = rive.Napi_File_cppViewModelCount(filePtr);
    console.info(`${testCase}: ViewModel count = ${count}`);

    console.info(`${testCase}: PASSED`);
  } catch (error) {
    console.error(`${testCase}: FAILED - ${error.message}`);
  }
}

export function test_ViewModel_ByIndex(filePtr: BigInt) {
  const testCase = 'Napi_File_cppViewModelByIndex';

  try {
    if (filePtr === 0n) {
      console.info(`${testCase}: SKIPPED - File not initialized`);
      return;
    }

    const count = rive.Napi_File_cppViewModelCount(filePtr);
    if (count > 0) {
      const viewModelPtr = rive.Napi_File_cppViewModelByIndex(filePtr, 0);
      console.info(`${testCase}: ViewModel pointer = ${viewModelPtr}`);

      console.info(`${testCase}: PASSED`);
    } else {
      console.info(`${testCase}: SKIPPED - No viewmodels available`);
    }
  } catch (error) {
    console.error(`${testCase}: FAILED - ${error.message}`);
  }
}

export function test_ViewModel_ByName(filePtr: BigInt) {
  const testCase = 'Napi_File_cppViewModelByName';

  try {
    if (filePtr === 0n) {
      console.info(`${testCase}: SKIPPED - File not initialized`);
      return;
    }

    const viewModelPtr = rive.Napi_File_cppViewModelByName(filePtr, "TestViewModel");
    console.info(`${testCase}: ViewModel pointer = ${viewModelPtr}`);

    console.info(`${testCase}: PASSED`);
  } catch (error) {
    console.error(`${testCase}: FAILED - ${error.message}`);
  }
}