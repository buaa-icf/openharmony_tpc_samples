import { hilog } from '@kit.PerformanceAnalysisKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'
import { AudioAsset, FileAsset, FontAsset, ImageAsset } from '../../../main/ets/runtime/core/FileAsset';
import { FallbackAssetLoader, FileAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';

function getContext(): Context {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  return context;
}

class TestAssetLoader extends FileAssetLoader {
  constructor() {
    super();
  }

  loadContents(asset: FileAsset, inBandBytes: Uint8Array): boolean {
    console.info("=== TestAssetLoader.loadContents ===");
    console.info("Asset constructor:", asset.constructor.name);
    console.info("Asset is ImageAsset:", asset instanceof ImageAsset);
    console.info("Asset is FontAsset:", asset instanceof FontAsset);
    console.info("Asset is AudioAsset:", asset instanceof AudioAsset);

    // 使用安全的属性访问
    console.info("Asset name:", asset.name);
    console.info("Asset uniqueFilename:", asset.uniqueFilename);
    console.info("Asset cdnUrl:", asset.cdnUrl);
    console.info("Byte array size:", inBandBytes.length);

    // 根据具体类型处理
    if (asset instanceof ImageAsset) {
      const imageAsset = asset as ImageAsset;
      console.info("ImageAsset width:", imageAsset.width);
      console.info("ImageAsset height:", imageAsset.height);
    } else if (asset instanceof FontAsset) {
      console.info("FontAsset handled");
    } else if (asset instanceof AudioAsset) {
      console.info("AudioAsset handled");
    }

    console.info("================================");

    // 返回 true 表示成功处理
    return true;
  }
}

export default function riveFileTest() {
  describe('RiveFileTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      rive.Napi_Rive_cppRegisterClass(FileAsset);
      rive.Napi_Rive_cppRegisterClass(ImageAsset);
      rive.Napi_Rive_cppRegisterClass(FontAsset);
      rive.Napi_Rive_cppRegisterClass(AudioAsset);
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('FileAssetLoaderTest_constructor', 0, (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      rive.Napi_FileAssetLoader_cppRef(fileAssetLoader.getNativePtr());
      rive.Napi_FileAssetLoader_cppSetRendererType(fileAssetLoader.getNativePtr(), rive.RendererType.Rive);
      rive.Napi_FileAssetLoader_cppDelete(fileAssetLoader.getNativePtr());
      done();
    })

    it('File_Test_import', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('data_binding_test.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let testLoader: TestAssetLoader = new TestAssetLoader();
      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, testLoader);
      expect(fileAssetLoader != null).assertTrue();
      rive.Napi_FileAssetLoader_cppSetRendererType(fileAssetLoader.getNativePtr(), rive.RendererType.Rive);
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();
      done();
    })

    it('File_Test_ArtboardByName_withValidName', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const count = rive.Napi_File_cppArtboardCount(filePtr);
      expect(count == 3).assertTrue();

      const firstName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(firstName == 'Square').assertTrue();

      const artboardPtr = rive.Napi_File_cppArtboardByName(filePtr, firstName);
      expect(artboardPtr != 0).assertTrue();

      rive.Napi_BindableArtboard_cppDelete(artboardPtr);
      done();
    })

    it('File_Test_CreateDefault_BindableArtboard', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const bindableArtboardPtr = rive.Napi_File_cppCreateDefaultBindableArtboard(filePtr);
      expect(bindableArtboardPtr != 0).assertTrue();

      const name = rive.Napi_BindableArtboard_cppName(bindableArtboardPtr);
      expect(name == 'Square').assertTrue();
      rive.Napi_BindableArtboard_cppDelete(bindableArtboardPtr);
      done();
    })

    it('File_Test_CreateBindableArtboard_ByName', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const count = rive.Napi_File_cppArtboardCount(filePtr);
      expect(count == 3).assertTrue();

      const firstName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(firstName == 'Square').assertTrue();
      const bindableArtboardPtr = rive.Napi_File_cppCreateBindableArtboardByName(filePtr, firstName);
      expect(bindableArtboardPtr != 0).assertTrue();

      const name = rive.Napi_BindableArtboard_cppName(bindableArtboardPtr);
      expect(name == 'Square').assertTrue();

      rive.Napi_BindableArtboard_cppDelete(bindableArtboardPtr);
      done();
    })

    it('File_Test_ViewModel_Count', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('artboard_animations.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const count = rive.Napi_File_cppViewModelCount(filePtr);
      expect(count == 0).assertTrue();
      done();
    })
  })
}