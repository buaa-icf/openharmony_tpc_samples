import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'
import { FallbackAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';

const DOMAIN = 0x0000;
const TAG = 'RiveTest';

function getContext(): Context {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  return context;
}

// 辅助函数：获取字体数据
function getFontBytes(): Promise<Uint8Array> {
  return new Promise((resolve, reject) => {
    try {
      const context = getContext();
      const resourceManager = context.resourceManager;
      resourceManager.getRawFileContent('inter.ttf')
        .then(rawFile => {
          resolve(new Uint8Array(rawFile.buffer));
        })
        .catch(() => {
          // 如果没有找到字体文件，返回一个空数组
          reject('No default font file found');
        });
    } catch (error) {
      reject(error);
    }
  });
}

function getFileArrayBuffer(): Promise<ArrayBuffer> {
  return new Promise((resolve, reject) => {
    try {
      const context = getContext();
      const resourceManager = context.resourceManager;
      resourceManager.getRawFileContent('inter.ttf')
        .then(rawFile => {
          resolve(rawFile.buffer.slice(0));
        })
        .catch(() => {
          // 如果没有找到字体文件，返回一个空数组
          reject('No default font file found');
        });
    } catch (error) {
      reject(error);
    }
  });
}

export default function commandQueueTest() {
  rive.Napi_Rive_cppInitialize();
  describe('CommandQueueTest', () => {
    beforeAll(async () => {
      hilog.info(DOMAIN, TAG, 'beforeAll called');
    });

    beforeEach(async () => {
      hilog.info(DOMAIN, TAG, 'beforeEach called');
    });

    afterEach(async () => {
      hilog.info(DOMAIN, TAG, 'afterEach called');
    });

    afterAll(async () => {
      hilog.info(DOMAIN, TAG, 'afterAll called');
    });

    /**
     * @tc.number: RIVE_CommandQueue_0100
     * @tc.name: CommandQueue_Test_constructor_and_delete
     * @tc.desc: Test Napi_CommandQueue_constructor interface for resource cleanup
     */
    it('CommandQueue_Test_constructor_and_delete', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'CommandQueue_Test_constructor_and_delete begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();

      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'CommandQueue_Test_constructor_and_delete end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0200
     * @tc.name: CommandQueue_Test_CreateRenderTarget
     * @tc.desc: Test Napi_CommandQueue_cppCreateRenderTarget
     */
    it('Napi_CommandQueue_cppCreateRenderTarget', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppCreateRenderTarget begin');
      let renderTarget = await rive.Napi_CommandQueue_cppCreateRenderTarget(10, 10);
      expect(renderTarget != null).assertTrue();
      rive.Napi_CommandQueue_cppDeleteRiveSurface(renderTarget);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppCreateRenderTarget end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0300
     * @tc.name: CommandQueue_Test_loadFile
     * @tc.desc: Test Napi_CommandQueue_cppLoadFile interface
     */
    it('CommandQueue_Test_loadFile', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'CommandQueue_Test_loadFile begin');

      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'CommandQueue_Test_loadFile end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0500
     * @tc.name: CommandQueue_Test_DefaultArtboard
     * @tc.desc: Test Napi_CommandQueue_cppCreateDefaultArtboard interface
     */
    it('CommandQueue_Test_DefaultArtboard', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'CommandQueue_Test_DefaultArtboard begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();

      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);

      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'CommandQueue_Test_DefaultArtboard end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0501
     * @tc.name: CommandQueue_Test_CreateArtboardByName
     * @tc.desc: Test Napi_CommandQueue_cppCreateArtboardByName interface
     */
    it('CommandQueue_Test_CreateArtboardByName', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'CommandQueue_Test_CreateArtboardByName begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();

      let artboardHandle = rive.Napi_CommandQueue_cppCreateArtboardByName(commandQueue, mockRequestID, fileHandle, 'Artboard');
      expect(artboardHandle != 0).assertTrue();
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);

      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'CommandQueue_Test_CreateArtboardByName end');
      done();
    });    

    /**
     * @tc.number: RIVE_CommandQueue_0502
     * @tc.name: CommandQueue_Test_GetArtboardNames
     * @tc.desc: Test Napi_CommandQueue_cppGetArtboardNames interface for retrieving artboard names
     */
    it('CommandQueue_Test_GetArtboardNames', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'CommandQueue_Test_GetArtboardNames begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      
      rive.Napi_CommandQueue_cppGetArtboardNames(commandQueue, mockRequestID, fileHandle);
      
      // 清理资源
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      
      hilog.info(DOMAIN, TAG, 'CommandQueue_Test_GetArtboardNames end');
      done();
    });  

    /**
     * @tc.number: RIVE_CommandQueue_0600
     * @tc.name: CommandQueue_Test_DefaultStateMachine
     * @tc.desc: Test Napi_CommandQueue_cppCreateDefaultStateMachine
     */
    it('Napi_CommandQueue_cppDefaultStateMachine', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDefaultStateMachine begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();

      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let stateMachine = rive.Napi_CommandQueue_cppCreateDefaultStateMachine(commandQueue, mockRequestID,
        artboardHandle);
      expect(stateMachine != 0).assertTrue();

      rive.Napi_CommandQueue_cppDeleteStateMachine(commandQueue, mockRequestID, stateMachine);
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDefaultStateMachine end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0601
     * @tc.name: CommandQueue_Test_CreateStateMachineByName
     * @tc.desc: Test Napi_CommandQueue_cppCreateStateMachineByName
     */
    it('Napi_CommandQueue_cppCreateStateMachineByName', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppCreateStateMachineByName begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();

      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let stateMachine = rive.Napi_CommandQueue_cppCreateStateMachineByName(commandQueue, mockRequestID,
        artboardHandle, 'State Machine');
      expect(stateMachine != 0).assertTrue();

      rive.Napi_CommandQueue_cppDeleteStateMachine(commandQueue, mockRequestID, stateMachine);
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppCreateStateMachineByName end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0602
     * @tc.name: CommandQueue_Test_GetStateMachineNames
     * @tc.desc: Test Napi_CommandQueue_cppGetStateMachineNames interface for retrieving artboard names
     */
    it('Napi_CommandQueue_cppGetStateMachineNames', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetStateMachineNames begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      rive.Napi_CommandQueue_cppGetStateMachineNames(commandQueue, mockRequestID, artboardHandle);
      
      // 清理资源
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetStateMachineNames end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0603
     * @tc.name: CommandQueue_Test_AdvanceStateMachine
     * @tc.desc: Test Napi_CommandQueue_cppAdvanceStateMachine interface for retrieving artboard names
     */
    it('Napi_CommandQueue_cppAdvanceStateMachine', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppAdvanceStateMachine begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();

      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      let stateMachine = rive.Napi_CommandQueue_cppCreateDefaultStateMachine(commandQueue, mockRequestID,
        artboardHandle);
      expect(stateMachine != 0).assertTrue();
      const deltaTimeNs: number = 1000; // 1ms
      rive.Napi_CommandQueue_cppAdvanceStateMachine(commandQueue, stateMachine, deltaTimeNs);
      
      // 清理资源
      rive.Napi_CommandQueue_cppDeleteStateMachine(commandQueue, mockRequestID, stateMachine);
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppAdvanceStateMachine end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0700
     * @tc.name: CommandQueue_Test_DeleteViewModelInstance
     * @tc.desc: Test Napi_CommandQueue_cppDeleteViewModelInstance
     */
    it('Napi_CommandQueue_cppDeleteViewModelInstance', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDeleteViewModelInstance begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let fileBuffer = await getFileArrayBuffer();
      expect(fileBuffer.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, fileBuffer);
      expect(fileHandle != 0).assertTrue();

      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();

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
      let viewModeHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModeHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModeHandle);
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDeleteViewModelInstance end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0701
     * @tc.name: CommandQueue_Test_GetViewModelNames
     * @tc.desc: Test Napi_CommandQueue_cppGetViewModelNames
     */
    it('Napi_CommandQueue_cppGetViewModelNames', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetViewModelNames begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      rive.Napi_CommandQueue_cppGetViewModelNames(commandQueue, mockRequestID, fileHandle);
      
      // 清理资源
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetViewModelNames end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0702
     * @tc.name: CommandQueue_Test_GetViewModelInstanceNames
     * @tc.desc: Test Napi_CommandQueue_cppGetViewModelInstanceNames
     */
    it('Napi_CommandQueue_cppGetViewModelInstanceNames', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetViewModelInstanceNames begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      rive.Napi_CommandQueue_cppGetViewModelInstanceNames(commandQueue, mockRequestID, fileHandle, "vm");
      
      // 清理资源
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetViewModelInstanceNames end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0703
     * @tc.name: CommandQueue_Test_GetViewModelProperties
     * @tc.desc: Test Napi_CommandQueue_cppGetViewModelProperties
     */
    it('Napi_CommandQueue_cppGetViewModelProperties', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetViewModelProperties begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      rive.Napi_CommandQueue_cppGetViewModelProperties(commandQueue, mockRequestID, fileHandle, "vm");
      
      // 清理资源
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetViewModelProperties end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0704
     * @tc.name: CommandQueue_Test_CommandQueueGetEnums
     * @tc.desc: Test Napi_CommandQueue_cppCommandQueueGetEnums
     */
    it('Napi_CommandQueue_cppCommandQueueGetEnums', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppCommandQueueGetEnums begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      rive.Napi_CommandQueue_cppGetEnums(commandQueue, mockRequestID, fileHandle);
      
      // 清理资源
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppCommandQueueGetEnums end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0800
     * @tc.name: CommandQueue_Test_DeleteImage
     * @tc.desc: Test Napi_CommandQueue_cppDeleteImage
     */
    it('Napi_CommandQueue_cppDeleteImage', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDeleteImage begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      // 创建一个简单的1x1像素的RGBA图像数据
      const imageData = new Uint8Array([255, 0, 0, 255]); // 红色像素
      // 使用Napi_RiveRenderImage_cppCreateFromRGBABytes创建图像
      let imageHandle = rive.Napi_RiveRenderImage_cppCreateFromRGBABytes(
        imageData,
        1,
        1,
        rive.RendererType.Rive,
        false
      );
      expect(imageHandle > 0).assertTrue();

      // 测试删除图像
      rive.Napi_CommandQueue_cppDeleteImage(commandQueue, imageHandle);

      // 清理资源
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDeleteImage end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0900
     * @tc.name: CommandQueue_Test_DeleteFont
     * @tc.desc: Test Napi_CommandQueue_cppDeleteFont
     */
    it('Napi_CommandQueue_cppDeleteFont', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDeleteFont begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      try {
        let fontBytes = await getFontBytes();
        expect(fontBytes.byteLength > 0).assertTrue();
        
        // 使用Napi_RiveFont_00024Companion_cppMakeFont创建字体
        let fontHandle = rive.Napi_RiveFont_00024Companion_cppMakeFont(
          fontBytes,
          rive.RendererType.Rive
        );
        expect(fontHandle > 0).assertTrue();

        // 测试删除字体
        rive.Napi_CommandQueue_cppDeleteFont(commandQueue, fontHandle);
      } catch (error) {
        hilog.error(DOMAIN, TAG, 'Failed to get system font: ' + error);
        // 如果没有系统字体，创建一个空的字体数据作为备选
        const emptyFontData = new Uint8Array(0);
        try {
          let fontHandle = rive.Napi_RiveFont_00024Companion_cppMakeFont(
            emptyFontData,
            rive.RendererType.Rive
          );
          if (fontHandle > 0) {
            rive.Napi_CommandQueue_cppDeleteFont(commandQueue, fontHandle);
          }
        } catch (innerError) {
          // 如果创建也失败，记录但不影响测试流程
          hilog.error(DOMAIN, TAG, 'Failed to create font: ' + innerError);
        }
      }

      // 清理资源
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDeleteFont end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0901
     * @tc.name: CommandQueue_Test_DecodeFont
     * @tc.desc: Test Napi_CommandQueue_cppDecodeFont
     */
    it('Napi_CommandQueue_cppDecodeFont', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDecodeFont begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      const context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('inter.ttf')
      expect(rawFile.byteLength != 0).assertTrue();
      let fontArrayBuffer = rawFile.buffer.slice(0);
      expect(fontArrayBuffer.byteLength > 0).assertTrue();

      const requestId: number = 0;
      rive.Napi_CommandQueue_cppDecodeFont(commandQueue, requestId, fontArrayBuffer);
      // 清理资源
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDecodeFont end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_0902
     * @tc.name: CommandQueue_Test_RegisterFont
     * @tc.desc: Test Napi_CommandQueue_cppRegisterFont
     */
    it('Napi_CommandQueue_cppRegisterFont', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppRegisterFont begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppRegisterFont(commandQueue, 'path', fileHandle);
      rive.Napi_CommandQueue_cppUnregisterFont(commandQueue, 'path');
      // 清理资源
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppRegisterFont end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_1000
     * @tc.name: CommandQueue_Test_CommandQueueNamedVMCreateBlankVMI
     * @tc.desc: Test Napi_CommandQueue_cppNamedVMCreateBlankVMI
     */
    it('Napi_CommandQueue_cppNamedVMCreateBlankVMI', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppNamedVMCreateBlankVMI begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let dfaultVMCreateBlankVMI = rive.Napi_CommandQueue_cppNamedVMCreateBlankVMI(commandQueue, mockRequestID, fileHandle, "123");
      expect(dfaultVMCreateBlankVMI != 0).assertTrue();
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppNamedVMCreateBlankVMI end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_1100
     * @tc.name: CommandQueue_Test_CommandQueueDefaultVMCreateBlankVMI
     * @tc.desc: Test Napi_CommandQueueDefaultVMCreateBlankVMI
     */
    it('Napi_CommandQueueDefaultVMCreateBlankVMI', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueueDefaultVMCreateBlankVMI begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let defaultVMCreateBlankVMI = rive.Napi_CommandQueue_cppDefaultVMCreateBlankVMI(commandQueue, mockRequestID, fileHandle, artboardHandle);
      expect(defaultVMCreateBlankVMI != 0).assertTrue();
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueueDefaultVMCreateBlankVMI end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_1200
     * @tc.name: CommandQueue_Test_CommandQueueDefaultVMCreateDefaultVMI
     * @tc.desc: Test Napi_CommandQueue_cppNamedVMCreateDefaultVMI
     */
    it('Napi_CommandQueue_cppNamedVMCreateDefaultVMI', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppNamedVMCreateDefaultVMI begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let defaultVMCreateBlankVMI = rive.Napi_CommandQueue_cppNamedVMCreateDefaultVMI(commandQueue, mockRequestID,
        fileHandle, "artboardHandle");
      expect(defaultVMCreateBlankVMI != 0).assertTrue();
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppNamedVMCreateDefaultVMI end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_1300
     * @tc.name: CommandQueue_Test_CommandQueueDefaultVMCreateDefaultVMI
     * @tc.desc: Test Napi_CommandQueue_cppDefaultVMCreateBlankVMI
     */
    it('Napi_CommandQueue_cppDefaultVMCreateBlankVMI', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDefaultVMCreateBlankVMI begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let defaultVMCreateBlankVMI = rive.Napi_CommandQueue_cppDefaultVMCreateBlankVMI(commandQueue, mockRequestID,
        fileHandle, artboardHandle);
      expect(defaultVMCreateBlankVMI != 0).assertTrue();
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDefaultVMCreateBlankVMI end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_1400
     * @tc.name: CommandQueue_Test_CommandQueueNamedVMCreateNamedVMI
     * @tc.desc: Test Napi_CommandQueue_cppNamedVMCreateNamedVMI
     */
    it('Napi_CommandQueue_cppNamedVMCreateNamedVMI', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppNamedVMCreateNamedVMI begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let namedVMCreateNamedVMI = rive.Napi_CommandQueue_cppNamedVMCreateNamedVMI(commandQueue, mockRequestID, fileHandle,
        "artboardHandle", "instanceName");
      expect(namedVMCreateNamedVMI != 0).assertTrue();
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppNamedVMCreateNamedVMI end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_1500
     * @tc.name: CommandQueue_Test_CommandQueueDefaultVMCreateNamedVMI
     * @tc.desc: Test Napi_CommandQueue_cppDefaultVMCreateNamedVMI
     */
    it('Napi_CommandQueue_cppDefaultVMCreateNamedVMI', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDefaultVMCreateNamedVMI begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let defaultVMCreateNamedVMI = rive.Napi_CommandQueue_cppDefaultVMCreateNamedVMI(commandQueue, mockRequestID, fileHandle,
        artboardHandle, "instanceName");
      expect(defaultVMCreateNamedVMI != 0).assertTrue();
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDefaultVMCreateNamedVMI end');
      done();
    });


    /**
     * @tc.number: RIVE_CommandQueue_1600
     * @tc.name: CommandQueue_Test_CommandQueueReferenceNestedVMI
     * @tc.desc: Test Napi_CommandQueue_cppReferenceNestedVMI
     */
    it('Napi_CommandQueue_cppReferenceNestedVMI', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppReferenceNestedVMI begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let fileArray = await getFileArrayBuffer();
      expect(fileArray.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, fileArray);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      let defaultVMCreateNamedVMI = rive.Napi_CommandQueue_cppReferenceNestedVMI(commandQueue, mockRequestID, viewModelPtr,
         "pathLength");
      expect(defaultVMCreateNamedVMI != 0).assertTrue();
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppReferenceNestedVMI end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_1700
     * @tc.name: CommandQueue_Test_CommandQueueBindViewModelInstance
     * @tc.desc: Test Napi_CommandQueue_cppBindViewModelInstance
     */
    it('Napi_CommandQueue_cppBindViewModelInstance', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppBindViewModelInstance begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let fileArray = await getFileArrayBuffer();
      expect(fileArray.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, fileArray);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let stateMachine = rive.Napi_CommandQueue_cppCreateDefaultStateMachine(commandQueue, mockRequestID,
        artboardHandle);
      expect(stateMachine != 0).assertTrue();

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppBindViewModelInstance(commandQueue, mockRequestID, stateMachine,
        viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppBindViewModelInstance end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_1800
     * @tc.name: CommandQueue_Test_CommandQueueSetNumberProperty
     * @tc.desc: Test Napi_CommandQueue_cppSetNumberProperty
     */
    it('Napi_CommandQueue_cppSetNumberProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSetNumberProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppSetNumberProperty(commandQueue, viewModelInstanceHandle, "pathLength",
        viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSetNumberProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_1900
     * @tc.name: CommandQueue_Test_CommandQueueGetNumberProperty
     * @tc.desc: Test Napi_CommandQueue_cppGetNumberProperty
     */
    it('Napi_CommandQueue_cppGetNumberProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetNumberProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppGetNumberProperty(commandQueue, mockRequestID,
        viewModelInstanceHandle, "pathLength");
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetNumberProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_2000
     * @tc.name: CommandQueue_Test_CommandQueueSetStringProperty
     * @tc.desc: Test Napi_CommandQueue_cppSetStringProperty
     */
    it('Napi_CommandQueue_cppSetStringProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSetStringProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppSetStringProperty(commandQueue, viewModelInstanceHandle,
        "pathLength", "valueLength");
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSetStringProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_2100
     * @tc.name: CommandQueue_Test_CommandQueueGetStringProperty
     * @tc.desc: Test Napi_CommandQueue_cppGetStringProperty
     */
    it('Napi_CommandQueue_cppGetStringProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetStringProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppGetStringProperty(commandQueue, mockRequestID,
        viewModelInstanceHandle, "pathLength");
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetStringProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_2200
     * @tc.name: CommandQueue_Test_CommandQueueSetBooleanProperty
     * @tc.desc: Test Napi_CommandQueue_cppSetBooleanProperty
     */
    it('Napi_CommandQueue_cppSetBooleanProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSetBooleanProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppSetBooleanProperty(commandQueue, viewModelInstanceHandle, "pathLength", true);
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSetBooleanProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_2300
     * @tc.name: CommandQueue_Test_CommandQueueGetBooleanProperty
     * @tc.desc: Test Napi_CommandQueue_cppGetBooleanProperty
     */
    it('Napi_CommandQueue_cppGetBooleanProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetBooleanProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppGetBooleanProperty(commandQueue, mockRequestID,
        viewModelInstanceHandle, "pathLength");
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetBooleanProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_2400
     * @tc.name: CommandQueue_Test_CommandQueueSetEnumProperty
     * @tc.desc: Test Napi_CommandQueue_cppSetEnumProperty
     */
    it('Napi_CommandQueue_cppSetEnumProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSetEnumProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppSetEnumProperty(commandQueue, viewModelInstanceHandle, "pathLength", "valueLength");
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSetEnumProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_2500
     * @tc.name: CommandQueue_Test_CommandQueueGetEnumProperty
     * @tc.desc: Test Napi_CommandQueue_cppGetEnumProperty
     */
    it('Napi_CommandQueue_cppGetEnumProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetEnumProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppGetEnumProperty(commandQueue, mockRequestID,
        viewModelInstanceHandle, "pathLength");
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetEnumProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_2600
     * @tc.name: CommandQueue_Test_CommandQueueSetColorProperty
     * @tc.desc: Test Napi_CommandQueue_cppSetColorProperty
     */
    it('Napi_CommandQueue_cppSetColorProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSetColorProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppSetColorProperty(commandQueue, viewModelInstanceHandle, "pathLength", 16777215);
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSetColorProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_2700
     * @tc.name: CommandQueue_Test_CommandQueueGetColorProperty
     * @tc.desc: Test Napi_CommandQueue_cppGetColorProperty
     */
    it('Napi_CommandQueue_cppGetColorProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetColorProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppGetColorProperty(commandQueue, mockRequestID,
        viewModelInstanceHandle, "pathLength");
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppGetColorProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_2800
     * @tc.name: CommandQueue_Test_CommandQueueFireTriggerProperty
     * @tc.desc: Test Napi_CommandQueue_cppFireTriggerProperty
     */
    it('Napi_CommandQueue_cppFireTriggerProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppFireTriggerProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      rive.Napi_CommandQueue_cppFireTriggerProperty(commandQueue, viewModelInstanceHandle, "pathLength");
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppFireTriggerProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_2900
     * @tc.name: CommandQueue_Test_CommandQueueSubscribeToProperty
     * @tc.desc: Test Napi_CommandQueue_cppSubscribeToProperty
     */
    it('Napi_CommandQueue_cppSubscribeToProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSubscribeToProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      const propertyType: number  = 0;
      rive.Napi_CommandQueue_cppSubscribeToProperty(commandQueue, viewModelInstanceHandle, "pathLength", propertyType);
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppSubscribeToProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3000
     * @tc.name: CommandQueue_Test_CommandQueueUnsubscribeFromProperty
     * @tc.desc: Test Napi_CommandQueue_cppUnsubscribeFromProperty
     */
    it('Napi_CommandQueue_cppUnsubscribeFromProperty', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppUnsubscribeFromProperty begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

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
      let viewModelInstanceHandle = rive.Napi_ViewModel_createDefaultInstance(viewModelPtr);
      expect(viewModelInstanceHandle != 0).assertTrue();

      const propertyType: number  = 0;
      rive.Napi_CommandQueue_cppUnsubscribeFromProperty(commandQueue, viewModelInstanceHandle, "pathLength", propertyType);
      rive.Napi_CommandQueue_cppDeleteViewModelInstance(commandQueue, mockRequestID, viewModelInstanceHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppUnsubscribeFromProperty end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3100
     * @tc.name: CommandQueue_Test_CommandQueueDecodeImage
     * @tc.desc: Test Napi_CommandQueue_cppDecodeImage
     */
    it('Napi_CommandQueue_cppDecodeImage', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDecodeImage begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('viewmodel_runtime_file.riv');
      expect(rawFile.byteLength != 0).assertTrue();
      const arrayBuffer = rawFile.buffer.slice(0);
      rive.Napi_CommandQueue_cppDecodeImage(commandQueue, mockRequestID, arrayBuffer);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDecodeImage end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3200
     * @tc.name: CommandQueue_Test_CommandQueueRegisterImage
     * @tc.desc: Test Napi_CommandQueue_cppRegisterImage
     */
    it('Napi_CommandQueue_cppRegisterImage', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppRegisterImage begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      // 创建一个简单的1x1像素的RGBA图像数据
      const imageData = new Uint8Array([255, 0, 0, 255]); // 红色像素
      // 使用Napi_RiveRenderImage_cppCreateFromRGBABytes创建图像
      let imageHandle = rive.Napi_RiveRenderImage_cppCreateFromRGBABytes(
        imageData,
        1,
        1,
        rive.RendererType.Rive,
        false
      );
      expect(imageHandle > 0).assertTrue();


      rive.Napi_CommandQueue_cppRegisterImage(commandQueue, "pathLength", imageHandle);
      // 测试删除图像
      rive.Napi_CommandQueue_cppDeleteImage(commandQueue, imageHandle);
      rive.Napi_CommandQueue_cppUnregisterImage(commandQueue, "pathLength");
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppRegisterImage end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3300
     * @tc.name: CommandQueue_Test_CommandQueueDecodeAudio
     * @tc.desc: Test Napi_CommandQueue_cppDecodeAudio
     */
    it('Napi_CommandQueue_cppDecodeAudio', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDecodeAudio begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      const mockRequestID: number = 0;

      let context = getContext();
      const resourceManager = context.resourceManager;
      const rawFile = await resourceManager.getRawFileContent('viewmodel_runtime_file.riv');
      expect(rawFile.byteLength != 0).assertTrue();
      const arrayBuffer = rawFile.buffer.slice(0);

      //解码音频
      rive.Napi_CommandQueue_cppDecodeAudio(commandQueue, mockRequestID, arrayBuffer);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDecodeAudio end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3400
     * @tc.name: CommandQueue_Test_CommandQueueDeleteAudio
     * @tc.desc: Test Napi_CommandQueue_cppDeleteAudio
     */
    it('Napi_CommandQueue_cppDeleteAudio', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDeleteAudio begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      // 创建音频
      const emptyFontData = new Uint8Array(0);
      let audioHandle = rive.Napi_RiveAudio_00024Companion_cppMakeAudio(emptyFontData, rive.RendererType.Rive)
      //音频 删除
      rive.Napi_CommandQueue_cppDeleteAudio(commandQueue, audioHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDeleteAudio end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3500
     * @tc.name: CommandQueue_Test_CommandQueueRegisterAudio and CommandQueueUnregisterAudio
     * @tc.desc: Test Napi_CommandQueue_cppRegisterAudio and Napi_CommandQueue_cppUnregisterAudio
     */
    it('Napi_CommandQueue_cppRegisterAudio and Napi_CommandQueue_cppUnregisterAudio', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDeleteAudio begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      // 创建音频
      const emptyFontData = new Uint8Array(0);
      let audioHandle = rive.Napi_RiveAudio_00024Companion_cppMakeAudio(emptyFontData, rive.RendererType.Rive)
      // 注册音频
      rive.Napi_CommandQueue_cppRegisterAudio(commandQueue, "pathLength", audioHandle)
      // 注销音频
      rive.Napi_CommandQueue_cppUnregisterAudio(commandQueue, "pathLength")
      //音频 删除
      rive.Napi_CommandQueue_cppDeleteAudio(commandQueue, audioHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDeleteAudio end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3601
     * @tc.name: CommandQueue_Test_PointerMove
     * @tc.desc: Test Napi_CommandQueue_cppPointerMove
     */
    it('Napi_CommandQueue_cppPointerMove', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppPointerMove begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let stateMachine = rive.Napi_CommandQueue_cppCreateStateMachineByName(commandQueue, mockRequestID,
        artboardHandle, 'State Machine');
      expect(stateMachine != 0).assertTrue();

      rive.Napi_CommandQueue_cppPointerMove(commandQueue, stateMachine, 0, 0, 10, 10, 0, 0, 0);

      rive.Napi_CommandQueue_cppDeleteStateMachine(commandQueue, mockRequestID, stateMachine);
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppPointerMove end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3602
     * @tc.name: CommandQueue_Test_PointerDown
     * @tc.desc: Test Napi_CommandQueue_cppPointerDown
     */
    it('Napi_CommandQueue_cppPointerDown', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppPointerDown begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let stateMachine = rive.Napi_CommandQueue_cppCreateStateMachineByName(commandQueue, mockRequestID,
        artboardHandle, 'State Machine');
      expect(stateMachine != 0).assertTrue();

      rive.Napi_CommandQueue_cppPointerDown(commandQueue, stateMachine, 0, 0, 10, 10, 0, 0, 0);

      rive.Napi_CommandQueue_cppDeleteStateMachine(commandQueue, mockRequestID, stateMachine);
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);

      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppPointerDown end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3603
     * @tc.name: CommandQueue_Test_PointerUp
     * @tc.desc: Test Napi_CommandQueue_cppPointerUp
     */
    it('Napi_CommandQueue_cppPointerUp', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppPointerUp begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let stateMachine = rive.Napi_CommandQueue_cppCreateStateMachineByName(commandQueue, mockRequestID,
        artboardHandle, 'State Machine');
      expect(stateMachine != 0).assertTrue();

      rive.Napi_CommandQueue_cppPointerUp(commandQueue, stateMachine, 0, 0, 10, 10, 0, 0, 0);

      rive.Napi_CommandQueue_cppDeleteStateMachine(commandQueue, mockRequestID, stateMachine);
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);

      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppPointerUp end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3604
     * @tc.name: CommandQueue_Test_PointerExit
     * @tc.desc: Test Napi_CommandQueue_cppPointerExit
     */
    it('Napi_CommandQueue_cppPointerExit', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppPointerExit begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let stateMachine = rive.Napi_CommandQueue_cppCreateStateMachineByName(commandQueue, mockRequestID,
        artboardHandle, 'State Machine');
      expect(stateMachine != 0).assertTrue();

      rive.Napi_CommandQueue_cppPointerExit(commandQueue, stateMachine, 0, 0, 10, 10, 0, 0, 0);

      rive.Napi_CommandQueue_cppDeleteStateMachine(commandQueue, mockRequestID, stateMachine);
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);

      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppPointerExit end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3700
     * @tc.name: CommandQueue_Test_CreateDrawKey
     * @tc.desc: Test Napi_CommandQueue_cppCreateDrawKey
     */
    it('Napi_CommandQueue_cppCreateDrawKey', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppCreateDrawKey begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      let drawKey = rive.Napi_CommandQueue_cppCreateDrawKey(commandQueue);
      expect(drawKey != 0).assertTrue();

      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppCreateDrawKey end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3701
     * @tc.name: CommandQueue_Test_PollMessages
     * @tc.desc: Test Napi_CommandQueue_cppPollMessages
     */
    it('Napi_CommandQueue_cppPollMessages', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppPollMessages begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();

      rive.Napi_CommandQueue_cppPollMessages(commandQueue);

      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppPollMessages end');
      done();
    });

    /**
     * @tc.number: RIVE_CommandQueue_3702
     * @tc.name: CommandQueue_Test_Draw
     * @tc.desc: Test Napi_CommandQueue_cppDraw
     */
    it('Napi_CommandQueue_cppDraw', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDraw begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let surfacePtr = rive.Napi_CommandQueue_cppCreateEglSurface(displayPtr, contextPtr);
      expect(surfacePtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let stateMachine = rive.Napi_CommandQueue_cppCreateStateMachineByName(commandQueue, mockRequestID,
        artboardHandle, 'State Machine');
      expect(stateMachine != 0).assertTrue();
      let renderTarget = await rive.Napi_CommandQueue_cppCreateRenderTarget(10, 10);
      expect(renderTarget != null).assertTrue();
      let drawKey = rive.Napi_CommandQueue_cppCreateDrawKey(commandQueue);
      expect(drawKey != 0).assertTrue();

      rive.Napi_CommandQueue_cppDraw(commandQueue, displayPtr, surfacePtr, contextPtr, drawKey, artboardHandle,
        stateMachine, renderTarget, 10, 10, 0, 0, 0);

      rive.Napi_CommandQueue_cppDeleteStateMachine(commandQueue, mockRequestID, stateMachine);
      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppDraw end');
      done();
    });
    
    /**
     * @tc.number: RIVE_CommandQueue_3800
     * @tc.name: CommandQueue_Test_CommandQueueCreateListeners
     * @tc.desc: Test Napi_CommandQueue_cppCreateListeners
     */
    it('Napi_CommandQueue_cppCreateListeners', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppCreateListeners begin');
      let displayPtr = rive.Napi_CommandQueue_cppGetEglDisplay();
      expect(displayPtr != null).assertTrue();
      let contextPtr = rive.Napi_CommandQueue_cppCreateEglContext(displayPtr);
      expect(contextPtr != null).assertTrue();
      let commandQueue = await rive.Napi_CommandQueue_constructor(displayPtr, contextPtr);
      expect(commandQueue != null).assertTrue();
      let rawFile = await getFileArrayBuffer();
      expect(rawFile.byteLength != 0).assertTrue();
      const mockRequestID: number = 0;
      const fileHandle = rive.Napi_CommandQueue_cppLoadFile(commandQueue, mockRequestID, rawFile);
      expect(fileHandle != 0).assertTrue();
      let artboardHandle = rive.Napi_CommandQueue_cppCreateDefaultArtboard(commandQueue, mockRequestID, fileHandle);
      expect(artboardHandle != 0).assertTrue();
      let stateMachine = rive.Napi_CommandQueue_cppCreateDefaultStateMachine(commandQueue, mockRequestID,
        artboardHandle);
      expect(stateMachine != 0).assertTrue();

      // 创建监听器
      const createListeners = rive.Napi_CommandQueue_cppCreateListeners(commandQueue, 0);
      expect(createListeners != null).assertTrue();

      // 删除监听器
      rive.Napi_CommandQueue_cppDeleteListeners(0, 0, 0, 0, 0, 0, 0);

      rive.Napi_CommandQueue_cppDeleteArtboard(commandQueue, mockRequestID, artboardHandle);
      rive.Napi_CommandQueue_cppDeleteFile(commandQueue, mockRequestID, fileHandle);
      rive.Napi_CommandQueue_cppDelete(commandQueue);
      rive.Napi_CommandQueue_cppDeleteEglContext(displayPtr, contextPtr);
      hilog.info(DOMAIN, TAG, 'Napi_CommandQueue_cppCreateListeners end');
      done();
    });
  })
}