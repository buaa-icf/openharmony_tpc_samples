// Core enums & primitives
export { Loop } from './src/main/ets/runtime/core/Loop';
export { Direction } from './src/main/ets/runtime/core/Direction';
export { Alignment } from './src/main/ets/runtime/core/Alignment';
export { Fit } from './src/main/ets/runtime/core/Fit';
export { AdvanceResult } from './src/main/ets/runtime/core/AdvanceResult';
export { EventType } from './src/main/ets/runtime/core/EventType';

// Runtime view & init
export { RiveAnimationView } from './src/main/ets/runtime/RiveAnimationView';
export { initializeRive } from './src/main/ets/rive/RiveInitializer';

// Controller & events
export {
  RiveFileControllerListener,
  RiveEventListener,
  ControllerState,
  PointerEvents,
} from './src/main/ets/runtime/controllers/RiveFileController';

// Assets
export {
  FileAsset,
  AudioAsset,
  FontAsset,
  ImageAsset,
  RiveRenderImage,
  RiveAudio,
  RiveFont,
} from './src/main/ets/runtime/core/FileAsset';
export {
  FileAssetLoader,
  ContextAssetLoader,
  FallbackAssetLoader,
  CDNAssetLoader,
} from './src/main/ets/runtime/core/FileAssetLoader';
export { File } from './src/main/ets/runtime/core/File';

// Renderer
export { RendererType } from './src/main/ets/runtime/renderers/RendererType';
export { RiveArtboardRenderer } from './src/main/ets/runtime/renderers/RiveArtboardRenderer';
export { RendererAttributes } from './src/main/ets/runtime/renderers/RendererAttributes';
export { Renderer } from './src/main/ets/runtime/renderers/Renderer';
export { RectF } from './src/main/ets/runtime/renderers/RectF';

// Animation & state machine
export { default as LinearAnimationInstance } from './src/main/ets/runtime/core/LinearAnimationInstance';
export { StateMachineInstance } from './src/main/ets/runtime/core/StateMachineInstance';
export { PlayableInstance } from './src/main/ets/runtime/core/PlayableInstance';
export { SMIBoolean } from './src/main/ets/runtime/core/SMIBoolean';
export { SMINumber } from './src/main/ets/runtime/core/SMINumber';
export { SMITrigger } from './src/main/ets/runtime/core/SMITrigger';
export { SMIInput } from './src/main/ets/runtime/core/SMIInput';
export { Artboard } from './src/main/ets/runtime/core/Artboard';
export { BindableArtboard } from './src/main/ets/runtime/core/BindableArtboard';
export { RiveManager } from './src/main/ets/runtime/core/Rive';

// ViewModel
export { ViewModel } from './src/main/ets/runtime/core/ViewModel';
export { ViewModelInstance } from './src/main/ets/runtime/core/ViewModelInstance';
export {
  ViewModelBooleanProperty,
  ViewModelColorProperty,
  ViewModelEnumProperty,
  ViewModelNumberProperty,
  ViewModelStringProperty,
  ViewModelTriggerProperty,
  ViewModelImageProperty,
  ViewModelListProperty,
  ViewModelArtboardProperty,
} from './src/main/ets/runtime/core/ViewModelInstance';

// Events
export { RiveEvent } from './src/main/ets/runtime/core/RiveEvent';
export { RiveGeneralEvent } from './src/main/ets/runtime/core/RiveGeneralEvent';
export { RiveOpenURLEvent } from './src/main/ets/runtime/core/RiveOpenURLEvent';
export { RiveEventReport } from './src/main/ets/runtime/core/RiveEventReport';
export { RiveTextValueRun } from './src/main/ets/runtime/core/RiveTextValueRun';

// Exceptions
export { AnimationException } from './src/main/ets/runtime/core/errors/AnimationException';
export { ArtboardException } from './src/main/ets/runtime/core/errors/ArtboardException';
export { MalformedFileException } from './src/main/ets/runtime/core/errors/MalformedFileException';
export { RiveException } from './src/main/ets/runtime/core/errors/RiveException';
export { StateMachineException } from './src/main/ets/runtime/core/errors/StateMachineException';
export { StateMachineInputException } from './src/main/ets/runtime/core/errors/StateMachineInputException';
export { TextValueRunException } from './src/main/ets/runtime/core/errors/TextValueRunException';
export { UnsupportedRuntimeVersionException } from './src/main/ets/runtime/core/errors/UnsupportedRuntimeVersionException';
export { ViewModelException } from './src/main/ets/runtime/core/errors/ViewModelException';

// Fonts & helpers
export { FontFallbackStrategy, FontBytes } from './src/main/ets/runtime/fonts/FontFallbackStrategy';
export { FontHelper, FontOpts, NativeFontHelper, FileFont, Font, Weight } from './src/main/ets/runtime/fonts/FontHelpers';
export { Helpers, PointF } from './src/main/ets/runtime/core/Helpers';
export { ImageDecoder } from './src/main/ets/runtime/core/ImageDecoder';

// Tests (keep existing exports)
export { test_file_asset_loader } from './src/main/ets/test/test_file_asset_loader';
export {
  test_file_import,
  test_ArtboardByName_withValidName,
  test_ArtboardCount_ValidFile,
  test_Artboard_ByIndexValid,
  test_ArtboardName_ValidIndex,
  test_CreateDefault_BindableArtboard,
  test_CreateBindableArtboard_ByName,
  test_ViewModel_Count,
  test_ViewModel_ByIndex,
  test_ViewModel_ByName,
} from './src/main/ets/test/test_file';
