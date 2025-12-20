import { hilog } from '@kit.PerformanceAnalysisKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'
import { common } from '@kit.AbilityKit';
import { PropertyData, PropertyDataUtils } from '../../../main/ets/runtime/core/ViewModel';
import { FallbackAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';

const DOMAIN = 0x0000;
const TAG = 'RiveTest';

function getContext(): Context {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  return context;
}

export default function viewModelTest() {
  rive.Napi_Rive_cppInitialize();
  describe('ViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
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

    it('ViewModel_Test_cppGetName', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('viewmodel_runtime_file.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const viewModel = rive.Napi_File_cppViewModelByName(filePtr, "vm");
      expect(viewModel != 0).assertTrue();

      const viewModelName = rive.Napi_ViewModel_cppName(viewModel);
      expect(viewModelName == 'vm').assertTrue();

      done();
    })

    it('ViewModel_Test_count', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('viewmodel_runtime_file.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const viewModel = rive.Napi_File_cppViewModelByName(filePtr, "vm");
      expect(viewModel != 0).assertTrue();

      const insCount = rive.Napi_ViewModel_instanceCount(viewModel);
      expect(insCount == 0).assertTrue();

      const perCount = rive.Napi_ViewModel_propertyCount(viewModel);
      expect(perCount == 10).assertTrue();

      done();
    })

    it('ViewModel_Test_Default_Blank_Instance', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('viewmodel_runtime_file.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const viewModel = rive.Napi_File_cppViewModelByName(filePtr, "vm");
      expect(viewModel != 0).assertTrue();

      const blankIns = rive.Napi_ViewModel_createBlankInstance(viewModel);
      expect(blankIns != 0).assertTrue();

      const defaultIns = rive.Napi_ViewModel_createDefaultInstance(viewModel);
      expect(defaultIns != 0).assertTrue();

      done();
    })

    it('ViewModel_Test_GetProperties', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      rive.Napi_Rive_cppRegisterClass(PropertyData);
      rive.Napi_Rive_cppRegisterClass(PropertyDataUtils);
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('viewmodel_runtime_file.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const viewModel = rive.Napi_File_cppViewModelByName(filePtr, "vm");
      expect(viewModel != 0).assertTrue();

      const perVector = rive.Napi_ViewModel_getProperties(viewModel);
      expect(perVector.length == 10).assertTrue();

      done();
    })

    it('ViewModel_Test_List', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('viewmodel_runtime_file.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const viewModel = rive.Napi_File_cppViewModelByName(filePtr, "vm");
      expect(viewModel != 0).assertTrue();

      let defaultIns = rive.Napi_ViewModel_createDefaultInstance(viewModel);
      expect(defaultIns != 0).assertTrue();
      const propertyList = rive.Napi_ViewModelInstance_propertyList(defaultIns, "lis");
      expect(propertyList != null).assertTrue();
      let listSize = rive.Napi_ViewModelListProperty_size(propertyList);
      expect(listSize == 0).assertTrue();

      rive.Napi_ViewModelListProperty_add(propertyList, defaultIns);
      listSize = rive.Napi_ViewModelListProperty_size(propertyList);
      expect(listSize == 1).assertTrue();

      let elementAt = rive.Napi_ViewModelListProperty_elementAt(propertyList, 0);
      expect(elementAt != null).assertTrue();

      const blankIns = rive.Napi_ViewModel_createBlankInstance(viewModel);
      expect(blankIns != 0).assertTrue();
      rive.Napi_ViewModelListProperty_addAt(propertyList, 0, blankIns);
      listSize = rive.Napi_ViewModelListProperty_size(propertyList);
      expect(listSize == 2).assertTrue();

      rive.Napi_ViewModelListProperty_swap(propertyList, 0, 1);

      rive.Napi_ViewModelListProperty_remove(propertyList, blankIns);
      listSize = rive.Napi_ViewModelListProperty_size(propertyList);
      expect(listSize == 1).assertTrue();

      rive.Napi_ViewModelListProperty_removeAt(propertyList, 0);
      listSize = rive.Napi_ViewModelListProperty_size(propertyList);
      expect(listSize == 0).assertTrue();
      done();
    })

    it('ViewModel_Test_Artboard', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('viewmodel_runtime_file.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      const viewModel = rive.Napi_File_cppViewModelByName(filePtr, "vm");
      expect(viewModel != 0).assertTrue();

      const firstName = rive.Napi_File_cppArtboardNameByIndex(filePtr, 0);
      expect(firstName == 'Artboard').assertTrue();
      const artboardInstance = rive.Napi_File_cppArtboardByName(filePtr, firstName);
      expect(artboardInstance != 0).assertTrue();
      let defaultIns = rive.Napi_ViewModel_createDefaultInstance(viewModel);
      expect(defaultIns != 0).assertTrue();
      const propertyArtboard = rive.Napi_ViewModelInstance_propertyArtboard(defaultIns, "art");
      expect(propertyArtboard != null).assertTrue();

      rive.Napi_ViewModelArtboardProperty_setArtboard(propertyArtboard, filePtr, artboardInstance);
      rive.Napi_ViewModelArtboardProperty_setBindableArtboard(propertyArtboard, artboardInstance);
      done();
      })

  })
}