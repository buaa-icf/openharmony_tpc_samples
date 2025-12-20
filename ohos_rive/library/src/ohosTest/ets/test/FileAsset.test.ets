import { hilog } from '@kit.PerformanceAnalysisKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import rive from 'libohos_rive.so'
import { AudioAsset, FileAsset, FontAsset, ImageAsset } from '../../../main/ets/runtime/core/FileAsset';
import { FallbackAssetLoader, FileAssetLoader } from '../../../main/ets/runtime/core/FileAssetLoader';
import { image } from '@kit.ImageKit';

function getContext(): Context {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  return context;
}

async function loadImageRawFile(): Promise<Uint8Array> {
  let context = getContext();
  const resourceMgr = context.resourceManager;

  const imageRawFile = await resourceMgr.getRawFileContent('eve.png');
  const imageBytes = new Uint8Array(imageRawFile.buffer);

  console.info(`Loaded resources - Image: ${imageBytes.length} bytes`);
  return imageBytes;
}

async function loadFontRawFile(): Promise<Uint8Array> {
  let context = getContext();
  const resourceMgr = context.resourceManager;

  const fontRawFile = await resourceMgr.getRawFileContent('font.ttf');
  const fontBytes = new Uint8Array(fontRawFile.buffer);

  console.info(`Loaded resources - Font: ${fontBytes.length} bytes`);
  return fontBytes;
}

async function loadAudioRawFile(): Promise<Uint8Array> {
  let context = getContext();
  const resourceMgr = context.resourceManager;

  const audioRawFile = await resourceMgr.getRawFileContent('table.wav');
  const audioBytes = new Uint8Array(audioRawFile.buffer);

  console.info(`Loaded resources - Audio: ${audioBytes.length} bytes`);
  return audioBytes;
}

async function createTestPixelMap(): Promise<PixelMap> {
  let context = getContext();
  const resourceMgr = context.resourceManager;
  const imageRawFile = await resourceMgr.getRawFileContent('eve.png');
  const imageSource = image.createImageSource(imageRawFile.buffer);
  const decodingOptions: image.DecodingOptions = {
    editable: false,
    desiredPixelFormat: image.PixelMapFormat.RGBA_8888
  };
  return imageSource.createPixelMapSync(decodingOptions);
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

    return true;
  }
}

export default function fileAssetTest() {
  describe('FileAssetTest', () => {
    beforeAll(() => {
      rive.Napi_Rive_cppRegisterClass(FileAsset);
      rive.Napi_Rive_cppRegisterClass(ImageAsset);
      rive.Napi_Rive_cppRegisterClass(FontAsset);
      rive.Napi_Rive_cppRegisterClass(AudioAsset);
    })

    it('FileAsset_cppDecode_Test', 0, async (done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      let imageBytes = await loadImageRawFile()
      const renderImagePtr = rive.Napi_RiveRenderImage_cppCreateFromRGBABytes(
        imageBytes,
        10,
        10,
        rive.RendererType.Rive,
        true
      );
      expect(renderImagePtr).not().assertEqual(0);

      rive.Napi_RiveRenderImage_cppDelete(renderImagePtr);
      done();
    })

    it('RiveRenderImage_cppCreateFromARGBInts_Test', 0, (done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'RiveRenderImage_cppCreateFromARGBInts_Test begin');

      const width = 2;
      const height = 2;
      const pixels = new Uint32Array([0xFFFF0000, 0xFF00FF00, 0xFF0000FF, 0xFFFFFFFF]);

      const renderImagePtr = rive.Napi_RiveRenderImage_cppCreateFromARGBInts(
        pixels,
        width,
        height,
        rive.RendererType.Rive,
        false
      );
      expect(renderImagePtr).not().assertEqual(0);

      rive.Napi_RiveRenderImage_cppDelete(renderImagePtr);
      done();
    });

    it('RiveRenderImage_cppCreateFromBitmap_Test', 0, async(done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'RiveRenderImage_cppCreateFromBitmap_Test begin');

      let pixelMap = await createTestPixelMap();
      const renderImagePtr = rive.Napi_RiveRenderImage_cppCreateFromBitmap(
        pixelMap,
        rive.RendererType.Rive,
        true
      );
      expect(renderImagePtr).not().assertEqual(0);

      rive.Napi_RiveRenderImage_cppDelete(renderImagePtr);
      done();
    });

    it('RiveFont_Companion_cppMakeFont_Test', 0, async(done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'RiveFont_Companion_cppMakeFont_Test begin');

      let fontBytes = await loadFontRawFile();
      const fontPtr = rive.Napi_RiveFont_00024Companion_cppMakeFont(
        fontBytes,
        rive.RendererType.Rive
      );
      expect(fontPtr).not().assertEqual(0);

      rive.Napi_RiveFont_cppDelete(fontPtr);
      done();
    });

    it('RiveAudio_Companion_cppMakeAudio_Test', 0, async(done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'RiveAudio_Companion_cppMakeAudio_Test begin');

      let audioBytes = await loadAudioRawFile();
      const audioPtr = rive.Napi_RiveAudio_00024Companion_cppMakeAudio(
        audioBytes,
        rive.RendererType.Rive
      );
      expect(audioPtr).not().assertEqual(0);

      rive.Napi_RiveAudio_cppDelete(audioPtr);
      done();

    });
  })
}