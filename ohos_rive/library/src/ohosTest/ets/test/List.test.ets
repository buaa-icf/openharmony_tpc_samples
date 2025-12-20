import abilityTest from './Ability.test';
import bindingsLayerStateTest from './BindingsLayerState.test';
import convertToArtboardSpaceTest from './BindingsHelperAbility.test';
import stateMachineTest from './StateMachine.test';
import smiInputTest from './SMIInput.test';
import artboardTest from './Artboard.test';
import viewModelTest from './ViewModel.test';
import viewModelInstanceTest from './ViewModelInstance.test';
import linearAnimationInstanceTest from './LinearAnimationInstance.test';
import textValueRunTest from './TextValueRun.test';
import riveEventTest from './RiveEvent.test';
import commandQueueTest from './CommandQueue.test';
import riveFileTest from './File.test';
import fileAssetTest from './FileAsset.test';

export default function testsuite() {
  abilityTest();
  bindingsLayerStateTest();
  convertToArtboardSpaceTest();
  stateMachineTest();
  smiInputTest()
  artboardTest();
  viewModelTest();
  viewModelInstanceTest();
  linearAnimationInstanceTest();
  textValueRunTest();
  riveEventTest();
  commandQueueTest();
  riveFileTest();
  fileAssetTest();
}