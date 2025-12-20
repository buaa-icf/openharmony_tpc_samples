import rive from 'libohos_rive.so';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { FallbackAssetLoader } from '../runtime/core/FileAssetLoader';

export function test_file_asset_loader() {
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let context = abilityDelegator.getAppContext();
  let fileAssetLoader: FallbackAssetLoader = new FallbackAssetLoader(context, true, null);
  rive.Napi_FileAssetLoader_cppRef(fileAssetLoader.getNativePtr());
  rive.Napi_FileAssetLoader_cppSetRendererType(fileAssetLoader.getNativePtr(), rive.RendererType.Rive);
  rive.Napi_FileAssetLoader_cppDelete(fileAssetLoader.getNativePtr());
}