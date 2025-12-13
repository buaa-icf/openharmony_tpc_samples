import { hilog } from '@kit.PerformanceAnalysisKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'
import { FallbackAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';

function getContext(): Context {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  return context;
}

export default function viewModelInstanceTest() {
  describe('ViewModelInstanceTest', () => {
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

    it('ViewModelInstance_Test_name', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;

      const rawFile = await resourceManager.getRawFileContent('data_bind_test_impl.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      rive.Napi_FileAssetLoader_cppSetRendererType(fileAssetLoader.getNativePtr(), 0);
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      let viewModelPtr = rive.Napi_File_cppViewModelByIndex(filePtr, 1);
      expect(viewModelPtr != null).assertTrue();

      let viewModelCount = rive.Napi_File_cppViewModelCount(filePtr);
      expect(viewModelCount == 6).assertTrue();

      const instanceCount = rive.Napi_ViewModel_instanceCount(viewModelPtr);
      expect(instanceCount == 2).assertTrue();

      const instance = rive.Napi_ViewModel_createInstanceFromName(viewModelPtr, "Test Default");
      expect(instance != null).assertTrue();

      let viewModelInstancePtr = rive.Napi_ViewModel_createInstanceFromIndex(viewModelPtr, 0);
      expect(viewModelInstancePtr != null).assertTrue();

      const result = rive.Napi_ViewModelInstance_cppName(viewModelInstancePtr);
      expect(result == "Test Default").assertTrue();

      const propertyInstance = rive.Napi_ViewModelInstance_propertyInstance(viewModelInstancePtr, "Test Nested");
      expect(propertyInstance != null).assertTrue();

      const setInstanceRes = rive.Napi_ViewModelInstance_setInstanceProperty(viewModelInstancePtr, "Test Nested", propertyInstance);
      expect(setInstanceRes).assertTrue();
      done();
    })

    it('ViewModelInstance_Test_property', 0, async (done: Function) => {
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

      // 使用ByName方法获取ViewModel
      let viewModelPtr = rive.Napi_File_cppViewModelByName(filePtr, "vm");
      expect(viewModelPtr > 0).assertTrue();

      let viewModelInstancePtr = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstancePtr > 0).assertTrue();

      const propertyNumber = rive.Napi_ViewModelInstance_propertyNumber(viewModelInstancePtr, "chi/chi-num");
      expect(propertyNumber != null).assertTrue();

      const rootNumProperty = rive.Napi_ViewModelInstance_propertyNumber(viewModelInstancePtr, "num");
      expect(rootNumProperty != null).assertTrue();

      const propertystring = rive.Napi_ViewModelInstance_propertyString(viewModelInstancePtr, "str");
      expect(propertystring != null).assertTrue();

      const propertyColor = rive.Napi_ViewModelInstance_propertyColor(viewModelInstancePtr, "col");
      expect(propertyColor != null).assertTrue();

      const propertyBool = rive.Napi_ViewModelInstance_propertyBoolean(viewModelInstancePtr, "boo");
      expect(propertyBool != null).assertTrue();
      done();
    })

    it('ViewModelInstance_Test_property2', 0, async (done: Function) => {
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

      // 使用ByName方法获取ViewModel
      let viewModelPtr = rive.Napi_File_cppViewModelByName(filePtr, "vm");
      expect(viewModelPtr > 0).assertTrue();

      let viewModelInstancePtr = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstancePtr > 0).assertTrue();

      const propertyEnum = rive.Napi_ViewModelInstance_propertyEnum(viewModelInstancePtr, "enu");
      expect(propertyEnum != null).assertTrue();

      const propertyTrigger = rive.Napi_ViewModelInstance_propertyTrigger(viewModelInstancePtr, "tri");
      expect(propertyTrigger != null).assertTrue();

      const propertyImage = rive.Napi_ViewModelInstance_propertyImage(viewModelInstancePtr, "ima");
      expect(propertyImage != null).assertTrue();

      const propertyList = rive.Napi_ViewModelInstance_propertyList(viewModelInstancePtr, "lis");
      expect(propertyList != null).assertTrue();

      const propertyArtboard = rive.Napi_ViewModelInstance_propertyArtboard(viewModelInstancePtr, "art");
      expect(propertyArtboard != null).assertTrue();
      done();
    })

    it('ViewModelInstance_Test_refInstance', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('target_event.riv');
      expect(rawFile.byteLength != 0).assertTrue();

      const arrayBuffer = rawFile.buffer.slice(0);

      let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
      expect(fileAssetLoader != null).assertTrue();
      let filePtr = rive.Napi_File_import(arrayBuffer, rive.RendererType.Rive, fileAssetLoader.getNativePtr());
      expect(filePtr != 0).assertTrue();

      let viewModelCount = rive.Napi_File_cppViewModelCount(filePtr);
      expect(viewModelCount == 1).assertTrue();

      let viewModelPtr = rive.Napi_File_cppViewModelByIndex(filePtr, 0);
      expect(viewModelPtr != null).assertTrue();

      let viewModelInstancePtr = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstancePtr != null).assertTrue();

      rive.Napi_ViewModelInstance_refInstance(viewModelInstancePtr);
      rive.Napi_ViewModelInstance_derefInstance(viewModelInstancePtr);
      done();
    })

    it('ViewModelInstance_Test_setProperty', 0, async (done: Function) => {
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

      // 使用ByName方法获取ViewModel
      let viewModelPtr = rive.Napi_File_cppViewModelByName(filePtr, "vm");
      expect(viewModelPtr > 0).assertTrue();

      let viewModelInstancePtr = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstancePtr > 0).assertTrue();

      const rootNumProperty = rive.Napi_ViewModelInstance_propertyNumber(viewModelInstancePtr, "num");
      expect(rootNumProperty != null).assertTrue();
      rive.Napi_ViewModelNumberProperty_setValue(rootNumProperty, 123);
      const rootNumValue = rive.Napi_ViewModelNumberProperty_getValue(rootNumProperty);
      expect(rootNumValue == 123).assertTrue();

      const PropertyTrigger = rive.Napi_ViewModelInstance_propertyTrigger(viewModelInstancePtr, "tri");
      rive.Napi_ViewModelTriggerProperty_trigger(PropertyTrigger);

      const PropertyString = rive.Napi_ViewModelInstance_propertyString(viewModelInstancePtr, "str");
      expect(PropertyString != null).assertTrue();
      rive.Napi_ViewModelStringProperty_setValue(PropertyString, "test");
      const PropertyName = rive.Napi_ViewModelProperty_cppName(PropertyString);
      expect(PropertyName == "str").assertTrue();
      const result = rive.Napi_ViewModelProperty_hasChanged(PropertyString);
      expect(result).assertTrue();
      const flashResult = rive.Napi_ViewModelProperty_flushChanges(PropertyString);
      expect(flashResult).assertTrue();
      const strValue = rive.Napi_ViewModelStringProperty_getValue(PropertyString);
      expect(strValue == "test").assertTrue();

      const PropertyBoolean = rive.Napi_ViewModelInstance_propertyBoolean(viewModelInstancePtr, "boo");
      expect(PropertyBoolean != null).assertTrue();
      rive.Napi_ViewModelBooleanProperty_setValue(PropertyBoolean, false);
      const boolValue = rive.Napi_ViewModelBooleanProperty_getValue(PropertyBoolean);
      expect(!boolValue).assertTrue();

      const propertyImage = rive.Napi_ViewModelInstance_propertyImage(viewModelInstancePtr, "ima");
      expect(propertyImage != null).assertTrue();
      let byteArry = new Uint8Array([
        255, 0, 0, 255,   // Opaque red (R, G, B, A)
        0, 255, 0, 128,   // 50% green (R, G, B, A)
        0, 0, 255, 64,    // 25% blue (R, G, B, A)
        255, 255, 255, 0  // Transparent white (R, G, B, A)
      ])
      const renderImage = rive.Napi_RiveRenderImage_cppCreateFromRGBABytes(byteArry, 2, 2, 0, false);
      expect(renderImage != null).assertTrue();
      rive.Napi_ViewModelImageProperty_setValue(propertyImage, renderImage);

      const PropertyColor = rive.Napi_ViewModelInstance_propertyColor(viewModelInstancePtr, "col");
      expect(PropertyColor != null).assertTrue();
      rive.Napi_ViewModelColorProperty_setValue(PropertyColor, 0xFFFF0000);
      const colorValue = rive.Napi_ViewModelColorProperty_getValue(PropertyColor);
      expect((colorValue >>> 0) === 0xFFFF0000).assertTrue();

      const PropertyEnum = rive.Napi_ViewModelInstance_propertyEnum(viewModelInstancePtr, "enu");
      expect(PropertyEnum != null).assertTrue();
      rive.Napi_ViewModelEnumProperty_setValue(PropertyEnum, "Center align");
      const enumValue = rive.Napi_ViewModelEnumProperty_getValue(PropertyEnum);
      expect(enumValue === "Center align").assertTrue();
      done();
    })
  })
}